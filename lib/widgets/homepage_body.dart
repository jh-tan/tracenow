import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/services/ble_trace.dart';
import 'package:tracenow/services/firebase_auth.dart';
import 'package:tracenow/services/firebase_db.dart';
import 'package:tracenow/widgets/category_menu_list.dart';
import 'package:tracenow/widgets/dialog_box.dart';
import 'package:tracenow/widgets/homepage_appbar.dart';
import 'package:tracenow/widgets/snackbar.dart';
import 'package:tracenow/widgets/text_input_dialog.dart';

import '../services/notification_service.dart';

class HomepageBody extends StatefulWidget {
  const HomepageBody({Key? key}) : super(key: key);

  @override
  _HomepageBodyState createState() => _HomepageBodyState();
}

class _HomepageBodyState extends State<HomepageBody> {
  String userID = '', userStatus = '', name = '';
  Color? iconColor = Colors.black, bgColor = Colors.red;
  String text = "The tracer is not activated";
  bool servicesIsRunning = false;
  final TracingServices tracingServices = TracingServices();
  final String documentID = FirebaseAuthentication().getCurrentUserID();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          HomepageAppBar(
            UserID: userID,
            UserStatus: userStatus,
            userName: name,
          ),
          SizedBox(height: 5.h),
          Expanded(
              child: Container(
            width: 100.w,
            decoration: const BoxDecoration(
                color: Color(0xFF2196F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                )),
            child: ListView(
              children: [
                SizedBox(height: 2.h),
                Row(children: [
                  Container(
                      margin: EdgeInsets.only(left: 5.w),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.bluetooth_outlined),
                        iconSize: 13.w,
                        color: iconColor,
                        onPressed: () async {
                          if (servicesIsRunning) {
                            tracingServices.stopService();
                            _stateChange();
                          } else {
                            String status = await tracingServices.checkStatus();
                            if (status != "True") {
                              GlobalSnackBar().show(context, status);
                            } else {
                              tracingServices.startService(userID);
                              _stateChange();
                            }
                          }
                        },
                      )),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Text(text, style: TextStyle(fontSize: 14.sp)),
                    ),
                    ValueListenableBuilder(
                        valueListenable: tracingServices.getDevicesNum(),
                        builder: (context, value, widget) {
                          if (tracingServices.getContactList().length > 1) {
                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text(
                                  '${tracingServices.getContactList().length} persons interacted',
                                  style: TextStyle(fontSize: 14.sp),
                                ));
                          } else {
                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text(
                                  '${tracingServices.getContactList().length} person interacted',
                                  style: TextStyle(fontSize: 14.sp),
                                ));
                          }
                        }),
                  ]))
                ]),
                SizedBox(height: 5.h),
                Center(
                  child: GestureDetector(
                    child: const CategoryMenu(
                      title: 'Self Report',
                      icon: Icons.report,
                    ),
                    onTap: () {
                      GlobalDialogBox().show(
                          context,
                          'By clicking agree, you assure that your report is true',
                          FirebaseDatabase().updateReportStatus);
                    },
                  ),
                ),
                SizedBox(height: 5.h),
                Center(
                  child: GestureDetector(
                    child: const CategoryMenu(
                      title: 'Upload Log',
                      icon: Icons.upload_file_outlined,
                    ),
                    onTap: () async {
                      GlobalTextBox().show(context);
                    },
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString min $secondsString sec';
  }

  String _calculateRisk(int seconds) {
    if (seconds <= 900) {
      return "Low Risk";
    } else if (seconds <= 1800) {
      return "Middle Risk";
    } else {
      return "High Risk";
    }
  }

  Future init() async {
    CollectionReference users = FirebaseDatabase().getCollection();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    users.doc(documentID).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> currentUser = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userID = currentUser["uuid"];
          userStatus = currentUser["healthStatus"];
          name = currentUser["name"];
        });
      }
    });

    Query<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.collectionGroup('encounterUser');
    reference.snapshots().listen((querySnapshot) {
      int? closeTime = preferences.getInt('lastNotification');
      querySnapshot.docChanges.forEach((element) async {
        if (element.doc['uuid'].toString().replaceAll('-', '') == userID &&
            element.doc['timestamp'] > (closeTime ?? 0)) {
          NotificationServices().showNotification(
              'COVID - 19 ATTENTION',
              'One of the person that you contacted with has turned positive\nContact Duration : ${_formatDuration(element.doc['duration'])}',
              '');

          String risk = _calculateRisk(element.doc['duration']);

          if (risk == "High Risk" && userStatus != "Covid" && userStatus != "High Risk") {
            FirebaseDatabase().updateStatus(documentID, risk);
            preferences.setString('status', risk);
            setState(() {
              userStatus = risk;
            });
          } else if (risk == "Medium Risk" && userStatus != "High Risk" && userStatus != "Covid") {
            FirebaseDatabase().updateStatus(documentID, risk);
            preferences.setString('status', risk);
            setState(() {
              userStatus = risk;
            });
          } else if (risk == "Low Risk" && userStatus == "Healthy") {
            FirebaseDatabase().updateStatus(documentID, risk);
            preferences.setString('status', risk);
            setState(() {
              userStatus = risk;
            });
          }
          preferences.setInt('lastNotification', element.doc['timestamp'] + 1000);
        }
      });
    });
  }

  void _stateChange() async {
    servicesIsRunning = await tracingServices.isRunning();

    setState(() {
      bgColor = servicesIsRunning ? Colors.green : Colors.red;
      iconColor = servicesIsRunning ? Colors.white : Colors.black;
      text = servicesIsRunning ? "The tracer is running" : "The tracer is not activated";
    });
  }
}

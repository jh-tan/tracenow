import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/services/ble_trace.dart';
import 'package:tracenow/services/firebase_auth.dart';
import 'package:tracenow/services/firebase_db.dart';
import 'package:tracenow/widgets/category_menu_list.dart';
import 'package:tracenow/widgets/homepage_appbar.dart';
import 'package:tracenow/widgets/snackbar.dart';

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

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              children: [
                SizedBox(height: 5.h),
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
                    onTap: () {},
                  ),
                ),
                SizedBox(height: 5.h),
                Center(
                  child: GestureDetector(
                    child: const CategoryMenu(
                      title: 'Upload Log',
                      icon: Icons.upload_file_outlined,
                    ),
                    onTap: () {},
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Future getUserID() async {
    final String documentID = FirebaseAuthentication().getCurrentUserID();
    CollectionReference users = FirebaseDatabase().getCollection();
    // final SharedPreferences preferences = await SharedPreferences.getInstance();
    users.doc(documentID).snapshots().listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        // if (preferences.getString('UUID') == null) {
        //   preferences.setString('UUID', data["UUID"]);
        //   preferences.setString('status', data["health_status"]);
        // }
        // if (data["health_status"] == "Healthy") {
        //   preferences.setString('status', data["health_status"]);
        // }

        setState(() {
          userID = data["uuid"];
          userStatus = data["healthStatus"];
          name = data["name"];
        });
      }
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

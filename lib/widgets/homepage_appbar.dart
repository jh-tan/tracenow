import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/models/arguments.dart';
import 'package:tracenow/screens/history.dart';
import 'package:tracenow/services/firebase_auth.dart';

class HomepageAppBar extends StatelessWidget {
  final String? UserID;
  final String? UserStatus;
  final String? userName;
  const HomepageAppBar({Key? key, this.UserID = '', this.UserStatus = '', this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                margin: const EdgeInsets.only(top: 40.0, right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  color: Colors.black,
                  iconSize: 28.0,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // dismiss dialog
                                    },
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      FirebaseAuthentication().signOut();
                                      Navigator.pushReplacementNamed(context, 'Login');
                                    },
                                    child: const Text('Confirmed'))
                              ],
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ));
                  },
                )),
            Container(
                margin: const EdgeInsets.only(top: 40.0, right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none),
                  color: Colors.black,
                  iconSize: 28.0,
                  onPressed: () {
                    // Navigator.pushNamed(context, 'History');
                    Navigator.pushNamed(context, History.routeName,
                        arguments: UUIDArguments(UserID!));
                  },
                )),
          ]),
          SizedBox(
            height: (0.3).h,
          ),
          Center(
            child: Text(
              userName!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(
            height: (0.3).h,
          ),
          Center(
            child: Text(
              UserID!,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(
            height: (0.3).h,
          ),
          Center(
            child: Text(
              UserStatus!,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

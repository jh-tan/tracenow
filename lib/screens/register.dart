import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/configs/size_config.dart';
import 'package:tracenow/services/firebase_db.dart';
import 'package:tracenow/widgets/onboard_body.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.phoneNumber, required this.userID}) : super(key: key);

  final String phoneNumber;
  final String userID;
  static const routeName = '/RegisterUser';
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              "Please insert your name",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 40,
              width: 95.w,
              child: CupertinoTextField(
                // padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(width: 0.5.w, color: Colors.black),
                )),
                controller: textController,
                clearButtonMode: OverlayVisibilityMode.editing,
                keyboardType: TextInputType.text,
                maxLines: 1,
                placeholder: 'Enter your name here',
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 95.w,
                  height: SizeConfig().getProportionalScreenHeight(60),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (textController.text.isNotEmpty) {
                        FirebaseDatabase().registerUser(
                            widget.userID.toString(), textController.text.toString(), widget.phoneNumber.toString());
                        Navigator.pushReplacementNamed(context, 'HomePage');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Finish",
                          style: TextStyle(
                              fontSize: SizeConfig().getProportionalScreenWidth(18),
                              color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            color: Colors.lightBlue[100],
                          ),
                          child: const Icon(Icons.arrow_forward_ios),
                        )
                      ],
                    ),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.blue),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1.h,
            )
          ],
        ),
        backgroundColor: Colors.white);
  }
}

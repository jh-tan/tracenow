import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/configs/size_config.dart';
import 'package:tracenow/services/firebase_db.dart';
import 'package:tracenow/widgets/onboard_body.dart';
import 'package:tracenow/widgets/snackbar.dart';

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
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "Name: ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 95.w,
                  child: CupertinoTextField(
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
                SizedBox(height: 5.h),
                Text(
                  "NRIC",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 95.w,
                  child: CupertinoTextField(
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 0.5.w, color: Colors.black),
                    )),
                    controller: numberController,

                    clearButtonMode: OverlayVisibilityMode.editing,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    maxLength: 12,
                    placeholder: 'Enter your nric here, without the \'-\'',
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
                          RegExp nricVallidation =
                              RegExp(r'\d{2}(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[0-1])\d{2}\d{4}');
                          bool isValidate = nricVallidation.hasMatch(numberController.text);
                          if (textController.text.isNotEmpty && isValidate) {
                            FirebaseDatabase().registerUser(
                                widget.userID.toString(),
                                textController.text.toString(),
                                numberController.text,
                                widget.phoneNumber.toString());
                            Navigator.pushReplacementNamed(context, 'HomePage');
                          } else if (textController.text.isEmpty || numberController.text.isEmpty) {
                            GlobalSnackBar().show(context, "Please do not leave any field blank");
                          } else if (!isValidate) {
                            GlobalSnackBar().show(context, "Invalid NRIC");
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
                  height: 3.h,
                )
              ],
            )),
        backgroundColor: Colors.white);
  }
}

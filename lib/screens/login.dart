import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/configs/size_config.dart';
import 'package:tracenow/models/arguments.dart';
import 'package:tracenow/screens/otp.dart';
import 'package:tracenow/widgets/snackbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig().getScreenHeight(),
          child: Column(children: [
            Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 240,
                                constraints: const BoxConstraints(maxWidth: 500),
                                margin: const EdgeInsets.only(top: 70),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFE1E0F5),
                                    borderRadius: BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                            Center(
                              child: Container(
                                  constraints: const BoxConstraints(maxHeight: 340),
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Image.asset('assets/onboard_privacy.png')),
                            ),
                          ],
                        )),
                    SizedBox(height: 5.h),
                    Column(children: [
                      Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'We will send you an ',
                                  style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                              TextSpan(
                                  text: 'One Time Password ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp)),
                              TextSpan(
                                  text: 'on this mobile number',
                                  style: TextStyle(color: Colors.black, fontSize: 14.sp)),
                            ]),
                          ))
                    ]),
                    Container(
                      height: 40,
                      constraints: const BoxConstraints(maxWidth: 500),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(width: 0.5.w, color: Colors.black),
                        )),
                        controller: phoneController,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        placeholder: '+60...',
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
                              // \+60\d{2}-\d{7}
                              // final phoneFormat = RegExp(r'01');
                              if (phoneController.text.isNotEmpty) {
                                Navigator.pushReplacementNamed(context, OTPScreen.routeName,
                                    arguments: PhoneArguments(phoneController.text.toString()));
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Next",
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
                    SizedBox(height: 2.h,)
                  ],
                ))
          ]),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

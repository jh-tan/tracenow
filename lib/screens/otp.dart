import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/services/firebase_auth.dart';
import 'package:tracenow/widgets/otp_pin_input.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);
  final String phoneNumber;
  static const routeName = '/OTPScreen';

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _verificationCode = '';
  int? _resentToken;
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) { });
  int _start = 60;

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.blueGrey[50],
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue[300],
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, 'Login'),
        ),
      ),
      body: SafeArea(
          child: _verificationCode != ''
              ? Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "Verification",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Enter the code sent to the number",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      widget.phoneNumber,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    PinInput(phoneNumber: widget.phoneNumber, verificationCode: _verificationCode),
                    _start != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Resend Code in",
                                style: TextStyle(fontSize: 12.sp, color: Colors.lightBlue),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                _start.toString(),
                                style: TextStyle(fontSize: 12.sp, color: Colors.black),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                "Didn't receive the code?",
                                style: TextStyle(fontSize: 12.sp, color: Colors.lightBlue),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _resentOTP();
                                  },
                                  child: Text(
                                    "Resend",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.lightBlue,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ],
                          )
                  ],
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }

  _verifyPhone() async {
    await FirebaseAuthentication().getAuthInstance().verifyPhoneNumber(
        phoneNumber: '+60${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          debugPrint(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          startTimer();
          setState(() {
            _verificationCode = verificationID;
            _resentToken = resendToken;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: const Duration(seconds: 60));
  }

  _resentOTP() async {
    await FirebaseAuthentication().getAuthInstance().verifyPhoneNumber(
        phoneNumber: '+60${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          debugPrint(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          _start = 60;
          startTimer();
          setState(() {
            _verificationCode = verificationID;
          });
        },
        forceResendingToken: _resentToken,
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: const Duration(seconds: 60));
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}

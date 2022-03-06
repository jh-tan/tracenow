import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:tracenow/models/arguments.dart';
import 'package:tracenow/screens/register.dart';
import 'package:tracenow/services/firebase_auth.dart';
import 'package:tracenow/services/firebase_db.dart';
import 'package:tracenow/widgets/snackbar.dart';

class PinInput extends StatefulWidget {
  final String verificationCode;
  final String phoneNumber;
  const PinInput({Key? key, required this.verificationCode, required this.phoneNumber})
      : super(key: key);

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  final TextEditingController _pinPutController = TextEditingController();

  final FocusNode _pinPutFocusNode = FocusNode();

  @override
  void dispose() {
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      child: Pinput(
          length: 6,
          onCompleted: (String pin) async {
            User? user =
                await FirebaseAuthentication().loginWithPhone(widget.verificationCode, pin);
            if (user == null) {
              FocusScope.of(context).unfocus();
              _pinPutController.text = "";
              GlobalSnackBar().show(context, "Invalid Pin Number");
            } else if (await FirebaseDatabase().isExist(user.uid)) {
              Navigator.pushReplacementNamed(context, 'HomePage');
            } else {
              Navigator.pushReplacementNamed(context, Register.routeName,
                  arguments: UserArguments(user.uid, widget.phoneNumber));
            }
          },
          focusNode: _pinPutFocusNode,
          controller: _pinPutController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme),
    );
  }

  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 104, 176, 235)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
    borderRadius: BorderRadius.circular(8),
  );

  final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: const Color.fromRGBO(234, 239, 243, 1),
    ),
  );
}

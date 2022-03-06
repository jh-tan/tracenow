import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GlobalSnackBar {
  void show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: SizedBox(
          height: 5.h,
          child: Center(
            child: Text(
              message,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ));
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tracenow/configs/size_config.dart';

class OnBoardContent extends StatelessWidget {
  final String? title;
  final String? text;
  final String? image;
  const OnBoardContent({
    Key? key,
    required this.title,
    required this.text,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          title!,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp),
        ),
        const Spacer(
          flex: 2,
        ),
        Image.asset(
          image!,
        )
      ],
    );
  }
}

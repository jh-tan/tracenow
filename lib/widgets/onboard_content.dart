import 'package:flutter/material.dart';
import 'package:tracenow/configs/size_config.dart';

class OnBoardContent extends StatelessWidget {
  final String? text;
  final String? image;
  const OnBoardContent({
    Key? key, required this.text, required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          'This is Title',
          style: TextStyle(
              fontSize: SizeConfig().getProportionalScreenWidth(36),
              fontWeight: FontWeight.bold),
        ),
        Text(text!),
        const Spacer(
          flex: 2,
        ),
        Image.asset(
          image!,
          // height: SizeConfig().getProportionalScreenHeight(265),
          // width: SizeConfig().getProportionalScreenWidth(235),
        )
      ],
    );
  }
}

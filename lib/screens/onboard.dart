import 'package:flutter/material.dart';
import 'package:tracenow/configs/size_config.dart';
import 'package:tracenow/widgets/onboard_body.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: OnBoardBody(),
      backgroundColor: Colors.white
    );
  }
}

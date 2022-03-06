import 'package:flutter/material.dart';
import 'package:tracenow/widgets/homepage_body.dart';


class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomepageBody(),
      backgroundColor: Colors.white
    );
  }
}

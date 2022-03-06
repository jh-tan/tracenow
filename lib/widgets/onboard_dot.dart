import 'package:flutter/material.dart';

class OnBoardDot extends StatelessWidget {
  final int? index;
  final int current;
  const OnBoardDot({
    Key? key,
    required this.index, required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: current == index ? 20 : 6,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(3),
      ),
      duration: const Duration(milliseconds: 200),
    );
  }
}

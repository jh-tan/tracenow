import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({Key? key, required this.title, required this.icon, this.color = Colors.white})
      : super(key: key);

  final String title;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.h,
      width: 90.w,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Icon(icon),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 22),
                        ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

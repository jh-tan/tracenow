import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? _screenWidth;
  static double? _screenHeight;
  static double? _defaultSize;
  static Orientation? _orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData!.size.width;
    _screenHeight = _mediaQueryData!.size.height;
    _orientation = _mediaQueryData!.orientation;
  }

  double getProportionalScreenHeight(double inputHeight) {
    return (inputHeight / 812.0) * _screenHeight!;
  }

  double getProportionalScreenWidth(double inputWidth) {
    return (inputWidth / 375.0) * _screenWidth!;
  }

  double? getScreenWidth() {
    return _screenWidth;
  }

  double? getScreenHeight() {
    return _screenHeight;
  }
}

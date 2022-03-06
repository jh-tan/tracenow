import 'package:flutter/material.dart';
import 'package:tracenow/screens/homepage.dart';
import 'package:tracenow/models/arguments.dart';
import 'package:tracenow/screens/login.dart';
// import 'package:tracenow/screens/history.dart';
import 'package:tracenow/screens/onboard.dart';
import 'package:tracenow/screens/otp.dart';
import 'package:tracenow/screens/register.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      'HomePage': (_) => const Homepage(),
      'Login': (_) => const Login(),
      'OnBoard': (_) => const OnBoard(),
      // 'History': (_) => const History(),
    };
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/OTPScreen":
        final args = settings.arguments as PhoneArguments;
        return MaterialPageRoute(
            builder: (_) => OTPScreen(
                  phoneNumber: args.phoneNumber,
                ));
      case "/RegisterUser":
        final args = settings.arguments as UserArguments;
        return MaterialPageRoute(
            builder: (_) => Register(
                  phoneNumber: args.phoneNumber,
                  userID: args.userID,
                ));
      default:
        assert(false, 'Need to implement ${settings.name}');
        return null;
    }
  }
}

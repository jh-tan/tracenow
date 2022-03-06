import 'package:firebase_auth/firebase_auth.dart';

class PhoneArguments {
  final String phoneNumber;
  PhoneArguments(this.phoneNumber);
}

class UserArguments {
  final String userID;
  final String phoneNumber;

  UserArguments(this.userID,this.phoneNumber);
}

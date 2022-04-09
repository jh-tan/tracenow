import 'dart:math';

class User {
  final String uuid;
  final String name;
  final String nric;
  final String phoneNo;
  final bool reportStatus;
  final healthStatus;
  final generatedCode;

  User(
      {required this.name,
      required this.phoneNo,
      required this.nric,
      this.uuid = '',
      this.reportStatus = false,
      this.healthStatus = "Healthy",
      this.generatedCode = ""});

  Map<String, dynamic> toMap() {
    return {
      'uuid': getRandomString(),
      'name': name,
      'nric': nric,
      'phoneNo': "+6" + phoneNo,
      'reportStatus': false,
      'healthStatus': "Healthy",
      'generatedCode': ""
    };
  }

  @override
  String toString() {
    return 'User{uuid: $uuid, name: $name, phoneNumber: $phoneNo}';
  }

  String getRandomString() {
    const _chars = '0123456789ABCDEF';
    Random _rnd = Random();

    return String.fromCharCodes(
        Iterable.generate(32, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}

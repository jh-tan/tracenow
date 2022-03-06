import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> loginWithPhone(String verificationCode, String pin) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: pin);
    try {
      await _firebaseAuth.signInWithCredential(credential);
      User? user = _firebaseAuth.currentUser;
      return user;
    } catch (e) {
      return null;
    }
  }

  bool isLogin() {
    return _firebaseAuth.currentUser != null;
  }

  String getCurrentUserID() {
    return _firebaseAuth.currentUser!.uid.toString();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  FirebaseAuth getAuthInstance() {
    return _firebaseAuth;
  }
}

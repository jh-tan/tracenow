// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracenow/models/info.dart';
import 'package:tracenow/models/user.dart';
import 'package:tracenow/services/db.dart';
import 'package:tracenow/services/firebase_auth.dart';

class FirebaseDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('Users');
  final CollectionReference _encounterUserCollection =
      FirebaseFirestore.instance.collection('encounterUser');
  final DatabaseHelper db = DatabaseHelper.instance;

  Future<void> registerUser(String uid, String name, String phoneNo) async {
    _userCollection.doc(uid).set(User(name: name, phoneNo: phoneNo).toMap());
  }

  Future<bool> isExist(String uid) async {
    DocumentSnapshot snapshot = await _userCollection.doc(uid).get();
    if (snapshot.exists) return true;
    return false;
  }

  CollectionReference getCollection() {
    return _userCollection;
  }

  Future<bool> _isVerify(String inputCode) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('Users')
        .where('phoneNo', isEqualTo: FirebaseAuthentication().getCurrentUserPhoneNo())
        .where('generatedCode', isEqualTo: inputCode)
        .get();

    if (snapshot.size != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> uploadLog(String code) async {
    String userID = FirebaseAuthentication().getCurrentUserID();
    bool isVerified = await _isVerify(code);
    List<Info> encounterLog = await db.getAllCompiled();
    if (!isVerified) {
      return "Invalid Code!";
    }

    if (encounterLog.isEmpty) {
      return "No encounter log in the device";
    } else {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      encounterLog.forEach((log) async {
        batch.set(_userCollection.doc(userID).collection("encounterUser").doc(), log.toUploadMap());
      });

      _userCollection.doc(userID).update({'healthStatus': 'Covid Positive '});
      batch.commit();
      return "Log uploaded";
    }
  }

  Future<void> updateReportStatus() {
    String userID = FirebaseAuthentication().getCurrentUserID();
    return _userCollection
        .doc(userID)
        .update({'reportStatus': true})
        .then((value) => "User Updated")
        .catchError((error) => "Failed to update user: $error");
  }
}

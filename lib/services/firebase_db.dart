import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracenow/models/user.dart';

class FirebaseDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _collection = FirebaseFirestore.instance.collection('Users');

  Future<void> registerUser(String uid, String name, String phoneNo) async {
    _collection.doc(uid).set(User(name: name, phoneNo: phoneNo).toMap());
  }

  Future<bool> isExist(String uid) async {
    DocumentSnapshot snapshot = await _collection.doc(uid).get();
    if (snapshot.exists) return true;
    return false;
  }

  CollectionReference getCollection() {
    return _collection;
  }
}

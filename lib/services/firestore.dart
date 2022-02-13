import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String token) async {
    await _users.doc(token).set({
      'name': name,
      'highScore': 0,
      'highScoreDate': '',
      'highScoreTime': 0,
      'highScoreDimension': 0,
    });

  }

  // Future<void> updateUser(String name, String email, String password) async {
  //   await _collectionReference.doc(name).update({
  //     'name': name,
  //     'email': email,
  //     'password': password,
  //   });
  // }

  Future<void> deleteUser(String name) async {
    await _users.doc(name).delete();
  }

  Future<QuerySnapshot> getUsers() async {
    return await _users.get();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String email, String password) async {
    await _collectionReference.doc(name).set({
      'name': name,
      'email': email,
      'password': password,
    });

  }

  Future<void> updateUser(String name, String email, String password) async {
    await _collectionReference.doc(name).update({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<void> deleteUser(String name) async {
    await _collectionReference.doc(name).delete();
  }

  Future<QuerySnapshot> getUsers() async {
    return await _collectionReference.get();
  }
}
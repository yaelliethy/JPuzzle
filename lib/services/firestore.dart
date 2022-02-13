import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jpuzzle/models/Game.dart';
import 'package:jpuzzle/models/User.dart';
class FirestoreProvider {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<User> addUser(String name, String token) async {
    final DocumentSnapshot result = await _users.doc(token).get();
    //If the user doesn't exist, add it to the database
    if (!result.exists) {
      await _users.doc(token).set({
        'name': name,
        'highScore': 0,
        'highScoreDate': '',
        'highScoreTime': 0,
        'highScoreDimension': 0,
      });
    }
    return await getUser(token);
  }

  // Future<void> updateUser(String name, String email, String password) async {
  //   await _collectionReference.doc(name).update({
  //     'name': name,
  //     'email': email,
  //     'password': password,
  //   });
  // }
  Future<QuerySnapshot> getUsers() async {
    return await _users.get();
  }
  //Get user by token
  Future<User> getUser(String token) async {
    Map<String, dynamic> data = (await _users.doc(token).get()).data() as Map<String, dynamic>;
    return User.fromJson(data, token);
  }
  //Add game to user from a Game object
  Future<void> addGame(User user, Game game) async {
    await _users.doc(user.token).update({
      'highScore': game.score,
      'highScoreDate': game.date,
      'highScoreTime': game.time,
      'highScoreDimension': game.dimension,
    });
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jpuzzle/models/Game.dart';
import 'package:jpuzzle/models/User.dart';
class FirestoreProvider {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<User> addUser(String name, String email, String profilePicUrl) async {
    final DocumentSnapshot result = await _users.doc(email).get();
    //If the user doesn't exist, add it to the database
    if (!result.exists) {
      await _users.doc(email).set({
        'name': name,
        'highScore': 0,
        'highScoreDate': '',
        'highScoreTime': 0,
        'highScoreDimension': 0,
        'email': email,
        'Games':{},
        'profilePicUrl': profilePicUrl,
      });
    }
    return await getUser(email);
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
  Future<User> getUser(String email) async {
    Map<String, dynamic> data = (await _users.doc(email).get()).data() as Map<String, dynamic>;
    return User.fromJson(data);
  }
  //Add game to user from a Game object
  Future<void> addGame(String email, Game game) async {
    User user=await getUser(email);
    if(game.score>user.highScore) {
      await _users.doc(user.email).update({
        'highScore': game.score,
        'highScoreDate': game.date,
        'highScoreTime': game.time,
        'highScoreDimension': game.dimension,
        'highScoreGame': game.toJson(),
      });
    }
    await _users.doc(user.email).update({"Games": FieldValue.arrayUnion([game.toJson()])});
  }
  Future<List<Game>> getGames(String email) async{
    Map<String, dynamic> data = (await _users.doc(email).get()).data() as Map<String, dynamic>;
    List<dynamic> games=data['Games'];
    List<Game> gameList=[];
    for (Map<String, dynamic> game in games){
      gameList.add(Game.fromJson(game));
    }
    return gameList;
  }
  Future<Map<User, Game>> getLeaders() async{
    Map<User, Game> leaders={};
    List<QueryDocumentSnapshot> data = (await _users.orderBy('highScore', descending: true).limit(100).get()).docs;
    for (QueryDocumentSnapshot snapshot in data){
      User user=User.fromJson(snapshot.data() as Map<String, dynamic>);
      leaders[user]=Game.fromJson((snapshot.data() as Map<String, dynamic>)['highScoreGame']);
    }
    return leaders;
  }
}
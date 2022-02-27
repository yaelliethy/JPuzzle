import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:jpuzzle/models/Game.dart';
import 'package:jpuzzle/services/firestore.dart';
import 'package:jpuzzle/views/game_history_item.dart';

class GameHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameHistoryState();
  }
}

class _GameHistoryState extends State<GameHistory> {
  late FirestoreProvider firestoreProvider;
  late Future<List<Game>> gamesFuture;
  late List<Game> games;
  late List<bool> expanded;
  @override
  void initState() {
    firestoreProvider = FirestoreProvider();
    gamesFuture =
        firestoreProvider.getGames(FirebaseAuth.instance.currentUser!.email!);
    gamesFuture.then((value) {
      games = value.reversed.toList();
      expanded = List.generate(games.length, (_) => false);
    });
    super.initState();
  }
  List<Widget> _buildGameHistoryItems() {
    List<Widget> items = [];
    for (int i=0; i<games.length; i++) {
      items.add(
        Container(
          width: 100,
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundImage: Image.network(FirebaseAuth.instance.currentUser!.photoURL!).image,
            ),
            title: Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    spreadRadius: 5.0,
                    offset: Offset(3.0, 3.0),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              (games[i].date).toString(),
              style: TextStyle(
                color: kOrange,
              ),
            ),
            trailing: Text(
              (games[i].score).toString(),
              style: TextStyle(
                color: kAccentColor,
              ),
            ),
            children: [
              _buildItem(i),
            ],
          ),
        )
      );
    }
    return items;
  }
  Widget _buildItem(int index) {
    Game game=games[index];
    return Container(
      height:
          ((100 - (game.dimension * 5)) * game.dimension.toDouble()) +
              108,
      child: GameHistoryItem(games: games, index: index),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width-50,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(
              horizontal: 100.0,
              vertical: 75.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
                    Center(
                      child: Text(
                        'History',
                        style: kHeaderStyle,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: gamesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width-50,
                            child: ListView(
                              children: _buildGameHistoryItems(),
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

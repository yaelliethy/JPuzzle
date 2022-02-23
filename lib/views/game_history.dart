import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    firestoreProvider = FirestoreProvider();
    gamesFuture =
        firestoreProvider.getGames(FirebaseAuth.instance.currentUser!.email!);
    gamesFuture.then((value) => games = value.reversed.toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  Game game = games[index];
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height:
                            ((100 - (game.dimension * 5)) * game.dimension.toDouble()) +
                                100,
                        child: GameHistoryItem(games: games, index: index),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container(
            color: Colors.yellow,
            height: 50,
            width: 50,
          );
        },
      ),
    );
  }
}

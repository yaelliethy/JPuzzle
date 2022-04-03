import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:jpuzzle/models/Game.dart';
import 'package:jpuzzle/services/firestore.dart';
import 'package:jpuzzle/views/game_history_item.dart';
import 'package:jpuzzle/models/User.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late FirestoreProvider firestoreProvider;
  late Future<Map<User, Game>> gamesFuture;
  List<Game> games = [];
  List<User> users = [];
  late List<bool> expanded;
  @override
  void initState() {
    firestoreProvider = FirestoreProvider();
    gamesFuture = firestoreProvider.getLeaders();
    gamesFuture.then((value) {
      users = value.keys.toList();
      games = value.values.toList();
      expanded = List.generate(games.length, (_) => false);
    });
    super.initState();
  }

  List<Widget> _buildGameHistoryItems() {
    List<Widget> items = [];
    for (int i = 0; i < games.length; i++) {
      items.add(Container(
        width: 100,
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundImage: Image.network(users[i].profilePicUrl).image,
          ),
          title: Text(
            users[i].name,
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
            (games[i].score).toString(),
            style: TextStyle(
              color: kOrange,
            ),
          ),
          trailing: Text(
            getPosition(i + 1),
            style: TextStyle(
              color: kAccentColor,
            ),
          ),
          children: [
            _buildItem(i),
          ],
        ),
      ));
    }
    return items;
  }

  //Get position name like 1st, 2nd, 3rd
  String getPosition(int position) {
    switch (position) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${position}th';
    }
  }

  Widget _buildItem(int index) {
    Game game = games[index];
    return Container(
      height: ((100 - (game.dimension * 5)) * game.dimension.toDouble()) + 108,
      child: GameHistoryItem(games: games, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
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
              ListTile(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                ),
                title: Text(
                  'Leaderboard',
                  style: kHeaderStyle,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: gamesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.hasData &&
                            _buildGameHistoryItems().length > 0) {
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: ListView(
                            children: _buildGameHistoryItems(),
                          ),
                        ),
                      );
                    }
                    else if (_buildGameHistoryItems().length == 0) {
                      print('No Game History Items');
                      return Center(
                        child: Lottie.network(
                          'https://assets1.lottiefiles.com/packages/lf20_roylwd7o.json',
                        ),
                      );
                    }
                    return Center(
                      child: Lottie.network(
                        'https://assets1.lottiefiles.com/packages/lf20_roylwd7o.json',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

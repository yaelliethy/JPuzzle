import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jpuzzle/Base/Base.dart';
import 'package:jpuzzle/Base/Shuffle.dart';
import 'package:jpuzzle/models/Game.dart';
import 'package:jpuzzle/models/Tile.dart';
import 'package:jpuzzle/services/firestore.dart';

class GameHistoryItem extends StatefulWidget {
  final List<Game> games;
  final int index;
  const GameHistoryItem({Key? key, required this.games, required this.index}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _GameHistoryItemState();
  }
}

class _GameHistoryItemState extends State<GameHistoryItem>
    with TickerProviderStateMixin {
  FirestoreProvider firestoreProvider = FirestoreProvider();
  late List<Tile> tiles;
  List<List<Tile>> allTiles = [];
  int targetIndex = 8;
  List<dynamic> axes = [];
  List<int> solution = [];
  bool solving = false;
  late AnimationController _controller;
  late AnimationController _playPauseController;
  late Tween<double> _animation;
  int time = 0;
  int score = 0;
  bool playing = false;
  bool doneSolving = false;
  late List<Game> games;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    games = widget.games;
    Game game = games[widget.index];
    solution = List.from(game.userSolution);
    tiles = List.from(game.tiles);
    targetIndex = (game.dimension * game.dimension) - 1;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _playPauseController.dispose();
    super.dispose();
  }

  void calculateAllTiles(int dimension) {
    allTiles.clear();
    for (int row = 0; row < dimension; row++) {
      allTiles
          .add(tiles.sublist(row * dimension, (row * dimension) + dimension));
    }
  }

  void calculateAxes(int dimension) {
    calculateAllTiles(dimension);
    List<dynamic> emptyAxes = [];
    for (List<Tile> row in allTiles) {
      if (row.contains(tiles[targetIndex])) {
        int targetInAllTilesX = row.indexOf(tiles[targetIndex]);
        int targetInAllTilesY = allTiles.indexOf(row);
        for (int i = 0; i < dimension * dimension; i++) {
          emptyAxes
              .add(getAxis(i, targetInAllTilesX, targetInAllTilesY, dimension));
        }
        axes = emptyAxes;
        break;
      }
    }
  }

  dynamic getAxis(
      int index, int targetInAllTilesX, int targetInAllTilesY, int dimension) {
    // int tileInAllTilesX=0;
    // int tileInAllTilesY=0;
    // for (List<Tile> row in allTiles) {
    //   if(row.contains(tiles[index])) {
    //     tileInAllTilesX=row.gameIndexOf(tiles[index]);
    //     tileInAllTilesY=allTiles.gameIndexOf(row);
    //     break;
    //   }
    // }
    // if(base.isSolved(tiles)){
    //   print("Solved");
    // }
    if (targetInAllTilesY != dimension - 1) {
      if (allTiles[targetInAllTilesY + 1][targetInAllTilesX] == tiles[index]) {
        return Axis.vertical;
      }
    }
    if (targetInAllTilesY != 0) {
      if (allTiles[targetInAllTilesY - 1][targetInAllTilesX] == tiles[index]) {
        return Axis.vertical;
      }
    }
    if (targetInAllTilesX != dimension - 1) {
      if (allTiles[targetInAllTilesY][targetInAllTilesX + 1] == tiles[index]) {
        return Axis.horizontal;
      }
    }
    if (targetInAllTilesX != 0) {
      if (allTiles[targetInAllTilesY][targetInAllTilesX - 1] == tiles[index]) {
        return Axis.horizontal;
      }
    }
    return null;
  }

  Widget getSolvingGrid(int dimension) {
    //_animation = Tween<double>(begin: 0, end: (100 - (dimension * 5)));
    for (int i = 0; i < dimension * dimension; i++) {
      axes.add(null);
    }
    for (int x = 0; x < tiles.length; x++) {
      tiles[x].gameIndex = x;
    }
    calculateAxes(dimension);
    return GridView.count(
        crossAxisCount: dimension,
        children: List.generate(tiles.length, (index) {
          Widget newChild = Container(
            child: Builder(
              builder: (context) {
                return Stack(
                  children: [
                    tiles[index].gameIndex == dimension * dimension - 1
                        ? SvgPicture.asset("assets/images/tiles/target.svg")
                        : Container(),
                    Base.getImageFromTileType(tiles[index].type),
                  ],
                );
              },
            ),
            color: Colors.transparent,
            width: (100 - (dimension * 5)),
            height: (100 - (dimension * 5)),
          );
          if (axes[index] == null ||
              !(solution.length > 1 &&
                  solution[solution.length - 2] == index)) {
            return newChild;
          }
          return AnimatedBuilder(
            builder: (BuildContext context, Widget? child) {
              return Transform.translate(
                offset: getOffset(_controller.value, index, solution.last),
                child: child,
              );
            },
            animation: _controller,
            child: newChild,
          );
        }));
  }

  Offset getOffset(double animationValue, int index, int newTargetIndex) {
    double x = 0;
    double y = 0;
    if (axes[index] == Axis.horizontal) {
      x = index < newTargetIndex ? animationValue : -animationValue;
      y = 0;
    } else {
      y = index < newTargetIndex ? animationValue : -animationValue;
      x = 0;
    }
    return Offset(x, y);
  }

  void solve(int dimension) {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    var callback = (status) {
      if (!playing) {
        return;
      }
      if (status == AnimationStatus.completed && playing) {
        if (solution.length == 1) {
          setState(() {
            int move = solution.last;
            Tile newTile = tiles[move];
            tiles[move] = tiles[targetIndex];
            tiles[targetIndex] = newTile;
            tiles[newTile.gameIndex].gameIndex = tiles[targetIndex].gameIndex;
            tiles[targetIndex].gameIndex = targetIndex;
            targetIndex = move;
            solution.removeLast();
            calculateAxes(dimension);
            solution = [(dimension * dimension) - 1];
          });
          _controller.reset();
          _controller.forward();
        } else {
          setState(() {
            int move = solution.last;
            Tile newTile = tiles[move];
            tiles[move] = tiles[targetIndex];
            tiles[targetIndex] = newTile;
            tiles[newTile.gameIndex].gameIndex = tiles[targetIndex].gameIndex;
            tiles[targetIndex].gameIndex = targetIndex;
            targetIndex = move;
            solution.removeLast();
            calculateAxes(dimension);
          });
          _controller.reset();
          _controller.forward();
        }
      }
    };
    if (!playing) {
      return;
    }
    if (solving && playing) {
      setState(() {
        int move = solution.last;
        Tile newTile = tiles[move];
        tiles[move] = tiles[targetIndex];
        tiles[targetIndex] = newTile;
        tiles[newTile.gameIndex].gameIndex = tiles[targetIndex].gameIndex;
        tiles[targetIndex].gameIndex = targetIndex;
        targetIndex = move;
        solution.removeLast();
        calculateAxes(dimension);
      });
      _controller.reset();
      _controller.forward();
      _controller.addStatusListener(callback);
    }
  }

  void togglePlay(int dimension) {
    setState(() {
      playing = !playing;
      solving = playing;
      if (playing == true) {
        _playPauseController.forward();
      } else {
        _playPauseController.reverse();
      }
      solve(dimension);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          Game game = games[widget.index];
          // solution=game.userSolution;
          // tiles=game.tiles;
          return Center(
            child: Column(
              children: [
                Container(
                    width:
                        (100 - (game.dimension * 5)) * game.dimension.toDouble(),
                    height:
                        (100 - (game.dimension * 5)) * game.dimension.toDouble(),
                    child: getSolvingGrid(game.dimension)),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      togglePlay(game.dimension);
                    },
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _playPauseController,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

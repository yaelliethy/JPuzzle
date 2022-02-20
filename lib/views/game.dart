import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jpuzzle/Base/Base.dart';
import 'package:jpuzzle/Base/Shuffle.dart';
import 'package:jpuzzle/Base/TileTypes.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:jpuzzle/models/Game.dart';
import 'package:jpuzzle/models/Tile.dart';

class GameScreen extends StatefulWidget {
  final int dimension;

  const GameScreen({Key? key, required this.dimension}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late Base base;
  late Shuffle shuffle;
  late List<Tile> tiles;
  List<List<Tile>> allTiles = [];
  int targetIndex = 8;
  List<dynamic> axes = [];
  List<int> solution = [];
  List<int> originalSolution = [];
  List<Tile> originalTiles=[];
  bool solving = false;
  bool userSolved = false;
  bool computerSolved = false;
  late AnimationController _controller;
  late Tween<double> _animation;
  int time=0;
  int score=0;
  @override
  void initState() {
    shuffle = Shuffle();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: (100 - (widget.dimension * 5)));
    targetIndex = (widget.dimension * widget.dimension) - 1;
    base = Base(widget.dimension);
    for (int i = 0; i < widget.dimension * widget.dimension; i++) {
      axes.add(null);
    }
    tiles = base.createPuzzle();
    tiles.add(Tile(
        index: (widget.dimension * widget.dimension) - 1,
        type: TileType.target));

    List<dynamic> shuffledTiles = shuffle.shuffle(tiles, widget.dimension);
    tiles = shuffledTiles[0];
    originalTiles = shuffledTiles[0];
    solution = shuffledTiles[1];
    originalSolution = shuffledTiles[1];
    targetIndex = shuffledTiles[2];
    scoreBoard();
    print(solution);
    // while (true){
    //   tiles.shuffle();
    //
    //   if(base.isSolvable(tiles)){
    //     break;
    //   }
    // }
    for (int x = 0; x < tiles.length; x++) {
      tiles[x].gameIndex = x;
    }
    calculateAxes();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future<void> scoreBoard() async{
    while(true){
      if(userSolved || computerSolved){
        break;
      }
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        time++;
        score=((((widget.dimension^2)*originalSolution.length)/time)*100).toInt();
      });
    }
  }
  void calculateAllTiles() {
    allTiles.clear();
    for (int row = 0; row < widget.dimension; row++) {
      allTiles.add(tiles.sublist(
          row * widget.dimension, (row * widget.dimension) + widget.dimension));
    }
  }

  void calculateAxes() {
    base.isSolved(tiles).then((solved) {
      if (solved && (computerSolved == false)) {
        setState(() {
          userSolved = true;
          computerSolved = false;
        });
      }
      if (solved && (computerSolved == true)) {
        setState(() {
          solving = false;
          userSolved = false;
          computerSolved = true;
        });
      }
      if (solving) {
        setState(() {
          solving = false;
        });
      }
    });
    calculateAllTiles();
    List<dynamic> emptyAxes = [];
    for (List<Tile> row in allTiles) {
      if (row.contains(tiles[targetIndex])) {
        int targetInAllTilesX = row.indexOf(tiles[targetIndex]);
        int targetInAllTilesY = allTiles.indexOf(row);
        for (int i = 0; i < widget.dimension * widget.dimension; i++) {
          emptyAxes.add(getAxis(i, targetInAllTilesX, targetInAllTilesY));
        }
        setState(() {
          axes = emptyAxes;
        });
        break;
      }
    }
  }

  Widget getSolvingGrid() {
    return GridView.count(
        crossAxisCount: widget.dimension,
        children: List.generate(tiles.length, (index) {
          Widget newChild = Container(
            child: Builder(
              builder: (context) {
                return Stack(
                  children: [
                    tiles[index].gameIndex ==
                            widget.dimension * widget.dimension - 1
                        ? SvgPicture.asset("assets/images/tiles/target.svg")
                        : Container(),
                    Base.getImageFromTileType(tiles[index].type),
                  ],
                );
              },
            ),
            color: Colors.transparent,
            width: (100 - (widget.dimension * 5)),
            height: (100 - (widget.dimension * 5)),
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
            animation: _controller.drive(_animation),
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

  void solve() {
    if (solving) {
      setState(() {
        int move = solution.last;
        Tile newTile = tiles[move];
        tiles[move] = tiles[targetIndex];
        tiles[targetIndex] = newTile;
        tiles[newTile.gameIndex].gameIndex = tiles[targetIndex].gameIndex;
        tiles[targetIndex].gameIndex = targetIndex;
        targetIndex = move;
        solution.removeLast();
        calculateAxes();
      });
      _controller.reset();
      _controller.forward();
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
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
              calculateAxes();
              solution = [(widget.dimension * widget.dimension) - 1];
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
              calculateAxes();
            });
            _controller.reset();
            _controller.forward();
          }
        }
      });
    }
  }

  dynamic getAxis(int index, int targetInAllTilesX, int targetInAllTilesY) {
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
    if (targetInAllTilesY != widget.dimension - 1) {
      if (allTiles[targetInAllTilesY + 1][targetInAllTilesX] == tiles[index]) {
        return Axis.vertical;
      }
    }
    if (targetInAllTilesY != 0) {
      if (allTiles[targetInAllTilesY - 1][targetInAllTilesX] == tiles[index]) {
        return Axis.vertical;
      }
    }
    if (targetInAllTilesX != widget.dimension - 1) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width:
                  (100 - (widget.dimension * 5)) * widget.dimension.toDouble(),
              height:
                  (100 - (widget.dimension * 5)) * widget.dimension.toDouble(),
              child: solving == false
                  ? GridView.count(
                      crossAxisCount: widget.dimension,
                      children: List.generate(tiles.length, (index) {
                        Tile tile = tiles[index];
                        Tile acceptedTile = tile;

                        return DragTarget<Tile>(
                          builder: (context, List<Tile?> candidateData,
                              rejectedData) {
                            Widget newChild = Container(
                              child: Builder(
                                builder: (context) {
                                  return Stack(
                                    children: [
                                      tiles[index].gameIndex ==
                                              widget.dimension *
                                                      widget.dimension -
                                                  1
                                          ? SvgPicture.asset(
                                              "assets/images/tiles/target.svg")
                                          : Container(),
                                      Base.getImageFromTileType(
                                          tiles[index].type),
                                    ],
                                  );
                                },
                              ),
                              color: Colors.transparent,
                              width: (100 - (widget.dimension * 5)),
                              height: (100 - (widget.dimension * 5)),
                            );
                            dynamic axis = axes[index];
                            if (tile.type == TileType.target ||
                                axis == null ||
                                computerSolved == true ||
                                solving == true ||
                                userSolved == true) {
                              return newChild;
                            } else {
                              return Draggable<Tile>(
                                axis: axis,
                                data: tiles[index],
                                child: newChild,
                                feedback: newChild,
                                childWhenDragging: Container(),
                              );
                            }
                          },
                          onWillAccept: (data) {
                            return tile.type == TileType.target;
                          },
                          onAccept: (data) {
                            setState(() {
                              acceptedTile = data;
                              solution.add(targetIndex);
                              targetIndex = acceptedTile.gameIndex;
                              tiles[acceptedTile.gameIndex] = tiles[index];
                              tiles[index] = acceptedTile;
                              tiles[acceptedTile.gameIndex].gameIndex =
                                  data.gameIndex;
                              tiles[index].gameIndex = index;
                              print(solution);
                              calculateAxes();
                            });
                          },
                        );
                      }),
                    )
                  : getSolvingGrid(),
            ),
            SizedBox(
              height: 10,
            ),
            computerSolved
                ? ElevatedButton(
                    child: Text('Go home'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                    ),
                  )
                : (userSolved
                    ? Column(
                      children: [
                        RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow,
                              ),
                              children: [
                                const TextSpan(text: 'You solved it!'),
                                TextSpan(text: "Your score is: $score")
                              ],
                            ),
                          ),
                        ElevatedButton(
                          child: Text('Go home'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                          ),
                        )
                      ],
                    )
                    : Column(
                      children: [
                        ElevatedButton(
                            child: Text('Solve'),
                            onPressed: () {
                              //Alert user that his game won't be stored
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Solve'),
                                    content: Text(
                                        'Are you sure you want to the computer to ssolve this game? This will not be stored.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Solve'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            userSolved = false;
                                            computerSolved = true;
                                            solving = true;
                                          });
                                          solve();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                            ),
                          ),
                          //Score
                          Text(
                            'Score: $score',
                            style: GoogleFonts.poppins(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                          ),
                      ],
                    )),
          ],
        ),
      ),
    );
  }
  void goHome(context){
    if(userSolved){
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      Game game=Game(
        id:now.millisecondsSinceEpoch,
        date: formatted,
        score: score,
        dimension: widget.dimension,
        tiles: Shuffle.getGeneratedTiles(tiles),
        time: time,
        userSolution: solution.sublist((solution.length-originalSolution.length)+1)
      );
    }
    Navigator.of(context).pop();
  }
}

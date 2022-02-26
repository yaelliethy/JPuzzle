import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jpuzzle/Base/Base.dart';
import 'package:jpuzzle/Base/TileTypes.dart';
import 'package:jpuzzle/common/constants.dart';
import 'package:jpuzzle/models/Tile.dart';
import 'package:jpuzzle/views/home_page.dart';
import 'package:jpuzzle/views/leaderboard.dart';

class GameScreen extends StatefulWidget {
  final int dimension;

  const GameScreen({Key? key, required this.dimension}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Base base;
  late List<Tile> tiles;
  List<List<Tile>> allTiles = [];
  int targetIndex = 8;
  List<dynamic> axes = [];
  @override
  void initState() {
    targetIndex = (widget.dimension * widget.dimension) - 1;
    base = Base(widget.dimension);
    for (int i = 0; i < widget.dimension * widget.dimension; i++) {
      axes.add(null);
    }
    tiles = base.createPuzzle();
    while (true) {
      tiles.shuffle();
      for (int x = 0; x < tiles.length; x++) {
        tiles[x].gameIndex = x;
      }
      if (base.isSolvable(tiles)) {
        break;
      }
    }
    tiles.add(Tile(
        index: (widget.dimension * widget.dimension) - 1,
        type: TileType.target));
    calculateAxes();
    super.initState();
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
      if (solved) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: kBackgroundColor,
              title: ListTile(
                leading: Icon(FontAwesomeIcons.grinStars),
                title: Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kAccentColor,
                  ),
                ),
                subtitle: Divider(
                  endIndent: 50.0,
                  indent: 50.0,
                  thickness: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.home),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Leaderboard();
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.trophy),
                    title: Text(
                      'Leaderboard',
                      style: TextStyle(
                        color: Color(0xFFFF4C29),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SvgPicture.asset(
          'assets/images/backgrounds/Kander.svg',
          fit: BoxFit.fitWidth,
        ),
        title: RichText(
          text: TextSpan(
            style: kHeaderStyle,
            children: [
              TextSpan(
                text: 'Game ',
              ),
              TextSpan(
                text: '(${widget.dimension} × ${widget.dimension})',
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        toolbarHeight: size.height * 0.1,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          width: (100 - (widget.dimension * 5)) * widget.dimension.toDouble(),
          height: (100 - (widget.dimension * 5)) * widget.dimension.toDouble(),
          child: GridView.count(
            crossAxisCount: widget.dimension,
            children: List.generate(tiles.length, (index) {
              Tile tile = tiles[index];
              Tile acceptedTile = tile;

              return DragTarget<Tile>(
                builder: (context, List<Tile?> candidateData, rejectedData) {
                  Widget newChild = Container(
                    child: Builder(
                      builder: (context) {
                        return Stack(
                          children: [
                            tiles[index].gameIndex ==
                                    widget.dimension * widget.dimension - 1
                                ? SvgPicture.asset(
                                    "assets/images/tiles/target.svg",
                                  )
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
                  dynamic axis = axes[index];
                  if (tile.type == TileType.target || axis == null) {
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
                    targetIndex = acceptedTile.gameIndex;
                    tiles[acceptedTile.gameIndex] = tiles[index];
                    tiles[index] = acceptedTile;
                    tiles[acceptedTile.gameIndex].gameIndex = data.gameIndex;
                    tiles[index].gameIndex = index;
                    calculateAxes();
                  });
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

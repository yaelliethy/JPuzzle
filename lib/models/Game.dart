//Game model with time, dimension and score
import 'package:jpuzzle/Base/TileTypes.dart';
import 'package:jpuzzle/models/Tile.dart';

class Game {
  final int id;
  final int time;
  final int dimension;
  final int score;
  final String date;
  final List<Tile> tiles;
  final List<int> userSolution;
  Game({required this.id, required this.time, required this.dimension, required this.score, required this.date, required this.tiles, required this.userSolution});

  factory Game.fromJson(
    Map<String, dynamic> json,
  ) {
    List<Tile> tileFromJson=[];
    for (Map<String, dynamic> tile in json['tiles']){
      tileFromJson.add(Tile(
        index: tile['index'],
        gameIndex: tile['gameIndex'],
        type: TileType.values[tile['type']]
      ));
    }
    return Game(
      id: json['id'],
      time: json['time'],
      dimension: json['dimension'],
      score: json['score'],
      date: json['date'],
      tiles: tileFromJson,
      userSolution: json['userSolution'].cast<int>()
    );
  }
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tileToJson=[];
    for (Tile tile in tiles){
      tileToJson.add({
        'index': tile.index,
        'type': tile.type.index,
        'gameIndex': tile.gameIndex
      });
    }
    return {
      'id': id,
      'time': time,
      'dimension': dimension,
      'score': score,
      'date': date,
      'tiles': tileToJson,
      'userSolution': userSolution
    };
  }
}
//Game model with time, dimension and score
import 'package:jpuzzle/models/Tile.dart';

class Game {
  final int id;
  final int time;
  final int dimension;
  final int score;
  final String date;
  final List<int> tiles;
  final List<int> userSolution;
  Game({required this.id, required this.time, required this.dimension, required this.score, required this.date, required this.tiles, required this.userSolution});

  factory Game.fromJson(
    Map<String, dynamic> json,
  ) {
    return Game(
      id: json['id'],
      time: json['time'],
      dimension: json['dimension'],
      score: json['score'],
      date: json['date'],
      tiles: json['tiles'],
      userSolution: json['userSolution']
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time,
    'dimension': dimension,
    'score': score,
    'date': date,
    'tiles': tiles,
    'userSolution': userSolution
  };
}
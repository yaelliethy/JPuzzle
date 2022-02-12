//Game model with time, dimension and score
class Game{
  final int id;
  final int time;
  final int dimension;
  final int score;

  Game({required this.id, required this.time, required this.dimension, required this.score});

  factory Game.fromJson(Map<String, dynamic> json){
    return Game(
      id: json['id'],
      time: json['time'],
      dimension: json['dimension'],
      score: json['score']
    );
  }
}
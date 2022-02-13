//Game model with time, dimension and score
class Game {
  final int id;
  final int time;
  final int dimension;
  final int score;
  final String date;
  Game({required this.id, required this.time, required this.dimension, required this.score, required this.date});

  factory Game.fromJson(
    Map<String, dynamic> json,
  ) {
    return Game(
      id: json['id'],
      time: json['time'],
      dimension: json['dimension'],
      score: json['score'],
      date: json['date']
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time,
    'dimension': dimension,
    'score': score,
    'date': date
  };
}
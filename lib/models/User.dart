//User model with High score, high score date, high score time, and high score dimension
class User {
  int highScore;
  String highScoreDate;
  int highScoreTime;
  int highScoreDimension;

  User({required this.highScore, required this.highScoreDate, required this.highScoreTime, required this.highScoreDimension});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      highScore: json['highScore'],
      highScoreDate: json['highScoreDate'],
      highScoreTime: json['highScoreTime'],
      highScoreDimension: json['highScoreDimension'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['highScore'] = this.highScore;
    data['highScoreDate'] = this.highScoreDate;
    data['highScoreTime'] = this.highScoreTime;
    data['highScoreDimension'] = this.highScoreDimension;
    return data;
  }
}
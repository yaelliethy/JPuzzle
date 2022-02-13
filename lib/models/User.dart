//User model with High score, high score date, high score time, and high score dimension
class User {
  int highScore;
  String highScoreDate;
  int highScoreTime;
  int highScoreDimension;
  String token;
  User({required this.highScore, required this.highScoreDate, required this.highScoreTime, required this.highScoreDimension, required this.token});

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      highScore: json['highScore'],
      highScoreDate: json['highScoreDate'],
      highScoreTime: json['highScoreTime'],
      highScoreDimension: json['highScoreDimension'],
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highScore'] = highScore;
    data['highScoreDate'] = highScoreDate;
    data['highScoreTime'] = highScoreTime;
    data['highScoreDimension'] = highScoreDimension;
    data['token'] = token;
    return data;
  }
}
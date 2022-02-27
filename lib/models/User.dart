//User model with High score, high score date, high score time, and high score dimension
class User {
  int highScore;
  String highScoreDate;
  int highScoreTime;
  int highScoreDimension;
  String email;
  String profilePicUrl;
  String name;
  User({required this.highScore, required this.highScoreDate, required this.highScoreTime, required this.highScoreDimension, required this.email, required this.profilePicUrl, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      highScore: json['highScore'],
      highScoreDate: json['highScoreDate'],
      highScoreTime: json['highScoreTime'],
      highScoreDimension: json['highScoreDimension'],
      email: json['email'],
      profilePicUrl: json['profilePicUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highScore'] = highScore;
    data['highScoreDate'] = highScoreDate;
    data['highScoreTime'] = highScoreTime;
    data['highScoreDimension'] = highScoreDimension;
    data['email'] = email;
    data['profilePicUrl'] = profilePicUrl;
    data['name'] = name;
    return data;
  }
}
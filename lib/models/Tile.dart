import 'package:jpuzzle/Base/TileTypes.dart';

class Tile{
  int index;
  TileType type;
  int gameIndex;
  //Constructor
  Tile({required this.index, required this.type, this.gameIndex=-2}){
    if(gameIndex==-2){
      gameIndex=index;
    }
  }
  factory Tile.fromJson(Map<String, dynamic> json){
    return Tile(
      index: json['index'],
      type: TileType.values[json['type']],
      gameIndex: json['gameIndex']
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'index': index,
      'type': type.index,
      'gameIndex': gameIndex
    };
  }
}
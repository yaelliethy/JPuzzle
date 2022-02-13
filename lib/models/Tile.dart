import 'package:jpuzzle/Base/TileTypes.dart';

class Tile{
  final int index;
  final TileType type;
  //Constructor
  Tile({required this.index, required this.type});
  factory Tile.fromJson(Map<String, dynamic> json){
    return Tile(
      index: json['index'],
      type: TileType.values[json['type']],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'index': index,
      'type': type.index,
    };
  }
}
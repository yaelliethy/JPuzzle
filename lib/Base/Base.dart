import 'dart:math';

import 'package:jpuzzle/Base/Direction.dart';
import 'package:jpuzzle/models/Tile.dart';
import 'package:jpuzzle/Base/TileTypes.dart';

class Base{
  late int dimension;
  Base(this.dimension);
  //Check if slide puzzle is solvable
  bool isSolvable(List<Tile> tiles){
    int inversions = 0;
    for(int i = 0; i < tiles.length; i++){
      for(int j = i + 1; j < tiles.length; j++){
        if(tiles[i].index != 0 && tiles[j].index != 0 && tiles[i].index > tiles[j].index){
          inversions++;
        }
      }
    }
    return inversions % 2 == 0;
  }
  //Check if the puzzle is solved
  bool isSolved(List<Tile> tiles){
    if(tiles[1].type != TileType.horizontal && tiles[1].type != TileType.leftUp && tiles[1].type != TileType.leftDown){
      return false;
    }
    int x=1, y=0;
    Direction direction=Direction.right;
    //For each tile
    for(int i = 0; i < tiles.length; i++){
      if(tiles[i].type == TileType.horizontal) {
        //Check whether this tile is the first tile
        //If direction is up or down, return false
        if(direction == Direction.up || direction == Direction.down){
          return false;
        }
        else{
          if(direction == Direction.right){
            x++;
          }
          else{
            x--;
          }
        }
      }
      else if(tiles[i].type == TileType.leftUp) {
        if(direction == Direction.right || direction == Direction.down){
          x++;
          direction=Direction.up;
        }
        else{
          return false;
        }
      }
      else if(tiles[i].type == TileType.leftDown) {
        if(direction == Direction.right || direction == Direction.up){
          x++;
          direction=Direction.down;
        }
        else{
          return false;
        }
      }
      else if(tiles[i].type == TileType.vertical) {
        if(direction == Direction.left || direction == Direction.right){
          return false;
        }
        else{
          if(direction == Direction.up){
            y++;
          }
          else{
            y--;
          }
        }
      }
      else if(tiles[i].type == TileType.rightUp) {
        if(direction == Direction.left || direction == Direction.down){
          y++;
          direction=Direction.right;
        }
        else{
          return false;
        }
      }
      else if(tiles[i].type == TileType.rightDown) {
        if(direction == Direction.left || direction == Direction.up){
          y++;
          direction=Direction.left;
        }
        else{
          return false;
        }
      }
    }
    if(x==dimension && y==dimension){
      return true;
    }
    else{
      return false;
    }
  }
  List<Tile> createPuzzle(){
    List<Tile> tiles = [];
    List<int> numbers = [];
    Random random = Random();
    //Loop dimension times
    for(int i = 0; i < dimension-1; i++){
      numbers.add(random.nextInt(dimension));
    }
    while (true){
      int lastNum=random.nextInt(dimension);
      if(numbers[-1] <= lastNum){
        numbers.add(lastNum);
        break;
      }
    }
    tiles.addAll(getFromPointAToB(0, 0, 1, 0));
    int x = 1;
    int y = 0;
    for(int i = 0; i < dimension-1; i++){
      tiles.addAll(getFromPointAToB(x, y, numbers[i]+(dimension*y), y+1));
      x=numbers[i]+(dimension*y);
      y+=1;
    }
    return shuffle(tiles);
  }
  //Get all possible tiles
  List<Tile> getAllPossibleTiles(int x, int y){
    Map<TileType, Tile> tiles = getAllTiles(getIndex(x, y));
    if(x==0){
      tiles.remove(TileType.leftUp);
      tiles.remove(TileType.leftDown);
    }
    if(x==dimension-1){
      tiles.remove(TileType.rightUp);
      tiles.remove(TileType.rightDown);
    }
    if(y==0){
      tiles.remove(TileType.leftUp);
      tiles.remove(TileType.rightUp);
    }
    if(y==dimension-1){
      tiles.remove(TileType.leftDown);
      tiles.remove(TileType.rightDown);
    }
    if(x==0 && y==0){
      return [Tile(index: getIndex(x, y), type: TileType.horizontal)];
    }
    return tiles.values.toList();
  }
  Map<TileType, Tile> getAllTiles(int index){
    Map<TileType, Tile> tiles = {};
    for(int i = 0; i < 6; i++){
      for(int j = 0; j < 6; j++){
        tiles[TileType.values[j]] = Tile(index: index, type: TileType.values[j]);
      }
    }
    return tiles;
  }
  //Get index from x and y
  int getIndex(int x, int y){
    return x * dimension + y;
  }
  List<Tile> getFromPointAToB(int ax, int bx, int ay, int by){
    List<Tile> tiles = [];
    if(ax==bx){
      for(int i = 0; i < by-ay; i++){
        tiles.add(Tile(index: ay+i, type: TileType.horizontal));
      }
    }
    else{
      if(ay==by){
        return [Tile(index: getIndex(bx, by), type: TileType.vertical)];
      }
      else if(ay<by){
        tiles=getFromPointAToB(ax, bx, ay, by);
        tiles.removeLast();
        tiles.add(Tile(index: getIndex(bx, by), type: TileType.rightDown));
      }
      else{
        tiles=getFromPointAToB(ax, bx, ay, by);
        tiles.removeLast();
        tiles.add(Tile(index: getIndex(bx, by), type: TileType.leftDown));
      }
    }
    return tiles;
  }
  //Shuffle the puzzle in a way that is solvable
  List<Tile> shuffle(List<Tile> tiles){
    while(true){
      List<Tile> newTiles = tiles.toList();
      newTiles.shuffle();
      if(isSolvable(newTiles)){
        return newTiles;
      }
    }
  }
}
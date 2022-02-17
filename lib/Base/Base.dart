import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    if(tiles[0].type != TileType.horizontal){
      return false;
    }
    int x=1, y=0;
    Direction direction=Direction.right;
    //For each tile
    while(x<dimension-1 && y<dimension-1){
      int i=getIndex(x, y);
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
          y--;
          direction=Direction.up;
        }
        else{
          return false;
        }
      }
      else if(tiles[i].type == TileType.leftDown) {
        if(direction == Direction.right || direction == Direction.up){
          x++;
          y++;
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
            y--;
          }
          else{
            y++;
          }
        }
      }
      else if(tiles[i].type == TileType.rightUp) {
        if(direction == Direction.left || direction == Direction.down){
          x--;
          y--;
          direction=Direction.right;
        }
        else{
          return false;
        }
      }
      else if(tiles[i].type == TileType.rightDown) {
        if(direction == Direction.left || direction == Direction.up){
          x--;
          y--;
          direction=Direction.left;
        }
        else{
          return false;
        }
      }
    }
    if(x==dimension-1 && y==dimension-1){
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
    numbers.add(random.nextInt(dimension-2)+1);
    for(int i = 0; i < dimension-2; i++){
      numbers.add(random.nextInt(dimension-1));
    }
    while (true){
      int lastNum=random.nextInt(dimension-1);
      if(numbers.last <= lastNum){
        numbers.add(lastNum);
        break;
      }
    }
    //numbers=[1,0,1];
    tiles.add(Tile(index: 0, type: TileType.horizontal));
    int x = 1;
    int y = 0;
    Direction direction = Direction.right;
    for(int i = 0; i < numbers.length; i++){
      int number=numbers[i];
      if(i!=numbers.length-1) {
        if (y != 0 && direction == Direction.down) {
          if (number > x) {
            tiles.add(Tile(index: getIndex(x, y), type: TileType.rightUp));
            direction = Direction.right;
            x++;
          }
          else if (number < x) {
            tiles.add(Tile(index: getIndex(x, y), type: TileType.leftUp));
            direction = Direction.left;
            x--;
          }
          else {
            tiles.add(Tile(index: getIndex(x, y), type: TileType.vertical));
            direction = Direction.down;
          }
        }
        if (number > x) {
          for (int j = 0; j <= (number - x); j++) {
            tiles.add(
                Tile(index: getIndex(x + j, y), type: TileType.horizontal));
            direction = Direction.right;
          }
          tiles.add(Tile(index: getIndex(number, y), type: TileType.leftDown));
          direction = Direction.down;
        }
        else if (number < x) {
          for (int j = 0; j <= (x - number); j++) {
            tiles.add(
                Tile(index: getIndex(x - j, y), type: TileType.horizontal));
            direction = Direction.left;
          }
          tiles.add(Tile(index: getIndex(number, y), type: TileType.rightDown));
          direction = Direction.down;
        }
        else {
          if (direction == Direction.right) {
            tiles.add(
                Tile(index: getIndex(number, y), type: TileType.leftDown));
            direction = Direction.down;
          }
          else if (direction == Direction.left) {
            tiles.add(
                Tile(index: getIndex(number, y), type: TileType.rightDown));
            direction = Direction.down;
          }
          else if (direction == Direction.up) {
            tiles.add(
                Tile(index: getIndex(number, y), type: TileType.vertical));
          }
          else if (direction == Direction.down) {
            tiles.add(
                Tile(index: getIndex(number, y), type: TileType.vertical));
          }
        }
        x = number;
        y += 1;
      }
      else{
        tiles.add(Tile(index: getIndex(x, y), type: TileType.rightUp));
        for (int j = x+1; j < (dimension-1); j++) {
          tiles.add(
              Tile(index: getIndex(j, y), type: TileType.horizontal));
          direction = Direction.right;
        }
      }
    }
    List<int> indexes = [];
    for(int i = 0; i < tiles.length; i++){
      indexes.add(tiles[i].index);
    }
    for(int i = 0; i < (dimension*dimension)-1; i++){
      if(!indexes.contains(i)){
        tiles.add(Tile(index: i, type: TileType.placeholder));
      }
    }
    //tiles=shuffle(tiles);
    Map<int, Tile> tilesMap = {};
    for(int i = 0; i < tiles.length; i++){
      tilesMap[tiles[i].gameIndex] = tiles[i];
    }
    List<Tile> finalTilesList = tilesMap.values.toList();
    for(int i = 0; i < tilesMap.values.toList().length; i++){
      finalTilesList[tilesMap.keys.toList()[i]]=tilesMap.values.toList()[i];
    }
    //return shuffle(finalTilesList);
    return finalTilesList;
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
    return y * (dimension) + x;
  }
  int getTargetX(List<int> numbers, int targetY){
    int x=(targetY*(dimension+1))+numbers[targetY-1];
    return x;
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
  static Widget getImageFromTileType(TileType tileType){
    if(tileType==TileType.placeholder){
      return SvgPicture.asset("assets/images/tiles/placeholder.svg");
    }
    else if (tileType==TileType.target){
      return Container();
    }
    else {
      String path;
      int rotation=0;
      if (tileType == TileType.horizontal || tileType == TileType.vertical) {
        path = "assets/images/tiles/vertical.svg";
      }
      else {
        path = "assets/images/tiles/round.svg";
      }
      //If vertical or leftDown rotate 0 degrees
      if (tileType == TileType.vertical || tileType == TileType.leftDown) {
        rotation = 0;
      }
      //If leftUp or horizontal rotate 90 degrees
      else if (tileType == TileType.leftUp || tileType == TileType.horizontal) {
        rotation = 90;
      }
      //If rightUp rotate 180 degrees
      else if (tileType == TileType.rightUp) {
        rotation = 180;
      }
      //If rightDown rotate 270 degrees
      else if (tileType == TileType.rightDown) {
        rotation = 270;
      }
      return Transform.rotate(
        angle: rotation.toDouble() * pi / 180,
        child: SvgPicture.asset(
            path,
        ),
      );
    }
  }
}
import 'dart:math';

import 'package:jpuzzle/models/Tile.dart';
class Shuffle{
    static List<Tile> getTiles(List<int> generatedTiles, List<Tile> tiles){
      List<Tile> returnedTiles=tiles;
      for (int i=0; i<generatedTiles.length; i++){
        returnedTiles[i]=tiles[generatedTiles[i]];
      }
      return returnedTiles;
    }
    static List<int> getGeneratedTiles(List<Tile> tiles){
      List<int> returnedTiles=[];
      for (Tile tile in tiles){
        returnedTiles.add(tile.index);
      }
      return returnedTiles;
    }
    List<dynamic> shuffle(List<Tile> tiles, int dimension){
        Random random=Random();
        List<List<Tile>> allTiles = [];
        List<int> solution = [];
        List<dynamic> possibleMoves = [];
        int targetIndex = (dimension * dimension) - 1;
        solution.add(targetIndex);
        int repeat=0;
        while ((repeat<dimension*dimension*dimension) || targetIndex!=(dimension*dimension)-1){
          possibleMoves.clear();
          allTiles.clear();
          for (int row = 0; row < dimension; row++) {
            allTiles.add(
                tiles.sublist(row * dimension, (row * dimension) + dimension));
          }
          for (List<Tile> row in allTiles) {
            if (row.contains(tiles[targetIndex])) {
              int targetInAllTilesX = row.indexOf(tiles[targetIndex]);
              int targetInAllTilesY = allTiles.indexOf(row);
              for (int index = 0; index < dimension * dimension; index++) {
                if (targetInAllTilesY != dimension - 1) {
                  if (allTiles[targetInAllTilesY + 1][targetInAllTilesX] ==
                      tiles[index]) {
                    possibleMoves.add(index);
                  }
                }
                if (targetInAllTilesY != 0) {
                  if (allTiles[targetInAllTilesY - 1][targetInAllTilesX] ==
                      tiles[index]) {
                    possibleMoves.add(index);
                  }
                }
                if (targetInAllTilesX != dimension - 1) {
                  if (allTiles[targetInAllTilesY][targetInAllTilesX + 1] ==
                      tiles[index]) {
                    possibleMoves.add(index);
                  }
                }
                if (targetInAllTilesX != 0) {
                  if (allTiles[targetInAllTilesY][targetInAllTilesX - 1] ==
                      tiles[index]) {
                    possibleMoves.add(index);
                  }
                }
              }
              break;
            }
          }
          int randomIndex = random.nextInt(possibleMoves.length);
          dynamic move = possibleMoves[randomIndex];
          while (move == null || solution.last==move || (solution.length>2 && solution.sublist(solution.length-3, solution.length).contains(move))){
            randomIndex = random.nextInt(possibleMoves.length);
            move = possibleMoves[randomIndex];
          }
          Tile newTile = tiles[move];
          tiles[move] = tiles[targetIndex];
          tiles[targetIndex] = newTile;
          tiles[newTile.gameIndex].gameIndex = tiles[targetIndex].gameIndex;
          tiles[targetIndex].gameIndex = targetIndex;
          targetIndex = move;
          solution.add(targetIndex);
          repeat++;
        }
        return [tiles, solution, targetIndex];
    }
}
import 'dart:math';

import 'package:jpuzzle/models/Tile.dart';
class Shuffle{
    List<Tile> surroundingPieces(List<Tile> puzzle, int z, int w, int h){
      int x = z%w;
      int y = (z/h).floor();

      int? left  = x == 0?null:z - 1;
      int? up    = y == 0?null:z - w;
      int? right = x == (w-1)?null:z + 1;
      int? down  = y == (h-1)?null: z + w;

      List<int> indexList=[left, up, right, down].whereType<int>().toList();
      List <Tile> returnedList=[];
      for (int index in indexList){
        returnedList.add(puzzle[index]);
      }
      return returnedList;
    }
    List<dynamic> shuffle(List<Tile> puzzle, int moves, int width, int height){
      List<Tile> originalTiles=puzzle;
      Random random=Random();
      Tile empty = puzzle[puzzle.indexWhere((element){
        if(element==(width*height)-1){
          return true;
        }
        return false;
      })];
      Tile lastPiece = empty;
      List<Tile> solution = [empty];
      for(Tile _ in puzzle){
        List<Tile> pieces = surroundingPieces(originalTiles, empty.index, width, height);

        if (pieces.contains(lastPiece)){
          pieces.remove(lastPiece);
        }

        Tile pieceIndex = pieces[random.nextInt(pieces.length)];
        solution.insert(0, pieceIndex);

        puzzle[empty.index] = puzzle[pieceIndex.index];
        lastPiece = empty;

        //puzzle[pieceIndex] = 0;
        empty = pieceIndex;
      }
      return [puzzle, solution];
    }
    List<int> solve(List<int> pzl, List<int> sol){
      for (int i=0; i<pzl.length-1;i++){
        pzl[sol[i]] = pzl[sol[i + 1]];
        pzl[sol[i + 1]] = 0;
      }

      return pzl;
    }
    List<Tile> getTiles(List<int> generatedTiles, List<Tile> tiles){
      List<Tile> returnedTiles=tiles;
      for (int i=0; i<generatedTiles.length; i++){
        returnedTiles[i]=tiles[generatedTiles[i]];
      }
      return returnedTiles;
    }
    List<int> getGeneratedTiles(List<Tile> tiles){
      List<int> returnedTiles=[];
      for (Tile tile in tiles){
        returnedTiles.add(tile.index);
      }
      return returnedTiles;
    }
    List<dynamic> shuffleT(List<Tile> tiles, int dimension){
        Random random=Random();
        List<List<Tile>> allTiles = [];
        List<int> solution = [];
        List<dynamic> possibleMoves = [];
        int targetIndex = (dimension * dimension) - 1;
        solution.add(targetIndex);
        for (int repeat=0;repeat<random.nextInt(dimension*dimension)+3  ;repeat++) {
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
          while (move == null || solution.last==move) {
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
        }
        return [tiles, solution, targetIndex];
    }
}
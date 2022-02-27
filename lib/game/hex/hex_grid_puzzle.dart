import 'package:slide_puzzle/game/_shared/models/models.dart';

import 'puzzle.dart';

/// {@template square_grid_puzzle}
/// Model for a square grid puzzle.
/// {@endtemplate}
class HexGridPuzzle extends GridPuzzle<HexTile> {
  /// {@macro square_grid_puzzle}
  HexGridPuzzle({required List<HexTile> tiles}) : super(tiles: tiles);

  HexTile getWhitespaceTile() => tiles.singleWhere((tile) => tile.isWhitespace);

  /// Gets the number of tiles that are currently in their correct position.
  int get numberOfCorrectTiles {
    final correctTiles = tiles.where((tile) => !tile.isWhitespace && tile.hasCorrectPosition);
    return correctTiles.length;
  }

  /// Determines if the puzzle is completed.
  bool get isComplete => numberOfCorrectTiles == tiles.length - 1;

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    return tile.isAlignedWith(whitespaceTile);
  }

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  @override
  HexGridPuzzle moveTiles(HexTile tile, List<HexTile> tilesToSwap) {
    final whitespaceTile = getWhitespaceTile();
    final whiteSpaceCurrentPosition = whitespaceTile.currentPosition;

    final currentPosition = tile.currentPosition;

    final deltaQ = whiteSpaceCurrentPosition.q - currentPosition.q;
    final deltaR = whiteSpaceCurrentPosition.r - currentPosition.r;
    final deltaS = whiteSpaceCurrentPosition.s - currentPosition.s;

    final distanceToWhitespaceTile = (deltaQ.abs() + deltaR.abs() + deltaS.abs());
    if (distanceToWhitespaceTile > 2) {
      // more than 1 tiles needs to be swapped
      final shiftPointQ = currentPosition.q + deltaQ.sign;
      final shiftPointR = currentPosition.r + deltaR.sign;
      final shiftPointS = currentPosition.s + deltaS.sign;
      final tileToSwapWith = tiles.singleWhere(
        (tile) {
          final position = tile.currentPosition;
          return position.q == shiftPointQ && position.r == shiftPointR && position.s == shiftPointS;
        },
      );
      tilesToSwap.add(tile);
      return moveTiles(tileToSwapWith, tilesToSwap);
    } else {
      tilesToSwap.add(tile);
      return _swapTiles(tilesToSwap);
    }
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  HexGridPuzzle _swapTiles(List<HexTile> tilesToSwap) {
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = getWhitespaceTile();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      // Swap current board positions of the moving tile and the whitespace.
      tiles[tileIndex] = tile.copyWith(
        currentPosition: whitespaceTile.currentPosition,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: tile.currentPosition,
      );
    }

    return HexGridPuzzle(tiles: tiles);
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  HexGridPuzzle sort() {
    final sortedTiles = [...tiles]..sort((tileA, tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });

    return HexGridPuzzle(tiles: sortedTiles);
  }

  @override
  List<Object> get props => [tiles];
}

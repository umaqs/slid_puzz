import 'dart:math';

import 'package:slide_puzzle/game/_shared/models/models.dart';

import 'puzzle.dart';

// A 3x3 square grid puzzle board visualization:
//
//   ┌─────1───────2───────3────► x
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   1  │  1  │ │  2  │ │  3  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   2  │  4  │ │  5  │ │  6  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐
//   3  │  7  │ │  8  │
//   │  └─────┘ └─────┘
//   ▼
//   y
//
// This puzzle is in its completed state (i.e. the tiles are arranged in
// ascending order by value from top to bottom, left to right).
//
// Each tile has a value (1-8 on example above), and a correct and current
// position.
//
// The correct position is where the tile should be in the completed
// puzzle. As seen from example above, tile 2's correct position is (2, 1).
// The current position is where the tile is currently located on the board.

/// {@template square_grid_puzzle}
/// Model for a square grid puzzle.
/// {@endtemplate}
class SquareGridPuzzle extends GridPuzzle<SquareTile> {
  /// {@macro square_grid_puzzle}
  const SquareGridPuzzle({required List<SquareTile> tiles}) : super(tiles: tiles);

  @override
  SquareTile getWhitespaceTile() => tiles.singleWhere((tile) => tile.isWhitespace);

  /// Gets the number of tiles that are currently in their correct position.
  @override
  int get numberOfCorrectTiles {
    final correctTiles = tiles.where((tile) => !tile.isWhitespace && tile.hasCorrectPosition);
    return correctTiles.length;
  }

  /// Determines if the puzzle is completed.
  @override
  bool get isComplete => numberOfCorrectTiles == tiles.length - 1;

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  @override
  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    return tile.isAlignedWith(whitespaceTile);
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    final size = sqrt(tiles.length).toInt();
    final height = tiles.length ~/ size;
    final inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespaceRow = getWhitespaceTile().currentPosition.y.toInt();

    if ((height - whitespaceRow).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (tileB.isWhitespace) {
          continue;
        }
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (a.value == b.value) {
      return false;
    }
    if (b.value < a.value) {
      return b.currentPosition.compareTo(a.currentPosition) > 0;
    } else {
      return a.currentPosition.compareTo(b.currentPosition) > 0;
    }
  }

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  @override
  SquareGridPuzzle moveTiles(SquareTile tile, List<SquareTile> tilesToSwap) {
    final whitespaceTile = getWhitespaceTile();
    final deltaX = whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final deltaY = whitespaceTile.currentPosition.y - tile.currentPosition.y;

    final distanceToWhitespaceTile = deltaX.abs() + deltaY.abs();
    if (distanceToWhitespaceTile > 1) {
      // more than 1 tiles needs to be swapped
      final shiftPointX = tile.currentPosition.x + deltaX.sign;
      final shiftPointY = tile.currentPosition.y + deltaY.sign;
      final tileToSwapWith = tiles.singleWhere(
        (tile) => tile.currentPosition.x == shiftPointX && tile.currentPosition.y == shiftPointY,
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
  SquareGridPuzzle _swapTiles(List<SquareTile> tilesToSwap) {
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexWhere((tile) => tile.value == tileToSwap.value);
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

    return SquareGridPuzzle(tiles: tiles);
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  @override
  SquareGridPuzzle sort() {
    final sortedTiles = [...tiles]..sort((tileA, tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });

    return SquareGridPuzzle(tiles: sortedTiles);
  }

  @override
  SquareGridPuzzle clone() {
    return SquareGridPuzzle(tiles: [...tiles]);
  }

  @override
  List<Object> get props => [tiles];
}

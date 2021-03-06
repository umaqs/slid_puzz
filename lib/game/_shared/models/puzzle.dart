import 'package:equatable/equatable.dart';

import 'tile.dart';

/// {@template grid_puzzle}
/// Base class for grid puzzle.
/// {@endtemplate}
abstract class GridPuzzle<T extends Tile> extends Equatable {
  /// {@macro grid_puzzle}
  const GridPuzzle({required this.tiles});

  /// List of [Tile]s representing the puzzle's current arrangement.
  final List<T> tiles;

  /// Gets the single whitespace tile object in the puzzle.
  T getWhitespaceTile();

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  GridPuzzle<T> moveTiles(T tile, List<T> tilesToSwap);

  /// Uniquely identify the puzzle based on the tile formation
  String get id => tiles.map((t) => t.value).join();

  /// Gets the number of tiles that are currently in their correct position.
  int get numberOfCorrectTiles {
    final correctTiles = tiles.where((tile) => !tile.isWhitespace && tile.hasCorrectPosition);
    return correctTiles.length;
  }

  /// Determines if the puzzle is completed.
  bool get isComplete => numberOfCorrectTiles == tiles.length - 1;

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(T tile) {
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    return tile.isAlignedWith(whitespaceTile);
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  GridPuzzle<T> sort();

  GridPuzzle<T> clone();

  num getManhattanDistance({bool weighted = true}) {
    var cost = 0.0;
    for (final tile in tiles) {
      if (tile.isWhitespace) {
        continue;
      }

      if (weighted) {
        cost += _getTileManhattanDistance(tile);
      } else {
        cost += tile.manhattanDistance;
      }
    }
    return cost;
  }

  num _getTileManhattanDistance(Tile tile) {
    final tileCount = tiles.length;
    final exp = tileCount - tile.value + 1.0;
    return exp * tile.manhattanDistance;
  }

  @override
  List<Object> get props => [tiles];
}

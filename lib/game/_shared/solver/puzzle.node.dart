import 'dart:collection';

import 'package:slide_puzzle/game/_shared/models/models.dart';

class PuzzleNode<T extends Tile> {
  PuzzleNode({
    required this.puzzle,
    required this.cost,
    this.actionTile,
    this.parent,
  })  : remainingTile = puzzle.tiles.length - puzzle.numberOfCorrectTiles,
        manhattanDistance = puzzle.getManhattanDistance(weighted: false),
        weightedManhattanDistance = puzzle.getManhattanDistance();

  final GridPuzzle<T> puzzle;
  final num cost;
  final num manhattanDistance;
  final num weightedManhattanDistance;
  final int remainingTile;
  final PuzzleNode<T>? parent;
  final T? actionTile;

  String get key => puzzle.id;

  num get totalCost => cost + 1.01 * manhattanDistance;
  num get totalCostWeighted => cost + 1.01 * weightedManhattanDistance;

  Set<PuzzleNode<T>> getChildren(Set<String> visited) {
    final children = HashSet<PuzzleNode<T>>();

    final movableTiles = [
      for (final tile in puzzle.tiles)
        if (puzzle.isTileMovable(tile)) tile,
    ];
    for (final movableTile in movableTiles) {
      final newPuzzle = puzzle.clone().moveTiles(movableTile, []).sort();

      final id = newPuzzle.id;

      // break loops
      if (id == parent?.key || visited.contains(id)) {
        continue;
      }

      final newNode = PuzzleNode<T>(
        puzzle: newPuzzle,
        cost: cost + 1,
        parent: this,
        actionTile: movableTile,
      );

      children.add(newNode);
    }

    return children;
  }

  Iterable<T> getPath() {
    final path = <T>[];

    if (actionTile != null) {
      path.add(actionTile!);
    }

    var pointer = parent;
    // Go up the chain to recreate the path
    while (pointer != null) {
      if (pointer.actionTile != null) {
        path.add(pointer.actionTile!);
      }
      pointer = pointer.parent;
    }

    return path.reversed;
  }

  static int comparator(PuzzleNode a, PuzzleNode b) {
    return a.totalCost.compareTo(b.totalCost);
  }

  static int comparatorWeighed(PuzzleNode a, PuzzleNode b) {
    return a.totalCostWeighted.compareTo(b.totalCostWeighted);
  }

  static int comparatorHeuristicOnly(PuzzleNode a, PuzzleNode b) {
    return a.manhattanDistance.compareTo(b.manhattanDistance);
  }
}

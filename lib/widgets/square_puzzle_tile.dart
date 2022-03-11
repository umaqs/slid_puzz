import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/layout/layout.dart';

/// {@template square_puzzle_tile}
/// Displays the puzzle tile associated with [tile]
/// {@endtemplate}
@visibleForTesting
class SquarePuzzleTile extends StatelessWidget {
  /// {@macro square_puzzle_tile}
  const SquarePuzzleTile({
    Key? key,
    required this.tile,
    required this.gridSize,
    required this.childBuilder,
    this.useCorrectPosition = false,
  }) : super(key: key);

  /// The tile to be displayed.
  final SquareTile tile;

  /// Size of the board grid
  final int gridSize;

  /// Use to build custom child for the game mode
  final WidgetBuilder childBuilder;

  /// Display the tile at it's correct position on the grid
  final bool useCorrectPosition;

  @override
  Widget build(BuildContext context) {
    final gridScaleFactor = 4 / gridSize;
    final dimension = context.layoutSize.squareTileSize * gridScaleFactor;

    return AnimatedAlign(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 100 * min(gridSize, 4)),
      alignment: FractionalOffset.fromOffsetAndSize(
        (useCorrectPosition ? tile.correctPosition : tile.currentPosition).toOffset,
        Size.square(gridSize.toDouble() - 1),
      ),
      child: SizedBox.square(
        dimension: dimension,
        child: childBuilder(context),
      ),
    );
  }
}

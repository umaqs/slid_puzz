import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';

/// {@template numbers_square_puzzle_board}
/// Display the board of the puzzle in a [gridSize]x[gridSize] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SquarePuzzleBoard extends StatelessWidget {
  /// {@macro numbers_square_puzzle_board}
  const SquarePuzzleBoard({
    Key? key,
    required this.gridSize,
    required this.tiles,
  }) : super(key: key);

  /// The size of the board.
  final int gridSize;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, _) {
        return SizedBox.square(
          dimension: layoutSize.squareBoardSize,
          child: Stack(
            alignment: Alignment.center,
            children: tiles,
          ),
        );
      },
    );
  }
}

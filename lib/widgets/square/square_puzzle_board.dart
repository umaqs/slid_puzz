import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';

class SquarePuzzleBoard extends StatelessWidget {
  const SquarePuzzleBoard({
    Key? key,
    required this.gridSize,
    required this.tiles,
    this.background,
  }) : super(key: key);

  final int gridSize;
  final List<Widget> tiles;
  final Widget? background;

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
            children: [
              if (background != null) background!,
              ...tiles,
            ],
          ),
        );
      },
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/widgets/animations/tile_animation.dart';

class SquarePuzzleTile extends StatelessWidget {
  const SquarePuzzleTile({
    Key? key,
    required this.tile,
    required this.gridSize,
    required this.childBuilder,
    this.useCorrectPosition = false,
  }) : super(key: key);

  final SquareTile tile;
  final int gridSize;
  final WidgetBuilder childBuilder;
  final bool useCorrectPosition;

  @override
  Widget build(BuildContext context) {
    final gridScaleFactor = 4 / gridSize;
    final dimension = context.layoutSize.squareTileSize * gridScaleFactor;

    Offset offset;
    if (useCorrectPosition) {
      offset = tile.correctPosition.toOffset;
    } else {
      offset = tile.currentPosition.toOffset;
    }

    return TileAnimation(
      duration: Duration(
        milliseconds: 100 * min(gridSize, 4),
      ),
      offset: FractionalOffset.fromOffsetAndSize(
        offset,
        Size.square(gridSize - 1),
      ),
      child: SizedBox.square(
        dimension: dimension,
        child: childBuilder(context),
      ),
    );
  }
}

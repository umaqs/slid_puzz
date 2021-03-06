import 'package:flutter/material.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class PuzzleHeader<T extends PuzzleGameNotifier> extends StatelessWidget {
  const PuzzleHeader({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final T notifier;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => Padding(
        padding: kPadding16,
        child: child,
      ),
      medium: (_, child) => Padding(
        padding: kPadding24,
        child: child,
      ),
      large: (_, child) => SizedBox(
        height: ResponsiveLayoutSize.large.squareBoardSize,
        child: child,
      ),
      child: (layoutSize, _) {
        final gameState = notifier.gameState;
        return Column(
          crossAxisAlignment: layoutSize.isLarge ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            PuzzleTitle(gameState: gameState),
            if (gameState.inProgress || gameState.paused) ...[
              const ResponsiveGap(small: 8, medium: 12, large: 24),
              PuzzleGameplayInfo(
                numberOfMoves: notifier.moveCount,
                numberOfTilesLeft: notifier.puzzle.tiles.length - notifier.puzzle.numberOfCorrectTiles - 1,
              ),
            ],
          ],
        );
      },
    );
  }
}

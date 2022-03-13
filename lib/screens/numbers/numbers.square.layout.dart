import 'package:flutter/material.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class NumbersSquareLayout implements PageLayoutDelegate<SquarePuzzleNotifier> {
  const NumbersSquareLayout(this.notifier);

  @override
  final SquarePuzzleNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return PuzzleHeader(notifier: notifier);
  }

  @override
  Widget body(BuildContext context, BoxConstraints constraints) {
    return PuzzleBoard.square(
      tiles: [
        for (var i = 0; i < notifier.puzzle.tiles.length; i++) gridItem(context, i),
      ],
    );
  }

  @override
  Widget endSection(BuildContext context, BoxConstraints constraints) {
    final gameState = notifier.gameState;

    return PuzzleFooter(
      gameState: gameState,
      gridSizePicker: GridSizePicker(
        initialValue: notifier.gridSize,
        min: notifier.minSize,
        max: notifier.maxSize,
        onChanged: gameState.canInteract ? (value) => notifier.gridSize = value : null,
      ),
      primaryButton: PrimaryButton(
        text: _primaryButtonTitle(gameState),
        onPressed: gameState.canInteract ? notifier.nextState : null,
      ),
      secondaryButton: gameState.inProgress ? const SolveButton() : null,
    );
  }

  String _primaryButtonTitle(GameState gameState) {
    switch (gameState) {
      case GameState.gettingReady:
      case GameState.ready:
        return 'Start';
      case GameState.inProgress:
        return 'Pause';
      case GameState.paused:
        return 'Resume';
      case GameState.completed:
        return 'Restart';
    }
  }

  @override
  Widget gridItem(BuildContext context, int index) {
    final tile = notifier.puzzle.tiles[index];
    return SquarePuzzleTile(
      key: Key('square_puzzle_tile_${tile.value}'),
      tile: tile,
      gridSize: notifier.gridSize,
      childBuilder: (context) => tile.isWhitespace
          ? const SizedBox.shrink()
          : _buildNumberSquareTile(
              context,
              tile,
            ),
    );
  }

  Widget _buildNumberSquareTile(BuildContext context, SquareTile tile) {
    final colors = context.colors;
    final layoutSize = context.layoutSize;
    final gridScaleFactor = 4 / notifier.gridSize;
    final tileFontSize = layoutSize.tileFontSize * gridScaleFactor;

    final gameState = notifier.gameState;
    final showCorrectTileIndicator = tile.hasCorrectPosition && (gameState.inProgress || gameState.isCompleted);
    return SquareButton(
      borderRadius: 8,
      elevation: showCorrectTileIndicator ? 0 : 16,
      margin: layoutSize.isSmall ? kPadding2 : kPadding4,
      borderColor: showCorrectTileIndicator ? colors.primary : null,
      onTap: () {
        if (notifier.isSolving) {
          return;
        }
        notifier.moveTile(tile);
      },
      child: Center(
        child: Text(
          (tile.value + 1).toString(),
          textAlign: TextAlign.center,
          style: PuzzleTextStyle.headline2.copyWith(
            fontSize: tileFontSize,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}

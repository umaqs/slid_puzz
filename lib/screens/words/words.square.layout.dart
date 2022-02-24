import 'package:flutter/material.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/game/words/words.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class WordsSquareLayout implements PageLayoutDelegate<WordsSquarePuzzleNotifier> {
  const WordsSquareLayout(this.notifier);

  final WordsSquarePuzzleNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return PuzzleHeader(notifier: notifier);
  }

  @override
  Widget body(context, constraints) {
    return SquarePuzzleBoard(
      gridSize: notifier.gridSize,
      tiles: [
        for (var i = 0; i < notifier.puzzle.tiles.length; i++) gridItem(context, i),
      ],
    );
  }

  @override
  Widget endSection(context, constraints) {
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
      secondaryButton: SecondaryButton(
        text: 'Refresh',
        onPressed: gameState.canInteract ? () => notifier.generatePuzzle() : null,
      ),
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
      childBuilder: (context, layoutSize) => _buildNumberSquareTile(
        context,
        tile,
        layoutSize,
      ),
    );
  }

  Widget _buildNumberSquareTile(BuildContext context, SquareTile tile, ResponsiveLayoutSize layoutSize) {
    final colors = context.colors;

    final gridScaleFactor = 4 / notifier.gridSize;
    final tileFontSize = layoutSize.tileFontSize * gridScaleFactor;

    return Opacity(
      opacity: tile.isWhitespace ? 0.2 : 1,
      child: SquareButton(
        key: Key('tile_button_${tile.value}'),
        borderRadius: 8,
        elevation: 16,
        onTap: tile.isWhitespace ? null : () => notifier.moveTile(tile),
        child: Center(
          child: Text(
            notifier.letters[tile.value].toUpperCase(),
            textAlign: TextAlign.center,
            style: PuzzleTextStyle.headline2.copyWith(
              fontSize: tileFontSize,
              color: colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

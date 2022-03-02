import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class NumbersSquareLayout implements PageLayoutDelegate<SquarePuzzleNotifier> {
  const NumbersSquareLayout(this.notifier);

  final SquarePuzzleNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return PuzzleHeader(notifier: notifier);
  }

  @override
  Widget body(context, constraints) {
    return PuzzleBoard.square(
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
      secondaryButton: gameState.inProgress
          ? PrimaryButton(
              text: 'RESTART',
              onPressed: gameState.canInteract ? () => notifier.generatePuzzle(startGame: true, shuffle: true) : null,
            )
          : null,
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
      childBuilder: (context, layoutSize) => tile.isWhitespace
          ? const SizedBox.shrink()
          : _buildNumberSquareTile(
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

    final gameState = notifier.gameState;
    final showCorrectTileIndicator = tile.hasCorrectPosition && (gameState.inProgress || gameState.completed);
    return SquareButton(
      key: Key('tile_button_${tile.value}'),
      borderRadius: 8,
      elevation: showCorrectTileIndicator ? 0 : 16,
      borderColor: showCorrectTileIndicator ? colors.primary : null,
      onTap: () {
        final audio = context.read<AudioNotifier>();
        final canMove = notifier.puzzle.isTileMovable(tile);
        if (gameState.inProgress && canMove) {
          audio.play(AudioAssets.tileMove);
        } else {
          audio.play(AudioAssets.dumbbell);
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

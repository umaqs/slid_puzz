import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/hex/puzzle.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class NumbersHexLayout implements PageLayoutDelegate<HexPuzzleNotifier> {
  const NumbersHexLayout(this.notifier);

  @override
  final HexPuzzleNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return PuzzleHeader(notifier: notifier);
  }

  @override
  Widget body(BuildContext context, BoxConstraints constraints) {
    return PuzzleBoard.hex(
      tiles: [
        for (var i = 0; i < notifier.puzzle.tiles.length; i++) gridItem(context, i),
      ],
    );
  }

  @override
  Widget endSection(BuildContext context, BoxConstraints constraints) {
    final gameState = notifier.gameState;
    return IgnorePointer(
      ignoring: notifier.isSolving,
      child: PuzzleFooter(
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
            ? notifier.canSolve
                ? PrimaryButton(
                    text: 'SOLVE',
                    onPressed: gameState.canInteract ? () => notifier.findSolution() : null,
                  )
                : PrimaryButton(
                    text: 'RESTART',
                    onPressed:
                        gameState.canInteract ? () => notifier.generatePuzzle(startGame: true, shuffle: true) : null,
                  )
            : null,
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
    if (tile.isWhitespace) {
      return const SizedBox.shrink();
    }
    return HexPuzzleTile(
      key: Key('hex_puzzle_tile_${tile.value}'),
      gridDepth: notifier.gridSize,
      color: context.colors.surface,
      offset: tile.currentPosition.toOffset,
      childBuilder: (context, layoutSize) => _buildNumberHexTile(
        context,
        tile,
        layoutSize,
      ),
    );
  }

  Widget _buildNumberHexTile(BuildContext context, HexTile tile, ResponsiveLayoutSize layoutSize) {
    final colors = context.colors;

    final gridScaleFactor = 4 / notifier.gridSize;
    final tileFontSize = 18 * gridScaleFactor;

    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          context.read<AudioNotifier>().play(AudioAssets.tileMove);
          notifier.moveTile(tile);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  (tile.value + 1).toString(),
                  textAlign: TextAlign.center,
                  style: PuzzleTextStyle.headline2.copyWith(
                    fontSize: tileFontSize,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

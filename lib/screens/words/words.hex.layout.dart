import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/hex/puzzle.dart';
import 'package:slide_puzzle/game/words/words.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class WordsHexLayout implements PageLayoutDelegate<WordsHexPuzzleNotifier> {
  const WordsHexLayout(this.notifier);

  @override
  final WordsHexPuzzleNotifier notifier;

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
    return PuzzleFooter(
      gameState: notifier.gameState,
      primaryButton: PrimaryButton(
        text: _primaryButtonTitle(notifier.gameState),
        onPressed: notifier.gameState.canInteract ? notifier.nextState : null,
      ),
      secondaryButton: SecondaryButton(
        text: 'REFRESH',
        onPressed: notifier.gameState.canInteract ? () => notifier.generatePuzzle() : null,
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
    return HexPuzzleTile(
      key: Key('hex_puzzle_tile_${tile.value}'),
      showWhitespaceTile: tile.isWhitespace,
      gridDepth: notifier.gridSize,
      color: context.colors.surface,
      offset: tile.currentPosition.toOffset,
      childBuilder: (context, layoutSize) => _buildWordHexTile(
        context,
        tile,
        layoutSize,
      ),
    );
  }

  Widget _buildWordHexTile(BuildContext context, HexTile tile, ResponsiveLayoutSize layoutSize) {
    final colors = context.colors;

    final gridScaleFactor = 4 / notifier.gridSize;
    final tileFontSize = 16 * gridScaleFactor;

    return SizedBox.expand(
      child: GestureDetector(
        onTap: tile.isWhitespace
            ? null
            : () {
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
                  notifier.letters[tile.value].toUpperCase(),
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

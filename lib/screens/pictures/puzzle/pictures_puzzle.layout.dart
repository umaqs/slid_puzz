import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/screens/pictures/puzzle/puzzle.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class PicturePuzzleLayout implements PageLayoutDelegate<PicturesPuzzleNotifier> {
  const PicturePuzzleLayout(this.notifier);

  @override
  final PicturesPuzzleNotifier notifier;

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

    return IgnorePointer(
      ignoring: notifier.isSolving,
      child: PuzzleFooter(
        gameState: gameState,
        showValueCheckbox: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Show solution'),
            CheckboxTheme(
              data: CheckboxThemeData(
                fillColor: MaterialStateProperty.all(context.colors.primary),
              ),
              child: Checkbox(
                value: notifier.showSolution,
                fillColor: MaterialStateProperty.all(context.colors.primary),
                onChanged: (value) => notifier.showSolution = value,
              ),
            ),
          ],
        ),
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
    return SquarePuzzleTile(
      key: Key('square_puzzle_tile_${tile.value}'),
      tile: tile,
      gridSize: notifier.gridSize,
      useCorrectPosition: notifier.showSolution,
      childBuilder: (context, layoutSize) => tile.isWhitespace
          ? const SizedBox.shrink()
          : _buildPictureSquareTile(
              context,
              tile,
              layoutSize,
            ),
    );
  }

  Widget _buildPictureSquareTile(
    BuildContext context,
    SquareTile tile,
    ResponsiveLayoutSize layoutSize,
  ) {
    final isLoading = notifier.isLoading || notifier.puzzle.tiles.length != notifier.imageParts.length;

    if (isLoading) {
      return Shimmer(
        gradient: context.getMenuLoaderGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        period: const Duration(seconds: 3),
        child: SquareButton(
          borderRadius: 8,
          disableShadows: true,
          color: context.colors.primary,
        ),
      );
    }

    return SquareButton(
      color: Colors.transparent,
      borderRadius: 8,
      onTap: () {
        context.read<AudioNotifier>().play(AudioAssets.tileMove);
        notifier.moveTile(tile);
      },
      child: Image.memory(notifier.imageParts[tile.value]),
    );
  }
}

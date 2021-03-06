import 'package:flutter/material.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/helpers/helpers.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';

enum BoardType { square, hex }

class PuzzleBoard extends StatefulWidget {
  const PuzzleBoard.square({
    Key? key,
    required this.tiles,
    this.background,
  })  : type = BoardType.square,
        super(key: key);

  const PuzzleBoard.hex({
    Key? key,
    required this.tiles,
  })  : type = BoardType.hex,
        background = null,
        super(key: key);

  final List<Widget> tiles;
  final Widget? background;
  final BoardType type;

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  final _boardKey = GlobalKey();

  bool _shownCompletedDialog = false;

  @override
  Widget build(BuildContext context) {
    final layoutSize = context.layoutSize;
    return Listen<PuzzleGameNotifier>(
      listener: (notifier) {
        if (notifier.gameState.isCompleted && !_shownCompletedDialog) {
          _shownCompletedDialog = true;
          Future.delayed(
            const Duration(seconds: 1),
            () => showGameCompletedDialog(
              context,
              _boardKey,
            ),
          );
        } else {
          _shownCompletedDialog = false;
        }
      },
      child: RepaintBoundary(
        key: _boardKey,
        child: SizedBox.square(
          dimension: widget.type == BoardType.square ? layoutSize.squareBoardSize : layoutSize.hexBoardSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.background != null) widget.background!,
              ...widget.tiles,
            ],
          ),
        ),
      ),
    );
  }
}

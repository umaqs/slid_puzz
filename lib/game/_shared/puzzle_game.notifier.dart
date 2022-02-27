import 'package:slide_puzzle/screens/_base/base.notifier.dart';

import 'shared.dart';

abstract class PuzzleGameNotifier<T extends Tile> extends BaseNotifier {
  PuzzleGameNotifier();

  int get minSize;

  int get maxSize;

  int get gridSize;

  set gridSize(int value);

  int get moveCount;

  GameState get gameState;

  GridPuzzle<T> get puzzle;

  bool get isCompleted;

  Future<void> generatePuzzle({bool startGame = false, bool shuffle = false});

  void moveTile(T tile);

  bool showCorrectTileIndicator(T tile);
}

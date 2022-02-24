import 'shared.dart';

abstract class PuzzleGameNotifier<T extends Tile> extends GameTimerNotifier {
  PuzzleGameNotifier(Ticker ticker) : super(ticker);

  int get minSize;

  int get maxSize;

  int get gridSize;

  set gridSize(int value);

  int get moveCount;

  int get secondsToBegin;

  GameState get gameState;

  GridPuzzle<T> get puzzle;

  bool get isCompleted;

  Future<void> generatePuzzle({bool startGame = false, int shuffleIterations = 0, bool addDelay = false});

  void moveTile(T tile);

  bool showCorrectTileIndicator(T tile);
}

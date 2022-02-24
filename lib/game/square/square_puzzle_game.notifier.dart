import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';

class SquarePuzzleNotifier extends GameTimerNotifier implements PuzzleGameNotifier<SquareTile> {
  SquarePuzzleNotifier({
    int initialGridSize = 4,
  })  : assert(
          initialGridSize >= _minGridSize && initialGridSize <= _maxGridSize,
          'Grid size should range from $_minGridSize to $_maxGridSize',
        ),
        _gridSize = initialGridSize,
        _gameState = GameState.gettingReady,
        super(const Ticker()) {
    generatePuzzle();
  }

  static const _minGridSize = 3;
  static const _maxGridSize = 6;

  int get minSize => _minGridSize;

  int get maxSize => _maxGridSize;

  int get gridSize => _gridSize;
  int _gridSize;

  int get moveCount => _moveCount;
  int _moveCount = 0;

  GameState get gameState => _gameState;
  GameState _gameState;

  SquareGridPuzzle get puzzle => _puzzle;
  late SquareGridPuzzle _puzzle;

  set gridSize(int value) {
    if (value == _gridSize) {
      return;
    }
    if (value >= minSize && value <= maxSize) {
      _gridSize = value;

      generatePuzzle();
    }
  }

  bool get isCompleted => _puzzle.isComplete;

  @override
  bool showCorrectTileIndicator(SquareTile tile) {
    if (tile.isWhitespace) {
      return false;
    }
    if (!_gameState.inProgress || !_gameState.completed) {
      return false;
    }
    return tile.hasCorrectPosition;
  }

  @override
  Future<void> generatePuzzle({
    bool startGame = false,
    int shuffleIterations = 0,
    bool addDelay = false,
  }) async {
    stop();
    _gameState = GameState.gettingReady;
    notifyListeners();

    if (shuffleIterations > 0 && addDelay) {
      startCountdown(countdownSeconds: shuffleIterations);
    }

    final correctPositions = <SquarePosition>[];
    final currentPositions = <SquarePosition>[];

    // Create all possible board positions.
    for (var y = 0; y < _gridSize; y++) {
      for (var x = 0; x < _gridSize; x++) {
        final position = SquarePosition(x, y);
        correctPositions.add(position);
        currentPositions.add(position);
      }
    }

    var tiles = _generateTileListFromPositions(correctPositions, currentPositions);

    var puzzle = SquareGridPuzzle(tiles: tiles);

    if (shuffleIterations != 0) {
      while (!puzzle.isSolvable() || puzzle.numberOfCorrectTiles != 0) {
        currentPositions.shuffle();
        tiles = _generateTileListFromPositions(
          correctPositions,
          currentPositions,
        );
        puzzle = SquareGridPuzzle(tiles: tiles);
      }

      // for (var i = 0; i < shuffleIterations; i++) {
      //   _secondsToBegin = shuffleIterations - i;
      //   notifyListeners();
      //   _shuffleTilesAndCreatePuzzle(tiles, tileShuffleIterations: _gridSize * 100);
      //   notifyListeners();
      //   if (addDelay) {
      //     await Future<void>.delayed(const Duration(seconds: 1));
      //   }
      // }
    }

    _puzzle = SquareGridPuzzle(tiles: puzzle.sort());
    if (startGame) {
      start();
    } else {
      _gameState = GameState.ready;
      notifyListeners();
    }
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<SquareTile> _generateTileListFromPositions(
    List<SquarePosition> correctPositions,
    List<SquarePosition> currentPositions,
  ) {
    final tileCount = _gridSize * _gridSize;

    return List.generate(
      tileCount,
      (i) => SquareTile(
        value: i,
        correctPosition: correctPositions[i],
        currentPosition: currentPositions[i],
        isWhitespace: i == tileCount - 1,
      ),
    );
  }

  Future<void> _shuffleTilesAndCreatePuzzle(List<SquareTile> tiles, {int tileShuffleIterations = 200}) async {
    final random = Random();

    _puzzle = SquareGridPuzzle(tiles: [...tiles]);
    while (tileShuffleIterations > 0) {
      final moveIndex = random.nextInt(_puzzle.tiles.length);
      final tileToMove = _puzzle.tiles[moveIndex];
      if (_puzzle.isTileMovable(tileToMove)) {
        _puzzle = SquareGridPuzzle(
          tiles: _puzzle.moveTiles(tileToMove, []).sort(),
        );
        tileShuffleIterations--;
      }
    }
  }

  void moveTile(SquareTile tile) {
    if (_gameState.inProgress) {
      if (_puzzle.isTileMovable(tile)) {
        final mutablePuzzle = SquareGridPuzzle(tiles: [..._puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tile, []);
        _puzzle = SquareGridPuzzle(tiles: puzzle.sort());
        if (isCompleted) {
          _gameState = GameState.completed;
        }
        _moveCount++;
        notifyListeners();
      }
    }
  }

  void nextState() {
    switch (_gameState) {
      case GameState.gettingReady:
        break;
      case GameState.ready:
        generatePuzzle(startGame: true, shuffleIterations: 3, addDelay: true);
        break;
      case GameState.inProgress:
        pause();
        break;
      case GameState.paused:
        start();
        break;
      case GameState.completed:
        generatePuzzle(startGame: true, shuffleIterations: 3, addDelay: true);
        break;
    }
  }

  @override
  @protected
  void start() {
    _gameState = GameState.inProgress;
    super.start();
  }

  @override
  @protected
  void pause() {
    _gameState = GameState.paused;
    super.pause();
  }
}

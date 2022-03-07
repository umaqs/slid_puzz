import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/_shared/solver/puzzle.solver.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

class SquarePuzzleNotifier extends BaseNotifier implements PuzzleGameNotifier<SquareTile> {
  SquarePuzzleNotifier(
    this._countdown,
    this._timer, {
    int initialGridSize = 4,
  })  : assert(
          initialGridSize >= _minGridSize && initialGridSize <= _maxGridSize,
          'Grid size should range from $_minGridSize to $_maxGridSize',
        ),
        _gridSize = initialGridSize,
        _gameState = GameState.gettingReady {
    generatePuzzle();
  }

  static const _minGridSize = 3;
  static const _maxGridSize = 6;

  final CountdownNotifier _countdown;
  final GameTimerNotifier _timer;

  @override
  int get minSize => _minGridSize;

  @override
  int get maxSize => _maxGridSize;

  @override
  int get gridSize => _gridSize;
  int _gridSize;

  @override
  int get moveCount => _moveCount;
  int _moveCount = 0;

  @override
  GameState get gameState => _gameState;
  GameState _gameState;

  @override
  bool get isSolving => _isSolving;
  bool _isSolving = false;

  @override
  SquareGridPuzzle get puzzle => _puzzle;
  late SquareGridPuzzle _puzzle;

  @override
  set gridSize(int value) {
    if (value == _gridSize) {
      return;
    }
    if (value >= minSize && value <= maxSize) {
      _gridSize = value;
      generatePuzzle();
      notifyListeners();
    }
  }

  @override
  bool get isCompleted => _puzzle.isComplete;

  bool get canSolve => !kIsWeb || gridSize <= minSize + 1;

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
    bool shuffle = false,
  }) async {
    _getReady();

    final correctPositions = _generatePositions();
    final currentPositions = [...correctPositions];

    var tiles = _generateTileListFromPositions(correctPositions, currentPositions);
    _puzzle = SquareGridPuzzle(tiles: tiles);

    if (shuffle) {
      while (!puzzle.isSolvable() || puzzle.numberOfCorrectTiles != 0) {
        currentPositions.shuffle();
        tiles = _generateTileListFromPositions(
          correctPositions,
          currentPositions,
        );
        _puzzle = SquareGridPuzzle(tiles: tiles).sort();
      }
    }

    if (startGame) {
      _countdown.start(onComplete: start);
    } else {
      _gameState = GameState.ready;
      notifyListeners();
    }
  }

  @override
  Future<void> findSolution() async {
    _isSolving = true;
    notifyListeners();

    final correctPositions = _generatePositions();
    final currentPositions = [...correctPositions];
    final tiles = _generateTileListFromPositions(correctPositions, currentPositions);
    final start = SquareGridPuzzle(tiles: [...puzzle.tiles]);
    final goal = SquareGridPuzzle(tiles: tiles);

    final solver = PuzzleSolver<SquareTile>(
      start: start,
      goal: goal,
    );

    final solution = (await solver.solve()).toList();

    // rewind
    _puzzle = start;
    if (kDebugMode) {
      print(solution.map((tile) => '${tile.value + 1}').toList().join(','));
    }
    for (final tile in solution) {
      moveTile(tile);
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void moveTile(SquareTile tile) {
    if (_gameState.inProgress) {
      if (_puzzle.isTileMovable(tile)) {
        final mutablePuzzle = SquareGridPuzzle(tiles: [..._puzzle.tiles]);
        _puzzle = mutablePuzzle.moveTiles(tile, []).sort();
        if (isCompleted) {
          _gameState = GameState.completed;
          _isSolving = false;
          _timer.pause();
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
      case GameState.completed:
        generatePuzzle(startGame: true, shuffle: true);
        break;
      case GameState.inProgress:
        pause();
        break;
      case GameState.paused:
        start();
        break;
    }
  }

  void pause() {
    _gameState = GameState.paused;
    _timer.pause();
    notifyListeners();
  }

  void start() {
    _gameState = GameState.inProgress;
    _timer.start();
    notifyListeners();
  }

  void _getReady() {
    _moveCount = 0;
    _gameState = GameState.gettingReady;
    _timer.stop();
    notifyListeners();
  }

  /// Create all possible board positions.
  List<SquarePosition> _generatePositions() {
    final positions = <SquarePosition>[];

    for (var y = 0; y < _gridSize; y++) {
      for (var x = 0; x < _gridSize; x++) {
        final position = SquarePosition(x, y);
        positions.add(position);
      }
    }

    return positions;
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
}

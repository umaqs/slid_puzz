import 'dart:async';

import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/audio/audio.notifier.dart';
import 'package:slide_puzzle/game/_shared/puzzle.game.solver_extension.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/hex/puzzle.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

class HexPuzzleNotifier extends BaseNotifier implements PuzzleGameNotifier<HexTile> {
  HexPuzzleNotifier(
    this._audio,
    this._countdown,
    this._timer, {
    int initialDepth = 2,
  })  : assert(
          initialDepth >= _minDepth && initialDepth <= _maxDepth,
          'Depth should range from $_minDepth to $_maxDepth',
        ),
        _gridDepth = initialDepth,
        _gameState = GameState.gettingReady {
    generatePuzzle();
  }

  final AudioNotifier _audio;
  final CountdownNotifier _countdown;
  final GameTimerNotifier _timer;

  static const _minDepth = 1;
  static const _maxDepth = 4;

  @override
  int get minSize => _minDepth;

  @override
  int get maxSize => _maxDepth;

  int get _maxHexCount => 1 + (_gridDepth * 2);

  @override
  int get gridSize => _gridDepth;
  int _gridDepth;

  @override
  int get moveCount => _moveCount;
  int _moveCount = 0;

  @override
  GameState get gameState => _gameState;
  GameState _gameState;

  @override
  HexGridPuzzle get puzzle => _puzzle;
  late HexGridPuzzle _puzzle;

  @override
  bool get isSolving => _isSolving;
  bool _isSolving = false;

  @override
  num get solvingThresholdFactor => _thresholdsMap[_gridDepth]!;
  final _thresholdsMap = const {1: 0, 2: 0.9, 3: 0.95, 4: 0.97};

  @override
  set gridSize(int value) {
    if (value == _gridDepth) {
      return;
    }
    if (value >= minSize && value <= maxSize) {
      _gridDepth = value;
      generatePuzzle();
      notifyListeners();
    }
  }

  @override
  bool get isCompleted => _puzzle.isComplete;

  @override
  bool showCorrectTileIndicator(HexTile tile) {
    if (tile.isWhitespace) {
      return false;
    }
    if (!_gameState.inProgress || !_gameState.isCompleted) {
      return false;
    }
    return tile.hasCorrectPosition;
  }

  @override
  HexGridPuzzle getSolvedPuzzle() {
    final correctPositions = _generatePositions();
    final currentPositions = [...correctPositions];
    final tiles = _generateTileListFromPositions(correctPositions, currentPositions);
    return HexGridPuzzle(tiles: tiles);
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
    _puzzle = HexGridPuzzle(tiles: tiles);

    if (shuffle) {
      while (puzzle.numberOfCorrectTiles != 0) {
        currentPositions.shuffle();
        tiles = _generateTileListFromPositions(
          correctPositions,
          currentPositions,
        );
        _puzzle = HexGridPuzzle(tiles: tiles).sort();
      }
    }

    if (startGame) {
      _audio.play(AudioAssets.shuffle);
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

    final solved = await solve<HexTile>(distanceThreshold: 3);
    if (_isSolving && !solved) {
      _isSolving = false;
      notifyListeners();
    }
  }

  @override
  Future<void> moveTile(HexTile tile) async {
    if (_gameState.inProgress) {
      if (_puzzle.isTileMovable(tile)) {
        _audio.play(AudioAssets.tileMove);
        final mutablePuzzle = HexGridPuzzle(tiles: [..._puzzle.tiles]);
        _puzzle = mutablePuzzle.moveTiles(tile, []).sort();
        if (isCompleted) {
          _gameState = GameState.completed;
          _isSolving = false;
          _timer.pause();
        }
        _moveCount++;
        notifyListeners();
      } else {
        _audio.play(AudioAssets.sandwich);
      }
    }
  }

  void nextState() {
    _isSolving = false;

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
  List<HexPosition> _generatePositions() {
    final positions = <HexPosition>[];

    for (var mainIndex = 0; mainIndex < _maxHexCount; mainIndex++) {
      final r = mainIndex - _gridDepth;
      final crossCount = _maxHexCount - r.abs();
      for (var crossIndex = 0; crossIndex < crossCount; crossIndex++) {
        int q;
        if (r <= 0) {
          q = -_gridDepth - r + crossIndex;
        } else {
          q = -_gridDepth + crossIndex;
        }

        final position = HexPosition.axial(q, r);
        positions.add(position);
      }
    }

    return positions;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<HexTile> _generateTileListFromPositions(
    List<HexPosition> correctPositions,
    List<HexPosition> currentPositions,
  ) {
    return List.generate(
      currentPositions.length,
      (i) => HexTile(
        value: i,
        correctPosition: correctPositions[i],
        currentPosition: currentPositions[i],
        isWhitespace: i == correctPositions.length - 1,
      ),
    );
  }
}

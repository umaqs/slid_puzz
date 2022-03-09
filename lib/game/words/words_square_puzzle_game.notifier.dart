import 'dart:async';
import 'dart:math';

import 'package:slide_puzzle/game/_shared/puzzle.game.solver_extension.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/game/words/data/_data.dart';

class WordsSquarePuzzleNotifier extends SquarePuzzleNotifier {
  WordsSquarePuzzleNotifier(
    CountdownNotifier countdown,
    GameTimerNotifier timer, {
    int initialGridSize = 4,
  })  : _letters = [],
        super(
          countdown,
          timer,
          initialGridSize: initialGridSize,
        );

  @override
  int get minSize => 3;

  @override
  int get maxSize => 6;

  List<String> get letters => List.unmodifiable(_letters);
  List<String> _letters;

  @override
  bool get isSolving => _isSolving;
  bool _isSolving = false;

  bool shouldHighlightTile(int index) {
    if (gameState.isCompleted) {
      return true;
    }

    if (gameState.inProgress) {
      final tile = puzzle.tiles[index];
      return tile.hasCorrectPosition || letters[index] == letters[tile.value];
    }
    return false;
  }

  List<String> get actualAnswers {
    return [
      for (var i = 0; i < gridSize; i++) ...[
        _letters.skip(gridSize * i).take(gridSize).join(),
      ],
    ];
  }

  @override
  bool get isCompleted {
    if (super.isCompleted) {
      return true;
    }

    return _hasMatchingWords();
  }

  @override
  Future<void> findSolution() async {
    _isSolving = true;
    notifyListeners();

    final solved = await solve<SquareTile>(distanceThreshold: gridSize);
    if (_isSolving && !solved) {
      _isSolving = false;
      notifyListeners();
    }
  }

  @override
  void nextState() {
    _isSolving = false;
    switch (gameState) {
      case GameState.gettingReady:
        break;
      case GameState.ready:
        _shuffle(startGame: true);
        break;
      case GameState.inProgress:
        pause();
        break;
      case GameState.paused:
        start();
        break;
      case GameState.completed:
        generatePuzzle(startGame: true, shuffle: true);
        break;
    }
  }

  Future<void> _shuffle({bool startGame = false}) async {
    return super.generatePuzzle(startGame: startGame, shuffle: true);
  }

  @override
  Future<void> generatePuzzle({
    bool startGame = false,
    bool shuffle = false,
  }) async {
    final solutionGrid = solutions[gridSize]!.keys;

    final random = Random();
    _letters = [
      for (var i = 0; i < gridSize; i++) ...[
        ...solutionGrid.elementAt(random.nextInt(solutionGrid.length)).split(''),
      ],
    ];
    super.generatePuzzle(
      startGame: startGame,
      shuffle: shuffle,
    );
  }

  bool _hasMatchingWords() {
    final tiles = puzzle.tiles;

    final words = [
      for (var i = 0; i < gridSize; i++) ...[
        tiles.skip(gridSize * i).take(gridSize).map((tile) => _letters[tile.value]).join(),
      ],
    ];

    final dictGrid = dictionaries[gridSize]!;
    final solutions = [
      for (var i = 0; i < gridSize; i++) dictGrid.containsKey(words[i]),
    ];

    return solutions.every((solution) => solution);
  }
}

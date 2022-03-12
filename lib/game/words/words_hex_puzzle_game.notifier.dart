import 'dart:async';
import 'dart:math';

import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/puzzle.game.solver_extension.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/hex/puzzle.dart';
import 'package:slide_puzzle/game/words/data/_data.dart';

class WordsHexPuzzleNotifier extends HexPuzzleNotifier {
  WordsHexPuzzleNotifier(
    AudioNotifier audio,
    CountdownNotifier countdown,
    GameTimerNotifier timer,
  )   : _letters = [],
        super(
          audio,
          countdown,
          timer,
          initialDepth: _depth,
        );

  static const _depth = 2;

  @override
  int get minSize => _depth;

  @override
  int get maxSize => _depth;

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
      _letters.take(3).join(),
      _letters.skip(3).take(4).join(),
      _letters.skip(3 + 4).take(5).join(),
      _letters.skip(3 + 4 + 5).take(4).join(),
      _letters.skip(3 + 4 + 5 + 4).take(3).join(),
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

    final solved = await solve<HexTile>(distanceThreshold: 3);
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
    final solution3 = solutions[3]!.keys;
    final solution4 = solutions[4]!.keys;
    final solution5 = solutions[5]!.keys;

    final random = Random();
    _letters = [
      ...solution3.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution4.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution5.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution4.elementAt(random.nextInt(solution3.length)).split(''),
      ...solution3.elementAt(random.nextInt(solution3.length)).split(''),
    ];
    super.generatePuzzle(
      startGame: startGame,
      shuffle: shuffle,
    );
  }

  bool _hasMatchingWords() {
    final tiles = puzzle.tiles;

    final words = [
      tiles.take(3).map((tile) => _letters[tile.value]).join(),
      tiles.skip(3).take(4).map((tile) => _letters[tile.value]).join(),
      tiles.skip(3 + 4).take(5).map((tile) => _letters[tile.value]).join(),
      tiles.skip(3 + 4 + 5).take(4).map((tile) => _letters[tile.value]).join(),
      tiles.skip(3 + 4 + 5 + 4).take(3).map((tile) => _letters[tile.value]).join(),
    ];

    final solutions = [
      for (final word in words) dictionaries[word.length]!.containsKey(word),
    ];

    return solutions.every((solution) => solution);
  }
}

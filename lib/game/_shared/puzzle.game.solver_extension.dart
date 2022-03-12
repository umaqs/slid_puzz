import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:slide_puzzle/game/_shared/game_state.dart';
import 'package:slide_puzzle/game/_shared/models/models.dart';
import 'package:slide_puzzle/game/_shared/puzzle_game.notifier.dart';
import 'package:slide_puzzle/game/_shared/solver/puzzle.solver.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';

extension SolverExtension on PuzzleGameNotifier {
  Future<bool> solve<T extends Tile>({required num distanceThreshold}) async {
    final goal = getSolvedPuzzle();
    final snackBar = SnackBarService.instance;
    final targetDistance = puzzle.getManhattanDistance(weighted: gridSize == minSize);
    final thresholdFactor = solvingThresholdFactor;
    var threshold = targetDistance;

    while (!gameState.isCompleted) {
      threshold *= thresholdFactor;
      if (threshold <= distanceThreshold) {
        threshold = 0;
      }
      if (threshold * 2 < targetDistance) {
        if (threshold == 0 || Random().nextBool()) {
          final messages = canSolveMessages..shuffle();
          snackBar.showSnackBar(message: messages.first);
        }
      }
      if (kDebugMode) {
        print('Starting solver with distance threshold: $threshold');
      }
      final solver = PuzzleSolver<T>(
        start: puzzle as GridPuzzle<T>,
        goal: goal as GridPuzzle<T>,
        distanceThreshold: threshold,
      );

      final solution = await solver.solve();

      if (!isSolving || !mounted) {
        return false;
      }

      if (solution.isEmpty) {
        final messages = cannotSolveMessages..shuffle();
        snackBar.showSnackBar(message: messages.first, isError: true, seconds: 5);
        return false;
      }

      if (kDebugMode) {
        print(solution.map((tile) => '${tile.value + 1}').toList().join(','));
      }

      for (final tile in solution) {
        await moveTile(tile);
        await Future.delayed(const Duration(milliseconds: 500));
        if (!isSolving || !mounted) {
          return false;
        }
      }
    }

    return true;
  }
}

final canSolveMessages = [
  'Let me think... 🧠',
  'Bear with me! 🐻',
  'Watch and learn! 👆',
  'Sweaty palms 😰',
  'I think I got this! 😎',
  'Hold my cookie 🍪',
  'Almost there 😊'
];

final cannotSolveMessages = [
  'I think you got it from here! Show me some moves 💃',
  'Sorry, I am going for a coffee break! ☕️',
  'You solve some, I solve some 🥵',
  'Try again after making a few moves 🙏',
  'This is tougher than I thought, you try 🙇',
];

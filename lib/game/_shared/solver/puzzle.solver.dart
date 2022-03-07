import 'dart:async';
import 'dart:collection';

import 'package:async_task/async_task.dart';
import 'package:collection/collection.dart' show HeapPriorityQueue;
import 'package:flutter/foundation.dart';
import 'package:slide_puzzle/game/_shared/models/models.dart';
import 'package:slide_puzzle/game/_shared/solver/puzzle.node.dart';
import 'package:slide_puzzle/game/hex/hex_grid_puzzle.dart';
import 'package:slide_puzzle/game/hex/hex_tile.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';

class Result<T extends Tile> {
  Result(this.nodeCount, {this.path});

  final int nodeCount;
  final Iterable<T>? path;
}

class PuzzleSolver<T extends Tile> {
  PuzzleSolver({
    required this.start,
    required this.goal,
  }) : _queue = HeapPriorityQueue<PuzzleNode<T>>(PuzzleNode.comparator);

  final GridPuzzle<T> start;
  final GridPuzzle<T> goal;
  final HeapPriorityQueue<PuzzleNode<T>> _queue;

  final Set<String> _open = HashSet<String>();
  final Set<String> _visited = HashSet<String>();

  Future<Iterable<T>> solve() async {
    final asyncExecutor = AsyncExecutor(taskTypeRegister: _taskTypeRegister);
    final task = SolverTask<T>(this);
    await asyncExecutor.execute(task);
    final path = task.result!;
    asyncExecutor.close();
    return path;
  }

  Future<Iterable<T>> _solve() async {
    final startNode = PuzzleNode(puzzle: start, cost: 0);
    _queue
      ..clear()
      ..add(startNode);

    _visited.clear();

    _open.add(startNode.key);

    final startTime = DateTime.now();

    while (_queue.isNotEmpty) {
      final currentNode = _queue.removeFirst();

      if (currentNode.puzzle == goal) {
        if (kDebugMode) {
          print('visited nodes: ${_visited.length}');
          print('Solved in: ${DateTime.now().difference(startTime).inMilliseconds} ms');
        }
        return currentNode.getPath();
      }

      _visited.add(currentNode.key);

      final children = currentNode.getChildren(_visited);

      for (final childNode in children) {
        if (_open.contains(childNode.key)) {
          continue;
        }

        // double check to avoid loops
        if (_visited.contains(childNode.key)) {
          // this should never reach because of the check in currentNode.getChildren()
          continue;
        }

        _open.add(childNode.key);
        _queue.add(childNode);
      }
    }

    return [];
  }
}

class SolverTask<T extends Tile> extends AsyncTask<PuzzleSolver<T>, Iterable<T>> {
  SolverTask(this.solver);

  final PuzzleSolver<T> solver;

  @override
  AsyncTask<PuzzleSolver<T>, Iterable<T>> instantiate(
    PuzzleSolver<T> solver, [
    Map<String, SharedData<dynamic, dynamic>>? sharedData,
  ]) {
    return SolverTask(solver);
  }

  @override
  PuzzleSolver<T> parameters() => solver;

  @override
  Future<Iterable<T>> run() async {
    return solver._solve();
  }
}

class ExplorerTask<T extends Tile> extends AsyncTask<PuzzleNode<T>, Iterable<PuzzleNode<T>>> {
  ExplorerTask(this.node);

  final PuzzleNode<T> node;

  @override
  AsyncTask<PuzzleNode<T>, Iterable<PuzzleNode<T>>> instantiate(
    PuzzleNode<T> node, [
    Map<String, SharedData<dynamic, dynamic>>? sharedData,
  ]) {
    return ExplorerTask(node);
  }

  @override
  PuzzleNode<T> parameters() => node;

  @override
  Future<Iterable<PuzzleNode<T>>> run() async {
    return node.getChildren({});
  }
}

List<AsyncTask<dynamic, dynamic>> _taskTypeRegister() => [
      SolverTask<SquareTile>(
        PuzzleSolver(
          start: const SquareGridPuzzle(tiles: []),
          goal: const SquareGridPuzzle(tiles: []),
        ),
      ),
      SolverTask<HexTile>(
        PuzzleSolver(
          start: const HexGridPuzzle(tiles: []),
          goal: const HexGridPuzzle(tiles: []),
        ),
      ),
      ExplorerTask<SquareTile>(
        PuzzleNode<SquareTile>(
          puzzle: const SquareGridPuzzle(tiles: []),
          cost: 0,
        ),
      ),
      ExplorerTask<HexTile>(
        PuzzleNode<HexTile>(
          puzzle: const HexGridPuzzle(tiles: []),
          cost: 0,
        ),
      ),
    ];

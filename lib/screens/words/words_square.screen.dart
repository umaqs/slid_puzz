import 'package:flutter/material.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/game/words/words.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/screens/words/words.dart';
import 'package:slide_puzzle/screens/words/words.square.layout.dart';

class WordsSquareScreen extends StatelessWidget {
  const WordsSquareScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final WordsSquarePuzzleNotifier notifier;

  static ScaleTransitionPage buildPage(BuildContext context) {
    return ScaleTransitionPage(
      key: ValueKey(RouteNames.wordsSquare),
      child: ProvideNotifier<WordsSquarePuzzleNotifier>(
        watch: true,
        create: (context) => WordsSquarePuzzleNotifier(),
        builder: (context, notifier) => WordsSquareScreen._(notifier: notifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAwareScaffold(
      pageLayoutDelegate: WordsSquareLayout(notifier),
    );
  }
}

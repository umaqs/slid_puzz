import 'package:flutter/material.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/game/words/words.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/screens/words/words.dart';

class WordsHexScreen extends StatelessWidget {
  const WordsHexScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final WordsHexPuzzleNotifier notifier;

  static ScaleTransitionPage buildPage(BuildContext context) {
    return ScaleTransitionPage(
      key: ValueKey(RouteNames.wordsHex),
      child: ProvideNotifier<WordsHexPuzzleNotifier>(
        watch: true,
        create: (context) => WordsHexPuzzleNotifier(),
        builder: (context, notifier) => WordsHexScreen._(notifier: notifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAwareScaffold(
      pageLayoutDelegate: WordsHexLayout(notifier),
    );
  }
}

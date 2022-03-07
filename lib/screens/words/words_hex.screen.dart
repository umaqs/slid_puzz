import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
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
      key: const ValueKey(RouteNames.wordsHex),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameTimerNotifier>(create: (_) => GameTimerNotifier(const Ticker())),
          ChangeNotifierProvider<CountdownNotifier>(create: (_) => CountdownNotifier(const Ticker())),
        ],
        builder: (_, __) => ProvideNotifier<PuzzleGameNotifier>(
          watch: true,
          create: (context) => WordsHexPuzzleNotifier(
            context.read<CountdownNotifier>(),
            context.read<GameTimerNotifier>(),
          ),
          builder: (_, notifier) => WordsHexScreen._(notifier: notifier as WordsHexPuzzleNotifier),
        ),
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

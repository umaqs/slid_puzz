import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
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
      key: const ValueKey(RouteNames.wordsSquare),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameTimerNotifier>(create: (_) => GameTimerNotifier(const Ticker())),
          ChangeNotifierProvider<CountdownNotifier>(create: (_) => CountdownNotifier(const Ticker())),
        ],
        builder: (_, __) => ProvideNotifier<PuzzleGameNotifier>(
          watch: true,
          create: (context) => WordsSquarePuzzleNotifier(
            context.read<AudioNotifier>(),
            context.read<CountdownNotifier>(),
            context.read<GameTimerNotifier>(),
          ),
          builder: (_, notifier) => WordsSquareScreen._(notifier: notifier as WordsSquarePuzzleNotifier),
        ),
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

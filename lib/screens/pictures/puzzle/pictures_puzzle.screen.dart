import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/screens/pictures/puzzle/puzzle.dart';
import 'package:slide_puzzle/services/image.service.dart';

class PicturesPuzzleScreen extends StatelessWidget {
  const PicturesPuzzleScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final PicturesPuzzleNotifier notifier;

  static ScaleTransitionPage buildPage(
    BuildContext context, {
    Uint8List? imageData,
    String? term,
  }) {
    return ScaleTransitionPage(
      key: const ValueKey(RouteNames.picturesPuzzle),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GameTimerNotifier>(create: (_) => GameTimerNotifier(const Ticker())),
          ChangeNotifierProvider<CountdownNotifier>(create: (_) => CountdownNotifier(const Ticker())),
        ],
        builder: (_, __) => ProvideNotifier<PuzzleGameNotifier>(
          watch: true,
          create: (context) => PicturesPuzzleNotifier(
            context.read<AudioNotifier>(),
            context.read<CountdownNotifier>(),
            context.read<GameTimerNotifier>(),
            context.read<ImageService>(),
            imageData: imageData,
            term: term,
          ),
          builder: (_, notifier) => PicturesPuzzleScreen._(notifier: notifier as PicturesPuzzleNotifier),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAwareScaffold(
      pageLayoutDelegate: PicturePuzzleLayout(notifier),
    );
  }
}

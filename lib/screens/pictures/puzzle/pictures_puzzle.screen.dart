import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
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

  static ScaleTransitionPage buildPage(BuildContext context, Uint8List imageData) {
    return ScaleTransitionPage(
      key: ValueKey(RouteNames.picturesPuzzle),
      child: ProvideNotifier<PicturesPuzzleNotifier>(
        watch: true,
        create: (context) => PicturesPuzzleNotifier(
          context.read<ImageService>(),
          imageData: imageData,
        ),
        builder: (context, notifier) => PicturesPuzzleScreen._(notifier: notifier),
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

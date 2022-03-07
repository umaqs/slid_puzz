import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/screens/pictures/menu/menu.dart';
import 'package:slide_puzzle/services/image.service.dart';

class PicturesMenuScreen extends StatelessWidget {
  const PicturesMenuScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);
  final PicturesMenuNotifier notifier;

  static ScaleTransitionPage buildPage(BuildContext context) {
    return ScaleTransitionPage(
      key: const ValueKey(RouteNames.picturesMenu),
      child: ProvideNotifier<PicturesMenuNotifier>(
        watch: true,
        create: (context) => PicturesMenuNotifier(
          context.read<ImageService>(),
          DefaultCacheManager(),
        ),
        builder: (context, notifier) => PicturesMenuScreen._(notifier: notifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAwareScaffold(
      pageLayoutDelegate: PicturesMenuLayout(notifier),
    );
  }
}

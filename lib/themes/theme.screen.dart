import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/themes/theme.layout.dart';
import 'package:slide_puzzle/themes/theme.notifier.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final ThemeNotifier notifier;

  static ScaleTransitionPage buildPage(BuildContext context) {
    return ScaleTransitionPage(
      key: const ValueKey(RouteNames.themes),
      child: Consumer<ThemeNotifier>(
        builder: (_, notifier, __) => ThemeScreen._(notifier: notifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = notifier.currentColor;
    return AnimatedTheme(
      data: themeColor.theme,
      child: ThemeAwareScaffold(
        pageLayoutDelegate: ThemeLayout(notifier),
      ),
    );
  }
}

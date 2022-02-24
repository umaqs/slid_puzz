import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/theme.notifier.dart';

class ThemeAwareScaffold extends StatelessWidget {
  ThemeAwareScaffold({
    Key? key,
    required this.pageLayoutDelegate,
  }) : super(key: key);

  final PageLayoutDelegate pageLayoutDelegate;

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ThemeNotifier>().currentColor;

    return AnimatedTheme(
      duration: kThemeChangeDuration,
      data: themeColor.theme,
      child: Scaffold(
        body: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: themeColor.gradient,
            ),
            child: PageLayout(
              layoutBuilderDelegate: pageLayoutDelegate,
            ),
          ),
        ),
      ),
    );
  }
}

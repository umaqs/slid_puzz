import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/theme.notifier.dart';
import 'package:slide_puzzle/widgets/square_button.dart';

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
      child: Stack(
        children: [
          Positioned.fill(
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
          ),
          if (Navigator.of(context).canPop())
            Positioned(
              top: 12,
              left: 12,
              child: _BackButton(),
            )
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Consumer(
      builder: (BuildContext context, value, Widget? child) {
        return Container();
      },
    );
    return SizedBox.square(
      dimension: kToolbarHeight,
      child: SquareButton(
        tilt: false,
        borderRadius: 50,
        color: colors.primary,
        child: Icon(
          Icons.arrow_back,
          color: colors.onPrimary,
        ),
        onTap: () => Navigator.maybePop(context),
      ),
    );
  }
}

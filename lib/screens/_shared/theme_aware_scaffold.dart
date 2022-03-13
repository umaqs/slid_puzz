import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/theme.notifier.dart';
import 'package:slide_puzzle/widgets/square_button.dart';

class ThemeAwareScaffold extends StatelessWidget {
  const ThemeAwareScaffold({
    Key? key,
    required this.pageLayoutDelegate,
  }) : super(key: key);

  final PageLayoutDelegate pageLayoutDelegate;

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: context.theme,
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: context.themeColor.gradient,
                  ),
                  child: PageLayout(
                    layoutBuilderDelegate: pageLayoutDelegate,
                  ),
                ),
              ),
            ),
          ),
          if (ModalRoute.of(context)?.canPop ?? false)
            const Positioned(
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
    final layoutSize = context.layoutSize;

    return SafeArea(
      child: SizedBox.square(
        dimension: layoutSize.isSmall ? 36 : kToolbarHeight,
        child: SquareButton(
          tilt: false,
          disableShadows: true,
          borderRadius: 50,
          color: colors.secondaryContainer,
          child: Icon(
            Icons.arrow_back,
            color: colors.onSecondaryContainer,
          ),
          onTap: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}

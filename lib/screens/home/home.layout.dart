import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/screens/home/home.notifier.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/text_styles.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

class HomeLayout implements PageLayoutDelegate<HomeNotifier> {
  const HomeLayout(this.notifier);

  final HomeNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return MenuHeader(title: 'Slide Puzzle');
  }

  @override
  Widget body(context, constraints) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, constraints) {
        return SizedBox.square(
          dimension: layoutSize.hexBoardSize,
          child: Stack(
            children: [
              for (var i = 0; i < notifier.menuItems.length; i++) gridItem(context, i),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget endSection(context, constraints) {
    return MenuFooter(
      children: [
        const ResponsiveGap(
          small: 8,
          medium: 8,
        ),
        AudioControl(),
        const ResponsiveGap(
          small: 8,
          medium: 16,
        ),
      ],
    );
  }

  @override
  Widget gridItem(BuildContext context, int index) {
    final menuItem = notifier.menuItems[index];

    return HexPuzzleTile(
      key: Key('hex_menu_item_${menuItem.index}'),
      gridDepth: 1,
      color: context.colors.primary,
      offset: menuItem.offset,
      childBuilder: (context, layoutSize) => _buildMenuTile(
        context,
        menuItem,
        layoutSize,
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, HexMenuItem menuItem, ResponsiveLayoutSize layoutSize) {
    final colors = context.colors;

    return SizedBox.expand(
      child: Tooltip(
        waitDuration: const Duration(seconds: 1),
        message: menuItem.modeToolTip,
        child: GestureDetector(
          onTap: () => notifier.itemTapped(context, menuItem),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (menuItem.icon == Icons.hexagon)
                        HexagonWidget.flat(
                          height: 30,
                          color: colors.surface,
                          cornerRadius: 2,
                        )
                      else
                        Icon(
                          menuItem.icon,
                          size: 30,
                          color: colors.surface,
                        ),
                      ResponsiveGap(
                        small: 8,
                        medium: 12,
                        large: 12,
                      ),
                      Text(
                        menuItem.label,
                        textAlign: TextAlign.center,
                        style: PuzzleTextStyle.body.copyWith(
                          color: colors.surface,
                          fontSize: layoutSize.menuTileFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  double get menuTileFontSize {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 18.0;
      case ResponsiveLayoutSize.medium:
        return 22.0;
      case ResponsiveLayoutSize.large:
        return 28.0;
    }
  }
}

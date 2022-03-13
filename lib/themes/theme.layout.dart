import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/screens/pictures/menu/menu.dart';
import 'package:slide_puzzle/themes/theme.notifier.dart';
import 'package:slide_puzzle/widgets/widgets.dart';

import '../typography/typography.dart';

class ThemeLayout implements PageLayoutDelegate<ThemeNotifier> {
  const ThemeLayout(this.notifier);

  @override
  final ThemeNotifier notifier;

  @override
  Widget startSection(BuildContext context, BoxConstraints constraints) {
    return MenuHeader(
      title: 'Themes',
      subtitle: Icon(
        Icons.color_lens,
        size: context.layoutSize.tileFontSize,
        color: context.colors.primary,
      ),
    );
  }

  @override
  Widget body(BuildContext context, BoxConstraints constraints) {
    return MenuGrid(
      gridSize: 3,
      spacing: 12,
      tiles: [
        for (int i = 0; i < notifier.themeColors.length; i++) gridItem(context, i),
      ],
    );
  }

  @override
  Widget endSection(BuildContext context, BoxConstraints constraints) {
    return _buildModeDropDown(context);
  }

  @override
  Widget gridItem(BuildContext context, int index) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => child!,
      child: (layoutSize, _) {
        final color = notifier.themeColors[index];
        final colors = color.theme.colorScheme;
        return Padding(
          padding: layoutSize.isLarge ? kPadding8 : kPadding4,
          child: SquareButton(
            elevation: 4,
            borderWidth: layoutSize.isLarge ? 8 : 4,
            borderColor: color == notifier.currentColor ? Colors.white : null,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.primary,
                colors.inversePrimary,
              ],
              stops: const [0.0, 1.0],
            ),
            borderRadius: 100,
            onTap: () {
              notifier.setTheme(color);
            },
          ),
        );
      },
    );
  }

  Widget _buildModeDropDown(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => SizedBox(
        height: ResponsiveLayoutSize.large.squareBoardSize,
        child: child,
      ),
      child: (layoutSize, _) {
        final platformBrightness = MediaQuery.of(context).platformBrightness;
        final colors = context.colors;
        return SizedBox(
          width: layoutSize.squareBoardSize,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: kEdgePadding8.add(kPadding4),
                  child: DropdownButton<AdaptiveThemeMode>(
                    isExpanded: true,
                    icon: const SizedBox.shrink(),
                    value: notifier.mode,
                    borderRadius: kBorderRadius8,
                    focusColor: Colors.transparent,
                    underline: const SizedBox.shrink(),
                    onChanged: (value) {
                      if (value != null) {
                        notifier.setThemeMode(
                          mode: value,
                          platformBrightness: platformBrightness,
                        );
                      }
                    },
                    selectedItemBuilder: (context) {
                      return [
                        for (final mode in AdaptiveThemeMode.values)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mode.name,
                                style: PuzzleTextStyle.body.copyWith(
                                  color: context.colors.onSurface,
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: kThemeChangeDuration,
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                child: Icon(
                                  context.theme.brightness == Brightness.light
                                      ? Icons.brightness_4
                                      : Icons.brightness_2,
                                  color: colors.primary,
                                ),
                              )
                            ],
                          ),
                      ];
                    },
                    items: [
                      for (final mode in AdaptiveThemeMode.values)
                        DropdownMenuItem<AdaptiveThemeMode>(
                          value: mode,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mode.name,
                                style: PuzzleTextStyle.body.copyWith(
                                  color: context.colors.onSurface,
                                ),
                              ),
                              Icon(
                                mode.isLight
                                    ? Icons.brightness_4
                                    : mode.isDark
                                        ? Icons.brightness_2
                                        : Icons.devices_other,
                                color: colors.primary,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

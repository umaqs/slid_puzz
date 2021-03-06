import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/typography.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => Padding(
        padding: kPadding16,
        child: child,
      ),
      medium: (_, child) => Padding(
        padding: kPadding24,
        child: child,
      ),
      large: (_, child) => SizedBox(
        height: ResponsiveLayoutSize.large.squareBoardSize,
        child: child,
      ),
      child: (layoutSize, _) {
        return Column(
          children: [
            _MenuTitle(title: title),
            if (subtitle != null) ...[
              kBox16,
              subtitle!,
            ],
          ],
        );
      },
    );
  }
}

class _MenuTitle extends StatelessWidget {
  const _MenuTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => Padding(
        padding: kPadding24,
        child: child,
      ),
      large: (_, child) => Padding(
        padding: kEdgePadding8,
        child: child,
      ),
      child: (layoutSize, _) {
        final titleColor = context.colors.primary;
        final textStyle = layoutSize.textStyle.copyWith(color: titleColor);

        return AnimatedDefaultTextStyle(
          style: textStyle,
          duration: kThemeChangeDuration,
          child: Text(
            title,
            textAlign: layoutSize.textAlign,
          ),
        );
      },
    );
  }
}

extension _ResponsiveLayoutSizeExtension on ResponsiveLayoutSize {
  TextStyle get textStyle {
    return isLarge ? PuzzleTextStyle.headline2 : PuzzleTextStyle.headline3;
  }

  TextAlign get textAlign {
    return isLarge ? TextAlign.left : TextAlign.center;
  }
}

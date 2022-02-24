import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/responsive_layout_builder.dart';

/// {@template responsive_gap}
/// A wrapper around [Gap] that renders a [small], [medium]
/// or a [large] gap depending on the screen size.
/// {@endtemplate}
class ResponsiveGap extends StatelessWidget {
  /// {@macro responsive_gap}
  const ResponsiveGap({
    Key? key,
    this.small = 0,
    this.medium = 0,
    this.large = 0,
  }) : super(key: key);

  /// {@macro responsive_gap}
  ResponsiveGap.all({
    Key? key,
    required double value,
  })  : small = value,
        medium = value,
        large = value,
        super(key: key);

  /// A gap rendered on a small layout.
  final double small;

  /// A gap rendered on a medium layout.
  final double medium;

  /// A gap rendered on a large layout.
  final double large;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SizedBox(width: small, height: small),
      medium: (_, __) => SizedBox(width: medium, height: medium),
      large: (_, __) => SizedBox(width: large, height: large),
    );
  }
}

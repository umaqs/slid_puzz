import 'package:flutter/material.dart';

class ThemeColor {
  const ThemeColor.light({
    required this.seedColor,
    required this.backgroundColors,
  }) : brightness = Brightness.light;

  const ThemeColor.dark({
    required this.seedColor,
    required this.backgroundColors,
  }) : brightness = Brightness.dark;

  final Color seedColor;
  final Brightness brightness;
  final List<Color> backgroundColors;

  RadialGradient get gradient {
    final colors = backgroundColors
        .map(
          (color) => brightness == Brightness.light ? color : color.withOpacity(0.5),
        )
        .toList();
    return RadialGradient(
      colors: colors,
      radius: 1,
    );
  }

  ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        primary: seedColor,
        brightness: brightness,
      ),
      // colorSchemeSeed: seedColor,
      // brightness: brightness,
    );
  }
}

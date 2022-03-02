import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';
import 'package:slide_puzzle/services/shared_prefs.service.dart';
import 'package:slide_puzzle/themes/theme_color.dart';
import 'package:slide_puzzle/utils/extensions.dart';

extension ThemeBuildContextExtension on BuildContext {
  ThemeColor get themeColor {
    final themeNotifier = read<ThemeNotifier>();
    return themeNotifier.currentColor;
  }

  ThemeData get theme => themeColor.theme;

  ColorScheme get colors => theme.colorScheme;

  LinearGradient getMenuLoaderGradient({
    int? seed,
    Alignment? begin,
    Alignment? end,
  }) {
    final useThemeColors = themeColor.brightness.isLight;
    final backgroundColors = [if (useThemeColors) ...themeColor.backgroundColors else ...Colors.primaries];
    final random = Random(seed);
    final loaderColor = backgroundColors.getRandom(random);

    return LinearGradient(
      begin: begin ?? Alignment.topLeft,
      end: end ?? Alignment.bottomRight,
      colors: [
        loaderColor,
        colors.primary,
      ],
      stops: [0.0, 1.0],
    );
  }
}

extension BrightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
}

class ThemeNotifier extends BaseNotifier {
  ThemeNotifier(
    this._sharedPrefsService,
    this.adaptiveThemeKey,
    AdaptiveThemeMode initialMode,
    Brightness platformBrightness,
  ) : _mode = initialMode {
    final seedColorValue = _sharedPrefsService.getInt(_themePrefsKey);
    _currentColor = [..._lightThemes, ..._darkThemes].firstWhere(
      (color) => color.seedColor.value == seedColorValue,
      orElse: () {
        if (platformBrightness.isLight) {
          return _lightThemes.getRandom();
        }
        return _darkThemes.getRandom();
      },
    );
  }

  static const _themePrefsKey = 'current_theme_color';

  final SharedPrefsService _sharedPrefsService;
  final GlobalKey<State<AdaptiveTheme>> adaptiveThemeKey;

  AdaptiveThemeManager get _manager => adaptiveThemeKey.currentState as AdaptiveThemeManager;

  ThemeColor get currentColor => _currentColor;
  ThemeColor _currentColor = _lightThemes.first;

  AdaptiveThemeMode get mode => _mode;
  AdaptiveThemeMode _mode;

  ThemeMode get themeMode {
    switch (_mode) {
      case AdaptiveThemeMode.light:
        return ThemeMode.light;
      case AdaptiveThemeMode.dark:
        return ThemeMode.dark;
      case AdaptiveThemeMode.system:
        return ThemeMode.system;
    }
  }

  List<ThemeColor> get themeColors {
    switch (_manager.theme.brightness) {
      case Brightness.light:
        return List.unmodifiable(_lightThemes);
      case Brightness.dark:
        return List.unmodifiable(_darkThemes);
    }
  }

  void setThemeMode({
    required AdaptiveThemeMode mode,
    required Brightness platformBrightness,
  }) {
    _mode = mode;
    _manager.setThemeMode(mode);
    switch (mode) {
      case AdaptiveThemeMode.dark:
        setTheme(_darkThemes.first);
        break;
      case AdaptiveThemeMode.light:
        setTheme(_lightThemes.first);
        break;
      case AdaptiveThemeMode.system:
        switch (platformBrightness) {
          case Brightness.dark:
            setTheme(_darkThemes.first);
            break;
          case Brightness.light:
            setTheme(_lightThemes.first);
            break;
        }
        break;
    }
  }

  void setTheme(ThemeColor value) {
    _currentColor = value;
    final dark = _currentColor.brightness == Brightness.dark ? _currentColor.theme : null;
    _manager.setTheme(light: _currentColor.theme, dark: dark, notify: false);

    _sharedPrefsService.setInt(_themePrefsKey, _currentColor.seedColor.value);
    notifyListeners();
  }
}

const _lightThemes = [
  ThemeColor.light(
    seedColor: Color(0xFF6A097D),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFF99154E),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFFEE2222),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFF39A388),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFF2C2891),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFF14452F),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFFF55C47),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFF161853),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
  ThemeColor.light(
    seedColor: Color(0xFFFF4081),
    backgroundColors: [
      Color(0xFFFFD6FF),
      Color(0xFFE7C6FF),
      Color(0xFFC8B6FF),
      Color(0xFFB8C0FF),
      Color(0xFFBBD0FF),
    ],
  ),
];

const _darkThemes = [
  ThemeColor.dark(
    seedColor: Color(0xFF24FBFF),
    backgroundColors: [
      Color(0xFF004B5E),
      Color(0xFF004355),
      Color(0xFF003442),
      Color(0xFF00252F),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFFFF0075),
    backgroundColors: [
      Color(0xFF44253E),
      Color(0xFF332945),
      Color(0xFF272727),
      Color(0xFF252525),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFF00F5D4),
    backgroundColors: [
      Color(0xFF00253E),
      Color(0xFF002945),
      Color(0xFF002E4E),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFFF7EA00),
    backgroundColors: [
      Color(0xFF113356),
      Color(0xFF222E4E),
      Color(0xFF332945),
      Color(0xFF44253E),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFFF96900),
    backgroundColors: [
      Color(0xFF003356),
      Color(0xFF002E4E),
      Color(0xFF002945),
      Color(0xFF00253E),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFFC400FF),
    backgroundColors: [
      Color(0xFF003356),
      Color(0xFF002E4E),
      Color(0xFF002945),
      Color(0xFF00253E),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFF03A9F4),
    backgroundColors: [
      Color(0xFF003356),
      Color(0xFF002E4E),
      Color(0xFF002945),
      Color(0xFF00253E),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFF1FFF01),
    backgroundColors: [
      Color(0xFF333356),
      Color(0xFF222E4E),
      Color(0xFF112945),
      Color(0xFF123456),
    ],
  ),
  ThemeColor.dark(
    seedColor: Color(0xFFF86AE3),
    backgroundColors: [
      Color(0xFF003356),
      Color(0xFF002E4E),
      Color(0xFF002945),
      Color(0xFF00253E),
    ],
  ),
];

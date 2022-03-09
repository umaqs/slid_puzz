import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/screens/home/home.screen.dart';
import 'package:slide_puzzle/screens/numbers/numbers.hex.screen.dart';
import 'package:slide_puzzle/screens/numbers/numbers.square.screen.dart';
import 'package:slide_puzzle/screens/pictures/menu/menu.dart';
import 'package:slide_puzzle/screens/pictures/puzzle/puzzle.dart';
import 'package:slide_puzzle/screens/words/words.dart';
import 'package:slide_puzzle/screens/words/words_hex.screen.dart';
import 'package:slide_puzzle/services/image.service.dart';
import 'package:slide_puzzle/services/shared_prefs.service.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';
import 'package:slide_puzzle/services/url_launcher.service.dart';
import 'package:slide_puzzle/themes/theme.notifier.dart';
import 'package:slide_puzzle/themes/theme.screen.dart';

part 'app.bootstrap.dart';
part 'app.lifecycle_observer.dart';
part 'app.router.dart';

class _PuzzleApp extends StatelessWidget {
  const _PuzzleApp({
    Key? key,
    required this.themeNotifier,
    required this.providers,
  }) : super(key: key);

  final ThemeNotifier themeNotifier;
  final List<SingleChildWidget> providers;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      key: themeNotifier.adaptiveThemeKey,
      initial: themeNotifier.mode,
      light: themeNotifier.currentColor.theme,
      dark: themeNotifier.currentColor.theme,
      builder: (theme, darkTheme) {
        return MultiProvider(
          providers: providers,
          child: MaterialApp.router(
            theme: theme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.themeMode,
            routerDelegate: _router.routerDelegate,
            routeInformationParser: _router.routeInformationParser,
            debugShowCheckedModeBanner: false,
            supportedLocales: const [Locale('en', 'US'), Locale('en', 'GB')],
            scaffoldMessengerKey: SnackBarService.instance.scaffoldMessengerKey,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        );
      },
    );
  }
}

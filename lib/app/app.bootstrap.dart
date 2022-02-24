part of 'app.dart';

Future<void> bootstrapAndRunApp() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

      final sharedPrefs = await SharedPreferences.getInstance();
      final sharedPrefsService = SharedPrefsService(sharedPrefs);

      final savedThemeMode = await AdaptiveTheme.getThemeMode();
      final adaptiveThemeKey = GlobalKey<State<AdaptiveTheme>>();

      Brightness? platformBrightness;
      final window = WidgetsBinding.instance?.window;
      if (window != null) {
        platformBrightness = MediaQueryData.fromWindow(window).platformBrightness;
      }

      final themeNotifier = ThemeNotifier(
        sharedPrefsService,
        adaptiveThemeKey,
        savedThemeMode ?? AdaptiveThemeMode.system,
        platformBrightness ?? Brightness.light,
      );

      final providers = [
        Provider<ImageService>(create: (_) => ImageService()),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => themeNotifier),
        Provider<UrlLauncherService>(create: (_) => UrlLauncherService()),
        Provider<SharedPrefsService>(create: (_) => sharedPrefsService),
      ];

      runApp(
        _PuzzleApp(
          themeNotifier: themeNotifier,
          providers: providers,
        ),
      );
    },
    (error, stack) {
      log('Error:', error: error, stackTrace: stack);
    },
  );
}

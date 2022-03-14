part of 'app.dart';

Future<void> bootstrapAndRunApp() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

      LicenseRegistry.addLicense(_addLicenses);

      final sharedPrefs = await SharedPreferences.getInstance();
      final sharedPrefsService = SharedPrefsService(sharedPrefs);

      final savedThemeMode = await AdaptiveTheme.getThemeMode();
      final adaptiveThemeKey = GlobalKey<State<AdaptiveTheme>>();

      Brightness? platformBrightness;
      final window = WidgetsBinding.instance?.window;
      if (window != null) {
        platformBrightness = MediaQueryData.fromWindow(window).platformBrightness;
      }

      SnackBarService.init();

      final themeNotifier = ThemeNotifier(
        sharedPrefsService,
        adaptiveThemeKey,
        savedThemeMode ?? AdaptiveThemeMode.system,
        platformBrightness ?? Brightness.light,
      );

      final audioNotifier = AudioNotifier(sharedPrefsService);
      await audioNotifier.loadAssets();

      final providers = [
        ChangeNotifierProvider<AudioNotifier>(create: (_) => audioNotifier),
        Provider<ImageService>(create: (_) => ImageService()),
        Provider<SharedPrefsService>(create: (_) => sharedPrefsService),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => themeNotifier),
        Provider<ShareService>(create: (_) => const ShareService()),
      ];

      runApp(
        _PuzzleApp(
          themeNotifier: themeNotifier,
          providers: providers,
        ),
      );
    },
    (error, stack) {
      if (kDebugMode) {
        print('Error: $error');
        print('Stacktrace: $stack');
        Error.throwWithStackTrace(error, stack);
      }
      log('Error: $error', error: error, stackTrace: stack);
    },
  );
}

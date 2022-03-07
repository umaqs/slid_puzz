part of 'app.dart';

mixin RouteNames {
  static const home = 'home';
  static const numbersSquare = 'numbers-square';
  static const numbersHex = 'numbers-hex';
  static const picturesMenu = 'pictures-menu';
  static const picturesPuzzle = 'pictures-puzzle';
  static const wordsSquare = 'words-square';
  static const wordsHex = 'words-hex';
  static const themes = 'themes';
}

late final _router = GoRouter(
  routes: [
    GoRoute(
      name: RouteNames.home,
      path: '/',
      pageBuilder: (context, state) => HomeScreen.buildPage(context),
    ),
    GoRoute(
      name: RouteNames.numbersSquare,
      path: '/numbers-square',
      pageBuilder: (context, state) => NumbersSquareScreen.buildPage(context),
    ),
    GoRoute(
      name: RouteNames.numbersHex,
      path: '/numbers-hex',
      pageBuilder: (context, state) => NumbersHexScreen.buildPage(context),
    ),
    GoRoute(
      name: RouteNames.picturesMenu,
      path: '/pictures',
      pageBuilder: (context, state) => PicturesMenuScreen.buildPage(context),
      routes: [
        GoRoute(
          name: RouteNames.picturesPuzzle,
          path: 'puzzle',
          redirect: (state) {
            final extra = state.extra;
            if (extra == null) {
              return '/';
            }
            return null;
          },
          pageBuilder: (context, state) {
            return PicturesPuzzleScreen.buildPage(
              context,
              state.extra! as Uint8List,
            );
          },
        ),
      ],
    ),
    GoRoute(
      name: RouteNames.wordsSquare,
      path: '/words-square',
      pageBuilder: (context, state) => WordsSquareScreen.buildPage(context),
    ),
    GoRoute(
      name: RouteNames.wordsHex,
      path: '/words-hex',
      pageBuilder: (context, state) => WordsHexScreen.buildPage(context),
    ),
    GoRoute(
      name: RouteNames.themes,
      path: '/themes',
      pageBuilder: (context, state) => ThemeScreen.buildPage(context),
    ),
  ],
);

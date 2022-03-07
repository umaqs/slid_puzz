import 'package:flutter/material.dart';
import 'package:slide_puzzle/app/app.dart';
import 'package:slide_puzzle/screens/_base/infrastructure.dart';
import 'package:slide_puzzle/screens/_shared/shared.dart';
import 'package:slide_puzzle/screens/home/home.layout.dart';
import 'package:slide_puzzle/screens/home/home.notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen._({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  final HomeNotifier notifier;

  static ScaleTransitionPage buildPage(BuildContext context) {
    return ScaleTransitionPage(
      key: const ValueKey(RouteNames.home),
      child: ProvideNotifier<HomeNotifier>(
        watch: true,
        create: (context) => HomeNotifier(),
        builder: (context, notifier) => HomeScreen._(notifier: notifier),
      ),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final themeNotifier = context.read<ThemeNotifier>();
    // final platformBrightness = context.dependOnInheritedWidgetOfExactType<MediaQuery>()?.data.platformBrightness;
    // if (platformBrightness != null) {
    //   themeNotifier.setThemeMode(mode: themeNotifier.mode, platformBrightness: platformBrightness);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeAwareScaffold(
      key: _scaffoldKey,
      pageLayoutDelegate: HomeLayout(widget.notifier),
    );
  }
}

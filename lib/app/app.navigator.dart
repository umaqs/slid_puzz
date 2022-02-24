part of 'app.dart';

class AppNavigator extends StatefulWidget {
  AppNavigator({
    Key? key,
    required List<Page> initialPages,
  })  : assert(initialPages.isNotEmpty),
        _initialPages = [...initialPages],
        super(key: key);

  final List<Page> _initialPages;

  static _AppNavigatorState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppNavigatorState>();
  }

  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _stack = <Page>[];
  final _onPop = <Page, Completer>{};

  @override
  void initState() {
    super.initState();
    _stack.addAll(widget._initialPages);
  }

  void push(Page page) {
    if (_stack.containsKey(page.key!)) {
      return;
    }

    _stack.add(page);
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return !(await _navigatorKey.currentState?.maybePop() ?? false);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final page = route.settings as Page;
    final index = _stack.indexOf(page);
    if (index != -1 && _stack.length > 1) {
      _stack.remove(page);
      final completer = _onPop.remove(page);
      completer?.complete();
    }

    setState(() {});

    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Navigator(
        key: _navigatorKey,
        pages: [..._stack],
        onPopPage: _onPopPage,
      ),
    );
  }
}

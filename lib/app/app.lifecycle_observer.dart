part of 'app.dart';

class AppLifeCycleObserver extends StatefulWidget {
  const AppLifeCycleObserver({
    Key? key,
    required this.child,
    required this.observers,
  }) : super(key: key);

  final Widget child;
  final List<AppLifeCycleStateObserver> observers;

  @override
  _AppLifeCycleObserverState createState() => _AppLifeCycleObserverState();
}

class _AppLifeCycleObserverState extends State<AppLifeCycleObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    widget.observers.forEach((observer) => observer.didChangeAppLifecycleState(state));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

abstract class AppLifeCycleStateObserver {
  void didChangeAppLifecycleState(AppLifecycleState state);
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef NotifierChildBuilder<T> = Widget Function(BuildContext context, T value);

class ProvideNotifier<T extends ChangeNotifier> extends StatelessWidget {
  const ProvideNotifier({
    Key? key,
    required this.create,
    required this.builder,
    this.watch = false,
  }) : super(key: key);

  final Create<T> create;
  final NotifierChildBuilder<T> builder;
  final bool watch;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: create,
      child: Builder(
        builder: (context) {
          final provider = watch ? context.watch<T>() : context.read<T>();
          return builder(context, provider);
        },
      ),
    );
  }
}

class Watch<T extends ChangeNotifier> extends StatelessWidget {
  const Watch({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final NotifierChildBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<T>();
    return builder(context, notifier);
  }
}

class Listen<T extends Listenable> extends StatefulWidget {
  const Listen({
    Key? key,
    required this.listener,
    required this.child,
  }) : super(key: key);

  final void Function(T value) listener;
  final Widget child;

  @override
  State<Listen<T>> createState() => _ListenState<T>();
}

class _ListenState<T extends Listenable> extends State<Listen<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = context.read<T>();
    value.addListener(_onNotifyListeners);
  }

  @override
  void dispose() {
    value.removeListener(_onNotifyListeners);
    super.dispose();
  }

  void _onNotifyListeners() {
    widget.listener(value);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

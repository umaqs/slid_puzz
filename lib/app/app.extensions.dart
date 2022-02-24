part of 'app.dart';

extension _PageList on List<Page> {
  bool containsKey(LocalKey key) => any((page) => page.key == key);
}

extension BuildContextExtension on BuildContext {
  String? get currentScreenName => ModalRoute.of(this)?.settings.name;
}

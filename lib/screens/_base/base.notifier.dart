import 'package:flutter/cupertino.dart';

abstract class BaseNotifier extends ChangeNotifier {
  bool get mounted => _mounted;
  bool _mounted = true;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }
}

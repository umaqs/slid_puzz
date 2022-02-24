import 'package:flutter/material.dart';

class SnackBarService {
  const SnackBarService._(this._scaffoldMessengerKey);

  static SnackBarService? _instance;

  static SnackBarService get instance {
    assert(_instance != null, 'Call init() before using the instance');
    return _instance!;
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  static Future<void> init() async {
    assert(_instance == null);
    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    _instance = SnackBarService._(scaffoldMessengerKey);
  }

  void showSnackBar({required String message}) {
    _scaffoldMessengerKey.currentState?.removeCurrentSnackBar();

    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(message),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
              },
            )
          ],
        ),
      ),
    );
  }
}

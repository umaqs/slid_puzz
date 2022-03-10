import 'package:flutter/material.dart';
import 'package:slide_puzzle/layout/layout.dart';
import 'package:slide_puzzle/themes/themes.dart';
import 'package:slide_puzzle/typography/text_styles.dart';

class SnackBarService {
  const SnackBarService._(this.scaffoldMessengerKey);

  static SnackBarService? _instance;

  static SnackBarService get instance {
    assert(_instance != null, 'Call init() before using the instance');
    return _instance!;
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  static void init() {
    assert(_instance == null);
    _instance = SnackBarService._(GlobalKey<ScaffoldMessengerState>());
  }

  void showSnackBar({
    required String message,
    bool isError = false,
    int seconds = 1,
    bool canClose = false,
  }) {
    scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    final context = scaffoldMessengerKey.currentContext;
    final colors = context?.colors;
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        width: context?.layoutSize.squareBoardSize,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: seconds),
        backgroundColor: isError ? colors?.errorContainer : colors?.surface,
        shape: RoundedRectangleBorder(
          borderRadius: kBorderRadius8,
        ),
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: PuzzleTextStyle.label.copyWith(
                  color: isError ? colors?.onErrorContainer : colors?.onSurface,
                ),
              ),
            ),
            if (canClose)
              IconButton(
                icon: const Icon(Icons.close),
                color: isError ? colors?.onErrorContainer : colors?.onSurfaceVariant,
                onPressed: () {
                  scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                },
              )
          ],
        ),
      ),
    );
  }
}

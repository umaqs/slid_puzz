import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

enum CountdownStatus { notStarted, running, elapsed }

class CountdownNotifier extends BaseNotifier {
  CountdownNotifier(this._ticker, [this.totalSeconds = 3]) : _secondsToBegin = totalSeconds;

  final Ticker _ticker;
  final int totalSeconds;

  int get secondsToBegin => _secondsToBegin;
  int _secondsToBegin;

  CountdownStatus get status => _status;
  CountdownStatus _status = CountdownStatus.notStarted;

  StreamSubscription<int>? _tickerSubscription;

  VoidCallback? onComplete;

  void start({VoidCallback? onComplete}) {
    this.onComplete = onComplete;
    _tickerSubscription?.cancel();
    _status = CountdownStatus.running;
    _secondsToBegin = totalSeconds;
    notifyListeners();
    _tickerSubscription = _ticker.tick().listen(_onElapsed);
  }

  void _onElapsed(int _) {
    _secondsToBegin--;
    notifyListeners();
    if (_secondsToBegin == 0) {
      _status = CountdownStatus.elapsed;
      notifyListeners();
      _tickerSubscription?.cancel();
      Future.delayed(const Duration(seconds: 1), () {
        onComplete?.call();
        _status = CountdownStatus.notStarted;
      });
    }
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

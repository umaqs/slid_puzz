import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

enum TimerStatus { notStarted, countdown, running, paused }

abstract class GameTimerNotifier extends BaseNotifier {
  GameTimerNotifier(
    this._ticker, {
    int countdownSeconds = 3,
  })  : _countdownSeconds = countdownSeconds,
        _secondsToBegin = countdownSeconds;

  final Ticker _ticker;

  int get secondsElapsed => _secondsElapsed;
  int _secondsElapsed = 0;

  int get secondsToBegin => _secondsToBegin;
  int _secondsToBegin;

  int _countdownSeconds;

  TimerStatus get status => _status;
  TimerStatus _status = TimerStatus.notStarted;

  bool _shouldStartAfterCountdown = false;

  StreamSubscription<int>? _tickerSubscription;

  void startCountdown({int? countdownSeconds}) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick().listen(_onCountdownElapsed);
    _secondsToBegin = countdownSeconds ?? _countdownSeconds;
    _status = TimerStatus.countdown;
    notifyListeners();
  }

  @protected
  void start() {
    print('when start called: $_secondsToBegin');
    _tickerSubscription?.cancel();
    _secondsToBegin = -1;
    _status = TimerStatus.running;
    notifyListeners();
    _tickerSubscription = _ticker.tick().listen(_onElapsed);
  }

  @protected
  void pause() {
    _tickerSubscription?.pause();
    _status = TimerStatus.paused;
    notifyListeners();
  }

  void _onCountdownElapsed(int _) {
    print('_onCountdownElapsed: $_secondsToBegin');
    _secondsToBegin--;
    notifyListeners();
  }

  void _onElapsed(int _) {
    _secondsElapsed++;
    notifyListeners();
  }

  @protected
  void stop() {
    _tickerSubscription?.cancel();
    _status = TimerStatus.notStarted;
    _secondsElapsed = 0;
  }

  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

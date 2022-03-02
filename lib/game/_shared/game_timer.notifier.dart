import 'dart:async';

import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';

class GameTimerNotifier extends BaseNotifier {
  GameTimerNotifier(this._ticker);

  final Ticker _ticker;

  int get secondsElapsed => _secondsElapsed;
  int _secondsElapsed = 0;

  StreamSubscription<int>? _tickerSubscription;

  void start() {
    _tickerSubscription?.cancel();
    notifyListeners();
    _tickerSubscription = _ticker.tick().listen(_onElapsed);
  }

  void pause() {
    _tickerSubscription?.pause();
    notifyListeners();
  }

  void _onElapsed(int _) {
    _secondsElapsed++;
    notifyListeners();
  }

  void stop() {
    _tickerSubscription?.cancel();
    _secondsElapsed = 0;
  }

  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';
import 'package:slide_puzzle/services/shared_prefs.service.dart';

class AudioNotifier extends BaseNotifier {
  AudioNotifier(this._sharedPrefsService) {
    _isMuted = _sharedPrefsService.getBool('muted') ?? false;
  }

  final SharedPrefsService _sharedPrefsService;

  final _audioAssets = <String, String>{
    AudioAssets.shuffle: 'assets/audio/shuffle.mp3',
    AudioAssets.click: 'assets/audio/click.mp3',
    AudioAssets.dumbbell: 'assets/audio/dumbbell.mp3',
    AudioAssets.sandwich: 'assets/audio/sandwich.mp3',
    AudioAssets.skateboard: 'assets/audio/skateboard.mp3',
    AudioAssets.success: 'assets/audio/success.mp3',
    AudioAssets.tileMove: 'assets/audio/tile_move.mp3',
  };

  final _audioPlayers = <String, List<AudioPlayer>>{};

  bool get isMuted => _isMuted;
  bool _isMuted = false;

  Future<void> loadAssets() async {
    if (kIsWeb) {
      await Future.wait([
        for (final asset in _audioAssets.values) http.get(Uri.parse('assets/$asset')),
      ]);
    }

    _audioPlayers.clear();
    _audioPlayers.addAll({
      for (final asset in _audioAssets.entries)
        asset.key: List.generate(
          4,
          (index) => AudioPlayer()..setAsset(asset.value),
        ),
    });
  }

  void toggleSound() {
    _isMuted = !_isMuted;
    play(AudioAssets.click);
    _sharedPrefsService.setBool('muted', _isMuted);

    notifyListeners();
  }

  Future<void> playClick() {
    return play(AudioAssets.click);
  }

  Future<void> play(String asset, [double volume = 1.0]) async {
    if (_isMuted) {
      return;
    }
    assert(_audioAssets.containsKey(asset), 'Unable to find the file: $asset');

    final players = _audioPlayers[asset]!;

    final player = players.removeAt(0);
    await player.setVolume(volume);
    await player.replay();
    players.add(player);
  }

  @override
  void dispose() {
    for (final list in _audioPlayers.values) {
      for (final player in list) {
        player.dispose();
      }
    }
    super.dispose();
  }
}

mixin AudioAssets {
  static const shuffle = 'shuffle';
  static const click = 'click';
  static const dumbbell = 'dumbbell';
  static const sandwich = 'sandwich';
  static const skateboard = 'skateboard';
  static const success = 'success';
  static const tileMove = 'tile_move';
}

extension AudioPlayerExtension on AudioPlayer {
  /// Replays the current audio.
  Future<void> replay() async {
    await stop();
    await seek(null);
    await play();
  }
}

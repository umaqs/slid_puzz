import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:slide_puzzle/audio/audio.dart';
import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/services/image.service.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';

class PicturesPuzzleNotifier extends SquarePuzzleNotifier {
  PicturesPuzzleNotifier(
    AudioNotifier audio,
    CountdownNotifier countdown,
    GameTimerNotifier timer,
    this._imageService, {
    int initialGridSize = 4,
    Uint8List? imageData,
    String? term,
  })  : _imageData = imageData,
        _term = term,
        _isLoading = true,
        super(
          audio,
          countdown,
          timer,
          initialGridSize: initialGridSize,
        ) {
    refresh(force: false);
  }

  final ImageService _imageService;
  final String? _term;

  Uint8List? get imageData => _imageData;
  Uint8List? _imageData;

  Image get uiImage => _uiImage;
  late Image _uiImage;

  bool get showSolution => _showSolution;
  bool _showSolution = false;

  set showSolution(bool? value) {
    if (value != null) {
      _showSolution = value;
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;
  bool _isLoading;

  String? get error => _error;
  String? _error;

  Future<void> refresh({bool force = true}) async {
    _isLoading = true;
    notifyListeners();

    if (_imageData == null || force) {
      _imageData = await _imageService.searchImage(term: _term ?? '');
    }
    try {
      final codec = await instantiateImageCodec(_imageData!, allowUpscaling: false);
      final frameInfo = await codec.getNextFrame();
      _uiImage = frameInfo.image;
    } catch (e) {
      SnackBarService.instance.showSnackBar(
        message: 'Unable to load the picture, Please try again',
        isError: true,
        seconds: 5,
      );
    }

    if (force) {
      await generatePuzzle();
    }
    _isLoading = false;
    notifyListeners();
  }
}

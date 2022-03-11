import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:slide_puzzle/game/_shared/shared.dart';
import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';

class PicturesPuzzleNotifier extends SquarePuzzleNotifier {
  PicturesPuzzleNotifier(
    CountdownNotifier countdown,
    GameTimerNotifier timer, {
    int initialGridSize = 4,
    required Uint8List imageData,
  })  : _imageData = imageData,
        _isLoading = true,
        super(
          countdown,
          timer,
          initialGridSize: initialGridSize,
        ) {
    _initImage();
  }

  final Uint8List _imageData;

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

  Future<void> _initImage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final codec = await instantiateImageCodec(_imageData, allowUpscaling: false);
      final frameInfo = await codec.getNextFrame();
      _uiImage = frameInfo.image;
    } catch (e) {
      SnackBarService.instance.showSnackBar(
        message: 'Unable to load the picture, Please try again',
        isError: true,
        seconds: 5,
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}

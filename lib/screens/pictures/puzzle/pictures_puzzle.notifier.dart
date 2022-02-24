import 'dart:async';
import 'dart:typed_data';

import 'package:slide_puzzle/game/square/puzzle.dart';
import 'package:slide_puzzle/services/image.service.dart';

class PicturesPuzzleNotifier extends SquarePuzzleNotifier {
  PicturesPuzzleNotifier(
    this._imageService, {
    int initialGridSize = 4,
    required Uint8List imageData,
  })  : _imageData = imageData,
        _isLoading = true,
        _imageParts = {},
        super(initialGridSize: initialGridSize) {
    _generateImageParts(initialGridSize);
  }

  final Uint8List _imageData;
  final ImageService _imageService;

  List<Uint8List> get imageParts => List.unmodifiable(_imageParts[gridSize] ?? []);
  Map<int, List<Uint8List>> _imageParts;

  @override
  set gridSize(int value) {
    super.gridSize = value;
    _generateImageParts(value);
  }

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

  Future<void> _generateImageParts(int size) async {
    if (_imageParts.containsKey(size)) {
      return;
    }

    final parts = await _imageService.splitImageIntoGrid(
      data: _imageData,
      gridSize: gridSize,
    );
    if (parts == null) {
      _error = 'Unable to load this image, Please try a different one';
    } else {
      _imageParts[size] = parts;
    }

    _isLoading = false;
    notifyListeners();

    // final parts = await Future.wait(
    //   [
    //     for (var iSize = minSize; iSize <= maxSize; iSize++)
    //       _imageService.splitImageIntoGrid(
    //         data: _imageData,
    //         gridSize: iSize,
    //       ),
    //   ],
    // );
    //
    // if (parts.any((part) => part == null)) {
    //   _error = 'Unable to load this image, Please try a different one';
    // } else {
    //   _imageParts = {
    //     for (var iSize = minSize; iSize <= maxSize; iSize++) iSize: parts[iSize - minSize]!,
    //   };
    // }
  }
}

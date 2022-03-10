import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slide_puzzle/screens/_base/base.notifier.dart';
import 'package:slide_puzzle/screens/pictures/menu/menu.dart';
import 'package:slide_puzzle/services/image.service.dart';
import 'package:slide_puzzle/services/snackbar.service.dart';

class PicturesMenuNotifier extends BaseNotifier {
  PicturesMenuNotifier(
    this._imageService,
    this._imageCacheManager,
  )   : _isLoading = true,
        _items = [] {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      reloadMenu();
    });
  }

  final int gridSize = 4;
  final ImageCacheManager _imageCacheManager;
  final ImageService _imageService;

  List<MenuItem> get items => List.unmodifiable(_items);
  List<MenuItem> _items;

  bool get isLoading => _isLoading;
  bool _isLoading;

  Future<void> reloadMenu() async {
    _items = _generateItems();

    _isLoading = true;
    notifyListeners();

    try {
      _items = await _loadImages();
    } catch (_) {
      SnackBarService.instance.showSnackBar(
        message: 'Unable to load pictures, Please try again',
        isError: true,
        seconds: 5,
      );
      _items = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    try {
      final imageData = await _imageService.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
      );

      return imageData;
    } catch (e) {
      SnackBarService.instance.showSnackBar(
        message: 'Unable to select a picture, Please try again!',
        isError: true,
        seconds: 5,
      );
      notifyListeners();
      return null;
    }
  }

  List<MenuItem> _generateItems() {
    final seed = Random().nextInt(100);

    int getKey(int index) => ((index + seed) * seed).hashCode;

    return List.generate(
      gridSize * gridSize,
      (index) => MenuItem(key: getKey(index)),
    );
  }

  Future<List<MenuItem>> _loadImages() async {
    return Future.wait([
      for (final item in _items)
        _imageCacheManager
            .getSingleFile('https://picsum.photos/seed/${item.key}/500', key: '${item.key}')
            .then((value) => value.readAsBytes())
            .then((data) => item.copyWith(data: data)),
    ]);
  }
}

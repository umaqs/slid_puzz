import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService() : _imagePicker = ImagePicker();

  final ImagePicker _imagePicker;

  Future<Uint8List?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
  }) async {
    final imageFile = await _imagePicker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    if (imageFile == null) {
      print('image file not picked');
      return null;
    }

    final data = await imageFile.readAsBytes();
    return data;
  }

  Future<List<Uint8List>?> splitImageIntoGrid({
    required Uint8List data,
    required int gridSize,
  }) async {
    if (kIsWeb) {
      //TODO(UMAIR): Use isolates/background workers to split the images
      return _splitImageIntoGrid(data: data, gridSize: gridSize);
    }
    try {
      var receivePort = ReceivePort();

      await Isolate.spawn(
        _decodeImageIsolate,
        _DecodeParam(data, gridSize, receivePort.sendPort),
      );

      return await receivePort.first as List<Uint8List>?;
    } catch (_) {
      return null;
    }
  }

  List<Uint8List>? _splitImageIntoGrid({
    required Uint8List data,
    required int gridSize,
  }) {
    final image = decodeImage(data);
    if (image == null) {
      return null;
    }

    var x = 0, y = 0;
    final width = (image.width / gridSize).round();
    final height = (image.height / gridSize).round();

    final pieceList = <Image>[];
    for (var i = 0; i < gridSize; i++) {
      for (var j = 0; j < gridSize; j++) {
        final copy = copyCrop(image, x, y, width, height);
        pieceList.add(copy);
        x += width;
      }
      x = 0;
      y += height;
    }

    return <Uint8List>[
      for (final image in pieceList) encodeJpg(image) as Uint8List,
    ];
  }

  void _decodeImageIsolate(_DecodeParam param) {
    final images = _splitImageIntoGrid(
      data: param.data,
      gridSize: param.gridSize,
    );
    param.sendPort.send(images);
  }
}

class _DecodeParam {
  const _DecodeParam(this.data, this.gridSize, this.sendPort);

  final Uint8List data;
  final int gridSize;
  final SendPort sendPort;
}

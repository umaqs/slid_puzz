import 'dart:typed_data';

import 'package:flutter/foundation.dart';
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
      if (kDebugMode) {
        print('image file not picked');
      }
      return null;
    }

    final data = await imageFile.readAsBytes();
    return data;
  }
}

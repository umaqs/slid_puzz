import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService() : _imagePicker = ImagePicker();

  final ImagePicker _imagePicker;

  Future<Uint8List?> searchImage({
    required String term,
  }) async {
    try {
      final uri = Uri.parse('https://source.unsplash.com/featured/500/?$term');
      final response = await http.get(uri);

      if (response.headers['x-imgix-id'] == '7dab072e2bcf469f60fa23c7cb543f2c426565ff') {
        return null;
      }
      return response.bodyBytes;
    } catch (e) {
      return null;
    }
  }

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

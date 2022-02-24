import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Represents remote themes in main menu
class MenuItem extends Equatable {
  /// Represents remote themes in main menu
  const MenuItem({
    required this.key,
    this.data,
    this.images,
  });

  /// Key to cache the image data
  final int key;

  /// Downloaded image data
  final Uint8List? data;

  /// Cropped images for this item
  final List<Uint8List>? images;

  @override
  List<Object?> get props => [key, data, images];

  /// Clones the instance by overriding the non-null parameters
  MenuItem copyWith({
    Uint8List? data,
  }) {
    return MenuItem(
      key: key,
      data: data ?? this.data,
      images: images,
    );
  }
}

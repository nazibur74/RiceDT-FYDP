import 'dart:io';

import 'package:image/image.dart' as img;

import 'tensor_converter.dart';

class ImagePreprocessor {
  static const int imageSize = 224;

  static List<List<List<List<double>>>> generateInput(File imageFile) {
    // Read image
    final bytes = imageFile.readAsBytesSync();

    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Unable to decode image.");
    }

    // --------------------------------------------------
    // STEP 1 : Center Crop
    // --------------------------------------------------

    final cropSize = image.width < image.height ? image.width : image.height;

    final offsetX = (image.width - cropSize) ~/ 2;
    final offsetY = (image.height - cropSize) ~/ 2;

    image = img.copyCrop(
      image,
      x: offsetX,
      y: offsetY,
      width: cropSize,
      height: cropSize,
    );

    // --------------------------------------------------
    // STEP 2 : Resize
    // --------------------------------------------------

    image = img.copyResize(
      image,
      width: imageSize,
      height: imageSize,
      interpolation: img.Interpolation.linear,
    );

    // --------------------------------------------------
    // STEP 3 : Convert to Tensor
    // --------------------------------------------------

    return TensorConverter.convert(image);
  }
}

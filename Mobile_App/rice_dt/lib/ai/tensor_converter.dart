import 'package:image/image.dart' as img;

class TensorConverter {
  static const List<double> mean = [0.485, 0.456, 0.406];

  static const List<double> std = [0.229, 0.224, 0.225];

  static List<List<List<List<double>>>> convert(img.Image image) {
    final input = List.generate(
      1,
      (_) => List.generate(
        image.height,
        (_) => List.generate(image.width, (_) => List.filled(3, 0.0)),
      ),
    );

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final r = pixel.r / 255.0;
        final g = pixel.g / 255.0;
        final b = pixel.b / 255.0;

        input[0][y][x][0] = (r - mean[0]) / std[0];
        input[0][y][x][1] = (g - mean[1]) / std[1];
        input[0][y][x][2] = (b - mean[2]) / std[2];
      }
    }

    return input;
  }
}

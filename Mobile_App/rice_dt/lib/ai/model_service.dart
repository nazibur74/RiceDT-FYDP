import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'image_preprocessor.dart';
import 'labels.dart';
import 'prediction.dart';

class ModelService {
  static final ModelService _instance = ModelService._internal();

  factory ModelService() => _instance;

  ModelService._internal();

  Interpreter? _interpreter;

  bool get isLoaded => _interpreter != null;

  Future<void> loadModel() async {
    if (_interpreter != null) return;

    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/mobilenetv3_se_float32.tflite',
      );

      print("========== MODEL LOADED ==========");
      print("Input Shape : ${_interpreter!.getInputTensor(0).shape}");
      print("Output Shape: ${_interpreter!.getOutputTensor(0).shape}");
    } on PlatformException catch (e) {
      throw Exception("Failed to load model: $e");
    }
  }

  Future<Prediction> predict(File imageFile) async {
    await loadModel();

    final input = ImagePreprocessor.generateInput(imageFile);

    final output = List.generate(
      1,
      (_) => List.filled(Labels.classes.length, 0.0),
    );

    _interpreter!.run(input, output);

    final logits = List<double>.from(output[0]);

    print("Raw logits : $logits");

    final probabilities = _softmax(logits);

    print("Softmax : $probabilities");

    int bestIndex = 0;

    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > probabilities[bestIndex]) {
        bestIndex = i;
      }
    }

    return Prediction(
      label: Labels.classes[bestIndex],
      confidence: probabilities[bestIndex],
    );
  }

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(max);

    final exps = logits.map((e) => exp(e - maxLogit)).toList();

    final sum = exps.reduce((a, b) => a + b);

    return exps.map((e) => e / sum).toList();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}

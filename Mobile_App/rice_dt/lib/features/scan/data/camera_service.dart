import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;
  bool _flashEnabled = false;

  CameraController? get controller => _controller;

  bool get flashEnabled => _flashEnabled;

  Future<void> initialize() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      throw Exception('No camera found on this device.');
    }

    // Prefer the back camera.
    CameraDescription selectedCamera = cameras.first;

    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        selectedCamera = camera;
        break;
      }
    }

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    // Always start with flash off.
    await _controller!.setFlashMode(FlashMode.off);
    _flashEnabled = false;
  }

  Future<XFile> captureImage() async {
    final camera = _controller;

    if (camera == null || !camera.value.isInitialized) {
      throw Exception('Camera is not initialized.');
    }

    if (camera.value.isTakingPicture) {
      throw Exception('A picture is already being captured.');
    }

    return camera.takePicture();
  }

  Future<bool> toggleFlash() async {
    final camera = _controller;

    if (camera == null || !camera.value.isInitialized) {
      throw Exception('Camera is not initialized.');
    }

    _flashEnabled = !_flashEnabled;

    await camera.setFlashMode(_flashEnabled ? FlashMode.torch : FlashMode.off);

    return _flashEnabled;
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}

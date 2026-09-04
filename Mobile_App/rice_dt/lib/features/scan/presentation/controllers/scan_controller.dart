import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rice_dt/features/scan/data/camera_service.dart';

final scanControllerProvider = FutureProvider<CameraService>((ref) async {
  final service = CameraService();

  await service.initialize();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

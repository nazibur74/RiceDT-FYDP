import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/settings_service.dart';

class SaveImageNotifier extends StateNotifier<bool> {
  SaveImageNotifier() : super(true) {
    _load();
  }

  Future<void> _load() async {
    state = await SettingsService.shouldSaveImage();
  }

  Future<void> toggle(bool value) async {
    state = value;
    await SettingsService.setSaveImage(value);
  }
}

final saveImageProvider = StateNotifierProvider<SaveImageNotifier, bool>(
  (ref) => SaveImageNotifier(),
);

import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _saveImageKey = 'save_scan_image';

  static Future<bool> shouldSaveImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_saveImageKey) ?? true;
  }

  static Future<void> setSaveImage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_saveImageKey, value);
  }
}

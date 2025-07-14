// helpers/sound_settings_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class SoundSettingsHelper {
  static const String _soundEnabledKey = 'sound_enabled';
  static SoundSettingsHelper? _instance;
  static Function(bool)? _onSoundToggled;

  SoundSettingsHelper._();

  static SoundSettingsHelper get instance {
    _instance ??= SoundSettingsHelper._();
    return _instance!;
  }

  // Callback function để thông báo khi âm thanh được bật/tắt
  void setOnSoundToggled(Function(bool) callback) {
    _onSoundToggled = callback;
  }

  // Lấy trạng thái âm thanh hiện tại
  Future<bool> isSoundEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_soundEnabledKey) ?? true; // Mặc định là bật
    } catch (e) {
      print('Error getting sound setting: $e');
      return true;
    }
  }

  // Cập nhật trạng thái âm thanh
  Future<void> setSoundEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundEnabledKey, enabled);

      // Thông báo cho music player
      if (_onSoundToggled != null) {
        _onSoundToggled!(enabled);
      }

      print('Sound setting updated: $enabled');
    } catch (e) {
      print('Error saving sound setting: $e');
    }
  }

  // Chuyển đổi trạng thái âm thanh
  Future<void> toggleSound() async {
    final currentState = await isSoundEnabled();
    await setSoundEnabled(!currentState);
  }
}
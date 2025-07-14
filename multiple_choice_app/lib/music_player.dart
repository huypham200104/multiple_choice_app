// music_player.dart
import 'package:audioplayers/audioplayers.dart';
import 'helpers/sound_settings_helper.dart';

class MusicPlayer {
  final AudioPlayer _player = AudioPlayer();
  final SoundSettingsHelper _soundSettings = SoundSettingsHelper.instance;
  bool _isPlaying = false;
  bool _shouldBePlaying = false;
  bool _isInitialized = false;

  MusicPlayer() {
    _initializeSoundSettings();
  }

  void _initializeSoundSettings() {
    if (!_isInitialized) {
      _soundSettings.setOnSoundToggled((enabled) async {
        print('Sound toggled: $enabled, should be playing: $_shouldBePlaying');

        if (enabled && _shouldBePlaying && !_isPlaying) {
          await _resumeInternal();
        } else if (!enabled && _isPlaying) {
          await _pauseInternal();
        }
      });
      _isInitialized = true;
    }
  }

  Future<void> playLoopMusic() async {
    try {
      _shouldBePlaying = true;
      final soundEnabled = await _soundSettings.isSoundEnabled();

      print('Starting music - Sound enabled: $soundEnabled');

      if (soundEnabled) {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.setVolume(0.5); // Đặt âm lượng vừa phải
        await _player.play(AssetSource('sound/baby_music.mp3'));
        _isPlaying = true;
        print('Music started playing');
      } else {
        print('Music not started - sound disabled');
      }
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      _shouldBePlaying = false;
      await _player.stop();
      _isPlaying = false;
      print('Music stopped');
    } catch (e) {
      print('Error stopping music: $e');
    }
  }

  Future<void> pauseMusic() async {
    try {
      _shouldBePlaying = false;
      await _pauseInternal();
      print('Music paused');
    } catch (e) {
      print('Error pausing music: $e');
    }
  }

  Future<void> _pauseInternal() async {
    if (_isPlaying) {
      await _player.pause();
      _isPlaying = false;
    }
  }

  Future<void> resumeMusic() async {
    try {
      _shouldBePlaying = true;
      await _resumeInternal();
      print('Music resumed');
    } catch (e) {
      print('Error resuming music: $e');
    }
  }

  Future<void> _resumeInternal() async {
    final soundEnabled = await _soundSettings.isSoundEnabled();
    if (soundEnabled && _shouldBePlaying && !_isPlaying) {
      await _player.resume();
      _isPlaying = true;
      print('Music resumed internally');
    }
  }

  // Getter để kiểm tra trạng thái
  bool get isPlaying => _isPlaying;
  bool get shouldBePlaying => _shouldBePlaying;

  void dispose() {
    _player.dispose();
  }
}

// Global instance
final MusicPlayer _musicPlayer = MusicPlayer();

// Public API functions
Future<void> startBackgroundMusic() async {
  await _musicPlayer.playLoopMusic();
}

Future<void> stopBackgroundMusic() async {
  await _musicPlayer.stopMusic();
}

Future<void> pauseBackgroundMusic() async {
  await _musicPlayer.pauseMusic();
}

Future<void> resumeBackgroundMusic() async {
  await _musicPlayer.resumeMusic();
}

// Getter để kiểm tra trạng thái
bool isBackgroundMusicPlaying() {
  return _musicPlayer.isPlaying;
}

bool shouldBackgroundMusicBePlaying() {
  return _musicPlayer.shouldBePlaying;
}

// Hàm để khởi tạo âm thanh khi app bắt đầu
Future<void> initializeMusicPlayer() async {
  // Chỉ cần gọi hàm này một lần khi app khởi động
  _musicPlayer._initializeSoundSettings();
}
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playLoopMusic() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('sound/baby_music.mp3'));
      print('Music started playing');
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      await _player.stop();
      print('Music stopped');
    } catch (e) {
      print('Error stopping music: $e');
    }
  }

  Future<void> pauseMusic() async {
    try {
      await _player.pause();
      print('Music paused');
    } catch (e) {
      print('Error pausing music: $e');
    }
  }

  Future<void> resumeMusic() async {
    try {
      await _player.resume();
      print('Music resumed');
    } catch (e) {
      print('Error resuming music: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}

final MusicPlayer _musicPlayer = MusicPlayer();

void startBackgroundMusic() {
  _musicPlayer.playLoopMusic();
}

void stopBackgroundMusic() {
  _musicPlayer.stopMusic();
}

void pauseBackgroundMusic() {
  _musicPlayer.pauseMusic();
}

void resumeBackgroundMusic() {
  _musicPlayer.resumeMusic();
}
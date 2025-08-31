import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playTap() async {
    await _player.play(AssetSource('audio/tap.mp3'));
  }

  Future<void> playMatch() async {
    await _player.play(AssetSource('audio/match.mp3'));
  }

  Future<void> playWin() async {
    await _player.play(AssetSource('audio/win.mp3'));
  }
}

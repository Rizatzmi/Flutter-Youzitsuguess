import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static Future<AudioPlayer> sfx(String file) {
    return AudioCache().play('file');
  }

  static Future<AudioPlayer> bgm() async {
    AudioPlayer advancedplayer;
    AudioCache audioCache;
    advancedplayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedplayer);
    audioCache.fixedPlayer.setReleaseMode(ReleaseMode.LOOP);
    return audioCache.play('audios/bensound-cute.mp3');
  }
}

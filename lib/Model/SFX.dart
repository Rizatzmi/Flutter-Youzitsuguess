import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

bool isPlaySfx = true;

class SFX {
  Future<AudioPlayer> click(bool isPLay) {
    if (isPLay == true) {
      return AudioCache()
          .play('audios/zapsplat_cartoon_slime_goo_bubbles_swamp_single_002_51669.mp3');
    } else {
      return null;
    }
  }

  Future<AudioPlayer> correct(bool isPLay) {
    if (isPLay == true) {
      return AudioCache()
          .play('audios/zapsplat_bells_small_bell_shop_door_ring_002_61905.mp3');
    } else {
      return null;
    }
  }

  Future<AudioPlayer> wrong(bool isPLay) {
    if (isPLay == true) {
      return AudioCache().play(
          'audios/zapsplat_multimedia_game_sound_basic_digital_retro_incorrect_error_negative_005_40466.mp3');
    } else {
      return null;
    }
  }
}

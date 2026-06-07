import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer player = AudioPlayer();

  Future<void> playFromUrl(String url) async {
    await player.play(UrlSource(url));
  }

  Future<void> stop() async {
    await player.stop();
  }
}

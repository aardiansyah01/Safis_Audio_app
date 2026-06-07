import '../services/audio_player_service.dart';

class AudioPlayerRepository {
  final AudioPlayerService service = AudioPlayerService();

  Future<void> play(String url) async {
    await service.playFromUrl(url);
  }

  Future<void> stop() async {
    await service.stop();
  }
}

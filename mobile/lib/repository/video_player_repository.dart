import 'package:video_player/video_player.dart';

import '../services/video_player_service.dart';

class VideoPlayerRepository {
  final VideoPlayerService service = VideoPlayerService();

  Future<VideoPlayerController> createController(String path) async {
    return service.createFileController(path);
  }

  Future<VideoPlayerController> createNetworkController(String url) async {
    return service.createNetworkController(url);
  }

  Future<void> play(VideoPlayerController controller) async {
    await service.play(controller);
  }

  Future<void> pause(VideoPlayerController controller) async {
    await service.pause(controller);
  }

  Future<void> dispose(VideoPlayerController? controller) async {
    await service.dispose(controller);
  }
}

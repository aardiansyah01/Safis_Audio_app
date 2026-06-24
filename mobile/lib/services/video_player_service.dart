import 'dart:io';

import 'package:video_player/video_player.dart';

class VideoPlayerService {
  Future<VideoPlayerController> createFileController(String path) async {
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    await controller.setLooping(true);
    return controller;
  }

  Future<VideoPlayerController> createNetworkController(String url) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    await controller.setLooping(true);
    return controller;
  }

  Future<void> play(VideoPlayerController controller) async {
    await controller.play();
  }

  Future<void> pause(VideoPlayerController controller) async {
    await controller.pause();
  }

  Future<void> dispose(VideoPlayerController? controller) async {
    await controller?.dispose();
  }
}

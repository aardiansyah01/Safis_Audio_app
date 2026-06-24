import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../viewmodel/upload_viewmodel.dart';

class ResultVideoPreviewCard extends StatelessWidget {
  const ResultVideoPreviewCard({super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadViewModel>();
    final VideoPlayerController? controller = vm.resultVideoController;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.video_file_rounded,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  vm.enhancedFile ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                controller != null && controller.value.isInitialized
                    ? _formatDuration(controller.value.duration)
                    : '--:--',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: double.infinity,
              height: 240,
              color: Colors.black,
              child: Builder(
                builder: (_) {
                  if (vm.isResultPreviewLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7C3AED),
                      ),
                    );
                  }

                  if (controller == null || !controller.value.isInitialized) {
                    return const Center(
                      child: Text(
                        "Preview video tidak tersedia",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final size = controller.value.size;
                  final videoWidth = size.width <= 0 ? 16.0 : size.width;
                  final videoHeight = size.height <= 0 ? 9.0 : size.height;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: videoWidth,
                            height: videoHeight,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: vm.toggleResultVideoPreview,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            controller.value.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 34,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

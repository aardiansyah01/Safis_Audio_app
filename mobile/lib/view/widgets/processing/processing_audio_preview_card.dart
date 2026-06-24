import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProcessingAudioPreviewCard extends StatefulWidget {
  final String filePath;
  final String fileName;

  const ProcessingAudioPreviewCard({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<ProcessingAudioPreviewCard> createState() =>
      _ProcessingAudioPreviewCardState();
}

class _ProcessingAudioPreviewCardState
    extends State<ProcessingAudioPreviewCard> {
  late final AudioPlayer _player;

  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    _player.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    } else {
      await _player.play(DeviceFileSource(widget.filePath));
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildWaveBar(double height, Color color) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _duration.inMilliseconds == 0 ? 1 : _duration.inMilliseconds;
    final current = _position.inMilliseconds.clamp(0, total);
    final progress = current / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.multitrack_audio_rounded,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  widget.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Text(
                _formatDuration(_duration),
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _WavePainter(progress: progress)),
                ),

                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWaveBar(12, const Color(0xFF2563EB)),
              const SizedBox(width: 4),
              _buildWaveBar(26, const Color(0xFF2563EB)),
              const SizedBox(width: 4),
              _buildWaveBar(18, const Color(0xFF93C5FD)),
              const SizedBox(width: 4),
              _buildWaveBar(30, const Color(0xFF2563EB)),
              const SizedBox(width: 4),
              _buildWaveBar(14, const Color(0xFF93C5FD)),
              const SizedBox(width: 4),
              _buildWaveBar(24, const Color(0xFF2563EB)),
              const SizedBox(width: 4),
              _buildWaveBar(16, const Color(0xFF93C5FD)),
              const SizedBox(width: 4),
              _buildWaveBar(28, const Color(0xFF2563EB)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;

  _WavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    final width = size.width;
    final height = size.height / 2;
    final amplitude = 12.0;

    path.moveTo(0, height);

    for (double x = 0; x <= width; x++) {
      final y =
          height +
          amplitude *
              (0.8 * (x / 18).sin() +
                  0.6 * (x / 11).cos() +
                  0.4 * (x / 27).sin());
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

extension on double {
  double sin() => MathHelper.sin(this);
  double cos() => MathHelper.cos(this);
}

class MathHelper {
  static double sin(double x) => math.sin(x);
  static double cos(double x) => math.cos(x);
}

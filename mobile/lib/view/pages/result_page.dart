import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UploadViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Processing Complete"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      "AI Enhancement Complete",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ENHANCED RESULT
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enhanced Result",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      "Original File: ${vm.selectedFile}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Enhanced File: ${vm.enhancedFile ?? '-'}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Noise Reduction: ${vm.noiseReduction.toInt()}%",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Audio Enhancement: ${vm.audioEnhancement.toInt()}%",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // INFO CARDS
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      title: "Noise Reduction",
                      value: "${vm.noiseReduction.toInt()}%",
                      icon: Icons.graphic_eq,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      title: "Clarity Boost",
                      value: "${vm.audioEnhancement.toInt()}%",
                      icon: Icons.auto_fix_high,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      title: "Status",
                      value: "Success",
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      title: "Output",
                      value: vm.enhancedFile ?? "-",
                      icon: Icons.audio_file,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PLAY
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: vm.enhancedFile == null
                      ? null
                      : () async {
                          await vm.playEnhancedAudio();
                        },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Play Enhanced Audio"),
                ),
              ),

              const SizedBox(height: 12),

              // STOP BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: vm.isPlaying
                      ? () async {
                          await vm.stopAudio();
                        }
                      : null,
                  icon: const Icon(Icons.stop),
                  label: const Text("Stop Audio"),
                ),
              ),

              const SizedBox(height: 12),

              // DOWNLOAD
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: vm.enhancedFile == null
                      ? null
                      : () async {
                          await vm.downloadEnhancedFile();

                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(vm.status)));
                          }
                        },
                  icon: const Icon(Icons.download),
                  label: const Text("Download Enhanced Audio"),
                ),
              ),

              const SizedBox(height: 12),

              // PROCESS AGAIN
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Process Again"),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 140),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}

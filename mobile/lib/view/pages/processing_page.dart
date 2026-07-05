import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';
import '../widgets/processing/processing_audio_preview_card.dart';
import '../widgets/processing/processing_process_button.dart';
import '../widgets/processing/processing_slider_card.dart';
import '../widgets/processing/processing_video_preview_card.dart';
import 'loading_page.dart';

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key});

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<UploadViewModel>().initializeProcessingPreview();
    });
  }

  @override
  void dispose() {
    context.read<UploadViewModel>().disposeProcessingPreview(notify: false);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UploadViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Audio Processing",
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vm.isProcessingVideo)
                const ProcessingVideoPreviewCard()
              else if (vm.isProcessingAudio)
                ProcessingAudioPreviewCard(
                  source: vm.isReprocessing
                      ? vm.originalFileUrl!
                      : vm.selectedLocalPath!,
                  fileName: vm.selectedFile,
                  isNetwork: vm.isReprocessing,
                ),

              const SizedBox(height: 18),

              ProcessingSliderCard(
                icon: Icons.graphic_eq_rounded,
                title: "Noise Reduction",
                value: vm.noiseReduction,
                valueColor: const Color(0xFF2563EB),
                activeColor: const Color(0xFF2563EB),
                leftLabel: "Subtle",
                rightLabel: "Aggressive",
                onChanged: vm.setNoiseReduction,
              ),

              const SizedBox(height: 16),

              ProcessingSliderCard(
                icon: Icons.auto_fix_high_rounded,
                title: "Audio Enhancement",
                value: vm.audioEnhancement,
                valueColor: const Color(0xFF7C3AED),
                activeColor: const Color(0xFF8B5CF6),
                leftLabel: "Natural",
                rightLabel: "Studio",
                onChanged: vm.setAudioEnhancement,
              ),

              const SizedBox(height: 28),

              ProcessingProcessButton(
                onPressed: () async {
                  if (vm.selectedLocalPath == null && !vm.isReprocessing) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("File belum dipilih")),
                    );
                    return;
                  }

                  await vm.stopAudio();
                  await vm.disposeProcessingPreview();

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoadingPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

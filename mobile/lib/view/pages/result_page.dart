import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';
import '../widgets/result/result_action_button.dart';
import '../widgets/result/result_audio_preview_card.dart';
import '../widgets/result/result_info_card.dart';
import '../widgets/result/result_success_banner.dart';
import '../widgets/result/result_video_preview_card.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UploadViewModel>().initializeResultPreview();
    });
  }

  @override
  void dispose() {
    // jangan pakai context.watch di dispose
    final vm = context.read<UploadViewModel>();
    vm.disposeResultPreview(notify: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Processing Complete",
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ResultSuccessBanner(),
              const SizedBox(height: 18),

              if (vm.enhancedFile != null) ...[
                if (vm.isEnhancedFileVideo)
                  const ResultVideoPreviewCard()
                else if (vm.isEnhancedFileAudio && vm.enhancedFileUrl != null)
                  ResultAudioPreviewCard(
                    fileName: vm.enhancedFile!,
                    audioUrl: vm.enhancedFileUrl!,
                  ),

                const SizedBox(height: 18),
              ],

              Row(
                children: [
                  Expanded(
                    child: ResultInfoCard(
                      icon: Icons.graphic_eq_rounded,
                      iconColor: const Color(0xFF2563EB),
                      value: "${vm.noiseReduction.toInt()}%",
                      label: "Noise Reduction",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ResultInfoCard(
                      icon: Icons.auto_fix_high_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      value: "${vm.audioEnhancement.toInt()}%",
                      label: "Clarity Boost",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: const ResultInfoCard(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: Color(0xFF10B981),
                      value: "Success",
                      label: "Status",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ResultInfoCard(
                      icon: Icons.insert_drive_file_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      value: vm.enhancedFile ?? "-",
                      label: "File Name",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              ResultActionButton(
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
                icon: Icons.download_rounded,
                label: vm.isEnhancedFileVideo
                    ? "Download Enhanced Video"
                    : "Download Enhanced Audio",
                isPrimary: true,
              ),

              const SizedBox(height: 12),

              ResultActionButton(
                onPressed: () async {
                  await vm.resetProcessingState();

                  if (!context.mounted) return;
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: Icons.refresh_rounded,
                label: "Process Again",
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/upload_viewmodel.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/recent_project_card.dart';
import '../widgets/home/upload_card.dart';
import 'processing_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color bgColor = Color(0xFFF5F8FC);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textSoft = Color(0xFF6B7280);

  Future<void> pickFile(BuildContext context) async {
    final vm = context.read<UploadViewModel>();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'mp4'],
    );

    if (result == null) return;

    final path = result.files.single.path!;
    final filename = result.files.single.name;

    vm.clearHistoryProject();

    vm.setSelectedFile(filename);
    vm.setSelectedLocalPath(path);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadViewModel>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 22),

              UploadCard(vm: vm, onTapUpload: () => pickFile(context)),

              const SizedBox(height: 18),

              _buildContinueButton(context, vm),

              const SizedBox(height: 28),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Projects",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: textDark,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _buildRecentProjectsList(context, vm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, UploadViewModel vm) {
    final bool hasFile = vm.selectedLocalPath != null || vm.isReprocessing;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: hasFile
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProcessingPage()),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasFile ? primaryBlue : const Color(0xFFE5E7EB),
          foregroundColor: hasFile ? Colors.white : const Color(0xFF9CA3AF),
          elevation: hasFile ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          "Continue",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildRecentProjectsList(BuildContext context, UploadViewModel vm) {
    if (vm.histories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          children: [
            Icon(
              Icons.library_music_outlined,
              size: 42,
              color: Color(0xFF9CA3AF),
            ),
            SizedBox(height: 12),
            Text(
              "Belum ada history project",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "History hasil processing akan muncul di sini",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: textSoft),
            ),
          ],
        ),
      );
    }

    final histories = vm.histories.take(4).toList();

    return Column(
      children: histories.map((history) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: RecentProjectCard(
            title: history.originalFile,
            subtitle: _formatDate(history.createdAt),
            status: "Done",
            onTap: () {
              vm.loadHistoryProject(history);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProcessingPage()),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      final day = dt.day.toString().padLeft(2, '0');
      final month = months[dt.month - 1];
      final year = dt.year;
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');

      return "$month $day, $year · $hour:$minute";
    } catch (_) {
      return rawDate;
    }
  }
}

import 'package:flutter/material.dart';

import '../../../viewmodel/upload_viewmodel.dart';
import 'format_chip.dart';

class UploadCard extends StatelessWidget {
  final UploadViewModel vm;
  final VoidCallback onTapUpload;

  const UploadCard({super.key, required this.vm, required this.onTapUpload});

  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF2563EB);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textSoft = Color(0xFF6B7280);
  static const Color borderBlue = Color(0xFFBFDBFE);
  static const Color successBg = Color(0xFFEAF8EF);
  static const Color successText = Color(0xFF2E9B57);

  @override
  Widget build(BuildContext context) {
    final bool hasFile = vm.selectedFile != "Tidak ada file dipilih";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderBlue, width: 2),
          color: const Color(0xFFF9FBFF),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTapUpload,
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: const LinearGradient(
                        colors: [primaryBlue, primaryBlueDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.30),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.file_upload_outlined,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Tap to Upload",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    hasFile
                        ? "File audio/video berhasil dipilih dan siap diproses"
                        : "Upload file audio atau video untuk dibersihkan oleh AI",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textSoft,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                FormatChip(label: "MP3"),
                FormatChip(label: "WAV"),
                FormatChip(label: "MP4"),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              "Max file size: 500 MB",
              style: TextStyle(
                color: textSoft,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            if (hasFile) ...[
              const SizedBox(height: 20),
              _SelectedFileCard(fileName: vm.selectedFile),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectedFileCard extends StatelessWidget {
  final String fileName;

  const _SelectedFileCard({required this.fileName});

  static const Color textDark = Color(0xFF1F2937);
  static const Color successBg = Color(0xFFEAF8EF);
  static const Color successText = Color(0xFF2E9B57);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: successBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBEBD6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: successText, size: 30),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "File berhasil dipilih. Kamu bisa lanjut ke halaman processing untuk mengatur Noise Reduction dan Audio Enhancement.",
                  style: TextStyle(
                    color: Color(0xFF4D6B54),
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

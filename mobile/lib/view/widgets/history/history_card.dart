import 'package:flutter/material.dart';

import '../../../model/history_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryModel history;

  final VoidCallback onDownload;
  final VoidCallback onReprocess;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.history,
    required this.onDownload,
    required this.onReprocess,
    required this.onDelete,
  });

  String _formatDate(String value) {
    try {
      final date = DateTime.parse(value);

      const months = [
        "",
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "Mei",
        "Jun",
        "Jul",
        "Agu",
        "Sep",
        "Okt",
        "Nov",
        "Des",
      ];

      return "${months[date.month]} ${date.day}, ${date.year}";
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = history.audioEnhancement / 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF4FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.graphic_eq,
                    color: Color(0xff2F6BFF),
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history.originalFile,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        _formatDate(history.createdAt),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF8EE),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: Color(0xff2E9B52),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xffE8EEF8),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xff2F6BFF),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  "${history.audioEnhancement.toInt()}%",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: "Download",
                  onPressed: onDownload,
                  icon: const Icon(
                    Icons.download_rounded,
                    color: Color(0xff2F6BFF),
                  ),
                ),

                IconButton(
                  tooltip: "Reprocess",
                  onPressed: onReprocess,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xff2F6BFF),
                  ),
                ),

                IconButton(
                  tooltip: "Delete",
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RecentProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;

  const RecentProjectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textSoft = Color(0xFF6B7280);
  static const Color doneBadgeBg = Color(0xFFE8F8EE);
  static const Color doneBadgeText = Color(0xFF2E9B57);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF5FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.multitrack_audio_rounded,
              color: primaryBlue,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: textSoft,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: doneBadgeBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: doneBadgeText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

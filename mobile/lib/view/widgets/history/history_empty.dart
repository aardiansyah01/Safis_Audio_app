import 'package:flutter/material.dart';

class HistoryEmpty extends StatelessWidget {
  final bool isSearching;

  const HistoryEmpty({super.key, this.isSearching = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                isSearching ? Icons.search_off_rounded : Icons.history_rounded,
                size: 46,
                color: const Color(0xFF9CA3AF),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              isSearching ? "History tidak ditemukan" : "Belum ada history",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              isSearching
                  ? "Coba gunakan kata kunci lain."
                  : "Setelah kamu memproses audio atau video, riwayat project akan muncul di halaman ini.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HistorySearchBar extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final ValueChanged<String> onChanged;

  const HistorySearchBar({
    super.key,
    required this.isSearching,
    required this.onToggleSearch,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "History",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            ElevatedButton.icon(
              onPressed: onToggleSearch,
              icon: Icon(isSearching ? Icons.close : Icons.search, size: 18),
              label: Text(isSearching ? "Close" : "Search"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xff2F6BFF),
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),

        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),

          crossFadeState: isSearching
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,

          firstChild: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: "Cari nama file...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(vertical: 16),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          secondChild: const SizedBox(height: 8),
        ),
      ],
    );
  }
}

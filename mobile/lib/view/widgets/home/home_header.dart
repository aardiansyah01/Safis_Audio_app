import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/auth_viewmodel.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const Color textDark = Color(0xFF1F2937);
  static const Color textSoft = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, auth, child) {
        final username = auth.currentUser?.username ?? "SafisAudio User";

        final avatar = username.isNotEmpty
            ? username.substring(0, 1).toUpperCase()
            : "SA";

        return Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Good morning,",
                    style: TextStyle(
                      color: textSoft,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    username,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: textDark,
                size: 26,
              ),
            ),
          ],
        );
      },
    );
  }
}

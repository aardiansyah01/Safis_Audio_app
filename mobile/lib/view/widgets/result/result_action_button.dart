import 'package:flutter/material.dart';

class ResultActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  const ResultActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isPrimary ? const Color(0xFF2563EB) : Colors.white;

    final Color textColor = isPrimary ? Colors.white : const Color(0xFF374151);

    final Color borderColor = isPrimary
        ? const Color(0xFF2563EB)
        : const Color(0xFFD1D5DB);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 18),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: isPrimary ? 0 : 0,
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }
}

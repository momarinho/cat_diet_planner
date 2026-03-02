import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color baseColor;

  const StatusBadge({super.key, required this.text, required this.baseColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: baseColor.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: baseColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

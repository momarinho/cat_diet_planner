import 'package:flutter/material.dart';

class GhostButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const GhostButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: colorScheme.primary, size: 20),
      label: Text(
        text,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,

        side: BorderSide(color: colorScheme.primary, width: 1.5),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),

        minimumSize: const Size(0, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }
}

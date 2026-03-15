import 'package:flutter/material.dart';

class PlanMetric extends StatelessWidget {
  const PlanMetric({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

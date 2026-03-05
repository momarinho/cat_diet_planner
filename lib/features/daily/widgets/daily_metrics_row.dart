import 'package:cat_diet_planner/core/widgets/app_card_container.dart';
import 'package:flutter/material.dart';

class DailyMetricsRow extends StatelessWidget {
  const DailyMetricsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MetricCard(title: 'CURRENT WEIGHT', value: '4.5', unit: 'kg'),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MetricCard(title: 'DAILY GOAL', value: '240', unit: 'kcal'),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return AppCardContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: primary,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: value,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.textTheme.bodyLarge?.color,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w700,
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

import 'package:flutter/material.dart';

class HistorySummaryCard extends StatelessWidget {
  const HistorySummaryCard({
    super.key,
    required this.latestWeight,
    required this.delta,
  });

  final double latestWeight;
  final double? delta;

  String get _trendLabel {
    if (delta == null) return 'Not enough data';
    if (delta! > 0) return 'Up';
    if (delta! < 0) return 'Down';
    return 'Stable';
  }

  String get _deltaLabel {
    if (delta == null) return '--';
    final sign = delta! > 0 ? '+' : '';
    return '$sign${delta!.toStringAsFixed(1)} kg';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Latest Weight',
              value: '${latestWeight.toStringAsFixed(1)} kg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryMetric(label: 'Recent Change', value: _deltaLabel),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryMetric(label: 'Trend', value: _trendLabel),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

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
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

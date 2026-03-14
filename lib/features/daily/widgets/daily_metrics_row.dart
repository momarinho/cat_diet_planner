import 'package:flutter/material.dart';

class DailyMetricsRow extends StatelessWidget {
  const DailyMetricsRow({
    super.key,
    required this.primaryMetricTitle,
    required this.primaryMetricValue,
    required this.primaryMetricUnit,
    required this.secondaryMetricTitle,
    required this.secondaryMetricValue,
    required this.secondaryMetricUnit,
  });

  final String primaryMetricTitle;
  final String primaryMetricValue;
  final String primaryMetricUnit;
  final String secondaryMetricTitle;
  final String secondaryMetricValue;
  final String secondaryMetricUnit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 360;
        final children = [
          Expanded(
            child: _MetricCard(
              title: primaryMetricTitle,
              value: primaryMetricValue,
              unit: primaryMetricUnit,
            ),
          ),
          Expanded(
            child: _MetricCard(
              title: secondaryMetricTitle,
              value: secondaryMetricValue,
              unit: secondaryMetricUnit,
            ),
          ),
        ];

        if (narrow) {
          return Column(
            children: [
              Row(children: [children[0]]),
              const SizedBox(height: 12),
              Row(children: [children[1]]),
            ],
          );
        }

        return Row(
          children: [children[0], const SizedBox(width: 16), children[1]],
        );
      },
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
    final labelColor = theme.colorScheme.primary;
    final valueColor = theme.colorScheme.onSurface;
    final unitColor = theme.colorScheme.onSurface.withValues(alpha: 0.72);
    final surfaceColor = theme.brightness == Brightness.dark
        ? const Color(0xFF342127)
        : const Color(0xFFFFFFFF).withValues(alpha: 0.76);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.16 : 0.04,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              text: value,
              style: theme.textTheme.displaySmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.4,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: unitColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
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

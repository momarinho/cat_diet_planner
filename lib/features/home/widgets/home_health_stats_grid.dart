import 'package:cat_diet_planner/features/home/providers/home_summary_provider.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card_container.dart';

class HomeHealthStatsGrid extends StatelessWidget {
  final HomeSummaryData? summary;

  const HomeHealthStatsGrid({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;
        final weightValue = summary == null
            ? '--'
            : '${summary!.currentWeight.toStringAsFixed(1)} kg';
        final weightStatus = summary?.weightTrendLabel ?? 'No data';
        final weightStatusColor =
            summary != null && summary!.weightTrendLabel.startsWith('+')
            ? AppTheme.warningYellow
            : AppTheme.successGreen;
        final goalValue = summary == null
            ? '--'
            : '${summary!.goalCalories.toStringAsFixed(0)} kcal';
        final goalStatus = summary == null
            ? 'No plan'
            : '${summary!.consumedCalories.toStringAsFixed(0)} consumed';
        final mealsValue = summary == null
            ? '--'
            : '${summary!.completedMeals}/${summary!.totalMeals}';
        final mealsStatus = summary == null
            ? 'No schedule'
            : '${summary!.remainingMeals} pending';
        final mealsStatusColor = summary != null && summary!.remainingMeals == 0
            ? AppTheme.successGreen
            : AppTheme.warningYellow;

        final cards = [
          Expanded(
            child: _StatCard(
              icon: Icons.monitor_weight_outlined,
              title: 'WEIGHT',
              value: weightValue,
              status: weightStatus,
              statusColor: weightStatusColor,
            ),
          ),
          Expanded(
            child: _StatCard(
              icon: Icons.local_fire_department_rounded,
              title: 'DAILY GOAL',
              value: goalValue,
              status: goalStatus,
              statusColor: AppTheme.primaryNeon,
            ),
          ),
          Expanded(
            child: _StatCard(
              icon: Icons.restaurant_rounded,
              title: 'MEALS',
              value: mealsValue,
              status: mealsStatus,
              statusColor: mealsStatusColor,
            ),
          ),
        ];

        if (isNarrow) {
          return Column(
            children: [
              Row(children: [cards[0]]),
              const SizedBox(height: 12),
              Row(children: [cards[1]]),
              const SizedBox(height: 12),
              Row(children: [cards[2]]),
            ],
          );
        }

        return Row(
          children: [
            cards[0],
            const SizedBox(width: 12),
            cards[1],
            const SizedBox(width: 12),
            cards[2],
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String status;
  final Color statusColor;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCardContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

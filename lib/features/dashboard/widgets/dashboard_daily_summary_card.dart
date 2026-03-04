import 'package:flutter/material.dart';

import '../../../core/widgets/app_card_container.dart';
import '../../../core/widgets/daily_summary_ring.dart';

class DashboardDailySummaryCard extends StatelessWidget {
  const DashboardDailySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    const consumed = 250;
    const goal = 400;
    final progress = (consumed / goal).clamp(0.0, 1.0).toDouble();
    final primary = Theme.of(context).colorScheme.primary;

    return AppCardContainer(
      child: Row(
        children: [
          const DailySummaryRing(
            consumedCalories: consumed,
            goalCalories: goal,
            size: 92,
            strokeWidth: 10,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CALORIE INTAKE',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '$consumed / $goal kcal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: progress,
                    backgroundColor: primary.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation(primary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${goal - consumed} kcal remaining for dinner',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

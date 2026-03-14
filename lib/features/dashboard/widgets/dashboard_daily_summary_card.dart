import 'package:cat_diet_planner/features/dashboard/providers/dashboard_summary_provider.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/app_card_container.dart';
import '../../../core/widgets/daily_summary_ring.dart';

class DashboardDailySummaryCard extends StatelessWidget {
  const DashboardDailySummaryCard({super.key, required this.summary});

  final DashboardSummaryData? summary;

  @override
  Widget build(BuildContext context) {
    final consumed = summary?.consumedCalories ?? 0;
    final goal = summary?.goalCalories ?? 0;
    final progress = (consumed / goal).clamp(0.0, 1.0).toDouble();
    final primary = Theme.of(context).colorScheme.primary;
    final remainingLabel = summary == null
        ? 'Create a plan to unlock your daily summary'
        : summary!.remainingCalories == 0
        ? 'Today is fully completed'
        : '${summary!.remainingCalories} kcal remaining for ${summary!.nextMealLabel.toLowerCase()}';

    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Daily Summary',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                'Today',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DailySummaryRing(
                consumedCalories: consumed,
                goalCalories: goal,
                size: 92,
                strokeWidth: 10,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CALORIE INTAKE',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        text: '$consumed',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w900,
                            ),
                        children: [
                          TextSpan(
                            text: ' / $goal kcal',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progress,
                        backgroundColor: primary.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation(primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      remainingLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

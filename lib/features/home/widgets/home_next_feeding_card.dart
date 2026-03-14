import 'package:cat_diet_planner/features/home/providers/home_summary_provider.dart';
import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card_container.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/status_badge.dart';

class HomeNextFeedingCard extends StatelessWidget {
  const HomeNextFeedingCard({super.key, required this.summary});

  final HomeSummaryData? summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final hasSummary = summary != null;
    final nextMealLabel = summary?.nextMealLabel ?? 'No feeding schedule yet';
    final nextMealTime = summary?.nextMealTime ?? 'Create a plan to see meals';
    final mealStatus = hasSummary
        ? '${summary!.remainingMeals} meal(s) remaining today'
        : 'Create a cat profile and diet plan first';
    final badgeText = !hasSummary
        ? 'SETUP'
        : summary!.remainingMeals == 0
        ? 'DONE'
        : '${summary!.remainingMeals} LEFT';

    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.schedule_rounded, color: primary, size: 22),
              Text(
                'Next Feeding',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              StatusBadge(
                text: badgeText,
                baseColor: summary?.remainingMeals == 0
                    ? AppTheme.successGreen
                    : AppTheme.primaryNeon,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 96,
                  height: 96,
                  color: primary.withValues(alpha: 0.10),
                  child: Icon(
                    summary?.remainingMeals == 0
                        ? Icons.check_circle_outline_rounded
                        : Icons.schedule_rounded,
                    color: primary,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextMealLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextMealTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mealStatus,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          NeonButton(
            text: hasSummary ? '🍴 View Today Plan' : '➕ Create Plan',
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(hasSummary ? AppRoutes.daily : AppRoutes.plans);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:cat_diet_planner/features/dashboard/providers/dashboard_summary_provider.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/meal_horizontal_card.dart';

class DashboardMealTimelineSection extends StatelessWidget {
  const DashboardMealTimelineSection({super.key, required this.summary});

  final DashboardSummaryData? summary;

  @override
  Widget build(BuildContext context) {
    final meals = summary?.meals ?? const <DashboardMealItem>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Meal Timeline',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              'View Plan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (meals.isEmpty)
          const AppEmptyState(
            icon: Icons.timeline_outlined,
            title: 'No timeline yet',
            description: 'Save a meal plan to unlock the meal timeline.',
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                for (var index = 0; index < meals.length; index++) ...[
                  MealHorizontalCard(
                    title: meals[index].title,
                    time: meals[index].time,
                    calories: meals[index].calories,
                    icon: dashboardMealIconForTitle(meals[index].title),
                    isCompleted: meals[index].isCompleted,
                    isNext: meals[index].isNext,
                  ),
                  if (index != meals.length - 1) const SizedBox(width: 12),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

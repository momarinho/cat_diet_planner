import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/widgets/meal_horizontal_card.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/daily/providers/daily_schedule_repository_provider.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/dashboard/providers/dashboard_summary_provider.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardMealTimelineSection extends ConsumerWidget {
  const DashboardMealTimelineSection({super.key, required this.cat});

  final CatProfile cat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final planRepository = ref.read(planRepositoryProvider);
    final scheduleRepository = ref.read(dailyScheduleRepositoryProvider);
    final todayKey = scheduleRepository.catDayKey(cat.id);

    return ValueListenableBuilder(
      valueListenable: planRepository.individualPlanListenable(),
      builder: (context, _, _) {
        final plan = planRepository.getPlanForCat(cat.id);
        if (plan == null ||
            !DailyMealScheduleService.isPlanActiveOn(
              startDate: plan.startDate,
            )) {
          return _TimelineScaffold(
            onViewPlan: () => Navigator.of(context).pushNamed(AppRoutes.plans),
            child: AppEmptyState(
              icon: Icons.timeline_outlined,
              title: l10n.noTimelineYetTitle,
              description: l10n.noTimelineYetDescription,
            ),
          );
        }

        DailyMealScheduleService.ensureTodaySchedule(cat: cat, plan: plan);

        return ValueListenableBuilder(
          valueListenable: scheduleRepository.mealsListenable(keys: [todayKey]),
          builder: (context, _, _) {
            final schedule =
                scheduleRepository.readSchedule(todayKey) ??
                DailyMealScheduleService.ensureTodaySchedule(
                  cat: cat,
                  plan: plan,
                );
            final items = ((schedule['items'] as List?) ?? const [])
                .map((item) => Map<String, dynamic>.from(item as Map))
                .where((item) => item['type'] == 'meal')
                .toList(growable: false);

            var nextMealIndex = -1;
            for (var index = 0; index < items.length; index++) {
              if (items[index]['completed'] != true) {
                nextMealIndex = index;
                break;
              }
            }

            final meals = List<DashboardMealItem>.generate(items.length, (
              index,
            ) {
              final item = items[index];
              return DashboardMealItem(
                id: item['id']?.toString() ?? 'meal_$index',
                title:
                    item['title']?.toString() ??
                    l10n.mealFallbackTitle(index + 1),
                time: item['time']?.toString() ?? '--:--',
                calories: ((item['kcal'] as num?)?.toDouble() ?? 0).round(),
                isCompleted: item['completed'] == true,
                isNext: index == nextMealIndex,
              );
            });

            return _TimelineScaffold(
              onViewPlan: () =>
                  Navigator.of(context).pushNamed(AppRoutes.plans),
              child: SingleChildScrollView(
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
                        onTap: () async {
                          await DailyMealScheduleService.markMealCompleted(
                            catId: cat.id,
                            mealId: meals[index].id,
                            completed: !meals[index].isCompleted,
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                meals[index].isCompleted
                                    ? l10n.mealMarkedPending(meals[index].title)
                                    : l10n.mealMarkedCompleted(
                                        meals[index].title,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (index != meals.length - 1) const SizedBox(width: 12),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TimelineScaffold extends StatelessWidget {
  const _TimelineScaffold({required this.child, required this.onViewPlan});

  final Widget child;
  final VoidCallback onViewPlan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context).mealTimelineTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            TextButton(
              onPressed: onViewPlan,
              child: Text(AppLocalizations.of(context).viewPlanAction),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

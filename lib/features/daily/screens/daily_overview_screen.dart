import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/features/cat_group/providers/selected_group_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_header_app_bar.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_metrics_row.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DailyOverviewScreen extends ConsumerWidget {
  const DailyOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroup = ref.watch(selectedGroupProvider);
    final selectedCat = ref.watch(selectedCatProvider);

    if (selectedGroup == null && selectedCat == null) {
      return const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: AppEmptyState(
              icon: Icons.today_outlined,
              title: 'Nothing selected yet',
              description:
                  'Select an individual cat or a group from Home and save a plan to unlock the daily dashboard.',
            ),
          ),
        ),
      );
    }

    if (selectedGroup != null) {
      return ValueListenableBuilder(
        valueListenable: HiveService.groupDietPlansBox.listenable(
          keys: [selectedGroup.id],
        ),
        builder: (context, Box<GroupDietPlan> box, _) {
          final plan = box.get(selectedGroup.id);

          if (plan == null) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AppEmptyState(
                    icon: Icons.calendar_view_day_outlined,
                    title: 'No group plan yet',
                    description:
                        'Save a meal plan for ${selectedGroup.name} in Plans before using Daily.',
                  ),
                ),
              ),
            );
          }

          DailyMealScheduleService.ensureTodayGroupSchedule(
            group: selectedGroup,
            plan: plan,
          );
          final scheduleKey = DailyMealScheduleService.todayKeyForGroup(
            selectedGroup.id,
          );

          return ValueListenableBuilder(
            valueListenable: HiveService.mealsBox.listenable(
              keys: [scheduleKey],
            ),
            builder: (context, _, _) {
              final schedule =
                  DailyMealScheduleService.loadTodayForGroup(
                    selectedGroup.id,
                  ) ??
                  DailyMealScheduleService.ensureTodayGroupSchedule(
                    group: selectedGroup,
                    plan: plan,
                  );
              final items = ((schedule['items'] as List?) ?? const [])
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList();

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 132),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyHeaderAppBar(
                        titleName: selectedGroup.name,
                        isGroup: true,
                      ),
                      const SizedBox(height: 24),
                      DailyMetricsRow(
                        primaryMetricTitle: 'GROUP SIZE',
                        primaryMetricValue: '${selectedGroup.catCount}',
                        primaryMetricUnit: 'cats',
                        secondaryMetricTitle: 'DAILY GOAL',
                        secondaryMetricValue: plan.targetKcalPerGroupPerDay
                            .toStringAsFixed(0),
                        secondaryMetricUnit: 'kcal',
                      ),
                      const SizedBox(height: 34),
                      DailyScheduleSection(
                        title: 'Today\'s Group Schedule',
                        showWeightCheckIn: false,
                        schedule: items,
                        onMealToggle: (item) async {
                          await DailyMealScheduleService.markGroupMealCompleted(
                            groupId: selectedGroup.id,
                            mealId: item['id'] as String,
                            completed: !(item['completed'] == true),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    if (selectedCat == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: HiveService.dietPlansBox.listenable(
        keys: [selectedCat.id],
      ),
      builder: (context, Box<DietPlan> box, _) {
        final plan = box.get(selectedCat.id);

        if (plan == null) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppEmptyState(
                  icon: Icons.calendar_view_day_outlined,
                  title: 'No meal plan yet',
                  description:
                      'Save a meal plan for ${selectedCat.name} in Plans before using Daily.',
                ),
              ),
            ),
          );
        }

        DailyMealScheduleService.ensureTodaySchedule(
          cat: selectedCat,
          plan: plan,
        );
        final scheduleKey = DailyMealScheduleService.todayKeyForCat(
          selectedCat.id,
        );

        return ValueListenableBuilder(
          valueListenable: HiveService.mealsBox.listenable(keys: [scheduleKey]),
          builder: (context, _, _) {
            final schedule =
                DailyMealScheduleService.loadTodayForCat(selectedCat.id) ??
                DailyMealScheduleService.ensureTodaySchedule(
                  cat: selectedCat,
                  plan: plan,
                );
            final items = ((schedule['items'] as List?) ?? const [])
                .map((item) => Map<String, dynamic>.from(item as Map))
                .toList();

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 132),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DailyHeaderAppBar(
                      titleName: selectedCat.name,
                      photoPath: selectedCat.photoPath,
                      photoBase64: selectedCat.photoBase64,
                    ),
                    const SizedBox(height: 24),
                    DailyMetricsRow(
                      primaryMetricTitle: 'CURRENT WEIGHT',
                      primaryMetricValue: selectedCat.weight.toStringAsFixed(1),
                      primaryMetricUnit: 'kg',
                      secondaryMetricTitle: 'DAILY GOAL',
                      secondaryMetricValue: plan.targetKcalPerDay
                          .toStringAsFixed(0),
                      secondaryMetricUnit: 'kcal',
                    ),
                    const SizedBox(height: 34),
                    DailyScheduleSection(
                      schedule: items,
                      onMealToggle: (item) async {
                        await DailyMealScheduleService.markMealCompleted(
                          catId: selectedCat.id,
                          mealId: item['id'] as String,
                          completed: !(item['completed'] == true),
                        );
                      },
                    ),
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

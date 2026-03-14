import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardMealItem {
  const DashboardMealItem({
    required this.id,
    required this.title,
    required this.time,
    required this.calories,
    required this.isCompleted,
    required this.isNext,
  });

  final String id;
  final String title;
  final String time;
  final int calories;
  final bool isCompleted;
  final bool isNext;
}

class DashboardSummaryData {
  const DashboardSummaryData({
    required this.goalCalories,
    required this.consumedCalories,
    required this.remainingCalories,
    required this.nextMealLabel,
    required this.meals,
  });

  final int goalCalories;
  final int consumedCalories;
  final int remainingCalories;
  final String nextMealLabel;
  final List<DashboardMealItem> meals;
}

final dashboardSummaryProvider =
    Provider.family<DashboardSummaryData?, CatProfile>((ref, cat) {
      final DietPlan? plan = HiveService.dietPlansBox.get(cat.id);
      if (plan == null) return null;

      final schedule = DailyMealScheduleService.ensureTodaySchedule(
        cat: cat,
        plan: plan,
      );

      final items = ((schedule['items'] as List?) ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .where((item) => item['type'] == 'meal')
          .toList();

      var nextMealIndex = -1;
      for (var index = 0; index < items.length; index++) {
        if (items[index]['completed'] != true) {
          nextMealIndex = index;
          break;
        }
      }

      final perMealCalories = plan.mealsPerDay == 0
          ? 0
          : (plan.targetKcalPerDay / plan.mealsPerDay).round();

      final meals = List<DashboardMealItem>.generate(items.length, (index) {
        final item = items[index];
        return DashboardMealItem(
          id: item['id']?.toString() ?? 'meal_$index',
          title: item['title']?.toString() ?? 'Meal ${index + 1}',
          time: item['time']?.toString() ?? '--:--',
          calories: perMealCalories,
          isCompleted: item['completed'] == true,
          isNext: index == nextMealIndex,
        );
      });

      final completedMeals = meals.where((meal) => meal.isCompleted).length;
      final consumedCalories = completedMeals * perMealCalories;
      final goalCalories = plan.targetKcalPerDay.round();
      final remainingCalories = goalCalories - consumedCalories;

      return DashboardSummaryData(
        goalCalories: goalCalories,
        consumedCalories: consumedCalories,
        remainingCalories: remainingCalories < 0 ? 0 : remainingCalories,
        nextMealLabel: nextMealIndex == -1
            ? 'All meals completed'
            : meals[nextMealIndex].title,
        meals: meals,
      );
    });

IconData dashboardMealIconForTitle(String title) {
  final normalized = title.toLowerCase();
  if (normalized.contains('breakfast')) return Icons.breakfast_dining;
  if (normalized.contains('lunch')) return Icons.lunch_dining;
  if (normalized.contains('dinner')) return Icons.dinner_dining;
  return Icons.restaurant_rounded;
}

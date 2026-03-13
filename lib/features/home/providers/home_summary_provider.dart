import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeSummaryData {
  const HomeSummaryData({
    required this.nextMealLabel,
    required this.nextMealTime,
    required this.remainingMeals,
    required this.completedMeals,
    required this.totalMeals,
    required this.goalCalories,
    required this.consumedCalories,
    required this.currentWeight,
    required this.weightTrendLabel,
    required this.insightTitle,
    required this.insightBody,
    required this.mealProgressBars,
  });

  final String nextMealLabel;
  final String nextMealTime;
  final int remainingMeals;
  final int completedMeals;
  final int totalMeals;
  final double goalCalories;
  final double consumedCalories;
  final double currentWeight;
  final String weightTrendLabel;
  final String insightTitle;
  final String insightBody;
  final List<HomeInsightBarData> mealProgressBars;
}

class HomeInsightBarData {
  const HomeInsightBarData({
    required this.height,
    required this.isCompleted,
    required this.isNext,
  });

  final double height;
  final bool isCompleted;
  final bool isNext;
}

final homeSummaryProvider = Provider<HomeSummaryData?>((ref) {
  final selectedCat = ref.watch(selectedCatProvider);
  if (selectedCat == null) return null;

  final DietPlan? plan = HiveService.dietPlansBox.get(selectedCat.id);

  final schedule = plan == null
      ? DailyMealScheduleService.loadTodayForCat(selectedCat.id)
      : DailyMealScheduleService.ensureTodaySchedule(
          cat: selectedCat,
          plan: plan,
        );

  final items = ((schedule?['items'] as List?) ?? const [])
      .map((item) => Map<String, dynamic>.from(item as Map))
      .where((item) => item['type'] == 'meal')
      .toList();

  final completedMeals = items
      .where((item) => item['completed'] == true)
      .length;
  final totalMeals = items.length;
  final remainingMeals = totalMeals - completedMeals;

  final consumedCalories = plan == null
      ? 0.0
      : completedMeals * (plan.targetKcalPerDay / plan.mealsPerDay);

  Map<String, dynamic>? nextMeal;
  var nextMealIndex = -1;
  for (var index = 0; index < items.length; index++) {
    final item = items[index];
    if (item['completed'] != true) {
      nextMeal = item;
      nextMealIndex = index;
      break;
    }
  }

  final currentWeight = selectedCat.weight;
  final previousWeight = selectedCat.weightHistory.length >= 2
      ? selectedCat.weightHistory[selectedCat.weightHistory.length - 2].weight
      : currentWeight;

  final delta = currentWeight - previousWeight;
  final weightTrendLabel = delta == 0
      ? 'Stable'
      : delta > 0
      ? '+${delta.toStringAsFixed(1)} kg'
      : '${delta.toStringAsFixed(1)} kg';

  final goalCalories = plan?.targetKcalPerDay ?? 0.0;

  final insightTitle = plan == null
      ? 'No active diet plan'
      : remainingMeals == 0
      ? 'Daily routine complete'
      : 'Next feeding scheduled';

  final insightBody = plan == null
      ? 'Create a plan to unlock next feeding and daily progress.'
      : remainingMeals == 0
      ? 'All planned meals for today were completed.'
      : '$remainingMeals meal(s) still pending today.';

  final mealProgressBars = items.isEmpty
      ? const <HomeInsightBarData>[]
      : List<HomeInsightBarData>.generate(items.length, (index) {
          final progress = items.length == 1 ? 1.0 : index / (items.length - 1);
          final height = 16 + (progress * 32);
          return HomeInsightBarData(
            height: height,
            isCompleted: items[index]['completed'] == true,
            isNext: index == nextMealIndex,
          );
        });

  return HomeSummaryData(
    nextMealLabel: nextMeal?['title']?.toString() ?? 'All meals done',
    nextMealTime: nextMeal?['time']?.toString() ?? 'Today complete',
    remainingMeals: remainingMeals,
    completedMeals: completedMeals,
    totalMeals: totalMeals,
    goalCalories: goalCalories,
    consumedCalories: consumedCalories,
    currentWeight: currentWeight,
    weightTrendLabel: weightTrendLabel,
    insightTitle: insightTitle,
    insightBody: insightBody,
    mealProgressBars: mealProgressBars,
  );
});

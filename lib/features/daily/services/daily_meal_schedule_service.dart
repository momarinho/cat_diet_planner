import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';

class DailyMealScheduleService {
  static const List<String> _defaultTimes = [
    '07:30 AM',
    '12:30 PM',
    '03:30 PM',
    '07:00 PM',
    '09:30 PM',
    '11:00 PM',
  ];

  static String todayKeyForCat(String catId, [DateTime? date]) {
    final target = date ?? DateTime.now();
    final day = target.toIso8601String().split('T').first;
    return '$catId:$day';
  }

  static Map<String, dynamic>? loadTodayForCat(String catId, [DateTime? date]) {
    final raw = HiveService.mealsBox.get(todayKeyForCat(catId, date));
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  static Map<String, dynamic> ensureTodaySchedule({
    required CatProfile cat,
    required DietPlan plan,
    DateTime? date,
  }) {
    final key = todayKeyForCat(cat.id, date);
    final existing = HiveService.mealsBox.get(key);
    if (existing != null) {
      return Map<String, dynamic>.from(existing);
    }

    final items = List.generate(plan.mealsPerDay, (index) {
      final kcal = plan.targetKcalPerDay / plan.mealsPerDay;
      return <String, dynamic>{
        'id': 'meal_${index + 1}',
        'title': _mealTitle(index),
        'subtitle':
            '${plan.foodName} • ${kcal.toStringAsFixed(0)} kcal • ${plan.portionGramsPerMeal.toStringAsFixed(1)} g',
        'time': _defaultTimes[index],
        'completed': false,
        'type': 'meal',
      };
    });

    final schedule = <String, dynamic>{
      'catId': cat.id,
      'date': (date ?? DateTime.now()).toIso8601String(),
      'planCreatedAt': plan.createdAt.toIso8601String(),
      'items': items,
    };

    HiveService.mealsBox.put(key, schedule);
    return schedule;
  }

  static Future<void> markMealCompleted({
    required String catId,
    required String mealId,
    required bool completed,
    DateTime? date,
  }) async {
    final key = todayKeyForCat(catId, date);
    final current = HiveService.mealsBox.get(key);
    if (current == null) return;

    final schedule = Map<String, dynamic>.from(current);
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    for (final item in items) {
      if (item['id'] == mealId) {
        item['completed'] = completed;
      }
    }

    schedule['items'] = items;
    await HiveService.mealsBox.put(key, schedule);
  }

  static int completedMealsCount(Map<String, dynamic> schedule) {
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .where((item) => item['type'] == 'meal');
    return items.where((item) => item['completed'] == true).length;
  }

  static int totalMealsCount(Map<String, dynamic> schedule) {
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .where((item) => item['type'] == 'meal');
    return items.length;
  }

  static String _mealTitle(int index) {
    switch (index) {
      case 0:
        return 'Breakfast';
      case 1:
        return 'Lunch';
      case 2:
        return 'Afternoon Meal';
      case 3:
        return 'Dinner';
      case 4:
        return 'Late Meal';
      default:
        return 'Meal ${index + 1}';
    }
  }
}

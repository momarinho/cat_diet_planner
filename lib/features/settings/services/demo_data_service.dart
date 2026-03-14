import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:cat_diet_planner/features/settings/services/app_settings_service.dart';

class DemoDataSummary {
  const DemoDataSummary({
    required this.cats,
    required this.groups,
    required this.foods,
    required this.mealSchedules,
  });

  final int cats;
  final int groups;
  final int foods;
  final int mealSchedules;
}

class DemoDataService {
  DemoDataService._();

  static const _photoLuna =
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=200&q=80';

  static Future<DemoDataSummary> seedReadyToTestScenario() async {
    final preservedThemeMode = HiveService.appSettingsBox.get('theme_mode');
    await clearAllLocalData();

    final now = DateTime.now();

    await AppSettingsService().save(
      const AppSettings(
        mealReminders: true,
        languageCode: 'en',
        reminderTimes: ['07:30', '12:30', '19:00'],
      ),
    );
    await HiveService.appSettingsBox.put(
      'theme_mode',
      preservedThemeMode is String ? preservedThemeMode : 'light',
    );

    const whiskasKey = 'food_whiskas_salmon';
    const royalCaninKey = 'food_royal_kitten';
    const hillsKey = 'food_hills_light';

    final foods = <String, FoodItem>{
      whiskasKey: FoodItem(
        barcode: '7891000101010',
        name: 'Whiskas Salmon Indoor',
        brand: 'Whiskas',
        kcalPer100g: 365,
        protein: 31,
        fat: 12,
      ),
      royalCaninKey: FoodItem(
        barcode: '7891000102024',
        name: 'Royal Canin Kitten',
        brand: 'Royal Canin',
        kcalPer100g: 402,
        protein: 34,
        fat: 18,
      ),
      hillsKey: FoodItem(
        barcode: '7891000103038',
        name: 'Hill\'s Light Adult',
        brand: 'Hill\'s',
        kcalPer100g: 318,
        protein: 29,
        fat: 9,
      ),
    };
    for (final entry in foods.entries) {
      await HiveService.foodsBox.put(entry.key, entry.value);
    }

    final rescueGroup = CatGroup(
      id: 'group-rescue-room',
      name: 'Rescue Room',
      catCount: 4,
      description: 'Shared feeding plan for the rescue cats staying together.',
      colorValue: 0xFFE87878,
      createdAt: now.subtract(const Duration(days: 30)),
    );
    await HiveService.catGroupsBox.put(rescueGroup.id, rescueGroup);

    final lunaWeights = [
      WeightRecord(
        date: now.subtract(const Duration(days: 14)),
        weight: 4.8,
        notes: 'Initial check-in',
      ),
      WeightRecord(
        date: now.subtract(const Duration(days: 7)),
        weight: 4.7,
        notes: 'Stable appetite',
      ),
      WeightRecord(
        date: now.subtract(const Duration(days: 3)),
        weight: 4.6,
        notes: 'More active this week',
      ),
      WeightRecord(
        date: now.subtract(const Duration(hours: 6)),
        weight: 4.6,
        notes: 'Good energy today',
      ),
    ];

    final luna = CatProfile(
      id: 'cat-luna-solo',
      name: 'Luna',
      weight: lunaWeights.last.weight,
      age: 36,
      neutered: true,
      activityLevel: 'moderate',
      goal: 'maintenance',
      createdAt: now.subtract(const Duration(days: 45)),
      weightHistory: lunaWeights,
      photoPath: _photoLuna,
    );
    await HiveService.catsBox.put(luna.id, luna);

    for (final record in lunaWeights) {
      await HiveService.weightsBox.add(record);
    }

    final lunaFood = foods[hillsKey]!;
    final lunaTargetKcal = DietCalculatorService.calculateMer(
      weightKg: luna.weight,
      ageMonths: luna.age,
      neutered: luna.neutered,
      activityLevel: luna.activityLevel,
      goal: luna.goal,
    );
    final lunaPortionPerDay = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: lunaTargetKcal,
      kcalPer100g: lunaFood.kcalPer100g,
    );
    final lunaPlan = DietPlan(
      catId: luna.id,
      foodKey: hillsKey,
      foodName: lunaFood.name,
      targetKcalPerDay: lunaTargetKcal,
      portionGramsPerDay: lunaPortionPerDay,
      mealsPerDay: 4,
      portionGramsPerMeal: DietCalculatorService.calculatePortionPerMealGrams(
        portionPerDayGrams: lunaPortionPerDay,
        mealsPerDay: 4,
      ),
      createdAt: now.subtract(const Duration(days: 2)),
      goal: luna.goal,
    );
    await HiveService.dietPlansBox.put(luna.id, lunaPlan);

    final groupFood = foods[whiskasKey]!;
    const targetPerCat = 220.0;
    final groupPortionPerCat = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: targetPerCat,
      kcalPer100g: groupFood.kcalPer100g,
    );
    final groupPlan = GroupDietPlan(
      groupId: rescueGroup.id,
      foodKey: whiskasKey,
      foodName: groupFood.name,
      catCount: rescueGroup.catCount,
      targetKcalPerCatPerDay: targetPerCat,
      targetKcalPerGroupPerDay: targetPerCat * rescueGroup.catCount,
      portionGramsPerCatPerDay: groupPortionPerCat,
      portionGramsPerGroupPerDay: groupPortionPerCat * rescueGroup.catCount,
      mealsPerDay: 3,
      portionGramsPerGroupPerMeal:
          DietCalculatorService.calculatePortionPerMealGrams(
            portionPerDayGrams: groupPortionPerCat * rescueGroup.catCount,
            mealsPerDay: 3,
          ),
      createdAt: now.subtract(const Duration(days: 1)),
    );
    await HiveService.groupDietPlansBox.put(rescueGroup.id, groupPlan);

    DailyMealScheduleService.ensureTodaySchedule(cat: luna, plan: lunaPlan);
    await DailyMealScheduleService.markMealCompleted(
      catId: luna.id,
      mealId: 'meal_1',
      completed: true,
    );
    await DailyMealScheduleService.markMealCompleted(
      catId: luna.id,
      mealId: 'meal_2',
      completed: true,
    );

    DailyMealScheduleService.ensureTodayGroupSchedule(
      group: rescueGroup,
      plan: groupPlan,
    );
    await DailyMealScheduleService.markGroupMealCompleted(
      groupId: rescueGroup.id,
      mealId: 'group_meal_1',
      completed: true,
    );

    return DemoDataSummary(
      cats: HiveService.catsBox.length,
      groups: HiveService.catGroupsBox.length,
      foods: HiveService.foodsBox.length,
      mealSchedules: HiveService.mealsBox.length,
    );
  }

  static Future<void> clearAllLocalData() async {
    await HiveService.groupDietPlansBox.clear();
    await HiveService.dietPlansBox.clear();
    await HiveService.mealsBox.clear();
    await HiveService.weightsBox.clear();
    await HiveService.catsBox.clear();
    await HiveService.catGroupsBox.clear();
    await HiveService.foodsBox.clear();
    await HiveService.appSettingsBox.clear();
  }
}

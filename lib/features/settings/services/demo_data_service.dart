import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/core/constants/app_limits.dart';
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
      AppSettings.defaults().copyWith(
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
        catId: 'cat-luna-solo',
        date: now.subtract(const Duration(days: 14)),
        weight: 4.8,
        notes: 'Initial check-in',
      ),
      WeightRecord(
        catId: 'cat-luna-solo',
        date: now.subtract(const Duration(days: 7)),
        weight: 4.7,
        notes: 'Stable appetite',
      ),
      WeightRecord(
        catId: 'cat-luna-solo',
        date: now.subtract(const Duration(days: 3)),
        weight: 4.6,
        notes: 'More active this week',
      ),
      WeightRecord(
        catId: 'cat-luna-solo',
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
      goal: 'senior_support',
      createdAt: now.subtract(const Duration(days: 45)),
      weightHistory: lunaWeights,
      photoPath: _photoLuna,
      preferredMealsPerDay: 4,
      manualTargetKcal: 235,
      notes:
          'Prefers smaller meals and benefits from a gentle maintenance target.',
      // clinical & routine demo fields
      idealWeight: 4.7,
      bcs: 5,
      sex: 'female',
      breed: 'Domestic Shorthair',
      birthDate: DateTime(now.year - 3, now.month, now.day),
      customActivityLevel: null,
      clinicalConditions: const ['sensitive_stomach'],
      allergies: const ['chicken'],
      dietaryPreferences: const ['low_fat'],
      vetNotes: 'Routine check: good condition.',
    );
    await HiveService.catsBox.put(luna.id, luna);

    for (final record in lunaWeights) {
      await HiveService.weightsBox.add(record);
    }

    final lunaFood = foods[hillsKey]!;
    final lunaTargetKcal = DietCalculatorService.suggestTargetKcal(
      weightKg: luna.weight,
      idealWeightKg: luna.idealWeight,
      ageMonths: luna.age,
      neutered: luna.neutered,
      activityLevel: luna.activityLevel,
      goal: luna.goal,
      bcs: luna.bcs,
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
      mealTimes: DailyMealScheduleService.suggestedMealTimes(4),
      mealLabels: DailyMealScheduleService.suggestedMealLabels(4),
      mealPortionGrams: DailyMealScheduleService.normalizeMealPortions(
        mealPortions: null,
        totalPortionGrams: lunaPortionPerDay,
        mealsPerDay: 4,
      ),
      startDate: now.subtract(const Duration(days: 2)),
      planId: 'plan-${luna.id}-default',
    );
    await HiveService.dietPlansBox.put(lunaPlan.planId, lunaPlan);
    luna.activePlanId = lunaPlan.planId;
    await luna.save();

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
      mealTimes: DailyMealScheduleService.suggestedMealTimes(3),
      mealLabels: DailyMealScheduleService.suggestedMealLabels(3),
      mealPortionGrams: DailyMealScheduleService.normalizeMealPortions(
        mealPortions: null,
        totalPortionGrams: groupPortionPerCat * rescueGroup.catCount,
        mealsPerDay: 3,
      ),
      startDate: now.subtract(const Duration(days: 1)),
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

  static Future<DemoDataSummary> seedOperationalStressScenario({
    int cats = AppLimits.maxCats,
    int groups = AppLimits.maxGroups,
  }) async {
    final safeCats = cats.clamp(1, AppLimits.maxCats);
    final safeGroups = groups.clamp(1, AppLimits.maxGroups);
    final preservedThemeMode = HiveService.appSettingsBox.get('theme_mode');
    await clearAllLocalData();

    final now = DateTime.now();
    await AppSettingsService().save(
      AppSettings.defaults().copyWith(
        mealReminders: true,
        languageCode: 'en',
        reminderTimes: const ['06:30', '11:30', '16:30', '21:00'],
      ),
    );
    await HiveService.appSettingsBox.put(
      'theme_mode',
      preservedThemeMode is String ? preservedThemeMode : 'light',
    );

    final foods = <String, FoodItem>{
      'food_stress_dry_1': FoodItem(
        barcode: '7891000201010',
        name: 'Stress Dry Mix',
        brand: 'CatDiet',
        kcalPer100g: 360,
        protein: 30,
        fat: 13,
      ),
      'food_stress_wet_1': FoodItem(
        barcode: '7891000202024',
        name: 'Stress Wet Turkey',
        brand: 'CatDiet',
        kcalPer100g: 112,
        protein: 10,
        fat: 5,
      ),
      'food_stress_light_1': FoodItem(
        barcode: '7891000203038',
        name: 'Stress Light Control',
        brand: 'CatDiet',
        kcalPer100g: 319,
        protein: 29,
        fat: 9,
      ),
    };
    for (final entry in foods.entries) {
      await HiveService.foodsBox.put(entry.key, entry.value);
    }

    final foodKeys = foods.keys.toList(growable: false);
    final createdCatIds = <String>[];

    for (var i = 0; i < safeCats; i++) {
      final id = 'cat-stress-${i + 1}';
      final weight = 3.2 + ((i % 5) * 0.5);
      final ageMonths = 12 + (i * 4);
      final weights = <WeightRecord>[
        WeightRecord(
          catId: id,
          date: now.subtract(Duration(days: 14 - (i % 4))),
          weight: weight + 0.1,
          notes: 'Initial baseline',
        ),
        WeightRecord(
          catId: id,
          date: now.subtract(Duration(days: 7 - (i % 3))),
          weight: weight,
          notes: 'Follow-up',
        ),
      ];

      final cat = CatProfile(
        id: id,
        name: 'Cat ${i + 1}',
        weight: weight,
        age: ageMonths,
        neutered: i % 2 == 0,
        activityLevel: i % 3 == 0 ? 'active' : 'moderate',
        goal: i % 4 == 0 ? 'loss' : 'maintenance',
        createdAt: now.subtract(Duration(days: 60 - i)),
        weightHistory: weights,
        preferredMealsPerDay: i % 2 == 0 ? 4 : 3,
        idealWeight: weight - 0.2,
        bcs: 5 + (i % 2),
        sex: i % 2 == 0 ? 'female' : 'male',
      );
      await HiveService.catsBox.put(cat.id, cat);
      createdCatIds.add(cat.id);
      for (final record in weights) {
        await HiveService.weightsBox.add(record);
      }

      final foodKey = foodKeys[i % foodKeys.length];
      final food = foods[foodKey]!;
      final targetKcal = DietCalculatorService.suggestTargetKcal(
        weightKg: cat.weight,
        idealWeightKg: cat.idealWeight,
        ageMonths: cat.age,
        neutered: cat.neutered,
        activityLevel: cat.activityLevel,
        goal: cat.goal,
        bcs: cat.bcs,
      );
      final portionPerDay = DietCalculatorService.calculateDailyPortionGrams(
        targetKcal: targetKcal,
        kcalPer100g: food.kcalPer100g,
      );
      final mealsPerDay = cat.preferredMealsPerDay;
      final plan = DietPlan(
        catId: cat.id,
        foodKey: foodKey,
        foodName: food.name,
        targetKcalPerDay: targetKcal,
        portionGramsPerDay: portionPerDay,
        mealsPerDay: mealsPerDay,
        portionGramsPerMeal: DietCalculatorService.calculatePortionPerMealGrams(
          portionPerDayGrams: portionPerDay,
          mealsPerDay: mealsPerDay,
        ),
        createdAt: now.subtract(Duration(hours: i)),
        goal: cat.goal,
        mealTimes: DailyMealScheduleService.suggestedMealTimes(mealsPerDay),
        mealLabels: DailyMealScheduleService.suggestedMealLabels(mealsPerDay),
        mealPortionGrams: DailyMealScheduleService.normalizeMealPortions(
          mealPortions: null,
          totalPortionGrams: portionPerDay,
          mealsPerDay: mealsPerDay,
        ),
        startDate: now.subtract(const Duration(days: 1)),
        planId: 'plan-${cat.id}-default',
      );
      await HiveService.dietPlansBox.put(plan.planId, plan);
      cat.activePlanId = plan.planId;
      await cat.save();
      DailyMealScheduleService.ensureTodaySchedule(cat: cat, plan: plan);
    }

    final catChunks = <List<String>>[];
    final chunkSize = (safeCats / safeGroups).ceil();
    for (var i = 0; i < createdCatIds.length; i += chunkSize) {
      final end = (i + chunkSize > createdCatIds.length)
          ? createdCatIds.length
          : i + chunkSize;
      catChunks.add(createdCatIds.sublist(i, end));
    }

    for (var i = 0; i < safeGroups; i++) {
      final members = i < catChunks.length ? catChunks[i] : <String>[];
      final groupId = 'group-stress-${i + 1}';
      final group = CatGroup(
        id: groupId,
        name: 'Group ${i + 1}',
        catCount: members.length,
        description: 'Operational stress scenario group ${i + 1}.',
        colorValue: 0xFF6EA8FE + (i * 3333),
        createdAt: now.subtract(Duration(days: 10 + i)),
        catIds: members,
        subgroup: i % 2 == 0 ? 'ward_a' : 'ward_b',
        category: i % 2 == 0 ? 'recovery' : 'maintenance',
        feedingShareByCat: {for (final catId in members) catId: 1.0},
        enclosure: 'Room ${i + 1}',
        environment: i % 2 == 0 ? 'indoor' : 'mixed',
        shiftMorningNotes: 'Morning checklist for group ${i + 1}.',
      );
      await HiveService.catGroupsBox.put(group.id, group);

      final foodKey = foodKeys[(i + 1) % foodKeys.length];
      final food = foods[foodKey]!;
      const targetPerCat = 210.0;
      final totalCats = members.isEmpty ? 1 : members.length;
      final portionPerCat = DietCalculatorService.calculateDailyPortionGrams(
        targetKcal: targetPerCat,
        kcalPer100g: food.kcalPer100g,
      );
      final groupMealsPerDay = i % 2 == 0 ? 3 : 4;
      final groupTotalPortion = portionPerCat * totalCats;
      final groupPlan = GroupDietPlan(
        groupId: group.id,
        foodKey: foodKey,
        foodName: food.name,
        catCount: totalCats,
        targetKcalPerCatPerDay: targetPerCat,
        targetKcalPerGroupPerDay: targetPerCat * totalCats,
        portionGramsPerCatPerDay: portionPerCat,
        portionGramsPerGroupPerDay: groupTotalPortion,
        mealsPerDay: groupMealsPerDay,
        portionGramsPerGroupPerMeal:
            DietCalculatorService.calculatePortionPerMealGrams(
              portionPerDayGrams: groupTotalPortion,
              mealsPerDay: groupMealsPerDay,
            ),
        createdAt: now.subtract(Duration(hours: i)),
        mealTimes: DailyMealScheduleService.suggestedMealTimes(
          groupMealsPerDay,
        ),
        mealLabels: DailyMealScheduleService.suggestedMealLabels(
          groupMealsPerDay,
        ),
        mealPortionGrams: DailyMealScheduleService.normalizeMealPortions(
          mealPortions: null,
          totalPortionGrams: groupTotalPortion,
          mealsPerDay: groupMealsPerDay,
        ),
        startDate: now.subtract(const Duration(days: 1)),
      );
      await HiveService.groupDietPlansBox.put(group.id, groupPlan);
      DailyMealScheduleService.ensureTodayGroupSchedule(
        group: group,
        plan: groupPlan,
      );
    }

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

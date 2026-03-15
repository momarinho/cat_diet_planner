import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';

class PlanPreviewBuilder {
  const PlanPreviewBuilder._();

  static PlanPreviewData buildIndividual({
    required CatProfile cat,
    required List<FoodItem> selectedFoods,
    required int mealsPerDay,
    required List<String> mealTimes,
    required List<String> mealLabels,
    required List<double> normalizedMealShares,
    required DateTime startDate,
    required String portionUnit,
    required double portionUnitGrams,
    required Map<int, Map<dynamic, dynamic>> dailyOverrides,
    String? operationalNotes,
  }) {
    final representativeFood = selectedFoods.first;
    final targetKcalPerDay =
        cat.manualTargetKcal ??
        DietCalculatorService.suggestTargetKcal(
          weightKg: cat.weight,
          idealWeightKg: cat.idealWeight,
          ageMonths: cat.age,
          neutered: cat.neutered,
          activityLevel: cat.activityLevel,
          goal: cat.goal,
          bcs: cat.bcs,
        );
    final portionGramsPerDay = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: targetKcalPerDay,
      kcalPer100g: representativeFood.kcalPer100g,
    );
    final portionGramsPerMeal =
        DietCalculatorService.calculatePortionPerMealGrams(
          portionPerDayGrams: portionGramsPerDay,
          mealsPerDay: mealsPerDay,
        );

    return PlanPreviewData(
      title: 'Plan Preview',
      foodNames: selectedFoods.map((food) => food.name).toList(growable: false),
      targetKcalPerDay: targetKcalPerDay,
      portionGramsPerDay: portionGramsPerDay,
      portionGramsPerMeal: portionGramsPerMeal,
      mealsPerDay: mealsPerDay,
      mealTimes: DailyMealScheduleService.normalizeMealTimes(
        mealTimes,
        mealsPerDay: mealsPerDay,
      ),
      mealLabels: DailyMealScheduleService.normalizeMealLabels(
        mealLabels,
        mealsPerDay: mealsPerDay,
      ),
      mealPortionGrams: normalizedMealShares
          .map((share) => portionGramsPerDay * (share / 100))
          .toList(growable: false),
      startDate: startDate,
      portionUnit: portionUnit,
      portionUnitGrams: portionUnitGrams,
      dailyOverrides: dailyOverrides,
      operationalNotes: operationalNotes,
      goalLabel: cat.goal,
    );
  }

  static PlanPreviewData buildGroup({
    required String groupName,
    required int catCount,
    required double targetKcalPerCat,
    required List<FoodItem> selectedFoods,
    required int mealsPerDay,
    required List<String> mealTimes,
    required List<String> mealLabels,
    required List<double> normalizedMealShares,
    required DateTime startDate,
    required String portionUnit,
    required double portionUnitGrams,
    String? operationalNotes,
  }) {
    final representativeFood = selectedFoods.first;
    final targetKcalPerDay = targetKcalPerCat * catCount;
    final portionGramsPerDay = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: targetKcalPerDay,
      kcalPer100g: representativeFood.kcalPer100g,
    );
    final portionGramsPerMeal =
        DietCalculatorService.calculatePortionPerMealGrams(
          portionPerDayGrams: portionGramsPerDay,
          mealsPerDay: mealsPerDay,
        );

    return PlanPreviewData(
      title: 'Group Plan Preview',
      foodNames: selectedFoods.map((food) => food.name).toList(growable: false),
      targetKcalPerDay: targetKcalPerDay,
      portionGramsPerDay: portionGramsPerDay,
      portionGramsPerMeal: portionGramsPerMeal,
      mealsPerDay: mealsPerDay,
      mealTimes: DailyMealScheduleService.normalizeMealTimes(
        mealTimes,
        mealsPerDay: mealsPerDay,
      ),
      mealLabels: DailyMealScheduleService.normalizeMealLabels(
        mealLabels,
        mealsPerDay: mealsPerDay,
      ),
      mealPortionGrams: normalizedMealShares
          .map((share) => portionGramsPerDay * (share / 100))
          .toList(growable: false),
      startDate: startDate,
      portionUnit: portionUnit,
      portionUnitGrams: portionUnitGrams,
      dailyOverrides: const {},
      operationalNotes: operationalNotes,
      catCount: catCount,
      goalLabel: groupName,
    );
  }
}

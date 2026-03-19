import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';
import 'package:cat_diet_planner/features/plans/services/portion/portion_unit_service.dart';

class PlanPreviewBuilder {
  const PlanPreviewBuilder._();

  static dynamic _foodReferenceKey(FoodItem food, int index) {
    return food.key ?? food.barcode ?? '${food.name}#$index';
  }

  static double? _gramsPerServingUnit(FoodItem food) {
    final packageGrams = PortionUnitService.extractGramsFromPackageSize(
      food.packageSize,
    );
    if (packageGrams != null && packageGrams > 0) {
      return packageGrams;
    }

    final canonicalUnit = PortionUnitService.canonicalServingUnit(
      food.servingUnit,
    );
    if (canonicalUnit == null) return null;
    try {
      return PortionUnitService.gramsPerUnit(canonicalUnit);
    } catch (_) {
      return null;
    }
  }

  static Map<dynamic, double> normalizedFoodSplitPercentByKcal({
    required List<FoodItem> selectedFoods,
    Map<dynamic, double> foodSplitPercentByKcal = const {},
  }) {
    if (selectedFoods.isEmpty) return const {};
    if (selectedFoods.length == 1) {
      return {_foodReferenceKey(selectedFoods.first, 0): 100.0};
    }

    final selectedKeys = selectedFoods
        .asMap()
        .entries
        .map((entry) => _foodReferenceKey(entry.value, entry.key))
        .toList(growable: false);
    final provided = <dynamic, double>{};
    for (final key in selectedKeys) {
      final raw = foodSplitPercentByKcal[key];
      if (raw != null && raw > 0) {
        provided[key] = raw;
      }
    }

    if (provided.length != selectedKeys.length) {
      final equalShare = 100 / selectedKeys.length;
      return {for (final key in selectedKeys) key: equalShare};
    }

    final total = provided.values.fold<double>(
      0.0,
      (sum, value) => sum + value,
    );
    if (total <= 0) {
      final equalShare = 100 / selectedKeys.length;
      return {for (final key in selectedKeys) key: equalShare};
    }

    return {
      for (final key in selectedKeys) key: ((provided[key] ?? 0) / total) * 100,
    };
  }

  static List<FoodPortionSplitData> buildFoodBreakdown({
    required List<FoodItem> selectedFoods,
    required double targetKcalPerDay,
    required int mealsPerDay,
    required List<double> normalizedMealShares,
    Map<dynamic, double> foodSplitPercentByKcal = const {},
  }) {
    if (selectedFoods.isEmpty) return const [];

    final normalizedSplits = normalizedFoodSplitPercentByKcal(
      selectedFoods: selectedFoods,
      foodSplitPercentByKcal: foodSplitPercentByKcal,
    );

    return selectedFoods
        .asMap()
        .entries
        .map((entry) {
          final food = entry.value;
          final foodKey = _foodReferenceKey(food, entry.key);
          final sharePercent = normalizedSplits[foodKey] ?? 0.0;
          final splitTargetKcalPerDay = targetKcalPerDay * (sharePercent / 100);
          final splitPortionGramsPerDay =
              DietCalculatorService.calculateDailyPortionGrams(
                targetKcal: splitTargetKcalPerDay,
                kcalPer100g: food.kcalPer100g,
              );
          final splitPortionGramsPerMeal =
              DietCalculatorService.calculatePortionPerMealGrams(
                portionPerDayGrams: splitPortionGramsPerDay,
                mealsPerDay: mealsPerDay,
              );
          final splitMealPortionGrams = normalizedMealShares
              .map((share) => splitPortionGramsPerDay * (share / 100))
              .toList(growable: false);
          final servingUnit = PortionUnitService.canonicalServingUnit(
            food.servingUnit,
          );
          final gramsPerServingUnit = _gramsPerServingUnit(food);

          return FoodPortionSplitData(
            foodKey: foodKey,
            foodName: food.name,
            sharePercent: sharePercent,
            targetKcalPerDay: splitTargetKcalPerDay,
            portionGramsPerDay: splitPortionGramsPerDay,
            portionGramsPerMeal: splitPortionGramsPerMeal,
            mealPortionGrams: splitMealPortionGrams,
            servingUnit: servingUnit,
            gramsPerServingUnit: gramsPerServingUnit,
            servingUnitsPerDay: gramsPerServingUnit == null
                ? null
                : splitPortionGramsPerDay / gramsPerServingUnit,
            servingUnitsPerMeal: gramsPerServingUnit == null
                ? null
                : splitPortionGramsPerMeal / gramsPerServingUnit,
          );
        })
        .toList(growable: false);
  }

  static double calculateTotalPortionGramsPerDay({
    required List<FoodItem> selectedFoods,
    required double targetKcalPerDay,
    required int mealsPerDay,
    required List<double> normalizedMealShares,
    Map<dynamic, double> foodSplitPercentByKcal = const {},
  }) {
    final breakdown = buildFoodBreakdown(
      selectedFoods: selectedFoods,
      targetKcalPerDay: targetKcalPerDay,
      mealsPerDay: mealsPerDay,
      normalizedMealShares: normalizedMealShares,
      foodSplitPercentByKcal: foodSplitPercentByKcal,
    );
    return breakdown.fold<double>(
      0.0,
      (sum, split) => sum + split.portionGramsPerDay,
    );
  }

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
    double? targetKcalPerDay,
    Map<dynamic, double> foodSplitPercentByKcal = const {},
    String? operationalNotes,
  }) {
    final resolvedTargetKcalPerDay =
        targetKcalPerDay ??
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
    final foodBreakdown = buildFoodBreakdown(
      selectedFoods: selectedFoods,
      targetKcalPerDay: resolvedTargetKcalPerDay,
      mealsPerDay: mealsPerDay,
      normalizedMealShares: normalizedMealShares,
      foodSplitPercentByKcal: foodSplitPercentByKcal,
    );
    final portionGramsPerDay = foodBreakdown.fold<double>(
      0.0,
      (sum, split) => sum + split.portionGramsPerDay,
    );
    final portionGramsPerMeal =
        DietCalculatorService.calculatePortionPerMealGrams(
          portionPerDayGrams: portionGramsPerDay,
          mealsPerDay: mealsPerDay,
        );
    final mealPortionGrams = List<double>.generate(
      normalizedMealShares.length,
      (index) {
        return foodBreakdown.fold<double>(
          0.0,
          (sum, split) =>
              sum +
              (index < split.mealPortionGrams.length
                  ? split.mealPortionGrams[index]
                  : 0.0),
        );
      },
      growable: false,
    );

    return PlanPreviewData(
      title: 'Plan Preview',
      foodNames: selectedFoods.map((food) => food.name).toList(growable: false),
      foodBreakdown: foodBreakdown,
      targetKcalPerDay: resolvedTargetKcalPerDay,
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
      mealPortionGrams: mealPortionGrams,
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
    required double feedingUnits,
    required double targetKcalPerCat,
    required List<FoodItem> selectedFoods,
    required int mealsPerDay,
    required List<String> mealTimes,
    required List<String> mealLabels,
    required List<double> normalizedMealShares,
    required DateTime startDate,
    required String portionUnit,
    required double portionUnitGrams,
    Map<dynamic, double> foodSplitPercentByKcal = const {},
    String? operationalNotes,
  }) {
    final targetKcalPerDay = targetKcalPerCat * feedingUnits;
    final foodBreakdown = buildFoodBreakdown(
      selectedFoods: selectedFoods,
      targetKcalPerDay: targetKcalPerDay,
      mealsPerDay: mealsPerDay,
      normalizedMealShares: normalizedMealShares,
      foodSplitPercentByKcal: foodSplitPercentByKcal,
    );
    final portionGramsPerDay = foodBreakdown.fold<double>(
      0.0,
      (sum, split) => sum + split.portionGramsPerDay,
    );
    final portionGramsPerMeal =
        DietCalculatorService.calculatePortionPerMealGrams(
          portionPerDayGrams: portionGramsPerDay,
          mealsPerDay: mealsPerDay,
        );
    final mealPortionGrams = List<double>.generate(
      normalizedMealShares.length,
      (index) {
        return foodBreakdown.fold<double>(
          0.0,
          (sum, split) =>
              sum +
              (index < split.mealPortionGrams.length
                  ? split.mealPortionGrams[index]
                  : 0.0),
        );
      },
      growable: false,
    );

    return PlanPreviewData(
      title: 'Group Plan Preview',
      foodNames: selectedFoods.map((food) => food.name).toList(growable: false),
      foodBreakdown: foodBreakdown,
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
      mealPortionGrams: mealPortionGrams,
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

import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/plans/services/plan_preview_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'buildIndividual splits kcal across two foods and sums grams correctly',
    () {
      final cat = CatProfile(
        id: 'skye',
        name: 'Skye',
        weight: 4.5,
        age: 36,
        neutered: true,
        activityLevel: 'moderate',
        goal: 'maintenance',
        createdAt: DateTime(2026, 3, 16),
        manualTargetKcal: 240,
      );
      final foods = [
        FoodItem(
          barcode: 'dry',
          name: 'Dry Food',
          brand: 'Brand A',
          kcalPer100g: 400,
          packageSize: '400 g',
          servingUnit: 'g',
        ),
        FoodItem(
          barcode: 'wet',
          name: 'Wet Food',
          brand: 'Brand B',
          kcalPer100g: 120,
          packageSize: '85 g',
          servingUnit: 'can',
        ),
      ];

      final preview = PlanPreviewBuilder.buildIndividual(
        cat: cat,
        selectedFoods: foods,
        mealsPerDay: 3,
        mealTimes: const ['07:30 AM', '01:00 PM', '07:00 PM'],
        mealLabels: const ['Breakfast', 'Lunch', 'Dinner'],
        normalizedMealShares: const [40, 30, 30],
        startDate: DateTime(2026, 3, 16),
        portionUnit: 'g',
        portionUnitGrams: 1,
        dailyOverrides: const {},
        foodSplitPercentByKcal: const {'dry': 70, 'wet': 30},
      );

      expect(preview.targetKcalPerDay, 240);
      expect(preview.foodBreakdown, hasLength(2));

      final dry = preview.foodBreakdown.firstWhere(
        (split) => split.foodKey == 'dry',
      );
      final wet = preview.foodBreakdown.firstWhere(
        (split) => split.foodKey == 'wet',
      );

      expect(dry.targetKcalPerDay, closeTo(168, 0.01));
      expect(dry.portionGramsPerDay, closeTo(42, 0.01));
      expect(wet.targetKcalPerDay, closeTo(72, 0.01));
      expect(wet.portionGramsPerDay, closeTo(60, 0.01));
      expect(wet.servingUnitsPerDay, closeTo(60 / 85, 0.01));
      expect(wet.servingUnit, 'can');

      expect(preview.portionGramsPerDay, closeTo(102, 0.01));
      expect(preview.portionGramsPerMeal, closeTo(34, 0.01));
      expect(preview.mealPortionGrams[0], closeTo(40.8, 0.01));
      expect(preview.mealPortionGrams[1], closeTo(30.6, 0.01));
      expect(preview.mealPortionGrams[2], closeTo(30.6, 0.01));
    },
  );
}

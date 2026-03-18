import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/widgets/plan_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('plan preview card shows mixed food split and serving units', (
    tester,
  ) async {
    final preview = PlanPreviewData(
      title: 'Mixed plan',
      foodNames: const ['Dry Food', 'Wet Food'],
      foodBreakdown: const [
        FoodPortionSplitData(
          foodKey: 'dry',
          foodName: 'Dry Food',
          sharePercent: 70,
          targetKcalPerDay: 168,
          portionGramsPerDay: 42,
          portionGramsPerMeal: 14,
          mealPortionGrams: [14, 14, 14],
          servingUnit: 'g',
          gramsPerServingUnit: 1,
          servingUnitsPerDay: 42,
          servingUnitsPerMeal: 14,
        ),
        FoodPortionSplitData(
          foodKey: 'wet',
          foodName: 'Wet Food',
          sharePercent: 30,
          targetKcalPerDay: 72,
          portionGramsPerDay: 60,
          portionGramsPerMeal: 20,
          mealPortionGrams: [20, 20, 20],
          servingUnit: 'can',
          gramsPerServingUnit: 85,
          servingUnitsPerDay: 0.7,
          servingUnitsPerMeal: 0.2,
        ),
      ],
      targetKcalPerDay: 240,
      portionGramsPerDay: 102,
      portionGramsPerMeal: 34,
      mealsPerDay: 3,
      mealTimes: const ['07:30 AM', '01:00 PM', '07:00 PM'],
      mealLabels: const ['Breakfast', 'Lunch', 'Dinner'],
      mealPortionGrams: const [40.8, 30.6, 30.6],
      startDate: DateTime(2026, 3, 16),
      portionUnit: 'g',
      portionUnitGrams: 1,
      dailyOverrides: const {},
      goalLabel: 'maintenance',
    );

    await tester.pumpWidget(
      buildTestApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PlanPreviewCard(preview: preview, primary: Colors.teal),
          ),
        ),
      ),
    );

    expect(find.text('Mixed food split'), findsOneWidget);
    expect(find.text('70% kcal share'), findsOneWidget);
    expect(find.text('30% kcal share'), findsOneWidget);
    expect(find.text('0.7 can/day'), findsOneWidget);
    expect(find.text('60.0 g'), findsOneWidget);
  });
}

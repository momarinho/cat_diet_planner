import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/widgets/plan_quick_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('quick summary card shows daily targets and meal split', (
    tester,
  ) async {
    final cat = CatProfile(
      id: 'skye',
      name: 'Skye',
      weight: 4.5,
      age: 36,
      neutered: true,
      activityLevel: 'moderate',
      goal: 'maintenance',
      createdAt: DateTime(2026, 3, 16),
    );

    final preview = PlanPreviewData(
      title: 'Skye preview',
      foodNames: ['Dry Food Brand', 'Wet Food Brand'],
      foodBreakdown: const [
        FoodPortionSplitData(
          foodKey: 'dry',
          foodName: 'Dry Food Brand',
          sharePercent: 70,
          targetKcalPerDay: 172.9,
          portionGramsPerDay: 43.2,
          portionGramsPerMeal: 14.4,
          mealPortionGrams: [14.4, 14.4, 14.4],
          servingUnit: 'g',
          gramsPerServingUnit: 1,
          servingUnitsPerDay: 43.2,
          servingUnitsPerMeal: 14.4,
        ),
        FoodPortionSplitData(
          foodKey: 'wet',
          foodName: 'Wet Food Brand',
          sharePercent: 30,
          targetKcalPerDay: 74.1,
          portionGramsPerDay: 61.8,
          portionGramsPerMeal: 20.6,
          mealPortionGrams: [20.6, 20.6, 20.6],
          servingUnit: 'can',
          gramsPerServingUnit: 85,
          servingUnitsPerDay: 0.73,
          servingUnitsPerMeal: 0.24,
        ),
      ],
      targetKcalPerDay: 247,
      portionGramsPerDay: 105,
      portionGramsPerMeal: 35,
      mealsPerDay: 3,
      mealTimes: ['07:30', '13:00', '19:00'],
      mealLabels: ['Breakfast', 'Lunch', 'Dinner'],
      mealPortionGrams: [35, 35, 35],
      startDate: DateTime(2026, 3, 16),
      portionUnit: 'g',
      portionUnitGrams: 1,
      dailyOverrides: {},
      goalLabel: 'Maintenance',
    );

    await tester.pumpWidget(
      buildTestApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PlanQuickSummaryCard(
              cat: cat,
              preview: preview,
              primary: Colors.teal,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Skye'), findsOneWidget);
    expect(find.text('Dry Food Brand + Wet Food Brand'), findsOneWidget);
    expect(find.text('Food split'), findsOneWidget);
    expect(find.text('70% kcal share'), findsOneWidget);
    expect(find.text('30% kcal share'), findsOneWidget);
    expect(find.text('0.7 can/day'), findsOneWidget);
    expect(find.text('43.2 g'), findsOneWidget);
    expect(find.text('61.8 g'), findsOneWidget);
    expect(find.text('247 kcal'), findsOneWidget);
    expect(find.text('105.0 g'), findsOneWidget);
    expect(find.text('35.0 g'), findsNWidgets(4));
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Dinner'), findsOneWidget);
  });
}

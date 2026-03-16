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
      foodNames: ['Dry Food Brand'],
      targetKcalPerDay: 247,
      portionGramsPerDay: 70,
      portionGramsPerMeal: 23.3,
      mealsPerDay: 3,
      mealTimes: ['07:30', '13:00', '19:00'],
      mealLabels: ['Breakfast', 'Lunch', 'Dinner'],
      mealPortionGrams: [23.3, 23.3, 23.4],
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
    expect(find.text('Dry Food Brand'), findsOneWidget);
    expect(find.text('247 kcal'), findsOneWidget);
    expect(find.text('70.0 g'), findsOneWidget);
    expect(find.text('23.3 g'), findsNWidgets(3));
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Dinner'), findsOneWidget);
  });
}

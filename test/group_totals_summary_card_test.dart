import 'package:cat_diet_planner/features/plans/models/group_totals_summary_data.dart';
import 'package:cat_diet_planner/features/plans/widgets/group_totals_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets(
    'group totals summary card shows header totals and per-cat rows',
    (tester) async {
      final summary = GroupTotalsSummaryData(
        groupName: 'Foster Room',
        foodNames: const ['Dry Food'],
        totalKcalPerDay: 600,
        totalGramsPerDay: 150,
        totalGramsPerMeal: 37.5,
        kcalPerCatBaseline: 200,
        gramsPerCatBaseline: 50,
        mealsPerDay: 4,
        catCount: 2,
        hasWeightedDistribution: true,
        rows: const [
          GroupCatSummaryRowData(
            name: 'Luna',
            goalKey: 'maintenance',
            goalLabel: 'Maintenance',
            weightKg: 3.8,
            kcalPerDay: 200,
            gramsPerDay: 50,
            gramsPerMeal: 12.5,
          ),
          GroupCatSummaryRowData(
            name: 'Skye',
            goalKey: 'gain',
            goalLabel: 'Weight gain',
            weightKg: 5.0,
            kcalPerDay: 400,
            gramsPerDay: 100,
            gramsPerMeal: 25,
          ),
        ],
      );

      await tester.pumpWidget(
        buildTestApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GroupTotalsSummaryCard(
                summary: summary,
                primary: Colors.teal,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Foster Room'), findsOneWidget);
      expect(find.text('Dry Food'), findsOneWidget);
      expect(find.text('600 kcal'), findsOneWidget);
      expect(find.text('150.0 g'), findsOneWidget);
      expect(find.text('37.5 g'), findsOneWidget);
      expect(find.text('Luna'), findsOneWidget);
      expect(find.text('Skye'), findsOneWidget);
      expect(find.text('50.0 g'), findsOneWidget);
      expect(find.text('100.0 g'), findsOneWidget);
    },
  );

  testWidgets('group totals summary card filters cats by goal', (tester) async {
    final summary = GroupTotalsSummaryData(
      groupName: 'Foster Room',
      foodNames: const ['Dry Food'],
      totalKcalPerDay: 600,
      totalGramsPerDay: 150,
      totalGramsPerMeal: 37.5,
      kcalPerCatBaseline: 200,
      gramsPerCatBaseline: 50,
      mealsPerDay: 4,
      catCount: 2,
      hasWeightedDistribution: false,
      rows: const [
        GroupCatSummaryRowData(
          name: 'Luna',
          goalKey: 'maintenance',
          goalLabel: 'Maintenance',
          kcalPerDay: 200,
          gramsPerDay: 50,
          gramsPerMeal: 12.5,
        ),
        GroupCatSummaryRowData(
          name: 'Skye',
          goalKey: 'gain',
          goalLabel: 'Weight gain',
          kcalPerDay: 400,
          gramsPerDay: 100,
          gramsPerMeal: 25,
        ),
      ],
    );

    String selected = 'all';

    await tester.pumpWidget(
      buildTestApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: GroupTotalsSummaryCard(
                  summary: summary,
                  primary: Colors.teal,
                  selectedGoalFilter: selected,
                  onGoalFilterChanged: (value) {
                    setState(() => selected = value);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('Skye'), findsOneWidget);

    await tester.tap(find.text('Gain'));
    await tester.pump();

    expect(find.text('Luna'), findsNothing);
    expect(find.text('Skye'), findsOneWidget);
  });
}

import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/plans/services/group_totals_summary_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builder distributes group totals using feeding shares', () {
    final group = CatGroup(
      id: 'group-1',
      name: 'Foster Room',
      catCount: 2,
      colorValue: 0xFF123456,
      createdAt: DateTime(2026, 3, 16),
      catIds: const ['a', 'b'],
      feedingShareByCat: const {'a': 1.0, 'b': 2.0},
    );
    final cats = [
      CatProfile(
        id: 'a',
        name: 'Luna',
        weight: 3.8,
        age: 24,
        goal: 'maintenance',
        createdAt: DateTime(2026, 3, 16),
      ),
      CatProfile(
        id: 'b',
        name: 'Skye',
        weight: 5.0,
        age: 36,
        goal: 'gain',
        createdAt: DateTime(2026, 3, 16),
      ),
    ];
    final foods = [
      FoodItem(name: 'Dry Food', brand: 'Brand A', kcalPer100g: 400),
    ];

    final summary = GroupTotalsSummaryBuilder.build(
      group: group,
      allCats: cats,
      selectedFoods: foods,
      targetKcalPerCat: 200,
      mealsPerDay: 4,
    );

    expect(summary.catCount, 2);
    expect(summary.hasWeightedDistribution, isTrue);
    expect(summary.totalKcalPerDay, 600);
    expect(summary.totalGramsPerDay, 150);
    expect(summary.totalGramsPerMeal, 37.5);
    expect(summary.rows, hasLength(2));

    final luna = summary.rows.firstWhere((row) => row.name == 'Luna');
    final skye = summary.rows.firstWhere((row) => row.name == 'Skye');

    expect(luna.kcalPerDay, closeTo(200, 0.01));
    expect(luna.gramsPerDay, closeTo(50, 0.01));
    expect(skye.kcalPerDay, closeTo(400, 0.01));
    expect(skye.gramsPerDay, closeTo(100, 0.01));
  });
}

import 'package:cat_diet_planner/features/cat_group/services/group_feeding_dashboard_filter.dart';
import 'package:cat_diet_planner/features/plans/models/group_totals_summary_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rows = [
    GroupCatSummaryRowData(
      catId: 'cat-1',
      name: 'Luna',
      goalKey: 'maintenance',
      goalLabel: 'Maintenance',
      weightKg: 4.0,
      kcalPerDay: 200,
      gramsPerDay: 120,
      gramsPerMeal: 30,
    ),
    GroupCatSummaryRowData(
      catId: 'cat-2',
      name: 'Skye',
      goalKey: 'gain',
      goalLabel: 'Weight gain',
      weightKg: 5.1,
      kcalPerDay: 240,
      gramsPerDay: 140,
      gramsPerMeal: 35,
    ),
    GroupCatSummaryRowData(
      catId: 'cat-3',
      name: 'Mochi',
      goalKey: 'loss',
      goalLabel: 'Weight loss',
      weightKg: 4.8,
      kcalPerDay: 180,
      gramsPerDay: 95,
      gramsPerMeal: 23.75,
    ),
  ];

  test('filters rows by goal only', () {
    final result = GroupFeedingDashboardFilter.apply(
      rows: rows,
      query: '',
      goalFilter: 'gain',
    );

    expect(result.map((row) => row.name), ['Skye']);
  });

  test('filters rows by search only', () {
    final result = GroupFeedingDashboardFilter.apply(
      rows: rows,
      query: 'mo',
      goalFilter: 'all',
    );

    expect(result.map((row) => row.name), ['Mochi']);
  });

  test('combines search and goal filters', () {
    final result = GroupFeedingDashboardFilter.apply(
      rows: rows,
      query: 's',
      goalFilter: 'gain',
    );

    expect(result.map((row) => row.name), ['Skye']);
  });
}

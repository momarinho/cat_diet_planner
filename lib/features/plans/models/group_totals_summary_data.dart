import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';

class GroupTotalsSummaryData {
  const GroupTotalsSummaryData({
    required this.groupName,
    required this.foodNames,
    this.foodBreakdown = const [],
    required this.totalKcalPerDay,
    required this.totalGramsPerDay,
    required this.totalGramsPerMeal,
    required this.kcalPerCatBaseline,
    required this.gramsPerCatBaseline,
    required this.mealsPerDay,
    required this.catCount,
    required this.hasWeightedDistribution,
    required this.rows,
  });

  final String groupName;
  final List<String> foodNames;
  final List<FoodPortionSplitData> foodBreakdown;
  final double totalKcalPerDay;
  final double totalGramsPerDay;
  final double totalGramsPerMeal;
  final double kcalPerCatBaseline;
  final double gramsPerCatBaseline;
  final int mealsPerDay;
  final int catCount;
  final bool hasWeightedDistribution;
  final List<GroupCatSummaryRowData> rows;
}

class GroupCatSummaryRowData {
  const GroupCatSummaryRowData({
    required this.name,
    required this.goalKey,
    required this.kcalPerDay,
    required this.gramsPerDay,
    required this.gramsPerMeal,
    this.weightKg,
    this.goalLabel,
  });

  final String name;
  final String goalKey;
  final double kcalPerDay;
  final double gramsPerDay;
  final double gramsPerMeal;
  final double? weightKg;
  final String? goalLabel;
}

import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';

class GroupFeedingShoppingProjection {
  const GroupFeedingShoppingProjection._();

  static GroupShoppingProjectionData build({
    required List<FoodPortionSplitData> foodBreakdown,
    int days = 7,
  }) {
    final entries = foodBreakdown
        .map(
          (split) => GroupShoppingProjectionEntry(
            foodName: split.foodName,
            dailyGrams: split.portionGramsPerDay,
            projectedGrams: split.portionGramsPerDay * days,
            servingUnit: split.servingUnit,
            dailyServingUnits: split.servingUnitsPerDay,
            projectedServingUnits: split.servingUnitsPerDay == null
                ? null
                : split.servingUnitsPerDay! * days,
          ),
        )
        .toList(growable: false);

    return GroupShoppingProjectionData(
      days: days,
      entries: entries,
      totalDailyGrams: entries.fold<double>(
        0.0,
        (sum, entry) => sum + entry.dailyGrams,
      ),
      totalProjectedGrams: entries.fold<double>(
        0.0,
        (sum, entry) => sum + entry.projectedGrams,
      ),
    );
  }
}

class GroupShoppingProjectionData {
  const GroupShoppingProjectionData({
    required this.days,
    required this.entries,
    required this.totalDailyGrams,
    required this.totalProjectedGrams,
  });

  final int days;
  final List<GroupShoppingProjectionEntry> entries;
  final double totalDailyGrams;
  final double totalProjectedGrams;
}

class GroupShoppingProjectionEntry {
  const GroupShoppingProjectionEntry({
    required this.foodName,
    required this.dailyGrams,
    required this.projectedGrams,
    this.servingUnit,
    this.dailyServingUnits,
    this.projectedServingUnits,
  });

  final String foodName;
  final double dailyGrams;
  final double projectedGrams;
  final String? servingUnit;
  final double? dailyServingUnits;
  final double? projectedServingUnits;
}

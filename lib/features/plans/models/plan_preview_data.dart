class PlanPreviewData {
  const PlanPreviewData({
    required this.title,
    required this.foodNames,
    required this.targetKcalPerDay,
    required this.portionGramsPerDay,
    required this.portionGramsPerMeal,
    required this.mealsPerDay,
    required this.mealTimes,
    required this.mealLabels,
    required this.mealPortionGrams,
    required this.startDate,
    required this.portionUnit,
    required this.portionUnitGrams,
    required this.dailyOverrides,
    this.foodBreakdown = const [],
    this.operationalNotes,
    this.goalLabel,
    this.catCount,
  });

  final String title;
  final List<String> foodNames;
  final List<FoodPortionSplitData> foodBreakdown;
  final double targetKcalPerDay;
  final double portionGramsPerDay;
  final double portionGramsPerMeal;
  final int mealsPerDay;
  final List<String> mealTimes;
  final List<String> mealLabels;
  final List<double> mealPortionGrams;
  final DateTime startDate;
  final String portionUnit;
  final double portionUnitGrams;
  final Map<int, Map<dynamic, dynamic>> dailyOverrides;
  final String? operationalNotes;
  final String? goalLabel;
  final int? catCount;
}

class FoodPortionSplitData {
  const FoodPortionSplitData({
    required this.foodKey,
    required this.foodName,
    required this.sharePercent,
    required this.targetKcalPerDay,
    required this.portionGramsPerDay,
    required this.portionGramsPerMeal,
    required this.mealPortionGrams,
    this.servingUnit,
    this.gramsPerServingUnit,
    this.servingUnitsPerDay,
    this.servingUnitsPerMeal,
  });

  final dynamic foodKey;
  final String foodName;
  final double sharePercent;
  final double targetKcalPerDay;
  final double portionGramsPerDay;
  final double portionGramsPerMeal;
  final List<double> mealPortionGrams;
  final String? servingUnit;
  final double? gramsPerServingUnit;
  final double? servingUnitsPerDay;
  final double? servingUnitsPerMeal;
}

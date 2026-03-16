import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/plans/models/group_totals_summary_data.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';

class GroupTotalsSummaryBuilder {
  const GroupTotalsSummaryBuilder._();

  static GroupTotalsSummaryData build({
    required CatGroup group,
    required List<CatProfile> allCats,
    required List<FoodItem> selectedFoods,
    required double targetKcalPerCat,
    required int mealsPerDay,
  }) {
    final representativeFood = selectedFoods.first;
    final linkedCats = allCats
        .where((cat) => group.catIds.contains(cat.id))
        .toList(growable: false);
    final hasWeightedDistribution =
        linkedCats.isNotEmpty && group.feedingShareByCat.isNotEmpty;
    final effectiveCatCount = linkedCats.isNotEmpty
        ? linkedCats.length
        : group.catCount;
    final totalWeightUnits = linkedCats.isNotEmpty
        ? linkedCats.fold<double>(
            0.0,
            (sum, cat) => sum + _weightForCat(group, cat.id),
          )
        : group.catCount.toDouble();
    final totalKcalPerDay = targetKcalPerCat * totalWeightUnits;
    final totalGramsPerDay = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: totalKcalPerDay,
      kcalPer100g: representativeFood.kcalPer100g,
    );
    final totalGramsPerMeal =
        DietCalculatorService.calculatePortionPerMealGrams(
          portionPerDayGrams: totalGramsPerDay,
          mealsPerDay: mealsPerDay,
        );
    final baselineGramsPerCat =
        DietCalculatorService.calculateDailyPortionGrams(
          targetKcal: targetKcalPerCat,
          kcalPer100g: representativeFood.kcalPer100g,
        );

    final rows = linkedCats
        .map((cat) {
          final share = totalWeightUnits <= 0
              ? 0.0
              : _weightForCat(group, cat.id) / totalWeightUnits;
          final kcalPerDay = totalKcalPerDay * share;
          final gramsPerDay = totalGramsPerDay * share;
          final gramsPerMeal =
              DietCalculatorService.calculatePortionPerMealGrams(
                portionPerDayGrams: gramsPerDay,
                mealsPerDay: mealsPerDay,
              );

          return GroupCatSummaryRowData(
            name: cat.name,
            weightKg: cat.weight,
            goalKey: cat.goal,
            goalLabel: catGoalLabel(cat.goal),
            kcalPerDay: kcalPerDay,
            gramsPerDay: gramsPerDay,
            gramsPerMeal: gramsPerMeal,
          );
        })
        .toList(growable: false);

    return GroupTotalsSummaryData(
      groupName: group.name,
      foodNames: selectedFoods.map((food) => food.name).toList(growable: false),
      totalKcalPerDay: totalKcalPerDay,
      totalGramsPerDay: totalGramsPerDay,
      totalGramsPerMeal: totalGramsPerMeal,
      kcalPerCatBaseline: targetKcalPerCat,
      gramsPerCatBaseline: baselineGramsPerCat,
      mealsPerDay: mealsPerDay,
      catCount: effectiveCatCount,
      hasWeightedDistribution: hasWeightedDistribution,
      rows: rows,
    );
  }

  static double _weightForCat(CatGroup group, String catId) {
    return group.feedingShareByCat[catId] ?? 1.0;
  }
}

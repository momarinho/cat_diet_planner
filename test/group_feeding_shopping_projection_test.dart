import 'package:cat_diet_planner/features/cat_group/services/group_feeding_shopping_projection.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds daily and weekly shopping projections from food breakdown', () {
    final projection = GroupFeedingShoppingProjection.build(
      foodBreakdown: const [
        FoodPortionSplitData(
          foodKey: 'dry',
          foodName: 'Dry Food',
          sharePercent: 60,
          targetKcalPerDay: 360,
          portionGramsPerDay: 90,
          portionGramsPerMeal: 30,
          mealPortionGrams: [30, 30, 30],
        ),
        FoodPortionSplitData(
          foodKey: 'wet',
          foodName: 'Wet Food',
          sharePercent: 40,
          targetKcalPerDay: 240,
          portionGramsPerDay: 210,
          portionGramsPerMeal: 70,
          mealPortionGrams: [70, 70, 70],
          servingUnit: 'sachet',
          gramsPerServingUnit: 100,
          servingUnitsPerDay: 2.1,
          servingUnitsPerMeal: 0.7,
        ),
      ],
      days: 7,
    );

    expect(projection.days, 7);
    expect(projection.totalDailyGrams, 300);
    expect(projection.totalProjectedGrams, 2100);
    expect(projection.entries[0].projectedGrams, 630);
    expect(projection.entries[1].projectedGrams, 1470);
    expect(projection.entries[1].projectedServingUnits, closeTo(14.7, 0.001));
  });
}

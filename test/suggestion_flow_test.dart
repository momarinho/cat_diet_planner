import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';
import 'package:cat_diet_planner/features/suggestions/services/plan_adjustment_service.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_engine.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_impact_history_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';

void main() {
  setUp(() async {
    await HiveTestHelper.init();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  test(
    'complete suggestion flow generates, accepts, applies and reverts',
    () async {
      final cat = await _seedCatWithPlan();
      await _seedWeightTrend(cat.id);

      final engine = const SuggestionEngine();
      final suggestions = engine.generateForCat(
        cat: cat,
        weightRecords: HiveService.weightsBox.values.toList(),
        recentMealSchedules: const [],
        activePlan: HiveService.dietPlansBox.get('plan-flow'),
        now: DateTime(2026, 3, 15, 10),
      );
      final suggestion = suggestions.firstWhere(
        (entry) => entry.type == SuggestionType.kcalAdjustment,
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(suggestionDecisionProvider.notifier).accept(suggestion.id);

      final applied = await container
          .read(planAdjustmentServiceProvider)
          .applySuggestion(
            cat: cat,
            suggestion: suggestion,
            acceptedBy: 'Mateus',
          );
      final appliedPlan = HiveService.dietPlansBox.get('plan-flow');
      final historyEntries = SuggestionImpactHistoryService().readAll();

      expect(applied.changed, isTrue);
      expect(
        container.read(suggestionDecisionProvider)[suggestion.id],
        SuggestionDecision.accepted,
      );
      expect(appliedPlan?.targetKcalPerDay, lessThan(220));
      expect(historyEntries, hasLength(1));
      expect(historyEntries.single.suggestion.id, suggestion.id);
      expect(
        historyEntries.single.afterPlan.targetKcalPerDay,
        appliedPlan?.targetKcalPerDay,
      );

      final reverted = await container
          .read(planAdjustmentServiceProvider)
          .revertLastSuggestedChange(revertedBy: 'Mateus');
      final restoredPlan = HiveService.dietPlansBox.get('plan-flow');
      final updatedHistoryEntries = SuggestionImpactHistoryService().readAll();

      expect(reverted.changed, isTrue);
      expect(restoredPlan?.targetKcalPerDay, 220);
      expect(updatedHistoryEntries.single.isReverted, isTrue);
    },
  );
}

Future<CatProfile> _seedCatWithPlan() async {
  final cat = CatProfile(
    id: 'cat-flow',
    name: 'Nina',
    weight: 4.4,
    age: 36,
    neutered: true,
    activityLevel: 'moderate',
    goal: 'maintenance',
    createdAt: DateTime(2026, 3, 1),
    weightGoalMaxKg: 4.3,
  );
  await HiveService.catsBox.put(cat.id, cat);

  final plan = DietPlan(
    catId: cat.id,
    foodKey: 'food-1',
    foodName: 'Dry Food',
    targetKcalPerDay: 220,
    portionGramsPerDay: 70,
    mealsPerDay: 4,
    portionGramsPerMeal: 17.5,
    createdAt: DateTime(2026, 3, 1),
    goal: cat.goal,
    mealTimes: const ['07:00 AM', '12:00 PM', '05:00 PM', '09:00 PM'],
    mealLabels: const ['Breakfast', 'Lunch', 'Dinner', 'Late meal'],
    mealPortionGrams: const [17.5, 17.5, 17.5, 17.5],
    startDate: DateTime(2026, 3, 1),
    planId: 'plan-flow',
  );
  await HiveService.dietPlansBox.put(plan.planId, plan);
  cat.activePlanId = plan.planId;
  await cat.save();
  return cat;
}

Future<void> _seedWeightTrend(String catId) async {
  final records = [
    WeightRecord(catId: catId, date: DateTime(2026, 3, 1), weight: 4.1),
    WeightRecord(catId: catId, date: DateTime(2026, 3, 8), weight: 4.25),
    WeightRecord(catId: catId, date: DateTime(2026, 3, 15), weight: 4.4),
  ];

  for (final record in records) {
    await HiveService.weightsBox.add(record);
  }
}

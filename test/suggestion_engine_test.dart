import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = SuggestionEngine();

  CatProfile buildCat({
    String goal = 'maintenance',
    double? minGoal,
    double? maxGoal,
    List<String> conditions = const [],
  }) {
    return CatProfile(
      id: 'cat-1',
      name: 'Nina',
      weight: 4.8,
      age: 36,
      neutered: true,
      activityLevel: 'moderate',
      goal: goal,
      createdAt: DateTime(2026, 1, 1),
      weightGoalMinKg: minGoal,
      weightGoalMaxKg: maxGoal,
      clinicalConditions: conditions,
    );
  }

  DietPlan buildPlan() {
    return DietPlan(
      catId: 'cat-1',
      foodKey: 'food-1',
      foodName: 'Test Food',
      targetKcalPerDay: 240,
      portionGramsPerDay: 70,
      mealsPerDay: 4,
      portionGramsPerMeal: 17.5,
      createdAt: DateTime(2026, 1, 1),
      goal: 'maintenance',
      mealTimes: const ['07:30 AM', '12:30 PM', '07:00 PM', '10:00 PM'],
      mealLabels: const ['Breakfast', 'Lunch', 'Dinner', 'Late Meal'],
      mealPortionGrams: const [17.5, 17.5, 17.5, 17.5],
      startDate: DateTime(2026, 1, 1),
    );
  }

  List<Map<String, dynamic>> buildSchedules({
    required int days,
    required int mealsPerDay,
    required int completedMealsPerDay,
    Set<int> forcedIncompleteMealIndexes = const {},
    Map<int, String> mealContextByIndex = const {},
    DateTime? now,
  }) {
    final ref = now ?? DateTime(2026, 3, 14, 12);
    final schedules = <Map<String, dynamic>>[];
    for (var d = 0; d < days; d++) {
      final date = DateTime(
        ref.year,
        ref.month,
        ref.day,
      ).subtract(Duration(days: d));
      final items = <Map<String, dynamic>>[];
      for (var i = 0; i < mealsPerDay; i++) {
        final completed =
            i < completedMealsPerDay &&
            !forcedIncompleteMealIndexes.contains(i);
        final context = mealContextByIndex[i];
        items.add({
          'id': 'meal_${i + 1}',
          'type': 'meal',
          'time': [
            '07:30 AM',
            '12:30 PM',
            '07:00 PM',
            '10:00 PM',
          ][i.clamp(0, 3)],
          'completed': completed,
          ...?context == null
              ? null
              : <String, dynamic>{'mealContext': context},
        });
      }
      schedules.add({'date': date.toIso8601String(), 'items': items});
    }
    return schedules;
  }

  List<WeightRecord> buildWeights({
    required List<double> values,
    DateTime? now,
    String appetite = 'normal',
    String vomit = 'none',
    String stool = 'normal',
    bool alert = false,
  }) {
    final ref = now ?? DateTime(2026, 3, 14, 12);
    return List.generate(values.length, (index) {
      final daysAgo = (values.length - 1 - index) * 3;
      return WeightRecord(
        catId: 'cat-1',
        date: ref.subtract(Duration(days: daysAgo)),
        weight: values[index],
        appetite: appetite,
        vomit: vomit,
        stool: stool,
        alertTriggered: alert,
      );
    });
  }

  test('builds kcal adjustment using weight trend and reason codes', () {
    final suggestions = engine.generateForCat(
      cat: buildCat(goal: 'loss', maxGoal: 4.6),
      activePlan: buildPlan(),
      weightRecords: buildWeights(values: [4.5, 4.7, 4.9]),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 4,
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    final kcal = suggestions.firstWhere(
      (s) => s.type == SuggestionType.kcalAdjustment,
    );
    expect(kcal.reasonCodes, contains(SuggestionReasonCodes.weightTrendUp));
    expect(kcal.reasonCodes, contains(SuggestionReasonCodes.outOfGoalMax));
    expect(kcal.confidenceScore, greaterThan(0.6));
    expect((kcal.metadata['changePercent'] as int), lessThan(0));
  });

  test('builds schedule adjustment when delayed adherence is frequent', () {
    final suggestions = engine.generateForCat(
      cat: buildCat(),
      activePlan: buildPlan(),
      weightRecords: buildWeights(values: [4.7, 4.7, 4.7]),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 4,
        forcedIncompleteMealIndexes: const {1},
        mealContextByIndex: const {1: 'delayed'},
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    final schedule = suggestions.firstWhere(
      (s) => s.type == SuggestionType.scheduleAdjustment,
    );
    expect(schedule.reasonCodes, contains(SuggestionReasonCodes.adherenceLow));
    expect(
      schedule.reasonCodes,
      contains(SuggestionReasonCodes.delayedFrequent),
    );
    expect(schedule.confidenceScore, greaterThan(0.55));
  });

  test('builds portion split suggestion from low-adherence meal slot', () {
    final suggestions = engine.generateForCat(
      cat: buildCat(),
      activePlan: buildPlan(),
      weightRecords: buildWeights(values: [4.7, 4.7, 4.7]),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 4,
        forcedIncompleteMealIndexes: const {1},
        mealContextByIndex: const {1: 'refused'},
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    final portion = suggestions.firstWhere(
      (s) => s.type == SuggestionType.portionSplitAdjustment,
    );
    expect(portion.reasonCodes, contains(SuggestionReasonCodes.adherenceLow));
    expect(
      portion.reasonCodes,
      contains(SuggestionReasonCodes.refusalFrequent),
    );
    expect((portion.metadata['shiftGrams'] as double), greaterThan(0.9));
    expect((portion.metadata['newMealPortionGrams'] as List).length, equals(4));
  });

  test('builds preventive alert when trend approaches weight boundary', () {
    final suggestions = engine.generateForCat(
      cat: buildCat(maxGoal: 5.0),
      activePlan: buildPlan(),
      weightRecords: buildWeights(values: [4.7, 4.8, 4.9]),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 4,
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    final alert = suggestions.firstWhere(
      (s) => s.type == SuggestionType.preventiveTrendAlert,
    );
    expect(
      alert.reasonCodes,
      contains(SuggestionReasonCodes.approachingGoalMax),
    );
    expect(alert.confidenceScore, greaterThan(0.5));
  });

  test('builds clinical watch suggestion from clinical context signals', () {
    final suggestions = engine.generateForCat(
      cat: buildCat(conditions: const ['ckd']),
      activePlan: buildPlan(),
      weightRecords: buildWeights(
        values: [4.7, 4.6, 4.5],
        appetite: 'reduced',
        vomit: 'frequent',
        stool: 'diarrhea',
        alert: true,
      ),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 3,
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    final clinical = suggestions.firstWhere(
      (s) => s.type == SuggestionType.clinicalWatch,
    );
    expect(
      clinical.reasonCodes,
      contains(SuggestionReasonCodes.clinicalConditionPresent),
    );
    expect(
      clinical.reasonCodes,
      contains(SuggestionReasonCodes.appetiteReduced),
    );
    expect(clinical.reasonCodes, contains(SuggestionReasonCodes.vomitFrequent));
    expect(clinical.reasonCodes, contains(SuggestionReasonCodes.stoolDiarrhea));
    expect(
      clinical.reasonCodes,
      contains(SuggestionReasonCodes.weightAlertTriggered),
    );
    expect(clinical.confidenceScore, inInclusiveRange(0.1, 0.95));
  });

  test('alerts only mode filters out plan-adjustment suggestions', () {
    const alertsOnlyEngine = SuggestionEngine(alertsOnly: true);

    final suggestions = alertsOnlyEngine.generateForCat(
      cat: buildCat(goal: 'loss', maxGoal: 4.6, conditions: const ['ckd']),
      activePlan: buildPlan(),
      weightRecords: buildWeights(
        values: [4.5, 4.7, 4.9],
        appetite: 'reduced',
        alert: true,
      ),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 3,
        forcedIncompleteMealIndexes: const {1},
        mealContextByIndex: const {1: 'delayed'},
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    expect(
      suggestions.every(
        (suggestion) =>
            suggestion.type == SuggestionType.preventiveTrendAlert ||
            suggestion.type == SuggestionType.clinicalWatch,
      ),
      isTrue,
    );
  });

  test('category toggles can disable schedule suggestions', () {
    const filteredEngine = SuggestionEngine(
      categoryToggles: {
        'kcalAdjustment': true,
        'scheduleAdjustment': false,
        'portionSplitAdjustment': true,
        'preventiveTrendAlert': true,
        'clinicalWatch': true,
      },
    );

    final suggestions = filteredEngine.generateForCat(
      cat: buildCat(),
      activePlan: buildPlan(),
      weightRecords: buildWeights(values: [4.7, 4.7, 4.7]),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 4,
        forcedIncompleteMealIndexes: const {1},
        mealContextByIndex: const {1: 'delayed'},
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    expect(
      suggestions.where((s) => s.type == SuggestionType.scheduleAdjustment),
      isEmpty,
    );
  });

  test('daily limit caps the number of returned suggestions', () {
    const limitedEngine = SuggestionEngine(dailySuggestionLimit: 2);

    final suggestions = limitedEngine.generateForCat(
      cat: buildCat(goal: 'loss', maxGoal: 4.6, conditions: const ['ckd']),
      activePlan: buildPlan(),
      weightRecords: buildWeights(
        values: [4.5, 4.7, 4.9],
        appetite: 'reduced',
        vomit: 'frequent',
        stool: 'diarrhea',
        alert: true,
      ),
      recentMealSchedules: buildSchedules(
        days: 7,
        mealsPerDay: 4,
        completedMealsPerDay: 3,
        forcedIncompleteMealIndexes: const {1},
        mealContextByIndex: const {1: 'refused'},
      ),
      now: DateTime(2026, 3, 14, 12),
    );

    expect(suggestions, hasLength(2));
  });
}

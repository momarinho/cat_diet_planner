import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/repositories/daily_schedule_repository.dart';
import 'package:cat_diet_planner/data/repositories/weight_repository.dart';
import 'package:cat_diet_planner/features/plans/repositories/plan_repository.dart';
import 'package:cat_diet_planner/features/settings/services/demo_data_service.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';

void main() {
  setUp(() async {
    await HiveTestHelper.init();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  test('suggestion generation handles operational stress scenario', () async {
    await DemoDataService.seedOperationalStressScenario();

    final engine = const SuggestionEngine(dailySuggestionLimit: 3);
    final planRepository = PlanRepository();
    final weightRepository = WeightRepository();
    final scheduleRepository = DailyScheduleRepository();
    var totalSuggestions = 0;

    for (final cat in HiveService.catsBox.values) {
      final mealKeys = List<String>.generate(
        7,
        (index) => scheduleRepository.catDayKey(
          cat.id,
          DateTime.now().subtract(Duration(days: index)),
        ),
        growable: false,
      );
      final schedules = mealKeys
          .map(scheduleRepository.readSchedule)
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);
      final suggestions = engine.generateForCat(
        cat: cat,
        weightRecords: weightRepository.recordsForCat(
          cat.id,
          fallbackHistory: cat.weightHistory,
          newestFirst: false,
        ),
        recentMealSchedules: schedules,
        activePlan: planRepository.getPlanForCat(cat.id),
      );

      expect(suggestions.length, inInclusiveRange(0, 3));
      totalSuggestions += suggestions.length;
    }

    expect(HiveService.catsBox.length, AppLimits.maxCats);
    expect(HiveService.catGroupsBox.length, AppLimits.maxGroups);
    expect(HiveService.groupDietPlansBox.length, AppLimits.maxGroups);
    expect(totalSuggestions, greaterThan(0));
  });
}

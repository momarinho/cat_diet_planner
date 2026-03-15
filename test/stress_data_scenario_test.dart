import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/settings/services/demo_data_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';

void main() {
  setUp(() async {
    await HiveTestHelper.init();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  test('stress scenario seeds operational limits and schedule data', () async {
    final summary = await DemoDataService.seedOperationalStressScenario();

    expect(summary.cats, AppLimits.maxCats);
    expect(summary.groups, AppLimits.maxGroups);
    expect(summary.foods, greaterThanOrEqualTo(3));
    expect(summary.mealSchedules, greaterThan(0));

    expect(HiveService.catsBox.length, AppLimits.maxCats);
    expect(HiveService.catGroupsBox.length, AppLimits.maxGroups);
    expect(HiveService.mealsBox.isNotEmpty, isTrue);
  });
}

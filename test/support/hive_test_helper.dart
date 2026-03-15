import 'dart:io';

import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

class HiveTestHelper {
  static Directory? _tempDir;

  static Future<void> init() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Hive.close();

    _tempDir = await Directory.systemTemp.createTemp('cat_diet_test_');
    Hive.init(_tempDir!.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CatProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FoodItemAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WeightRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DietPlanAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CatGroupAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(GroupDietPlanAdapter());
    }

    HiveService.appSettingsBox = await Hive.openBox<dynamic>('app_settings');
    HiveService.catGroupsBox = await Hive.openBox<CatGroup>('cat_groups');
    HiveService.catsBox = await Hive.openBox<CatProfile>('cats');
    HiveService.dietPlansBox = await Hive.openBox<DietPlan>('diet_plans');
    HiveService.foodsBox = await Hive.openBox<FoodItem>('foods');
    HiveService.groupDietPlansBox = await Hive.openBox<GroupDietPlan>(
      'group_diet_plans',
    );
    HiveService.weightsBox = await Hive.openBox<WeightRecord>('weights');
    HiveService.mealsBox = await Hive.openBox<Map<dynamic, dynamic>>('meals');
  }

  static Future<void> dispose() async {
    final boxes = <Box<dynamic>>[
      HiveService.appSettingsBox,
      HiveService.catGroupsBox,
      HiveService.catsBox,
      HiveService.dietPlansBox,
      HiveService.foodsBox,
      HiveService.groupDietPlansBox,
      HiveService.weightsBox,
      HiveService.mealsBox,
    ];

    for (final box in boxes) {
      if (box.isOpen) {
        await box.close();
      }
    }

    await Hive.close();
    if (_tempDir?.existsSync() ?? false) {
      _tempDir!.deleteSync(recursive: true);
    }
    _tempDir = null;
  }
}

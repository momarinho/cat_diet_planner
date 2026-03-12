import 'dart:convert';
import 'dart:typed_data';

import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/settings/services/app_settings_service.dart';
import 'package:share_plus/share_plus.dart';

class DataExportService {
  static Future<void> exportJsonBackup() async {
    final payload = <String, dynamic>{
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': AppSettingsService().read().toMap(),
      'cats': HiveService.catsBox.values.map(_catToMap).toList(),
      'foods': HiveService.foodsBox.values.map(_foodToMap).toList(),
      'weights': HiveService.weightsBox.values.map(_weightToMap).toList(),
      'dietPlans': HiveService.dietPlansBox.values.map(_planToMap).toList(),
      'meals': HiveService.mealsBox.toMap().map(
        (key, value) => MapEntry(key.toString(), _normalize(value)),
      ),
    };

    final bytes = Uint8List.fromList(
      const Utf8Encoder().convert(
        const JsonEncoder.withIndent('  ').convert(payload),
      ),
    );

    final file = XFile.fromData(
      bytes,
      mimeType: 'application/json',
      name: 'catdiet_backup.json',
    );

    await Share.shareXFiles([file], text: 'CatDiet Planner backup export');
  }

  static Map<String, dynamic> _catToMap(CatProfile cat) {
    return {
      'id': cat.id,
      'name': cat.name,
      'weight': cat.weight,
      'age': cat.age,
      'neutered': cat.neutered,
      'activityLevel': cat.activityLevel,
      'goal': cat.goal,
      'createdAt': cat.createdAt.toIso8601String(),
      'photoPath': cat.photoPath,
      'weightHistory': cat.weightHistory.map(_weightToMap).toList(),
    };
  }

  static Map<String, dynamic> _foodToMap(FoodItem food) {
    return {
      'barcode': food.barcode,
      'name': food.name,
      'brand': food.brand,
      'kcalPer100g': food.kcalPer100g,
      'protein': food.protein,
      'fat': food.fat,
    };
  }

  static Map<String, dynamic> _weightToMap(WeightRecord record) {
    return {
      'date': record.date.toIso8601String(),
      'weight': record.weight,
      'notes': record.notes,
    };
  }

  static Map<String, dynamic> _planToMap(DietPlan plan) {
    return {
      'catId': plan.catId,
      'foodKey': plan.foodKey,
      'foodName': plan.foodName,
      'targetKcalPerDay': plan.targetKcalPerDay,
      'portionGramsPerDay': plan.portionGramsPerDay,
      'mealsPerDay': plan.mealsPerDay,
      'portionGramsPerMeal': plan.portionGramsPerMeal,
      'createdAt': plan.createdAt.toIso8601String(),
      'goal': plan.goal,
    };
  }

  static dynamic _normalize(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, nested) => MapEntry(key.toString(), _normalize(nested)),
      );
    }
    if (value is List) {
      return value.map(_normalize).toList();
    }
    return value;
  }
}

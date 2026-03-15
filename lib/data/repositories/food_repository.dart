import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FoodRepository {
  ValueListenable<Box<FoodItem>> foodsListenable() {
    return HiveService.foodsBox.listenable();
  }

  List<FoodItem> getAllFoods() {
    return HiveService.foodsBox.values.toList();
  }

  List<FoodItem> getFoodsFromBox(Box<FoodItem> box) {
    return box.values.toList();
  }

  Future<void> addFood(FoodItem food) async {
    await HiveService.foodsBox.add(food);
  }

  FoodItem? findByBarcode(String barcode) {
    final normalized = barcode.trim();
    if (normalized.isEmpty) return null;

    for (final food in HiveService.foodsBox.values) {
      if (food.barcode == normalized) return food;
    }
    return null;
  }

  FoodItem? findByKey(dynamic key) {
    if (key == null) return null;
    for (final food in HiveService.foodsBox.values) {
      if (food.key == key) return food;
    }
    return null;
  }

  bool matchesQuery(FoodItem food, String query) {
    if (query.isEmpty) return true;

    final q = query.toLowerCase().trim();
    return food.name.toLowerCase().contains(q) ||
        (food.brand?.toLowerCase().contains(q) ?? false) ||
        (food.barcode?.toLowerCase().contains(q) ?? false) ||
        (food.category?.toLowerCase().contains(q) ?? false) ||
        (food.manufacturer?.toLowerCase().contains(q) ?? false) ||
        (food.productLine?.toLowerCase().contains(q) ?? false) ||
        (food.flavor?.toLowerCase().contains(q) ?? false) ||
        (food.texture?.toLowerCase().contains(q) ?? false) ||
        (food.packageSize?.toLowerCase().contains(q) ?? false) ||
        (food.servingUnit?.toLowerCase().contains(q) ?? false) ||
        food.userTags.any((tag) => tag.toLowerCase().contains(q));
  }

  List<FoodItem> buildRecentFoods(Box<FoodItem> box, {int limit = 4}) {
    final recentKeys = box.keys.toList().reversed.take(limit).toList();
    return recentKeys.map((key) => box.get(key)).whereType<FoodItem>().toList();
  }

  List<FoodItem> buildPopularFoods(List<FoodItem> foods, {int limit = 4}) {
    final usage = <dynamic, int>{};

    for (final DietPlan plan in HiveService.dietPlansBox.values) {
      usage.update(plan.foodKey, (count) => count + 1, ifAbsent: () => 1);
    }

    for (final GroupDietPlan plan in HiveService.groupDietPlansBox.values) {
      usage.update(plan.foodKey, (count) => count + 1, ifAbsent: () => 1);
    }

    final ranked = [...foods]
      ..sort((a, b) {
        final bCount = usage[b.key] ?? 0;
        final aCount = usage[a.key] ?? 0;
        if (bCount != aCount) return bCount.compareTo(aCount);
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    return ranked
        .where((food) => (usage[food.key] ?? 0) > 0)
        .take(limit)
        .toList();
  }
}

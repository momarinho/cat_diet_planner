import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/data/repositories/food_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlanRepository {
  final FoodRepository _foodRepository = FoodRepository();

  /// Returns an active plan for the given catId.
  /// Priority:
  /// 1) cat.activePlanId when present and found
  /// 2) most recently started plan (largest startDate)
  /// If no plan exists, returns null.
  DietPlan? getPlanForCat(String catId) {
    final plans = getPlansForCat(catId);
    if (plans.isEmpty) return null;
    final cat = HiveService.catsBox.get(catId);
    final activePlanId = cat?.activePlanId;
    if (activePlanId != null) {
      for (final plan in plans) {
        if (plan.planId == activePlanId) return plan;
      }
    }
    plans.sort((a, b) => b.startDate.compareTo(a.startDate));
    return plans.first;
  }

  /// Returns all saved plans that reference the given catId.
  List<DietPlan> getPlansForCat(String catId) {
    return HiveService.dietPlansBox.values
        .where((p) => p.catId == catId)
        .cast<DietPlan>()
        .toList();
  }

  GroupDietPlan? getPlanForGroup(String groupId) {
    return HiveService.groupDietPlansBox.get(groupId);
  }

  List<FoodItem> getAllFoods() {
    return _foodRepository.getAllFoods();
  }

  FoodItem? findFoodByKey(dynamic key) {
    return _foodRepository.findByKey(key);
  }

  String? getActivePlanIdForCat(String catId) {
    return HiveService.catsBox.get(catId)?.activePlanId;
  }

  Future<void> setActivePlanForCat({
    required String catId,
    required String? planId,
  }) async {
    final cat = HiveService.catsBox.get(catId);
    if (cat == null) return;
    cat.activePlanId = planId;
    await cat.save();
  }

  ValueListenable<Box<DietPlan>> individualPlanListenable() {
    return HiveService.dietPlansBox.listenable();
  }

  ValueListenable<Box> catsListenable() {
    return HiveService.catsBox.listenable();
  }

  ValueListenable<Box<GroupDietPlan>> groupPlanListenable(String groupId) {
    return HiveService.groupDietPlansBox.listenable(keys: [groupId]);
  }

  ValueListenable<Box<GroupDietPlan>> allGroupPlansListenable() {
    return HiveService.groupDietPlansBox.listenable();
  }

  ValueListenable<Box<FoodItem>> foodsListenable() {
    return _foodRepository.foodsListenable();
  }

  /// Save a plan for a cat. Supports storing multiple plans per cat by using
  /// a generated storage key when `plan.planId` is not set. The saved DietPlan
  /// stored in Hive will include the generated `planId`.
  Future<String> savePlanForCat(DietPlan plan) async {
    final storageKey =
        plan.planId ?? '${plan.catId}:${DateTime.now().microsecondsSinceEpoch}';

    // If plan.planId is missing, create a copy with the generated id so the persisted
    // object contains a planId. Otherwise persist the plan as-is keyed by plan.planId.
    final DietPlan toSave = plan.planId == null
        ? DietPlan(
            catId: plan.catId,
            foodKey: plan.foodKey,
            foodName: plan.foodName,
            targetKcalPerDay: plan.targetKcalPerDay,
            portionGramsPerDay: plan.portionGramsPerDay,
            mealsPerDay: plan.mealsPerDay,
            portionGramsPerMeal: plan.portionGramsPerMeal,
            createdAt: plan.createdAt,
            goal: plan.goal,
            mealTimes: plan.mealTimes,
            mealLabels: plan.mealLabels,
            mealPortionGrams: plan.mealPortionGrams,
            startDate: plan.startDate,
            planId: storageKey,
            foodKeys: plan.foodKeys,
            foodNames: plan.foodNames,
            portionUnit: plan.portionUnit,
            portionUnitGrams: plan.portionUnitGrams,
            dailyOverrides: plan.dailyOverrides,
            operationalNotes: plan.operationalNotes,
            foodSplitPercentByKcal: plan.foodSplitPercentByKcal,
          )
        : plan;

    await HiveService.dietPlansBox.put(storageKey, toSave);
    await setActivePlanForCat(catId: plan.catId, planId: storageKey);
    return storageKey;
  }

  /// Save or replace a group plan (unchanged behavior).
  Future<void> savePlanForGroup(GroupDietPlan plan) async {
    await HiveService.groupDietPlansBox.put(plan.groupId, plan);
  }

  /// Delete a specific plan by its planId. This will try direct key deletion first,
  /// otherwise it searches box values for the matching planId and deletes that entry.
  Future<void> deletePlanById(String planId) async {
    // If the plan was stored using planId as the box key, delete directly.
    if (HiveService.dietPlansBox.containsKey(planId)) {
      final plan = HiveService.dietPlansBox.get(planId);
      if (plan is DietPlan && getActivePlanIdForCat(plan.catId) == planId) {
        await setActivePlanForCat(catId: plan.catId, planId: null);
      }
      await HiveService.dietPlansBox.delete(planId);
      return;
    }
    // Otherwise search for a value with matching planId.
    dynamic foundKey;
    DietPlan? foundPlan;
    for (final key in HiveService.dietPlansBox.keys) {
      final val = HiveService.dietPlansBox.get(key);
      if (val is DietPlan && val.planId == planId) {
        foundKey = key;
        foundPlan = val;
        break;
      }
    }
    if (foundKey != null) {
      if (foundPlan != null &&
          getActivePlanIdForCat(foundPlan.catId) == planId) {
        await setActivePlanForCat(catId: foundPlan.catId, planId: null);
      }
      await HiveService.dietPlansBox.delete(foundKey);
    }
  }

  /// Delete all plans for a given catId (useful when deleting a cat).
  Future<void> deletePlansForCat(String catId) async {
    final keysToRemove = <dynamic>[];
    for (final key in HiveService.dietPlansBox.keys) {
      final val = HiveService.dietPlansBox.get(key);
      if (val is DietPlan && val.catId == catId) keysToRemove.add(key);
    }
    for (final k in keysToRemove) {
      await HiveService.dietPlansBox.delete(k);
    }
    await setActivePlanForCat(catId: catId, planId: null);
  }
}

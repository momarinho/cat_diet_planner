import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';

class SuggestionImpactHistoryEntry {
  const SuggestionImpactHistoryEntry({
    required this.id,
    required this.suggestion,
    required this.catId,
    required this.catName,
    required this.acceptedBy,
    required this.appliedAt,
    required this.changeSummary,
    required this.beforePlan,
    required this.afterPlan,
    this.revertedAt,
    this.revertedBy,
  });

  final String id;
  final SmartSuggestion suggestion;
  final String catId;
  final String catName;
  final String acceptedBy;
  final DateTime appliedAt;
  final List<String> changeSummary;
  final DietPlan beforePlan;
  final DietPlan afterPlan;
  final DateTime? revertedAt;
  final String? revertedBy;

  bool get isReverted => revertedAt != null;

  SuggestionImpactHistoryEntry copyWith({
    DateTime? revertedAt,
    String? revertedBy,
  }) {
    return SuggestionImpactHistoryEntry(
      id: id,
      suggestion: suggestion,
      catId: catId,
      catName: catName,
      acceptedBy: acceptedBy,
      appliedAt: appliedAt,
      changeSummary: changeSummary,
      beforePlan: beforePlan,
      afterPlan: afterPlan,
      revertedAt: revertedAt ?? this.revertedAt,
      revertedBy: revertedBy ?? this.revertedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'suggestion': suggestion.toMap(),
      'catId': catId,
      'catName': catName,
      'acceptedBy': acceptedBy,
      'appliedAt': appliedAt.toIso8601String(),
      'changeSummary': changeSummary,
      'beforePlan': _planToMap(beforePlan),
      'afterPlan': _planToMap(afterPlan),
      'revertedAt': revertedAt?.toIso8601String(),
      'revertedBy': revertedBy,
    };
  }

  factory SuggestionImpactHistoryEntry.fromMap(Map<dynamic, dynamic> map) {
    final rawChangeSummary = map['changeSummary'] as List?;
    return SuggestionImpactHistoryEntry(
      id: map['id']?.toString() ?? '',
      suggestion: SmartSuggestion.fromMap(
        (map['suggestion'] as Map?) ?? const {},
      ),
      catId: map['catId']?.toString() ?? '',
      catName: map['catName']?.toString() ?? '',
      acceptedBy: map['acceptedBy']?.toString() ?? '',
      appliedAt:
          DateTime.tryParse(map['appliedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      changeSummary:
          rawChangeSummary
              ?.map((value) => value.toString())
              .toList(growable: false) ??
          const [],
      beforePlan: _planFromMap((map['beforePlan'] as Map?) ?? const {}),
      afterPlan: _planFromMap((map['afterPlan'] as Map?) ?? const {}),
      revertedAt: DateTime.tryParse(map['revertedAt']?.toString() ?? ''),
      revertedBy: map['revertedBy']?.toString(),
    );
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
      'mealTimes': plan.mealTimes,
      'mealLabels': plan.mealLabels,
      'mealPortionGrams': plan.mealPortionGrams,
      'startDate': plan.startDate.toIso8601String(),
      'planId': plan.planId,
      'foodKeys': plan.foodKeys,
      'foodNames': plan.foodNames,
      'portionUnit': plan.portionUnit,
      'portionUnitGrams': plan.portionUnitGrams,
      'foodSplitPercentByKcal': plan.foodSplitPercentByKcal,
      'dailyOverrides': plan.dailyOverrides.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'operationalNotes': plan.operationalNotes,
    };
  }

  static DietPlan _planFromMap(Map<dynamic, dynamic> map) {
    final rawMealTimes = map['mealTimes'] as List?;
    final rawMealLabels = map['mealLabels'] as List?;
    final rawMealPortions = map['mealPortionGrams'] as List?;
    final rawFoodKeys = map['foodKeys'] as List?;
    final rawFoodNames = map['foodNames'] as List?;
    final rawFoodSplits = map['foodSplitPercentByKcal'] as Map?;
    final rawOverrides = map['dailyOverrides'] as Map?;
    return DietPlan(
      catId: map['catId']?.toString() ?? '',
      foodKey: map['foodKey'],
      foodName: map['foodName']?.toString() ?? '',
      targetKcalPerDay: (map['targetKcalPerDay'] as num?)?.toDouble() ?? 0.0,
      portionGramsPerDay:
          (map['portionGramsPerDay'] as num?)?.toDouble() ?? 0.0,
      mealsPerDay: (map['mealsPerDay'] as num?)?.toInt() ?? 0,
      portionGramsPerMeal:
          (map['portionGramsPerMeal'] as num?)?.toDouble() ?? 0.0,
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      goal: map['goal']?.toString() ?? 'maintenance',
      mealTimes:
          rawMealTimes
              ?.map((value) => value.toString())
              .toList(growable: false) ??
          const [],
      mealLabels:
          rawMealLabels
              ?.map((value) => value.toString())
              .toList(growable: false) ??
          const [],
      mealPortionGrams:
          rawMealPortions
              ?.map((value) => (value as num).toDouble())
              .toList(growable: false) ??
          const [],
      startDate:
          DateTime.tryParse(map['startDate']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      planId: map['planId']?.toString(),
      foodKeys: rawFoodKeys?.toList(growable: false) ?? const [],
      foodNames:
          rawFoodNames
              ?.map((value) => value.toString())
              .toList(growable: false) ??
          const [],
      portionUnit: map['portionUnit']?.toString() ?? 'g',
      portionUnitGrams: (map['portionUnitGrams'] as num?)?.toDouble() ?? 1.0,
      foodSplitPercentByKcal: {
        for (final entry in (rawFoodSplits ?? const {}).entries)
          entry.key: (entry.value as num?)?.toDouble() ?? 0.0,
      },
      dailyOverrides: {
        for (final entry in (rawOverrides ?? const {}).entries)
          int.tryParse(entry.key.toString()) ?? 0: Map<dynamic, dynamic>.from(
            (entry.value as Map?) ?? const {},
          ),
      },
      operationalNotes: map['operationalNotes']?.toString(),
    );
  }
}

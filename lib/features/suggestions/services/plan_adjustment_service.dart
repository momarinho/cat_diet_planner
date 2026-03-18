import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';
import 'package:cat_diet_planner/features/suggestions/models/plan_change_audit_entry.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/plan_change_audit_provider.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_impact_history_provider.dart';
import 'package:cat_diet_planner/features/suggestions/models/suggestion_impact_history_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanAdjustmentResult {
  const PlanAdjustmentResult({
    required this.changed,
    required this.summary,
    this.messageKey,
    this.messageArgs = const {},
    this.historyId,
  });

  final bool changed;
  final List<String> summary;
  final String? messageKey;
  final Map<String, Object> messageArgs;
  final String? historyId;
}

class PlanAdjustmentService {
  const PlanAdjustmentService(this._ref);

  final Ref _ref;

  bool requiresPlanChange(SmartSuggestion suggestion) {
    return switch (suggestion.type) {
      SuggestionType.kcalAdjustment => true,
      SuggestionType.scheduleAdjustment => true,
      SuggestionType.portionSplitAdjustment => true,
      _ => false,
    };
  }

  Future<PlanAdjustmentResult> applySuggestion({
    required CatProfile cat,
    required SmartSuggestion suggestion,
    required String acceptedBy,
  }) async {
    if (!requiresPlanChange(suggestion)) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'suggestionRecordedWithoutPlanChanges',
        historyId: null,
      );
    }

    final repository = _ref.read(planRepositoryProvider);
    final currentPlan = repository.getPlanForCat(cat.id);
    if (currentPlan == null) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'noActivePlanAvailableForCat',
        historyId: null,
      );
    }

    final result = switch (suggestion.type) {
      SuggestionType.kcalAdjustment => _validateKcalAdjustment(
        plan: currentPlan,
        suggestion: suggestion,
      ),
      SuggestionType.scheduleAdjustment => _validateScheduleAdjustment(
        plan: currentPlan,
        suggestion: suggestion,
      ),
      SuggestionType.portionSplitAdjustment => _validatePortionAdjustment(
        plan: currentPlan,
        suggestion: suggestion,
      ),
      _ => const PlanAdjustmentResult(changed: false, summary: []),
    };
    if (!result.changed) return result;

    final updatedPlan = switch (suggestion.type) {
      SuggestionType.kcalAdjustment => _updatedKcalPlan(
        plan: currentPlan,
        suggestion: suggestion,
      ),
      SuggestionType.scheduleAdjustment => _updatedSchedulePlan(
        plan: currentPlan,
        suggestion: suggestion,
      ),
      SuggestionType.portionSplitAdjustment => _updatedPortionPlan(
        plan: currentPlan,
        suggestion: suggestion,
      ),
      _ => currentPlan,
    };

    await repository.savePlanForCat(updatedPlan);
    final historyId =
        'impact-${cat.id}-${DateTime.now().microsecondsSinceEpoch}';
    await _ref
        .read(suggestionImpactHistoryServiceProvider)
        .append(
          SuggestionImpactHistoryEntry(
            id: historyId,
            suggestion: suggestion,
            catId: cat.id,
            catName: cat.name,
            acceptedBy: acceptedBy,
            appliedAt: DateTime.now(),
            changeSummary: result.summary,
            beforePlan: currentPlan,
            afterPlan: updatedPlan,
          ),
        );
    await _ref
        .read(planChangeAuditServiceProvider)
        .append(
          PlanChangeAuditEntry(
            suggestionId: suggestion.id,
            catId: cat.id,
            catName: cat.name,
            acceptedBy: acceptedBy,
            acceptedAt: DateTime.now(),
            changeSummary: result.summary,
          ),
        );
    _ref.invalidate(planChangeAuditProvider);
    _ref.invalidate(suggestionImpactHistoryProvider);
    return PlanAdjustmentResult(
      changed: result.changed,
      summary: result.summary,
      messageKey: result.messageKey,
      messageArgs: result.messageArgs,
      historyId: historyId,
    );
  }

  Future<PlanAdjustmentResult> revertLastSuggestedChange({
    String? catId,
    required String revertedBy,
  }) async {
    final impactService = _ref.read(suggestionImpactHistoryServiceProvider);
    final latest = impactService.latestRevertible(catId: catId);
    if (latest == null) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'noSuggestedPlanChangesAvailableToRevert',
        historyId: null,
      );
    }

    final restoredPlan = _copyPlan(source: latest.beforePlan);
    await _ref.read(planRepositoryProvider).savePlanForCat(restoredPlan);
    await impactService.markReverted(
      historyId: latest.id,
      revertedBy: revertedBy,
    );
    await _ref
        .read(planChangeAuditServiceProvider)
        .append(
          PlanChangeAuditEntry(
            suggestionId: latest.suggestion.id,
            catId: latest.catId,
            catName: latest.catName,
            acceptedBy: revertedBy,
            acceptedAt: DateTime.now(),
            changeSummary: latest.changeSummary,
          ),
        );
    _ref.invalidate(planChangeAuditProvider);
    _ref.invalidate(suggestionImpactHistoryProvider);
    return PlanAdjustmentResult(
      changed: true,
      summary: latest.changeSummary,
      messageKey: 'lastSuggestedChangeReverted',
      historyId: latest.id,
    );
  }

  PlanAdjustmentResult _validateKcalAdjustment({
    required DietPlan plan,
    required SmartSuggestion suggestion,
  }) {
    final changePercent = (suggestion.metadata['changePercent'] as num?)
        ?.toInt();
    final suggestedKcal = (suggestion.metadata['suggestedKcal'] as num?)
        ?.toDouble();
    if (changePercent == null || suggestedKcal == null) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'suggestionDataIncomplete',
        historyId: null,
      );
    }

    if (changePercent.abs() > AppLimits.maxSuggestionKcalAdjustmentPercent) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'suggestedKcalChangeExceedsSafeBand',
        historyId: null,
      );
    }
    if (suggestedKcal < AppLimits.minPlanTargetKcalPerDay ||
        suggestedKcal > AppLimits.maxPlanTargetKcalPerDay) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'suggestedKcalTargetOutsideSafeRange',
        historyId: null,
      );
    }

    final nextPortion = _portionFromPlanKcal(
      currentPlan: plan,
      targetKcal: suggestedKcal,
    );
    if (nextPortion <= 0) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'unableToRecalculatePortionSafely',
        historyId: null,
      );
    }

    final direction = changePercent > 0 ? '+' : '';
    return PlanAdjustmentResult(
      changed: true,
      summary: [
        'kcal_change|${plan.targetKcalPerDay.toStringAsFixed(0)}|${suggestedKcal.toStringAsFixed(0)}|$direction$changePercent%',
        'daily_portion_change|${plan.portionGramsPerDay.toStringAsFixed(1)} g|${nextPortion.toStringAsFixed(1)} g',
      ],
      historyId: null,
    );
  }

  DietPlan _updatedKcalPlan({
    required DietPlan plan,
    required SmartSuggestion suggestion,
  }) {
    final suggestedKcal = (suggestion.metadata['suggestedKcal'] as num)
        .toDouble();
    final nextPortion = _portionFromPlanKcal(
      currentPlan: plan,
      targetKcal: suggestedKcal,
    );
    final shares = _mealShares(plan.mealPortionGrams, plan.portionGramsPerDay);
    final updatedMealPortions = shares
        .map((share) => nextPortion * share)
        .toList(growable: false);

    return _copyPlan(
      source: plan,
      targetKcalPerDay: suggestedKcal,
      portionGramsPerDay: nextPortion,
      portionGramsPerMeal: nextPortion / plan.mealsPerDay,
      mealPortionGrams: updatedMealPortions,
    );
  }

  PlanAdjustmentResult _validateScheduleAdjustment({
    required DietPlan plan,
    required SmartSuggestion suggestion,
  }) {
    final shiftMinutes = (suggestion.metadata['shiftMinutes'] as num?)?.toInt();
    final index = _mealIndexFromSlotId(
      suggestion.metadata['targetSlotId']?.toString(),
    );
    if (shiftMinutes == null ||
        index == null ||
        index >= plan.mealTimes.length) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'suggestionDataIncomplete',
        historyId: null,
      );
    }
    if (shiftMinutes.abs() > AppLimits.maxSuggestionScheduleShiftMinutes) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'scheduleChangeExceedsSafeShiftLimit',
        historyId: null,
      );
    }

    final nextTime = _shiftTime(plan.mealTimes[index], shiftMinutes);
    return PlanAdjustmentResult(
      changed: true,
      summary: [
        'meal_time_change|${plan.mealLabels[index]}|${plan.mealTimes[index]}|$nextTime',
      ],
      historyId: null,
    );
  }

  DietPlan _updatedSchedulePlan({
    required DietPlan plan,
    required SmartSuggestion suggestion,
  }) {
    final shiftMinutes = (suggestion.metadata['shiftMinutes'] as num).toInt();
    final index = _mealIndexFromSlotId(
      suggestion.metadata['targetSlotId']?.toString(),
    )!;
    final updatedMealTimes = List<String>.from(plan.mealTimes);
    updatedMealTimes[index] = _shiftTime(updatedMealTimes[index], shiftMinutes);
    return _copyPlan(source: plan, mealTimes: updatedMealTimes);
  }

  PlanAdjustmentResult _validatePortionAdjustment({
    required DietPlan plan,
    required SmartSuggestion suggestion,
  }) {
    final updatedRaw = suggestion.metadata['newMealPortionGrams'] as List?;
    final fromIndex = (suggestion.metadata['fromMealIndex'] as num?)?.toInt();
    final toIndex = (suggestion.metadata['toMealIndex'] as num?)?.toInt();
    final shiftGrams = (suggestion.metadata['shiftGrams'] as num?)?.toDouble();
    if (updatedRaw == null ||
        fromIndex == null ||
        toIndex == null ||
        shiftGrams == null) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'suggestionDataIncomplete',
        historyId: null,
      );
    }

    final updated = updatedRaw
        .map((entry) => (entry as num).toDouble())
        .toList(growable: false);
    if (updated.length != plan.mealPortionGrams.length ||
        fromIndex >= updated.length ||
        toIndex >= updated.length) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'portionRedistributionInvalidForActivePlan',
        historyId: null,
      );
    }

    final safeLimit =
        plan.mealPortionGrams[fromIndex] *
        AppLimits.maxSuggestionMealPortionShiftRatio;
    if (shiftGrams > safeLimit) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'portionShiftExceedsSafeRedistributionLimit',
        historyId: null,
      );
    }

    final originalSum = plan.mealPortionGrams.fold<double>(0, (acc, value) {
      return acc + value;
    });
    final updatedSum = updated.fold<double>(0, (acc, value) {
      return acc + value;
    });
    if ((originalSum - updatedSum).abs() > 0.2 ||
        updated.any((value) => value <= 0)) {
      return const PlanAdjustmentResult(
        changed: false,
        summary: [],
        messageKey: 'portionRedistributionFailedSafetyValidation',
        historyId: null,
      );
    }

    return PlanAdjustmentResult(
      changed: true,
      summary: [
        'meal_portion_change|${plan.mealLabels[fromIndex]}|${plan.mealPortionGrams[fromIndex].toStringAsFixed(1)} g|${updated[fromIndex].toStringAsFixed(1)} g',
        'meal_portion_change|${plan.mealLabels[toIndex]}|${plan.mealPortionGrams[toIndex].toStringAsFixed(1)} g|${updated[toIndex].toStringAsFixed(1)} g',
      ],
      historyId: null,
    );
  }

  DietPlan _updatedPortionPlan({
    required DietPlan plan,
    required SmartSuggestion suggestion,
  }) {
    final updated = (suggestion.metadata['newMealPortionGrams'] as List)
        .map((entry) => (entry as num).toDouble())
        .toList(growable: false);
    return _copyPlan(
      source: plan,
      portionGramsPerMeal: plan.portionGramsPerDay / plan.mealsPerDay,
      mealPortionGrams: updated,
    );
  }

  double _portionFromPlanKcal({
    required DietPlan currentPlan,
    required double targetKcal,
  }) {
    final kcalPer100g = currentPlan.portionGramsPerDay <= 0
        ? 0.0
        : (currentPlan.targetKcalPerDay / currentPlan.portionGramsPerDay) * 100;
    if (kcalPer100g <= 0) return 0.0;
    return DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: targetKcal,
      kcalPer100g: kcalPer100g,
    );
  }

  List<double> _mealShares(List<double> mealPortions, double totalPortion) {
    if (mealPortions.isEmpty || totalPortion <= 0) {
      return List<double>.filled(1, 1.0, growable: false);
    }
    return mealPortions
        .map((portion) => portion / totalPortion)
        .toList(growable: false);
  }

  int? _mealIndexFromSlotId(String? slotId) {
    final match = RegExp(r'meal_(\d+)').firstMatch(slotId ?? '');
    final mealNumber = int.tryParse(match?.group(1) ?? '');
    if (mealNumber == null || mealNumber <= 0) return null;
    return mealNumber - 1;
  }

  String _shiftTime(String time, int deltaMinutes) {
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    ).firstMatch(time.trim());
    if (match == null) return time;

    final hour12 = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!.toUpperCase();
    var hour24 = hour12 % 12;
    if (period == 'PM') hour24 += 12;

    final shifted = ((hour24 * 60) + minute + deltaMinutes) % (24 * 60);
    final normalized = shifted < 0 ? shifted + (24 * 60) : shifted;
    final nextHour24 = normalized ~/ 60;
    final nextMinute = normalized % 60;
    final nextPeriod = nextHour24 >= 12 ? 'PM' : 'AM';
    final nextHour12 = switch (nextHour24 % 12) {
      0 => 12,
      final value => value,
    };

    return '${nextHour12.toString().padLeft(2, '0')}:${nextMinute.toString().padLeft(2, '0')} $nextPeriod';
  }

  DietPlan _copyPlan({
    required DietPlan source,
    double? targetKcalPerDay,
    double? portionGramsPerDay,
    double? portionGramsPerMeal,
    List<String>? mealTimes,
    List<double>? mealPortionGrams,
  }) {
    return DietPlan(
      catId: source.catId,
      foodKey: source.foodKey,
      foodName: source.foodName,
      targetKcalPerDay: targetKcalPerDay ?? source.targetKcalPerDay,
      portionGramsPerDay: portionGramsPerDay ?? source.portionGramsPerDay,
      mealsPerDay: source.mealsPerDay,
      portionGramsPerMeal: portionGramsPerMeal ?? source.portionGramsPerMeal,
      createdAt: DateTime.now(),
      goal: source.goal,
      mealTimes: mealTimes ?? List<String>.from(source.mealTimes),
      mealLabels: List<String>.from(source.mealLabels),
      mealPortionGrams:
          mealPortionGrams ?? List<double>.from(source.mealPortionGrams),
      startDate: source.startDate,
      planId: source.planId,
      foodKeys: List<dynamic>.from(source.foodKeys),
      foodNames: List<String>.from(source.foodNames),
      portionUnit: source.portionUnit,
      portionUnitGrams: source.portionUnitGrams,
      dailyOverrides: source.dailyOverrides,
      operationalNotes: source.operationalNotes,
      foodSplitPercentByKcal: source.foodSplitPercentByKcal,
    );
  }
}

final planAdjustmentServiceProvider = Provider<PlanAdjustmentService>((ref) {
  return PlanAdjustmentService(ref);
});

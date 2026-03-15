import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';

class SuggestionEngine {
  const SuggestionEngine({
    this.interventionLevel = 'balanced',
    this.categoryToggles = const {
      'kcalAdjustment': true,
      'scheduleAdjustment': true,
      'portionSplitAdjustment': true,
      'preventiveTrendAlert': true,
      'clinicalWatch': true,
    },
    this.dailySuggestionLimit = 3,
    this.alertsOnly = false,
  });

  final String interventionLevel;
  final Map<String, bool> categoryToggles;
  final int dailySuggestionLimit;
  final bool alertsOnly;

  List<SmartSuggestion> generateForCat({
    required CatProfile cat,
    required List<WeightRecord> weightRecords,
    required List<Map<String, dynamic>> recentMealSchedules,
    DietPlan? activePlan,
    DateTime? now,
  }) {
    final ref = now ?? DateTime.now();
    final sortedWeights = [...weightRecords]
      ..sort((a, b) => a.date.compareTo(b.date));
    final recentWeights = _weightsInWindow(
      sortedWeights,
      days: 14,
      now: ref,
      catId: cat.id,
    );
    final mealSummary = _buildMealSummary(
      recentMealSchedules,
      now: ref,
      days: 7,
    );
    final clinicalSummary = _buildClinicalSummary(recentWeights, cat);
    final suggestions = <SmartSuggestion>[];

    if (activePlan != null) {
      final kcal = _buildKcalAdjustmentSuggestion(
        cat: cat,
        plan: activePlan,
        recentWeights: recentWeights,
        mealSummary: mealSummary,
        clinicalSummary: clinicalSummary,
        now: ref,
      );
      if (kcal != null) suggestions.add(kcal);

      final portion = _buildPortionSplitSuggestion(
        cat: cat,
        plan: activePlan,
        mealSummary: mealSummary,
        now: ref,
      );
      if (portion != null) suggestions.add(portion);
    }

    final schedule = _buildScheduleAdjustmentSuggestion(
      cat: cat,
      mealSummary: mealSummary,
      now: ref,
    );
    if (schedule != null) suggestions.add(schedule);

    final preventiveAlert = _buildPreventiveTrendAlertSuggestion(
      cat: cat,
      recentWeights: recentWeights,
      now: ref,
    );
    if (preventiveAlert != null) suggestions.add(preventiveAlert);

    final clinical = _buildClinicalSuggestion(
      cat: cat,
      clinicalSummary: clinicalSummary,
      now: ref,
    );
    if (clinical != null) suggestions.add(clinical);

    suggestions.sort((a, b) {
      if (a.priority != b.priority) {
        return b.priority.index.compareTo(a.priority.index);
      }
      return b.confidenceScore.compareTo(a.confidenceScore);
    });
    return suggestions
        .where(_isSuggestionAllowed)
        .take(dailySuggestionLimit.clamp(1, 10))
        .toList(growable: false);
  }

  SmartSuggestion? _buildKcalAdjustmentSuggestion({
    required CatProfile cat,
    required DietPlan plan,
    required List<WeightRecord> recentWeights,
    required _MealSummary mealSummary,
    required _ClinicalSummary clinicalSummary,
    required DateTime now,
  }) {
    if (recentWeights.length < 2) return null;

    final start = recentWeights.first.weight;
    final end = recentWeights.last.weight;
    final deltaPercent = start == 0 ? 0.0 : ((end - start) / start) * 100.0;
    final reasons = <String>[];
    var changePercent = 0;

    final trendThreshold = switch (interventionLevel) {
      'conservative' => 2.0,
      'proactive' => 1.0,
      _ => 1.5,
    };
    final goalBoundaryChange = switch (interventionLevel) {
      'conservative' => 3,
      'proactive' => 5,
      _ => 4,
    };

    if (deltaPercent >= trendThreshold) {
      reasons.add(SuggestionReasonCodes.weightTrendUp);
      if (cat.goal == 'loss') {
        changePercent -= _goalDrivenKcalDelta(
          conservative: 4,
          balanced: 6,
          proactive: 8,
        );
      } else if (cat.goal == 'maintenance') {
        changePercent -= _goalDrivenKcalDelta(
          conservative: 3,
          balanced: 4,
          proactive: 5,
        );
      }
    } else if (deltaPercent <= -trendThreshold) {
      reasons.add(SuggestionReasonCodes.weightTrendDown);
      if (cat.goal == 'gain') {
        changePercent += _goalDrivenKcalDelta(
          conservative: 4,
          balanced: 6,
          proactive: 8,
        );
      } else if (cat.goal == 'maintenance') {
        changePercent += _goalDrivenKcalDelta(
          conservative: 3,
          balanced: 4,
          proactive: 5,
        );
      }
    }

    final goalMin = cat.weightGoalMinKg;
    final goalMax = cat.weightGoalMaxKg;
    if (goalMax != null && end > goalMax) {
      reasons.add(SuggestionReasonCodes.outOfGoalMax);
      changePercent -= goalBoundaryChange;
    }
    if (goalMin != null && end < goalMin) {
      reasons.add(SuggestionReasonCodes.outOfGoalMin);
      changePercent += goalBoundaryChange;
    }

    if (changePercent == 0) return null;

    final isReduction = changePercent < 0;
    if (isReduction && clinicalSummary.instabilitySignals > 0) {
      // Keep recommendation conservative when recent clinical context is unstable.
      changePercent = changePercent.clamp(
        _goalDrivenKcalDelta(conservative: -2, balanced: -3, proactive: -4),
        10,
      );
    }
    changePercent = changePercent.clamp(
      _goalDrivenKcalDelta(conservative: -6, balanced: -10, proactive: -12),
      _goalDrivenKcalDelta(conservative: 6, balanced: 10, proactive: 12),
    );

    final suggestedKcal = (plan.targetKcalPerDay * (1 + (changePercent / 100)))
        .clamp(120, 700);
    final confidence = _kcalConfidence(
      weightSamples: recentWeights.length,
      mealAdherence: mealSummary.adherenceRatio,
      hasGoalBoundarySignal:
          reasons.contains(SuggestionReasonCodes.outOfGoalMax) ||
          reasons.contains(SuggestionReasonCodes.outOfGoalMin),
      clinicalInstability: clinicalSummary.instabilitySignals > 0,
    );

    if (recentWeights.length < 4) {
      reasons.add(SuggestionReasonCodes.lowEvidence);
    }

    final changeLabel = changePercent > 0
        ? '+$changePercent%'
        : '$changePercent%';

    return SmartSuggestion(
      id: 'kcal-${cat.id}',
      type: SuggestionType.kcalAdjustment,
      priority:
          reasons.contains(SuggestionReasonCodes.outOfGoalMax) ||
              reasons.contains(SuggestionReasonCodes.outOfGoalMin)
          ? SuggestionPriority.high
          : SuggestionPriority.medium,
      title: 'Adjust daily calories for ${cat.name}',
      summary:
          'Weight trend over the last 14 days suggests a $changeLabel kcal adjustment.',
      recommendedAction:
          'Set target to ${suggestedKcal.toStringAsFixed(0)} kcal/day and monitor for 7 days.',
      confidenceScore: confidence,
      reasonCodes: reasons,
      metadata: {
        'currentKcal': plan.targetKcalPerDay,
        'suggestedKcal': suggestedKcal,
        'changePercent': changePercent,
        'weightDeltaPercent14d': deltaPercent,
      },
      generatedAt: now,
    );
  }

  SmartSuggestion? _buildScheduleAdjustmentSuggestion({
    required CatProfile cat,
    required _MealSummary mealSummary,
    required DateTime now,
  }) {
    final minimumMeals = switch (interventionLevel) {
      'conservative' => 8,
      'proactive' => 4,
      _ => 6,
    };
    if (mealSummary.totalMeals < minimumMeals ||
        mealSummary.slotStats.isEmpty) {
      return null;
    }

    final rankedSlots =
        mealSummary.slotStats.values
            .where((slot) => slot.total >= 3)
            .toList(growable: false)
          ..sort((a, b) {
            if (a.adherence != b.adherence) {
              return a.adherence.compareTo(b.adherence);
            }
            return (b.delayed + b.refused).compareTo(a.delayed + a.refused);
          });

    if (rankedSlots.isEmpty) return null;
    final worstSlot = rankedSlots.first;
    final acceptableAdherence = switch (interventionLevel) {
      'conservative' => 0.72,
      'proactive' => 0.88,
      _ => 0.80,
    };
    if (worstSlot.adherence >= acceptableAdherence &&
        worstSlot.delayed < 2 &&
        worstSlot.refused == 0) {
      return null;
    }

    final reasons = <String>[SuggestionReasonCodes.adherenceLow];
    if (worstSlot.delayed >= 2) {
      reasons.add(SuggestionReasonCodes.delayedFrequent);
    }
    if (worstSlot.refused >= 1) {
      reasons.add(SuggestionReasonCodes.refusalFrequent);
    }

    final shiftMinutes = switch (interventionLevel) {
      'conservative' => worstSlot.delayed >= 2 ? 15 : 10,
      'proactive' => worstSlot.delayed >= 2 ? 45 : 20,
      _ => worstSlot.delayed >= 2 ? 30 : 15,
    };
    final confidence = _scheduleConfidence(
      totalMeals: mealSummary.totalMeals,
      slotSamples: worstSlot.total,
      slotAdherence: worstSlot.adherence,
      delayedMeals: worstSlot.delayed,
      refusedMeals: worstSlot.refused,
    );

    return SmartSuggestion(
      id: 'schedule-${cat.id}-${worstSlot.slotId}',
      type: SuggestionType.scheduleAdjustment,
      priority: worstSlot.adherence < 0.55 || worstSlot.refused >= 2
          ? SuggestionPriority.high
          : SuggestionPriority.medium,
      title: 'Adjust feeding time window for ${cat.name}',
      summary:
          'Slot ${worstSlot.timeLabel} has ${(worstSlot.adherence * 100).toStringAsFixed(0)}% adherence in the last 7 days.',
      recommendedAction:
          'Shift this slot by +$shiftMinutes min and re-evaluate adherence for 3 days.',
      confidenceScore: confidence,
      reasonCodes: reasons,
      metadata: {
        'targetSlotId': worstSlot.slotId,
        'targetTimeLabel': worstSlot.timeLabel,
        'shiftMinutes': shiftMinutes,
        'slotAdherence': worstSlot.adherence,
        'slotSamples': worstSlot.total,
      },
      generatedAt: now,
    );
  }

  SmartSuggestion? _buildPortionSplitSuggestion({
    required CatProfile cat,
    required DietPlan plan,
    required _MealSummary mealSummary,
    required DateTime now,
  }) {
    final minimumMeals = switch (interventionLevel) {
      'conservative' => 8,
      'proactive' => 4,
      _ => 6,
    };
    if (plan.mealPortionGrams.length < 2 ||
        mealSummary.totalMeals < minimumMeals) {
      return null;
    }

    var worstIndex = -1;
    var bestIndex = -1;
    var worstAdherence = 2.0;
    var bestAdherence = -1.0;
    _MealSlotStats? worstStats;
    _MealSlotStats? bestStats;

    for (var i = 0; i < plan.mealPortionGrams.length; i++) {
      final slotId = 'meal_${i + 1}';
      final stats = mealSummary.slotStats[slotId];
      if (stats == null || stats.total < 3) continue;

      if (stats.adherence < worstAdherence) {
        worstAdherence = stats.adherence;
        worstIndex = i;
        worstStats = stats;
      }
      if (stats.adherence > bestAdherence) {
        bestAdherence = stats.adherence;
        bestIndex = i;
        bestStats = stats;
      }
    }

    if (worstIndex < 0 ||
        bestIndex < 0 ||
        worstIndex == bestIndex ||
        worstStats == null ||
        bestStats == null) {
      return null;
    }

    final adherenceGap = bestAdherence - worstAdherence;
    final minimumGap = switch (interventionLevel) {
      'conservative' => 0.28,
      'proactive' => 0.14,
      _ => 0.20,
    };
    final maximumWorstAdherence = switch (interventionLevel) {
      'conservative' => 0.60,
      'proactive' => 0.80,
      _ => 0.72,
    };
    if (adherenceGap < minimumGap || worstAdherence > maximumWorstAdherence) {
      return null;
    }

    final desiredShiftRatio =
        (_portionShiftBase() + (maximumWorstAdherence - worstAdherence)).clamp(
          _portionShiftBase(),
          _portionShiftMax(),
        );
    final desiredShiftGrams = plan.portionGramsPerDay * desiredShiftRatio;
    final maxFromWorst =
        plan.mealPortionGrams[worstIndex] *
        switch (interventionLevel) {
          'conservative' => 0.22,
          'proactive' => 0.38,
          _ => 0.30,
        };
    final shiftGrams = desiredShiftGrams.clamp(1.0, maxFromWorst);
    if (shiftGrams < 1.0) return null;

    final updatedPortions = [...plan.mealPortionGrams];
    updatedPortions[worstIndex] -= shiftGrams;
    updatedPortions[bestIndex] += shiftGrams;

    final reasons = <String>[SuggestionReasonCodes.adherenceLow];
    if (worstStats.delayed >= 2) {
      reasons.add(SuggestionReasonCodes.delayedFrequent);
    }
    if (worstStats.refused >= 1) {
      reasons.add(SuggestionReasonCodes.refusalFrequent);
    }

    return SmartSuggestion(
      id: 'portion-${cat.id}-$worstIndex-$bestIndex',
      type: SuggestionType.portionSplitAdjustment,
      priority: worstAdherence < 0.50
          ? SuggestionPriority.high
          : SuggestionPriority.medium,
      title: 'Rebalance meal portions for ${cat.name}',
      summary:
          'Lower adherence in ${_mealSlotLabel(plan, worstIndex)} suggests redistributing part of the daily portion.',
      recommendedAction:
          'Move ${shiftGrams.toStringAsFixed(1)} g from ${_mealSlotLabel(plan, worstIndex)} to ${_mealSlotLabel(plan, bestIndex)}.',
      confidenceScore: _portionConfidence(
        totalMeals: mealSummary.totalMeals,
        worstAdherence: worstAdherence,
        bestAdherence: bestAdherence,
        slotSamples: worstStats.total,
      ),
      reasonCodes: reasons,
      metadata: {
        'fromMealIndex': worstIndex,
        'toMealIndex': bestIndex,
        'fromMealLabel': _mealSlotLabel(plan, worstIndex),
        'toMealLabel': _mealSlotLabel(plan, bestIndex),
        'shiftGrams': shiftGrams,
        'newMealPortionGrams': updatedPortions,
        'fromAdherence': worstAdherence,
        'toAdherence': bestAdherence,
      },
      generatedAt: now,
    );
  }

  SmartSuggestion? _buildPreventiveTrendAlertSuggestion({
    required CatProfile cat,
    required List<WeightRecord> recentWeights,
    required DateTime now,
  }) {
    if (recentWeights.length < 3) return null;

    final first = recentWeights.first.weight;
    final latest = recentWeights.last.weight;
    if (first <= 0) return null;
    final deltaPercent = ((latest - first) / first) * 100;

    final reasons = <String>[];
    String boundary = 'none';
    double distancePercent = 999;

    final goalMax = cat.weightGoalMaxKg;
    final trendThreshold = switch (interventionLevel) {
      'conservative' => 1.2,
      'proactive' => 0.5,
      _ => 0.8,
    };
    final boundaryThreshold = switch (interventionLevel) {
      'conservative' => 2.0,
      'proactive' => 4.0,
      _ => 3.0,
    };

    if (goalMax != null && latest < goalMax && deltaPercent > trendThreshold) {
      final distance = ((goalMax - latest) / goalMax) * 100;
      if (distance <= boundaryThreshold) {
        reasons.add(SuggestionReasonCodes.approachingGoalMax);
        boundary = 'max';
        distancePercent = distance;
      }
    }

    final goalMin = cat.weightGoalMinKg;
    if (goalMin != null && latest > goalMin && deltaPercent < -trendThreshold) {
      final distance = ((latest - goalMin) / goalMin) * 100;
      if (distance <= boundaryThreshold && distance < distancePercent) {
        reasons
          ..clear()
          ..add(SuggestionReasonCodes.approachingGoalMin);
        boundary = 'min';
        distancePercent = distance;
      }
    }

    if (reasons.isEmpty) return null;

    final priority = distancePercent <= 1.5
        ? SuggestionPriority.high
        : SuggestionPriority.medium;

    return SmartSuggestion(
      id: 'preventive-${cat.id}-$boundary',
      type: SuggestionType.preventiveTrendAlert,
      priority: priority,
      title: 'Preventive weight trend alert for ${cat.name}',
      summary:
          'Current trend is approaching the ${boundary == 'max' ? 'upper' : 'lower'} weight boundary.',
      recommendedAction:
          'Increase monitoring frequency and review plan settings before crossing the goal range.',
      confidenceScore: _preventiveConfidence(
        weightSamples: recentWeights.length,
        distancePercent: distancePercent,
        trendPercent: deltaPercent.abs(),
      ),
      reasonCodes: reasons,
      metadata: {
        'boundary': boundary,
        'distanceToBoundaryPercent': distancePercent,
        'weightDeltaPercent14d': deltaPercent,
        'latestWeight': latest,
        'goalMinKg': goalMin,
        'goalMaxKg': goalMax,
      },
      generatedAt: now,
    );
  }

  SmartSuggestion? _buildClinicalSuggestion({
    required CatProfile cat,
    required _ClinicalSummary clinicalSummary,
    required DateTime now,
  }) {
    final reasons = <String>[];

    if (cat.clinicalConditions.isNotEmpty) {
      reasons.add(SuggestionReasonCodes.clinicalConditionPresent);
    }
    if (clinicalSummary.reducedAppetiteCount > 0) {
      reasons.add(SuggestionReasonCodes.appetiteReduced);
    }
    if (clinicalSummary.poorAppetiteCount > 0) {
      reasons.add(SuggestionReasonCodes.appetitePoor);
    }
    if (clinicalSummary.frequentVomitCount > 0) {
      reasons.add(SuggestionReasonCodes.vomitFrequent);
    }
    if (clinicalSummary.diarrheaCount > 0) {
      reasons.add(SuggestionReasonCodes.stoolDiarrhea);
    }
    if (clinicalSummary.alertTriggeredCount > 0) {
      reasons.add(SuggestionReasonCodes.weightAlertTriggered);
    }

    if (reasons.isEmpty) return null;

    return SmartSuggestion(
      id: 'clinical-${cat.id}',
      type: SuggestionType.clinicalWatch,
      priority: clinicalSummary.instabilitySignals >= 2
          ? SuggestionPriority.high
          : SuggestionPriority.medium,
      title: 'Clinical context watch for ${cat.name}',
      summary:
          'Recent check-ins include clinical context signals that should guide feeding decisions.',
      recommendedAction:
          'Keep dietary changes conservative and log appetite/stool/vomit daily for 3-5 days.',
      confidenceScore: _clinicalConfidence(clinicalSummary, cat),
      reasonCodes: reasons,
      metadata: {
        'clinicalConditionsCount': cat.clinicalConditions.length,
        'reducedAppetiteCount14d': clinicalSummary.reducedAppetiteCount,
        'poorAppetiteCount14d': clinicalSummary.poorAppetiteCount,
        'frequentVomitCount14d': clinicalSummary.frequentVomitCount,
        'diarrheaCount14d': clinicalSummary.diarrheaCount,
        'alertTriggeredCount14d': clinicalSummary.alertTriggeredCount,
      },
      generatedAt: now,
    );
  }

  List<WeightRecord> _weightsInWindow(
    List<WeightRecord> source, {
    required int days,
    required DateTime now,
    required String catId,
  }) {
    final cutoff = now.subtract(Duration(days: days));
    return source
        .where(
          (record) => record.catId == catId && !record.date.isBefore(cutoff),
        )
        .toList(growable: false);
  }

  _MealSummary _buildMealSummary(
    List<Map<String, dynamic>> schedules, {
    required DateTime now,
    required int days,
  }) {
    final cutoff = now.subtract(Duration(days: days));
    var totalMeals = 0;
    var completedMeals = 0;
    var delayedMeals = 0;
    var refusedMeals = 0;
    final mealsPerDayCounts = <int>[];
    final slotAccumulators = <String, _MealSlotAccumulator>{};

    for (final schedule in schedules) {
      final dateRaw = schedule['date']?.toString();
      final date = dateRaw == null ? null : DateTime.tryParse(dateRaw);
      if (date != null && date.isBefore(cutoff)) continue;

      final items = ((schedule['items'] as List?) ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);
      final meals = items.where((item) => item['type'] == 'meal').toList();
      if (meals.isNotEmpty) mealsPerDayCounts.add(meals.length);

      for (var i = 0; i < meals.length; i++) {
        final meal = meals[i];
        totalMeals += 1;
        final completed = meal['completed'] == true;
        if (completed) completedMeals += 1;

        final ctx = meal['mealContext']?.toString();
        if (ctx == 'delayed') delayedMeals += 1;
        if (ctx == 'refused') refusedMeals += 1;

        final slotId = meal['id']?.toString() ?? 'meal_${i + 1}';
        final slotTime = meal['time']?.toString() ?? 'Anytime';
        final slot = slotAccumulators.putIfAbsent(
          slotId,
          () => _MealSlotAccumulator(slotId: slotId, timeLabel: slotTime),
        );
        slot.total += 1;
        if (completed) slot.completed += 1;
        if (ctx == 'delayed') slot.delayed += 1;
        if (ctx == 'refused') slot.refused += 1;
      }
    }

    final adherence = totalMeals == 0 ? 0.0 : completedMeals / totalMeals;
    final mealsPerDayEstimate = mealsPerDayCounts.isEmpty
        ? 4
        : (mealsPerDayCounts.reduce((a, b) => a + b) / mealsPerDayCounts.length)
              .round()
              .clamp(1, 8);

    final slotStats = <String, _MealSlotStats>{};
    for (final entry in slotAccumulators.entries) {
      slotStats[entry.key] = entry.value.toStats();
    }

    return _MealSummary(
      totalMeals: totalMeals,
      completedMeals: completedMeals,
      delayedMeals: delayedMeals,
      refusedMeals: refusedMeals,
      adherenceRatio: adherence,
      mealsPerDayEstimate: mealsPerDayEstimate,
      slotStats: slotStats,
    );
  }

  _ClinicalSummary _buildClinicalSummary(
    List<WeightRecord> recentWeights,
    CatProfile cat,
  ) {
    var reducedAppetite = 0;
    var poorAppetite = 0;
    var frequentVomit = 0;
    var diarrhea = 0;
    var alertTriggered = 0;

    for (final record in recentWeights) {
      if (record.appetite == 'reduced') reducedAppetite += 1;
      if (record.appetite == 'poor') poorAppetite += 1;
      if (record.vomit == 'frequent') frequentVomit += 1;
      if (record.stool == 'diarrhea') diarrhea += 1;
      if (record.alertTriggered) alertTriggered += 1;
    }

    final instabilitySignals = [
      reducedAppetite > 0 || poorAppetite > 0,
      frequentVomit > 0,
      diarrhea > 0,
      alertTriggered > 0,
      cat.clinicalConditions.isNotEmpty,
    ].where((flag) => flag).length;

    return _ClinicalSummary(
      reducedAppetiteCount: reducedAppetite,
      poorAppetiteCount: poorAppetite,
      frequentVomitCount: frequentVomit,
      diarrheaCount: diarrhea,
      alertTriggeredCount: alertTriggered,
      instabilitySignals: instabilitySignals,
    );
  }

  String _mealSlotLabel(DietPlan plan, int index) {
    final custom = index < plan.mealLabels.length
        ? plan.mealLabels[index].trim()
        : '';
    if (custom.isNotEmpty) return custom;
    return 'Meal ${index + 1}';
  }

  double _kcalConfidence({
    required int weightSamples,
    required double mealAdherence,
    required bool hasGoalBoundarySignal,
    required bool clinicalInstability,
  }) {
    var score = 0.50;
    if (weightSamples >= 4) score += 0.18;
    if (weightSamples >= 6) score += 0.05;
    if (mealAdherence >= 0.70) score += 0.10;
    if (hasGoalBoundarySignal) score += 0.08;
    if (clinicalInstability) score -= 0.12;
    return score.clamp(0.10, 0.95);
  }

  double _scheduleConfidence({
    required int totalMeals,
    required int slotSamples,
    required double slotAdherence,
    required int delayedMeals,
    required int refusedMeals,
  }) {
    var score = 0.42;
    if (totalMeals >= 14) score += 0.16;
    if (slotSamples >= 5) score += 0.12;
    if (slotAdherence < 0.65) score += 0.10;
    if (delayedMeals >= 2) score += 0.08;
    if (refusedMeals >= 1) score += 0.08;
    return score.clamp(0.10, 0.95);
  }

  double _portionConfidence({
    required int totalMeals,
    required double worstAdherence,
    required double bestAdherence,
    required int slotSamples,
  }) {
    var score = 0.45;
    if (totalMeals >= 14) score += 0.12;
    if (slotSamples >= 5) score += 0.10;
    if ((bestAdherence - worstAdherence) >= 0.30) score += 0.14;
    if (worstAdherence < 0.55) score += 0.10;
    return score.clamp(0.10, 0.95);
  }

  double _preventiveConfidence({
    required int weightSamples,
    required double distancePercent,
    required double trendPercent,
  }) {
    var score = 0.40;
    if (weightSamples >= 4) score += 0.14;
    if (trendPercent >= 1.2) score += 0.10;
    if (distancePercent <= 2.0) score += 0.18;
    return score.clamp(0.10, 0.95);
  }

  double _clinicalConfidence(_ClinicalSummary clinical, CatProfile cat) {
    var score = 0.40;
    if (cat.clinicalConditions.isNotEmpty) score += 0.20;
    score += (clinical.instabilitySignals * 0.08);
    return score.clamp(0.10, 0.95);
  }

  bool _isSuggestionAllowed(SmartSuggestion suggestion) {
    final typeKey = suggestion.type.name;
    final categoryEnabled = categoryToggles[typeKey] ?? true;
    if (!categoryEnabled) return false;
    if (!alertsOnly) return true;
    return suggestion.type == SuggestionType.preventiveTrendAlert ||
        suggestion.type == SuggestionType.clinicalWatch;
  }

  int _goalDrivenKcalDelta({
    required int conservative,
    required int balanced,
    required int proactive,
  }) {
    return switch (interventionLevel) {
      'conservative' => conservative,
      'proactive' => proactive,
      _ => balanced,
    };
  }

  double _portionShiftBase() {
    return switch (interventionLevel) {
      'conservative' => 0.06,
      'proactive' => 0.10,
      _ => 0.08,
    };
  }

  double _portionShiftMax() {
    return switch (interventionLevel) {
      'conservative' => 0.12,
      'proactive' => 0.20,
      _ => 0.16,
    };
  }
}

class _MealSummary {
  const _MealSummary({
    required this.totalMeals,
    required this.completedMeals,
    required this.delayedMeals,
    required this.refusedMeals,
    required this.adherenceRatio,
    required this.mealsPerDayEstimate,
    required this.slotStats,
  });

  final int totalMeals;
  final int completedMeals;
  final int delayedMeals;
  final int refusedMeals;
  final double adherenceRatio;
  final int mealsPerDayEstimate;
  final Map<String, _MealSlotStats> slotStats;
}

class _MealSlotAccumulator {
  _MealSlotAccumulator({required this.slotId, required this.timeLabel});

  final String slotId;
  final String timeLabel;
  int total = 0;
  int completed = 0;
  int delayed = 0;
  int refused = 0;

  _MealSlotStats toStats() {
    return _MealSlotStats(
      slotId: slotId,
      timeLabel: timeLabel,
      total: total,
      completed: completed,
      delayed: delayed,
      refused: refused,
    );
  }
}

class _MealSlotStats {
  const _MealSlotStats({
    required this.slotId,
    required this.timeLabel,
    required this.total,
    required this.completed,
    required this.delayed,
    required this.refused,
  });

  final String slotId;
  final String timeLabel;
  final int total;
  final int completed;
  final int delayed;
  final int refused;

  double get adherence => total == 0 ? 0.0 : completed / total;
}

class _ClinicalSummary {
  const _ClinicalSummary({
    required this.reducedAppetiteCount,
    required this.poorAppetiteCount,
    required this.frequentVomitCount,
    required this.diarrheaCount,
    required this.alertTriggeredCount,
    required this.instabilitySignals,
  });

  final int reducedAppetiteCount;
  final int poorAppetiteCount;
  final int frequentVomitCount;
  final int diarrheaCount;
  final int alertTriggeredCount;
  final int instabilitySignals;
}

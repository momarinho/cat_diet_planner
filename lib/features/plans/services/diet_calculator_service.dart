import 'dart:math' as math;

import 'package:cat_diet_planner/core/errors/localized_exception.dart';

class DietCalculatorService {
  static const double _minWeightKg = 0.5;
  static const double _maxWeightKg = 20;
  static const int _minAgeMonths = 1;
  static const int _maxAgeMonths = 240;

  static void validateInputs({
    required double weightKg,
    required int ageMonths,
    required double kcalPer100g,
    required int mealsPerDay,
  }) {
    if (weightKg < _minWeightKg || weightKg > _maxWeightKg) {
      throw LocalizedException(
        'dietWeightRange',
        args: {'min': '$_minWeightKg', 'max': '$_maxWeightKg'},
      );
    }
    if (ageMonths < _minAgeMonths || ageMonths > _maxAgeMonths) {
      throw LocalizedException(
        'dietAgeRange',
        args: {'min': '$_minAgeMonths', 'max': '$_maxAgeMonths'},
      );
    }
    if (kcalPer100g <= 0) {
      throw const LocalizedException('dietFoodCaloriesPositive');
    }
    if (mealsPerDay < 3 || mealsPerDay > 6) {
      throw const LocalizedException(
        'dietMealsRange',
        args: {'min': '3', 'max': '6'},
      );
    }
  }

  static double calculateRer(double weightKg) {
    if (weightKg <= 0) {
      throw const LocalizedException('dietWeightPositive');
    }
    return 70 * math.pow(weightKg, 0.75).toDouble();
  }

  static double calculateMer({
    required double weightKg,
    required int ageMonths,
    required bool neutered,
    required String activityLevel,
    required String goal,
  }) {
    final rer = calculateRer(weightKg);
    final baseFactor = _activityFactor(
      ageMonths: ageMonths,
      neutered: neutered,
      activityLevel: activityLevel,
    );
    final goalFactor = _goalFactor(goal);
    return rer * baseFactor * goalFactor;
  }

  static double calculateDailyPortionGrams({
    required double targetKcal,
    required double kcalPer100g,
  }) {
    return (targetKcal * 100) / kcalPer100g;
  }

  static double calculatePortionPerMealGrams({
    required double portionPerDayGrams,
    required int mealsPerDay,
  }) {
    if (mealsPerDay <= 0) {
      throw const LocalizedException('dietMealsPositive');
    }
    return portionPerDayGrams / mealsPerDay;
  }

  static String healthAlertForWeight(double weightKg) {
    if (weightKg < 2.5) return 'Underweight range. Review intake and health.';
    if (weightKg > 6.5) return 'High weight range. Monitor calories closely.';
    return 'Weight is within a common healthy range.';
  }

  static double _activityFactor({
    required int ageMonths,
    required bool neutered,
    required String activityLevel,
  }) {
    if (ageMonths <= 4) return 2.5;
    if (ageMonths <= 12) return 2.0;

    switch (activityLevel) {
      case 'active':
        return neutered ? 1.4 : 1.6;
      case 'moderate':
        return neutered ? 1.2 : 1.4;
      case 'sedentary':
      default:
        return neutered ? 1.1 : 1.2;
    }
  }

  static double _goalFactor(String goal) {
    switch (goal) {
      case 'loss':
        return 0.8;
      case 'gain':
        return 1.15;
      case 'kitten_growth':
        return 1.2;
      case 'senior_support':
        return 0.95;
      case 'recovery':
        return 1.2;
      case 'post_surgery':
        return 1.1;
      case 'maintenance':
      default:
        return 1.0;
    }
  }

  /// Smarter suggestion for daily kcal tailored to goal, current weight and optional
  /// indicators such as `idealWeight` and `bcs` (body condition score).
  ///
  /// This function builds on the existing MER calculation but adds small, conservative
  /// nudges when an `idealWeight` is provided or when a `bcs` suggests lean/overweight status.
  /// It also applies gentle goal-based adjustments and clamps results to a sensible range.
  static double calculateSuggestedKcal({
    required double weightKg,
    required int ageMonths,
    required bool neutered,
    required String activityLevel,
    required String goal,
    double? idealWeight,
    int? bcs,
  }) {
    // Base MER from current parameters.
    final baseMer = calculateMer(
      weightKg: weightKg,
      ageMonths: ageMonths,
      neutered: neutered,
      activityLevel: activityLevel,
      goal: goal,
    );

    double adjusted = baseMer;

    // If an ideal weight is provided, nudge calories proportionally to the required change.
    // Positive diffRatio means current > ideal (over target) -> conservative reduction.
    // Negative diffRatio means current < ideal (under target) -> conservative increase.
    if (idealWeight != null && idealWeight > 0) {
      final diffRatio = (weightKg - idealWeight) / idealWeight;
      if (diffRatio > 0) {
        // Reduce up to 20% depending on how far above ideal the cat is.
        adjusted = adjusted * (1 - math.min(diffRatio * 0.5, 0.20));
      } else if (diffRatio < 0) {
        // Increase up to 15% depending on how far below ideal.
        adjusted = adjusted * (1 + math.min(-diffRatio * 0.4, 0.15));
      }
    }

    // Use BCS (1-9) as a small nudge:
    // - If BCS < 4 (lean), add ~5% per point below 4 (capped).
    // - If BCS > 6 (overweight), subtract ~5% per point above 6 (capped).
    if (bcs != null) {
      if (bcs < 4) {
        final nudge = (4 - bcs) * 0.05;
        adjusted *= (1 + math.min(nudge, 0.20));
      } else if (bcs > 6) {
        final nudge = (bcs - 6) * 0.05;
        adjusted *= (1 - math.min(nudge, 0.25));
      }
    }

    // Additional conservative goal-based nudges (these layer on top of _goalFactor).
    switch (goal) {
      case 'loss':
        adjusted *= 0.92; // slightly more conservative reduction
        break;
      case 'gain':
        adjusted *= 1.08; // gentle increase
        break;
      case 'kitten_growth':
        adjusted *= 1.15;
        break;
      case 'recovery':
        adjusted *= 1.10;
        break;
      default:
        break;
    }

    // Bound the suggestion to a reasonable range relative to the base MER to avoid extreme values.
    final lower = baseMer * 0.6;
    final upper = baseMer * 1.3;
    adjusted = math.max(lower, math.min(upper, adjusted));

    // Return with a single decimal for nicer presentation in the UI.
    return (adjusted * 10).round() / 10.0;
  }

  /// Backwards-compatible alias for older callers.
  ///
  /// The project previously used `suggestTargetKcal(...)`. Keep that API surface
  /// by forwarding to the newer `calculateSuggestedKcal(...)` implementation.
  static double suggestTargetKcal({
    required double weightKg,
    double? idealWeightKg,
    required int ageMonths,
    required bool neutered,
    required String activityLevel,
    required String goal,
    int? bcs,
  }) {
    return calculateSuggestedKcal(
      weightKg: weightKg,
      idealWeight: idealWeightKg,
      ageMonths: ageMonths,
      neutered: neutered,
      activityLevel: activityLevel,
      goal: goal,
      bcs: bcs,
    );
  }
}

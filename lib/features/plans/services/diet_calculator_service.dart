import 'dart:math' as math;

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
      throw ArgumentError(
        'Weight must be between $_minWeightKg and $_maxWeightKg kg.',
      );
    }
    if (ageMonths < _minAgeMonths || ageMonths > _maxAgeMonths) {
      throw ArgumentError(
        'Age must be between $_minAgeMonths and $_maxAgeMonths months.',
      );
    }
    if (kcalPer100g <= 0) {
      throw ArgumentError('Food calories must be greater than zero.');
    }
    if (mealsPerDay < 3 || mealsPerDay > 6) {
      throw ArgumentError('Meals per day must be between 3 and 6.');
    }
  }

  static double calculateRer(double weightKg) {
    if (weightKg <= 0) {
      throw ArgumentError('Weight must be greater than zero.');
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
      throw ArgumentError('Meals per day must be greater than zero.');
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
      case 'maintenance':
      default:
        return 1.0;
    }
  }
}

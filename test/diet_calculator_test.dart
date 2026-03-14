import 'package:flutter_test/flutter_test.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';

void main() {
  group('DietCalculatorService.suggestTargetKcal', () {
    test('maintenance should match calculateMer for maintenance goal', () {
      final weightKg = 3.8;
      final ageMonths = 36;
      final neutered = true;
      final activityLevel = 'moderate';

      final baseMer = DietCalculatorService.calculateMer(
        weightKg: weightKg,
        ageMonths: ageMonths,
        neutered: neutered,
        activityLevel: activityLevel,
        goal: 'maintenance',
      );

      final suggested = DietCalculatorService.suggestTargetKcal(
        weightKg: weightKg,
        idealWeightKg: null,
        ageMonths: ageMonths,
        neutered: neutered,
        activityLevel: activityLevel,
        goal: 'maintenance',
        bcs: null,
      );

      // Should be effectively equal (small numerical differences may occur).
      expect(suggested, closeTo(baseMer, 0.5));
    });

    test('loss with idealWeight reduces target compared to current MER', () {
      final weightKg = 6.0;
      final idealKg = 4.5;
      final ageMonths = 48;
      final neutered = true;
      final activityLevel = 'moderate';

      final baseMer = DietCalculatorService.calculateMer(
        weightKg: weightKg,
        ageMonths: ageMonths,
        neutered: neutered,
        activityLevel: activityLevel,
        goal: 'maintenance',
      );

      final suggested = DietCalculatorService.suggestTargetKcal(
        weightKg: weightKg,
        idealWeightKg: idealKg,
        ageMonths: ageMonths,
        neutered: neutered,
        activityLevel: activityLevel,
        goal: 'loss',
        bcs: null,
      );

      expect(suggested, lessThan(baseMer));
      // Ensure not recommending dangerously low calories
      final minAllowed = DietCalculatorService.calculateRer(weightKg) * 0.70;
      expect(suggested, greaterThanOrEqualTo(minAllowed));
    });

    test(
      'gain without idealWeight increases target compared to current MER',
      () {
        final weightKg = 3.2;
        final ageMonths = 12;
        final neutered = false;
        final activityLevel = 'moderate';

        final baseMer = DietCalculatorService.calculateMer(
          weightKg: weightKg,
          ageMonths: ageMonths,
          neutered: neutered,
          activityLevel: activityLevel,
          goal: 'maintenance',
        );

        final suggested = DietCalculatorService.suggestTargetKcal(
          weightKg: weightKg,
          idealWeightKg: null,
          ageMonths: ageMonths,
          neutered: neutered,
          activityLevel: activityLevel,
          goal: 'gain',
          bcs: null,
        );

        expect(suggested, greaterThan(baseMer));
      },
    );

    test(
      'BCS affects loss aggressiveness (higher BCS -> slightly lower kcal)',
      () {
        final weightKg = 5.5;
        final ageMonths = 36;
        final neutered = true;
        final activityLevel = 'sedentary';

        final suggestedNoBcs = DietCalculatorService.suggestTargetKcal(
          weightKg: weightKg,
          idealWeightKg: 5.0,
          ageMonths: ageMonths,
          neutered: neutered,
          activityLevel: activityLevel,
          goal: 'loss',
          bcs: null,
        );

        final suggestedHighBcs = DietCalculatorService.suggestTargetKcal(
          weightKg: weightKg,
          idealWeightKg: 5.0,
          ageMonths: ageMonths,
          neutered: neutered,
          activityLevel: activityLevel,
          goal: 'loss',
          bcs: 7,
        );

        // With higher BCS (>=7) the function applies a further small reduction
        expect(suggestedHighBcs, lessThan(suggestedNoBcs));
      },
    );

    test('Suggestion respects safety clamps for very low weight', () {
      final weightKg = 0.6; // small but allowed by validateInputs (>=0.5)
      final ageMonths = 6;
      final neutered = false;
      final activityLevel = 'moderate';

      final suggested = DietCalculatorService.suggestTargetKcal(
        weightKg: weightKg,
        idealWeightKg: null,
        ageMonths: ageMonths,
        neutered: neutered,
        activityLevel: activityLevel,
        goal: 'loss',
        bcs: null,
      );

      final minAllowed = DietCalculatorService.calculateRer(weightKg) * 0.70;
      final maxAllowed = DietCalculatorService.calculateRer(weightKg) * 2.5;

      expect(suggested, greaterThanOrEqualTo(minAllowed));
      expect(suggested, lessThanOrEqualTo(maxAllowed));
    });
  });
}

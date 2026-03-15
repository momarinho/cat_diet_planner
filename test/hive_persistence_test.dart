import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/features/cat_profile/repositories/cat_profile_repository.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:cat_diet_planner/features/settings/services/app_settings_service.dart';
import 'package:cat_diet_planner/features/suggestions/models/plan_change_audit_entry.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';
import 'package:cat_diet_planner/features/suggestions/services/plan_change_audit_service.dart';
import 'package:cat_diet_planner/features/suggestions/services/plan_adjustment_service.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_decision_service.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_impact_history_service.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_persistence_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'support/hive_test_helper.dart';

void main() {
  setUp(() async {
    await HiveTestHelper.init();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  test('cat profile repository persists and deletes Hive data', () async {
    final repository = CatProfileRepository();
    final cat = CatProfile(
      id: 'cat-42',
      name: 'Lilo',
      weight: 3.8,
      age: 18,
      neutered: true,
      activityLevel: 'active',
      goal: 'gain',
      createdAt: DateTime(2026, 3, 1),
      // Explicitly provide some of the new clinical/routine fields to
      // ensure constructor handling and defaults are exercised in tests.
      idealWeight: 3.9,
      bcs: 5,
      sex: 'female',
      breed: 'Mixed',
      birthDate: DateTime(2023, 3, 1),
      customActivityLevel: null,
      clinicalConditions: const [],
      allergies: const [],
      dietaryPreferences: const [],
      vetNotes: null,
    );

    await repository.save(cat);
    final all = repository.getAll();

    expect(all, hasLength(1));
    expect(all.single.name, 'Lilo');

    await repository.delete(cat.id);

    expect(repository.getAll(), isEmpty);
    expect(HiveService.catsBox.isEmpty, isTrue);
  });

  test('app settings service persists reminder preferences in Hive', () async {
    final service = AppSettingsService();
    final settings = AppSettings.defaults().copyWith(
      mealReminders: false,
      languageCode: 'pt',
      reminderTimes: ['08:00', '18:00'],
      suggestionInterventionLevel: 'proactive',
      suggestionCategoryToggles: {
        'kcalAdjustment': true,
        'scheduleAdjustment': false,
        'portionSplitAdjustment': true,
        'preventiveTrendAlert': true,
        'clinicalWatch': true,
      },
      suggestionDailyLimit: 2,
      suggestionAlertsOnly: true,
      suggestionAutoApply: false,
    );

    await service.save(settings);
    final restored = service.read();

    expect(restored.mealReminders, isFalse);
    expect(restored.languageCode, 'pt');
    expect(restored.reminderTimes, ['08:00', '18:00']);
    expect(restored.suggestionInterventionLevel, 'proactive');
    expect(restored.suggestionCategoryToggles['scheduleAdjustment'], isFalse);
    expect(restored.suggestionDailyLimit, 2);
    expect(restored.suggestionAlertsOnly, isTrue);
    expect(restored.suggestionAutoApply, isFalse);
  });

  test('plan change audit trail persists who, when and what changed', () async {
    final service = PlanChangeAuditService();
    final acceptedAt = DateTime(2026, 3, 15, 9, 30);

    await service.append(
      PlanChangeAuditEntry(
        suggestionId: 'kcal-cat-42',
        catId: 'cat-42',
        catName: 'Lilo',
        acceptedBy: 'Mateus',
        acceptedAt: acceptedAt,
        changeSummary: const [
          'Target kcal/day: 220 -> 205 (-7%)',
          'Daily portion: 68.0 g -> 63.5 g',
        ],
      ),
    );

    final entries = service.readAll();

    expect(entries, hasLength(1));
    expect(entries.single.acceptedBy, 'Mateus');
    expect(entries.single.acceptedAt, acceptedAt);
    expect(entries.single.changeSummary, isNotEmpty);
  });

  test(
    'suggestion persistence saves generated suggestions and decisions',
    () async {
      final suggestionService = SuggestionPersistenceService();
      final decisionService = SuggestionDecisionService();
      final suggestion = SmartSuggestion(
        id: 'schedule-cat-42-meal-1',
        type: SuggestionType.scheduleAdjustment,
        priority: SuggestionPriority.medium,
        title: 'Adjust feeding time window',
        summary: 'Morning slot is delayed.',
        recommendedAction: 'Shift breakfast by +15 min.',
        confidenceScore: 0.82,
        reasonCodes: const [SuggestionReasonCodes.adherenceLow],
        metadata: const {'targetSlotId': 'meal_1', 'shiftMinutes': 15},
        generatedAt: DateTime(2026, 3, 15, 8, 0),
      );

      await suggestionService.saveGeneratedForCat(
        catId: 'cat-42',
        suggestions: [suggestion],
      );
      await decisionService.save(const {
        'schedule-cat-42-meal-1': SuggestionDecision.deferred,
      });

      final storedSuggestions = suggestionService.readGeneratedForCat('cat-42');
      final storedDecisions = decisionService.read();

      expect(storedSuggestions, hasLength(1));
      expect(storedSuggestions.single.id, suggestion.id);
      expect(
        storedDecisions['schedule-cat-42-meal-1'],
        SuggestionDecision.deferred,
      );
    },
  );

  test(
    'plan adjustment history persists before/after and supports revert',
    () async {
      final repository = CatProfileRepository();
      final cat = CatProfile(
        id: 'cat-impact',
        name: 'Nina',
        weight: 4.2,
        age: 36,
        neutered: true,
        activityLevel: 'moderate',
        goal: 'maintenance',
        createdAt: DateTime(2026, 3, 1),
      );
      await repository.save(cat);

      final initialPlan = DietPlan(
        catId: cat.id,
        foodKey: 'food-1',
        foodName: 'Dry Food',
        targetKcalPerDay: 220,
        portionGramsPerDay: 70,
        mealsPerDay: 4,
        portionGramsPerMeal: 17.5,
        createdAt: DateTime(2026, 3, 1),
        goal: cat.goal,
        mealTimes: const ['07:00 AM', '12:00 PM', '05:00 PM', '09:00 PM'],
        mealLabels: const ['Breakfast', 'Lunch', 'Dinner', 'Late meal'],
        mealPortionGrams: const [17.5, 17.5, 17.5, 17.5],
        startDate: DateTime(2026, 3, 1),
        planId: 'plan-impact',
      );
      await HiveService.dietPlansBox.put(initialPlan.planId, initialPlan);
      cat.activePlanId = initialPlan.planId;
      await cat.save();

      final container = ProviderContainer();
      addTearDown(container.dispose);
      final service = container.read(planAdjustmentServiceProvider);
      final suggestion = SmartSuggestion(
        id: 'kcal-cat-impact',
        type: SuggestionType.kcalAdjustment,
        priority: SuggestionPriority.medium,
        title: 'Adjust calories',
        summary: 'Trend suggests lowering kcal.',
        recommendedAction: 'Set target to 205 kcal/day.',
        confidenceScore: 0.88,
        reasonCodes: const [SuggestionReasonCodes.weightTrendUp],
        metadata: const {'suggestedKcal': 205.0, 'changePercent': -7},
        generatedAt: DateTime(2026, 3, 15, 10, 0),
      );

      final applied = await service.applySuggestion(
        cat: cat,
        suggestion: suggestion,
        acceptedBy: 'Mateus',
      );
      final appliedPlan = HiveService.dietPlansBox.get('plan-impact');
      final historyService = SuggestionImpactHistoryService();
      final historyEntries = historyService.readAll();

      expect(applied.changed, isTrue);
      expect(appliedPlan?.targetKcalPerDay, 205);
      expect(historyEntries, hasLength(1));
      expect(historyEntries.single.beforePlan.targetKcalPerDay, 220);
      expect(historyEntries.single.afterPlan.targetKcalPerDay, 205);

      final reverted = await service.revertLastSuggestedChange(
        revertedBy: 'Mateus',
      );
      final revertedPlan = HiveService.dietPlansBox.get('plan-impact');
      final updatedHistoryEntries = historyService.readAll();

      expect(reverted.changed, isTrue);
      expect(revertedPlan?.targetKcalPerDay, 220);
      expect(updatedHistoryEntries.single.isReverted, isTrue);
    },
  );
}

import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_profile/repositories/cat_profile_repository.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:cat_diet_planner/features/settings/services/app_settings_service.dart';
import 'package:flutter_test/flutter_test.dart';

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
    const settings = AppSettings(
      mealReminders: false,
      languageCode: 'pt',
      reminderTimes: ['08:00', '18:00'],
    );

    await service.save(settings);
    final restored = service.read();

    expect(restored.mealReminders, isFalse);
    expect(restored.languageCode, 'pt');
    expect(restored.reminderTimes, ['08:00', '18:00']);
  });
}

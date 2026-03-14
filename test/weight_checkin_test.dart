import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';

void main() {
  setUp(() async {
    await HiveTestHelper.init();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  test('weight check-in persists record and updates cat history', () async {
    final cat = CatProfile(
      id: 'cat-1',
      name: 'Nina',
      weight: 4.2,
      age: 24,
      neutered: true,
      activityLevel: 'moderate',
      goal: 'maintenance',
      createdAt: DateTime(2026, 1, 1),
      // new optional clinical/routine fields (use defaults where appropriate)
      idealWeight: 4.0,
      bcs: 5,
      sex: 'female',
      breed: 'Domestic Shorthair',
      birthDate: DateTime(2024, 1, 1),
      customActivityLevel: null,
      clinicalConditions: const [],
      allergies: const [],
      dietaryPreferences: const [],
      vetNotes: null,
    );
    await HiveService.catsBox.put(cat.id, cat);

    final record = WeightRecord(
      date: DateTime(2026, 3, 13, 10),
      weight: 4.4,
      notes: 'Energetic',
    );

    await HiveService.weightsBox.add(record);

    final storedCat = HiveService.catsBox.get(cat.id)!;
    storedCat.weight = record.weight;
    storedCat.weightHistory = [...storedCat.weightHistory, record]
      ..sort((a, b) => a.date.compareTo(b.date));
    await storedCat.save();

    expect(HiveService.weightsBox.length, 1);
    expect(HiveService.weightsBox.values.single.notes, 'Energetic');

    final updatedCat = HiveService.catsBox.get(cat.id)!;
    expect(updatedCat.weight, 4.4);
    expect(updatedCat.weightHistory.length, 1);
    expect(updatedCat.weightHistory.single.notes, 'Energetic');
  });
}

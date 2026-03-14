import 'package:hive/hive.dart';

part 'diet_plan.g.dart';

/// DietPlan represents a saved feeding plan for a cat. Fields up to index 12
/// are preserved to retain backward compatibility with existing persisted data.
/// New fields are appended with higher Hive field IDs.
@HiveType(typeId: 3)
class DietPlan extends HiveObject {
  @HiveField(0)
  final String catId;

  // Backwards-compatible single food key (kept to read older records)
  @HiveField(1)
  final dynamic foodKey;

  // Backwards-compatible single food name
  @HiveField(2)
  final String foodName;

  @HiveField(3)
  final double targetKcalPerDay;

  @HiveField(4)
  final double portionGramsPerDay;

  @HiveField(5)
  final int mealsPerDay;

  @HiveField(6)
  final double portionGramsPerMeal;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String goal;

  @HiveField(9)
  final List<String> mealTimes;

  @HiveField(10)
  final List<String> mealLabels;

  @HiveField(11)
  final List<double> mealPortionGrams;

  @HiveField(12)
  final DateTime startDate;

  // --- NEW FIELDS (appended) ---

  /// Optional plan identifier to allow storing multiple plans per cat.
  @HiveField(13)
  final String? planId;

  /// Support multiple foods per plan. Kept separate from `foodKey` for backward compatibility.
  @HiveField(14)
  final List<dynamic> foodKeys;

  @HiveField(15)
  final List<String> foodNames;

  /// Unit used to present portions (e.g. 'g','can','sachet','scoop')
  @HiveField(16)
  final String portionUnit;

  /// Number of grams represented by a single `portionUnit` (defaults to 1.0 for 'g').
  @HiveField(17)
  final double portionUnitGrams;

  /// Optional per-weekday overrides. Key is weekday (1 = Monday .. 7 = Sunday).
  /// Each value can include a map with keys such as:
  /// { 'targetKcalPerDay': double, 'mealsPerDay': int, 'mealTimes': List<String>, 'mealPortionGrams': List<double> }
  @HiveField(18)
  final Map<int, Map<dynamic, dynamic>> dailyOverrides;

  /// Free-form operational notes for the plan (logistics, feeding instructions, etc).
  @HiveField(19)
  final String? operationalNotes;

  DietPlan({
    required this.catId,
    required this.foodKey,
    required this.foodName,
    required this.targetKcalPerDay,
    required this.portionGramsPerDay,
    required this.mealsPerDay,
    required this.portionGramsPerMeal,
    required this.createdAt,
    required this.goal,
    required this.mealTimes,
    required this.mealLabels,
    required this.mealPortionGrams,
    required this.startDate,
    // new optional fields with safe defaults
    this.planId,
    this.foodKeys = const [],
    this.foodNames = const [],
    this.portionUnit = 'g',
    this.portionUnitGrams = 1.0,
    this.dailyOverrides = const {},
    this.operationalNotes,
  });
}

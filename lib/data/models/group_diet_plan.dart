import 'package:hive/hive.dart';

part 'group_diet_plan.g.dart';

@HiveType(typeId: 5)
class GroupDietPlan extends HiveObject {
  @HiveField(0)
  final String groupId;

  @HiveField(1)
  final dynamic foodKey;

  @HiveField(2)
  final String foodName;

  @HiveField(3)
  final int catCount;

  @HiveField(4)
  final double targetKcalPerCatPerDay;

  @HiveField(5)
  final double targetKcalPerGroupPerDay;

  @HiveField(6)
  final double portionGramsPerCatPerDay;

  @HiveField(7)
  final double portionGramsPerGroupPerDay;

  @HiveField(8)
  final int mealsPerDay;

  @HiveField(9)
  final double portionGramsPerGroupPerMeal;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final List<String> mealTimes;

  @HiveField(12)
  final List<String> mealLabels;

  @HiveField(13)
  final List<double> mealPortionGrams;

  @HiveField(14)
  final DateTime startDate;

  // --- Appended fields for extended group plan behavior ---
  // These are appended to preserve Hive compatibility with existing records.
  @HiveField(15)
  final double? manualTargetKcal; // optional manual kcal target per cat

  @HiveField(16)
  final List<dynamic> foodKeys; // support multiple foods in a group plan

  @HiveField(17)
  final String portionUnit; // 'g', 'can', 'sachet', 'scoop', etc.

  @HiveField(18)
  final double portionUnitGrams; // grams represented by a single portionUnit

  @HiveField(19)
  final String? operationalNotes; // operational / staff notes for the plan

  @HiveField(20)
  final Map<String, double> perCatShareWeights; // uneven distribution by cat

  @HiveField(21)
  final Map<dynamic, double> foodSplitPercentByKcal; // kcal-based split for mixed feeding

  GroupDietPlan({
    required this.groupId,
    required this.foodKey,
    required this.foodName,
    required this.catCount,
    required this.targetKcalPerCatPerDay,
    required this.targetKcalPerGroupPerDay,
    required this.portionGramsPerCatPerDay,
    required this.portionGramsPerGroupPerDay,
    required this.mealsPerDay,
    required this.portionGramsPerGroupPerMeal,
    required this.createdAt,
    required this.mealTimes,
    required this.mealLabels,
    required this.mealPortionGrams,
    required this.startDate,
    // new optional fields with safe defaults
    this.manualTargetKcal,
    this.foodKeys = const [],
    this.portionUnit = 'g',
    this.portionUnitGrams = 1.0,
    this.operationalNotes,
    this.perCatShareWeights = const {},
    this.foodSplitPercentByKcal = const {},
  });
}

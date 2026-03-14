import 'package:hive/hive.dart';
import 'weight_record.dart';

part 'cat_profile.g.dart';

const Map<String, String> kCatGoalLabels = {
  'maintenance': 'Maintenance',
  'loss': 'Weight loss',
  'gain': 'Weight gain',
  'kitten_growth': 'Kitten growth',
  'senior_support': 'Senior support',
  'recovery': 'Recovery',
  'post_surgery': 'Post-surgery',
};

const Map<String, String> kCatActivityLabels = {
  'sedentary': 'Sedentary',
  'moderate': 'Moderate',
  'active': 'Active',
};

String catGoalLabel(String goal) => kCatGoalLabels[goal] ?? goal;

String catActivityLabel(String level) => kCatActivityLabels[level] ?? level;

@HiveType(typeId: 0)
class CatProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double weight; // kg

  @HiveField(3)
  int age; // months

  @HiveField(4)
  bool neutered;

  @HiveField(5)
  String activityLevel; // 'sedentary', 'moderate', 'active'

  @HiveField(6)
  String goal; // 'maintenance', 'loss', 'gain'

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  List<WeightRecord> weightHistory;

  @HiveField(9)
  String? photoPath;

  @HiveField(10)
  String? photoBase64;

  @HiveField(11)
  int preferredMealsPerDay;

  @HiveField(12)
  double? manualTargetKcal;

  @HiveField(13)
  String? notes;

  // Additional clinical and routine fields (appended to preserve Hive compatibility)
  @HiveField(14)
  double? idealWeight; // kg

  @HiveField(15)
  int? bcs; // Body Condition Score (1-9)

  @HiveField(16)
  String sex; // 'male' | 'female' | 'unknown'

  @HiveField(17)
  String? breed;

  @HiveField(18)
  DateTime? birthDate;

  @HiveField(19)
  String? customActivityLevel;

  @HiveField(20)
  List<String> clinicalConditions; // e.g. ['diabetes', 'ckd']

  @HiveField(21)
  List<String> allergies; // e.g. ['chicken', 'beef']

  @HiveField(22)
  List<String> dietaryPreferences; // e.g. ['grain_free', 'low_fat']

  @HiveField(23)
  String? vetNotes; // veterinary notes separate from free-form notes

  @HiveField(24)
  String? activePlanId; // currently selected active individual diet plan

  CatProfile({
    required this.id,
    required this.name,
    required this.weight,
    required this.age,
    this.neutered = false,
    this.activityLevel = 'sedentary',
    this.goal = 'maintenance',
    required this.createdAt,
    this.weightHistory = const [],
    this.photoPath,
    this.photoBase64,
    this.preferredMealsPerDay = 4,
    this.manualTargetKcal,
    this.notes,
    // new fields with reasonable defaults
    this.idealWeight,
    this.bcs,
    this.sex = 'unknown',
    this.breed,
    this.birthDate,
    this.customActivityLevel,
    this.clinicalConditions = const [],
    this.allergies = const [],
    this.dietaryPreferences = const [],
    this.vetNotes,
    this.activePlanId,
  });
}

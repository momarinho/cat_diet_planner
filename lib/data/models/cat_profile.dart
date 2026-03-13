import 'package:hive/hive.dart';
import 'weight_record.dart';

part 'cat_profile.g.dart';

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
  });
}

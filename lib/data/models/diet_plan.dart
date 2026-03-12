import 'package:hive/hive.dart';

part 'diet_plan.g.dart';

@HiveType(typeId: 3)
class DietPlan extends HiveObject {
  @HiveField(0)
  final String catId;

  @HiveField(1)
  final dynamic foodKey;

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
  });
}

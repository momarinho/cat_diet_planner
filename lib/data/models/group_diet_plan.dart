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
  });
}

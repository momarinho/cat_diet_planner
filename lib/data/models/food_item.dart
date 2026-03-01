import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 1)
class FoodItem extends HiveObject {
  @HiveField(0)
  final String? barcode;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? brand;

  @HiveField(3)
  final double kcalPer100g;

  @HiveField(4)
  final double? protein; // percentage

  @HiveField(5)
  final double? fat; // percentage

  FoodItem({
    this.barcode,
    required this.name,
    this.brand,
    required this.kcalPer100g,
    this.protein,
    this.fat,
  });
}

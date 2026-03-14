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

  @HiveField(6)
  final String? category; // dry, wet, natural, snack, supplement

  @HiveField(7)
  final String? manufacturer;

  @HiveField(8)
  final String? productLine;

  @HiveField(9)
  final String? flavor;

  @HiveField(10)
  final String? texture;

  @HiveField(11)
  final String? packageSize;

  @HiveField(12)
  final String? servingUnit; // can, sachet, cup, spoon, etc.

  @HiveField(13)
  final double? fiber; // percentage

  @HiveField(14)
  final double? moisture; // percentage

  @HiveField(15)
  final double? carbohydrate; // percentage

  @HiveField(16)
  final double? sodium; // mg/100g

  @HiveField(17)
  final String? palatabilityNotes;

  @HiveField(18)
  final List<String> userTags;

  FoodItem({
    this.barcode,
    required this.name,
    this.brand,
    required this.kcalPer100g,
    this.protein,
    this.fat,
    this.category,
    this.manufacturer,
    this.productLine,
    this.flavor,
    this.texture,
    this.packageSize,
    this.servingUnit,
    this.fiber,
    this.moisture,
    this.carbohydrate,
    this.sodium,
    this.palatabilityNotes,
    this.userTags = const [],
  });
}

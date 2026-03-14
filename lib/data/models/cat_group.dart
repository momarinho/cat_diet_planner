import 'package:hive/hive.dart';

part 'cat_group.g.dart';

@HiveType(typeId: 4)
class CatGroup extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int catCount;

  @HiveField(3)
  String? description;

  @HiveField(4)
  int colorValue;

  @HiveField(5)
  DateTime createdAt;

  CatGroup({
    required this.id,
    required this.name,
    required this.catCount,
    this.description,
    required this.colorValue,
    required this.createdAt,
  });
}

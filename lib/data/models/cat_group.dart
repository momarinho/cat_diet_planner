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

  @HiveField(6)
  List<String> catIds; // linked real cat profiles in the group

  @HiveField(7)
  String? subgroup; // operational subgroup/tag

  @HiveField(8)
  String? category; // operational category

  @HiveField(9)
  Map<String, double> feedingShareByCat; // per-cat distribution weight

  @HiveField(10)
  String? enclosure; // room/kennel/enclosure identifier

  @HiveField(11)
  String? environment; // environment condition (indoor/outdoor/etc.)

  @HiveField(12)
  String? shiftMorningNotes;

  @HiveField(13)
  String? shiftAfternoonNotes;

  @HiveField(14)
  String? shiftNightNotes;

  @HiveField(15)
  int? secondaryColorValue;

  @HiveField(16)
  String? iconName;

  @HiveField(17)
  String? badgeEmoji;

  CatGroup({
    required this.id,
    required this.name,
    required this.catCount,
    this.description,
    required this.colorValue,
    required this.createdAt,
    this.catIds = const [],
    this.subgroup,
    this.category,
    this.feedingShareByCat = const {},
    this.enclosure,
    this.environment,
    this.shiftMorningNotes,
    this.shiftAfternoonNotes,
    this.shiftNightNotes,
    this.secondaryColorValue,
    this.iconName,
    this.badgeEmoji,
  });
}

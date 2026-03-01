import 'package:hive/hive.dart';

part 'weight_record.g.dart';

@HiveType(typeId: 2)
class WeightRecord extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final String? notes;

  WeightRecord({required this.date, required this.weight, this.notes});
}

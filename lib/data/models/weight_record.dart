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

  @HiveField(3)
  final String? weightContext; // fasting, after_meal, different_scale, etc.

  @HiveField(4)
  final String? appetite; // normal, reduced, high, poor

  @HiveField(5)
  final String? stool; // normal, soft, hard, diarrhea, none

  @HiveField(6)
  final String? vomit; // none, occasional, frequent

  @HiveField(7)
  final String? energy; // low, normal, high

  @HiveField(8)
  final String? clinicalAssessment;

  @HiveField(9)
  final String? clinicalPlan;

  @HiveField(10)
  final String? clinicalAlertLevel; // none, watch, moderate, high

  @HiveField(11)
  final bool alertTriggered;

  WeightRecord({
    required this.date,
    required this.weight,
    this.notes,
    this.weightContext,
    this.appetite,
    this.stool,
    this.vomit,
    this.energy,
    this.clinicalAssessment,
    this.clinicalPlan,
    this.clinicalAlertLevel,
    this.alertTriggered = false,
  });
}

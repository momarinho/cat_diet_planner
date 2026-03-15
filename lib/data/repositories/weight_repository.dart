import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WeightRepository {
  ValueListenable<Box<WeightRecord>> weightsListenable() {
    return HiveService.weightsBox.listenable();
  }

  Future<void> addRecord(WeightRecord record) async {
    await HiveService.weightsBox.add(record);
  }

  List<WeightRecord> recordsForCat(
    String catId, {
    List<WeightRecord> fallbackHistory = const [],
    bool newestFirst = true,
  }) {
    final fromBox = HiveService.weightsBox.values
        .where((record) => record.catId == catId)
        .toList();
    final source = fromBox.isNotEmpty ? fromBox : [...fallbackHistory];
    source.sort(
      (a, b) =>
          newestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date),
    );
    return source;
  }

  List<WeightRecord> recordsForCatFromBox(
    Box<WeightRecord> box,
    String catId, {
    List<WeightRecord> fallbackHistory = const [],
    bool newestFirst = true,
  }) {
    final fromBox = box.values
        .where((record) => record.catId == catId)
        .toList();
    final source = fromBox.isNotEmpty ? fromBox : [...fallbackHistory];
    source.sort(
      (a, b) =>
          newestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date),
    );
    return source;
  }
}

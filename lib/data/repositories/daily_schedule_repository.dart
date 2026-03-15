import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DailyScheduleRepository {
  ValueListenable<Box<Map<dynamic, dynamic>>> mealsListenable({
    List<dynamic>? keys,
  }) {
    return HiveService.mealsBox.listenable(keys: keys);
  }

  String catDayKey(String catId, [DateTime? date]) {
    final target = date ?? DateTime.now();
    final day = target.toIso8601String().split('T').first;
    return '$catId:$day';
  }

  String groupDayKey(String groupId, [DateTime? date]) {
    final target = date ?? DateTime.now();
    final day = target.toIso8601String().split('T').first;
    return 'group:$groupId:$day';
  }

  Map<String, dynamic>? readSchedule(String key) {
    final raw = HiveService.mealsBox.get(key);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  Future<void> saveSchedule(String key, Map<String, dynamic> schedule) async {
    await HiveService.mealsBox.put(key, schedule);
  }
}

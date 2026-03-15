import 'package:cat_diet_planner/data/repositories/daily_schedule_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dailyScheduleRepositoryProvider = Provider<DailyScheduleRepository>((
  ref,
) {
  return DailyScheduleRepository();
});

import 'package:cat_diet_planner/features/plans/repositories/plan_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository();
});

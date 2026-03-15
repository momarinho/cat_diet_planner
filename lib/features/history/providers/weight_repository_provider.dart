import 'package:cat_diet_planner/data/repositories/weight_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  return WeightRepository();
});

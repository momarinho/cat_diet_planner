import 'package:cat_diet_planner/data/repositories/food_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository();
});

import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/core/errors/localized_exception.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';

class CatProfileRepository {
  List<CatProfile> getAll() {
    final cats = HiveService.catsBox.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return cats;
  }

  Future<void> save(CatProfile cat) async {
    final isNew = !HiveService.catsBox.containsKey(cat.id);
    if (isNew && HiveService.catsBox.length >= AppLimits.maxCats) {
      throw LocalizedException(
        'catLimitReached',
        args: {'max': AppLimits.maxCats},
      );
    }
    await HiveService.catsBox.put(cat.id, cat);
  }

  Future<void> delete(String id) async {
    await HiveService.catsBox.delete(id);
  }
}

import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';

class CatProfileRepository {
  List<CatProfile> getAll() {
    final cats = HiveService.catsBox.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return cats;
  }

  Future<void> save(CatProfile cat) async {
    await HiveService.catsBox.put(cat.id, cat);
  }

  Future<void> delete(String id) async {
    await HiveService.catsBox.delete(id);
  }
}

import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';

class CatGroupRepository {
  List<CatGroup> getAll() {
    final groups = HiveService.catGroupsBox.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return groups;
  }

  Future<void> save(CatGroup group) async {
    final isNew = !HiveService.catGroupsBox.containsKey(group.id);
    if (isNew && HiveService.catGroupsBox.length >= AppLimits.maxGroups) {
      throw StateError(
        'Group limit reached. You can create up to ${AppLimits.maxGroups} groups.',
      );
    }

    await HiveService.catGroupsBox.put(group.id, group);
  }

  Future<void> delete(String id) async {
    await HiveService.catGroupsBox.delete(id);
  }
}

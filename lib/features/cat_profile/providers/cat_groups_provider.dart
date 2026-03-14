import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/features/cat_profile/repositories/cat_group_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final catGroupRepositoryProvider = Provider<CatGroupRepository>((ref) {
  return CatGroupRepository();
});

final catGroupsProvider =
    StateNotifierProvider<CatGroupsNotifier, List<CatGroup>>((ref) {
      return CatGroupsNotifier(ref);
    });

class CatGroupsNotifier extends StateNotifier<List<CatGroup>> {
  CatGroupsNotifier(this.ref)
    : _repository = ref.read(catGroupRepositoryProvider),
      super(const []) {
    _listenable = HiveService.catGroupsBox.listenable();
    _listenable.addListener(_syncFromBox);
    _syncFromBox();
  }

  final Ref ref;
  final CatGroupRepository _repository;
  late final ValueListenable<Box<CatGroup>> _listenable;

  void _syncFromBox() {
    state = _repository.getAll();
  }

  Future<void> saveGroup(CatGroup group) async {
    await _repository.save(group);
    _syncFromBox();
  }

  Future<void> deleteGroup(CatGroup group) async {
    await _repository.delete(group.id);
    _syncFromBox();
  }

  @override
  void dispose() {
    _listenable.removeListener(_syncFromBox);
    super.dispose();
  }
}

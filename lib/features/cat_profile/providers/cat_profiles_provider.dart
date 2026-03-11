import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/repositories/cat_profile_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final catProfileRepositoryProvider = Provider<CatProfileRepository>((ref) {
  return CatProfileRepository();
});

final catProfilesProvider =
    StateNotifierProvider<CatProfilesNotifier, List<CatProfile>>((ref) {
      return CatProfilesNotifier(ref);
    });

class CatProfilesNotifier extends StateNotifier<List<CatProfile>> {
  CatProfilesNotifier(this.ref)
    : _repository = ref.read(catProfileRepositoryProvider),
      super(const []) {
    _listenable = HiveService.catsBox.listenable();
    _listenable.addListener(_syncFromBox);
    _syncFromBox();
  }

  final Ref ref;
  final CatProfileRepository _repository;
  late final ValueListenable<Box<CatProfile>> _listenable;

  void _syncFromBox() {
    state = _repository.getAll();

    final selected = ref.read(selectedCatProvider);
    if (state.isEmpty) {
      if (selected != null) {
        ref.read(selectedCatProvider.notifier).state = null;
      }
      return;
    }

    if (selected == null) {
      ref.read(selectedCatProvider.notifier).state = state.first;
      return;
    }

    final updatedSelected = _findById(selected.id);
    if (updatedSelected == null) {
      ref.read(selectedCatProvider.notifier).state = state.first;
      return;
    }

    ref.read(selectedCatProvider.notifier).state = updatedSelected;
  }

  CatProfile? _findById(String id) {
    for (final cat in state) {
      if (cat.id == id) return cat;
    }
    return null;
  }

  Future<void> saveProfile(CatProfile cat) async {
    await _repository.save(cat);
    _syncFromBox();
  }

  Future<void> deleteProfile(CatProfile cat) async {
    await _repository.delete(cat.id);
    _syncFromBox();
  }

  @override
  void dispose() {
    _listenable.removeListener(_syncFromBox);
    super.dispose();
  }
}

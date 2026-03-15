import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';

class SuggestionPersistenceService {
  String _generatedKey(String catId) => 'generated_suggestions_$catId';

  List<SmartSuggestion> readGeneratedForCat(String catId) {
    final raw = HiveService.appSettingsBox.get(_generatedKey(catId));
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(SmartSuggestion.fromMap)
        .toList(growable: false);
  }

  Future<void> saveGeneratedForCat({
    required String catId,
    required List<SmartSuggestion> suggestions,
  }) async {
    final next = suggestions
        .map((item) => item.toMap())
        .toList(growable: false);
    final current = HiveService.appSettingsBox.get(_generatedKey(catId));
    if (current is List && current.toString() == next.toString()) return;
    await HiveService.appSettingsBox.put(_generatedKey(catId), next);
  }
}

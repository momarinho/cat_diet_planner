import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';

class SuggestionDecisionService {
  static const _decisionsKey = 'suggestion_decisions';

  Map<String, SuggestionDecision> read() {
    final raw = HiveService.appSettingsBox.get(_decisionsKey);
    if (raw is! Map) return const {};
    return {
      for (final entry in raw.entries)
        entry.key.toString(): SuggestionDecision.values.firstWhere(
          (value) => value.name == entry.value?.toString(),
          orElse: () => SuggestionDecision.ignored,
        ),
    };
  }

  Future<void> save(Map<String, SuggestionDecision> decisions) async {
    await HiveService.appSettingsBox.put(_decisionsKey, {
      for (final entry in decisions.entries) entry.key: entry.value.name,
    });
  }
}

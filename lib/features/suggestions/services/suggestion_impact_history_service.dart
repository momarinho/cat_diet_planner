import 'package:cat_diet_planner/core/constants/app_limits.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/suggestions/models/suggestion_impact_history_entry.dart';

class SuggestionImpactHistoryService {
  static const _historyKey = 'suggestion_impact_history';

  List<SuggestionImpactHistoryEntry> readAll() {
    final raw = HiveService.appSettingsBox.get(_historyKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(SuggestionImpactHistoryEntry.fromMap)
        .toList(growable: false);
  }

  Future<void> append(SuggestionImpactHistoryEntry entry) async {
    final all = readAll().map((item) => item.toMap()).toList();
    all.insert(0, entry.toMap());
    await HiveService.appSettingsBox.put(
      _historyKey,
      all.take(AppLimits.maxPlanAuditEntries).toList(growable: false),
    );
  }

  SuggestionImpactHistoryEntry? latestRevertible({String? catId}) {
    for (final entry in readAll()) {
      if (entry.isReverted) continue;
      if (catId != null && entry.catId != catId) continue;
      return entry;
    }
    return null;
  }

  Future<void> markReverted({
    required String historyId,
    required String revertedBy,
    DateTime? revertedAt,
  }) async {
    final timestamp = revertedAt ?? DateTime.now();
    final updated = readAll()
        .map((entry) {
          if (entry.id != historyId) return entry;
          return entry.copyWith(revertedAt: timestamp, revertedBy: revertedBy);
        })
        .toList(growable: false);
    await HiveService.appSettingsBox.put(
      _historyKey,
      updated.map((item) => item.toMap()).toList(growable: false),
    );
  }
}

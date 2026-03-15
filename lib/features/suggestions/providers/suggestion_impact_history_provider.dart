import 'package:cat_diet_planner/features/suggestions/models/suggestion_impact_history_entry.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_impact_history_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final suggestionImpactHistoryServiceProvider =
    Provider<SuggestionImpactHistoryService>((ref) {
      return SuggestionImpactHistoryService();
    });

final suggestionImpactHistoryProvider =
    Provider<List<SuggestionImpactHistoryEntry>>((ref) {
      return ref.read(suggestionImpactHistoryServiceProvider).readAll();
    });

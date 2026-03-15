import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_persistence_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final suggestionPersistenceServiceProvider =
    Provider<SuggestionPersistenceService>((ref) {
      return SuggestionPersistenceService();
    });

final generatedSuggestionsProvider =
    Provider.family<List<SmartSuggestion>, String>((ref, catId) {
      return ref
          .read(suggestionPersistenceServiceProvider)
          .readGeneratedForCat(catId);
    });

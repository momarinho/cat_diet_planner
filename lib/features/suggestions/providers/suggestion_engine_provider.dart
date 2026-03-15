import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:cat_diet_planner/features/suggestions/services/suggestion_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final suggestionEngineProvider = Provider<SuggestionEngine>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return SuggestionEngine(
    interventionLevel: settings.suggestionInterventionLevel,
    categoryToggles: settings.suggestionCategoryToggles,
    dailySuggestionLimit: settings.suggestionDailyLimit,
    alertsOnly: settings.suggestionAlertsOnly,
  );
});

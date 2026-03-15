import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:cat_diet_planner/features/settings/services/app_settings_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appSettingsServiceProvider = Provider<AppSettingsService>((ref) {
  return AppSettingsService();
});

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
      return AppSettingsNotifier(ref.read(appSettingsServiceProvider));
    });

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier(this._service) : super(_service.read());

  final AppSettingsService _service;

  Future<void> setMealReminders(bool enabled) async {
    state = state.copyWith(mealReminders: enabled);
    await _service.save(state);
  }

  Future<void> setLanguageCode(String languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _service.save(state);
  }

  Future<void> setReminderTimes(List<String> reminderTimes) async {
    state = state.copyWith(reminderTimes: reminderTimes);
    await _service.save(state);
  }

  Future<void> setQuietHours({
    required bool enabled,
    required String start,
    required String end,
  }) async {
    state = state.copyWith(
      quietHoursEnabled: enabled,
      quietHoursStart: start,
      quietHoursEnd: end,
    );
    await _service.save(state);
  }

  Future<void> setNotificationProfile({
    required String type,
    String? sound,
    String? intensity,
  }) async {
    final current = Map<String, Map<String, String>>.from(
      state.notificationProfiles,
    );
    final existing = Map<String, String>.from(current[type] ?? const {});
    if (sound != null) existing['sound'] = sound;
    if (intensity != null) existing['intensity'] = intensity;
    current[type] = existing;
    state = state.copyWith(notificationProfiles: current);
    await _service.save(state);
  }

  Future<void> setReportRangeDays(int days) async {
    state = state.copyWith(reportRangeDays: days);
    await _service.save(state);
  }

  Future<void> setCustomReportRangeDays(int days) async {
    state = state.copyWith(customReportRangeDays: days);
    await _service.save(state);
  }

  Future<void> setPdfConfig({
    String? layout,
    bool? includeWeightTrend,
    bool? includeCalorieTable,
    bool? includeVetNotes,
  }) async {
    state = state.copyWith(
      pdfLayout: layout,
      pdfIncludeWeightTrend: includeWeightTrend,
      pdfIncludeCalorieTable: includeCalorieTable,
      pdfIncludeVetNotes: includeVetNotes,
    );
    await _service.save(state);
  }

  Future<void> setShareMessageTemplate(String template) async {
    state = state.copyWith(shareMessageTemplate: template);
    await _service.save(state);
  }

  Future<void> setSuggestionInterventionLevel(String level) async {
    state = state.copyWith(suggestionInterventionLevel: level);
    await _service.save(state);
  }

  Future<void> setSuggestionCategoryEnabled({
    required String category,
    required bool enabled,
  }) async {
    final toggles = Map<String, bool>.from(state.suggestionCategoryToggles);
    toggles[category] = enabled;
    state = state.copyWith(suggestionCategoryToggles: toggles);
    await _service.save(state);
  }

  Future<void> setSuggestionDailyLimit(int limit) async {
    state = state.copyWith(suggestionDailyLimit: limit);
    await _service.save(state);
  }

  Future<void> setSuggestionAlertsOnly(bool enabled) async {
    state = state.copyWith(suggestionAlertsOnly: enabled);
    await _service.save(state);
  }
}

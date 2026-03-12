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
}

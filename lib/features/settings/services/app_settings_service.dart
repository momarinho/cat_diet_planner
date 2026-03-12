import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';

class AppSettingsService {
  static const _settingsKey = 'settings';

  AppSettings read() {
    final raw = HiveService.appSettingsBox.get(_settingsKey);
    if (raw is Map) {
      return AppSettings.fromMap(raw);
    }
    return AppSettings.defaults();
  }

  Future<void> save(AppSettings settings) async {
    await HiveService.appSettingsBox.put(_settingsKey, settings.toMap());
  }
}

import 'package:cat_diet_planner/features/settings/models/app_settings.dart';

import 'notification_service_impl_stub.dart'
    if (dart.library.js_interop) 'notification_service_impl_web.dart'
    if (dart.library.io) 'notification_service_impl_native.dart';

class NotificationService {
  NotificationService._();

  static Future<void> init() => notificationServiceImpl.init();

  static Future<void> requestPermissions() =>
      notificationServiceImpl.requestPermissions();

  static Future<void> cancelMealReminders() =>
      notificationServiceImpl.cancelMealReminders();

  static Future<void> syncWithSettings(AppSettings settings) =>
      notificationServiceImpl.syncWithSettings(settings);

  static Future<void> showTestNotification() =>
      notificationServiceImpl.showTestNotification();
}

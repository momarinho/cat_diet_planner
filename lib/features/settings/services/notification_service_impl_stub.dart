import 'package:cat_diet_planner/features/settings/models/app_settings.dart';

abstract class NotificationServiceImpl {
  Future<void> init();
  Future<void> requestPermissions();
  Future<void> cancelMealReminders();
  Future<void> syncWithSettings(AppSettings settings);
  Future<void> showTestNotification();
}

class UnsupportedNotificationServiceImpl implements NotificationServiceImpl {
  @override
  Future<void> init() async {}

  @override
  Future<void> requestPermissions() async {}

  @override
  Future<void> cancelMealReminders() async {}

  @override
  Future<void> syncWithSettings(AppSettings settings) async {}

  @override
  Future<void> showTestNotification() async {}
}

final NotificationServiceImpl notificationServiceImpl =
    UnsupportedNotificationServiceImpl();

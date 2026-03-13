// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js_interop';

import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:web/web.dart' as web;

import 'notification_service_impl_stub.dart';

class WebNotificationServiceImpl implements NotificationServiceImpl {
  final List<Timer> _timers = [];

  @override
  Future<void> init() async {}

  @override
  Future<void> requestPermissions() async {
    if (!_isSupported) return;

    if (_permission == 'default') {
      await web.Notification.requestPermission().toDart;
    }
  }

  @override
  Future<void> cancelMealReminders() async {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  @override
  Future<void> syncWithSettings(AppSettings settings) async {
    await cancelMealReminders();

    if (!settings.mealReminders) return;

    await requestPermissions();
    if (_permission != 'granted') return;

    for (final rawTime in settings.reminderTimes) {
      final duration = _durationUntil(rawTime);
      if (duration == null) continue;

      _scheduleReminder(duration);
    }
  }

  @override
  Future<void> showTestNotification() async {
    await requestPermissions();
    if (_permission != 'granted') return;

    _showBrowserNotification(
      title: 'CatDiet Planner',
      body: 'Browser notifications are working.',
    );
  }

  void _scheduleReminder(Duration initialDelay) {
    Timer? recurringTimer;

    final initialTimer = Timer(initialDelay, () {
      _showBrowserNotification(
        title: 'Meal Reminder',
        body: 'Time to feed your cat',
      );

      recurringTimer = Timer.periodic(const Duration(days: 1), (_) {
        _showBrowserNotification(
          title: 'Meal Reminder',
          body: 'Time to feed your cat',
        );
      });

      if (recurringTimer != null) {
        _timers.add(recurringTimer!);
      }
    });

    _timers.add(initialTimer);
  }

  void _showBrowserNotification({required String title, required String body}) {
    if (!_isSupported || _permission != 'granted') return;

    web.Notification(title, web.NotificationOptions(body: body));
  }

  Duration? _durationUntil(String rawTime) {
    final parts = rawTime.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, hour, minute);

    if (!target.isAfter(now)) {
      target = target.add(const Duration(days: 1));
    }

    return target.difference(now);
  }

  bool get _isSupported {
    try {
      web.Notification.permission;
      return true;
    } catch (_) {
      return false;
    }
  }

  String get _permission {
    try {
      return web.Notification.permission;
    } catch (_) {
      return 'denied';
    }
  }
}

final NotificationServiceImpl notificationServiceImpl =
    WebNotificationServiceImpl();

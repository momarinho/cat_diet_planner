import 'dart:async';

import 'package:cat_diet_planner/features/notifications/models/app_notification_item.dart';
import 'package:cat_diet_planner/features/notifications/repositories/notification_inbox_repository.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service_impl_stub.dart';
import 'notification_support.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  unawaited(NativeNotificationServiceImpl.handleNotificationResponse(response));
}

void notificationTapForeground(NotificationResponse response) {
  unawaited(NativeNotificationServiceImpl.handleNotificationResponse(response));
}

class NativeNotificationServiceImpl implements NotificationServiceImpl {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'meal_reminders';
  static const _channelName = 'Meal Reminders';
  static const _categoryId = 'meal_reminder_actions';
  static const _recurringIdOffset = 1000;
  static const _snoozedIdOffset = 10000;
  static const _repeatTomorrowIdOffset = 20000;
  static final NotificationInboxRepository _inboxRepository =
      NotificationInboxRepository();

  @override
  Future<void> init() async {
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          _categoryId,
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              NotificationSupport.snoozeActionId,
              'Snooze 15 min',
            ),
            DarwinNotificationAction.plain(
              NotificationSupport.repeatTomorrowActionId,
              'Repeat Tomorrow',
            ),
          ],
        ),
      ],
    );

    final settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: notificationTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @override
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  @override
  Future<void> cancelMealReminders() async {
    for (final rawTime
        in NotificationSupport.readStoredSettings().reminderTimes) {
      final index = _indexFromTime(rawTime);
      await _plugin.cancel(_recurringIdOffset + index);
      await _plugin.cancel(_snoozedIdOffset + index);
      await _plugin.cancel(_repeatTomorrowIdOffset + index);
    }
  }

  @override
  Future<void> syncWithSettings(AppSettings settings) async {
    await cancelMealReminders();

    if (!settings.mealReminders) return;

    await requestPermissions();

    for (var i = 0; i < settings.reminderTimes.length; i++) {
      final time = NotificationSupport.adjustTimeForQuietHours(
        settings.reminderTimes[i],
        enabled: settings.quietHoursEnabled,
        start: settings.quietHoursStart,
        end: settings.quietHoursEnd,
      );
      final parts = time.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) continue;

      final content = NotificationSupport.buildContentForReminder(
        mealIndex: i,
        reminderTime: settings.reminderTimes[i],
      );

      await _plugin.zonedSchedule(
        _recurringIdOffset + i,
        content.title,
        content.body,
        _nextInstanceOfTime(hour, minute),
        _details,
        payload: content.payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  @override
  Future<void> showTestNotification() async {
    await requestPermissions();

    final content = NotificationSupport.buildContentForReminder(
      mealIndex: 0,
      reminderTime: 'Now',
    );

    await _plugin.show(
      9999,
      content.title,
      '${content.body} Test notification.',
      _details,
      payload: content.payload,
    );
    await _inboxRepository.upsert(
      AppNotificationItem(
        id: 'test-notification-${DateTime.now().millisecondsSinceEpoch}',
        type: AppNotificationType.mealReminder,
        title: content.title,
        message: '${content.body} Test notification.',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setActiveCatContext({
    required String catId,
    required String catName,
  }) async {
    await NotificationSupport.saveActiveCatContext(
      catId: catId,
      catName: catName,
    );
    await syncWithSettings(NotificationSupport.readStoredSettings());
  }

  @override
  Future<void> setActiveGroupContext({
    required String groupId,
    required String groupName,
  }) async {
    await NotificationSupport.saveActiveGroupContext(
      groupId: groupId,
      groupName: groupName,
    );
    await syncWithSettings(NotificationSupport.readStoredSettings());
  }

  static Future<void> handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = NotificationPayloadData.decode(response.payload);
    if (payload == null) return;

    if (response.actionId == NotificationSupport.snoozeActionId) {
      await _inboxRepository.upsert(
        AppNotificationItem(
          id: 'notification-action-snooze-${DateTime.now().millisecondsSinceEpoch}',
          type: AppNotificationType.mealReminder,
          title: 'Reminder snoozed',
          message:
              '${payload.mealLabel} for ${payload.entityName} was snoozed for 15 minutes.',
          createdAt: DateTime.now(),
        ),
      );
      await _scheduleSingleReminder(
        id: _snoozedIdOffset + payload.mealIndex,
        when: tz.TZDateTime.now(tz.local).add(const Duration(minutes: 15)),
        payload: payload,
      );
      return;
    }

    if (response.actionId == NotificationSupport.repeatTomorrowActionId) {
      await _inboxRepository.upsert(
        AppNotificationItem(
          id: 'notification-action-repeat-${DateTime.now().millisecondsSinceEpoch}',
          type: AppNotificationType.mealReminder,
          title: 'Reminder postponed',
          message:
              '${payload.mealLabel} for ${payload.entityName} was moved to tomorrow.',
          createdAt: DateTime.now(),
        ),
      );
      final parts = payload.reminderTime.split(':');
      final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 7 : 7;
      final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 30 : 30;
      final now = tz.TZDateTime.now(tz.local);
      final tomorrow = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
      await _scheduleSingleReminder(
        id: _repeatTomorrowIdOffset + payload.mealIndex,
        when: tomorrow,
        payload: payload,
      );
    }
  }

  static Future<void> _scheduleSingleReminder({
    required int id,
    required tz.TZDateTime when,
    required NotificationPayloadData payload,
  }) async {
    final content = NotificationContent(
      title: '${payload.mealLabel} for ${payload.entityName}',
      body: payload.entityType == 'group'
          ? 'Feed ${payload.entityName} tomorrow at ${payload.reminderTime}.'
          : 'Feed ${payload.entityName} at ${payload.reminderTime}.',
      payload: payload.encode(),
    );

    await _plugin.zonedSchedule(
      id,
      content.title,
      content.body,
      when,
      _details,
      payload: content.payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static NotificationDetails get _details {
    final settings = NotificationSupport.readStoredSettings();
    final mealProfile = settings.notificationProfiles['meal'] ?? const {};
    final intensity = mealProfile['intensity'] ?? 'high';
    final sound = mealProfile['sound'] ?? 'default';
    final importance = intensity == 'low'
        ? Importance.defaultImportance
        : intensity == 'max'
        ? Importance.max
        : Importance.high;
    final priority = intensity == 'low'
        ? Priority.defaultPriority
        : intensity == 'max'
        ? Priority.max
        : Priority.high;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Meal reminder notifications',
        importance: importance,
        priority: priority,
        playSound: sound != 'mute',
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            NotificationSupport.snoozeActionId,
            'Snooze 15 min',
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            NotificationSupport.repeatTomorrowActionId,
            'Repeat Tomorrow',
            cancelNotification: true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: _categoryId,
        presentSound: sound != 'mute',
      ),
    );
  }

  static int _indexFromTime(String rawTime) {
    final settings = NotificationSupport.readStoredSettings();
    final index = settings.reminderTimes.indexOf(rawTime);
    return index < 0 ? 0 : index;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}

final NotificationServiceImpl notificationServiceImpl =
    NativeNotificationServiceImpl();

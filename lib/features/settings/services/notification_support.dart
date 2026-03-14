import 'dart:convert';

import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';

class NotificationReminderContext {
  const NotificationReminderContext({
    required this.entityType,
    required this.entityId,
    required this.displayName,
  });

  final String entityType;
  final String entityId;
  final String displayName;

  bool get isGroup => entityType == 'group';

  Map<String, dynamic> toMap() {
    return {
      'entityType': entityType,
      'entityId': entityId,
      'displayName': displayName,
    };
  }

  static NotificationReminderContext? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return null;

    final entityType = map['entityType']?.toString();
    final entityId = map['entityId']?.toString();
    final displayName = map['displayName']?.toString();
    if (entityType == null || entityId == null || displayName == null) {
      return null;
    }

    return NotificationReminderContext(
      entityType: entityType,
      entityId: entityId,
      displayName: displayName,
    );
  }
}

class NotificationPayloadData {
  const NotificationPayloadData({
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.mealIndex,
    required this.mealLabel,
    required this.reminderTime,
  });

  final String entityType;
  final String entityId;
  final String entityName;
  final int mealIndex;
  final String mealLabel;
  final String reminderTime;

  Map<String, dynamic> toMap() {
    return {
      'entityType': entityType,
      'entityId': entityId,
      'entityName': entityName,
      'mealIndex': mealIndex,
      'mealLabel': mealLabel,
      'reminderTime': reminderTime,
    };
  }

  String encode() => jsonEncode(toMap());

  static NotificationPayloadData? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;

    final entityType = decoded['entityType']?.toString();
    final entityId = decoded['entityId']?.toString();
    final entityName = decoded['entityName']?.toString();
    final mealLabel = decoded['mealLabel']?.toString();
    final reminderTime = decoded['reminderTime']?.toString();
    final mealIndex = decoded['mealIndex'] is int
        ? decoded['mealIndex'] as int
        : int.tryParse(decoded['mealIndex']?.toString() ?? '');

    if (entityType == null ||
        entityId == null ||
        entityName == null ||
        mealLabel == null ||
        reminderTime == null ||
        mealIndex == null) {
      return null;
    }

    return NotificationPayloadData(
      entityType: entityType,
      entityId: entityId,
      entityName: entityName,
      mealIndex: mealIndex,
      mealLabel: mealLabel,
      reminderTime: reminderTime,
    );
  }
}

class NotificationContent {
  const NotificationContent({
    required this.title,
    required this.body,
    required this.payload,
  });

  final String title;
  final String body;
  final String payload;
}

class NotificationSupport {
  static const settingsKey = 'settings';
  static const contextKey = 'notification_context';
  static const snoozeActionId = 'snooze_15m';
  static const repeatTomorrowActionId = 'repeat_tomorrow';

  static AppSettings readStoredSettings() {
    final raw = HiveService.appSettingsBox.get(settingsKey);
    if (raw is Map) {
      return AppSettings.fromMap(raw);
    }
    return AppSettings.defaults();
  }

  static Future<void> saveActiveCatContext({
    required String catId,
    required String catName,
  }) async {
    await HiveService.appSettingsBox.put(
      contextKey,
      NotificationReminderContext(
        entityType: 'cat',
        entityId: catId,
        displayName: catName,
      ).toMap(),
    );
  }

  static Future<void> saveActiveGroupContext({
    required String groupId,
    required String groupName,
  }) async {
    await HiveService.appSettingsBox.put(
      contextKey,
      NotificationReminderContext(
        entityType: 'group',
        entityId: groupId,
        displayName: groupName,
      ).toMap(),
    );
  }

  static NotificationReminderContext? readActiveContext() {
    final raw = HiveService.appSettingsBox.get(contextKey);
    if (raw is Map) {
      return NotificationReminderContext.fromMap(raw);
    }
    return null;
  }

  static NotificationContent buildContentForReminder({
    required int mealIndex,
    required String reminderTime,
  }) {
    final context = readActiveContext();
    final mealLabel = mealTitle(mealIndex);

    if (context == null) {
      final payload = NotificationPayloadData(
        entityType: 'generic',
        entityId: 'global',
        entityName: 'CatDiet Planner',
        mealIndex: mealIndex,
        mealLabel: mealLabel,
        reminderTime: reminderTime,
      );
      return NotificationContent(
        title: '$mealLabel Reminder',
        body: 'Time to feed your cat at $reminderTime.',
        payload: payload.encode(),
      );
    }

    final name = context.displayName;
    final groupSuffix = context.isGroup ? _groupSuffix(context.entityId) : '';
    final payload = NotificationPayloadData(
      entityType: context.entityType,
      entityId: context.entityId,
      entityName: name,
      mealIndex: mealIndex,
      mealLabel: mealLabel,
      reminderTime: reminderTime,
    );

    return NotificationContent(
      title: '$mealLabel for $name',
      body: context.isGroup
          ? 'Feed $name$groupSuffix at $reminderTime.'
          : 'Feed $name at $reminderTime.',
      payload: payload.encode(),
    );
  }

  static String mealTitle(int index) {
    switch (index) {
      case 0:
        return 'Breakfast';
      case 1:
        return 'Lunch';
      case 2:
        return 'Afternoon Meal';
      case 3:
        return 'Dinner';
      case 4:
        return 'Late Meal';
      default:
        return 'Meal ${index + 1}';
    }
  }

  static String _groupSuffix(String groupId) {
    final group = HiveService.catGroupsBox.get(groupId);
    if (group == null) return '';
    return ' (${group.catCount} cats)';
  }
}

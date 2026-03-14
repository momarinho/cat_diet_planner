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
    final settings = readStoredSettings();
    final lang = settings.languageCode;
    final context = readActiveContext();
    final mealLabel = mealTitle(mealIndex, languageCode: lang);

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
        title: localizedTitle('$mealLabel Reminder', lang),
        body: localizedBodyForGeneric(reminderTime, lang),
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
      title: localizedTitle('$mealLabel for $name', lang),
      body: context.isGroup
          ? localizedBodyForGroup(name, groupSuffix, reminderTime, lang)
          : localizedBodyForCat(name, reminderTime, lang),
      payload: payload.encode(),
    );
  }

  static String mealTitle(int index, {String languageCode = 'en'}) {
    final isPt = languageCode == 'pt';
    final isTl = languageCode == 'tl';
    switch (index) {
      case 0:
        return isPt
            ? 'Cafe da manha'
            : isTl
            ? 'Almusal'
            : 'Breakfast';
      case 1:
        return isPt
            ? 'Almoco'
            : isTl
            ? 'Tanghalian'
            : 'Lunch';
      case 2:
        return isPt
            ? 'Refeicao da tarde'
            : isTl
            ? 'Meryenda'
            : 'Afternoon Meal';
      case 3:
        return isPt
            ? 'Jantar'
            : isTl
            ? 'Hapunan'
            : 'Dinner';
      case 4:
        return isPt
            ? 'Refeicao noturna'
            : isTl
            ? 'Huling kainan'
            : 'Late Meal';
      default:
        return isPt
            ? 'Refeicao ${index + 1}'
            : isTl
            ? 'Kainan ${index + 1}'
            : 'Meal ${index + 1}';
    }
  }

  static String localizedTitle(String fallback, String languageCode) {
    if (languageCode == 'pt') {
      return fallback.replaceAll('Reminder', 'Lembrete');
    }
    if (languageCode == 'tl') {
      return fallback.replaceAll('Reminder', 'Paalala');
    }
    return fallback;
  }

  static String localizedBodyForGeneric(String reminderTime, String lang) {
    if (lang == 'pt') {
      return 'Hora de alimentar seu gato as $reminderTime.';
    }
    if (lang == 'tl') {
      return 'Oras na para pakainin ang pusa mo sa $reminderTime.';
    }
    return 'Time to feed your cat at $reminderTime.';
  }

  static String localizedBodyForCat(
    String name,
    String reminderTime,
    String lang,
  ) {
    if (lang == 'pt') return 'Alimente $name as $reminderTime.';
    if (lang == 'tl') return 'Pakainin si $name sa $reminderTime.';
    return 'Feed $name at $reminderTime.';
  }

  static String localizedBodyForGroup(
    String name,
    String groupSuffix,
    String reminderTime,
    String lang,
  ) {
    if (lang == 'pt') return 'Alimente $name$groupSuffix as $reminderTime.';
    if (lang == 'tl') return 'Pakainin ang $name$groupSuffix sa $reminderTime.';
    return 'Feed $name$groupSuffix at $reminderTime.';
  }

  static String _groupSuffix(String groupId) {
    final group = HiveService.catGroupsBox.get(groupId);
    if (group == null) return '';
    return ' (${group.catCount} cats)';
  }

  static bool isWithinQuietHours(
    DateTime now, {
    required bool enabled,
    required String start,
    required String end,
  }) {
    if (!enabled) return false;
    final startParts = start.split(':');
    final endParts = end.split(':');
    if (startParts.length != 2 || endParts.length != 2) return false;
    final startHour = int.tryParse(startParts[0]) ?? 22;
    final startMinute = int.tryParse(startParts[1]) ?? 0;
    final endHour = int.tryParse(endParts[0]) ?? 7;
    final endMinute = int.tryParse(endParts[1]) ?? 0;

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    if (startMinutes == endMinutes) return true;
    if (startMinutes < endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    }
    return nowMinutes >= startMinutes || nowMinutes < endMinutes;
  }

  static String adjustTimeForQuietHours(
    String rawTime, {
    required bool enabled,
    required String start,
    required String end,
  }) {
    if (!enabled) return rawTime;
    final parts = rawTime.split(':');
    if (parts.length != 2) return rawTime;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return rawTime;
    final probe = DateTime(2026, 1, 1, hour, minute);
    if (!isWithinQuietHours(probe, enabled: enabled, start: start, end: end)) {
      return rawTime;
    }
    return end;
  }
}

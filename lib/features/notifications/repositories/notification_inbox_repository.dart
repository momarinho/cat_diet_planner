import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/notifications/models/app_notification_item.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationInboxRepository {
  static const inboxKey = 'notification_inbox';

  ValueListenable<Box<dynamic>> listenable() {
    return HiveService.appSettingsBox.listenable(keys: const [inboxKey]);
  }

  List<AppNotificationItem> readAll() {
    final raw = HiveService.appSettingsBox.get(inboxKey);
    if (raw is! List) return const [];

    final items = <AppNotificationItem>[];
    for (final entry in raw) {
      if (entry is Map) {
        final item = AppNotificationItem.fromMap(entry);
        if (item != null) items.add(item);
      }
    }
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> upsert(AppNotificationItem item) async {
    final current = readAll();
    final index = current.indexWhere((existing) => existing.id == item.id);
    if (index >= 0) {
      current[index] = item;
    } else {
      current.add(item);
    }
    await _save(current);
  }

  Future<void> markRead(String id, {bool isRead = true}) async {
    final current = readAll();
    final index = current.indexWhere((existing) => existing.id == id);
    if (index < 0) return;
    current[index] = current[index].copyWith(isRead: isRead);
    await _save(current);
  }

  Future<void> markAllRead() async {
    final current = readAll()
        .map((item) => item.copyWith(isRead: true))
        .toList(growable: false);
    await _save(current);
  }

  Future<void> _save(List<AppNotificationItem> items) async {
    await HiveService.appSettingsBox.put(
      inboxKey,
      items.map((item) => item.toMap()).toList(growable: false),
    );
  }
}

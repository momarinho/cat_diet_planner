import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/notifications/models/app_notification_item.dart';
import 'package:cat_diet_planner/features/notifications/services/notification_inbox_service.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'builds inbox items for reminders, backup overdue, and weight alerts',
    () {
      const service = NotificationInboxService();
      final cat = CatProfile(
        id: 'cat-1',
        name: 'Luna',
        weight: 4.2,
        age: 24,
        createdAt: DateTime(2026, 1, 1),
      );
      final settings = AppSettings.defaults().copyWith(
        reminderTimes: const ['07:30', '12:30'],
        backupReminderEnabled: true,
        backupReminderDays: 7,
        lastBackupAtIso: DateTime(2026, 3, 1).toIso8601String(),
      );
      final items = service.build(
        settings: settings,
        cats: [cat],
        recordsByCat: {
          cat.id: [
            WeightRecord(
              catId: cat.id,
              date: DateTime(2026, 3, 15, 8),
              weight: 4.4,
              clinicalAlertLevel: 'high',
              alertTriggered: true,
            ),
          ],
        },
        now: DateTime(2026, 3, 15, 10),
      );

      expect(items, hasLength(3));
      expect(
        items.any((item) => item.type == AppNotificationType.mealReminder),
        isTrue,
      );
      expect(
        items.any((item) => item.type == AppNotificationType.backupReminder),
        isTrue,
      );
      expect(
        items.any((item) => item.type == AppNotificationType.weightAlert),
        isTrue,
      );
      expect(items.first.title, 'Meal reminders active');
      expect(items.every((item) => item.isRead == false), isTrue);
    },
  );
}

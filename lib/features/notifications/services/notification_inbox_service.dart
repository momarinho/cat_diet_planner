import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/notifications/models/app_notification_item.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';

class NotificationInboxService {
  const NotificationInboxService();

  List<AppNotificationItem> build({
    required AppSettings settings,
    required List<CatProfile> cats,
    required Map<String, List<WeightRecord>> recordsByCat,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final items = <AppNotificationItem>[];

    if (settings.mealReminders && settings.reminderTimes.isNotEmpty) {
      items.add(
        AppNotificationItem(
          id: 'meal-reminders',
          type: AppNotificationType.mealReminder,
          title: 'Meal reminders active',
          message:
              'Scheduled reminders: ${settings.reminderTimes.join(' • ')}.',
          createdAt: reference,
          isRead: false,
          routeName: AppRoutes.settings,
        ),
      );
    }

    if (_isBackupOverdue(settings, reference)) {
      items.add(
        AppNotificationItem(
          id: 'backup-overdue',
          type: AppNotificationType.backupReminder,
          title: 'Backup overdue',
          message:
              'Export a new backup to avoid losing local data on this device.',
          createdAt: _parseLastBackupAt(settings.lastBackupAtIso) ?? reference,
          isRead: false,
          routeName: AppRoutes.settings,
        ),
      );
    }

    for (final cat in cats) {
      final records = recordsByCat[cat.id] ?? cat.weightHistory;
      if (records.isEmpty) continue;

      final sorted = [...records]..sort((a, b) => b.date.compareTo(a.date));
      final alertRecord = sorted.cast<WeightRecord?>().firstWhere(
        (record) => record?.alertTriggered ?? false,
        orElse: () => null,
      );
      if (alertRecord == null) continue;

      final alertLevel = alertRecord.clinicalAlertLevel ?? 'watch';
      items.add(
        AppNotificationItem(
          id: 'weight-alert-${cat.id}-${alertRecord.date.toIso8601String()}',
          type: AppNotificationType.weightAlert,
          title: 'Weight alert for ${cat.name}',
          message:
              'Latest check-in flagged a ${alertLevel.toLowerCase()} alert and should be reviewed.',
          createdAt: alertRecord.date,
          isRead: false,
          routeName: AppRoutes.catProfile,
          routeArguments: cat,
        ),
      );
    }

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  bool _isBackupOverdue(AppSettings settings, DateTime now) {
    if (!settings.backupReminderEnabled) return false;
    final lastBackupAt = _parseLastBackupAt(settings.lastBackupAtIso);
    if (lastBackupAt == null) return true;
    return now.isAfter(
      lastBackupAt.add(Duration(days: settings.backupReminderDays)),
    );
  }

  DateTime? _parseLastBackupAt(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    return DateTime.tryParse(iso);
  }
}

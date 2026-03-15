import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/features/notifications/models/app_notification_item.dart';
import 'package:cat_diet_planner/features/notifications/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.any((item) => !item.isRead))
            TextButton(
              onPressed: () async {
                await ref
                    .read(notificationInboxRepositoryProvider)
                    .markAllRead();
              },
              child: const Text('Mark all read'),
            ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Notification settings',
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No notifications right now',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'This inbox will show reminders, backup warnings, and clinical alerts.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _NotificationCard(item: item);
              },
            ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.item});

  final AppNotificationItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    final createdLabel =
        '${localizations.formatShortDate(item.createdAt)} • ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(item.createdAt))}';

    return Card(
      elevation: 0,
      color: item.isRead
          ? null
          : theme.colorScheme.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await ref.read(notificationInboxRepositoryProvider).markRead(item.id);
          if (!context.mounted || item.routeName == null) return;
          Navigator.of(
            context,
          ).pushNamed(item.routeName!, arguments: item.routeArguments);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _colorForType(
                    theme,
                    item.type,
                  ).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconForType(item.type),
                  color: _colorForType(theme, item.type),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!item.isRead) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Unread',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(item.message, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(
                      createdLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.72,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (item.routeName != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.mealReminder:
        return Icons.schedule_rounded;
      case AppNotificationType.backupReminder:
        return Icons.backup_outlined;
      case AppNotificationType.weightAlert:
        return Icons.monitor_weight_outlined;
    }
  }

  Color _colorForType(ThemeData theme, AppNotificationType type) {
    switch (type) {
      case AppNotificationType.mealReminder:
        return theme.colorScheme.primary;
      case AppNotificationType.backupReminder:
        return Colors.amber.shade800;
      case AppNotificationType.weightAlert:
        return Colors.redAccent;
    }
  }
}

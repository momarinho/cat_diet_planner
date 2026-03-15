import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/history/providers/weight_repository_provider.dart';
import 'package:cat_diet_planner/features/notifications/models/app_notification_item.dart';
import 'package:cat_diet_planner/features/notifications/repositories/notification_inbox_repository.dart';
import 'package:cat_diet_planner/features/notifications/services/notification_inbox_service.dart';
import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final notificationInboxServiceProvider = Provider<NotificationInboxService>((
  ref,
) {
  return const NotificationInboxService();
});

final notificationInboxRepositoryProvider =
    Provider<NotificationInboxRepository>((ref) {
      return NotificationInboxRepository();
    });

final persistedNotificationsProvider =
    StateNotifierProvider<
      PersistedNotificationsNotifier,
      List<AppNotificationItem>
    >((ref) {
      return PersistedNotificationsNotifier(
        ref.read(notificationInboxRepositoryProvider),
      );
    });

class PersistedNotificationsNotifier
    extends StateNotifier<List<AppNotificationItem>> {
  PersistedNotificationsNotifier(this._repository)
    : super(_repository.readAll()) {
    _listenable = _repository.listenable();
    _listenable.addListener(_sync);
  }

  final NotificationInboxRepository _repository;
  late final ValueListenable<Box<dynamic>> _listenable;

  void _sync() {
    state = _repository.readAll();
  }

  @override
  void dispose() {
    _listenable.removeListener(_sync);
    super.dispose();
  }
}

final notificationsProvider = Provider<List<AppNotificationItem>>((ref) {
  final settings = ref.watch(appSettingsProvider);
  final cats = ref.watch(catProfilesProvider);
  final weightRepository = ref.watch(weightRepositoryProvider);
  final service = ref.watch(notificationInboxServiceProvider);
  final persisted = ref.watch(persistedNotificationsProvider);

  final recordsByCat = <String, List<dynamic>>{};
  for (final cat in cats) {
    recordsByCat[cat.id] = weightRepository.recordsForCat(
      cat.id,
      fallbackHistory: cat.weightHistory,
    );
  }

  final systemItems = service.build(
    settings: settings,
    cats: cats,
    recordsByCat: recordsByCat.cast(),
  );

  final persistedById = <String, AppNotificationItem>{
    for (final item in persisted) item.id: item,
  };
  final systemIds = <String>{};
  final merged = <AppNotificationItem>[];

  for (final item in systemItems) {
    systemIds.add(item.id);
    final stored = persistedById[item.id];
    merged.add(stored == null ? item : item.copyWith(isRead: stored.isRead));
  }

  for (final item in persisted) {
    if (!systemIds.contains(item.id)) {
      merged.add(item);
    }
  }

  merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return merged;
});

final notificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((item) => !item.isRead).length;
});

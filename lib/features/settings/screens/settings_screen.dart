import 'package:cat_diet_planner/core/localization/app_locale.dart';
import 'package:cat_diet_planner/core/localization/app_feedback_localizer.dart';
import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/core/theme/theme_provider.dart';
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/features/cat_group/providers/selected_group_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:cat_diet_planner/features/settings/services/data_export_service.dart';
import 'package:cat_diet_planner/features/settings/services/demo_data_service.dart';
import 'package:cat_diet_planner/features/settings/services/notification_service.dart';
import 'package:cat_diet_planner/features/suggestions/providers/plan_change_audit_provider.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_impact_history_provider.dart';
import 'package:cat_diet_planner/features/suggestions/services/plan_adjustment_service.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _suggestionInterventionLabels = {
    'conservative': 'conservative',
    'balanced': 'balanced',
    'proactive': 'proactive',
  };
  static const _suggestionCategoryLabels = {
    'kcalAdjustment': 'Daily kcal adjustments',
    'scheduleAdjustment': 'Schedule adjustments',
    'portionSplitAdjustment': 'Portion split adjustments',
    'preventiveTrendAlert': 'Preventive trend alerts',
    'clinicalWatch': 'Clinical watch alerts',
  };
  bool _isGeneratingDemoData = false;
  bool _isGeneratingStressData = false;
  bool _isClearingDemoData = false;
  bool _isRevertingSuggestionChange = false;

  String _formatAuditTimestamp(DateTime value) {
    return AppFormatters.formatDateTime(context, value);
  }

  Future<void> _revertLastSuggestedChange() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    var validationMessage = '';
    final revertedBy = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(l10n.revertLastSuggestedChangeTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.revertLastSuggestedChangeDescription),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: l10n.typeWhoIsRevertingHint,
                      errorText: validationMessage.isEmpty
                          ? null
                          : validationMessage,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancelAction),
                ),
                FilledButton(
                  onPressed: () {
                    final value = controller.text.trim();
                    if (value.isEmpty) {
                      setDialogState(() {
                        validationMessage = l10n.responsiblePersonRequired;
                      });
                      return;
                    }
                    Navigator.of(dialogContext).pop(value);
                  },
                  child: Text(l10n.revertAction),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();
    if (revertedBy == null || !mounted) return;

    setState(() => _isRevertingSuggestionChange = true);
    try {
      final result = await ref
          .read(planAdjustmentServiceProvider)
          .revertLastSuggestedChange(revertedBy: revertedBy);
      ref.invalidate(planChangeAuditProvider);
      ref.invalidate(suggestionImpactHistoryProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizePlanAdjustmentMessage(l10n, result))),
      );
    } finally {
      if (mounted) {
        setState(() => _isRevertingSuggestionChange = false);
      }
    }
  }

  String _notificationProfileValue(
    AppSettings settings,
    String type,
    String field,
  ) {
    final defaults = AppSettings.defaults().notificationProfiles;
    final fallback = defaults[type]?[field] ?? '';
    return settings.notificationProfiles[type]?[field] ?? fallback;
  }

  String _formatLocalizedChangeSummary(List<String> lines) {
    final l10n = AppLocalizations.of(context);
    return lines
        .map((line) => localizeChangeSummaryLine(l10n, line))
        .join(' • ');
  }

  Future<void> _setNotificationProfile({
    required String type,
    String? sound,
    String? intensity,
  }) async {
    await ref
        .read(appSettingsProvider.notifier)
        .setNotificationProfile(type: type, sound: sound, intensity: intensity);
    await NotificationService.syncWithSettings(ref.read(appSettingsProvider));
  }

  Widget _buildNotificationProfileControls({
    required AppSettings appSettings,
    required String type,
    required String label,
    required Color primary,
  }) {
    final sound = _notificationProfileValue(appSettings, type, 'sound');
    final intensity = _notificationProfileValue(appSettings, type, 'intensity');
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.volume_up_rounded, color: primary),
          title: Text('$label Notification Sound'),
          subtitle: Text(sound),
          trailing: DropdownButton<String>(
            value: sound,
            items: const [
              DropdownMenuItem(value: 'default', child: Text('default')),
              DropdownMenuItem(value: 'soft', child: Text('soft')),
              DropdownMenuItem(value: 'mute', child: Text('mute')),
            ],
            onChanged: (value) async {
              if (value == null) return;
              await _setNotificationProfile(type: type, sound: value);
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.notifications_rounded, color: primary),
          title: Text('$label Notification Intensity'),
          subtitle: Text(intensity),
          trailing: DropdownButton<String>(
            value: intensity,
            items: const [
              DropdownMenuItem(value: 'low', child: Text('low')),
              DropdownMenuItem(value: 'default', child: Text('default')),
              DropdownMenuItem(value: 'high', child: Text('high')),
              DropdownMenuItem(value: 'max', child: Text('max')),
            ],
            onChanged: (value) async {
              if (value == null) return;
              await _setNotificationProfile(type: type, intensity: value);
            },
          ),
        ),
      ],
    );
  }

  bool _suggestionCategoryEnabled(AppSettings settings, String category) {
    final defaults = AppSettings.defaults().suggestionCategoryToggles;
    return settings.suggestionCategoryToggles[category] ??
        defaults[category] ??
        true;
  }

  Future<String?> _pickTimeString(String current) async {
    final parts = current.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 22,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return null;
    return '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _editShareMessage(String current) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: current);
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shareMessageTitle),
        content: TextField(
          controller: controller,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: l10n.shareMessageHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.saveAction),
          ),
        ],
      ),
    );
    if (shouldSave == true) {
      await ref
          .read(appSettingsProvider.notifier)
          .setShareMessageTemplate(controller.text.trim());
    }
    controller.dispose();
  }

  Future<void> _editSchedule(List<String> currentTimes) async {
    final l10n = AppLocalizations.of(context);
    final updatedTimes = [...currentTimes]..sort();

    final shouldSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> addTime() async {
              final now = TimeOfDay.now();
              final picked = await showTimePicker(
                context: context,
                initialTime: now,
              );
              if (picked == null) return;
              final formatted =
                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
              if (updatedTimes.contains(formatted)) return;
              setModalState(() {
                updatedTimes.add(formatted);
                updatedTimes.sort();
              });
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.mealReminderTimesTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...updatedTimes.map((time) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(time),
                        trailing: IconButton(
                          onPressed: () {
                            setModalState(() => updatedTimes.remove(time));
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: addTime,
                      icon: const Icon(Icons.add_alarm_rounded),
                      label: Text(l10n.addTimeAction),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l10n.saveScheduleAction),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (shouldSave == true && mounted) {
      await ref
          .read(appSettingsProvider.notifier)
          .setReminderTimes(updatedTimes);
      await NotificationService.syncWithSettings(ref.read(appSettingsProvider));
    }
  }

  Future<void> _pickLanguage(String currentLanguage) async {
    final l10n = AppLocalizations.of(context);
    final languageLabels = _languageLabels(l10n);
    final normalizedCurrent = AppLocale.normalizeLanguageCode(currentLanguage);
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languageLabels.entries.map((entry) {
              return ListTile(
                title: Text(entry.value),
                trailing: normalizedCurrent == entry.key
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () => Navigator.of(context).pop(entry.key),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected != null) {
      await ref.read(appSettingsProvider.notifier).setLanguageCode(selected);
    }
  }

  Future<void> _generateDemoData() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.generateDemoDataTitle),
          content: Text(l10n.generateDemoDataDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancelAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.generateAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isGeneratingDemoData = true);
    try {
      final summary = await DemoDataService.seedReadyToTestScenario();
      ref.invalidate(appSettingsProvider);
      ref.invalidate(themeProvider);
      ref.invalidate(catProfilesProvider);

      final cats = ref.read(catProfilesProvider);
      final seededCat = cats.isNotEmpty ? cats.first : null;
      ref.read(selectedCatProvider.notifier).state = seededCat;
      ref.read(selectedGroupProvider.notifier).state = null;

      final settings = ref.read(appSettingsProvider);
      await NotificationService.syncWithSettings(settings);
      if (seededCat != null) {
        await NotificationService.setActiveCatContext(
          catId: seededCat.id,
          catName: seededCat.name,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.demoDataReadyMessage(
              summary.groups,
              summary.cats,
              summary.foods,
              summary.mealSchedules,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGeneratingDemoData = false);
      }
    }
  }

  Future<void> _clearDemoData() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.clearDemoDataTitle),
          content: Text(l10n.clearDemoDataDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancelAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.clearAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isClearingDemoData = true);
    try {
      await DemoDataService.clearAllLocalData();
      ref.invalidate(appSettingsProvider);
      ref.invalidate(themeProvider);
      ref.read(selectedCatProvider.notifier).state = null;
      ref.read(selectedGroupProvider.notifier).state = null;
      await NotificationService.cancelMealReminders();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.localDemoDataClearedMessage)));
    } finally {
      if (mounted) {
        setState(() => _isClearingDemoData = false);
      }
    }
  }

  Future<void> _generateStressData() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.generateStressDataTitle),
          content: Text(l10n.generateStressDataDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancelAction),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.generateAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isGeneratingStressData = true);
    try {
      final summary = await DemoDataService.seedOperationalStressScenario();
      ref.invalidate(appSettingsProvider);
      ref.invalidate(themeProvider);
      ref.invalidate(catProfilesProvider);

      final cats = ref.read(catProfilesProvider);
      final seededCat = cats.isNotEmpty ? cats.first : null;
      ref.read(selectedCatProvider.notifier).state = seededCat;
      ref.read(selectedGroupProvider.notifier).state = null;

      final settings = ref.read(appSettingsProvider);
      await NotificationService.syncWithSettings(settings);
      if (seededCat != null) {
        await NotificationService.setActiveCatContext(
          catId: seededCat.id,
          catName: seededCat.name,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.stressScenarioReadyMessage(
              summary.groups,
              summary.cats,
              summary.foods,
              summary.mealSchedules,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGeneratingStressData = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageLabels = _languageLabels(l10n);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final themeMode = ref.watch(themeProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final planAuditEntries = ref.watch(planChangeAuditProvider);
    final impactEntries = ref.watch(suggestionImpactHistoryProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final secondaryText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SectionCard(
            title: 'Notifications',
            children: [
              SwitchListTile(
                value: appSettings.mealReminders,
                onChanged: (value) async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setMealReminders(value);
                  await NotificationService.syncWithSettings(
                    ref.read(appSettingsProvider),
                  );
                },
                title: const Text('Meal Reminders'),
                subtitle: const Text('Enable alerts for feeding times'),
                activeThumbColor: primary,
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.notifications_active_rounded,
                  color: primary,
                ),
                title: const Text('Test Notification'),
                subtitle: const Text(
                  'Verify the current platform notification flow',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await NotificationService.showTestNotification();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.schedule_rounded, color: primary),
                title: const Text('Edit Independent Reminder Schedule'),
                subtitle: Text(appSettings.reminderTimes.join(' • ')),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _editSchedule(appSettings.reminderTimes),
              ),
              SwitchListTile(
                value: appSettings.quietHoursEnabled,
                onChanged: (value) async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setQuietHours(
                        enabled: value,
                        start: appSettings.quietHoursStart,
                        end: appSettings.quietHoursEnd,
                      );
                  await NotificationService.syncWithSettings(
                    ref.read(appSettingsProvider),
                  );
                },
                title: const Text('Quiet Hours'),
                subtitle: Text(
                  '${appSettings.quietHoursStart} - ${appSettings.quietHoursEnd}',
                ),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.bedtime_rounded, color: primary),
                title: const Text('Quiet Start'),
                subtitle: Text(appSettings.quietHoursStart),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final next = await _pickTimeString(
                    appSettings.quietHoursStart,
                  );
                  if (next == null) return;
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setQuietHours(
                        enabled: appSettings.quietHoursEnabled,
                        start: next,
                        end: appSettings.quietHoursEnd,
                      );
                  await NotificationService.syncWithSettings(
                    ref.read(appSettingsProvider),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.wb_sunny_outlined, color: primary),
                title: const Text('Quiet End'),
                subtitle: Text(appSettings.quietHoursEnd),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final next = await _pickTimeString(appSettings.quietHoursEnd);
                  if (next == null) return;
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setQuietHours(
                        enabled: appSettings.quietHoursEnabled,
                        start: appSettings.quietHoursStart,
                        end: next,
                      );
                  await NotificationService.syncWithSettings(
                    ref.read(appSettingsProvider),
                  );
                },
              ),
              _buildNotificationProfileControls(
                appSettings: appSettings,
                type: 'meal',
                label: 'Meal',
                primary: primary,
              ),
              _buildNotificationProfileControls(
                appSettings: appSettings,
                type: 'weight',
                label: 'Weight',
                primary: primary,
              ),
              _buildNotificationProfileControls(
                appSettings: appSettings,
                type: 'health',
                label: 'Health',
                primary: primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Smart Suggestions',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.tune_rounded, color: primary),
                title: const Text('Intervention Level'),
                subtitle: Text(
                  _suggestionInterventionLabels[appSettings
                          .suggestionInterventionLevel] ??
                      'balanced',
                ),
                trailing: DropdownButton<String>(
                  value: appSettings.suggestionInterventionLevel,
                  items: _suggestionInterventionLabels.entries
                      .map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      })
                      .toList(growable: false),
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setSuggestionInterventionLevel(value);
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.filter_list_rounded, color: primary),
                title: const Text('Daily suggestion limit'),
                subtitle: Text(
                  '${appSettings.suggestionDailyLimit} active suggestions per day',
                ),
                trailing: DropdownButton<int>(
                  value: appSettings.suggestionDailyLimit,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1')),
                    DropdownMenuItem(value: 2, child: Text('2')),
                    DropdownMenuItem(value: 3, child: Text('3')),
                    DropdownMenuItem(value: 4, child: Text('4')),
                    DropdownMenuItem(value: 5, child: Text('5')),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setSuggestionDailyLimit(value);
                  },
                ),
              ),
              SwitchListTile(
                value: appSettings.suggestionAutoApply,
                onChanged: null,
                title: const Text('Auto-apply suggestions'),
                subtitle: const Text(
                  'Disabled by default and locked off. Any plan change requires manual confirmation.',
                ),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: appSettings.suggestionAlertsOnly,
                onChanged: (value) async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setSuggestionAlertsOnly(value);
                },
                title: const Text('Alerts Only Mode'),
                subtitle: const Text(
                  'Show only preventive and clinical alerts, without plan-adjustment suggestions.',
                ),
                contentPadding: EdgeInsets.zero,
              ),
              ..._suggestionCategoryLabels.entries.map((entry) {
                return SwitchListTile(
                  value: _suggestionCategoryEnabled(appSettings, entry.key),
                  onChanged: (value) async {
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setSuggestionCategoryEnabled(
                          category: entry.key,
                          enabled: value,
                        );
                  },
                  title: Text(entry.value),
                  subtitle: Text(
                    entry.key == 'preventiveTrendAlert' ||
                            entry.key == 'clinicalWatch'
                        ? 'Alert category'
                        : 'Plan suggestion category',
                  ),
                  contentPadding: EdgeInsets.zero,
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Plan Audit Trail',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.history_toggle_off_rounded, color: primary),
                title: Text(
                  AppLocalizations.of(context).revertLastSuggestedChangeTitle,
                ),
                subtitle: Text(
                  AppLocalizations.of(
                    context,
                  ).revertLatestSuggestedAdjustmentDescription,
                ),
                trailing: _isRevertingSuggestionChange
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.undo_rounded),
                onTap: _isRevertingSuggestionChange
                    ? null
                    : _revertLastSuggestedChange,
              ),
              if (planAuditEntries.isEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppLocalizations.of(context).noAcceptedPlanChangesYetTitle,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(
                      context,
                    ).noAcceptedPlanChangesYetDescription,
                  ),
                ),
              ...planAuditEntries.take(5).map((entry) {
                final summary = _formatLocalizedChangeSummary(
                  entry.changeSummary,
                );
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.fact_check_rounded, color: primary),
                  title: Text('${entry.catName} • ${entry.acceptedBy}'),
                  subtitle: Text(
                    '${_formatAuditTimestamp(entry.acceptedAt)}\n$summary',
                  ),
                  isThreeLine: true,
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Suggestion History',
            children: [
              if (impactEntries.isEmpty)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppLocalizations.of(
                      context,
                    ).noSuggestionImpactHistoryYetTitle,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(
                      context,
                    ).noSuggestionImpactHistoryYetDescription,
                  ),
                ),
              ...impactEntries.take(5).map((entry) {
                final status = entry.isReverted
                    ? AppLocalizations.of(context).impactRevertedBy(
                        entry.revertedBy ??
                            AppLocalizations.of(context).unknownPersonLabel,
                      )
                    : AppLocalizations.of(context).impactActiveChange;
                final before = entry.beforePlan.targetKcalPerDay
                    .toStringAsFixed(0);
                final after = entry.afterPlan.targetKcalPerDay.toStringAsFixed(
                  0,
                );
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.insights_rounded, color: primary),
                  title: Text('${entry.catName} • ${entry.suggestion.title}'),
                  subtitle: Text(
                    '${_formatAuditTimestamp(entry.appliedAt)} • $status\n${AppLocalizations.of(context).impactBeforeAfterKcal(before, after)}',
                  ),
                  isThreeLine: true,
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Appearance',
            children: [
              SwitchListTile(
                value: isDarkMode,
                onChanged: (_) async {
                  await ref.read(themeProvider.notifier).toggleTheme();
                },
                title: const Text('Dark Mode'),
                subtitle: const Text(
                  'Use the same global theme toggle as the app',
                ),
                activeThumbColor: primary,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.languageSectionTitle,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.language_rounded, color: primary),
                title: Text(l10n.appLanguageTitle),
                subtitle: Text(
                  languageLabels[AppLocale.normalizeLanguageCode(
                        appSettings.languageCode,
                      )] ??
                      l10n.languageEnglish,
                  style: TextStyle(color: secondaryText),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _pickLanguage(appSettings.languageCode),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.translate_rounded, color: primary),
                title: Text(l10n.localizedContentScopeTitle),
                subtitle: Text(l10n.localizedContentScopeDescription),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Help',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.menu_book_rounded, color: primary),
                title: const Text('How the app works'),
                subtitle: const Text(
                  'Overview of features and the recommended daily flow',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.howItWorks);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Reports',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.date_range_rounded, color: primary),
                title: const Text('Report Interval'),
                subtitle: Text(
                  appSettings.reportRangeDays == -1
                      ? 'Custom (${appSettings.customReportRangeDays} days)'
                      : '${appSettings.reportRangeDays} days',
                ),
                trailing: DropdownButton<int>(
                  value: appSettings.reportRangeDays,
                  items: const [
                    DropdownMenuItem(value: 7, child: Text('7d')),
                    DropdownMenuItem(value: 14, child: Text('14d')),
                    DropdownMenuItem(value: 30, child: Text('30d')),
                    DropdownMenuItem(value: -1, child: Text('Custom')),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setReportRangeDays(value);
                  },
                ),
              ),
              if (appSettings.reportRangeDays == -1)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.tune_rounded, color: primary),
                  title: Text(
                    AppLocalizations.of(context).customRangeDaysTitle,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(
                      context,
                    ).customRangeDaysValue(appSettings.customReportRangeDays),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    final controller = TextEditingController(
                      text: appSettings.customReportRangeDays.toString(),
                    );
                    final save = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          AppLocalizations.of(context).customRangeTitle,
                        ),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).daysLabel,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              AppLocalizations.of(context).cancelAction,
                            ),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              AppLocalizations.of(context).saveAction,
                            ),
                          ),
                        ],
                      ),
                    );
                    if (save == true) {
                      final days = int.tryParse(controller.text.trim());
                      if (days != null && days > 0) {
                        await ref
                            .read(appSettingsProvider.notifier)
                            .setCustomReportRangeDays(days);
                      }
                    }
                    controller.dispose();
                  },
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.picture_as_pdf_rounded, color: primary),
                title: const Text('PDF Layout'),
                subtitle: Text(appSettings.pdfLayout),
                trailing: DropdownButton<String>(
                  value: appSettings.pdfLayout,
                  items: const [
                    DropdownMenuItem(value: 'compact', child: Text('compact')),
                    DropdownMenuItem(
                      value: 'detailed',
                      child: Text('detailed'),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(appSettingsProvider.notifier)
                        .setPdfConfig(layout: value);
                  },
                ),
              ),
              SwitchListTile(
                value: appSettings.pdfIncludeWeightTrend,
                onChanged: (value) async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setPdfConfig(includeWeightTrend: value);
                },
                contentPadding: EdgeInsets.zero,
                title: const Text('Include weight trend in PDF'),
              ),
              SwitchListTile(
                value: appSettings.pdfIncludeCalorieTable,
                onChanged: (value) async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setPdfConfig(includeCalorieTable: value);
                },
                contentPadding: EdgeInsets.zero,
                title: const Text('Include table in PDF'),
              ),
              SwitchListTile(
                value: appSettings.pdfIncludeVetNotes,
                onChanged: (value) async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setPdfConfig(includeVetNotes: value);
                },
                contentPadding: EdgeInsets.zero,
                title: const Text('Include notes in PDF'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.share_rounded, color: primary),
                title: const Text('Share message'),
                subtitle: Text(
                  appSettings.shareMessageTemplate,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () =>
                    _editShareMessage(appSettings.shareMessageTemplate),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Data Management',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.backup_rounded, color: primary),
                title: const Text('Backup Data'),
                subtitle: const Text(
                  'Export and share a JSON backup snapshot of local app data',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await DataExportService.exportJsonBackup();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _isGeneratingDemoData
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation(primary),
                        ),
                      )
                    : Icon(Icons.auto_awesome_rounded, color: primary),
                title: const Text('Generate Demo Data'),
                subtitle: const Text(
                  'Create one group, one solo cat, foods, plans, meals and weight history',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _isGeneratingDemoData ? null : _generateDemoData,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _isGeneratingStressData
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation(primary),
                        ),
                      )
                    : Icon(Icons.groups_3_rounded, color: primary),
                title: const Text('Generate Stress Test Data'),
                subtitle: const Text(
                  'Create a high-volume scenario to validate many cats/groups UX',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _isGeneratingStressData ? null : _generateStressData,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _isClearingDemoData
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation(primary),
                        ),
                      )
                    : Icon(Icons.delete_sweep_rounded, color: primary),
                title: const Text('Clear Demo Data'),
                subtitle: const Text(
                  'Remove local cats, groups, foods, plans, meals and history',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _isClearingDemoData ? null : _clearDemoData,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, String> _languageLabels(AppLocalizations l10n) {
    return {
      'en': l10n.languageEnglish,
      'pt_BR': l10n.languagePortugueseBrazil,
      'tl': l10n.languageTagalog,
    };
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

import 'package:cat_diet_planner/core/theme/theme_provider.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/features/cat_group/providers/selected_group_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/settings/models/app_settings.dart';
import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:cat_diet_planner/features/settings/services/data_export_service.dart';
import 'package:cat_diet_planner/features/settings/services/demo_data_service.dart';
import 'package:cat_diet_planner/features/settings/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const _languageLabels = {
    'en': 'English',
    'pt': 'Portuguese',
    'tl': 'Tagalog',
  };
  bool _isGeneratingDemoData = false;
  bool _isClearingDemoData = false;

  Future<void> _editSchedule(List<String> currentTimes) async {
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
                      'Meal Reminder Times',
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
                      label: const Text('Add Time'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Save Schedule'),
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
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languageLabels.entries.map((entry) {
              return ListTile(
                title: Text(entry.value),
                trailing: currentLanguage == entry.key
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Generate demo data'),
          content: const Text(
            'This will replace the current local data with a ready-to-test scenario containing one group, one individual cat, foods, plans, meals and weight history.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Generate'),
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

      final seededCat = HiveService.catsBox.values.isNotEmpty
          ? HiveService.catsBox.values.first
          : null;
      ref.read(selectedCatProvider.notifier).state = seededCat;
      ref.read(selectedGroupProvider.notifier).state = null;

      final settings = AppSettings.fromMap(
        HiveService.appSettingsBox.get('settings') as Map<dynamic, dynamic>?,
      );
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
            'Demo data ready: ${summary.groups} group, ${summary.cats} cat, ${summary.foods} foods, ${summary.mealSchedules} schedules.',
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear demo data'),
          content: const Text(
            'This will remove the local demo data from the app, including cats, groups, foods, plans, meals and history.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear'),
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
      ).showSnackBar(const SnackBar(content: Text('Local demo data cleared.')));
    } finally {
      if (mounted) {
        setState(() => _isClearingDemoData = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final themeMode = ref.watch(themeProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final secondaryText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                title: const Text('Edit Schedule'),
                subtitle: Text(appSettings.reminderTimes.join(' • ')),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _editSchedule(appSettings.reminderTimes),
              ),
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
            title: 'Language',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.language_rounded, color: primary),
                title: const Text('App Language'),
                subtitle: Text(
                  _languageLabels[appSettings.languageCode] ?? 'English',
                  style: TextStyle(color: secondaryText),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _pickLanguage(appSettings.languageCode),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Data Management',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.upload_file_rounded, color: primary),
                title: const Text('Export to JSON'),
                subtitle: const Text('Create a portable backup file'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await DataExportService.exportJsonBackup();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.backup_rounded, color: primary),
                title: const Text('Backup Data'),
                subtitle: const Text(
                  'Share a backup snapshot of local app data',
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

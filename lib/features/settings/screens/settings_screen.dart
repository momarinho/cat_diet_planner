import 'package:cat_diet_planner/core/theme/theme_provider.dart';
import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:cat_diet_planner/features/settings/services/data_export_service.dart';
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
                },
                title: const Text('Meal Reminders'),
                subtitle: const Text('Enable alerts for feeding times'),
                activeThumbColor: primary,
                contentPadding: EdgeInsets.zero,
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

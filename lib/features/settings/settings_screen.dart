import 'package:cat_diet_planner/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _mealReminders = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final themeMode = ref.watch(themeProvider);
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
                value: _mealReminders,
                onChanged: (value) {
                  setState(() => _mealReminders = value);
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
                subtitle: const Text('Configure meal reminder times'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Appearance',
            children: [
              SwitchListTile(
                value: isDarkMode,
                onChanged: (_) {
                  ref.read(themeProvider.notifier).toggleTheme();
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
                  'English',
                  style: TextStyle(color: secondaryText),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
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
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.backup_rounded, color: primary),
                title: const Text('Backup Data'),
                subtitle: const Text('Save local app data'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {},
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

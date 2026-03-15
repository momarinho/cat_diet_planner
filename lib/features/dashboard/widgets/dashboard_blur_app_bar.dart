import 'dart:ui';

import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/theme/theme_provider.dart';
import 'package:cat_diet_planner/features/notifications/providers/notifications_provider.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardBlurAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const DashboardBlurAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final notificationCount = ref.watch(notificationCountProvider);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Text(AppLocalizations.of(context).dashboardTitle),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.82),
              border: Border(
                bottom: BorderSide(
                  color: primary.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        if (kDebugMode)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _IconCircleButton(
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _IconCircleButton(
            icon: Icons.settings_outlined,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _IconCircleButton(
                icon: Icons.notifications_outlined,
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.notifications),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: primary.withValues(alpha: 0.10),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: primary),
        ),
      ),
    );
  }
}

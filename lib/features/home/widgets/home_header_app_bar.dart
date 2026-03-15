import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/theme/theme_provider.dart';
import 'package:cat_diet_planner/features/notifications/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeaderAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeHeaderAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final notificationCount = ref.watch(notificationCountProvider);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text('CatDiet Planner'),
      actions: [
        if (kDebugMode)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _CircleIconButton(
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _CircleIconButton(
            icon: Icons.settings_outlined,
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _CircleIconButton(
                icon: Icons.notifications_outlined,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: primary.withValues(alpha: 0.10),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

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

import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/settings/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/neon_button.dart';

class DashboardQuickActions extends ConsumerWidget {
  const DashboardQuickActions({super.key, required this.cat});

  final CatProfile cat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: NeonButton(
            text: 'Scan Food',
            onTap: () async {
              ref.read(selectedCatProvider.notifier).state = cat;
              await NotificationService.setActiveCatContext(
                catId: cat.id,
                catName: cat.name,
              );
              if (!context.mounted) return;
              Navigator.of(context).pushNamed(AppRoutes.scanner);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GhostButton(
            text: 'Log Weight',
            icon: Icons.monitor_weight_outlined,
            onTap: () async {
              ref.read(selectedCatProvider.notifier).state = cat;
              await NotificationService.setActiveCatContext(
                catId: cat.id,
                catName: cat.name,
              );
              if (!context.mounted) return;
              Navigator.of(context).pushNamed(AppRoutes.weightCheckIn);
            },
          ),
        ),
      ],
    );
  }
}

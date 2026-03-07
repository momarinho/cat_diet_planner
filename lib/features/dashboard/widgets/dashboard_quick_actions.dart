import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/neon_button.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: NeonButton(
            text: 'Scan Food',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.scanner),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GhostButton(
            text: 'Log Weight',
            icon: Icons.monitor_weight_outlined,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.weightCheckIn),
          ),
        ),
      ],
    );
  }
}

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
          child: NeonButton(text: 'Scan Food', onTap: () {}),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GhostButton(
            text: 'Log Weight',
            icon: Icons.monitor_weight_outlined,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

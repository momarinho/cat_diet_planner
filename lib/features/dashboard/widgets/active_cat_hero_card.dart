import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card_container.dart';
import '../../../core/widgets/status_badge.dart';

class ActiveCatHeroCard extends StatelessWidget {
  const ActiveCatHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return AppCardContainer(
      child: Column(
        children: [
          Container(
            width: 112,
            height: 112,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primary, width: 4),
            ),
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=400&q=80',
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Luna',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '4.5 kg • 3 Years Old',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          const StatusBadge(
            text: 'ACTIVE PROFILE',
            baseColor: AppTheme.primaryNeon,
          ),
        ],
      ),
    );
  }
}

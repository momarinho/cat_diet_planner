import 'package:flutter/material.dart';

import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/core/utils/cat_photo.dart';
import '../../../core/widgets/app_card_container.dart';

class ActiveCatHeroCard extends StatelessWidget {
  final CatProfile cat;
  final VoidCallback? onEditTap;

  const ActiveCatHeroCard({super.key, required this.cat, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCardContainer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Active Cat',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (onEditTap != null)
                FilledButton.tonalIcon(
                  onPressed: onEditTap,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 44,
            backgroundImage: catPhotoProvider(
              photoPath: cat.photoPath,
              photoBase64: cat.photoBase64,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            cat.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${cat.weight.toStringAsFixed(1)} kg • ${cat.age ~/ 12} Years Old',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

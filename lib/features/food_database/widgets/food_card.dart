import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onEdit;

  const FoodCard({super.key, required this.food, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    final metaLine = [
      if ((food.category ?? '').isNotEmpty) food.category,
      if ((food.flavor ?? '').isNotEmpty) food.flavor,
      if ((food.texture ?? '').isNotEmpty) food.texture,
      if ((food.packageSize ?? '').isNotEmpty) food.packageSize,
      if ((food.servingUnit ?? '').isNotEmpty) 'unit: ${food.servingUnit}',
    ].join(' • ');
    final macroLine = [
      if (food.protein != null) 'P ${food.protein!.toStringAsFixed(1)}%',
      if (food.fat != null) 'F ${food.fat!.toStringAsFixed(1)}%',
      if (food.fiber != null) 'Fi ${food.fiber!.toStringAsFixed(1)}%',
      if (food.moisture != null) 'M ${food.moisture!.toStringAsFixed(1)}%',
      if (food.carbohydrate != null)
        'C ${food.carbohydrate!.toStringAsFixed(1)}%',
      if (food.sodium != null) 'Na ${food.sodium!.toStringAsFixed(0)} mg',
    ].join(' • ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: primary.withValues(alpha: 0.10),
            child: Icon(Icons.pets_rounded, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  food.brand ?? food.manufacturer ?? 'Unknown brand',
                  style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
                ),
                if (metaLine.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    metaLine,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
                if (macroLine.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    macroLine,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
                if ((food.palatabilityNotes ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Palatability: ${food.palatabilityNotes!.trim()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (food.userTags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: food.userTags
                        .take(4)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '#$tag',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${food.kcalPer100g.toStringAsFixed(0)} kcal',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (onEdit != null) ...[
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

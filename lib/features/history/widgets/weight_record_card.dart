import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:flutter/material.dart';

class WeightRecordCard extends StatelessWidget {
  const WeightRecordCard({super.key, required this.record});

  final WeightRecord record;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

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
            child: Icon(Icons.monitor_weight_outlined, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.weight.toStringAsFixed(1)} kg',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(record.date),
                  style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
                ),
                if ((record.weightContext ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Context: ${record.weightContext}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
                if ((record.appetite ?? '').isNotEmpty ||
                    (record.energy ?? '').isNotEmpty ||
                    (record.stool ?? '').isNotEmpty ||
                    (record.vomit ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Appetite: ${record.appetite ?? '-'} • Energy: ${record.energy ?? '-'} • Stool: ${record.stool ?? '-'} • Vomit: ${record.vomit ?? '-'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
                if (record.notes != null &&
                    record.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    record.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
                if ((record.clinicalAssessment ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Assessment: ${record.clinicalAssessment}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
                if ((record.clinicalPlan ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Plan: ${record.clinicalPlan}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (record.alertTriggered)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'ALERT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

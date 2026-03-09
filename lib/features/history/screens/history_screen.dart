import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/history/widgets/history_summary_card.dart';
import 'package:cat_diet_planner/features/history/widgets/weight_record_card.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.weeklyDietReport),
            icon: const Icon(Icons.description_outlined),
            label: const Text('Open Weekly Report'),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: HiveService.weightsBox.listenable(),
            builder: (context, Box<WeightRecord> box, _) {
              final records = box.values.toList()
                ..sort((a, b) => b.date.compareTo(a.date));
              final latest = records.isNotEmpty ? records.first : null;
              final previous = records.length > 1 ? records[1] : null;
              final delta = latest != null && previous != null
                  ? latest.weight - previous.weight
                  : null;

              if (records.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: primary.withValues(alpha: 0.10)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.bar_chart_rounded, size: 42, color: primary),
                      const SizedBox(height: 12),
                      Text(
                        'No history yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Weight records and weekly diet reports will appear here.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: secondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  HistorySummaryCard(
                    latestWeight: latest!.weight,
                    delta: delta,
                  ),
                  const SizedBox(height: 16),
                  ...records.map((record) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: WeightRecordCard(record: record),
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/history/providers/weight_repository_provider.dart';
import 'package:cat_diet_planner/features/history/widgets/history_summary_card.dart';
import 'package:cat_diet_planner/features/history/widgets/weight_record_card.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(selectedCatProvider);
    if (selectedCat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('History')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: AppEmptyState(
              icon: Icons.pets_rounded,
              title: 'No active cat',
              description: 'Select a cat from Home to view weight history.',
            ),
          ),
        ),
      );
    }

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
            valueListenable: ref
                .read(weightRepositoryProvider)
                .weightsListenable(),
            builder: (context, Box<WeightRecord> box, _) {
              final records = ref
                  .read(weightRepositoryProvider)
                  .recordsForCatFromBox(
                    box,
                    selectedCat.id,
                    fallbackHistory: selectedCat.weightHistory,
                    newestFirst: true,
                  );
              final latest = records.isNotEmpty ? records.first : null;
              final previous = records.length > 1 ? records[1] : null;
              final delta = latest != null && previous != null
                  ? latest.weight - previous.weight
                  : null;

              if (records.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.bar_chart_rounded,
                  title: 'No history yet',
                  description:
                      'Weight records and weekly diet reports will appear here.',
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

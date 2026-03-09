import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WeeklyDietReportScreen extends StatelessWidget {
  const WeeklyDietReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Diet Report'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveService.weightsBox.listenable(),
        builder: (context, Box<WeightRecord> box, _) {
          final records = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          final latest = records.isNotEmpty ? records.first : null;
          final oldest = records.length > 1 ? records.last : latest;
          final delta = latest != null && oldest != null
              ? latest.weight - oldest.weight
              : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: primary.withValues(alpha: 0.10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      latest == null
                          ? 'No weight data available'
                          : 'Latest weight: ${latest.weight.toStringAsFixed(1)} kg',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      delta == null
                          ? 'Trend unavailable'
                          : 'Weight change this period: ${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)} kg',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: primary.withValues(alpha: 0.10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calorie Intake',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _CalorieRow(day: 'Mon', intake: 245, goal: 250),
                    const _CalorieRow(day: 'Tue', intake: 235, goal: 250),
                    const _CalorieRow(day: 'Wed', intake: 260, goal: 250),
                    const _CalorieRow(day: 'Thu', intake: 240, goal: 250),
                    const _CalorieRow(day: 'Fri', intake: 250, goal: 250),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: primary.withValues(alpha: 0.10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Veterinary Notes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Weight trend is stable. Continue monitoring appetite and hydration.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download PDF'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_rounded),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CalorieRow extends StatelessWidget {
  const _CalorieRow({
    required this.day,
    required this.intake,
    required this.goal,
  });

  final String day;
  final int intake;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(day)),
          Text('$intake kcal', style: TextStyle(color: secondary)),
          const SizedBox(width: 12),
          Text('Goal $goal', style: TextStyle(color: secondary)),
        ],
      ),
    );
  }
}

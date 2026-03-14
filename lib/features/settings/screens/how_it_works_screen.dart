import 'package:flutter/material.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('How CatDiet Works'),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: const [
          _InfoCard(
            title: '1. Start with profiles',
            items: [
              'Create individual cats with clinical and routine details.',
              'Create groups for operational feeding when needed.',
              'Set goals, preferences and optional weight alerts.',
            ],
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: '2. Build feeding plans',
            items: [
              'Pick one or multiple foods, set portions and meal names.',
              'Customize times, per-meal amounts and start date.',
              'Use weekday/weekend overrides and keep multiple saved plans.',
            ],
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: '3. Run daily routine',
            items: [
              'Track each meal: completed, delayed, skipped or refused.',
              'Log water, treats and supplements in the same daily flow.',
              'Duplicate yesterday routine to speed up repetitive operations.',
            ],
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: '4. Monitor health',
            items: [
              'Record weight check-ins with manual date and context.',
              'Capture appetite, stool, vomiting and energy indicators.',
              'Attach structured clinical notes and follow trend alerts.',
            ],
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: '5. Notifications and reports',
            items: [
              'Set independent reminder times and quiet hours.',
              'Tune sound/intensity by notification type.',
              'Export and share PDF reports with custom range and content.',
            ],
          ),
          SizedBox(height: 12),
          _InfoCard(
            title: 'Current operational limits',
            items: [
              'Up to 10 cats and up to 5 groups.',
              'Everything is local-first with Hive persistence.',
              'Use Settings > Generate Stress Test Data for heavy-load checks.',
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(Icons.circle, size: 6),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

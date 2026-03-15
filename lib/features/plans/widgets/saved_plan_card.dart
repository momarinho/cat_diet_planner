import 'package:flutter/material.dart';

class SavedPlanCard extends StatelessWidget {
  const SavedPlanCard({
    super.key,
    required this.title,
    required this.headline,
    required this.primary,
    required this.primaryMetrics,
    required this.timeline,
    required this.detailMetrics,
    this.tags = const [],
    this.footer,
  });

  final String title;
  final String headline;
  final Color primary;
  final List<SavedPlanTag> tags;
  final List<SavedPlanMetric> primaryMetrics;
  final List<SavedPlanTimelineEntry> timeline;
  final List<SavedPlanMetric> detailMetrics;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = primary.withValues(alpha: 0.12);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.68) ??
        const Color(0xFF7A7678);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary.withValues(alpha: 0.14),
                  primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  headline,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags
                        .map((tag) => _InfoPill(tag: tag, primary: primary))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _SectionTitle(
            title: 'Core targets',
            subtitle: 'Saved values currently being used by this plan.',
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 560;
              final itemWidth = compact
                  ? double.infinity
                  : (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: primaryMetrics
                    .map(
                      (metric) => SizedBox(
                        width: itemWidth,
                        child: _PrimaryMetricCard(
                          metric: metric,
                          primary: primary,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          if (timeline.isNotEmpty) ...[
            const SizedBox(height: 22),
            const _SectionTitle(
              title: 'Meal timeline',
              subtitle: 'Saved schedule and portion split for each meal.',
            ),
            const SizedBox(height: 12),
            ...List.generate(timeline.length, (index) {
              final entry = timeline[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == timeline.length - 1 ? 0 : 10,
                ),
                child: _TimelineCard(entry: entry, primary: primary),
              );
            }),
          ],
          if (detailMetrics.isNotEmpty) ...[
            const SizedBox(height: 22),
            const _SectionTitle(
              title: 'Plan details',
              subtitle: 'Operational context, notes and saved configuration.',
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(22),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 560;
                  final itemWidth = compact
                      ? double.infinity
                      : (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 14,
                    children: detailMetrics
                        .map(
                          (metric) => SizedBox(
                            width: itemWidth,
                            child: _SecondaryMetric(
                              label: metric.label,
                              value: metric.value,
                              secondary: softText,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
          if (footer != null) ...[const SizedBox(height: 18), footer!],
        ],
      ),
    );
  }
}

class SavedPlanMetric {
  const SavedPlanMetric({
    required this.label,
    required this.value,
    this.helper,
    this.icon = Icons.analytics_outlined,
  });

  final String label;
  final String value;
  final String? helper;
  final IconData icon;
}

class SavedPlanTimelineEntry {
  const SavedPlanTimelineEntry({
    required this.index,
    required this.label,
    required this.time,
    required this.value,
    this.caption = 'Scheduled feeding slot',
  });

  final int index;
  final String label;
  final String time;
  final String value;
  final String caption;
}

class SavedPlanTag {
  const SavedPlanTag({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.66),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.tag, required this.primary});

  final SavedPlanTag tag;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tag.icon, size: 16, color: primary),
          const SizedBox(width: 8),
          Text(
            tag.label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryMetricCard extends StatelessWidget {
  const _PrimaryMetricCard({required this.metric, required this.primary});

  final SavedPlanMetric metric;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric.icon, size: 18, color: primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  metric.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.68,
                    ),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            metric.value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          if (metric.helper != null) ...[
            const SizedBox(height: 4),
            Text(
              metric.helper!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.60,
                ),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.entry, required this.primary});

  final SavedPlanTimelineEntry entry;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.66) ??
        const Color(0xFF7A7678);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              entry.index.toString().padLeft(2, '0'),
              style: theme.textTheme.labelLarge?.copyWith(
                color: primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  entry.caption,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.time,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                entry.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecondaryMetric extends StatelessWidget {
  const _SecondaryMetric({
    required this.label,
    required this.value,
    required this.secondary,
  });

  final String label;
  final String value;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

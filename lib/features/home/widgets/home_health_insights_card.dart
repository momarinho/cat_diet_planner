import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card_container.dart';

class HomeHealthInsightsCard extends StatelessWidget {
  const HomeHealthInsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return AppCardContainer(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151931) : const Color(0xFFF8F7FF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.warningYellow,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Health Insights',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3A2327)
                      : const Color(0xFFFFF5EB),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.warningYellow.withValues(alpha: 0.30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weight Alert',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.warningYellow,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '+0.2kg vs last week',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.warningYellow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Milo's weight trend is slightly above the target. Consider reducing portion sizes by 5% for the next 7 days.",
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _bar(16, primary.withValues(alpha: 0.35)),
                        _bar(24, primary.withValues(alpha: 0.45)),
                        _bar(20, primary.withValues(alpha: 0.40)),
                        _bar(28, primary.withValues(alpha: 0.50)),
                        _bar(34, primary.withValues(alpha: 0.60)),
                        _bar(42, primary.withValues(alpha: 0.70)),
                        _bar(52, AppTheme.warningYellow, isLast: true),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 320;

                  final leading = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: primary.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.fitness_center,
                          color: primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Daily Activity',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Goal: 30m playtime',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  final trailing = Column(
                    crossAxisAlignment: isCompact
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Text(
                        '18m / 30m',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: isCompact ? double.infinity : 86,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            minHeight: 7,
                            value: 18 / 30,
                            backgroundColor: primary.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation(primary),
                          ),
                        ),
                      ),
                    ],
                  );

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1D2342)
                          : const Color(0xFFEFF2FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: isCompact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              leading,
                              const SizedBox(height: 12),
                              trailing,
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: leading),
                              const SizedBox(width: 12),
                              trailing,
                            ],
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(double height, Color color, {bool isLast = false}) {
    return Expanded(
      child: Container(
        height: height,
        margin: EdgeInsets.only(right: isLast ? 0 : 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

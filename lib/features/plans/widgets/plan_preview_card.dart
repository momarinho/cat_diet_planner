import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PlanPreviewCard extends StatelessWidget {
  const PlanPreviewCard({
    super.key,
    required this.preview,
    required this.primary,
  });

  final PlanPreviewData preview;
  final Color primary;

  String _formatGoalLabel(AppLocalizations l10n, String? goal) {
    if (goal == null || goal.trim().isEmpty) return l10n.customPlanLabel;
    return goal
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final surface = theme.colorScheme.surface;
    final lineColor = primary.withValues(alpha: 0.12);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.68) ??
        const Color(0xFF7A7678);

    String formatPortion(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: lineColor),
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
          _PreviewHero(
            title: preview.catCount == null
                ? l10n.planPreviewTitle
                : l10n.groupPlanPreviewTitle,
            foodNames: preview.foodNames,
            goalLabel: _formatGoalLabel(l10n, preview.goalLabel),
            startDate: AppFormatters.formatDate(context, preview.startDate),
            mealsPerDay: preview.mealsPerDay,
            catCount: preview.catCount,
            primary: primary,
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: l10n.previewCoreTargetsTitle,
            subtitle: l10n.previewCoreTargetsSubtitle,
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
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _PrimaryMetricCard(
                      label: l10n.metricDailyGoal,
                      value:
                          '${AppFormatters.formatDecimal(context, preview.targetKcalPerDay, decimalDigits: 0)} kcal',
                      helper: l10n.helperEnergyTarget,
                      icon: Icons.local_fire_department_outlined,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _PrimaryMetricCard(
                      label: l10n.metricFoodPerDay,
                      value: formatPortion(preview.portionGramsPerDay),
                      helper: l10n.helperTotalPortion,
                      icon: Icons.scale_outlined,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _PrimaryMetricCard(
                      label: l10n.metricAveragePerMeal,
                      value: formatPortion(preview.portionGramsPerMeal),
                      helper: l10n.helperBaselineSplit,
                      icon: Icons.pie_chart_outline,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _PrimaryMetricCard(
                      label: l10n.metricServingUnit,
                      value:
                          '${preview.portionUnit} (${AppFormatters.formatDecimal(context, preview.portionUnitGrams, decimalDigits: 2)} g)',
                      helper: l10n.helperDisplayUnit,
                      icon: Icons.straighten_outlined,
                      primary: primary,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          _SectionTitle(
            title: l10n.previewMealTimelineTitle,
            subtitle: l10n.previewMealTimelineSubtitle,
          ),
          const SizedBox(height: 12),
          ...List.generate(preview.mealLabels.length, (index) {
            final label = preview.mealLabels[index];
            final time = index < preview.mealTimes.length
                ? AppFormatters.formatStoredMealTime(
                    context,
                    preview.mealTimes[index],
                  )
                : '--:--';
            final portion = index < preview.mealPortionGrams.length
                ? preview.mealPortionGrams[index]
                : 0.0;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == preview.mealLabels.length - 1 ? 0 : 10,
              ),
              child: _MealTimelineCard(
                index: index + 1,
                label: label,
                time: time,
                portion: formatPortion(portion),
                primary: primary,
              ),
            );
          }),
          const SizedBox(height: 22),
          _SectionTitle(
            title: l10n.previewPlanDetailsTitle,
            subtitle: l10n.previewPlanDetailsSubtitle,
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
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: _SecondaryMetric(
                        label: l10n.metricStarts,
                        value: AppFormatters.formatDate(
                          context,
                          preview.startDate,
                        ),
                        secondary: softText,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _SecondaryMetric(
                        label: l10n.metricOverrides,
                        value: preview.dailyOverrides.isEmpty
                            ? l10n.noActiveOverrides
                            : l10n.activeOverridesCount(
                                preview.dailyOverrides.length,
                              ),
                        secondary: softText,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _SecondaryMetric(
                        label: l10n.metricFoods,
                        value: preview.foodNames.join(' + '),
                        secondary: softText,
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _SecondaryMetric(
                        label: l10n.metricNotes,
                        value:
                            preview.operationalNotes?.trim().isNotEmpty == true
                            ? preview.operationalNotes!.trim()
                            : l10n.noNotesYet,
                        secondary: softText,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewHero extends StatelessWidget {
  const _PreviewHero({
    required this.title,
    required this.foodNames,
    required this.goalLabel,
    required this.startDate,
    required this.mealsPerDay,
    required this.catCount,
    required this.primary,
  });

  final String title;
  final List<String> foodNames;
  final String goalLabel;
  final String startDate;
  final int mealsPerDay;
  final int? catCount;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
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
            foodNames.join(' + '),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(
                icon: Icons.flag_outlined,
                label: goalLabel,
                primary: primary,
              ),
              _InfoPill(
                icon: Icons.today_outlined,
                label: l10n.startsTag(startDate),
                primary: primary,
              ),
              _InfoPill(
                icon: Icons.restaurant_menu_outlined,
                label: l10n.mealsPerDayTag(mealsPerDay),
                primary: primary,
              ),
              if (catCount != null)
                _InfoPill(
                  icon: Icons.groups_2_outlined,
                  label: l10n.catsCountTag(catCount!),
                  primary: primary,
                ),
            ],
          ),
        ],
      ),
    );
  }
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
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.primary,
  });

  final IconData icon;
  final String label;
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
          Icon(icon, size: 16, color: primary),
          const SizedBox(width: 8),
          Text(
            label,
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
  const _PrimaryMetricCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
    required this.primary,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;
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
              Icon(icon, size: 18, color: primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
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
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            helper,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.60),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealTimelineCard extends StatelessWidget {
  const _MealTimelineCard({
    required this.index,
    required this.label,
    required this.time,
    required this.portion,
    required this.primary,
  });

  final int index;
  final String label;
  final String time;
  final String portion;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
              index.toString().padLeft(2, '0'),
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
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.scheduledFeedingSlotCaption,
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
                time,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                portion,
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

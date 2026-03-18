import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';
import 'package:cat_diet_planner/features/plans/services/portion/portion_unit_service.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PlanQuickSummaryCard extends StatelessWidget {
  const PlanQuickSummaryCard({
    super.key,
    required this.cat,
    required this.preview,
    required this.primary,
  });

  final CatProfile cat;
  final PlanPreviewData preview;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.66) ??
        const Color(0xFF7A7678);
    final rer = DietCalculatorService.calculateRer(cat.weight);

    String formatKcal(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 0)} kcal';
    }

    String formatGrams(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g';
    }

    String? formatServingUnitsPerDay(FoodPortionSplitData split) {
      if (split.servingUnit == null || split.servingUnitsPerDay == null) {
        return null;
      }
      return '${PortionUnitService.formatPortion(amount: split.servingUnitsPerDay!, unit: split.servingUnit!, decimalsForNonGram: 1)}/day';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primary.withValues(alpha: 0.10),
                child: Icon(Icons.auto_awesome_rounded, color: primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview.foodNames.join(' + '),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: softText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryChip(
                label:
                    '${AppFormatters.formatDecimal(context, cat.weight, decimalDigits: 1)} kg',
                primary: primary,
              ),
              _SummaryChip(
                label: l10n.mealsPerDayTag(preview.mealsPerDay),
                primary: primary,
              ),
              if (preview.goalLabel?.trim().isNotEmpty == true)
                _SummaryChip(label: preview.goalLabel!, primary: primary),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 560;
              final cardWidth = compact
                  ? double.infinity
                  : (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _MetricTile(
                      label: 'RER',
                      value: formatKcal(rer),
                      helper: l10n.kcalLabel,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _MetricTile(
                      label: l10n.metricDailyGoal,
                      value: formatKcal(preview.targetKcalPerDay),
                      helper: l10n.helperEnergyTarget,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _MetricTile(
                      label: l10n.metricFoodPerDay,
                      value: formatGrams(preview.portionGramsPerDay),
                      helper: l10n.helperTotalPortion,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _MetricTile(
                      label: l10n.metricAveragePerMeal,
                      value: formatGrams(preview.portionGramsPerMeal),
                      helper: l10n.helperBaselineSplit,
                      primary: primary,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          if (preview.foodBreakdown.length > 1) ...[
            Text(
              'Food split',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ...preview.foodBreakdown.map(
              (split) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              split.foodName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${AppFormatters.formatDecimal(context, split.sharePercent, decimalDigits: 0)}% kcal share',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: softText,
                              ),
                            ),
                            if (formatServingUnitsPerDay(split)
                                case final units?)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  units,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: softText,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatGrams(split.portionGramsPerDay),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${formatGrams(split.portionGramsPerMeal)} avg/meal',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: softText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            l10n.previewMealTimelineTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.previewMealTimelineSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: softText),
          ),
          const SizedBox(height: 12),
          ...List.generate(preview.mealLabels.length, (index) {
            final portion = index < preview.mealPortionGrams.length
                ? preview.mealPortionGrams[index]
                : 0.0;
            final time = index < preview.mealTimes.length
                ? AppFormatters.formatStoredMealTime(
                    context,
                    preview.mealTimes[index],
                  )
                : '--:--';
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == preview.mealLabels.length - 1 ? 0 : 10,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            preview.mealLabels[index],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            time,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: softText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatGrams(portion),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.helper,
    required this.primary,
  });

  final String label;
  final String value;
  final String helper;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.64) ??
        const Color(0xFF7A7678);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: softText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            helper,
            style: theme.textTheme.bodySmall?.copyWith(color: softText),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.primary});

  final String label;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/features/plans/models/group_totals_summary_data.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class GroupTotalsSummaryCard extends StatelessWidget {
  const GroupTotalsSummaryCard({
    super.key,
    required this.summary,
    required this.primary,
    this.selectedGoalFilter = 'all',
    this.onGoalFilterChanged,
  });

  final GroupTotalsSummaryData summary;
  final Color primary;
  final String selectedGoalFilter;
  final ValueChanged<String>? onGoalFilterChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.66) ??
        const Color(0xFF7A7678);

    String formatKcal(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 0)} kcal';
    }

    String formatGrams(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g';
    }

    final visibleRows = selectedGoalFilter == 'all'
        ? summary.rows
        : summary.rows
              .where((row) => row.goalKey == selectedGoalFilter)
              .toList(growable: false);

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
                child: Icon(Icons.groups_2_outlined, color: primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.groupName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.foodNames.join(' + '),
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
              _SummaryChip(label: '${summary.catCount} cats', primary: primary),
              _SummaryChip(
                label: l10n.mealsPerDayTag(summary.mealsPerDay),
                primary: primary,
              ),
              if (summary.hasWeightedDistribution)
                _SummaryChip(label: 'Weighted split', primary: primary),
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
                      label: l10n.metricDailyGoal,
                      value: formatKcal(summary.totalKcalPerDay),
                      helper: l10n.helperEnergyTarget,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _MetricTile(
                      label: l10n.metricFoodPerDay,
                      value: formatGrams(summary.totalGramsPerDay),
                      helper: l10n.helperTotalPortion,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _MetricTile(
                      label: 'Baseline per cat',
                      value: formatKcal(summary.kcalPerCatBaseline),
                      helper: l10n.helperEnergyTargetPerCat,
                      primary: primary,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _MetricTile(
                      label: l10n.metricGroupPerMeal,
                      value: formatGrams(summary.totalGramsPerMeal),
                      helper: l10n.metricAveragePerMeal,
                      primary: primary,
                    ),
                  ),
                ],
              );
            },
          ),
          if (summary.rows.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: 'All',
                  value: 'all',
                  selectedValue: selectedGoalFilter,
                  onSelected: onGoalFilterChanged,
                ),
                _FilterChip(
                  label: 'Maintain',
                  value: 'maintenance',
                  selectedValue: selectedGoalFilter,
                  onSelected: onGoalFilterChanged,
                ),
                _FilterChip(
                  label: 'Gain',
                  value: 'gain',
                  selectedValue: selectedGoalFilter,
                  onSelected: onGoalFilterChanged,
                ),
                _FilterChip(
                  label: 'Lose',
                  value: 'loss',
                  selectedValue: selectedGoalFilter,
                  onSelected: onGoalFilterChanged,
                ),
              ],
            ),
          ],
          if (visibleRows.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              'Per-cat breakdown',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ...visibleRows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CatRow(
                  row: row,
                  primary: primary,
                  formatKcal: formatKcal,
                  formatGrams: formatGrams,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 18),
            Text(
              summary.rows.isEmpty
                  ? 'Link cats to this group to unlock per-cat totals.'
                  : 'No cats match the selected goal filter.',
              style: theme.textTheme.bodyMedium?.copyWith(color: softText),
            ),
          ],
        ],
      ),
    );
  }
}

class _CatRow extends StatelessWidget {
  const _CatRow({
    required this.row,
    required this.primary,
    required this.formatKcal,
    required this.formatGrams,
  });

  final GroupCatSummaryRowData row;
  final Color primary;
  final String Function(double value) formatKcal;
  final String Function(double value) formatGrams;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.66) ??
        const Color(0xFF7A7678);

    final weightLabel = row.weightKg == null
        ? null
        : '${AppFormatters.formatDecimal(context, row.weightKg!, decimalDigits: 1)} kg';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  row.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (weightLabel != null)
                Text(
                  weightLabel,
                  style: theme.textTheme.bodySmall?.copyWith(color: softText),
                ),
            ],
          ),
          if (row.goalLabel?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              row.goalLabel!,
              style: theme.textTheme.bodySmall?.copyWith(color: softText),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MiniMetric(label: 'kcal/day', value: formatKcal(row.kcalPerDay)),
              _MiniMetric(label: 'g/day', value: formatGrams(row.gramsPerDay)),
              _MiniMetric(
                label: 'g/meal',
                value: formatGrams(row.gramsPerMeal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.64) ??
        const Color(0xFF7A7678);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: softText),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedValue == value,
      onSelected: (_) => onSelected?.call(value),
    );
  }
}

import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/features/cat_group/providers/selected_group_provider.dart';
import 'package:cat_diet_planner/features/cat_group/services/group_feeding_dashboard_filter.dart';
import 'package:cat_diet_planner/features/cat_group/services/group_feeding_shopping_projection.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_groups_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/plans/models/group_totals_summary_data.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/features/plans/repositories/plan_repository.dart';
import 'package:cat_diet_planner/features/plans/services/group_totals_summary_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupFeedingDashboardScreen extends ConsumerStatefulWidget {
  const GroupFeedingDashboardScreen({super.key, required this.initialGroup});

  final CatGroup initialGroup;

  @override
  ConsumerState<GroupFeedingDashboardScreen> createState() =>
      _GroupFeedingDashboardScreenState();
}

class _GroupFeedingDashboardScreenState
    extends ConsumerState<GroupFeedingDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _goalFilter = 'all';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    setState(() {});
  }

  CatGroup _resolveGroup(List<CatGroup> groups) {
    for (final group in groups) {
      if (group.id == widget.initialGroup.id) {
        return group;
      }
    }
    return widget.initialGroup;
  }

  List<FoodItem> _resolveFoods(PlanRepository repository, GroupDietPlan plan) {
    final keys = plan.foodKeys.isNotEmpty ? plan.foodKeys : [plan.foodKey];
    final foods = <FoodItem>[];
    for (final key in keys) {
      final food = repository.findFoodByKey(key);
      if (food != null) {
        foods.add(food);
      }
    }
    return foods;
  }

  List<double> _normalizedMealShares(GroupDietPlan plan) {
    if (plan.mealPortionGrams.isEmpty) {
      return List<double>.filled(
        plan.mealsPerDay,
        100 / plan.mealsPerDay,
        growable: false,
      );
    }

    final total = plan.mealPortionGrams.fold<double>(
      0.0,
      (sum, value) => sum + value,
    );
    if (total <= 0) {
      return List<double>.filled(
        plan.mealsPerDay,
        100 / plan.mealsPerDay,
        growable: false,
      );
    }

    return plan.mealPortionGrams
        .map((portion) => (portion / total) * 100)
        .toList(growable: false);
  }

  void _openGroupPlan(CatGroup group) {
    ref.read(selectedCatProvider.notifier).state = null;
    ref.read(selectedGroupProvider.notifier).state = group;
    Navigator.of(context).pushNamed(AppRoutes.plans);
  }

  void _openCatPlan(CatProfile cat) {
    ref.read(selectedGroupProvider.notifier).state = null;
    ref.read(selectedCatProvider.notifier).state = cat;
    Navigator.of(context).pushNamed(AppRoutes.plans);
  }

  Future<void> _openWeightPicker({
    required CatGroup group,
    required List<GroupCatSummaryRowData> rows,
    required List<CatProfile> cats,
  }) async {
    if (rows.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link cats to this group before logging weights.'),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final sortedRows = [...rows]..sort((a, b) => a.name.compareTo(b.name));
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log weight for ${group.name}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose a cat from this group to open the weight check-in flow.',
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sortedRows.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final row = sortedRows[index];
                      final cat = row.catId == null
                          ? null
                          : _findCatById(cats, row.catId!);
                      return ListTile(
                        enabled: cat != null,
                        leading: const Icon(Icons.monitor_weight_outlined),
                        title: Text(row.name),
                        subtitle: Text(
                          [
                            if (row.weightKg != null)
                              '${AppFormatters.formatDecimal(context, row.weightKg!, decimalDigits: 1)} kg',
                            row.goalLabel ?? row.goalKey,
                          ].join('  •  '),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: cat == null
                            ? null
                            : () {
                                Navigator.of(context).pop();
                                ref.read(selectedGroupProvider.notifier).state =
                                    null;
                                ref.read(selectedCatProvider.notifier).state =
                                    cat;
                                Navigator.of(
                                  this.context,
                                ).pushNamed(AppRoutes.weightCheckIn);
                              },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openShoppingProjection(GroupTotalsSummaryData summary) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _ShoppingProjectionSheet(
        summary: summary,
        primary: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFF7A7678);
    final groups = ref.watch(catGroupsProvider);
    final cats = ref.watch(catProfilesProvider);
    final group = _resolveGroup(groups);
    final repository = ref.read(planRepositoryProvider);

    return ValueListenableBuilder(
      valueListenable: repository.groupPlanListenable(group.id),
      builder: (context, box, child) {
        final plan = repository.getPlanForGroup(group.id);

        return ValueListenableBuilder(
          valueListenable: repository.foodsListenable(),
          builder: (context, foodsBox, child) {
            final summary = plan == null
                ? null
                : _buildSummary(
                    repository: repository,
                    group: group,
                    cats: cats,
                    plan: plan,
                  );

            final visibleRows = summary == null
                ? const <GroupCatSummaryRowData>[]
                : _filterRows(summary.rows);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Group Feeding Dashboard'),
                actions: [
                  IconButton(
                    tooltip: 'Edit group',
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.catGroup, arguments: group);
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _DashboardHero(
                    group: group,
                    summary: summary,
                    secondary: secondary,
                  ),
                  const SizedBox(height: 16),
                  if (summary == null)
                    _MissingPlanCard(
                      primary: primary,
                      onOpenPlans: () => _openGroupPlan(group),
                    )
                  else ...[
                    _DashboardControls(
                      searchController: _searchController,
                      goalFilter: _goalFilter,
                      onGoalFilterChanged: (value) {
                        setState(() => _goalFilter = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (summary.foodBreakdown.isNotEmpty)
                      _FoodBreakdownCard(
                        summary: summary,
                        primary: primary,
                        secondary: secondary,
                      ),
                    if (summary.foodBreakdown.isNotEmpty)
                      const SizedBox(height: 16),
                    if (visibleRows.isEmpty)
                      _EmptyRowsCard(
                        hasSearch: _searchController.text.trim().isNotEmpty,
                        goalFilter: _goalFilter,
                      )
                    else
                      ...visibleRows.map((row) {
                        final cat = row.catId == null
                            ? null
                            : _findCatById(cats, row.catId!);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CatFeedingRowCard(
                            row: row,
                            mealsPerDay: summary.mealsPerDay,
                            onEdit: cat == null
                                ? null
                                : () => _openCatPlan(cat),
                          ),
                        );
                      }),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          onPressed: () => _openGroupPlan(group),
                          icon: const Icon(Icons.restaurant_menu_outlined),
                          label: const Text('Edit Group Plan'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _openWeightPicker(
                            group: group,
                            rows: summary.rows,
                            cats: cats,
                          ),
                          icon: const Icon(Icons.monitor_weight_outlined),
                          label: const Text('Log Weight'),
                        ),
                        OutlinedButton.icon(
                          onPressed: summary.foodBreakdown.isEmpty
                              ? null
                              : () => _openShoppingProjection(summary),
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: const Text('Shopping'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  GroupTotalsSummaryData _buildSummary({
    required PlanRepository repository,
    required CatGroup group,
    required List<CatProfile> cats,
    required GroupDietPlan plan,
  }) {
    final foods = _resolveFoods(repository, plan);
    return GroupTotalsSummaryBuilder.build(
      group: group,
      allCats: cats,
      selectedFoods: foods,
      targetKcalPerCat: plan.targetKcalPerCatPerDay,
      mealsPerDay: plan.mealsPerDay,
      normalizedMealShares: _normalizedMealShares(plan),
      foodSplitPercentByKcal: plan.foodSplitPercentByKcal,
    );
  }

  List<GroupCatSummaryRowData> _filterRows(List<GroupCatSummaryRowData> rows) {
    return GroupFeedingDashboardFilter.apply(
      rows: rows,
      query: _searchController.text,
      goalFilter: _goalFilter,
    );
  }

  CatProfile? _findCatById(List<CatProfile> cats, String id) {
    for (final cat in cats) {
      if (cat.id == id) return cat;
    }
    return null;
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.group,
    required this.summary,
    required this.secondary,
  });

  final CatGroup group;
  final GroupTotalsSummaryData? summary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = group.secondaryColorValue == null
        ? Color(group.colorValue)
        : Color(group.secondaryColorValue!);

    String formatKcal(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 0)} kcal';
    }

    String formatGrams(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g/day';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(group.colorValue), accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            summary == null
                ? 'Set up a saved group feeding plan to unlock daily totals.'
                : 'Managing ${summary!.catCount} cats with a saved feeding plan.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroMetric(
                label: 'Cats',
                value: '${summary?.catCount ?? group.catCount}',
              ),
              _HeroMetric(
                label: 'Daily kcal',
                value: summary == null
                    ? '--'
                    : formatKcal(summary!.totalKcalPerDay),
              ),
              _HeroMetric(
                label: 'Food/day',
                value: summary == null
                    ? '--'
                    : formatGrams(summary!.totalGramsPerDay),
              ),
            ],
          ),
          if (summary != null && summary!.foodNames.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              summary!.foodNames.join(' + '),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.90),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if ((group.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              group.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardControls extends StatelessWidget {
  const _DashboardControls({
    required this.searchController,
    required this.goalFilter,
    required this.onGoalFilterChanged,
  });

  final TextEditingController searchController;
  final String goalFilter;
  final ValueChanged<String> onGoalFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search cats',
            prefixIcon: Icon(Icons.search_rounded),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _GoalChoiceChip(
              label: 'All',
              value: 'all',
              selected: goalFilter,
              onSelected: onGoalFilterChanged,
            ),
            _GoalChoiceChip(
              label: 'Maintain',
              value: 'maintenance',
              selected: goalFilter,
              onSelected: onGoalFilterChanged,
            ),
            _GoalChoiceChip(
              label: 'Gain',
              value: 'gain',
              selected: goalFilter,
              onSelected: onGoalFilterChanged,
            ),
            _GoalChoiceChip(
              label: 'Lose',
              value: 'loss',
              selected: goalFilter,
              onSelected: onGoalFilterChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class _GoalChoiceChip extends StatelessWidget {
  const _GoalChoiceChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: value == selected,
      onSelected: (_) => onSelected(value),
    );
  }
}

class _FoodBreakdownCard extends StatelessWidget {
  const _FoodBreakdownCard({
    required this.summary,
    required this.primary,
    required this.secondary,
  });

  final GroupTotalsSummaryData summary;
  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String formatGrams(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g/day';
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
          Text(
            'Food split',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...summary.foodBreakdown.map((split) {
            final units =
                split.servingUnit == null || split.servingUnitsPerDay == null
                ? null
                : '${AppFormatters.formatDecimal(context, split.servingUnitsPerDay!, decimalDigits: 1)} ${split.servingUnit}/day';
            return Padding(
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
                              color: secondary,
                            ),
                          ),
                          if (units != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                units,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: secondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      formatGrams(split.portionGramsPerDay),
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

class _CatFeedingRowCard extends StatelessWidget {
  const _CatFeedingRowCard({
    required this.row,
    required this.mealsPerDay,
    required this.onEdit,
  });

  final GroupCatSummaryRowData row;
  final int mealsPerDay;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFF7A7678);
    final primary = theme.colorScheme.primary;

    String formatKcal(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 0)} kcal';
    }

    String formatGrams(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g';
    }

    final goalColor = switch (row.goalKey) {
      'gain' => const Color(0xFF2E7D32),
      'loss' => const Color(0xFFC62828),
      _ => const Color(0xFF1565C0),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 540;
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      row.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: goalColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      row.goalLabel ?? row.goalKey,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: goalColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                [
                  if (row.weightKg != null)
                    '${AppFormatters.formatDecimal(context, row.weightKg!, decimalDigits: 1)} kg',
                  formatKcal(row.kcalPerDay),
                  '${formatGrams(row.gramsPerDay)}/day',
                ].join('  •  '),
                style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MiniMetric(
                    label: 'kcal/day',
                    value: formatKcal(row.kcalPerDay),
                  ),
                  _MiniMetric(
                    label: 'g/day',
                    value: formatGrams(row.gramsPerDay),
                  ),
                  _MiniMetric(
                    label: 'g/meal',
                    value: formatGrams(row.gramsPerMeal),
                  ),
                  _MiniMetric(label: 'meals', value: '$mealsPerDay'),
                ],
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: content),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              ),
            ],
          );
        },
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingPlanCard extends StatelessWidget {
  const _MissingPlanCard({required this.primary, required this.onOpenPlans});

  final Color primary;
  final VoidCallback onOpenPlans;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          Text(
            'No saved group plan yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create or save a group plan first to see exact totals, portions, and per-cat breakdown here.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onOpenPlans,
            icon: const Icon(Icons.restaurant_menu_outlined),
            label: const Text('Open Plans'),
          ),
        ],
      ),
    );
  }
}

class _EmptyRowsCard extends StatelessWidget {
  const _EmptyRowsCard({required this.hasSearch, required this.goalFilter});

  final bool hasSearch;
  final String goalFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reason = hasSearch
        ? 'Try a broader search query.'
        : goalFilter == 'all'
        ? 'Link cats to this group to see a per-cat breakdown.'
        : 'No cats match the current goal filter.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(reason, style: theme.textTheme.bodyMedium),
    );
  }
}

class _ShoppingProjectionSheet extends StatelessWidget {
  const _ShoppingProjectionSheet({
    required this.summary,
    required this.primary,
  });

  final GroupTotalsSummaryData summary;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projection = GroupFeedingShoppingProjection.build(
      foodBreakdown: summary.foodBreakdown,
      days: 7,
    );
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFF7A7678);

    String formatGrams(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g';
    }

    String? formatUnits(double? amount, String? unit) {
      if (amount == null || unit == null) return null;
      return '${AppFormatters.formatDecimal(context, amount, decimalDigits: 1)} $unit';
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shopping totals',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${summary.groupName} • 7 day projection',
              style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MiniMetric(
                    label: 'Daily total',
                    value: formatGrams(projection.totalDailyGrams),
                  ),
                  _MiniMetric(
                    label: '7 days',
                    value: formatGrams(projection.totalProjectedGrams),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: projection.entries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = projection.entries[index];
                  final dailyUnits = formatUnits(
                    entry.dailyServingUnits,
                    entry.servingUnit,
                  );
                  final weeklyUnits = formatUnits(
                    entry.projectedServingUnits,
                    entry.servingUnit,
                  );
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      entry.foodName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      [
                        '${formatGrams(entry.dailyGrams)}/day',
                        if (dailyUnits != null) '$dailyUnits/day',
                      ].join('  •  '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondary,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatGrams(entry.projectedGrams),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (weeklyUnits != null)
                          Text(
                            weeklyUnits,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: secondary,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

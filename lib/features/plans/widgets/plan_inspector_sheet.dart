import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/repositories/plan_repository.dart';
import 'package:cat_diet_planner/features/plans/widgets/plan_preview_card.dart';
import 'package:cat_diet_planner/features/plans/widgets/saved_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlanInspectorSheet extends StatelessWidget {
  const PlanInspectorSheet({
    super.key,
    required this.planningForGroup,
    required this.selectedCat,
    required this.selectedGroup,
    required this.individualPreview,
    required this.groupPreview,
    required this.repository,
    required this.primary,
    required this.onSetActivePlanForCat,
    required this.onDeletePlanForCat,
    required this.formatDate,
  });

  final bool planningForGroup;
  final CatProfile? selectedCat;
  final CatGroup? selectedGroup;
  final PlanPreviewData? individualPreview;
  final PlanPreviewData? groupPreview;
  final PlanRepository repository;
  final Color primary;
  final Future<void> Function(CatProfile cat, String planId)
  onSetActivePlanForCat;
  final Future<void> Function(CatProfile cat, String planId) onDeletePlanForCat;
  final String Function(DateTime date) formatDate;

  @override
  Widget build(BuildContext context) {
    final preview = planningForGroup ? groupPreview : individualPreview;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.82,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        planningForGroup
                            ? 'Group Plan Inspector'
                            : 'Plan Inspector',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Preview'),
                  Tab(text: 'Saved'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _PreviewTab(preview: preview, primary: primary),
                    planningForGroup
                        ? _SavedGroupTab(
                            selectedGroup: selectedGroup,
                            repository: repository,
                            primary: primary,
                            formatDate: formatDate,
                          )
                        : _SavedIndividualTab(
                            selectedCat: selectedCat,
                            repository: repository,
                            primary: primary,
                            formatDate: formatDate,
                            onSetActivePlanForCat: onSetActivePlanForCat,
                            onDeletePlanForCat: onDeletePlanForCat,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewTab extends StatelessWidget {
  const _PreviewTab({required this.preview, required this.primary});

  final PlanPreviewData? preview;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (preview == null)
          const AppEmptyState(
            icon: Icons.visibility_outlined,
            title: 'No preview yet',
            description: 'Adjust foods or plan inputs to generate a preview.',
          )
        else
          PlanPreviewCard(preview: preview!, primary: primary),
      ],
    );
  }
}

class _SavedIndividualTab extends StatelessWidget {
  const _SavedIndividualTab({
    required this.selectedCat,
    required this.repository,
    required this.primary,
    required this.formatDate,
    required this.onSetActivePlanForCat,
    required this.onDeletePlanForCat,
  });

  final CatProfile? selectedCat;
  final PlanRepository repository;
  final Color primary;
  final String Function(DateTime date) formatDate;
  final Future<void> Function(CatProfile cat, String planId)
  onSetActivePlanForCat;
  final Future<void> Function(CatProfile cat, String planId) onDeletePlanForCat;

  String _formatGoalLabel(String? goal) {
    if (goal == null || goal.trim().isEmpty) return 'Custom plan';
    return goal
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  String _formatPortion(double value) => '${value.toStringAsFixed(1)} g';

  @override
  Widget build(BuildContext context) {
    if (selectedCat == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppEmptyState(
            icon: Icons.pets_rounded,
            title: 'No cat selected',
            description: 'Select a cat to inspect its saved plans.',
          ),
        ],
      );
    }

    return ValueListenableBuilder(
      valueListenable: repository.individualPlanListenable(),
      builder: (context, Box<DietPlan> _, child) {
        return ValueListenableBuilder(
          valueListenable: repository.catsListenable(),
          builder: (context, _, child) {
            final plans = repository.getPlansForCat(selectedCat!.id)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            final activePlanId = repository.getActivePlanIdForCat(
              selectedCat!.id,
            );
            if (plans.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const AppEmptyState(
                    icon: Icons.folder_open_rounded,
                    title: 'No saved plans yet',
                    description: 'Save a plan to inspect it here.',
                  ),
                ],
              );
            }
            final activePlan = plans.firstWhere(
              (plan) => plan.planId == activePlanId,
              orElse: () => repository.getPlanForCat(selectedCat!.id)!,
            );
            final activePlanFoods = activePlan.foodNames.isEmpty
                ? activePlan.foodName
                : activePlan.foodNames.join(' + ');

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SavedPlanCard(
                  title: 'Saved Individual Plan',
                  headline: activePlanFoods,
                  primary: primary,
                  tags: [
                    SavedPlanTag(
                      icon: Icons.flag_outlined,
                      label: _formatGoalLabel(activePlan.goal),
                    ),
                    SavedPlanTag(
                      icon: Icons.today_outlined,
                      label: 'Starts ${formatDate(activePlan.startDate)}',
                    ),
                    SavedPlanTag(
                      icon: Icons.restaurant_menu_outlined,
                      label: '${activePlan.mealsPerDay} meals/day',
                    ),
                    if (activePlan.planId == activePlanId)
                      const SavedPlanTag(
                        icon: Icons.check_circle_outline,
                        label: 'Active plan',
                      ),
                  ],
                  primaryMetrics: [
                    SavedPlanMetric(
                      label: 'Daily goal',
                      value:
                          '${activePlan.targetKcalPerDay.toStringAsFixed(0)} kcal',
                      helper: 'Energy target',
                      icon: Icons.local_fire_department_outlined,
                    ),
                    SavedPlanMetric(
                      label: 'Food per day',
                      value: _formatPortion(activePlan.portionGramsPerDay),
                      helper: 'Total portion',
                      icon: Icons.scale_outlined,
                    ),
                    SavedPlanMetric(
                      label: 'Average per meal',
                      value: _formatPortion(activePlan.portionGramsPerMeal),
                      helper: 'Baseline split',
                      icon: Icons.pie_chart_outline,
                    ),
                    SavedPlanMetric(
                      label: 'Serving unit',
                      value:
                          '${activePlan.portionUnit} (${activePlan.portionUnitGrams.toStringAsFixed(2)} g)',
                      helper: 'Display unit',
                      icon: Icons.straighten_outlined,
                    ),
                  ],
                  timeline: List.generate(activePlan.mealLabels.length, (
                    index,
                  ) {
                    final time = index < activePlan.mealTimes.length
                        ? activePlan.mealTimes[index]
                        : '--:--';
                    final portion = index < activePlan.mealPortionGrams.length
                        ? activePlan.mealPortionGrams[index]
                        : 0.0;
                    return SavedPlanTimelineEntry(
                      index: index + 1,
                      label: activePlan.mealLabels[index],
                      time: time,
                      value: _formatPortion(portion),
                    );
                  }),
                  detailMetrics: [
                    SavedPlanMetric(
                      label: 'Saved at',
                      value:
                          '${formatDate(activePlan.createdAt)} • ${activePlan.createdAt.hour.toString().padLeft(2, '0')}:${activePlan.createdAt.minute.toString().padLeft(2, '0')}',
                    ),
                    SavedPlanMetric(
                      label: 'Overrides',
                      value: activePlan.dailyOverrides.isEmpty
                          ? 'No active overrides'
                          : '${activePlan.dailyOverrides.length} active overrides',
                    ),
                    SavedPlanMetric(label: 'Foods', value: activePlanFoods),
                    SavedPlanMetric(
                      label: 'Notes',
                      value:
                          activePlan.operationalNotes?.trim().isNotEmpty == true
                          ? activePlan.operationalNotes!.trim()
                          : 'No notes yet',
                    ),
                  ],
                  footer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: activePlan.planId,
                        decoration: const InputDecoration(
                          labelText: 'Active plan',
                          border: OutlineInputBorder(),
                        ),
                        items: plans.where((plan) => plan.planId != null).map((
                          plan,
                        ) {
                          return DropdownMenuItem<String>(
                            value: plan.planId!,
                            child: Text(
                              '${formatDate(plan.startDate)} • ${plan.createdAt.hour.toString().padLeft(2, '0')}:${plan.createdAt.minute.toString().padLeft(2, '0')}',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          await onSetActivePlanForCat(selectedCat!, value);
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: plans
                            .where((plan) => plan.planId != null)
                            .map((plan) {
                              final isActive = plan.planId == activePlanId;
                              return OutlinedButton.icon(
                                onPressed: isActive
                                    ? null
                                    : () async {
                                        await onSetActivePlanForCat(
                                          selectedCat!,
                                          plan.planId!,
                                        );
                                      },
                                icon: const Icon(Icons.check_circle_outline),
                                label: Text(
                                  'Use ${formatDate(plan.startDate)}',
                                ),
                              );
                            })
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: activePlan.planId == null
                              ? null
                              : () async {
                                  await onDeletePlanForCat(
                                    selectedCat!,
                                    activePlan.planId!,
                                  );
                                },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete active plan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SavedGroupTab extends StatelessWidget {
  const _SavedGroupTab({
    required this.selectedGroup,
    required this.repository,
    required this.primary,
    required this.formatDate,
  });

  final CatGroup? selectedGroup;
  final PlanRepository repository;
  final Color primary;
  final String Function(DateTime date) formatDate;

  String _formatPortion(double value) => '${value.toStringAsFixed(1)} g';

  @override
  Widget build(BuildContext context) {
    if (selectedGroup == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppEmptyState(
            icon: Icons.groups_outlined,
            title: 'No group selected',
            description: 'Select a group to inspect its saved plan.',
          ),
        ],
      );
    }

    return ValueListenableBuilder(
      valueListenable: repository.groupPlanListenable(selectedGroup!.id),
      builder: (context, Box<GroupDietPlan> box, _) {
        final plan = box.get(selectedGroup!.id);
        if (plan == null) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const AppEmptyState(
                icon: Icons.folder_open_rounded,
                title: 'No saved group plan',
                description: 'Save a group plan to inspect it here.',
              ),
            ],
          );
        }

        final headline = plan.foodKeys.length > 1
            ? '${plan.foodName} + ${plan.foodKeys.length - 1} more'
            : plan.foodName;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SavedPlanCard(
              title: 'Saved Group Plan',
              headline: headline,
              primary: primary,
              tags: [
                SavedPlanTag(
                  icon: Icons.groups_2_outlined,
                  label: '${plan.catCount} cats',
                ),
                SavedPlanTag(
                  icon: Icons.today_outlined,
                  label: 'Starts ${formatDate(plan.startDate)}',
                ),
                SavedPlanTag(
                  icon: Icons.restaurant_menu_outlined,
                  label: '${plan.mealsPerDay} meals/day',
                ),
              ],
              primaryMetrics: [
                SavedPlanMetric(
                  label: 'Per cat',
                  value:
                      '${plan.targetKcalPerCatPerDay.toStringAsFixed(0)} kcal',
                  helper: 'Energy target per cat',
                  icon: Icons.local_fire_department_outlined,
                ),
                SavedPlanMetric(
                  label: 'Group total',
                  value:
                      '${plan.targetKcalPerGroupPerDay.toStringAsFixed(0)} kcal',
                  helper: 'Combined energy target',
                  icon: Icons.bolt_outlined,
                ),
                SavedPlanMetric(
                  label: 'Group per day',
                  value: _formatPortion(plan.portionGramsPerGroupPerDay),
                  helper: 'Total daily portion',
                  icon: Icons.scale_outlined,
                ),
                SavedPlanMetric(
                  label: 'Group per meal',
                  value: _formatPortion(plan.portionGramsPerGroupPerMeal),
                  helper: 'Average feeding slot',
                  icon: Icons.pie_chart_outline,
                ),
              ],
              timeline: List.generate(plan.mealLabels.length, (index) {
                final time = index < plan.mealTimes.length
                    ? plan.mealTimes[index]
                    : '--:--';
                final portion = index < plan.mealPortionGrams.length
                    ? plan.mealPortionGrams[index]
                    : 0.0;
                return SavedPlanTimelineEntry(
                  index: index + 1,
                  label: plan.mealLabels[index],
                  time: time,
                  value: _formatPortion(portion),
                );
              }),
              detailMetrics: [
                SavedPlanMetric(
                  label: 'Serving unit',
                  value:
                      '${plan.portionUnit} (${plan.portionUnitGrams.toStringAsFixed(2)} g)',
                ),
                SavedPlanMetric(
                  label: 'Distribution',
                  value: plan.perCatShareWeights.isEmpty
                      ? 'Equal split'
                      : 'Unequal (${plan.perCatShareWeights.length} cats)',
                ),
                SavedPlanMetric(
                  label: 'Saved at',
                  value:
                      '${formatDate(plan.createdAt)} • ${plan.createdAt.hour.toString().padLeft(2, '0')}:${plan.createdAt.minute.toString().padLeft(2, '0')}',
                ),
                SavedPlanMetric(
                  label: 'Notes',
                  value: plan.operationalNotes?.trim().isNotEmpty == true
                      ? plan.operationalNotes!.trim()
                      : 'No notes yet',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

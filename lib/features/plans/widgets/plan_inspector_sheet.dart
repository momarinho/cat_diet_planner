import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/repositories/plan_repository.dart';
import 'package:cat_diet_planner/features/plans/widgets/plan_preview_card.dart';
import 'package:cat_diet_planner/features/plans/widgets/saved_plan_card.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

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
                            ? l10n.groupPlanInspectorTitle
                            : l10n.planInspectorTitle,
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
              TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: l10n.previewTab),
                  Tab(text: l10n.savedTab),
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
          AppEmptyState(
            icon: Icons.visibility_outlined,
            title: AppLocalizations.of(context).noPreviewYetTitle,
            description: AppLocalizations.of(context).noPreviewYetDescription,
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
    final l10n = AppLocalizations.of(context);
    String formatPortion(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g';
    }

    if (selectedCat == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppEmptyState(
            icon: Icons.pets_rounded,
            title: AppLocalizations.of(context).noCatSelectedTitle,
            description: AppLocalizations.of(context).noCatSelectedDescription,
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
                  AppEmptyState(
                    icon: Icons.folder_open_rounded,
                    title: AppLocalizations.of(context).noSavedPlansYetTitle,
                    description: AppLocalizations.of(
                      context,
                    ).noSavedPlansYetDescription,
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
                  title: AppLocalizations.of(context).savedIndividualPlanTitle,
                  headline: activePlanFoods,
                  primary: primary,
                  tags: [
                    SavedPlanTag(
                      icon: Icons.flag_outlined,
                      label: _formatGoalLabel(l10n, activePlan.goal),
                    ),
                    SavedPlanTag(
                      icon: Icons.today_outlined,
                      label: l10n.startsTag(formatDate(activePlan.startDate)),
                    ),
                    SavedPlanTag(
                      icon: Icons.restaurant_menu_outlined,
                      label: l10n.mealsPerDayTag(activePlan.mealsPerDay),
                    ),
                    if (activePlan.planId == activePlanId)
                      SavedPlanTag(
                        icon: Icons.check_circle_outline,
                        label: l10n.activePlanTag,
                      ),
                  ],
                  primaryMetrics: [
                    SavedPlanMetric(
                      label: l10n.metricDailyGoal,
                      value:
                          '${AppFormatters.formatDecimal(context, activePlan.targetKcalPerDay, decimalDigits: 0)} kcal',
                      helper: l10n.helperEnergyTarget,
                      icon: Icons.local_fire_department_outlined,
                    ),
                    SavedPlanMetric(
                      label: l10n.metricFoodPerDay,
                      value: formatPortion(activePlan.portionGramsPerDay),
                      helper: l10n.helperTotalPortion,
                      icon: Icons.scale_outlined,
                    ),
                    SavedPlanMetric(
                      label: l10n.metricAveragePerMeal,
                      value: formatPortion(activePlan.portionGramsPerMeal),
                      helper: l10n.helperBaselineSplit,
                      icon: Icons.pie_chart_outline,
                    ),
                    SavedPlanMetric(
                      label: l10n.metricServingUnit,
                      value:
                          '${activePlan.portionUnit} (${AppFormatters.formatDecimal(context, activePlan.portionUnitGrams, decimalDigits: 2)} g)',
                      helper: l10n.helperDisplayUnit,
                      icon: Icons.straighten_outlined,
                    ),
                  ],
                  timeline: List.generate(activePlan.mealLabels.length, (
                    index,
                  ) {
                    final time = index < activePlan.mealTimes.length
                        ? AppFormatters.formatStoredMealTime(
                            context,
                            activePlan.mealTimes[index],
                          )
                        : '--:--';
                    final portion = index < activePlan.mealPortionGrams.length
                        ? activePlan.mealPortionGrams[index]
                        : 0.0;
                    return SavedPlanTimelineEntry(
                      index: index + 1,
                      label: activePlan.mealLabels[index],
                      time: time,
                      value: formatPortion(portion),
                    );
                  }),
                  detailMetrics: [
                    SavedPlanMetric(
                      label: l10n.metricSavedAt,
                      value: AppFormatters.formatDateTime(
                        context,
                        activePlan.createdAt,
                      ),
                    ),
                    SavedPlanMetric(
                      label: l10n.metricOverrides,
                      value: activePlan.dailyOverrides.isEmpty
                          ? l10n.noActiveOverrides
                          : l10n.activeOverridesCount(
                              activePlan.dailyOverrides.length,
                            ),
                    ),
                    SavedPlanMetric(
                      label: l10n.metricFoods,
                      value: activePlanFoods,
                    ),
                    SavedPlanMetric(
                      label: l10n.metricNotes,
                      value:
                          activePlan.operationalNotes?.trim().isNotEmpty == true
                          ? activePlan.operationalNotes!.trim()
                          : l10n.noNotesYet,
                    ),
                  ],
                  footer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: activePlan.planId,
                        decoration: InputDecoration(
                          labelText: l10n.activePlanLabelText,
                          border: OutlineInputBorder(),
                        ),
                        items: plans.where((plan) => plan.planId != null).map((
                          plan,
                        ) {
                          return DropdownMenuItem<String>(
                            value: plan.planId!,
                            child: Text(
                              AppFormatters.formatDateTime(
                                context,
                                plan.createdAt,
                              ),
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
                                  l10n.usePlanAction(
                                    formatDate(plan.startDate),
                                  ),
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
                          label: Text(l10n.deleteActivePlanAction),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String formatPortion(double value) {
      return '${AppFormatters.formatDecimal(context, value, decimalDigits: 1)} g';
    }

    if (selectedGroup == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppEmptyState(
            icon: Icons.groups_outlined,
            title: AppLocalizations.of(context).noGroupSelectedTitle,
            description: AppLocalizations.of(
              context,
            ).noGroupSelectedDescription,
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
              AppEmptyState(
                icon: Icons.folder_open_rounded,
                title: AppLocalizations.of(context).noSavedGroupPlanTitle,
                description: AppLocalizations.of(
                  context,
                ).noSavedGroupPlanDescription,
              ),
            ],
          );
        }

        final headline = plan.foodKeys.length > 1
            ? '${plan.foodName} ${l10n.plusMoreFoods(plan.foodKeys.length - 1)}'
            : plan.foodName;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SavedPlanCard(
              title: AppLocalizations.of(context).savedGroupPlanTitle,
              headline: headline,
              primary: primary,
              tags: [
                SavedPlanTag(
                  icon: Icons.groups_2_outlined,
                  label: l10n.catsCountTag(plan.catCount),
                ),
                SavedPlanTag(
                  icon: Icons.today_outlined,
                  label: l10n.startsTag(formatDate(plan.startDate)),
                ),
                SavedPlanTag(
                  icon: Icons.restaurant_menu_outlined,
                  label: l10n.mealsPerDayTag(plan.mealsPerDay),
                ),
              ],
              primaryMetrics: [
                SavedPlanMetric(
                  label: l10n.metricPerCat,
                  value:
                      '${AppFormatters.formatDecimal(context, plan.targetKcalPerCatPerDay, decimalDigits: 0)} kcal',
                  helper: l10n.helperEnergyTargetPerCat,
                  icon: Icons.local_fire_department_outlined,
                ),
                SavedPlanMetric(
                  label: l10n.metricGroupTotal,
                  value:
                      '${AppFormatters.formatDecimal(context, plan.targetKcalPerGroupPerDay, decimalDigits: 0)} kcal',
                  helper: l10n.helperCombinedEnergyTarget,
                  icon: Icons.bolt_outlined,
                ),
                SavedPlanMetric(
                  label: l10n.metricGroupPerDay,
                  value: formatPortion(plan.portionGramsPerGroupPerDay),
                  helper: l10n.helperTotalPortion,
                  icon: Icons.scale_outlined,
                ),
                SavedPlanMetric(
                  label: l10n.metricGroupPerMeal,
                  value: formatPortion(plan.portionGramsPerGroupPerMeal),
                  helper: l10n.helperAverageFeedingSlot,
                  icon: Icons.pie_chart_outline,
                ),
              ],
              timeline: List.generate(plan.mealLabels.length, (index) {
                final time = index < plan.mealTimes.length
                    ? AppFormatters.formatStoredMealTime(
                        context,
                        plan.mealTimes[index],
                      )
                    : '--:--';
                final portion = index < plan.mealPortionGrams.length
                    ? plan.mealPortionGrams[index]
                    : 0.0;
                return SavedPlanTimelineEntry(
                  index: index + 1,
                  label: plan.mealLabels[index],
                  time: time,
                  value: formatPortion(portion),
                );
              }),
              detailMetrics: [
                SavedPlanMetric(
                  label: l10n.metricServingUnit,
                  value:
                      '${plan.portionUnit} (${AppFormatters.formatDecimal(context, plan.portionUnitGrams, decimalDigits: 2)} g)',
                ),
                SavedPlanMetric(
                  label: l10n.metricDistribution,
                  value: plan.perCatShareWeights.isEmpty
                      ? l10n.equalSplitLabel
                      : l10n.unequalSplitLabel(plan.perCatShareWeights.length),
                ),
                SavedPlanMetric(
                  label: l10n.metricSavedAt,
                  value: AppFormatters.formatDateTime(context, plan.createdAt),
                ),
                SavedPlanMetric(
                  label: l10n.metricNotes,
                  value: plan.operationalNotes?.trim().isNotEmpty == true
                      ? plan.operationalNotes!.trim()
                      : l10n.noNotesYet,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

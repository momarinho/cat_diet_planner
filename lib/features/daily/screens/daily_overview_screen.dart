import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/features/cat_group/providers/selected_group_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/daily/providers/daily_schedule_repository_provider.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_header_app_bar.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_metrics_row.dart';
import 'package:cat_diet_planner/features/daily/widgets/daily_schedule_section.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyOverviewScreen extends ConsumerWidget {
  const DailyOverviewScreen({super.key});

  Map<String, String> _mealContextOptionsIndividual(AppLocalizations l10n) => {
    'completed': l10n.completedOption,
    'partial': l10n.partialOption,
    'delayed': l10n.delayedOption,
    'refused': l10n.refusedOption,
    'reduced': l10n.reducedAppetiteOption,
    'skipped': l10n.skippedOption,
  };

  Map<String, String> _mealContextOptionsGroup(AppLocalizations l10n) => {
    'completed': l10n.completedOption,
    'partial': l10n.partialOption,
    'delayed': l10n.delayedOption,
    'skipped': l10n.skippedOption,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedGroup = ref.watch(selectedGroupProvider);
    final selectedCat = ref.watch(selectedCatProvider);
    final planRepository = ref.read(planRepositoryProvider);
    final scheduleRepository = ref.read(dailyScheduleRepositoryProvider);

    if (selectedGroup == null && selectedCat == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppEmptyState(
              icon: Icons.today_outlined,
              title: l10n.nothingSelectedYetTitle,
              description: l10n.dailySelectionRequiredDescription,
            ),
          ),
        ),
      );
    }

    if (selectedGroup != null) {
      return ValueListenableBuilder(
        valueListenable: planRepository.groupPlanListenable(selectedGroup.id),
        builder: (context, _, _) {
          final plan = planRepository.getPlanForGroup(selectedGroup.id);

          if (plan == null) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AppEmptyState(
                    icon: Icons.calendar_view_day_outlined,
                    title: l10n.noGroupPlanYetTitle,
                    description: l10n.saveGroupPlanBeforeDailyDescription(
                      selectedGroup.name,
                    ),
                  ),
                ),
              ),
            );
          }

          if (!DailyMealScheduleService.isPlanActiveOn(
            startDate: plan.startDate,
          )) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AppEmptyState(
                    icon: Icons.event_available_rounded,
                    title: l10n.groupPlanNotActiveYetTitle,
                    description: l10n.groupPlanStartsOnDescription(
                      selectedGroup.name,
                      AppFormatters.formatDate(context, plan.startDate),
                    ),
                  ),
                ),
              ),
            );
          }

          DailyMealScheduleService.ensureTodayGroupSchedule(
            group: selectedGroup,
            plan: plan,
          );
          final scheduleKey = DailyMealScheduleService.todayKeyForGroup(
            selectedGroup.id,
          );

          return ValueListenableBuilder(
            valueListenable: scheduleRepository.mealsListenable(
              keys: [scheduleKey],
            ),
            builder: (context, _, _) {
              final schedule =
                  DailyMealScheduleService.loadTodayForGroup(
                    selectedGroup.id,
                  ) ??
                  DailyMealScheduleService.ensureTodayGroupSchedule(
                    group: selectedGroup,
                    plan: plan,
                  );
              final items = ((schedule['items'] as List?) ?? const [])
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList();

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 132),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyHeaderAppBar(
                        titleName: selectedGroup.name,
                        isGroup: true,
                      ),
                      const SizedBox(height: 24),
                      DailyMetricsRow(
                        primaryMetricTitle: l10n.groupSizeMetricTitle,
                        primaryMetricValue: '${selectedGroup.catCount}',
                        primaryMetricUnit: l10n.catsUnit,
                        secondaryMetricTitle:
                            l10n.dailyGoalMetricTitleUppercase,
                        secondaryMetricValue: plan.targetKcalPerGroupPerDay
                            .toStringAsFixed(0),
                        secondaryMetricUnit: l10n.kcalLabel,
                      ),
                      const SizedBox(height: 34),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await DailyMealScheduleService.duplicateYesterdayForGroup(
                              selectedGroup.id,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.yesterdayRoutineDuplicatedMessage,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy_all_rounded),
                          label: Text(l10n.duplicateYesterdayRoutineAction),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DailyScheduleSection(
                        title: l10n.todaysGroupScheduleTitle,
                        showWeightCheckIn: false,
                        schedule: items,
                        onMealToggle: (item) async {
                          await _openEntryLogSheet(
                            context,
                            initialItem: item,
                            mealContextOptions: _mealContextOptionsGroup(l10n),
                            onSave:
                                ({
                                  required bool completed,
                                  required String context,
                                  required String notes,
                                  String? time,
                                  double? quantity,
                                  String? quantityUnit,
                                }) {
                                  return DailyMealScheduleService.updateGroupMealEntry(
                                    groupId: selectedGroup.id,
                                    mealId: item['id'] as String,
                                    completed: completed,
                                    context: context,
                                    notes: notes,
                                    time: time,
                                    quantity: quantity,
                                    quantityUnit: quantityUnit,
                                  );
                                },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    if (selectedCat == null) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: planRepository.individualPlanListenable(),
      builder: (context, _, _) {
        final plan = planRepository.getPlanForCat(selectedCat.id);

        if (plan == null) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppEmptyState(
                  icon: Icons.calendar_view_day_outlined,
                  title: l10n.noMealPlanYetTitle,
                  description: l10n.savePlanBeforeDailyDescription(
                    selectedCat.name,
                  ),
                ),
              ),
            ),
          );
        }

        if (!DailyMealScheduleService.isPlanActiveOn(
          startDate: plan.startDate,
        )) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppEmptyState(
                  icon: Icons.event_available_rounded,
                  title: l10n.planNotActiveYetTitle,
                  description: l10n.planStartsOnDescription(
                    selectedCat.name,
                    AppFormatters.formatDate(context, plan.startDate),
                  ),
                ),
              ),
            ),
          );
        }

        DailyMealScheduleService.ensureTodaySchedule(
          cat: selectedCat,
          plan: plan,
        );
        final scheduleKey = DailyMealScheduleService.todayKeyForCat(
          selectedCat.id,
        );

        return ValueListenableBuilder(
          valueListenable: scheduleRepository.mealsListenable(
            keys: [scheduleKey],
          ),
          builder: (context, _, _) {
            final schedule =
                DailyMealScheduleService.loadTodayForCat(selectedCat.id) ??
                DailyMealScheduleService.ensureTodaySchedule(
                  cat: selectedCat,
                  plan: plan,
                );
            final items = ((schedule['items'] as List?) ?? const [])
                .map((item) => Map<String, dynamic>.from(item as Map))
                .toList();

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 132),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DailyHeaderAppBar(
                      titleName: selectedCat.name,
                      photoPath: selectedCat.photoPath,
                      photoBase64: selectedCat.photoBase64,
                    ),
                    const SizedBox(height: 24),
                    DailyMetricsRow(
                      primaryMetricTitle: l10n.currentWeightMetricTitle,
                      primaryMetricValue: selectedCat.weight.toStringAsFixed(1),
                      primaryMetricUnit: l10n.kgUnit,
                      secondaryMetricTitle: l10n.dailyGoalMetricTitleUppercase,
                      secondaryMetricValue: plan.targetKcalPerDay
                          .toStringAsFixed(0),
                      secondaryMetricUnit: l10n.kcalLabel,
                    ),
                    const SizedBox(height: 34),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await DailyMealScheduleService.duplicateYesterdayForCat(
                            selectedCat.id,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.yesterdayRoutineDuplicatedMessage,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy_all_rounded),
                        label: Text(l10n.duplicateYesterdayRoutineAction),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DailyScheduleSection(
                      schedule: items,
                      onMealToggle: (item) async {
                        await _openEntryLogSheet(
                          context,
                          initialItem: item,
                          mealContextOptions: _mealContextOptionsIndividual(
                            l10n,
                          ),
                          onSave:
                              ({
                                required bool completed,
                                required String context,
                                required String notes,
                                String? time,
                                double? quantity,
                                String? quantityUnit,
                              }) {
                                return DailyMealScheduleService.updateMealEntry(
                                  catId: selectedCat.id,
                                  mealId: item['id'] as String,
                                  completed: completed,
                                  context: context,
                                  notes: notes,
                                  time: time,
                                  quantity: quantity,
                                  quantityUnit: quantityUnit,
                                );
                              },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openEntryLogSheet(
    BuildContext context, {
    required Map<String, dynamic> initialItem,
    required Map<String, String> mealContextOptions,
    required Future<void> Function({
      required bool completed,
      required String context,
      required String notes,
      String? time,
      double? quantity,
      String? quantityUnit,
    })
    onSave,
  }) async {
    final l10n = AppLocalizations.of(context);
    final entryType = initialItem['type']?.toString() ?? 'meal';
    final isMeal = entryType == 'meal';
    final initialContext = isMeal
        ? (initialItem['mealContext']?.toString() ??
              ((initialItem['completed'] == true) ? 'completed' : 'delayed'))
        : (initialItem['mealContext']?.toString() ?? 'logged');
    final initialTime = initialItem['time']?.toString() ?? '';
    final initialQuantity =
        (initialItem['quantity'] as num?)?.toDouble() ?? 0.0;
    final initialQuantityUnit =
        initialItem['quantityUnit']?.toString() ??
        (entryType == 'water'
            ? 'ml'
            : entryType == 'snacks'
            ? 'g'
            : 'dose');
    final notesController = TextEditingController(
      text: initialItem['mealNotes']?.toString() ?? '',
    );
    final quantityController = TextEditingController(
      text: initialQuantity > 0 ? initialQuantity.toStringAsFixed(0) : '',
    );
    var selectedContext = initialContext;
    var selectedTime = initialTime;
    var selectedQuantityUnit = initialQuantityUnit;

    final shouldSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      initialItem['title']?.toString() ?? l10n.genericMealTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isMeal) ...[
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: mealContextOptions.entries.map((entry) {
                          return ChoiceChip(
                            label: Text(entry.value),
                            selected: selectedContext == entry.key,
                            onSelected: (_) {
                              setModalState(() => selectedContext = entry.key);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.mealTimeTitle),
                        subtitle: Text(
                          selectedTime.trim().isEmpty
                              ? l10n.unsetLabel
                              : AppFormatters.formatStoredMealTime(
                                  context,
                                  selectedTime,
                                ),
                        ),
                        trailing: const Icon(Icons.schedule_rounded),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _parseStoredTime(selectedTime),
                          );
                          if (picked == null) return;
                          if (!context.mounted) return;
                          setModalState(() {
                            selectedTime = picked.format(context);
                          });
                        },
                      ),
                    ] else ...[
                      TextField(
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: l10n.quantityLabel,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: selectedQuantityUnit,
                        decoration: InputDecoration(
                          labelText: l10n.unitLabel,
                          border: OutlineInputBorder(),
                        ),
                        items: const ['ml', 'g', 'dose']
                            .map(
                              (unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setModalState(() => selectedQuantityUnit = value);
                        },
                      ),
                      const SizedBox(height: 14),
                    ],
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.observationsLabel,
                        hintText: l10n.dailyObservationsHint,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(l10n.saveLogAction),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (shouldSave == true) {
      final parsedQuantity = double.tryParse(
        quantityController.text.trim().replaceAll(',', '.'),
      );
      final completed = isMeal
          ? selectedContext == 'completed'
          : (parsedQuantity ?? 0) > 0;
      await onSave(
        completed: completed,
        context: selectedContext,
        notes: notesController.text,
        time: isMeal ? selectedTime : null,
        quantity: isMeal ? null : parsedQuantity,
        quantityUnit: isMeal ? null : selectedQuantityUnit,
      );
    }
    notesController.dispose();
    quantityController.dispose();
  }

  TimeOfDay _parseStoredTime(String value) {
    final sanitized = value.trim().toUpperCase();
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    ).firstMatch(sanitized);
    if (match == null) return const TimeOfDay(hour: 8, minute: 0);
    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    final period = match.group(3);
    if (hour == null || minute == null || period == null) {
      return const TimeOfDay(hour: 8, minute: 0);
    }
    var convertedHour = hour % 12;
    if (period == 'PM') convertedHour += 12;
    return TimeOfDay(hour: convertedHour, minute: minute);
  }
}

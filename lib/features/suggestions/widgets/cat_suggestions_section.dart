import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/daily/providers/daily_schedule_repository_provider.dart';
import 'package:cat_diet_planner/features/history/providers/weight_repository_provider.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_persistence_provider.dart';
import 'package:cat_diet_planner/features/suggestions/services/plan_adjustment_service.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_engine_provider.dart';
import 'package:cat_diet_planner/features/suggestions/widgets/suggestion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatSuggestionsSection extends ConsumerWidget {
  const CatSuggestionsSection({
    super.key,
    required this.cat,
    required this.title,
    this.maxItems = 3,
  });

  final CatProfile cat;
  final String title;
  final int maxItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);
    final planRepository = ref.read(planRepositoryProvider);
    final weightRepository = ref.read(weightRepositoryProvider);
    final scheduleRepository = ref.read(dailyScheduleRepositoryProvider);
    final engine = ref.read(suggestionEngineProvider);
    final adjustmentService = ref.read(planAdjustmentServiceProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final decisions = ref.watch(suggestionDecisionProvider);
    final decisionNotifier = ref.read(suggestionDecisionProvider.notifier);
    final today = DateTime.now();
    final mealKeys = List<String>.generate(
      7,
      (index) => scheduleRepository.catDayKey(
        cat.id,
        DateTime(
          today.year,
          today.month,
          today.day,
        ).subtract(Duration(days: index)),
      ),
      growable: false,
    );

    return ValueListenableBuilder(
      valueListenable: planRepository.individualPlanListenable(),
      builder: (context, _, _) {
        final activePlan = planRepository.getPlanForCat(cat.id);

        return ValueListenableBuilder(
          valueListenable: weightRepository.weightsListenable(),
          builder: (context, box, _) {
            final records = weightRepository.recordsForCatFromBox(
              box,
              cat.id,
              fallbackHistory: cat.weightHistory,
              newestFirst: false,
            );

            return ValueListenableBuilder(
              valueListenable: scheduleRepository.mealsListenable(
                keys: mealKeys,
              ),
              builder: (context, scheduleBox, child) {
                final schedules = mealKeys
                    .map(scheduleRepository.readSchedule)
                    .whereType<Map<String, dynamic>>()
                    .toList(growable: false);
                final generated = engine.generateForCat(
                  cat: cat,
                  weightRecords: records,
                  recentMealSchedules: schedules,
                  activePlan: activePlan,
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .read(suggestionPersistenceServiceProvider)
                      .saveGeneratedForCat(
                        catId: cat.id,
                        suggestions: generated,
                      );
                  ref.invalidate(generatedSuggestionsProvider(cat.id));
                });
                final visible = generated
                    .where(
                      (suggestion) =>
                          decisions[suggestion.id] !=
                          SuggestionDecision.ignored,
                    )
                    .take(maxItems)
                    .toList(growable: false);

                if (visible.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.10),
                      ),
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
                        const SizedBox(height: 6),
                        Text(
                          'No active suggestions right now. Keep logging meals and weight to improve guidance.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: secondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
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
                      const SizedBox(height: 12),
                      ...visible.map((suggestion) {
                        final decision = decisions[suggestion.id];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SuggestionCard(
                            suggestion: suggestion,
                            decision: decision,
                            autoApplyEnabled: appSettings.suggestionAutoApply,
                            onAccept: () async {
                              if (!adjustmentService.requiresPlanChange(
                                suggestion,
                              )) {
                                decisionNotifier.accept(suggestion.id);
                                return;
                              }

                              final acceptedBy =
                                  await _showPlanChangeConfirmationDialog(
                                    context: context,
                                    catName: cat.name,
                                    suggestion: suggestion,
                                  );
                              if (acceptedBy == null || !context.mounted) {
                                return;
                              }

                              final result = await adjustmentService
                                  .applySuggestion(
                                    cat: cat,
                                    suggestion: suggestion,
                                    acceptedBy: acceptedBy,
                                  );
                              if (!context.mounted) return;

                              if (result.changed) {
                                decisionNotifier.accept(suggestion.id);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result.message ??
                                        (result.changed
                                            ? 'Plan updated after confirmation.'
                                            : 'Suggestion recorded without plan changes.'),
                                  ),
                                ),
                              );
                            },
                            onDefer: () =>
                                decisionNotifier.defer(suggestion.id),
                            onIgnore: () =>
                                decisionNotifier.ignore(suggestion.id),
                            onRestore: () =>
                                decisionNotifier.clear(suggestion.id),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

Future<String?> _showPlanChangeConfirmationDialog({
  required BuildContext context,
  required String catName,
  required SmartSuggestion suggestion,
}) async {
  final controller = TextEditingController();
  var validationMessage = '';

  final acceptedBy = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text('Confirm plan change'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Apply this suggestion to $catName only after review.'),
                const SizedBox(height: 8),
                Text(
                  suggestion.recommendedAction,
                  style: Theme.of(
                    dialogContext,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Responsible person',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Type who approved this change',
                    errorText: validationMessage.isEmpty
                        ? null
                        : validationMessage,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final value = controller.text.trim();
                  if (value.isEmpty) {
                    setDialogState(() {
                      validationMessage = 'Approval identity is required.';
                    });
                    return;
                  }
                  Navigator.of(dialogContext).pop(value);
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    },
  );

  controller.dispose();
  return acceptedBy;
}

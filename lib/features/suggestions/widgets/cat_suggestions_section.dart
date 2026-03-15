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
import 'package:cat_diet_planner/features/suggestions/utils/suggestion_reason_label.dart';
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
                          child: _SuggestionCard(
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

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.decision,
    required this.autoApplyEnabled,
    required this.onAccept,
    required this.onDefer,
    required this.onIgnore,
    required this.onRestore,
  });

  final SmartSuggestion suggestion;
  final SuggestionDecision? decision;
  final bool autoApplyEnabled;
  final Future<void> Function() onAccept;
  final VoidCallback onDefer;
  final VoidCallback onIgnore;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.70) ??
        const Color(0xFF7A7678);
    final confidenceLabel =
        '${(suggestion.confidenceScore * 100).toStringAsFixed(0)}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surface.withValues(alpha: 0.72)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  suggestionTypeLabel(suggestion.type),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Confidence $confidenceLabel',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (decision != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: switch (decision!) {
                      SuggestionDecision.accepted => const Color(
                        0xFF31C178,
                      ).withValues(alpha: 0.15),
                      SuggestionDecision.deferred => const Color(
                        0xFFE48A18,
                      ).withValues(alpha: 0.15),
                      SuggestionDecision.ignored => const Color(
                        0xFF7B8DA8,
                      ).withValues(alpha: 0.15),
                    },
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    switch (decision!) {
                      SuggestionDecision.accepted => 'Accepted',
                      SuggestionDecision.deferred => 'Deferred',
                      SuggestionDecision.ignored => 'Ignored',
                    },
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            suggestion.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            suggestion.summary,
            style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
          ),
          const SizedBox(height: 8),
          Text(
            suggestion.recommendedAction,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (suggestion.reasonCodes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Why this suggestion:',
              style: theme.textTheme.labelLarge?.copyWith(
                color: secondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            ...suggestion.reasonCodes.take(3).map((code) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        suggestionReasonLabel(code),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: onAccept,
                child: const Text('Accept'),
              ),
              FilledButton.tonal(
                onPressed: onDefer,
                child: const Text('Defer'),
              ),
              OutlinedButton(onPressed: onIgnore, child: const Text('Ignore')),
              if (decision != null)
                TextButton(onPressed: onRestore, child: const Text('Restore')),
            ],
          ),
          if (!autoApplyEnabled) ...[
            const SizedBox(height: 8),
            Text(
              'Auto-apply is disabled. Plan changes always require confirmation.',
              style: theme.textTheme.bodySmall?.copyWith(color: secondary),
            ),
          ],
        ],
      ),
    );
  }
}

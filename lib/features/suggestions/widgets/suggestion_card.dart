import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
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

  String _suggestionTypeLabel(AppLocalizations l10n) {
    return switch (suggestion.type) {
      SuggestionType.kcalAdjustment => l10n.suggestionTypeKcal,
      SuggestionType.scheduleAdjustment => l10n.suggestionTypeSchedule,
      SuggestionType.portionSplitAdjustment => l10n.suggestionTypePortions,
      SuggestionType.preventiveTrendAlert => l10n.suggestionTypePreventiveAlert,
      SuggestionType.clinicalWatch => l10n.suggestionTypeClinicalWatch,
    };
  }

  String _reasonLabel(AppLocalizations l10n, String code) {
    return switch (code) {
      SuggestionReasonCodes.weightTrendUp => l10n.reasonWeightTrendUp,
      SuggestionReasonCodes.weightTrendDown => l10n.reasonWeightTrendDown,
      SuggestionReasonCodes.outOfGoalMax => l10n.reasonOutOfGoalMax,
      SuggestionReasonCodes.outOfGoalMin => l10n.reasonOutOfGoalMin,
      SuggestionReasonCodes.approachingGoalMax => l10n.reasonApproachingGoalMax,
      SuggestionReasonCodes.approachingGoalMin => l10n.reasonApproachingGoalMin,
      SuggestionReasonCodes.adherenceLow => l10n.reasonAdherenceLow,
      SuggestionReasonCodes.refusalFrequent => l10n.reasonRefusalFrequent,
      SuggestionReasonCodes.delayedFrequent => l10n.reasonDelayedFrequent,
      SuggestionReasonCodes.appetiteReduced => l10n.reasonAppetiteReduced,
      SuggestionReasonCodes.appetitePoor => l10n.reasonAppetitePoor,
      SuggestionReasonCodes.vomitFrequent => l10n.reasonVomitFrequent,
      SuggestionReasonCodes.stoolDiarrhea => l10n.reasonStoolDiarrhea,
      SuggestionReasonCodes.clinicalConditionPresent =>
        l10n.reasonClinicalConditionPresent,
      SuggestionReasonCodes.weightAlertTriggered =>
        l10n.reasonWeightAlertTriggered,
      SuggestionReasonCodes.lowEvidence => l10n.reasonLowEvidence,
      _ => code,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  _suggestionTypeLabel(l10n),
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
                  l10n.suggestionConfidenceLabel(confidenceLabel),
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
                      SuggestionDecision.accepted =>
                        l10n.suggestionAcceptedStatus,
                      SuggestionDecision.deferred =>
                        l10n.suggestionDeferredStatus,
                      SuggestionDecision.ignored =>
                        l10n.suggestionIgnoredStatus,
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
              l10n.whyThisSuggestionTitle,
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
                        _reasonLabel(l10n, code),
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
                child: Text(l10n.acceptAction),
              ),
              FilledButton.tonal(
                onPressed: onDefer,
                child: Text(l10n.deferAction),
              ),
              OutlinedButton(
                onPressed: onIgnore,
                child: Text(l10n.ignoreAction),
              ),
              if (decision != null)
                TextButton(
                  onPressed: onRestore,
                  child: Text(l10n.restoreAction),
                ),
            ],
          ),
          if (!autoApplyEnabled) ...[
            const SizedBox(height: 8),
            Text(
              l10n.autoApplyDisabledMessage,
              style: theme.textTheme.bodySmall?.copyWith(color: secondary),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';
import 'package:cat_diet_planner/features/suggestions/utils/suggestion_reason_label.dart';
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

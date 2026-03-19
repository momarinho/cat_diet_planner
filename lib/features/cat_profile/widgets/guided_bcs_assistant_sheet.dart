import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/cat_profile/services/guided_bcs_service.dart';
import 'package:flutter/material.dart';

Future<GuidedBcsSelection?> showGuidedBcsAssistantSheet(
  BuildContext context, {
  int? initialBcs,
  String? currentGoal,
  bool initialApplySuggestedGoal = true,
}) {
  return showModalBottomSheet<GuidedBcsSelection>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _GuidedBcsAssistantSheet(
      initialBcs: initialBcs,
      currentGoal: currentGoal,
      initialApplySuggestedGoal: initialApplySuggestedGoal,
    ),
  );
}

class _GuidedBcsAssistantSheet extends StatefulWidget {
  const _GuidedBcsAssistantSheet({
    required this.initialBcs,
    required this.currentGoal,
    required this.initialApplySuggestedGoal,
  });

  final int? initialBcs;
  final String? currentGoal;
  final bool initialApplySuggestedGoal;

  @override
  State<_GuidedBcsAssistantSheet> createState() =>
      _GuidedBcsAssistantSheetState();
}

class _GuidedBcsAssistantSheetState extends State<_GuidedBcsAssistantSheet> {
  final Map<String, int> _answers = <String, int>{};
  late int _finalScore;
  bool _manuallyAdjustedScore = false;
  bool _applySuggestedGoal = true;

  GuidedBcsAssessmentResult? get _result => GuidedBcsService.assess(_answers);
  int get _effectiveScore => _manuallyAdjustedScore
      ? _finalScore
      : (_result?.suggestedScore ?? _finalScore);

  @override
  void initState() {
    super.initState();
    _finalScore = widget.initialBcs ?? 5;
    _applySuggestedGoal = widget.initialApplySuggestedGoal;
  }

  void _selectAnswer(String questionId, int value) {
    setState(() {
      _answers[questionId] = value;
      final result = _result;
      if (!_manuallyAdjustedScore && result != null) {
        _finalScore = result.suggestedScore;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.68) ??
        const Color(0xFF7A7678);
    final result = _result;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guided BCS assistant',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Use body-shape cues to estimate a safe BCS range before you save a final score.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: softText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  _InfoCard(
                    primary: primary,
                    title: 'How to inspect body shape',
                    child: Text(
                      'Feel the ribs with light pressure, look down from above for waist shape, then inspect the belly line from the side. Long fur can hide fat cover, so palpation matters.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    primary: primary,
                    title: 'BCS 1-9 reference guide',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: GuidedBcsService.references
                          .map((reference) {
                            return _ReferenceCard(
                              reference: reference,
                              primary: primary,
                            );
                          })
                          .toList(growable: false),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...GuidedBcsService.questions.map((question) {
                    final selected = _answers[question.id];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _InfoCard(
                        primary: primary,
                        title: question.prompt,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.helper,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: softText,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...question.options.map((option) {
                              final isSelected = selected == option.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () =>
                                      _selectAnswer(question.id, option.value),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primary.withValues(alpha: 0.10)
                                          : theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected
                                            ? primary
                                            : primary.withValues(alpha: 0.12),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.title,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          option.description,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: softText),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                  _InfoCard(
                    primary: primary,
                    title: result == null
                        ? 'Complete all checks to see a suggestion'
                        : result.rangeLabel,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result?.summary ??
                              'Answer all four body-shape prompts to unlock a suggested range.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (result != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            result.explanation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: softText,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        Text(
                          'Confirm or override final BCS',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Slider(
                          value: _effectiveScore.toDouble(),
                          min: 1,
                          max: 9,
                          divisions: 8,
                          label: '$_effectiveScore',
                          onChanged: result == null
                              ? null
                              : (value) {
                                  setState(() {
                                    _manuallyAdjustedScore = true;
                                    _finalScore = value.round();
                                  });
                                },
                        ),
                        Text(
                          'Final score: $_effectiveScore',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: softText,
                          ),
                        ),
                        if (result != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommended next step',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _RecommendationChip(
                                      label:
                                          'Goal: ${result.recommendation.goalLabel}',
                                      primary: primary,
                                    ),
                                    _RecommendationChip(
                                      label:
                                          'Monitor: ${result.recommendation.monitoringCadence}',
                                      primary: primary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  result.recommendation.rationale,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: softText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  result.recommendation.calorieGuidance,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: softText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  result.recommendation.followUpNote,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: softText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CheckboxListTile(
                                  value: _applySuggestedGoal,
                                  onChanged: (value) {
                                    setState(
                                      () =>
                                          _applySuggestedGoal = value ?? false,
                                    );
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    widget.currentGoal ==
                                            result.recommendation.goal
                                        ? 'Keep goal aligned with this recommendation'
                                        : 'Apply ${result.recommendation.goalLabel.toLowerCase()} to this profile',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                    widget.currentGoal == null
                                        ? 'The cat profile will save this recommended goal with the new BCS.'
                                        : 'Current goal: ${catGoalLabel(widget.currentGoal!)}. You can save only the BCS if you prefer.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: softText,
                                    ),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Guidance only. This assistant does not replace veterinary diagnosis, especially for kittens, seniors, pregnant cats, or cats with heavy fur or medical conditions.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: result == null
                      ? null
                      : () => Navigator.of(context).pop(
                          GuidedBcsSelection(
                            finalScore: _effectiveScore,
                            appliedGoal: _applySuggestedGoal
                                ? result.recommendation.goal
                                : null,
                          ),
                        ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(
                    result == null
                        ? 'Use this BCS'
                        : _applySuggestedGoal
                        ? 'Use BCS and goal'
                        : 'Use this BCS',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationChip extends StatelessWidget {
  const _RecommendationChip({required this.label, required this.primary});

  final String label;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.primary,
    required this.title,
    required this.child,
  });

  final Color primary;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  const _ReferenceCard({required this.reference, required this.primary});

  final GuidedBcsReference reference;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final softText =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.66) ??
        const Color(0xFF7A7678);
    final bodyWidth = 26.0 + (reference.score * 6);

    return Container(
      width: 104,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${reference.score}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: bodyWidth.clamp(26, 80),
              height: 22,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: primary.withValues(alpha: 0.24)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            reference.title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reference.visualCue,
            style: theme.textTheme.bodySmall?.copyWith(color: softText),
          ),
        ],
      ),
    );
  }
}

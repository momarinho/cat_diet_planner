import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';
import 'package:cat_diet_planner/features/suggestions/widgets/suggestion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('suggestion card renders reasons and action state', (
    tester,
  ) async {
    final suggestion = SmartSuggestion(
      id: 'alert-luna',
      type: SuggestionType.preventiveTrendAlert,
      priority: SuggestionPriority.medium,
      title: 'Watch Luna closely',
      summary: 'Weight is approaching the upper goal boundary.',
      recommendedAction: 'Monitor intake for 3 days before adjusting the plan.',
      confidenceScore: 0.84,
      reasonCodes: const [
        SuggestionReasonCodes.approachingGoalMax,
        SuggestionReasonCodes.lowEvidence,
      ],
      metadata: const {},
      generatedAt: DateTime(2026, 3, 15, 10),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuggestionCard(
            suggestion: suggestion,
            decision: SuggestionDecision.deferred,
            autoApplyEnabled: false,
            onAccept: () async {},
            onDefer: () {},
            onIgnore: () {},
            onRestore: () {},
          ),
        ),
      ),
    );

    expect(find.text('Preventive Alert'), findsOneWidget);
    expect(find.text('Confidence 84%'), findsOneWidget);
    expect(find.text('Deferred'), findsOneWidget);
    expect(find.text('Watch Luna closely'), findsOneWidget);
    expect(find.text('Why this suggestion:'), findsOneWidget);
    expect(
      find.text('Trend is approaching the upper goal boundary'),
      findsOneWidget,
    );
    expect(find.text('Limited data available (low evidence)'), findsOneWidget);
    expect(find.text('Restore'), findsOneWidget);
    expect(
      find.text(
        'Auto-apply is disabled. Plan changes always require confirmation.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('suggestion card hides restore when no decision exists', (
    tester,
  ) async {
    final suggestion = SmartSuggestion(
      id: 'clinical-miso',
      type: SuggestionType.clinicalWatch,
      priority: SuggestionPriority.high,
      title: 'Clinical watch for Miso',
      summary: 'Recent symptoms justify extra observation.',
      recommendedAction: 'Keep the current plan and watch for recurrence.',
      confidenceScore: 0.79,
      reasonCodes: const [SuggestionReasonCodes.clinicalConditionPresent],
      metadata: const {},
      generatedAt: DateTime(2026, 3, 15, 11),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuggestionCard(
            suggestion: suggestion,
            decision: null,
            autoApplyEnabled: false,
            onAccept: () async {},
            onDefer: () {},
            onIgnore: () {},
            onRestore: () {},
          ),
        ),
      ),
    );

    expect(find.text('Clinical Watch'), findsOneWidget);
    expect(
      find.text('Clinical conditions are configured on profile'),
      findsOneWidget,
    );
    expect(find.text('Restore'), findsNothing);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Defer'), findsOneWidget);
    expect(find.text('Ignore'), findsOneWidget);
  });
}

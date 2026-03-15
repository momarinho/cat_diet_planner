import 'package:cat_diet_planner/core/localization/app_feedback_localizer.dart';
import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/core/localization/app_locale.dart';
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/widgets/plan_preview_card.dart';
import 'package:cat_diet_planner/features/settings/providers/app_settings_provider.dart';
import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';
import 'package:cat_diet_planner/features/suggestions/providers/suggestion_decision_provider.dart';
import 'package:cat_diet_planner/features/suggestions/widgets/suggestion_card.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';

void main() {
  setUp(() async {
    await HiveTestHelper.init();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  test('unsupported locale falls back safely', () {
    expect(AppLocale.normalizeLanguageCode('fr'), 'en');
    expect(AppLocale.normalizeLanguageCode('fil'), 'tl');
    expect(AppLocale.fromLanguageCode('zz'), const Locale('en'));
  });

  testWidgets('locale switch updates localized text', (tester) async {
    Future<void> pumpForLocale(Locale locale) async {
      await tester.pumpWidget(
        _buildLocalizedApp(
          locale: locale,
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Text(l10n.settingsTitle);
            },
          ),
        ),
      );
    }

    await pumpForLocale(const Locale('en'));
    expect(find.text('Settings'), findsOneWidget);

    await pumpForLocale(const Locale('pt', 'BR'));
    expect(find.text('Configuracoes'), findsOneWidget);
  });

  test('selected locale is normalized and persisted', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(appSettingsProvider.notifier).setLanguageCode('pt');
    expect(container.read(appSettingsProvider).languageCode, 'pt_BR');

    await container.read(appSettingsProvider.notifier).setLanguageCode('fil');
    expect(container.read(appSettingsProvider).languageCode, 'tl');
  });

  testWidgets('localized formatter uses locale-aware date and decimal output', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildLocalizedApp(
        locale: const Locale('pt', 'BR'),
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Text(AppFormatters.formatDate(context, DateTime(2026, 3, 15))),
                Text(
                  AppFormatters.formatDecimal(context, 12.5, decimalDigits: 1),
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.textContaining('2026'), findsOneWidget);
    expect(find.text('12,5'), findsOneWidget);
  });

  testWidgets('localized widget copy renders in pt_BR', (tester) async {
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
      _buildLocalizedApp(
        locale: const Locale('pt', 'BR'),
        child: Scaffold(
          body: SuggestionCard(
            suggestion: suggestion,
            decision: SuggestionDecision.accepted,
            autoApplyEnabled: false,
            onAccept: () async {},
            onDefer: () {},
            onIgnore: () {},
            onRestore: () {},
          ),
        ),
      ),
    );

    expect(find.text('Aceita'), findsOneWidget);
    expect(find.text('Alerta preventivo'), findsOneWidget);
    expect(find.textContaining('Confianca'), findsOneWidget);
  });

  testWidgets('localized cards do not overflow in narrow Tagalog layout', (
    tester,
  ) async {
    final preview = PlanPreviewData(
      title: 'Plan Preview',
      foodNames: const ['Hill\'s Light Adult'],
      targetKcalPerDay: 235,
      portionGramsPerDay: 73.9,
      portionGramsPerMeal: 18.5,
      mealsPerDay: 4,
      mealTimes: const ['07:30 AM', '12:30 PM', '03:30 PM', '07:00 PM'],
      mealLabels: const ['Breakfast', 'Lunch', 'Afternoon Meal', 'Dinner'],
      mealPortionGrams: const [18.5, 18.5, 18.5, 18.5],
      startDate: DateTime(2026, 3, 15),
      portionUnit: 'g',
      portionUnitGrams: 1,
      dailyOverrides: const {},
      goalLabel: 'senior_support',
    );

    await tester.pumpWidget(
      _buildLocalizedApp(
        locale: const Locale('tl'),
        child: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 900),
            textScaler: TextScaler.linear(1.15),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: PlanPreviewCard(
                preview: preview,
                primary: const Color(0xFFE85D75),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('feedback localizer falls back safely for unknown keys', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildLocalizedApp(
        locale: const Locale('en'),
        child: Builder(
          builder: (context) {
            return Text(
              localizeChangeSummaryLine(
                AppLocalizations.of(context),
                'raw-summary-line',
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('raw-summary-line'), findsOneWidget);
  });
}

Widget _buildLocalizedApp({required Locale locale, required Widget child}) {
  return ProviderScope(
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

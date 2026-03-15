import 'package:cat_diet_planner/core/navigation/app_router.dart';
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/localization/app_locale.dart';
import 'package:cat_diet_planner/features/shell/screens/app_shell_screen.dart';
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

  testWidgets('main shell switches tabs and opens scanner route', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocale.supportedLocales,
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: AppShellScreen(),
        ),
      ),
    );

    expect(find.text('Nothing selected yet'), findsOneWidget);

    await tester.tap(find.text('HOME'));
    await tester.pumpAndSettle();
    expect(find.text('CatDiet Planner'), findsOneWidget);

    await tester.tap(find.text('PLANS'));
    await tester.pumpAndSettle();
    expect(find.text('Plans'), findsOneWidget);

    await tester.tap(find.text('HISTORY'));
    await tester.pumpAndSettle();
    expect(find.text('History'), findsOneWidget);

    await tester.tap(find.text('DAILY'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing selected yet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.qr_code_scanner_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Scanner'), findsOneWidget);
    expect(
      ModalRoute.of(tester.element(find.text('Scanner')))?.settings.name,
      AppRoutes.scanner,
    );
  });
}

import 'package:cat_diet_planner/features/cat_profile/screens/cat_profile_screen.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';
import 'support/mock_http_images.dart';
import 'support/test_app.dart';

void main() {
  setUpAll(MockHttpImages.install);
  tearDownAll(MockHttpImages.restore);

  setUp(() async {
    await HiveTestHelper.init();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  testWidgets(
    'cat profile form validates required name field and shows clinical fields',
    (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 2200);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(child: buildTestApp(home: const CatProfileScreen())),
      );

      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));

      // Ensure the form renders key clinical fields
      expect(find.text(l10n.idealWeightOptionalLabel), findsOneWidget);
      expect(find.text(l10n.bodyConditionScoreLabel), findsOneWidget);
      expect(find.text(l10n.sexLabel), findsOneWidget);
      expect(find.text(l10n.breedOptionalLabel), findsOneWidget);
      expect(find.text(l10n.dateOfBirthOptionalLabel), findsOneWidget);
      expect(find.text(l10n.veterinaryNotesOptionalLabel), findsOneWidget);

      final saveButton = find.widgetWithText(
        FilledButton,
        l10n.saveProfileAction,
      );
      await tester.scrollUntilVisible(
        saveButton,
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Validation still applies for required fields
      expect(find.text(l10n.enterCatNameError), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}

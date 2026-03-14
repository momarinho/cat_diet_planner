import 'package:cat_diet_planner/features/cat_profile/screens/cat_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';
import 'support/mock_http_images.dart';

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
        const ProviderScope(child: MaterialApp(home: CatProfileScreen())),
      );

      // Ensure the form renders key clinical fields
      expect(find.text('Ideal weight (kg) (optional)'), findsOneWidget);
      expect(find.text('Body Condition Score (1-9)'), findsOneWidget);
      expect(find.text('Sex'), findsOneWidget);
      expect(find.text('Breed (optional)'), findsOneWidget);
      expect(find.text('Date of birth (optional)'), findsOneWidget);
      expect(find.text('Veterinary notes (optional)'), findsOneWidget);

      final saveButton = find.text('Save Profile', skipOffstage: false).last;
      await tester.tap(saveButton);
      await tester.pump();

      // Validation still applies for required fields
      expect(find.text('Enter the cat name'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}

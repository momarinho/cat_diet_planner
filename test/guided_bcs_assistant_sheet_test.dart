import 'package:cat_diet_planner/features/cat_profile/widgets/guided_bcs_assistant_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('guided BCS assistant completes and returns selected score', (
    tester,
  ) async {
    int? returnedScore;
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    returnedScore = await showGuidedBcsAssistantSheet(
                      context,
                      initialBcs: 5,
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    Future<void> answer(String label) async {
      final textFinder = find.text(label);
      await tester.ensureVisible(textFinder);
      final cardFinder = find.ancestor(
        of: textFinder,
        matching: find.byType(InkWell),
      );
      await tester.tap(cardFinder.first);
      await tester.pumpAndSettle();
    }

    await answer('Easy with light cover');
    await answer('Visible');
    await answer('Gentle tuck');
    await answer('Light cover');

    await tester.ensureVisible(find.text('BCS 4-5'));
    expect(find.text('BCS 4-5'), findsOneWidget);

    await tester.ensureVisible(find.text('Use this BCS'));
    await tester.tap(find.text('Use this BCS'));
    await tester.pumpAndSettle();

    expect(returnedScore, 5);
  });
}

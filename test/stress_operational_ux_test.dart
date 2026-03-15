import 'package:cat_diet_planner/core/navigation/app_router.dart';
import 'package:cat_diet_planner/features/settings/services/demo_data_service.dart';
import 'package:cat_diet_planner/features/shell/screens/app_shell_screen.dart';
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
    await DemoDataService.seedOperationalStressScenario();
  });

  tearDown(() async {
    await HiveTestHelper.dispose();
  });

  testWidgets('stress scenario keeps Home and Daily flows stable', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1200, 2200);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: AppShellScreen(initialTab: AppShellTab.home),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('CatDiet Planner'), findsOneWidget);
    expect(find.text('Groups'), findsOneWidget);
    expect(find.textContaining('cat(s) visible'), findsOneWidget);
    expect(find.textContaining('active'), findsWidgets);

    final homeScroll = find.byType(Scrollable).first;
    await tester.drag(homeScroll, const Offset(0, -1200));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.drag(homeScroll, const Offset(0, 900));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('DAILY'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text("Today's Schedule"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

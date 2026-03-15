import 'package:cat_diet_planner/core/navigation/app_router.dart';
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
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

  testWidgets('internal app routes open without route errors', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      ProviderScope(
        child: buildTestApp(
          navigatorKey: navigatorKey,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: AppRoutes.shell,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final sampleCat = CatProfile(
      id: 'route-cat-1',
      name: 'Route Cat',
      weight: 4.1,
      age: 24,
      neutered: true,
      activityLevel: 'moderate',
      goal: 'maintenance',
      createdAt: DateTime(2026, 1, 1),
    );

    final sampleGroup = CatGroup(
      id: 'route-group-1',
      name: 'Route Group',
      catCount: 3,
      colorValue: 0xFFE87878,
      createdAt: DateTime(2026, 1, 1),
    );

    Future<void> openAndClose(String route, {Object? arguments}) async {
      navigatorKey.currentState!.pushNamed(route, arguments: arguments);
      await tester.pumpAndSettle();
      expect(find.text('Route Error'), findsNothing);
      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
    }

    await openAndClose(AppRoutes.daily);
    await openAndClose(AppRoutes.home);
    await openAndClose(AppRoutes.plans);
    await openAndClose(AppRoutes.history);
    await openAndClose(AppRoutes.dashboard, arguments: sampleCat);
    await openAndClose(AppRoutes.catProfile, arguments: sampleCat);
    await openAndClose(AppRoutes.catGroup, arguments: sampleGroup);
    await openAndClose(AppRoutes.settings);
    await openAndClose(AppRoutes.notifications);
    await openAndClose(AppRoutes.howItWorks);
    await openAndClose(AppRoutes.weightCheckIn);
    await openAndClose(AppRoutes.scanner);
    await openAndClose(AppRoutes.foodDatabase);
    await openAndClose(AppRoutes.weeklyDietReport);
  });
}

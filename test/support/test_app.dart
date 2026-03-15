import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Widget buildTestApp({
  Widget? home,
  GlobalKey<NavigatorState>? navigatorKey,
  RouteFactory? onGenerateRoute,
  String? initialRoute,
}) {
  return MaterialApp(
    navigatorKey: navigatorKey,
    onGenerateRoute: onGenerateRoute,
    initialRoute: initialRoute,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: home,
  );
}

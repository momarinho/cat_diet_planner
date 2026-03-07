import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/dashboard/screens/dashboard_overview_screen.dart';
import 'package:cat_diet_planner/features/navigation/app_shell_screen.dart';
import 'package:cat_diet_planner/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.shell:
        return MaterialPageRoute(
          builder: (_) => const AppShellScreen(),
          settings: settings,
        );
      case AppRoutes.dashboard:
        final cat = settings.arguments as CatProfile?;
        if (cat == null) {
          return _errorRoute(
            settings,
            'Missing `CatProfile` argument for ${settings.name}.',
          );
        }

        return MaterialPageRoute(
          builder: (_) => DashboardOverviewScreen(cat: cat),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      default:
        return _errorRoute(settings, 'No route defined for ${settings.name}.');
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

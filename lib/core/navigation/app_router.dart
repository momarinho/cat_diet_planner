import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/features/dashboard/screens/dashboard_overview_screen.dart';
import 'package:cat_diet_planner/features/cat_group/screens/cat_group_screen.dart';
import 'package:cat_diet_planner/features/cat_profile/screens/cat_profile_screen.dart';
import 'package:cat_diet_planner/features/food_database/screens/food_database_screen.dart';
import 'package:cat_diet_planner/features/history/screens/weekly_diet_report_screen.dart';
import 'package:cat_diet_planner/features/notifications/screens/notifications_screen.dart';
import 'package:cat_diet_planner/features/shell/screens/app_shell_screen.dart';
import 'package:cat_diet_planner/features/scanner/screens/scanner_screen.dart';
import 'package:cat_diet_planner/features/settings/screens/settings_screen.dart';
import 'package:cat_diet_planner/features/settings/screens/how_it_works_screen.dart';
import 'package:cat_diet_planner/features/splash/screens/splash_screen.dart';
import 'package:cat_diet_planner/features/weight/screens/weight_checkin_screen.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.shell:
        return MaterialPageRoute(
          builder: (_) => const AppShellScreen(),
          settings: settings,
        );
      case AppRoutes.daily:
        return MaterialPageRoute(
          builder: (_) => const AppShellScreen(initialTab: AppShellTab.daily),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const AppShellScreen(initialTab: AppShellTab.home),
          settings: settings,
        );
      case AppRoutes.plans:
        return MaterialPageRoute(
          builder: (_) => const AppShellScreen(initialTab: AppShellTab.plans),
          settings: settings,
        );
      case AppRoutes.history:
        return MaterialPageRoute(
          builder: (_) => const AppShellScreen(initialTab: AppShellTab.history),
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
      case AppRoutes.catProfile:
        final cat = settings.arguments as CatProfile?;
        return MaterialPageRoute(
          builder: (_) => CatProfileScreen(initialCat: cat),
          settings: settings,
        );
      case AppRoutes.catGroup:
        final group = settings.arguments as CatGroup?;
        return MaterialPageRoute(
          builder: (_) => CatGroupScreen(initialGroup: group),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case AppRoutes.howItWorks:
        return MaterialPageRoute(
          builder: (_) => const HowItWorksScreen(),
          settings: settings,
        );
      case AppRoutes.weightCheckIn:
        return MaterialPageRoute(
          builder: (_) => const WeightCheckInScreen(),
          settings: settings,
        );
      case AppRoutes.scanner:
        return MaterialPageRoute(
          builder: (_) => const ScannerScreen(),
          settings: settings,
        );
      case AppRoutes.foodDatabase:
        return MaterialPageRoute(
          builder: (_) => const FoodDatabaseScreen(),
          settings: settings,
        );
      case AppRoutes.weeklyDietReport:
        return MaterialPageRoute(
          builder: (_) => const WeeklyDietReportScreen(),
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
        appBar: AppBar(
          title: Builder(
            builder: (context) =>
                Text(AppLocalizations.of(context).routeErrorTitle),
          ),
        ),
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

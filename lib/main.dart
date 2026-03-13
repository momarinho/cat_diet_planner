import 'package:cat_diet_planner/core/navigation/app_router.dart';
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/theme/theme_provider.dart';
import 'package:cat_diet_planner/features/settings/services/notification_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/local/hive_service.dart';

void main() async {
  // Garante que os bindings do Flutter estejam prontos antes de inicializar serviços externos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive e os Boxes através do serviço centralizado
  await HiveService.init();
  await NotificationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatDiet Planner 🐱',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

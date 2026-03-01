import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/hive_service/hive_service.dart';
import 'features/cat_profile/screens/profile_list_screen.dart';

void main() async {
  // Garante que os bindings do Flutter estejam prontos antes de inicializar serviços externos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive e os Boxes através do serviço centralizado
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatDiet Planner 🐱',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ProfileListScreen(),
    );
  }
}

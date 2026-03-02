import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// O StateNotifier guarda o estado (ThemeMode) e os métodos para alterá-lo.
// Começamos o app usando o tema configurado no sistema do celular (ThemeMode.system)
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  // Função chamada pelo botão para alternar entre Claro e Escuro
  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }
}

// O Riverpod Provider que expõe o nosso Notifier para o resto do app
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

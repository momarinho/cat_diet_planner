import 'package:flutter/material.dart';

abstract final class AppLocale {
  static const supportedLocales = [
    Locale('en'),
    Locale('pt', 'BR'),
    Locale('tl'),
  ];

  static Locale fromLanguageCode(String languageCode) {
    final normalized = normalizeLanguageCode(languageCode);
    return switch (normalized) {
      'pt_BR' => const Locale('pt', 'BR'),
      'tl' => const Locale('tl'),
      _ => const Locale('en'),
    };
  }

  static String normalizeLanguageCode(String languageCode) {
    final normalized = languageCode.trim();
    if (normalized.isEmpty) return 'en';
    final lower = normalized.toLowerCase();
    if (lower == 'pt' || lower == 'pt_br' || lower == 'pt-br') {
      return 'pt_BR';
    }
    if (lower == 'tl' || lower == 'fil') {
      return 'tl';
    }
    return 'en';
  }
}

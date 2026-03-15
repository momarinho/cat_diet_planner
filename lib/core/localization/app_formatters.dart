import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract final class AppFormatters {
  static String formatDate(BuildContext context, DateTime value) {
    return DateFormat.yMd(_localeName(context)).format(value);
  }

  static String formatDateTime(BuildContext context, DateTime value) {
    return '${formatDate(context, value)} ${formatTime(context, value)}';
  }

  static String formatTime(BuildContext context, DateTime value) {
    final locale = _localeName(context);
    final pattern = _uses24HourClock(context) ? 'HH:mm' : 'jm';
    return DateFormat(pattern, locale).format(value);
  }

  static String formatStoredMealTime(BuildContext context, String value) {
    final parsed = _parseStoredTime(value);
    if (parsed == null) return value;
    return formatTime(context, parsed);
  }

  static String formatDecimal(
    BuildContext context,
    num value, {
    int decimalDigits = 1,
  }) {
    return NumberFormat.decimalPatternDigits(
      locale: _localeName(context),
      decimalDigits: decimalDigits,
    ).format(value);
  }

  static String _localeName(BuildContext context) {
    return Localizations.localeOf(context).toString();
  }

  static bool _uses24HourClock(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return locale.startsWith('pt');
  }

  static DateTime? _parseStoredTime(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;

    final meridiemMatch = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    ).firstMatch(normalized);
    if (meridiemMatch != null) {
      final hour12 = int.tryParse(meridiemMatch.group(1)!);
      final minute = int.tryParse(meridiemMatch.group(2)!);
      final period = meridiemMatch.group(3)!.toUpperCase();
      if (hour12 == null || minute == null) return null;
      var hour24 = hour12 % 12;
      if (period == 'PM') hour24 += 12;
      return DateTime(2026, 1, 1, hour24, minute);
    }

    final twentyFourHourMatch = RegExp(
      r'^(\d{1,2}):(\d{2})$',
    ).firstMatch(normalized);
    if (twentyFourHourMatch != null) {
      final hour = int.tryParse(twentyFourHourMatch.group(1)!);
      final minute = int.tryParse(twentyFourHourMatch.group(2)!);
      if (hour == null || minute == null) return null;
      return DateTime(2026, 1, 1, hour, minute);
    }

    return null;
  }
}

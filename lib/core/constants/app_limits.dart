class AppLimits {
  AppLimits._();

  static const int maxCats = 10;
  static const int maxGroups = 5;
  static const double minPlanTargetKcalPerDay = 120;
  static const double maxPlanTargetKcalPerDay = 700;
  static const int maxSuggestionKcalAdjustmentPercent = 12;
  static const int maxSuggestionScheduleShiftMinutes = 45;
  static const double maxSuggestionMealPortionShiftRatio = 0.30;
  static const int maxPlanAuditEntries = 50;
}

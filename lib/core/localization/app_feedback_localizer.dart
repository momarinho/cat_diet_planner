import 'package:cat_diet_planner/core/errors/localized_exception.dart';
import 'package:cat_diet_planner/features/suggestions/services/plan_adjustment_service.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';

String localizeErrorMessage(AppLocalizations l10n, Object error) {
  if (error is LocalizedException) {
    return _localizedFromKey(l10n, error.key, error.args);
  }
  if (error is ArgumentError && error.message != null) {
    return error.message.toString();
  }
  return error.toString();
}

String localizePlanAdjustmentMessage(
  AppLocalizations l10n,
  PlanAdjustmentResult result,
) {
  if (result.messageKey == null) {
    return result.changed
        ? l10n.planUpdatedAfterConfirmation
        : l10n.suggestionRecordedWithoutPlanChanges;
  }
  return _localizedFromKey(l10n, result.messageKey!, result.messageArgs);
}

String localizeChangeSummaryLine(AppLocalizations l10n, String line) {
  final parts = line.split('|');
  if (parts.isEmpty) return line;
  switch (parts.first) {
    case 'kcal_change':
      if (parts.length < 4) return line;
      return l10n.summaryTargetKcalPerDayChange(parts[1], parts[2], parts[3]);
    case 'daily_portion_change':
      if (parts.length < 3) return line;
      return l10n.summaryDailyPortionChange(parts[1], parts[2]);
    case 'meal_time_change':
      if (parts.length < 4) return line;
      return l10n.summaryMealTimeChange(parts[1], parts[2], parts[3]);
    case 'meal_portion_change':
      if (parts.length < 4) return line;
      return l10n.summaryMealPortionChange(parts[1], parts[2], parts[3]);
    default:
      return line;
  }
}

String _localizedFromKey(
  AppLocalizations l10n,
  String key,
  Map<String, Object> args,
) {
  switch (key) {
    case 'dietWeightRange':
      return l10n.dietWeightRangeError(
        args['min'] as String? ?? '',
        args['max'] as String? ?? '',
      );
    case 'dietAgeRange':
      return l10n.dietAgeRangeError(
        args['min'] as String? ?? '',
        args['max'] as String? ?? '',
      );
    case 'dietFoodCaloriesPositive':
      return l10n.dietFoodCaloriesPositiveError;
    case 'dietMealsRange':
      return l10n.dietMealsRangeError(
        args['min'] as String? ?? '',
        args['max'] as String? ?? '',
      );
    case 'dietWeightPositive':
      return l10n.dietWeightPositiveError;
    case 'dietMealsPositive':
      return l10n.dietMealsPositiveError;
    case 'portionUnknownUnit':
      return l10n.portionUnknownUnitError(args['unit'] as String? ?? '');
    case 'portionZeroEquivalent':
      return l10n.portionZeroEquivalentError(args['unit'] as String? ?? '');
    case 'suggestionRecordedWithoutPlanChanges':
      return l10n.suggestionRecordedWithoutPlanChanges;
    case 'noActivePlanAvailableForCat':
      return l10n.noActivePlanAvailableForCat;
    case 'noSuggestedPlanChangesAvailableToRevert':
      return l10n.noSuggestedPlanChangesAvailableToRevert;
    case 'lastSuggestedChangeReverted':
      return l10n.lastSuggestedChangeReverted;
    case 'suggestionDataIncomplete':
      return l10n.suggestionDataIncomplete;
    case 'suggestedKcalChangeExceedsSafeBand':
      return l10n.suggestedKcalChangeExceedsSafeBand;
    case 'suggestedKcalTargetOutsideSafeRange':
      return l10n.suggestedKcalTargetOutsideSafeRange;
    case 'unableToRecalculatePortionSafely':
      return l10n.unableToRecalculatePortionSafely;
    case 'scheduleChangeExceedsSafeShiftLimit':
      return l10n.scheduleChangeExceedsSafeShiftLimit;
    case 'portionRedistributionInvalidForActivePlan':
      return l10n.portionRedistributionInvalidForActivePlan;
    case 'portionShiftExceedsSafeRedistributionLimit':
      return l10n.portionShiftExceedsSafeRedistributionLimit;
    case 'portionRedistributionFailedSafetyValidation':
      return l10n.portionRedistributionFailedSafetyValidation;
    case 'catLimitReached':
      return l10n.catLimitReached((args['max'] as num?)?.toInt() ?? 0);
    case 'invalidImageFile':
      return l10n.invalidImageFile;
    default:
      return key;
  }
}

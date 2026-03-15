import 'package:cat_diet_planner/features/suggestions/models/smart_suggestion.dart';

String suggestionReasonLabel(String code) {
  switch (code) {
    case SuggestionReasonCodes.weightTrendUp:
      return 'Recent weight trend is increasing';
    case SuggestionReasonCodes.weightTrendDown:
      return 'Recent weight trend is decreasing';
    case SuggestionReasonCodes.outOfGoalMax:
      return 'Weight is above configured goal range';
    case SuggestionReasonCodes.outOfGoalMin:
      return 'Weight is below configured goal range';
    case SuggestionReasonCodes.approachingGoalMax:
      return 'Trend is approaching the upper goal boundary';
    case SuggestionReasonCodes.approachingGoalMin:
      return 'Trend is approaching the lower goal boundary';
    case SuggestionReasonCodes.adherenceLow:
      return 'Meal adherence is below target';
    case SuggestionReasonCodes.refusalFrequent:
      return 'Refusal events are frequent';
    case SuggestionReasonCodes.delayedFrequent:
      return 'Delayed meals are frequent';
    case SuggestionReasonCodes.appetiteReduced:
      return 'Reduced appetite was logged recently';
    case SuggestionReasonCodes.appetitePoor:
      return 'Poor appetite was logged recently';
    case SuggestionReasonCodes.vomitFrequent:
      return 'Frequent vomit events were logged';
    case SuggestionReasonCodes.stoolDiarrhea:
      return 'Diarrhea events were logged';
    case SuggestionReasonCodes.clinicalConditionPresent:
      return 'Clinical conditions are configured on profile';
    case SuggestionReasonCodes.weightAlertTriggered:
      return 'Weight alerts were triggered recently';
    case SuggestionReasonCodes.lowEvidence:
      return 'Limited data available (low evidence)';
    default:
      return code;
  }
}

String suggestionTypeLabel(SuggestionType type) {
  switch (type) {
    case SuggestionType.kcalAdjustment:
      return 'Kcal';
    case SuggestionType.scheduleAdjustment:
      return 'Schedule';
    case SuggestionType.portionSplitAdjustment:
      return 'Portions';
    case SuggestionType.preventiveTrendAlert:
      return 'Preventive Alert';
    case SuggestionType.clinicalWatch:
      return 'Clinical Watch';
  }
}

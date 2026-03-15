enum SuggestionType {
  kcalAdjustment,
  scheduleAdjustment,
  portionSplitAdjustment,
  preventiveTrendAlert,
  clinicalWatch,
}

enum SuggestionPriority { low, medium, high }

class SmartSuggestion {
  const SmartSuggestion({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.summary,
    required this.recommendedAction,
    required this.confidenceScore,
    required this.reasonCodes,
    required this.metadata,
    required this.generatedAt,
  });

  final String id;
  final SuggestionType type;
  final SuggestionPriority priority;
  final String title;
  final String summary;
  final String recommendedAction;
  final double confidenceScore; // 0.0 .. 1.0
  final List<String> reasonCodes;
  final Map<String, dynamic> metadata;
  final DateTime generatedAt;
}

abstract final class SuggestionReasonCodes {
  static const weightTrendUp = 'WEIGHT_TREND_UP';
  static const weightTrendDown = 'WEIGHT_TREND_DOWN';
  static const outOfGoalMax = 'OUT_OF_GOAL_MAX';
  static const outOfGoalMin = 'OUT_OF_GOAL_MIN';
  static const approachingGoalMax = 'APPROACHING_GOAL_MAX';
  static const approachingGoalMin = 'APPROACHING_GOAL_MIN';
  static const adherenceLow = 'ADHERENCE_LOW';
  static const refusalFrequent = 'REFUSAL_FREQUENT';
  static const delayedFrequent = 'DELAYED_FREQUENT';
  static const appetiteReduced = 'APPETITE_REDUCED';
  static const appetitePoor = 'APPETITE_POOR';
  static const vomitFrequent = 'VOMIT_FREQUENT';
  static const stoolDiarrhea = 'STOOL_DIARRHEA';
  static const clinicalConditionPresent = 'CLINICAL_CONDITION_PRESENT';
  static const weightAlertTriggered = 'WEIGHT_ALERT_TRIGGERED';
  static const lowEvidence = 'LOW_EVIDENCE';
}

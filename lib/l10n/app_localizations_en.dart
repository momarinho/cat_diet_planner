// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CatDiet Planner';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get appLanguageTitle => 'App Language';

  @override
  String get localizedContentScopeTitle => 'Localized content scope';

  @override
  String get localizedContentScopeDescription =>
      'Notifications and report/share texts now follow the selected language.';

  @override
  String get navDaily => 'Daily';

  @override
  String get navHome => 'Home';

  @override
  String get navPlans => 'Plans';

  @override
  String get navHistory => 'History';

  @override
  String get routeErrorTitle => 'Route Error';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get activeCatTitle => 'Active Cat';

  @override
  String get editAction => 'Edit';

  @override
  String catAgeYearsOld(int years) {
    return '$years Years Old';
  }

  @override
  String get scanFoodAction => 'Scan Food';

  @override
  String get logWeightAction => 'Log Weight';

  @override
  String get dailySummaryTitle => 'Daily Summary';

  @override
  String get todayLabel => 'Today';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get calorieIntakeLabel => 'CALORIE INTAKE';

  @override
  String get createPlanToUnlockDailySummary =>
      'Create a plan to unlock your daily summary';

  @override
  String get todayFullyCompleted => 'Today is fully completed';

  @override
  String remainingCaloriesForMeal(int kcal, String meal) {
    return '$kcal kcal remaining for $meal';
  }

  @override
  String get mealTimelineTitle => 'Meal Timeline';

  @override
  String get viewPlanAction => 'View Plan';

  @override
  String get noTimelineYetTitle => 'No timeline yet';

  @override
  String get noTimelineYetDescription =>
      'Save a meal plan to unlock the meal timeline.';

  @override
  String mealFallbackTitle(int number) {
    return 'Meal $number';
  }

  @override
  String mealMarkedPending(String meal) {
    return '$meal marked as pending.';
  }

  @override
  String mealMarkedCompleted(String meal) {
    return '$meal marked as completed.';
  }

  @override
  String get planInspectorTitle => 'Plan Inspector';

  @override
  String get groupPlanInspectorTitle => 'Group Plan Inspector';

  @override
  String get previewTab => 'Preview';

  @override
  String get savedTab => 'Saved';

  @override
  String get noPreviewYetTitle => 'No preview yet';

  @override
  String get noPreviewYetDescription =>
      'Adjust foods or plan inputs to generate a preview.';

  @override
  String get noCatSelectedTitle => 'No cat selected';

  @override
  String get noCatSelectedDescription =>
      'Select a cat to inspect its saved plans.';

  @override
  String get noSavedPlansYetTitle => 'No saved plans yet';

  @override
  String get noSavedPlansYetDescription => 'Save a plan to inspect it here.';

  @override
  String get noGroupSelectedTitle => 'No group selected';

  @override
  String get noGroupSelectedDescription =>
      'Select a group to inspect its saved plan.';

  @override
  String get noSavedGroupPlanTitle => 'No saved group plan';

  @override
  String get noSavedGroupPlanDescription =>
      'Save a group plan to inspect it here.';

  @override
  String get savedIndividualPlanTitle => 'Saved Individual Plan';

  @override
  String get savedGroupPlanTitle => 'Saved Group Plan';

  @override
  String get planPreviewTitle => 'Plan Preview';

  @override
  String get groupPlanPreviewTitle => 'Group Plan Preview';

  @override
  String get savedCoreTargetsTitle => 'Core targets';

  @override
  String get savedCoreTargetsSubtitle =>
      'Saved values currently being used by this plan.';

  @override
  String get savedMealTimelineTitle => 'Meal timeline';

  @override
  String get savedMealTimelineSubtitle =>
      'Saved schedule and portion split for each meal.';

  @override
  String get savedPlanDetailsTitle => 'Plan details';

  @override
  String get savedPlanDetailsSubtitle =>
      'Operational context, notes and saved configuration.';

  @override
  String get previewCoreTargetsTitle => 'Core targets';

  @override
  String get previewCoreTargetsSubtitle =>
      'The numbers that will be used when this draft is saved.';

  @override
  String get previewMealTimelineTitle => 'Meal timeline';

  @override
  String get previewMealTimelineSubtitle =>
      'Each feeding slot with time and exact portion.';

  @override
  String get previewPlanDetailsTitle => 'Plan details';

  @override
  String get previewPlanDetailsSubtitle =>
      'Context that affects execution but is easy to miss.';

  @override
  String get customPlanLabel => 'Custom plan';

  @override
  String startsTag(String date) {
    return 'Starts $date';
  }

  @override
  String mealsPerDayTag(int count) {
    return '$count meals/day';
  }

  @override
  String catsCountTag(int count) {
    return '$count cats';
  }

  @override
  String get activePlanTag => 'Active plan';

  @override
  String get metricDailyGoal => 'Daily goal';

  @override
  String get metricFoodPerDay => 'Food per day';

  @override
  String get metricAveragePerMeal => 'Average per meal';

  @override
  String get metricServingUnit => 'Serving unit';

  @override
  String get metricPerCat => 'Per cat';

  @override
  String get metricGroupTotal => 'Group total';

  @override
  String get metricGroupPerDay => 'Group per day';

  @override
  String get metricGroupPerMeal => 'Group per meal';

  @override
  String get metricSavedAt => 'Saved at';

  @override
  String get metricOverrides => 'Overrides';

  @override
  String get metricFoods => 'Foods';

  @override
  String get metricNotes => 'Notes';

  @override
  String get metricStarts => 'Starts';

  @override
  String get metricDistribution => 'Distribution';

  @override
  String get helperEnergyTarget => 'Energy target';

  @override
  String get helperTotalPortion => 'Total portion';

  @override
  String get helperBaselineSplit => 'Baseline split';

  @override
  String get helperDisplayUnit => 'Display unit';

  @override
  String get helperEnergyTargetPerCat => 'Energy target per cat';

  @override
  String get helperCombinedEnergyTarget => 'Combined energy target';

  @override
  String get helperAverageFeedingSlot => 'Average feeding slot';

  @override
  String get noActiveOverrides => 'No active overrides';

  @override
  String activeOverridesCount(int count) {
    return '$count active overrides';
  }

  @override
  String get noNotesYet => 'No notes yet';

  @override
  String get equalSplitLabel => 'Equal split';

  @override
  String unequalSplitLabel(int count) {
    return 'Unequal ($count cats)';
  }

  @override
  String get activePlanLabelText => 'Active plan';

  @override
  String usePlanAction(String date) {
    return 'Use $date';
  }

  @override
  String get deleteActivePlanAction => 'Delete active plan';

  @override
  String get scheduledFeedingSlotCaption => 'Scheduled feeding slot';

  @override
  String plusMoreFoods(int count) {
    return '+ $count more';
  }

  @override
  String get plansTitle => 'Plans';

  @override
  String get planInspectorTooltip => 'Preview and saved plan';

  @override
  String get buildPlanTitle => 'Build Plan';

  @override
  String get individualPlanMode => 'Individual';

  @override
  String get groupPlanMode => 'Group';

  @override
  String get catProfileLabel => 'Cat Profile';

  @override
  String get groupLabel => 'Group';

  @override
  String groupWithCats(String group, int count) {
    return '$group ($count cats)';
  }

  @override
  String get targetKcalPerCatPerDayLabel => 'Target kcal per cat / day';

  @override
  String get createGroupAction => 'Create Group';

  @override
  String mealsPerDayChip(int count) {
    return '$count meals/day';
  }

  @override
  String get planStartDateTitle => 'Plan Start Date';

  @override
  String startsOnLabel(String date) {
    return 'Starts on $date';
  }

  @override
  String get portionUnitTitle => 'Portion Unit';

  @override
  String get unitLabel => 'Unit';

  @override
  String get gramsPerUnitLabel => 'Grams per unit';

  @override
  String get weekendAlternativeTitle => 'Weekend alternative';

  @override
  String get weekendAlternativeDescription =>
      'Apply a different kcal/portion factor on Saturday and Sunday.';

  @override
  String get weekendKcalFactorLabel => 'Weekend kcal factor (%)';

  @override
  String get byWeekdayTitle => 'By Weekday';

  @override
  String get byWeekdayDescription =>
      'Enable specific days and set a kcal/portion factor for each day.';

  @override
  String get factorPercentLabel => 'Factor %';

  @override
  String get operationalNotesLabel => 'Operational notes';

  @override
  String get mealLabelsTitle => 'Meal Labels';

  @override
  String mealNameLabel(int count) {
    return 'Meal $count name';
  }

  @override
  String get mealPortionsTitle => 'Meal Portions';

  @override
  String get mealPortionsDescription =>
      'Set the percentage of the daily portion served in each meal. The app normalizes the total to 100%.';

  @override
  String mealShareLabel(String meal) {
    return '$meal share (%)';
  }

  @override
  String get mealScheduleTitle => 'Meal Schedule';

  @override
  String get mealScheduleDescription =>
      'Choose the time for each meal. Daily and Home will use this schedule.';

  @override
  String get suggestionsTitle => 'Suggestions';

  @override
  String get noCatProfilesAvailableTitle => 'No cat profiles available';

  @override
  String get noCatProfilesAvailableMessage =>
      'Create a cat profile before building an individual meal plan.';

  @override
  String get noGroupsAvailableTitle => 'No groups available';

  @override
  String get noGroupsAvailableMessage =>
      'Create a group before building a shared meal plan.';

  @override
  String get availableFoodsTitle => 'Available Foods';

  @override
  String get noFoodsAvailableTitle => 'No foods available';

  @override
  String get noFoodsAvailableDescription =>
      'Add foods in Food Database before creating a plan.';

  @override
  String get multipleFoodsTitle => 'Multiple foods';

  @override
  String get multipleFoodsDescription =>
      'Allow selecting multiple foods for the plan';

  @override
  String get unknownBrand => 'Unknown brand';

  @override
  String get savePlanAction => 'Save Plan';

  @override
  String get saveGroupPlanAction => 'Save Group Plan';

  @override
  String get savingLabel => 'Saving...';

  @override
  String get planDeletedMessage => 'Plan deleted.';

  @override
  String planSavedForCatMessage(String name) {
    return 'Plan saved for $name';
  }

  @override
  String planSavedForGroupMessage(String name) {
    return 'Plan saved for $name';
  }

  @override
  String get enterValidKcalPerCatMessage =>
      'Enter a valid kcal target per cat.';

  @override
  String get mondayLabel => 'Monday';

  @override
  String get tuesdayLabel => 'Tuesday';

  @override
  String get wednesdayLabel => 'Wednesday';

  @override
  String get thursdayLabel => 'Thursday';

  @override
  String get fridayLabel => 'Friday';

  @override
  String get saturdayLabel => 'Saturday';

  @override
  String get sundayLabel => 'Sunday';

  @override
  String dayFallbackLabel(int weekday) {
    return 'Day $weekday';
  }

  @override
  String get noActiveSuggestionsDescription =>
      'No active suggestions right now. Keep logging meals and weight to improve guidance.';

  @override
  String get confirmPlanChangeTitle => 'Confirm plan change';

  @override
  String applySuggestionAfterReview(String catName) {
    return 'Apply this suggestion to $catName only after review.';
  }

  @override
  String get responsiblePersonLabel => 'Responsible person';

  @override
  String get typeWhoApprovedHint => 'Type who approved this change';

  @override
  String get approvalIdentityRequired => 'Approval identity is required.';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get planUpdatedAfterConfirmation => 'Plan updated after confirmation.';

  @override
  String get suggestionRecordedWithoutPlanChanges =>
      'Suggestion recorded without plan changes.';

  @override
  String suggestionConfidenceLabel(String value) {
    return 'Confidence $value';
  }

  @override
  String get suggestionAcceptedStatus => 'Accepted';

  @override
  String get suggestionDeferredStatus => 'Deferred';

  @override
  String get suggestionIgnoredStatus => 'Ignored';

  @override
  String get whyThisSuggestionTitle => 'Why this suggestion:';

  @override
  String get acceptAction => 'Accept';

  @override
  String get deferAction => 'Defer';

  @override
  String get ignoreAction => 'Ignore';

  @override
  String get restoreAction => 'Restore';

  @override
  String get autoApplyDisabledMessage =>
      'Auto-apply is disabled. Plan changes always require confirmation.';

  @override
  String get suggestionTypeKcal => 'Kcal';

  @override
  String get suggestionTypeSchedule => 'Schedule';

  @override
  String get suggestionTypePortions => 'Portions';

  @override
  String get suggestionTypePreventiveAlert => 'Preventive Alert';

  @override
  String get suggestionTypeClinicalWatch => 'Clinical Watch';

  @override
  String get reasonWeightTrendUp => 'Recent weight trend is increasing';

  @override
  String get reasonWeightTrendDown => 'Recent weight trend is decreasing';

  @override
  String get reasonOutOfGoalMax => 'Weight is above configured goal range';

  @override
  String get reasonOutOfGoalMin => 'Weight is below configured goal range';

  @override
  String get reasonApproachingGoalMax =>
      'Trend is approaching the upper goal boundary';

  @override
  String get reasonApproachingGoalMin =>
      'Trend is approaching the lower goal boundary';

  @override
  String get reasonAdherenceLow => 'Meal adherence is below target';

  @override
  String get reasonRefusalFrequent => 'Refusal events are frequent';

  @override
  String get reasonDelayedFrequent => 'Delayed meals are frequent';

  @override
  String get reasonAppetiteReduced => 'Reduced appetite was logged recently';

  @override
  String get reasonAppetitePoor => 'Poor appetite was logged recently';

  @override
  String get reasonVomitFrequent => 'Frequent vomit events were logged';

  @override
  String get reasonStoolDiarrhea => 'Diarrhea events were logged';

  @override
  String get reasonClinicalConditionPresent =>
      'Clinical conditions are configured on profile';

  @override
  String get reasonWeightAlertTriggered =>
      'Weight alerts were triggered recently';

  @override
  String get reasonLowEvidence => 'Limited data available (low evidence)';

  @override
  String dietWeightRangeError(String min, String max) {
    return 'Weight must be between $min and $max kg.';
  }

  @override
  String dietAgeRangeError(String min, String max) {
    return 'Age must be between $min and $max months.';
  }

  @override
  String get dietFoodCaloriesPositiveError =>
      'Food calories must be greater than zero.';

  @override
  String dietMealsRangeError(String min, String max) {
    return 'Meals per day must be between $min and $max.';
  }

  @override
  String get dietWeightPositiveError => 'Weight must be greater than zero.';

  @override
  String get dietMealsPositiveError =>
      'Meals per day must be greater than zero.';

  @override
  String portionUnknownUnitError(String unit) {
    return 'Unknown portion unit \"$unit\".';
  }

  @override
  String portionZeroEquivalentError(String unit) {
    return 'Unit \"$unit\" has a zero gram equivalent.';
  }

  @override
  String get noActivePlanAvailableForCat =>
      'No active plan available for this cat.';

  @override
  String get noSuggestedPlanChangesAvailableToRevert =>
      'No suggested plan changes available to revert.';

  @override
  String get lastSuggestedChangeReverted => 'Last suggested change reverted.';

  @override
  String get suggestionDataIncomplete => 'Suggestion data is incomplete.';

  @override
  String get suggestedKcalChangeExceedsSafeBand =>
      'Suggested kcal change exceeds the safe adjustment band.';

  @override
  String get suggestedKcalTargetOutsideSafeRange =>
      'Suggested kcal target is outside the allowed safe range.';

  @override
  String get unableToRecalculatePortionSafely =>
      'Unable to recalculate portion size safely.';

  @override
  String get scheduleChangeExceedsSafeShiftLimit =>
      'Schedule change exceeds the safe shift limit.';

  @override
  String get portionRedistributionInvalidForActivePlan =>
      'Portion redistribution is invalid for the active plan.';

  @override
  String get portionShiftExceedsSafeRedistributionLimit =>
      'Portion shift exceeds the safe redistribution limit.';

  @override
  String get portionRedistributionFailedSafetyValidation =>
      'Portion redistribution failed safety validation.';

  @override
  String summaryTargetKcalPerDayChange(
    String fromValue,
    String toValue,
    String delta,
  ) {
    return 'Target kcal/day: $fromValue -> $toValue ($delta)';
  }

  @override
  String summaryDailyPortionChange(String fromValue, String toValue) {
    return 'Daily portion: $fromValue -> $toValue';
  }

  @override
  String summaryMealTimeChange(String meal, String fromValue, String toValue) {
    return '$meal: $fromValue -> $toValue';
  }

  @override
  String summaryMealPortionChange(
    String meal,
    String fromValue,
    String toValue,
  ) {
    return '$meal: $fromValue -> $toValue';
  }

  @override
  String get revertLastSuggestedChangeTitle => 'Revert last suggested change';

  @override
  String get revertLastSuggestedChangeDescription =>
      'This restores the plan snapshot from before the latest suggested change.';

  @override
  String get typeWhoIsRevertingHint => 'Type who is reverting this change';

  @override
  String get responsiblePersonRequired => 'Responsible person is required.';

  @override
  String get revertAction => 'Revert';

  @override
  String impactRevertedBy(String name) {
    return 'Reverted by $name';
  }

  @override
  String get impactActiveChange => 'Active change';

  @override
  String impactBeforeAfterKcal(String beforeValue, String afterValue) {
    return 'Before/after kcal: $beforeValue -> $afterValue';
  }

  @override
  String get unknownPersonLabel => 'unknown';

  @override
  String get shareMessageTitle => 'Share message';

  @override
  String get shareMessageHint => 'Message used when sharing report files';

  @override
  String get saveAction => 'Save';

  @override
  String get mealReminderTimesTitle => 'Meal Reminder Times';

  @override
  String get addTimeAction => 'Add Time';

  @override
  String get saveScheduleAction => 'Save Schedule';

  @override
  String get generateDemoDataTitle => 'Generate demo data';

  @override
  String get generateDemoDataDescription =>
      'This will replace the current local data with a ready-to-test scenario containing one group, one individual cat, foods, plans, meals and weight history.';

  @override
  String get generateAction => 'Generate';

  @override
  String demoDataReadyMessage(int groups, int cats, int foods, int schedules) {
    return 'Demo data ready: $groups group, $cats cat, $foods foods, $schedules schedules.';
  }

  @override
  String get clearDemoDataTitle => 'Clear demo data';

  @override
  String get clearDemoDataDescription =>
      'This will remove the local demo data from the app, including cats, groups, foods, plans, meals and history.';

  @override
  String get clearAction => 'Clear';

  @override
  String get localDemoDataClearedMessage => 'Local demo data cleared.';

  @override
  String get generateStressDataTitle => 'Generate stress test data';

  @override
  String get generateStressDataDescription =>
      'This will load a heavy operational scenario (up to 10 cats and 5 groups) to validate navigation, lists and daily routines in high-volume usage.';

  @override
  String stressScenarioReadyMessage(
    int groups,
    int cats,
    int foods,
    int schedules,
  ) {
    return 'Stress scenario ready: $groups groups, $cats cats, $foods foods, $schedules schedules.';
  }

  @override
  String get customRangeDaysTitle => 'Custom range days';

  @override
  String customRangeDaysValue(int days) {
    return '$days days';
  }

  @override
  String get customRangeTitle => 'Custom range';

  @override
  String get daysLabel => 'Days';

  @override
  String get noAcceptedPlanChangesYetTitle => 'No accepted plan changes yet';

  @override
  String get noAcceptedPlanChangesYetDescription =>
      'Approved suggestion changes will record who accepted them, when, and what changed.';

  @override
  String get noSuggestionImpactHistoryYetTitle =>
      'No suggestion impact history yet';

  @override
  String get noSuggestionImpactHistoryYetDescription =>
      'Generated suggestions, accepted changes and before/after snapshots will be stored here.';

  @override
  String get revertLatestSuggestedAdjustmentDescription =>
      'Restore the latest plan snapshot saved before a suggested adjustment was applied.';

  @override
  String get continueAction => 'Continue';

  @override
  String get tryAgainAction => 'Try Again';

  @override
  String get deleteAction => 'Delete';

  @override
  String get kgUnit => 'kg';

  @override
  String get catsUnit => 'cats';

  @override
  String get noneOption => 'None';

  @override
  String get normalOption => 'Normal';

  @override
  String get highOption => 'High';

  @override
  String get lowOption => 'Low';

  @override
  String get poorOption => 'Poor';

  @override
  String get reducedOption => 'Reduced';

  @override
  String get softOption => 'Soft';

  @override
  String get hardOption => 'Hard';

  @override
  String get diarrheaOption => 'Diarrhea';

  @override
  String get occasionalOption => 'Occasional';

  @override
  String get frequentOption => 'Frequent';

  @override
  String get otherOption => 'Other';

  @override
  String get sedentaryOption => 'Sedentary';

  @override
  String get moderateOption => 'Moderate';

  @override
  String get activeOption => 'Active';

  @override
  String get maleOption => 'Male';

  @override
  String get femaleOption => 'Female';

  @override
  String get unknownOption => 'Unknown';

  @override
  String get maintenanceGoalOption => 'Maintenance';

  @override
  String get weightLossGoalOption => 'Weight loss';

  @override
  String get weightGainGoalOption => 'Weight gain';

  @override
  String get kittenGrowthGoalOption => 'Kitten growth';

  @override
  String get seniorSupportGoalOption => 'Senior support';

  @override
  String get recoveryGoalOption => 'Recovery';

  @override
  String get postSurgeryGoalOption => 'Post-surgery';

  @override
  String get completedOption => 'Completed';

  @override
  String get partialOption => 'Partial';

  @override
  String get delayedOption => 'Delayed';

  @override
  String get refusedOption => 'Refused';

  @override
  String get reducedAppetiteOption => 'Reduced appetite';

  @override
  String get skippedOption => 'Skipped';

  @override
  String get loggedStatus => 'Logged';

  @override
  String get weightCheckInTitle => 'Weight Check-in';

  @override
  String get noActiveCatTitle => 'No active cat';

  @override
  String get noActiveCatDescription =>
      'Select a cat from Home before recording weight.';

  @override
  String get weightRecordedWithAlertMessage =>
      'Weight recorded with alert. Review goals and clinical notes.';

  @override
  String get weightRecordedMessage => 'Weight recorded.';

  @override
  String get weightNoteSuggestionHighAppetite => 'High Appetite';

  @override
  String get weightNoteSuggestionEnergetic => 'Energetic';

  @override
  String get weightNoteSuggestionLazyDay => 'Lazy Day';

  @override
  String get weightContextFastingOption => 'Fasting';

  @override
  String get weightContextAfterMealOption => 'After meal';

  @override
  String get weightContextDifferentScaleOption => 'Different scale';

  @override
  String get noPreviousCheckInLabel => 'No previous check-in';

  @override
  String lastCheckInLabel(String date) {
    return 'Last check-in: $date';
  }

  @override
  String recordingNowLabel(String date, String time) {
    return 'Recording now: $date at $time';
  }

  @override
  String get lastWeightLabel => 'LAST\nWEIGHT';

  @override
  String get checkInDateTimeTitle => 'Check-in Date & Time';

  @override
  String get currentWeightLabel => 'CURRENT WEIGHT';

  @override
  String get checkInContextTitle => 'Check-in Context';

  @override
  String get checkInContextDescription =>
      'Use this context to improve trend interpretation in reports.';

  @override
  String get weightContextLabel => 'Weight context';

  @override
  String get appetiteLabel => 'Appetite';

  @override
  String get stoolLabel => 'Stool';

  @override
  String get vomitLabel => 'Vomit';

  @override
  String get energyLabel => 'Energy';

  @override
  String get checkInNotesTitle => 'Check-in Notes';

  @override
  String get checkInNotesDescription =>
      'Record behavior and clinical follow-up for this weight entry.';

  @override
  String get weightNotesHint =>
      'How is your cat\'s appetite today? Any changes in mood or energy levels?';

  @override
  String get clinicalAssessmentStructuredLabel =>
      'Clinical assessment (structured)';

  @override
  String get clinicalPlanFollowUpLabel => 'Clinical plan / follow-up';

  @override
  String get recordWeightAction => 'Record Weight';

  @override
  String get recordWeightActionUppercase => 'RECORD WEIGHT';

  @override
  String get catProfileTitle => 'Cat Profile';

  @override
  String get deleteProfileTitle => 'Delete profile';

  @override
  String removeProfileMessage(String name) {
    return 'Remove $name from the app?';
  }

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get createNewCatProfileTitle => 'Create a new cat profile';

  @override
  String get catProfileIntroDescription =>
      'Personal data, clinical context and feeding targets in one place.';

  @override
  String get uploadPhotoAction => 'Upload Photo';

  @override
  String get coreProfileSectionTitle => 'Core Profile';

  @override
  String get coreProfileSectionDescription =>
      'Identity and baseline metabolic data used across the app.';

  @override
  String get nameLabel => 'Name';

  @override
  String get enterCatNameError => 'Enter the cat name';

  @override
  String get weightKgLabel => 'Weight (kg)';

  @override
  String get invalidWeightError => 'Invalid weight';

  @override
  String get ageYearsLabel => 'Age (years)';

  @override
  String get invalidAgeError => 'Invalid age';

  @override
  String get neuteredSpayedTitle => 'Neutered / Spayed';

  @override
  String get neuteredSpayedDescription => 'Affects calorie requirements';

  @override
  String get activityLevelLabel => 'Activity level';

  @override
  String get goalLabel => 'Goal';

  @override
  String get preferredMealsPerDayLabel => 'Preferred meals per day';

  @override
  String get manualTargetKcalPerDayOptionalLabel =>
      'Manual target kcal/day (optional)';

  @override
  String get manualTargetKcalHelperText =>
      'Leave empty to keep automatic calculation';

  @override
  String get invalidKcalTargetError => 'Invalid kcal target';

  @override
  String get clinicalContextSectionTitle => 'Clinical Context';

  @override
  String get clinicalContextSectionDescription =>
      'Optional fields that refine recommendations and clinical tracking.';

  @override
  String get idealWeightOptionalLabel => 'Ideal weight (kg) (optional)';

  @override
  String get idealWeightHelperText =>
      'Optional: used to refine kcal suggestions';

  @override
  String get invalidIdealWeightError => 'Invalid ideal weight';

  @override
  String get bodyConditionScoreLabel => 'Body Condition Score (1-9)';

  @override
  String get sexLabel => 'Sex';

  @override
  String get breedOptionalLabel => 'Breed (optional)';

  @override
  String get dateOfBirthOptionalLabel => 'Date of birth (optional)';

  @override
  String get customActivityLevelOptionalLabel =>
      'Custom activity level (optional)';

  @override
  String get customActivityLevelHelperText =>
      'Overrides preset activity labels when provided';

  @override
  String get clinicalConditionsLabel => 'Clinical conditions (comma separated)';

  @override
  String get clinicalConditionsHelperText =>
      'Examples: diabetes, ckd, arthritis';

  @override
  String get allergiesRestrictionsLabel =>
      'Allergies / restrictions (comma separated)';

  @override
  String get allergiesRestrictionsHelperText =>
      'Examples: chicken, beef, dairy';

  @override
  String get dietaryPreferencesLabel => 'Dietary preferences (comma separated)';

  @override
  String get dietaryPreferencesHelperText => 'Examples: grain_free, low_fat';

  @override
  String get veterinaryNotesOptionalLabel => 'Veterinary notes (optional)';

  @override
  String get targetsAlertsSectionTitle => 'Targets & Alerts';

  @override
  String get targetsAlertsSectionDescription =>
      'Set safe weight range and threshold alerts for each check-in.';

  @override
  String get weightGoalsAlertsTitle => 'Weight Goals & Alerts';

  @override
  String get goalMinWeightKgLabel => 'Goal min weight (kg)';

  @override
  String get goalMaxWeightKgLabel => 'Goal max weight (kg)';

  @override
  String get alertDeltaKgPerCheckInLabel => 'Alert delta (kg) per check-in';

  @override
  String get alertDeltaPercentPerCheckInLabel => 'Alert delta (%) per check-in';

  @override
  String get clinicalNotesPreferencesLabel => 'Clinical notes / preferences';

  @override
  String get clinicalNotesPreferencesHelperText =>
      'Examples: sensitive stomach, picky eater, post-surgery, senior support';

  @override
  String catLimitHint(int max) {
    return 'Limit: $max individual cats. Groups are created separately as lightweight operational units.';
  }

  @override
  String get saveChangesAction => 'Save Changes';

  @override
  String get saveProfileAction => 'Save Profile';

  @override
  String get deleteProfileAction => 'Delete Profile';

  @override
  String get profileFeedsAppDescription =>
      'Profiles saved here will feed Home, Plans, Weight Check-in, and Dashboard.';

  @override
  String get nothingSelectedYetTitle => 'Nothing selected yet';

  @override
  String get dailySelectionRequiredDescription =>
      'Select an individual cat or a group from Home and save a plan to unlock the daily dashboard.';

  @override
  String get noGroupPlanYetTitle => 'No group plan yet';

  @override
  String saveGroupPlanBeforeDailyDescription(String name) {
    return 'Save a meal plan for $name in Plans before using Daily.';
  }

  @override
  String get groupPlanNotActiveYetTitle => 'Group plan not active yet';

  @override
  String groupPlanStartsOnDescription(String name, String date) {
    return 'This plan for $name starts on $date.';
  }

  @override
  String get groupSizeMetricTitle => 'GROUP SIZE';

  @override
  String get dailyGoalMetricTitleUppercase => 'DAILY GOAL';

  @override
  String get yesterdayRoutineDuplicatedMessage =>
      'Yesterday routine duplicated for today.';

  @override
  String get duplicateYesterdayRoutineAction => 'Duplicate Yesterday Routine';

  @override
  String get todaysGroupScheduleTitle => 'Today\'s Group Schedule';

  @override
  String get noMealPlanYetTitle => 'No meal plan yet';

  @override
  String savePlanBeforeDailyDescription(String name) {
    return 'Save a meal plan for $name in Plans before using Daily.';
  }

  @override
  String get planNotActiveYetTitle => 'Plan not active yet';

  @override
  String planStartsOnDescription(String name, String date) {
    return 'The plan for $name starts on $date.';
  }

  @override
  String get currentWeightMetricTitle => 'CURRENT WEIGHT';

  @override
  String get genericMealTitle => 'Meal';

  @override
  String get mealTimeTitle => 'Meal time';

  @override
  String get unsetLabel => 'Unset';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get observationsLabel => 'Observations';

  @override
  String get dailyObservationsHint =>
      'Delay reason, refusal, appetite, practical notes, etc.';

  @override
  String get saveLogAction => 'Save Log';

  @override
  String get dailyGreetingTitle => 'Good morning!';

  @override
  String dailyGroupReadyDescription(String name) {
    return '$name group is ready for today\'s routine';
  }

  @override
  String dailyCatReadyDescription(String name) {
    return '$name is ready for today\'s meals';
  }

  @override
  String get todaysScheduleTitle => 'Today\'s Schedule';

  @override
  String loggedQuantityLabel(String quantity, String unit) {
    return 'Logged: $quantity $unit';
  }

  @override
  String noteWithValueLabel(String note) {
    return 'Note: $note';
  }

  @override
  String get updateLogAction => 'UPDATE LOG';

  @override
  String get logMealAction => 'LOG MEAL';

  @override
  String get logEventAction => 'LOG EVENT';

  @override
  String get recordTodaysWeightProgressDescription =>
      'Record today\'s weight progress';

  @override
  String get anytimeLabel => 'Anytime';

  @override
  String get noMealsScheduledTitle => 'No meals scheduled';

  @override
  String get noMealsScheduledDescription =>
      'Save a plan in Plans to generate today\'s schedule.';

  @override
  String get dailyWaterEntryTitle => 'Water';

  @override
  String get dailySnacksEntryTitle => 'Snacks';

  @override
  String get dailySupplementsEntryTitle => 'Supplements';

  @override
  String get dailyWaterGroupSubtitle => 'Register water intake for the group';

  @override
  String get dailyWaterCatSubtitle => 'Register water intake for the cat';

  @override
  String get dailySnacksGroupSubtitle => 'Register snacks offered to the group';

  @override
  String get dailySnacksCatSubtitle => 'Register snacks offered today';

  @override
  String get dailySupplementsGroupSubtitle =>
      'Register supplements for the group';

  @override
  String get dailySupplementsCatSubtitle => 'Register supplements for the cat';

  @override
  String productConfirmedFromDatabaseMessage(String name) {
    return '$name confirmed from database';
  }

  @override
  String get foodGenericLabel => 'Food';

  @override
  String get scannerTitle => 'Scanner';

  @override
  String get cameraUnavailableTitle => 'Camera unavailable';

  @override
  String get cameraUnavailableDescription =>
      'Unable to start camera. On web, use localhost or https, allow camera access, and keep only one tab using the webcam.';

  @override
  String get webCameraNotRunningHint =>
      'Web camera not running yet. Test one browser tab at a time, allow camera access, and try the switch-camera button.';

  @override
  String get alignBarcodeWithinFrameTitle => 'Align barcode within frame';

  @override
  String get typeBarcodeToSimulateScanHint => 'Type barcode to simulate scan';

  @override
  String get noBarcodeScannedYetTitle => 'No barcode scanned yet';

  @override
  String noProductFoundForBarcodeTitle(String barcode) {
    return 'No product found for $barcode';
  }

  @override
  String get unknownBrandLabel => 'Unknown brand';

  @override
  String get kcalPer100gLabel => 'kcal/100g';

  @override
  String get useLiveCameraOrBarcodeDescription =>
      'Use the live camera or the barcode field above.';

  @override
  String get createFoodEntryFromBarcodeDescription =>
      'You can create a new food entry with this barcode.';

  @override
  String get editManuallyAction => 'Edit Manually';

  @override
  String get manualEntryAction => 'Manual Entry';

  @override
  String get useProductAction => 'Use Product';

  @override
  String get confirmProductAction => 'Confirm Product';

  @override
  String get veterinaryGradeNutritionTagline => 'VETERINARY-GRADE NUTRITION';

  @override
  String catLimitReached(int max) {
    return 'Cat limit reached. You can create up to $max cats.';
  }

  @override
  String get invalidImageFile => 'Invalid image file.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortugueseBrazil => 'Portuguese (Brazil)';

  @override
  String get languageTagalog => 'Tagalog';
}

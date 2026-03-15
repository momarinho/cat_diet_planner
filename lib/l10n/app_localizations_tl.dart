// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class AppLocalizationsTl extends AppLocalizations {
  AppLocalizationsTl([String locale = 'tl']) : super(locale);

  @override
  String get appTitle => 'CatDiet Planner';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSectionTitle => 'Wika';

  @override
  String get appLanguageTitle => 'Wika ng app';

  @override
  String get localizedContentScopeTitle => 'Lawak ng naka-localize na content';

  @override
  String get localizedContentScopeDescription =>
      'Susunod na ngayon sa napiling wika ang mga notification at mga text para sa report/share.';

  @override
  String get navDaily => 'Araw';

  @override
  String get navHome => 'Home';

  @override
  String get navPlans => 'Plano';

  @override
  String get navHistory => 'Kasaysayan';

  @override
  String get routeErrorTitle => 'Error sa ruta';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get activeCatTitle => 'Aktibong pusa';

  @override
  String get editAction => 'I-edit';

  @override
  String catAgeYearsOld(int years) {
    return '$years taong gulang';
  }

  @override
  String get scanFoodAction => 'I-scan ang pagkain';

  @override
  String get logWeightAction => 'I-log ang timbang';

  @override
  String get dailySummaryTitle => 'Arawang buod';

  @override
  String get todayLabel => 'Ngayon';

  @override
  String get kcalLabel => 'kcal';

  @override
  String get calorieIntakeLabel => 'CALORIE INTAKE';

  @override
  String get createPlanToUnlockDailySummary =>
      'Gumawa ng plano para makita ang arawang buod';

  @override
  String get todayFullyCompleted => 'Kumpleto na ang araw na ito';

  @override
  String remainingCaloriesForMeal(int kcal, String meal) {
    return '$kcal kcal pa para sa $meal';
  }

  @override
  String get mealTimelineTitle => 'Timeline ng pagkain';

  @override
  String get viewPlanAction => 'Tingnan ang plano';

  @override
  String get noTimelineYetTitle => 'Wala pang timeline';

  @override
  String get noTimelineYetDescription =>
      'Mag-save ng meal plan para makita ang timeline ng pagkain.';

  @override
  String mealFallbackTitle(int number) {
    return 'Kainan $number';
  }

  @override
  String mealMarkedPending(String meal) {
    return '$meal minarkahang pending.';
  }

  @override
  String mealMarkedCompleted(String meal) {
    return '$meal minarkahang completed.';
  }

  @override
  String get planInspectorTitle => 'Inspector ng plano';

  @override
  String get groupPlanInspectorTitle => 'Inspector ng group plan';

  @override
  String get previewTab => 'Preview';

  @override
  String get savedTab => 'Saved';

  @override
  String get noPreviewYetTitle => 'Wala pang preview';

  @override
  String get noPreviewYetDescription =>
      'Ayusin ang foods o plan inputs para makagawa ng preview.';

  @override
  String get noCatSelectedTitle => 'Walang napiling pusa';

  @override
  String get noCatSelectedDescription =>
      'Pumili ng pusa para makita ang saved plans nito.';

  @override
  String get noSavedPlansYetTitle => 'Wala pang saved plans';

  @override
  String get noSavedPlansYetDescription =>
      'Mag-save ng plano para makita ito rito.';

  @override
  String get noGroupSelectedTitle => 'Walang napiling grupo';

  @override
  String get noGroupSelectedDescription =>
      'Pumili ng grupo para makita ang saved plan nito.';

  @override
  String get noSavedGroupPlanTitle => 'Walang saved group plan';

  @override
  String get noSavedGroupPlanDescription =>
      'Mag-save ng group plan para makita ito rito.';

  @override
  String get savedIndividualPlanTitle => 'Saved individual plan';

  @override
  String get savedGroupPlanTitle => 'Saved group plan';

  @override
  String get planPreviewTitle => 'Plan preview';

  @override
  String get groupPlanPreviewTitle => 'Group plan preview';

  @override
  String get savedCoreTargetsTitle => 'Core targets';

  @override
  String get savedCoreTargetsSubtitle =>
      'Mga saved value na kasalukuyang gamit ng planong ito.';

  @override
  String get savedMealTimelineTitle => 'Meal timeline';

  @override
  String get savedMealTimelineSubtitle =>
      'Saved schedule at hatian ng portion sa bawat meal.';

  @override
  String get savedPlanDetailsTitle => 'Plan details';

  @override
  String get savedPlanDetailsSubtitle =>
      'Operational context, notes at saved configuration.';

  @override
  String get previewCoreTargetsTitle => 'Core targets';

  @override
  String get previewCoreTargetsSubtitle =>
      'Mga numerong gagamitin kapag sinave ang draft na ito.';

  @override
  String get previewMealTimelineTitle => 'Meal timeline';

  @override
  String get previewMealTimelineSubtitle =>
      'Bawat feeding slot na may oras at eksaktong portion.';

  @override
  String get previewPlanDetailsTitle => 'Plan details';

  @override
  String get previewPlanDetailsSubtitle =>
      'Kontekstong may epekto sa execution pero madaling ma-miss.';

  @override
  String get customPlanLabel => 'Custom plan';

  @override
  String startsTag(String date) {
    return 'Starts $date';
  }

  @override
  String mealsPerDayTag(int count) {
    return '$count kainan/araw';
  }

  @override
  String catsCountTag(int count) {
    return '$count pusa';
  }

  @override
  String get activePlanTag => 'Aktibong plano';

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
    return '+ $count pa';
  }

  @override
  String get plansTitle => 'Mga plano';

  @override
  String get planInspectorTooltip => 'Preview at saved plan';

  @override
  String get buildPlanTitle => 'Bumuo ng plano';

  @override
  String get individualPlanMode => 'Individual';

  @override
  String get groupPlanMode => 'Grupo';

  @override
  String get catProfileLabel => 'Profile ng pusa';

  @override
  String get groupLabel => 'Grupo';

  @override
  String groupWithCats(String group, int count) {
    return '$group ($count pusa)';
  }

  @override
  String get targetKcalPerCatPerDayLabel => 'Target kcal bawat pusa / araw';

  @override
  String get createGroupAction => 'Gumawa ng grupo';

  @override
  String mealsPerDayChip(int count) {
    return '$count kainan/araw';
  }

  @override
  String get planStartDateTitle => 'Petsa ng simula ng plano';

  @override
  String startsOnLabel(String date) {
    return 'Nagsisimula sa $date';
  }

  @override
  String get portionUnitTitle => 'Unit ng portion';

  @override
  String get unitLabel => 'Unit';

  @override
  String get gramsPerUnitLabel => 'Gramo bawat unit';

  @override
  String get weekendAlternativeTitle => 'Weekend alternative';

  @override
  String get weekendAlternativeDescription =>
      'Mag-apply ng ibang kcal/portion factor tuwing Sabado at Linggo.';

  @override
  String get weekendKcalFactorLabel => 'Weekend kcal factor (%)';

  @override
  String get byWeekdayTitle => 'Ayon sa weekday';

  @override
  String get byWeekdayDescription =>
      'I-enable ang mga partikular na araw at magtakda ng kcal/portion factor para sa bawat isa.';

  @override
  String get factorPercentLabel => 'Factor %';

  @override
  String get operationalNotesLabel => 'Operational notes';

  @override
  String get mealLabelsTitle => 'Mga label ng meal';

  @override
  String mealNameLabel(int count) {
    return 'Pangalan ng meal $count';
  }

  @override
  String get mealPortionsTitle => 'Mga portion ng meal';

  @override
  String get mealPortionsDescription =>
      'Itakda ang porsyento ng daily portion na ihahain sa bawat meal. Nino-normalize ng app ang total sa 100%.';

  @override
  String mealShareLabel(String meal) {
    return 'Bahagi ng $meal (%)';
  }

  @override
  String get mealScheduleTitle => 'Iskedyul ng meal';

  @override
  String get mealScheduleDescription =>
      'Piliin ang oras ng bawat meal. Gagamitin ito ng Daily at Home.';

  @override
  String get suggestionsTitle => 'Mga suhestiyon';

  @override
  String get noCatProfilesAvailableTitle => 'Walang available na cat profiles';

  @override
  String get noCatProfilesAvailableMessage =>
      'Gumawa muna ng cat profile bago bumuo ng individual meal plan.';

  @override
  String get noGroupsAvailableTitle => 'Walang available na grupo';

  @override
  String get noGroupsAvailableMessage =>
      'Gumawa muna ng grupo bago bumuo ng shared meal plan.';

  @override
  String get availableFoodsTitle => 'Mga available na pagkain';

  @override
  String get noFoodsAvailableTitle => 'Walang available na pagkain';

  @override
  String get noFoodsAvailableDescription =>
      'Magdagdag ng pagkain sa Food Database bago gumawa ng plano.';

  @override
  String get multipleFoodsTitle => 'Maramihang pagkain';

  @override
  String get multipleFoodsDescription =>
      'Payagang pumili ng maraming pagkain para sa plano';

  @override
  String get unknownBrand => 'Hindi kilalang brand';

  @override
  String get savePlanAction => 'I-save ang plano';

  @override
  String get saveGroupPlanAction => 'I-save ang group plan';

  @override
  String get savingLabel => 'Sine-save...';

  @override
  String get planDeletedMessage => 'Nabura ang plano.';

  @override
  String planSavedForCatMessage(String name) {
    return 'Na-save ang plano para kay $name';
  }

  @override
  String planSavedForGroupMessage(String name) {
    return 'Na-save ang plano para sa $name';
  }

  @override
  String get enterValidKcalPerCatMessage =>
      'Maglagay ng valid na kcal target bawat pusa.';

  @override
  String get mondayLabel => 'Lunes';

  @override
  String get tuesdayLabel => 'Martes';

  @override
  String get wednesdayLabel => 'Miyerkules';

  @override
  String get thursdayLabel => 'Huwebes';

  @override
  String get fridayLabel => 'Biyernes';

  @override
  String get saturdayLabel => 'Sabado';

  @override
  String get sundayLabel => 'Linggo';

  @override
  String dayFallbackLabel(int weekday) {
    return 'Araw $weekday';
  }

  @override
  String get noActiveSuggestionsDescription =>
      'Walang active suggestions ngayon. Ipagpatuloy ang pag-log ng meals at timbang para gumanda ang guidance.';

  @override
  String get confirmPlanChangeTitle => 'Kumpirmahin ang pagbabago ng plano';

  @override
  String applySuggestionAfterReview(String catName) {
    return 'I-apply ang suhestyong ito kay $catName pagkatapos lamang ng review.';
  }

  @override
  String get responsiblePersonLabel => 'Responsableng tao';

  @override
  String get typeWhoApprovedHint =>
      'I-type kung sino ang nag-apruba ng pagbabagong ito';

  @override
  String get approvalIdentityRequired =>
      'Kailangan ang pagkakakilanlan ng nag-apruba.';

  @override
  String get cancelAction => 'Kanselahin';

  @override
  String get confirmAction => 'Kumpirmahin';

  @override
  String get planUpdatedAfterConfirmation =>
      'Na-update ang plano pagkatapos ng kumpirmasyon.';

  @override
  String get suggestionRecordedWithoutPlanChanges =>
      'Na-record ang suggestion nang walang pagbabago sa plano.';

  @override
  String suggestionConfidenceLabel(String value) {
    return 'Kumpiyansa $value';
  }

  @override
  String get suggestionAcceptedStatus => 'Tinanggap';

  @override
  String get suggestionDeferredStatus => 'Ipinagpaliban';

  @override
  String get suggestionIgnoredStatus => 'Binalewala';

  @override
  String get whyThisSuggestionTitle => 'Bakit ang suhestyong ito:';

  @override
  String get acceptAction => 'Tanggapin';

  @override
  String get deferAction => 'Ipagpaliban';

  @override
  String get ignoreAction => 'Balewalain';

  @override
  String get restoreAction => 'Ibalik';

  @override
  String get autoApplyDisabledMessage =>
      'Naka-disable ang auto-apply. Ang mga pagbabago sa plano ay laging nangangailangan ng kumpirmasyon.';

  @override
  String get suggestionTypeKcal => 'Kcal';

  @override
  String get suggestionTypeSchedule => 'Iskedyul';

  @override
  String get suggestionTypePortions => 'Mga portion';

  @override
  String get suggestionTypePreventiveAlert => 'Preventive Alert';

  @override
  String get suggestionTypeClinicalWatch => 'Clinical Watch';

  @override
  String get reasonWeightTrendUp => 'Tumataas ang kamakailang trend ng timbang';

  @override
  String get reasonWeightTrendDown =>
      'Bumababa ang kamakailang trend ng timbang';

  @override
  String get reasonOutOfGoalMax =>
      'Mas mataas ang timbang kaysa sa naka-configure na goal range';

  @override
  String get reasonOutOfGoalMin =>
      'Mas mababa ang timbang kaysa sa naka-configure na goal range';

  @override
  String get reasonApproachingGoalMax =>
      'Papalapit ang trend sa itaas na hangganan ng goal';

  @override
  String get reasonApproachingGoalMin =>
      'Papalapit ang trend sa ibabang hangganan ng goal';

  @override
  String get reasonAdherenceLow => 'Mas mababa sa target ang meal adherence';

  @override
  String get reasonRefusalFrequent => 'Madalas ang refusal events';

  @override
  String get reasonDelayedFrequent => 'Madalas ang delayed meals';

  @override
  String get reasonAppetiteReduced =>
      'May naitalang reduced appetite kamakailan';

  @override
  String get reasonAppetitePoor => 'May naitalang poor appetite kamakailan';

  @override
  String get reasonVomitFrequent => 'May naitalang madalas na pagsusuka';

  @override
  String get reasonStoolDiarrhea => 'May naitalang diarrhea events';

  @override
  String get reasonClinicalConditionPresent =>
      'May naka-configure na clinical conditions sa profile';

  @override
  String get reasonWeightAlertTriggered =>
      'May mga weight alert na na-trigger kamakailan';

  @override
  String get reasonLowEvidence =>
      'Limitado ang available na data (mababang ebidensya)';

  @override
  String dietWeightRangeError(String min, String max) {
    return 'Ang timbang ay dapat nasa pagitan ng $min at $max kg.';
  }

  @override
  String dietAgeRangeError(String min, String max) {
    return 'Ang edad ay dapat nasa pagitan ng $min at $max buwan.';
  }

  @override
  String get dietFoodCaloriesPositiveError =>
      'Dapat mas mataas sa zero ang calories ng pagkain.';

  @override
  String dietMealsRangeError(String min, String max) {
    return 'Ang meals bawat araw ay dapat nasa pagitan ng $min at $max.';
  }

  @override
  String get dietWeightPositiveError => 'Dapat mas mataas sa zero ang timbang.';

  @override
  String get dietMealsPositiveError =>
      'Dapat mas mataas sa zero ang meals bawat araw.';

  @override
  String portionUnknownUnitError(String unit) {
    return 'Hindi kilalang portion unit na \"$unit\".';
  }

  @override
  String portionZeroEquivalentError(String unit) {
    return 'Ang unit na \"$unit\" ay may zero gram equivalent.';
  }

  @override
  String get noActivePlanAvailableForCat =>
      'Walang active plan para sa pusang ito.';

  @override
  String get noSuggestedPlanChangesAvailableToRevert =>
      'Walang suggested plan change na puwedeng i-revert.';

  @override
  String get lastSuggestedChangeReverted =>
      'Na-revert ang huling suggested change.';

  @override
  String get suggestionDataIncomplete =>
      'Hindi kumpleto ang data ng suggestion.';

  @override
  String get suggestedKcalChangeExceedsSafeBand =>
      'Lumalagpas ang suggested kcal change sa ligtas na adjustment band.';

  @override
  String get suggestedKcalTargetOutsideSafeRange =>
      'Nasa labas ng pinapayagang ligtas na range ang suggested kcal target.';

  @override
  String get unableToRecalculatePortionSafely =>
      'Hindi ligtas na ma-recalculate ang laki ng portion.';

  @override
  String get scheduleChangeExceedsSafeShiftLimit =>
      'Lumalagpas ang pagbabago ng schedule sa ligtas na shift limit.';

  @override
  String get portionRedistributionInvalidForActivePlan =>
      'Hindi valid ang redistribution ng portion para sa active plan.';

  @override
  String get portionShiftExceedsSafeRedistributionLimit =>
      'Lumalagpas ang paglipat ng portion sa ligtas na redistribution limit.';

  @override
  String get portionRedistributionFailedSafetyValidation =>
      'Bumagsak sa safety validation ang redistribution ng portion.';

  @override
  String summaryTargetKcalPerDayChange(
    String fromValue,
    String toValue,
    String delta,
  ) {
    return 'Target kcal/araw: $fromValue -> $toValue ($delta)';
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
  String get revertLastSuggestedChangeTitle =>
      'I-revert ang huling suggested change';

  @override
  String get revertLastSuggestedChangeDescription =>
      'Ibinabalik nito ang snapshot ng plano bago ang pinakahuling suggested change.';

  @override
  String get typeWhoIsRevertingHint =>
      'Ilagay kung sino ang nagre-revert ng pagbabagong ito';

  @override
  String get responsiblePersonRequired =>
      'Kinakailangan ang responsableng tao.';

  @override
  String get revertAction => 'I-revert';

  @override
  String impactRevertedBy(String name) {
    return 'Ni-revert ni $name';
  }

  @override
  String get impactActiveChange => 'Aktibong pagbabago';

  @override
  String impactBeforeAfterKcal(String beforeValue, String afterValue) {
    return 'Bago/pagkatapos na kcal: $beforeValue -> $afterValue';
  }

  @override
  String get unknownPersonLabel => 'hindi kilala';

  @override
  String get shareMessageTitle => 'Share message';

  @override
  String get shareMessageHint =>
      'Mensaheng ginagamit kapag nagshi-share ng report files';

  @override
  String get saveAction => 'I-save';

  @override
  String get mealReminderTimesTitle => 'Mga oras ng meal reminder';

  @override
  String get addTimeAction => 'Magdagdag ng oras';

  @override
  String get saveScheduleAction => 'I-save ang schedule';

  @override
  String get generateDemoDataTitle => 'Gumawa ng demo data';

  @override
  String get generateDemoDataDescription =>
      'Papapalitan nito ang kasalukuyang local data ng ready-to-test na scenario na may isang group, isang individual na pusa, foods, plans, meals at weight history.';

  @override
  String get generateAction => 'Gumawa';

  @override
  String demoDataReadyMessage(int groups, int cats, int foods, int schedules) {
    return 'Handa na ang demo data: $groups group, $cats pusa, $foods foods, $schedules schedules.';
  }

  @override
  String get clearDemoDataTitle => 'Burahin ang demo data';

  @override
  String get clearDemoDataDescription =>
      'Aalisin nito ang local demo data sa app, kasama ang cats, groups, foods, plans, meals at history.';

  @override
  String get clearAction => 'Burahin';

  @override
  String get localDemoDataClearedMessage => 'Na-clear ang local demo data.';

  @override
  String get generateStressDataTitle => 'Gumawa ng stress test data';

  @override
  String get generateStressDataDescription =>
      'Maglo-load ito ng mabigat na operational scenario (hanggang 10 pusa at 5 group) para ma-validate ang navigation, lists at daily routines sa high-volume usage.';

  @override
  String stressScenarioReadyMessage(
    int groups,
    int cats,
    int foods,
    int schedules,
  ) {
    return 'Handa na ang stress scenario: $groups groups, $cats cats, $foods foods, $schedules schedules.';
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
  String get noAcceptedPlanChangesYetTitle =>
      'Wala pang tinanggap na plan changes';

  @override
  String get noAcceptedPlanChangesYetDescription =>
      'Itatala rito ang mga approved suggestion change, kung sino ang tumanggap, kailan, at ano ang nabago.';

  @override
  String get noSuggestionImpactHistoryYetTitle =>
      'Wala pang suggestion impact history';

  @override
  String get noSuggestionImpactHistoryYetDescription =>
      'Dito ise-save ang generated suggestions, accepted changes at before/after snapshots.';

  @override
  String get revertLatestSuggestedAdjustmentDescription =>
      'Ibalik ang pinakabagong plan snapshot na na-save bago na-apply ang suggested adjustment.';

  @override
  String get continueAction => 'Magpatuloy';

  @override
  String get tryAgainAction => 'Subukan muli';

  @override
  String get deleteAction => 'Burahin';

  @override
  String get kgUnit => 'kg';

  @override
  String get catsUnit => 'pusa';

  @override
  String get noneOption => 'Wala';

  @override
  String get normalOption => 'Normal';

  @override
  String get highOption => 'Mataas';

  @override
  String get lowOption => 'Mababa';

  @override
  String get poorOption => 'Mahina';

  @override
  String get reducedOption => 'Nabawasan';

  @override
  String get softOption => 'Malambot';

  @override
  String get hardOption => 'Matigas';

  @override
  String get diarrheaOption => 'Pagtatae';

  @override
  String get occasionalOption => 'Paminsan-minsan';

  @override
  String get frequentOption => 'Madalas';

  @override
  String get otherOption => 'Iba pa';

  @override
  String get sedentaryOption => 'Laging nakaupo';

  @override
  String get moderateOption => 'Katamtaman';

  @override
  String get activeOption => 'Aktibo';

  @override
  String get maleOption => 'Lalaki';

  @override
  String get femaleOption => 'Babae';

  @override
  String get unknownOption => 'Hindi alam';

  @override
  String get maintenanceGoalOption => 'Panatilihin';

  @override
  String get weightLossGoalOption => 'Magbawas ng timbang';

  @override
  String get weightGainGoalOption => 'Magdagdag ng timbang';

  @override
  String get kittenGrowthGoalOption => 'Paglaki ng kuting';

  @override
  String get seniorSupportGoalOption => 'Suporta sa senior';

  @override
  String get recoveryGoalOption => 'Pagbawi';

  @override
  String get postSurgeryGoalOption => 'Pagkatapos ng operasyon';

  @override
  String get completedOption => 'Tapos';

  @override
  String get partialOption => 'Bahagya';

  @override
  String get delayedOption => 'Naantala';

  @override
  String get refusedOption => 'Tinanggihan';

  @override
  String get reducedAppetiteOption => 'Nabawasang gana';

  @override
  String get skippedOption => 'Nilaktawan';

  @override
  String get loggedStatus => 'Naitala';

  @override
  String get weightCheckInTitle => 'Weight check-in';

  @override
  String get noActiveCatTitle => 'Walang aktibong pusa';

  @override
  String get noActiveCatDescription =>
      'Pumili muna ng pusa sa Home bago mag-record ng timbang.';

  @override
  String get weightRecordedWithAlertMessage =>
      'Na-record ang timbang na may alert. Suriin ang goals at clinical notes.';

  @override
  String get weightRecordedMessage => 'Na-record ang timbang.';

  @override
  String get weightNoteSuggestionHighAppetite => 'Malakas kumain';

  @override
  String get weightNoteSuggestionEnergetic => 'Masigla';

  @override
  String get weightNoteSuggestionLazyDay => 'Tamad na araw';

  @override
  String get weightContextFastingOption => 'Walang laman ang tiyan';

  @override
  String get weightContextAfterMealOption => 'Pagkatapos kumain';

  @override
  String get weightContextDifferentScaleOption => 'Ibang timbangan';

  @override
  String get noPreviousCheckInLabel => 'Wala pang nakaraang check-in';

  @override
  String lastCheckInLabel(String date) {
    return 'Huling check-in: $date';
  }

  @override
  String recordingNowLabel(String date, String time) {
    return 'Nagre-record ngayon: $date sa $time';
  }

  @override
  String get lastWeightLabel => 'HULING\nTIMBANG';

  @override
  String get checkInDateTimeTitle => 'Petsa at oras ng check-in';

  @override
  String get currentWeightLabel => 'KASALUKUYANG TIMBANG';

  @override
  String get checkInContextTitle => 'Konteksto ng check-in';

  @override
  String get checkInContextDescription =>
      'Gamitin ang kontekstong ito para mas maayos ang pag-interpret ng trend sa reports.';

  @override
  String get weightContextLabel => 'Konteksto ng timbang';

  @override
  String get appetiteLabel => 'Gana';

  @override
  String get stoolLabel => 'Dumi';

  @override
  String get vomitLabel => 'Pagsusuka';

  @override
  String get energyLabel => 'Enerhiya';

  @override
  String get checkInNotesTitle => 'Mga tala sa check-in';

  @override
  String get checkInNotesDescription =>
      'I-record ang behavior at clinical follow-up para sa timbang na ito.';

  @override
  String get weightNotesHint =>
      'Kumusta ang gana ngayon? May pagbabago ba sa mood o energy?';

  @override
  String get clinicalAssessmentStructuredLabel =>
      'Clinical assessment (structured)';

  @override
  String get clinicalPlanFollowUpLabel => 'Clinical plan / follow-up';

  @override
  String get recordWeightAction => 'I-record ang timbang';

  @override
  String get recordWeightActionUppercase => 'I-RECORD ANG TIMBANG';

  @override
  String get catProfileTitle => 'Cat profile';

  @override
  String get deleteProfileTitle => 'Burahin ang profile';

  @override
  String removeProfileMessage(String name) {
    return 'Tanggalin si $name sa app?';
  }

  @override
  String get editProfileTitle => 'I-edit ang profile';

  @override
  String get createNewCatProfileTitle => 'Gumawa ng bagong cat profile';

  @override
  String get catProfileIntroDescription =>
      'Personal data, clinical context at feeding targets sa iisang lugar.';

  @override
  String get uploadPhotoAction => 'Mag-upload ng litrato';

  @override
  String get coreProfileSectionTitle => 'Core profile';

  @override
  String get coreProfileSectionDescription =>
      'Identity at baseline metabolic data na ginagamit sa buong app.';

  @override
  String get nameLabel => 'Pangalan';

  @override
  String get enterCatNameError => 'Ilagay ang pangalan ng pusa';

  @override
  String get weightKgLabel => 'Timbang (kg)';

  @override
  String get invalidWeightError => 'Hindi wastong timbang';

  @override
  String get ageYearsLabel => 'Edad (taon)';

  @override
  String get invalidAgeError => 'Hindi wastong edad';

  @override
  String get neuteredSpayedTitle => 'Neutered / spayed';

  @override
  String get neuteredSpayedDescription =>
      'Nakakaapekto sa calorie requirements';

  @override
  String get activityLevelLabel => 'Antas ng aktibidad';

  @override
  String get goalLabel => 'Layunin';

  @override
  String get preferredMealsPerDayLabel => 'Gustong bilang ng meals bawat araw';

  @override
  String get manualTargetKcalPerDayOptionalLabel =>
      'Manual target kcal/day (opsyonal)';

  @override
  String get manualTargetKcalHelperText =>
      'Iwanang walang laman para sa automatic calculation';

  @override
  String get invalidKcalTargetError => 'Hindi wastong kcal target';

  @override
  String get clinicalContextSectionTitle => 'Clinical context';

  @override
  String get clinicalContextSectionDescription =>
      'Opsyonal na fields para mas pino ang recommendations at clinical tracking.';

  @override
  String get idealWeightOptionalLabel => 'Ideal weight (kg) (opsyonal)';

  @override
  String get idealWeightHelperText =>
      'Opsyonal: ginagamit para mas pino ang kcal suggestions';

  @override
  String get invalidIdealWeightError => 'Hindi wastong ideal weight';

  @override
  String get bodyConditionScoreLabel => 'Body Condition Score (1-9)';

  @override
  String get sexLabel => 'Kasarian';

  @override
  String get breedOptionalLabel => 'Breed (opsyonal)';

  @override
  String get dateOfBirthOptionalLabel => 'Araw ng kapanganakan (opsyonal)';

  @override
  String get customActivityLevelOptionalLabel =>
      'Custom activity level (opsyonal)';

  @override
  String get customActivityLevelHelperText =>
      'Pinapalitan ang preset activity labels kapag may value';

  @override
  String get clinicalConditionsLabel => 'Clinical conditions (comma separated)';

  @override
  String get clinicalConditionsHelperText =>
      'Halimbawa: diabetes, ckd, arthritis';

  @override
  String get allergiesRestrictionsLabel =>
      'Allergies / restrictions (comma separated)';

  @override
  String get allergiesRestrictionsHelperText =>
      'Halimbawa: chicken, beef, dairy';

  @override
  String get dietaryPreferencesLabel => 'Dietary preferences (comma separated)';

  @override
  String get dietaryPreferencesHelperText => 'Halimbawa: grain_free, low_fat';

  @override
  String get veterinaryNotesOptionalLabel => 'Veterinary notes (opsyonal)';

  @override
  String get targetsAlertsSectionTitle => 'Targets at alerts';

  @override
  String get targetsAlertsSectionDescription =>
      'Magtakda ng ligtas na weight range at threshold alerts sa bawat check-in.';

  @override
  String get weightGoalsAlertsTitle => 'Weight goals at alerts';

  @override
  String get goalMinWeightKgLabel => 'Minimum goal weight (kg)';

  @override
  String get goalMaxWeightKgLabel => 'Maximum goal weight (kg)';

  @override
  String get alertDeltaKgPerCheckInLabel => 'Alert delta (kg) bawat check-in';

  @override
  String get alertDeltaPercentPerCheckInLabel =>
      'Alert delta (%) bawat check-in';

  @override
  String get clinicalNotesPreferencesLabel => 'Clinical notes / preferences';

  @override
  String get clinicalNotesPreferencesHelperText =>
      'Halimbawa: sensitive stomach, picky eater, post-surgery, senior support';

  @override
  String catLimitHint(int max) {
    return 'Limit: $max individual na pusa. Hiwalay na ginagawa ang groups bilang lightweight operational units.';
  }

  @override
  String get saveChangesAction => 'I-save ang changes';

  @override
  String get saveProfileAction => 'I-save ang profile';

  @override
  String get deleteProfileAction => 'Burahin ang profile';

  @override
  String get profileFeedsAppDescription =>
      'Ang mga profile dito ang gagamitin ng Home, Plans, Weight Check-in, at Dashboard.';

  @override
  String get nothingSelectedYetTitle => 'Wala pang napili';

  @override
  String get dailySelectionRequiredDescription =>
      'Pumili ng individual na pusa o group sa Home at mag-save ng plan para magamit ang Daily.';

  @override
  String get noGroupPlanYetTitle => 'Wala pang group plan';

  @override
  String saveGroupPlanBeforeDailyDescription(String name) {
    return 'Mag-save muna ng meal plan para sa $name sa Plans bago gamitin ang Daily.';
  }

  @override
  String get groupPlanNotActiveYetTitle => 'Hindi pa active ang group plan';

  @override
  String groupPlanStartsOnDescription(String name, String date) {
    return 'Magsisimula ang plan para sa $name sa $date.';
  }

  @override
  String get groupSizeMetricTitle => 'LAKI NG GROUP';

  @override
  String get dailyGoalMetricTitleUppercase => 'ARAWANG GOAL';

  @override
  String get yesterdayRoutineDuplicatedMessage =>
      'Kinopya ang routine kahapon para sa ngayon.';

  @override
  String get duplicateYesterdayRoutineAction => 'Kopyahin ang routine kahapon';

  @override
  String get todaysGroupScheduleTitle => 'Schedule ng group ngayong araw';

  @override
  String get noMealPlanYetTitle => 'Wala pang meal plan';

  @override
  String savePlanBeforeDailyDescription(String name) {
    return 'Mag-save muna ng meal plan para kay $name sa Plans bago gamitin ang Daily.';
  }

  @override
  String get planNotActiveYetTitle => 'Hindi pa active ang plan';

  @override
  String planStartsOnDescription(String name, String date) {
    return 'Magsisimula ang plan ni $name sa $date.';
  }

  @override
  String get currentWeightMetricTitle => 'KASALUKUYANG TIMBANG';

  @override
  String get genericMealTitle => 'Meal';

  @override
  String get mealTimeTitle => 'Oras ng meal';

  @override
  String get unsetLabel => 'Hindi nakatakda';

  @override
  String get quantityLabel => 'Dami';

  @override
  String get observationsLabel => 'Observations';

  @override
  String get dailyObservationsHint =>
      'Dahilan ng delay, refusal, appetite, practical notes, atbp.';

  @override
  String get saveLogAction => 'I-save ang log';

  @override
  String get dailyGreetingTitle => 'Magandang umaga!';

  @override
  String dailyGroupReadyDescription(String name) {
    return 'Handa na ang group na $name para sa routine ngayong araw';
  }

  @override
  String dailyCatReadyDescription(String name) {
    return 'Handa na si $name para sa meals ngayong araw';
  }

  @override
  String get todaysScheduleTitle => 'Schedule ngayong araw';

  @override
  String loggedQuantityLabel(String quantity, String unit) {
    return 'Naitala: $quantity $unit';
  }

  @override
  String noteWithValueLabel(String note) {
    return 'Tala: $note';
  }

  @override
  String get updateLogAction => 'I-UPDATE ANG LOG';

  @override
  String get logMealAction => 'I-LOG ANG MEAL';

  @override
  String get logEventAction => 'I-LOG ANG EVENT';

  @override
  String get recordTodaysWeightProgressDescription =>
      'I-record ang progreso ng timbang ngayong araw';

  @override
  String get anytimeLabel => 'Kahit anong oras';

  @override
  String get noMealsScheduledTitle => 'Walang nakaiskedyul na meal';

  @override
  String get noMealsScheduledDescription =>
      'Mag-save ng plan sa Plans para mabuo ang schedule ngayong araw.';

  @override
  String get dailyWaterEntryTitle => 'Tubig';

  @override
  String get dailySnacksEntryTitle => 'Meryenda';

  @override
  String get dailySupplementsEntryTitle => 'Supplements';

  @override
  String get dailyWaterGroupSubtitle => 'I-record ang water intake ng group';

  @override
  String get dailyWaterCatSubtitle => 'I-record ang water intake ng pusa';

  @override
  String get dailySnacksGroupSubtitle =>
      'I-record ang snacks na ibinigay sa group';

  @override
  String get dailySnacksCatSubtitle => 'I-record ang snacks na ibinigay ngayon';

  @override
  String get dailySupplementsGroupSubtitle =>
      'I-record ang supplements para sa group';

  @override
  String get dailySupplementsCatSubtitle =>
      'I-record ang supplements para sa pusa';

  @override
  String productConfirmedFromDatabaseMessage(String name) {
    return 'Nakumpirma mula sa database ang $name';
  }

  @override
  String get foodGenericLabel => 'Pagkain';

  @override
  String get scannerTitle => 'Scanner';

  @override
  String get cameraUnavailableTitle => 'Hindi available ang camera';

  @override
  String get cameraUnavailableDescription =>
      'Hindi masimulan ang camera. Sa web, gumamit ng localhost o https, payagan ang camera access, at isang tab lang ang gumamit ng webcam.';

  @override
  String get webCameraNotRunningHint =>
      'Hindi pa tumatakbo ang web camera. Isang browser tab lang muna, payagan ang camera access, at subukan ang switch-camera button.';

  @override
  String get alignBarcodeWithinFrameTitle =>
      'Ihanay ang barcode sa loob ng frame';

  @override
  String get typeBarcodeToSimulateScanHint =>
      'Mag-type ng barcode para gayahin ang scan';

  @override
  String get noBarcodeScannedYetTitle => 'Wala pang na-scan na barcode';

  @override
  String noProductFoundForBarcodeTitle(String barcode) {
    return 'Walang produktong nakita para sa $barcode';
  }

  @override
  String get unknownBrandLabel => 'Hindi kilalang brand';

  @override
  String get kcalPer100gLabel => 'kcal/100g';

  @override
  String get useLiveCameraOrBarcodeDescription =>
      'Gamitin ang live camera o ang barcode field sa itaas.';

  @override
  String get createFoodEntryFromBarcodeDescription =>
      'Maaari kang gumawa ng bagong food entry gamit ang barcode na ito.';

  @override
  String get editManuallyAction => 'I-edit nang mano-mano';

  @override
  String get manualEntryAction => 'Manual na entry';

  @override
  String get useProductAction => 'Gamitin ang produkto';

  @override
  String get confirmProductAction => 'Kumpirmahin ang produkto';

  @override
  String get veterinaryGradeNutritionTagline => 'VETERINARY-GRADE NUTRITION';

  @override
  String catLimitReached(int max) {
    return 'Naabot na ang limit ng pusa. Maaari kang gumawa ng hanggang $max pusa.';
  }

  @override
  String get invalidImageFile => 'Hindi wastong image file.';

  @override
  String get languageEnglish => 'Ingles';

  @override
  String get languagePortugueseBrazil => 'Portuges (Brazil)';

  @override
  String get languageTagalog => 'Tagalog';

  @override
  String get dataManagementTitle => 'Pamamahala ng data';

  @override
  String get backupDataTitle => 'I-export ang backup';

  @override
  String get backupDataDescription =>
      'Mag-export at magbahagi ng JSON backup ng lahat ng lokal na data ng app.';

  @override
  String get importBackupTitle => 'Mag-import ng backup';

  @override
  String get importBackupDescription =>
      'Ibalik sa device na ito ang dating na-export na JSON backup.';

  @override
  String get importBackupConfirmationDescription =>
      'Papaltan ng pag-import ng backup ang kasalukuyang lokal na data sa device na ito. Magpatuloy lang kung pinagkakatiwalaan mo ang file.';

  @override
  String get importAction => 'Import';

  @override
  String get backupReminderTitle => 'Paalala sa backup';

  @override
  String get backupReminderDescription =>
      'Magpakita ng babala sa Settings kapag oras nang gumawa ulit ng backup.';

  @override
  String get backupReminderFrequencyTitle => 'Dalas ng paalala';

  @override
  String backupReminderEveryDays(int days) {
    return 'Tuwing $days araw';
  }

  @override
  String get backupReminderDueTitle => 'Lagpas na ang backup';

  @override
  String backupReminderDueDescription(int days) {
    return 'Mag-export ng bagong backup bawat $days araw para hindi mawala ang lokal na data ng browser.';
  }

  @override
  String get backupNeverExportedLabel => 'Wala pang na-export na backup';

  @override
  String lastBackupAtLabel(String date) {
    return 'Huling backup: $date';
  }

  @override
  String get backupExportedMessage => 'Matagumpay na na-export ang backup.';

  @override
  String backupImportedMessage(int groups, int cats, int foods, int plans) {
    return 'Naibalik ang backup: $groups group, $cats pusa, $foods pagkain at $plans plan.';
  }

  @override
  String get backupImportFailedMessage =>
      'Hindi ma-import ang backup file na ito.';

  @override
  String get generateDemoDataListTileDescription =>
      'Gumawa ng isang group, isang solo na pusa, mga pagkain, plans, meals at weight history.';

  @override
  String get generateStressDataListTileDescription =>
      'Gumawa ng high-volume na scenario para masubukan ang UI ng maraming pusa at group.';

  @override
  String get clearDemoDataListTileDescription =>
      'Tanggalin ang lokal na mga pusa, group, pagkain, plans, meals at history.';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('tl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CatDiet Planner'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @appLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguageTitle;

  /// No description provided for @localizedContentScopeTitle.
  ///
  /// In en, this message translates to:
  /// **'Localized content scope'**
  String get localizedContentScopeTitle;

  /// No description provided for @localizedContentScopeDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications and report/share texts now follow the selected language.'**
  String get localizedContentScopeDescription;

  /// No description provided for @navDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get navDaily;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get navPlans;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @routeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Route Error'**
  String get routeErrorTitle;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @activeCatTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Cat'**
  String get activeCatTitle;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @catAgeYearsOld.
  ///
  /// In en, this message translates to:
  /// **'{years} Years Old'**
  String catAgeYearsOld(int years);

  /// No description provided for @scanFoodAction.
  ///
  /// In en, this message translates to:
  /// **'Scan Food'**
  String get scanFoodAction;

  /// No description provided for @logWeightAction.
  ///
  /// In en, this message translates to:
  /// **'Log Weight'**
  String get logWeightAction;

  /// No description provided for @dailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummaryTitle;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @kcalLabel.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcalLabel;

  /// No description provided for @calorieIntakeLabel.
  ///
  /// In en, this message translates to:
  /// **'CALORIE INTAKE'**
  String get calorieIntakeLabel;

  /// No description provided for @createPlanToUnlockDailySummary.
  ///
  /// In en, this message translates to:
  /// **'Create a plan to unlock your daily summary'**
  String get createPlanToUnlockDailySummary;

  /// No description provided for @todayFullyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Today is fully completed'**
  String get todayFullyCompleted;

  /// No description provided for @remainingCaloriesForMeal.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal remaining for {meal}'**
  String remainingCaloriesForMeal(int kcal, String meal);

  /// No description provided for @mealTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Timeline'**
  String get mealTimelineTitle;

  /// No description provided for @viewPlanAction.
  ///
  /// In en, this message translates to:
  /// **'View Plan'**
  String get viewPlanAction;

  /// No description provided for @noTimelineYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No timeline yet'**
  String get noTimelineYetTitle;

  /// No description provided for @noTimelineYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a meal plan to unlock the meal timeline.'**
  String get noTimelineYetDescription;

  /// No description provided for @mealFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal {number}'**
  String mealFallbackTitle(int number);

  /// No description provided for @mealMarkedPending.
  ///
  /// In en, this message translates to:
  /// **'{meal} marked as pending.'**
  String mealMarkedPending(String meal);

  /// No description provided for @mealMarkedCompleted.
  ///
  /// In en, this message translates to:
  /// **'{meal} marked as completed.'**
  String mealMarkedCompleted(String meal);

  /// No description provided for @planInspectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Inspector'**
  String get planInspectorTitle;

  /// No description provided for @groupPlanInspectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Plan Inspector'**
  String get groupPlanInspectorTitle;

  /// No description provided for @previewTab.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTab;

  /// No description provided for @savedTab.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTab;

  /// No description provided for @noPreviewYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No preview yet'**
  String get noPreviewYetTitle;

  /// No description provided for @noPreviewYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust foods or plan inputs to generate a preview.'**
  String get noPreviewYetDescription;

  /// No description provided for @noCatSelectedTitle.
  ///
  /// In en, this message translates to:
  /// **'No cat selected'**
  String get noCatSelectedTitle;

  /// No description provided for @noCatSelectedDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a cat to inspect its saved plans.'**
  String get noCatSelectedDescription;

  /// No description provided for @noSavedPlansYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved plans yet'**
  String get noSavedPlansYetTitle;

  /// No description provided for @noSavedPlansYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a plan to inspect it here.'**
  String get noSavedPlansYetDescription;

  /// No description provided for @noGroupSelectedTitle.
  ///
  /// In en, this message translates to:
  /// **'No group selected'**
  String get noGroupSelectedTitle;

  /// No description provided for @noGroupSelectedDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a group to inspect its saved plan.'**
  String get noGroupSelectedDescription;

  /// No description provided for @noSavedGroupPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved group plan'**
  String get noSavedGroupPlanTitle;

  /// No description provided for @noSavedGroupPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a group plan to inspect it here.'**
  String get noSavedGroupPlanDescription;

  /// No description provided for @savedIndividualPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Individual Plan'**
  String get savedIndividualPlanTitle;

  /// No description provided for @savedGroupPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Group Plan'**
  String get savedGroupPlanTitle;

  /// No description provided for @planPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Preview'**
  String get planPreviewTitle;

  /// No description provided for @groupPlanPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Plan Preview'**
  String get groupPlanPreviewTitle;

  /// No description provided for @savedCoreTargetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Core targets'**
  String get savedCoreTargetsTitle;

  /// No description provided for @savedCoreTargetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved values currently being used by this plan.'**
  String get savedCoreTargetsSubtitle;

  /// No description provided for @savedMealTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal timeline'**
  String get savedMealTimelineTitle;

  /// No description provided for @savedMealTimelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved schedule and portion split for each meal.'**
  String get savedMealTimelineSubtitle;

  /// No description provided for @savedPlanDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan details'**
  String get savedPlanDetailsTitle;

  /// No description provided for @savedPlanDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Operational context, notes and saved configuration.'**
  String get savedPlanDetailsSubtitle;

  /// No description provided for @previewCoreTargetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Core targets'**
  String get previewCoreTargetsTitle;

  /// No description provided for @previewCoreTargetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The numbers that will be used when this draft is saved.'**
  String get previewCoreTargetsSubtitle;

  /// No description provided for @previewMealTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal timeline'**
  String get previewMealTimelineTitle;

  /// No description provided for @previewMealTimelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each feeding slot with time and exact portion.'**
  String get previewMealTimelineSubtitle;

  /// No description provided for @previewPlanDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan details'**
  String get previewPlanDetailsTitle;

  /// No description provided for @previewPlanDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Context that affects execution but is easy to miss.'**
  String get previewPlanDetailsSubtitle;

  /// No description provided for @customPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom plan'**
  String get customPlanLabel;

  /// Compact tag shown on plan cards to indicate when a plan begins.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String startsTag(String date);

  /// Compact tag shown on plan cards for meal frequency.
  ///
  /// In en, this message translates to:
  /// **'{count} meals/day'**
  String mealsPerDayTag(int count);

  /// Compact tag shown on group plan cards for number of cats.
  ///
  /// In en, this message translates to:
  /// **'{count} cats'**
  String catsCountTag(int count);

  /// No description provided for @activePlanTag.
  ///
  /// In en, this message translates to:
  /// **'Active plan'**
  String get activePlanTag;

  /// No description provided for @metricDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get metricDailyGoal;

  /// No description provided for @metricFoodPerDay.
  ///
  /// In en, this message translates to:
  /// **'Food per day'**
  String get metricFoodPerDay;

  /// No description provided for @metricAveragePerMeal.
  ///
  /// In en, this message translates to:
  /// **'Average per meal'**
  String get metricAveragePerMeal;

  /// No description provided for @metricServingUnit.
  ///
  /// In en, this message translates to:
  /// **'Serving unit'**
  String get metricServingUnit;

  /// No description provided for @metricPerCat.
  ///
  /// In en, this message translates to:
  /// **'Per cat'**
  String get metricPerCat;

  /// No description provided for @metricGroupTotal.
  ///
  /// In en, this message translates to:
  /// **'Group total'**
  String get metricGroupTotal;

  /// No description provided for @metricGroupPerDay.
  ///
  /// In en, this message translates to:
  /// **'Group per day'**
  String get metricGroupPerDay;

  /// No description provided for @metricGroupPerMeal.
  ///
  /// In en, this message translates to:
  /// **'Group per meal'**
  String get metricGroupPerMeal;

  /// No description provided for @metricSavedAt.
  ///
  /// In en, this message translates to:
  /// **'Saved at'**
  String get metricSavedAt;

  /// No description provided for @metricOverrides.
  ///
  /// In en, this message translates to:
  /// **'Overrides'**
  String get metricOverrides;

  /// No description provided for @metricFoods.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get metricFoods;

  /// No description provided for @metricNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get metricNotes;

  /// No description provided for @metricStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get metricStarts;

  /// No description provided for @metricDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get metricDistribution;

  /// No description provided for @helperEnergyTarget.
  ///
  /// In en, this message translates to:
  /// **'Energy target'**
  String get helperEnergyTarget;

  /// No description provided for @helperTotalPortion.
  ///
  /// In en, this message translates to:
  /// **'Total portion'**
  String get helperTotalPortion;

  /// No description provided for @helperBaselineSplit.
  ///
  /// In en, this message translates to:
  /// **'Baseline split'**
  String get helperBaselineSplit;

  /// No description provided for @helperDisplayUnit.
  ///
  /// In en, this message translates to:
  /// **'Display unit'**
  String get helperDisplayUnit;

  /// No description provided for @helperEnergyTargetPerCat.
  ///
  /// In en, this message translates to:
  /// **'Energy target per cat'**
  String get helperEnergyTargetPerCat;

  /// No description provided for @helperCombinedEnergyTarget.
  ///
  /// In en, this message translates to:
  /// **'Combined energy target'**
  String get helperCombinedEnergyTarget;

  /// No description provided for @helperAverageFeedingSlot.
  ///
  /// In en, this message translates to:
  /// **'Average feeding slot'**
  String get helperAverageFeedingSlot;

  /// No description provided for @noActiveOverrides.
  ///
  /// In en, this message translates to:
  /// **'No active overrides'**
  String get noActiveOverrides;

  /// Summary label for how many active daily overrides a plan has.
  ///
  /// In en, this message translates to:
  /// **'{count} active overrides'**
  String activeOverridesCount(int count);

  /// No description provided for @noNotesYet.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get noNotesYet;

  /// No description provided for @equalSplitLabel.
  ///
  /// In en, this message translates to:
  /// **'Equal split'**
  String get equalSplitLabel;

  /// Distribution label for group plans when cats do not share equal weights.
  ///
  /// In en, this message translates to:
  /// **'Unequal ({count} cats)'**
  String unequalSplitLabel(int count);

  /// No description provided for @activePlanLabelText.
  ///
  /// In en, this message translates to:
  /// **'Active plan'**
  String get activePlanLabelText;

  /// Button label to activate a saved plan starting on a given date.
  ///
  /// In en, this message translates to:
  /// **'Use {date}'**
  String usePlanAction(String date);

  /// No description provided for @deleteActivePlanAction.
  ///
  /// In en, this message translates to:
  /// **'Delete active plan'**
  String get deleteActivePlanAction;

  /// No description provided for @scheduledFeedingSlotCaption.
  ///
  /// In en, this message translates to:
  /// **'Scheduled feeding slot'**
  String get scheduledFeedingSlotCaption;

  /// Suffix for group plan headline when there are additional foods beyond the first one.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more'**
  String plusMoreFoods(int count);

  /// No description provided for @plansTitle.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plansTitle;

  /// No description provided for @planInspectorTooltip.
  ///
  /// In en, this message translates to:
  /// **'Preview and saved plan'**
  String get planInspectorTooltip;

  /// No description provided for @buildPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Plan'**
  String get buildPlanTitle;

  /// No description provided for @individualPlanMode.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individualPlanMode;

  /// No description provided for @groupPlanMode.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupPlanMode;

  /// No description provided for @catProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Cat Profile'**
  String get catProfileLabel;

  /// No description provided for @groupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupLabel;

  /// Label for a cat group with its member count.
  ///
  /// In en, this message translates to:
  /// **'{group} ({count} cats)'**
  String groupWithCats(String group, int count);

  /// No description provided for @targetKcalPerCatPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Target kcal per cat / day'**
  String get targetKcalPerCatPerDayLabel;

  /// No description provided for @createGroupAction.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroupAction;

  /// No description provided for @mealsPerDayChip.
  ///
  /// In en, this message translates to:
  /// **'{count} meals/day'**
  String mealsPerDayChip(int count);

  /// No description provided for @planStartDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Start Date'**
  String get planStartDateTitle;

  /// No description provided for @startsOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Starts on {date}'**
  String startsOnLabel(String date);

  /// No description provided for @portionUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Portion Unit'**
  String get portionUnitTitle;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @gramsPerUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Grams per unit'**
  String get gramsPerUnitLabel;

  /// No description provided for @weekendAlternativeTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekend alternative'**
  String get weekendAlternativeTitle;

  /// No description provided for @weekendAlternativeDescription.
  ///
  /// In en, this message translates to:
  /// **'Apply a different kcal/portion factor on Saturday and Sunday.'**
  String get weekendAlternativeDescription;

  /// No description provided for @weekendKcalFactorLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekend kcal factor (%)'**
  String get weekendKcalFactorLabel;

  /// No description provided for @byWeekdayTitle.
  ///
  /// In en, this message translates to:
  /// **'By Weekday'**
  String get byWeekdayTitle;

  /// No description provided for @byWeekdayDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable specific days and set a kcal/portion factor for each day.'**
  String get byWeekdayDescription;

  /// No description provided for @factorPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Factor %'**
  String get factorPercentLabel;

  /// No description provided for @operationalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Operational notes'**
  String get operationalNotesLabel;

  /// No description provided for @mealLabelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Labels'**
  String get mealLabelsTitle;

  /// No description provided for @mealNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal {count} name'**
  String mealNameLabel(int count);

  /// No description provided for @mealPortionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Portions'**
  String get mealPortionsTitle;

  /// No description provided for @mealPortionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Set the percentage of the daily portion served in each meal. The app normalizes the total to 100%.'**
  String get mealPortionsDescription;

  /// Form label for the percentage of the daily portion assigned to a meal.
  ///
  /// In en, this message translates to:
  /// **'{meal} share (%)'**
  String mealShareLabel(String meal);

  /// No description provided for @mealScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Schedule'**
  String get mealScheduleTitle;

  /// No description provided for @mealScheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the time for each meal. Daily and Home will use this schedule.'**
  String get mealScheduleDescription;

  /// No description provided for @suggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestionsTitle;

  /// No description provided for @noCatProfilesAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'No cat profiles available'**
  String get noCatProfilesAvailableTitle;

  /// No description provided for @noCatProfilesAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a cat profile before building an individual meal plan.'**
  String get noCatProfilesAvailableMessage;

  /// No description provided for @noGroupsAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'No groups available'**
  String get noGroupsAvailableTitle;

  /// No description provided for @noGroupsAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a group before building a shared meal plan.'**
  String get noGroupsAvailableMessage;

  /// No description provided for @availableFoodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Available Foods'**
  String get availableFoodsTitle;

  /// No description provided for @noFoodsAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'No foods available'**
  String get noFoodsAvailableTitle;

  /// No description provided for @noFoodsAvailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Add foods in Food Database before creating a plan.'**
  String get noFoodsAvailableDescription;

  /// No description provided for @multipleFoodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Multiple foods'**
  String get multipleFoodsTitle;

  /// No description provided for @multipleFoodsDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow selecting multiple foods for the plan'**
  String get multipleFoodsDescription;

  /// No description provided for @unknownBrand.
  ///
  /// In en, this message translates to:
  /// **'Unknown brand'**
  String get unknownBrand;

  /// No description provided for @savePlanAction.
  ///
  /// In en, this message translates to:
  /// **'Save Plan'**
  String get savePlanAction;

  /// No description provided for @saveGroupPlanAction.
  ///
  /// In en, this message translates to:
  /// **'Save Group Plan'**
  String get saveGroupPlanAction;

  /// No description provided for @savingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingLabel;

  /// No description provided for @planDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Plan deleted.'**
  String get planDeletedMessage;

  /// No description provided for @planSavedForCatMessage.
  ///
  /// In en, this message translates to:
  /// **'Plan saved for {name}'**
  String planSavedForCatMessage(String name);

  /// No description provided for @planSavedForGroupMessage.
  ///
  /// In en, this message translates to:
  /// **'Plan saved for {name}'**
  String planSavedForGroupMessage(String name);

  /// No description provided for @enterValidKcalPerCatMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid kcal target per cat.'**
  String get enterValidKcalPerCatMessage;

  /// No description provided for @mondayLabel.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get mondayLabel;

  /// No description provided for @tuesdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesdayLabel;

  /// No description provided for @wednesdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesdayLabel;

  /// No description provided for @thursdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursdayLabel;

  /// No description provided for @fridayLabel.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get fridayLabel;

  /// No description provided for @saturdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturdayLabel;

  /// No description provided for @sundayLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sundayLabel;

  /// No description provided for @dayFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {weekday}'**
  String dayFallbackLabel(int weekday);

  /// No description provided for @noActiveSuggestionsDescription.
  ///
  /// In en, this message translates to:
  /// **'No active suggestions right now. Keep logging meals and weight to improve guidance.'**
  String get noActiveSuggestionsDescription;

  /// No description provided for @confirmPlanChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm plan change'**
  String get confirmPlanChangeTitle;

  /// Confirmation dialog body before applying a suggestion to a cat plan.
  ///
  /// In en, this message translates to:
  /// **'Apply this suggestion to {catName} only after review.'**
  String applySuggestionAfterReview(String catName);

  /// No description provided for @responsiblePersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Responsible person'**
  String get responsiblePersonLabel;

  /// No description provided for @typeWhoApprovedHint.
  ///
  /// In en, this message translates to:
  /// **'Type who approved this change'**
  String get typeWhoApprovedHint;

  /// No description provided for @approvalIdentityRequired.
  ///
  /// In en, this message translates to:
  /// **'Approval identity is required.'**
  String get approvalIdentityRequired;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// No description provided for @planUpdatedAfterConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Plan updated after confirmation.'**
  String get planUpdatedAfterConfirmation;

  /// No description provided for @suggestionRecordedWithoutPlanChanges.
  ///
  /// In en, this message translates to:
  /// **'Suggestion recorded without plan changes.'**
  String get suggestionRecordedWithoutPlanChanges;

  /// Confidence badge shown on a suggestion card.
  ///
  /// In en, this message translates to:
  /// **'Confidence {value}'**
  String suggestionConfidenceLabel(String value);

  /// No description provided for @suggestionAcceptedStatus.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get suggestionAcceptedStatus;

  /// No description provided for @suggestionDeferredStatus.
  ///
  /// In en, this message translates to:
  /// **'Deferred'**
  String get suggestionDeferredStatus;

  /// No description provided for @suggestionIgnoredStatus.
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get suggestionIgnoredStatus;

  /// No description provided for @whyThisSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this suggestion:'**
  String get whyThisSuggestionTitle;

  /// No description provided for @acceptAction.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptAction;

  /// No description provided for @deferAction.
  ///
  /// In en, this message translates to:
  /// **'Defer'**
  String get deferAction;

  /// No description provided for @ignoreAction.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignoreAction;

  /// No description provided for @restoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreAction;

  /// No description provided for @autoApplyDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Auto-apply is disabled. Plan changes always require confirmation.'**
  String get autoApplyDisabledMessage;

  /// No description provided for @suggestionTypeKcal.
  ///
  /// In en, this message translates to:
  /// **'Kcal'**
  String get suggestionTypeKcal;

  /// No description provided for @suggestionTypeSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get suggestionTypeSchedule;

  /// No description provided for @suggestionTypePortions.
  ///
  /// In en, this message translates to:
  /// **'Portions'**
  String get suggestionTypePortions;

  /// No description provided for @suggestionTypePreventiveAlert.
  ///
  /// In en, this message translates to:
  /// **'Preventive Alert'**
  String get suggestionTypePreventiveAlert;

  /// No description provided for @suggestionTypeClinicalWatch.
  ///
  /// In en, this message translates to:
  /// **'Clinical Watch'**
  String get suggestionTypeClinicalWatch;

  /// No description provided for @reasonWeightTrendUp.
  ///
  /// In en, this message translates to:
  /// **'Recent weight trend is increasing'**
  String get reasonWeightTrendUp;

  /// No description provided for @reasonWeightTrendDown.
  ///
  /// In en, this message translates to:
  /// **'Recent weight trend is decreasing'**
  String get reasonWeightTrendDown;

  /// No description provided for @reasonOutOfGoalMax.
  ///
  /// In en, this message translates to:
  /// **'Weight is above configured goal range'**
  String get reasonOutOfGoalMax;

  /// No description provided for @reasonOutOfGoalMin.
  ///
  /// In en, this message translates to:
  /// **'Weight is below configured goal range'**
  String get reasonOutOfGoalMin;

  /// No description provided for @reasonApproachingGoalMax.
  ///
  /// In en, this message translates to:
  /// **'Trend is approaching the upper goal boundary'**
  String get reasonApproachingGoalMax;

  /// No description provided for @reasonApproachingGoalMin.
  ///
  /// In en, this message translates to:
  /// **'Trend is approaching the lower goal boundary'**
  String get reasonApproachingGoalMin;

  /// No description provided for @reasonAdherenceLow.
  ///
  /// In en, this message translates to:
  /// **'Meal adherence is below target'**
  String get reasonAdherenceLow;

  /// No description provided for @reasonRefusalFrequent.
  ///
  /// In en, this message translates to:
  /// **'Refusal events are frequent'**
  String get reasonRefusalFrequent;

  /// No description provided for @reasonDelayedFrequent.
  ///
  /// In en, this message translates to:
  /// **'Delayed meals are frequent'**
  String get reasonDelayedFrequent;

  /// No description provided for @reasonAppetiteReduced.
  ///
  /// In en, this message translates to:
  /// **'Reduced appetite was logged recently'**
  String get reasonAppetiteReduced;

  /// No description provided for @reasonAppetitePoor.
  ///
  /// In en, this message translates to:
  /// **'Poor appetite was logged recently'**
  String get reasonAppetitePoor;

  /// No description provided for @reasonVomitFrequent.
  ///
  /// In en, this message translates to:
  /// **'Frequent vomit events were logged'**
  String get reasonVomitFrequent;

  /// No description provided for @reasonStoolDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea events were logged'**
  String get reasonStoolDiarrhea;

  /// No description provided for @reasonClinicalConditionPresent.
  ///
  /// In en, this message translates to:
  /// **'Clinical conditions are configured on profile'**
  String get reasonClinicalConditionPresent;

  /// No description provided for @reasonWeightAlertTriggered.
  ///
  /// In en, this message translates to:
  /// **'Weight alerts were triggered recently'**
  String get reasonWeightAlertTriggered;

  /// No description provided for @reasonLowEvidence.
  ///
  /// In en, this message translates to:
  /// **'Limited data available (low evidence)'**
  String get reasonLowEvidence;

  /// No description provided for @dietWeightRangeError.
  ///
  /// In en, this message translates to:
  /// **'Weight must be between {min} and {max} kg.'**
  String dietWeightRangeError(String min, String max);

  /// No description provided for @dietAgeRangeError.
  ///
  /// In en, this message translates to:
  /// **'Age must be between {min} and {max} months.'**
  String dietAgeRangeError(String min, String max);

  /// No description provided for @dietFoodCaloriesPositiveError.
  ///
  /// In en, this message translates to:
  /// **'Food calories must be greater than zero.'**
  String get dietFoodCaloriesPositiveError;

  /// No description provided for @dietMealsRangeError.
  ///
  /// In en, this message translates to:
  /// **'Meals per day must be between {min} and {max}.'**
  String dietMealsRangeError(String min, String max);

  /// No description provided for @dietWeightPositiveError.
  ///
  /// In en, this message translates to:
  /// **'Weight must be greater than zero.'**
  String get dietWeightPositiveError;

  /// No description provided for @dietMealsPositiveError.
  ///
  /// In en, this message translates to:
  /// **'Meals per day must be greater than zero.'**
  String get dietMealsPositiveError;

  /// No description provided for @portionUnknownUnitError.
  ///
  /// In en, this message translates to:
  /// **'Unknown portion unit \"{unit}\".'**
  String portionUnknownUnitError(String unit);

  /// No description provided for @portionZeroEquivalentError.
  ///
  /// In en, this message translates to:
  /// **'Unit \"{unit}\" has a zero gram equivalent.'**
  String portionZeroEquivalentError(String unit);

  /// No description provided for @noActivePlanAvailableForCat.
  ///
  /// In en, this message translates to:
  /// **'No active plan available for this cat.'**
  String get noActivePlanAvailableForCat;

  /// No description provided for @noSuggestedPlanChangesAvailableToRevert.
  ///
  /// In en, this message translates to:
  /// **'No suggested plan changes available to revert.'**
  String get noSuggestedPlanChangesAvailableToRevert;

  /// No description provided for @lastSuggestedChangeReverted.
  ///
  /// In en, this message translates to:
  /// **'Last suggested change reverted.'**
  String get lastSuggestedChangeReverted;

  /// No description provided for @suggestionDataIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Suggestion data is incomplete.'**
  String get suggestionDataIncomplete;

  /// No description provided for @suggestedKcalChangeExceedsSafeBand.
  ///
  /// In en, this message translates to:
  /// **'Suggested kcal change exceeds the safe adjustment band.'**
  String get suggestedKcalChangeExceedsSafeBand;

  /// No description provided for @suggestedKcalTargetOutsideSafeRange.
  ///
  /// In en, this message translates to:
  /// **'Suggested kcal target is outside the allowed safe range.'**
  String get suggestedKcalTargetOutsideSafeRange;

  /// No description provided for @unableToRecalculatePortionSafely.
  ///
  /// In en, this message translates to:
  /// **'Unable to recalculate portion size safely.'**
  String get unableToRecalculatePortionSafely;

  /// No description provided for @scheduleChangeExceedsSafeShiftLimit.
  ///
  /// In en, this message translates to:
  /// **'Schedule change exceeds the safe shift limit.'**
  String get scheduleChangeExceedsSafeShiftLimit;

  /// No description provided for @portionRedistributionInvalidForActivePlan.
  ///
  /// In en, this message translates to:
  /// **'Portion redistribution is invalid for the active plan.'**
  String get portionRedistributionInvalidForActivePlan;

  /// No description provided for @portionShiftExceedsSafeRedistributionLimit.
  ///
  /// In en, this message translates to:
  /// **'Portion shift exceeds the safe redistribution limit.'**
  String get portionShiftExceedsSafeRedistributionLimit;

  /// No description provided for @portionRedistributionFailedSafetyValidation.
  ///
  /// In en, this message translates to:
  /// **'Portion redistribution failed safety validation.'**
  String get portionRedistributionFailedSafetyValidation;

  /// Localized audit summary line for kcal/day changes in a suggested plan adjustment.
  ///
  /// In en, this message translates to:
  /// **'Target kcal/day: {fromValue} -> {toValue} ({delta})'**
  String summaryTargetKcalPerDayChange(
    String fromValue,
    String toValue,
    String delta,
  );

  /// Localized audit summary line for total daily portion changes.
  ///
  /// In en, this message translates to:
  /// **'Daily portion: {fromValue} -> {toValue}'**
  String summaryDailyPortionChange(String fromValue, String toValue);

  /// Localized audit summary line for a meal time shift.
  ///
  /// In en, this message translates to:
  /// **'{meal}: {fromValue} -> {toValue}'**
  String summaryMealTimeChange(String meal, String fromValue, String toValue);

  /// Localized audit summary line for a meal portion redistribution.
  ///
  /// In en, this message translates to:
  /// **'{meal}: {fromValue} -> {toValue}'**
  String summaryMealPortionChange(
    String meal,
    String fromValue,
    String toValue,
  );

  /// No description provided for @revertLastSuggestedChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revert last suggested change'**
  String get revertLastSuggestedChangeTitle;

  /// No description provided for @revertLastSuggestedChangeDescription.
  ///
  /// In en, this message translates to:
  /// **'This restores the plan snapshot from before the latest suggested change.'**
  String get revertLastSuggestedChangeDescription;

  /// No description provided for @typeWhoIsRevertingHint.
  ///
  /// In en, this message translates to:
  /// **'Type who is reverting this change'**
  String get typeWhoIsRevertingHint;

  /// No description provided for @responsiblePersonRequired.
  ///
  /// In en, this message translates to:
  /// **'Responsible person is required.'**
  String get responsiblePersonRequired;

  /// No description provided for @revertAction.
  ///
  /// In en, this message translates to:
  /// **'Revert'**
  String get revertAction;

  /// No description provided for @impactRevertedBy.
  ///
  /// In en, this message translates to:
  /// **'Reverted by {name}'**
  String impactRevertedBy(String name);

  /// No description provided for @impactActiveChange.
  ///
  /// In en, this message translates to:
  /// **'Active change'**
  String get impactActiveChange;

  /// No description provided for @impactBeforeAfterKcal.
  ///
  /// In en, this message translates to:
  /// **'Before/after kcal: {beforeValue} -> {afterValue}'**
  String impactBeforeAfterKcal(String beforeValue, String afterValue);

  /// No description provided for @unknownPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get unknownPersonLabel;

  /// No description provided for @shareMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Share message'**
  String get shareMessageTitle;

  /// No description provided for @shareMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message used when sharing report files'**
  String get shareMessageHint;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @mealReminderTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Reminder Times'**
  String get mealReminderTimesTitle;

  /// No description provided for @addTimeAction.
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTimeAction;

  /// No description provided for @saveScheduleAction.
  ///
  /// In en, this message translates to:
  /// **'Save Schedule'**
  String get saveScheduleAction;

  /// No description provided for @generateDemoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate demo data'**
  String get generateDemoDataTitle;

  /// No description provided for @generateDemoDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will replace the current local data with a ready-to-test scenario containing one group, one individual cat, foods, plans, meals and weight history.'**
  String get generateDemoDataDescription;

  /// No description provided for @generateAction.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generateAction;

  /// Snackbar shown after generating the ready-to-test demo scenario.
  ///
  /// In en, this message translates to:
  /// **'Demo data ready: {groups} group, {cats} cat, {foods} foods, {schedules} schedules.'**
  String demoDataReadyMessage(int groups, int cats, int foods, int schedules);

  /// No description provided for @clearDemoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear demo data'**
  String get clearDemoDataTitle;

  /// No description provided for @clearDemoDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will remove the local demo data from the app, including cats, groups, foods, plans, meals and history.'**
  String get clearDemoDataDescription;

  /// No description provided for @clearAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearAction;

  /// No description provided for @localDemoDataClearedMessage.
  ///
  /// In en, this message translates to:
  /// **'Local demo data cleared.'**
  String get localDemoDataClearedMessage;

  /// No description provided for @generateStressDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate stress test data'**
  String get generateStressDataTitle;

  /// No description provided for @generateStressDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will load a heavy operational scenario (up to 10 cats and 5 groups) to validate navigation, lists and daily routines in high-volume usage.'**
  String get generateStressDataDescription;

  /// Snackbar shown after generating the high-volume stress scenario.
  ///
  /// In en, this message translates to:
  /// **'Stress scenario ready: {groups} groups, {cats} cats, {foods} foods, {schedules} schedules.'**
  String stressScenarioReadyMessage(
    int groups,
    int cats,
    int foods,
    int schedules,
  );

  /// No description provided for @customRangeDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom range days'**
  String get customRangeDaysTitle;

  /// No description provided for @customRangeDaysValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String customRangeDaysValue(int days);

  /// No description provided for @customRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get customRangeTitle;

  /// No description provided for @daysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysLabel;

  /// No description provided for @noAcceptedPlanChangesYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No accepted plan changes yet'**
  String get noAcceptedPlanChangesYetTitle;

  /// No description provided for @noAcceptedPlanChangesYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Approved suggestion changes will record who accepted them, when, and what changed.'**
  String get noAcceptedPlanChangesYetDescription;

  /// No description provided for @noSuggestionImpactHistoryYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No suggestion impact history yet'**
  String get noSuggestionImpactHistoryYetTitle;

  /// No description provided for @noSuggestionImpactHistoryYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Generated suggestions, accepted changes and before/after snapshots will be stored here.'**
  String get noSuggestionImpactHistoryYetDescription;

  /// No description provided for @revertLatestSuggestedAdjustmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Restore the latest plan snapshot saved before a suggested adjustment was applied.'**
  String get revertLatestSuggestedAdjustmentDescription;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @tryAgainAction.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @catsUnit.
  ///
  /// In en, this message translates to:
  /// **'cats'**
  String get catsUnit;

  /// No description provided for @noneOption.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneOption;

  /// No description provided for @normalOption.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalOption;

  /// No description provided for @highOption.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highOption;

  /// No description provided for @lowOption.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowOption;

  /// No description provided for @poorOption.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poorOption;

  /// No description provided for @reducedOption.
  ///
  /// In en, this message translates to:
  /// **'Reduced'**
  String get reducedOption;

  /// No description provided for @softOption.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get softOption;

  /// No description provided for @hardOption.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hardOption;

  /// No description provided for @diarrheaOption.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get diarrheaOption;

  /// No description provided for @occasionalOption.
  ///
  /// In en, this message translates to:
  /// **'Occasional'**
  String get occasionalOption;

  /// No description provided for @frequentOption.
  ///
  /// In en, this message translates to:
  /// **'Frequent'**
  String get frequentOption;

  /// No description provided for @otherOption.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherOption;

  /// No description provided for @sedentaryOption.
  ///
  /// In en, this message translates to:
  /// **'Sedentary'**
  String get sedentaryOption;

  /// No description provided for @moderateOption.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateOption;

  /// No description provided for @activeOption.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeOption;

  /// No description provided for @maleOption.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleOption;

  /// No description provided for @femaleOption.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleOption;

  /// No description provided for @unknownOption.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownOption;

  /// No description provided for @maintenanceGoalOption.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceGoalOption;

  /// No description provided for @weightLossGoalOption.
  ///
  /// In en, this message translates to:
  /// **'Weight loss'**
  String get weightLossGoalOption;

  /// No description provided for @weightGainGoalOption.
  ///
  /// In en, this message translates to:
  /// **'Weight gain'**
  String get weightGainGoalOption;

  /// No description provided for @kittenGrowthGoalOption.
  ///
  /// In en, this message translates to:
  /// **'Kitten growth'**
  String get kittenGrowthGoalOption;

  /// No description provided for @seniorSupportGoalOption.
  ///
  /// In en, this message translates to:
  /// **'Senior support'**
  String get seniorSupportGoalOption;

  /// No description provided for @recoveryGoalOption.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get recoveryGoalOption;

  /// No description provided for @postSurgeryGoalOption.
  ///
  /// In en, this message translates to:
  /// **'Post-surgery'**
  String get postSurgeryGoalOption;

  /// No description provided for @completedOption.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedOption;

  /// No description provided for @partialOption.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get partialOption;

  /// No description provided for @delayedOption.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get delayedOption;

  /// No description provided for @refusedOption.
  ///
  /// In en, this message translates to:
  /// **'Refused'**
  String get refusedOption;

  /// No description provided for @reducedAppetiteOption.
  ///
  /// In en, this message translates to:
  /// **'Reduced appetite'**
  String get reducedAppetiteOption;

  /// No description provided for @skippedOption.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skippedOption;

  /// No description provided for @loggedStatus.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get loggedStatus;

  /// No description provided for @weightCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Check-in'**
  String get weightCheckInTitle;

  /// No description provided for @noActiveCatTitle.
  ///
  /// In en, this message translates to:
  /// **'No active cat'**
  String get noActiveCatTitle;

  /// No description provided for @noActiveCatDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a cat from Home before recording weight.'**
  String get noActiveCatDescription;

  /// No description provided for @weightRecordedWithAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'Weight recorded with alert. Review goals and clinical notes.'**
  String get weightRecordedWithAlertMessage;

  /// No description provided for @weightRecordedMessage.
  ///
  /// In en, this message translates to:
  /// **'Weight recorded.'**
  String get weightRecordedMessage;

  /// No description provided for @weightNoteSuggestionHighAppetite.
  ///
  /// In en, this message translates to:
  /// **'High Appetite'**
  String get weightNoteSuggestionHighAppetite;

  /// No description provided for @weightNoteSuggestionEnergetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get weightNoteSuggestionEnergetic;

  /// No description provided for @weightNoteSuggestionLazyDay.
  ///
  /// In en, this message translates to:
  /// **'Lazy Day'**
  String get weightNoteSuggestionLazyDay;

  /// No description provided for @weightContextFastingOption.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get weightContextFastingOption;

  /// No description provided for @weightContextAfterMealOption.
  ///
  /// In en, this message translates to:
  /// **'After meal'**
  String get weightContextAfterMealOption;

  /// No description provided for @weightContextDifferentScaleOption.
  ///
  /// In en, this message translates to:
  /// **'Different scale'**
  String get weightContextDifferentScaleOption;

  /// No description provided for @noPreviousCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'No previous check-in'**
  String get noPreviousCheckInLabel;

  /// No description provided for @lastCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'Last check-in: {date}'**
  String lastCheckInLabel(String date);

  /// No description provided for @recordingNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Recording now: {date} at {time}'**
  String recordingNowLabel(String date, String time);

  /// No description provided for @lastWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'LAST\nWEIGHT'**
  String get lastWeightLabel;

  /// No description provided for @checkInDateTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in Date & Time'**
  String get checkInDateTimeTitle;

  /// No description provided for @currentWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT WEIGHT'**
  String get currentWeightLabel;

  /// No description provided for @checkInContextTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in Context'**
  String get checkInContextTitle;

  /// No description provided for @checkInContextDescription.
  ///
  /// In en, this message translates to:
  /// **'Use this context to improve trend interpretation in reports.'**
  String get checkInContextDescription;

  /// No description provided for @weightContextLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight context'**
  String get weightContextLabel;

  /// No description provided for @appetiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Appetite'**
  String get appetiteLabel;

  /// No description provided for @stoolLabel.
  ///
  /// In en, this message translates to:
  /// **'Stool'**
  String get stoolLabel;

  /// No description provided for @vomitLabel.
  ///
  /// In en, this message translates to:
  /// **'Vomit'**
  String get vomitLabel;

  /// No description provided for @energyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energyLabel;

  /// No description provided for @checkInNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in Notes'**
  String get checkInNotesTitle;

  /// No description provided for @checkInNotesDescription.
  ///
  /// In en, this message translates to:
  /// **'Record behavior and clinical follow-up for this weight entry.'**
  String get checkInNotesDescription;

  /// No description provided for @weightNotesHint.
  ///
  /// In en, this message translates to:
  /// **'How is your cat\'s appetite today? Any changes in mood or energy levels?'**
  String get weightNotesHint;

  /// No description provided for @clinicalAssessmentStructuredLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinical assessment (structured)'**
  String get clinicalAssessmentStructuredLabel;

  /// No description provided for @clinicalPlanFollowUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinical plan / follow-up'**
  String get clinicalPlanFollowUpLabel;

  /// No description provided for @recordWeightAction.
  ///
  /// In en, this message translates to:
  /// **'Record Weight'**
  String get recordWeightAction;

  /// No description provided for @recordWeightActionUppercase.
  ///
  /// In en, this message translates to:
  /// **'RECORD WEIGHT'**
  String get recordWeightActionUppercase;

  /// No description provided for @catProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Cat Profile'**
  String get catProfileTitle;

  /// No description provided for @deleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete profile'**
  String get deleteProfileTitle;

  /// No description provided for @removeProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the app?'**
  String removeProfileMessage(String name);

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @createNewCatProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new cat profile'**
  String get createNewCatProfileTitle;

  /// No description provided for @catProfileIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Personal data, clinical context and feeding targets in one place.'**
  String get catProfileIntroDescription;

  /// No description provided for @uploadPhotoAction.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhotoAction;

  /// No description provided for @coreProfileSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Core Profile'**
  String get coreProfileSectionTitle;

  /// No description provided for @coreProfileSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Identity and baseline metabolic data used across the app.'**
  String get coreProfileSectionDescription;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @enterCatNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter the cat name'**
  String get enterCatNameError;

  /// No description provided for @weightKgLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKgLabel;

  /// No description provided for @invalidWeightError.
  ///
  /// In en, this message translates to:
  /// **'Invalid weight'**
  String get invalidWeightError;

  /// No description provided for @ageYearsLabel.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get ageYearsLabel;

  /// No description provided for @invalidAgeError.
  ///
  /// In en, this message translates to:
  /// **'Invalid age'**
  String get invalidAgeError;

  /// No description provided for @neuteredSpayedTitle.
  ///
  /// In en, this message translates to:
  /// **'Neutered / Spayed'**
  String get neuteredSpayedTitle;

  /// No description provided for @neuteredSpayedDescription.
  ///
  /// In en, this message translates to:
  /// **'Affects calorie requirements'**
  String get neuteredSpayedDescription;

  /// No description provided for @activityLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get activityLevelLabel;

  /// No description provided for @goalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goalLabel;

  /// No description provided for @preferredMealsPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred meals per day'**
  String get preferredMealsPerDayLabel;

  /// No description provided for @manualTargetKcalPerDayOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Manual target kcal/day (optional)'**
  String get manualTargetKcalPerDayOptionalLabel;

  /// No description provided for @manualTargetKcalHelperText.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep automatic calculation'**
  String get manualTargetKcalHelperText;

  /// No description provided for @invalidKcalTargetError.
  ///
  /// In en, this message translates to:
  /// **'Invalid kcal target'**
  String get invalidKcalTargetError;

  /// No description provided for @clinicalContextSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinical Context'**
  String get clinicalContextSectionTitle;

  /// No description provided for @clinicalContextSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional fields that refine recommendations and clinical tracking.'**
  String get clinicalContextSectionDescription;

  /// No description provided for @idealWeightOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Ideal weight (kg) (optional)'**
  String get idealWeightOptionalLabel;

  /// No description provided for @idealWeightHelperText.
  ///
  /// In en, this message translates to:
  /// **'Optional: used to refine kcal suggestions'**
  String get idealWeightHelperText;

  /// No description provided for @invalidIdealWeightError.
  ///
  /// In en, this message translates to:
  /// **'Invalid ideal weight'**
  String get invalidIdealWeightError;

  /// No description provided for @bodyConditionScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Condition Score (1-9)'**
  String get bodyConditionScoreLabel;

  /// No description provided for @sexLabel.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sexLabel;

  /// No description provided for @breedOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Breed (optional)'**
  String get breedOptionalLabel;

  /// No description provided for @dateOfBirthOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth (optional)'**
  String get dateOfBirthOptionalLabel;

  /// No description provided for @customActivityLevelOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom activity level (optional)'**
  String get customActivityLevelOptionalLabel;

  /// No description provided for @customActivityLevelHelperText.
  ///
  /// In en, this message translates to:
  /// **'Overrides preset activity labels when provided'**
  String get customActivityLevelHelperText;

  /// No description provided for @clinicalConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinical conditions (comma separated)'**
  String get clinicalConditionsLabel;

  /// No description provided for @clinicalConditionsHelperText.
  ///
  /// In en, this message translates to:
  /// **'Examples: diabetes, ckd, arthritis'**
  String get clinicalConditionsHelperText;

  /// No description provided for @allergiesRestrictionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Allergies / restrictions (comma separated)'**
  String get allergiesRestrictionsLabel;

  /// No description provided for @allergiesRestrictionsHelperText.
  ///
  /// In en, this message translates to:
  /// **'Examples: chicken, beef, dairy'**
  String get allergiesRestrictionsHelperText;

  /// No description provided for @dietaryPreferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Dietary preferences (comma separated)'**
  String get dietaryPreferencesLabel;

  /// No description provided for @dietaryPreferencesHelperText.
  ///
  /// In en, this message translates to:
  /// **'Examples: grain_free, low_fat'**
  String get dietaryPreferencesHelperText;

  /// No description provided for @veterinaryNotesOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Veterinary notes (optional)'**
  String get veterinaryNotesOptionalLabel;

  /// No description provided for @targetsAlertsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Targets & Alerts'**
  String get targetsAlertsSectionTitle;

  /// No description provided for @targetsAlertsSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Set safe weight range and threshold alerts for each check-in.'**
  String get targetsAlertsSectionDescription;

  /// No description provided for @weightGoalsAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Goals & Alerts'**
  String get weightGoalsAlertsTitle;

  /// No description provided for @goalMinWeightKgLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal min weight (kg)'**
  String get goalMinWeightKgLabel;

  /// No description provided for @goalMaxWeightKgLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal max weight (kg)'**
  String get goalMaxWeightKgLabel;

  /// No description provided for @alertDeltaKgPerCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert delta (kg) per check-in'**
  String get alertDeltaKgPerCheckInLabel;

  /// No description provided for @alertDeltaPercentPerCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert delta (%) per check-in'**
  String get alertDeltaPercentPerCheckInLabel;

  /// No description provided for @clinicalNotesPreferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinical notes / preferences'**
  String get clinicalNotesPreferencesLabel;

  /// No description provided for @clinicalNotesPreferencesHelperText.
  ///
  /// In en, this message translates to:
  /// **'Examples: sensitive stomach, picky eater, post-surgery, senior support'**
  String get clinicalNotesPreferencesHelperText;

  /// No description provided for @catLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Limit: {max} individual cats. Groups are created separately as lightweight operational units.'**
  String catLimitHint(int max);

  /// No description provided for @saveChangesAction.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesAction;

  /// No description provided for @saveProfileAction.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfileAction;

  /// No description provided for @deleteProfileAction.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfileAction;

  /// No description provided for @profileFeedsAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Profiles saved here will feed Home, Plans, Weight Check-in, and Dashboard.'**
  String get profileFeedsAppDescription;

  /// No description provided for @nothingSelectedYetTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing selected yet'**
  String get nothingSelectedYetTitle;

  /// No description provided for @dailySelectionRequiredDescription.
  ///
  /// In en, this message translates to:
  /// **'Select an individual cat or a group from Home and save a plan to unlock the daily dashboard.'**
  String get dailySelectionRequiredDescription;

  /// No description provided for @noGroupPlanYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No group plan yet'**
  String get noGroupPlanYetTitle;

  /// No description provided for @saveGroupPlanBeforeDailyDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a meal plan for {name} in Plans before using Daily.'**
  String saveGroupPlanBeforeDailyDescription(String name);

  /// No description provided for @groupPlanNotActiveYetTitle.
  ///
  /// In en, this message translates to:
  /// **'Group plan not active yet'**
  String get groupPlanNotActiveYetTitle;

  /// No description provided for @groupPlanStartsOnDescription.
  ///
  /// In en, this message translates to:
  /// **'This plan for {name} starts on {date}.'**
  String groupPlanStartsOnDescription(String name, String date);

  /// No description provided for @groupSizeMetricTitle.
  ///
  /// In en, this message translates to:
  /// **'GROUP SIZE'**
  String get groupSizeMetricTitle;

  /// No description provided for @dailyGoalMetricTitleUppercase.
  ///
  /// In en, this message translates to:
  /// **'DAILY GOAL'**
  String get dailyGoalMetricTitleUppercase;

  /// No description provided for @yesterdayRoutineDuplicatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Yesterday routine duplicated for today.'**
  String get yesterdayRoutineDuplicatedMessage;

  /// No description provided for @duplicateYesterdayRoutineAction.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Yesterday Routine'**
  String get duplicateYesterdayRoutineAction;

  /// No description provided for @todaysGroupScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Group Schedule'**
  String get todaysGroupScheduleTitle;

  /// No description provided for @noMealPlanYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No meal plan yet'**
  String get noMealPlanYetTitle;

  /// No description provided for @savePlanBeforeDailyDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a meal plan for {name} in Plans before using Daily.'**
  String savePlanBeforeDailyDescription(String name);

  /// No description provided for @planNotActiveYetTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan not active yet'**
  String get planNotActiveYetTitle;

  /// No description provided for @planStartsOnDescription.
  ///
  /// In en, this message translates to:
  /// **'The plan for {name} starts on {date}.'**
  String planStartsOnDescription(String name, String date);

  /// No description provided for @currentWeightMetricTitle.
  ///
  /// In en, this message translates to:
  /// **'CURRENT WEIGHT'**
  String get currentWeightMetricTitle;

  /// No description provided for @genericMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get genericMealTitle;

  /// No description provided for @mealTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal time'**
  String get mealTimeTitle;

  /// No description provided for @unsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Unset'**
  String get unsetLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @observationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get observationsLabel;

  /// No description provided for @dailyObservationsHint.
  ///
  /// In en, this message translates to:
  /// **'Delay reason, refusal, appetite, practical notes, etc.'**
  String get dailyObservationsHint;

  /// No description provided for @saveLogAction.
  ///
  /// In en, this message translates to:
  /// **'Save Log'**
  String get saveLogAction;

  /// No description provided for @dailyGreetingTitle.
  ///
  /// In en, this message translates to:
  /// **'Good morning!'**
  String get dailyGreetingTitle;

  /// No description provided for @dailyGroupReadyDescription.
  ///
  /// In en, this message translates to:
  /// **'{name} group is ready for today\'s routine'**
  String dailyGroupReadyDescription(String name);

  /// No description provided for @dailyCatReadyDescription.
  ///
  /// In en, this message translates to:
  /// **'{name} is ready for today\'s meals'**
  String dailyCatReadyDescription(String name);

  /// No description provided for @todaysScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysScheduleTitle;

  /// No description provided for @loggedQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Logged: {quantity} {unit}'**
  String loggedQuantityLabel(String quantity, String unit);

  /// No description provided for @noteWithValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String noteWithValueLabel(String note);

  /// No description provided for @updateLogAction.
  ///
  /// In en, this message translates to:
  /// **'UPDATE LOG'**
  String get updateLogAction;

  /// No description provided for @logMealAction.
  ///
  /// In en, this message translates to:
  /// **'LOG MEAL'**
  String get logMealAction;

  /// No description provided for @logEventAction.
  ///
  /// In en, this message translates to:
  /// **'LOG EVENT'**
  String get logEventAction;

  /// No description provided for @recordTodaysWeightProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'Record today\'s weight progress'**
  String get recordTodaysWeightProgressDescription;

  /// No description provided for @anytimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get anytimeLabel;

  /// No description provided for @noMealsScheduledTitle.
  ///
  /// In en, this message translates to:
  /// **'No meals scheduled'**
  String get noMealsScheduledTitle;

  /// No description provided for @noMealsScheduledDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a plan in Plans to generate today\'s schedule.'**
  String get noMealsScheduledDescription;

  /// No description provided for @dailyWaterEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get dailyWaterEntryTitle;

  /// No description provided for @dailySnacksEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get dailySnacksEntryTitle;

  /// No description provided for @dailySupplementsEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get dailySupplementsEntryTitle;

  /// No description provided for @dailyWaterGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register water intake for the group'**
  String get dailyWaterGroupSubtitle;

  /// No description provided for @dailyWaterCatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register water intake for the cat'**
  String get dailyWaterCatSubtitle;

  /// No description provided for @dailySnacksGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register snacks offered to the group'**
  String get dailySnacksGroupSubtitle;

  /// No description provided for @dailySnacksCatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register snacks offered today'**
  String get dailySnacksCatSubtitle;

  /// No description provided for @dailySupplementsGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register supplements for the group'**
  String get dailySupplementsGroupSubtitle;

  /// No description provided for @dailySupplementsCatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register supplements for the cat'**
  String get dailySupplementsCatSubtitle;

  /// No description provided for @productConfirmedFromDatabaseMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} confirmed from database'**
  String productConfirmedFromDatabaseMessage(String name);

  /// No description provided for @foodGenericLabel.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodGenericLabel;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get scannerTitle;

  /// No description provided for @cameraUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable'**
  String get cameraUnavailableTitle;

  /// No description provided for @cameraUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Unable to start camera. On web, use localhost or https, allow camera access, and keep only one tab using the webcam.'**
  String get cameraUnavailableDescription;

  /// No description provided for @webCameraNotRunningHint.
  ///
  /// In en, this message translates to:
  /// **'Web camera not running yet. Test one browser tab at a time, allow camera access, and try the switch-camera button.'**
  String get webCameraNotRunningHint;

  /// No description provided for @alignBarcodeWithinFrameTitle.
  ///
  /// In en, this message translates to:
  /// **'Align barcode within frame'**
  String get alignBarcodeWithinFrameTitle;

  /// No description provided for @typeBarcodeToSimulateScanHint.
  ///
  /// In en, this message translates to:
  /// **'Type barcode to simulate scan'**
  String get typeBarcodeToSimulateScanHint;

  /// No description provided for @noBarcodeScannedYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No barcode scanned yet'**
  String get noBarcodeScannedYetTitle;

  /// No description provided for @noProductFoundForBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'No product found for {barcode}'**
  String noProductFoundForBarcodeTitle(String barcode);

  /// No description provided for @unknownBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown brand'**
  String get unknownBrandLabel;

  /// No description provided for @kcalPer100gLabel.
  ///
  /// In en, this message translates to:
  /// **'kcal/100g'**
  String get kcalPer100gLabel;

  /// No description provided for @useLiveCameraOrBarcodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the live camera or the barcode field above.'**
  String get useLiveCameraOrBarcodeDescription;

  /// No description provided for @createFoodEntryFromBarcodeDescription.
  ///
  /// In en, this message translates to:
  /// **'You can create a new food entry with this barcode.'**
  String get createFoodEntryFromBarcodeDescription;

  /// No description provided for @editManuallyAction.
  ///
  /// In en, this message translates to:
  /// **'Edit Manually'**
  String get editManuallyAction;

  /// No description provided for @manualEntryAction.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntryAction;

  /// No description provided for @useProductAction.
  ///
  /// In en, this message translates to:
  /// **'Use Product'**
  String get useProductAction;

  /// No description provided for @confirmProductAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Product'**
  String get confirmProductAction;

  /// No description provided for @veterinaryGradeNutritionTagline.
  ///
  /// In en, this message translates to:
  /// **'VETERINARY-GRADE NUTRITION'**
  String get veterinaryGradeNutritionTagline;

  /// No description provided for @catLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Cat limit reached. You can create up to {max} cats.'**
  String catLimitReached(int max);

  /// No description provided for @invalidImageFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid image file.'**
  String get invalidImageFile;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortugueseBrazil.
  ///
  /// In en, this message translates to:
  /// **'Portuguese (Brazil)'**
  String get languagePortugueseBrazil;

  /// No description provided for @languageTagalog.
  ///
  /// In en, this message translates to:
  /// **'Tagalog'**
  String get languageTagalog;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt', 'tl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
    case 'tl':
      return AppLocalizationsTl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

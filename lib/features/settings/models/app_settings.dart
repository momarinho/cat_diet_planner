class AppSettings {
  const AppSettings({
    required this.mealReminders,
    required this.languageCode,
    required this.reminderTimes,
    required this.quietHoursEnabled,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.notificationProfiles,
    required this.reportRangeDays,
    required this.customReportRangeDays,
    required this.pdfLayout,
    required this.pdfIncludeWeightTrend,
    required this.pdfIncludeCalorieTable,
    required this.pdfIncludeVetNotes,
    required this.shareMessageTemplate,
    required this.suggestionInterventionLevel,
    required this.suggestionCategoryToggles,
    required this.suggestionDailyLimit,
    required this.suggestionAlertsOnly,
    required this.suggestionAutoApply,
  });

  final bool mealReminders;
  final String languageCode;
  final List<String> reminderTimes;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final Map<String, Map<String, String>> notificationProfiles; // by type
  final int reportRangeDays;
  final int customReportRangeDays;
  final String pdfLayout; // compact | detailed
  final bool pdfIncludeWeightTrend;
  final bool pdfIncludeCalorieTable;
  final bool pdfIncludeVetNotes;
  final String shareMessageTemplate;
  final String
  suggestionInterventionLevel; // conservative | balanced | proactive
  final Map<String, bool> suggestionCategoryToggles;
  final int suggestionDailyLimit;
  final bool suggestionAlertsOnly;
  final bool suggestionAutoApply;

  factory AppSettings.defaults() {
    return const AppSettings(
      mealReminders: true,
      languageCode: 'en',
      reminderTimes: ['07:30', '12:30', '19:00'],
      quietHoursEnabled: false,
      quietHoursStart: '22:00',
      quietHoursEnd: '07:00',
      notificationProfiles: {
        'meal': {'sound': 'default', 'intensity': 'high'},
        'weight': {'sound': 'default', 'intensity': 'default'},
        'health': {'sound': 'soft', 'intensity': 'default'},
      },
      reportRangeDays: 7,
      customReportRangeDays: 21,
      pdfLayout: 'detailed',
      pdfIncludeWeightTrend: true,
      pdfIncludeCalorieTable: true,
      pdfIncludeVetNotes: true,
      shareMessageTemplate: 'Weekly diet report from CatDiet Planner',
      suggestionInterventionLevel: 'balanced',
      suggestionCategoryToggles: {
        'kcalAdjustment': true,
        'scheduleAdjustment': true,
        'portionSplitAdjustment': true,
        'preventiveTrendAlert': true,
        'clinicalWatch': true,
      },
      suggestionDailyLimit: 3,
      suggestionAlertsOnly: false,
      suggestionAutoApply: false,
    );
  }

  AppSettings copyWith({
    bool? mealReminders,
    String? languageCode,
    List<String>? reminderTimes,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    Map<String, Map<String, String>>? notificationProfiles,
    int? reportRangeDays,
    int? customReportRangeDays,
    String? pdfLayout,
    bool? pdfIncludeWeightTrend,
    bool? pdfIncludeCalorieTable,
    bool? pdfIncludeVetNotes,
    String? shareMessageTemplate,
    String? suggestionInterventionLevel,
    Map<String, bool>? suggestionCategoryToggles,
    int? suggestionDailyLimit,
    bool? suggestionAlertsOnly,
    bool? suggestionAutoApply,
  }) {
    return AppSettings(
      mealReminders: mealReminders ?? this.mealReminders,
      languageCode: languageCode ?? this.languageCode,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      notificationProfiles: notificationProfiles ?? this.notificationProfiles,
      reportRangeDays: reportRangeDays ?? this.reportRangeDays,
      customReportRangeDays:
          customReportRangeDays ?? this.customReportRangeDays,
      pdfLayout: pdfLayout ?? this.pdfLayout,
      pdfIncludeWeightTrend:
          pdfIncludeWeightTrend ?? this.pdfIncludeWeightTrend,
      pdfIncludeCalorieTable:
          pdfIncludeCalorieTable ?? this.pdfIncludeCalorieTable,
      pdfIncludeVetNotes: pdfIncludeVetNotes ?? this.pdfIncludeVetNotes,
      shareMessageTemplate: shareMessageTemplate ?? this.shareMessageTemplate,
      suggestionInterventionLevel:
          suggestionInterventionLevel ?? this.suggestionInterventionLevel,
      suggestionCategoryToggles:
          suggestionCategoryToggles ?? this.suggestionCategoryToggles,
      suggestionDailyLimit: suggestionDailyLimit ?? this.suggestionDailyLimit,
      suggestionAlertsOnly: suggestionAlertsOnly ?? this.suggestionAlertsOnly,
      suggestionAutoApply: suggestionAutoApply ?? this.suggestionAutoApply,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealReminders': mealReminders,
      'languageCode': languageCode,
      'reminderTimes': reminderTimes,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'notificationProfiles': notificationProfiles,
      'reportRangeDays': reportRangeDays,
      'customReportRangeDays': customReportRangeDays,
      'pdfLayout': pdfLayout,
      'pdfIncludeWeightTrend': pdfIncludeWeightTrend,
      'pdfIncludeCalorieTable': pdfIncludeCalorieTable,
      'pdfIncludeVetNotes': pdfIncludeVetNotes,
      'shareMessageTemplate': shareMessageTemplate,
      'suggestionInterventionLevel': suggestionInterventionLevel,
      'suggestionCategoryToggles': suggestionCategoryToggles,
      'suggestionDailyLimit': suggestionDailyLimit,
      'suggestionAlertsOnly': suggestionAlertsOnly,
      'suggestionAutoApply': suggestionAutoApply,
    };
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return AppSettings.defaults();
    final times = (map['reminderTimes'] as List?)
        ?.map((value) => value.toString())
        .toList();
    final profileDefaults = AppSettings.defaults().notificationProfiles;
    final suggestionToggleDefaults =
        AppSettings.defaults().suggestionCategoryToggles;
    final rawProfiles = (map['notificationProfiles'] as Map?) ?? const {};
    final rawSuggestionToggles =
        (map['suggestionCategoryToggles'] as Map?) ?? const {};
    final profiles = <String, Map<String, String>>{};
    final suggestionToggles = <String, bool>{};
    for (final entry in profileDefaults.entries) {
      final raw = rawProfiles[entry.key];
      if (raw is Map) {
        profiles[entry.key] = {
          'sound': raw['sound']?.toString() ?? entry.value['sound']!,
          'intensity':
              raw['intensity']?.toString() ?? entry.value['intensity']!,
        };
      } else {
        profiles[entry.key] = Map<String, String>.from(entry.value);
      }
    }
    for (final entry in suggestionToggleDefaults.entries) {
      suggestionToggles[entry.key] =
          rawSuggestionToggles[entry.key] as bool? ?? entry.value;
    }

    return AppSettings(
      mealReminders: map['mealReminders'] as bool? ?? true,
      languageCode: map['languageCode'] as String? ?? 'en',
      reminderTimes: times == null || times.isEmpty
          ? AppSettings.defaults().reminderTimes
          : times,
      quietHoursEnabled: map['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: map['quietHoursStart']?.toString() ?? '22:00',
      quietHoursEnd: map['quietHoursEnd']?.toString() ?? '07:00',
      notificationProfiles: profiles,
      reportRangeDays: (map['reportRangeDays'] as int?) ?? 7,
      customReportRangeDays: (map['customReportRangeDays'] as int?) ?? 21,
      pdfLayout: map['pdfLayout']?.toString() ?? 'detailed',
      pdfIncludeWeightTrend: map['pdfIncludeWeightTrend'] as bool? ?? true,
      pdfIncludeCalorieTable: map['pdfIncludeCalorieTable'] as bool? ?? true,
      pdfIncludeVetNotes: map['pdfIncludeVetNotes'] as bool? ?? true,
      shareMessageTemplate:
          map['shareMessageTemplate']?.toString() ??
          'Weekly diet report from CatDiet Planner',
      suggestionInterventionLevel:
          map['suggestionInterventionLevel']?.toString() ?? 'balanced',
      suggestionCategoryToggles: suggestionToggles,
      suggestionDailyLimit: (map['suggestionDailyLimit'] as int?) ?? 3,
      suggestionAlertsOnly: map['suggestionAlertsOnly'] as bool? ?? false,
      suggestionAutoApply: map['suggestionAutoApply'] as bool? ?? false,
    );
  }
}

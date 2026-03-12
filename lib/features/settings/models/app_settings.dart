class AppSettings {
  const AppSettings({
    required this.mealReminders,
    required this.languageCode,
    required this.reminderTimes,
  });

  final bool mealReminders;
  final String languageCode;
  final List<String> reminderTimes;

  factory AppSettings.defaults() {
    return const AppSettings(
      mealReminders: true,
      languageCode: 'en',
      reminderTimes: ['07:30', '12:30', '19:00'],
    );
  }

  AppSettings copyWith({
    bool? mealReminders,
    String? languageCode,
    List<String>? reminderTimes,
  }) {
    return AppSettings(
      mealReminders: mealReminders ?? this.mealReminders,
      languageCode: languageCode ?? this.languageCode,
      reminderTimes: reminderTimes ?? this.reminderTimes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealReminders': mealReminders,
      'languageCode': languageCode,
      'reminderTimes': reminderTimes,
    };
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return AppSettings.defaults();
    final times = (map['reminderTimes'] as List?)
        ?.map((value) => value.toString())
        .toList();

    return AppSettings(
      mealReminders: map['mealReminders'] as bool? ?? true,
      languageCode: map['languageCode'] as String? ?? 'en',
      reminderTimes: times == null || times.isEmpty
          ? AppSettings.defaults().reminderTimes
          : times,
    );
  }
}

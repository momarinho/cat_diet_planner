import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/data/repositories/daily_schedule_repository.dart';
import 'package:cat_diet_planner/features/plans/services/portion/portion_unit_service.dart';

class DailyMealScheduleService {
  static final DailyScheduleRepository _scheduleRepository =
      DailyScheduleRepository();

  static const List<String> _defaultTimes = [
    '07:30 AM',
    '12:30 PM',
    '03:30 PM',
    '07:00 PM',
    '09:30 PM',
    '11:00 PM',
  ];

  static List<String> suggestedMealTimes(int mealsPerDay) {
    return List<String>.generate(
      mealsPerDay,
      (index) => _defaultTimes[index],
      growable: false,
    );
  }

  static List<String> normalizeMealTimes(
    List<String>? mealTimes, {
    required int mealsPerDay,
  }) {
    final defaults = suggestedMealTimes(mealsPerDay);
    final normalized = List<String>.generate(mealsPerDay, (index) {
      final custom = mealTimes != null && index < mealTimes.length
          ? mealTimes[index].trim()
          : '';
      return custom.isEmpty ? defaults[index] : custom;
    });
    return normalized;
  }

  static List<String> suggestedMealLabels(int mealsPerDay) {
    return List<String>.generate(
      mealsPerDay,
      (index) => _mealTitle(index),
      growable: false,
    );
  }

  static List<String> normalizeMealLabels(
    List<String>? mealLabels, {
    required int mealsPerDay,
  }) {
    final defaults = suggestedMealLabels(mealsPerDay);
    return List<String>.generate(mealsPerDay, (index) {
      final custom = mealLabels != null && index < mealLabels.length
          ? mealLabels[index].trim()
          : '';
      return custom.isEmpty ? defaults[index] : custom;
    });
  }

  static List<double> normalizeMealPortions({
    required List<double>? mealPortions,
    required double totalPortionGrams,
    required int mealsPerDay,
  }) {
    final fallbackPortion = mealsPerDay <= 0
        ? 0.0
        : totalPortionGrams / mealsPerDay;
    final source = List<double>.generate(mealsPerDay, (index) {
      final value = mealPortions != null && index < mealPortions.length
          ? mealPortions[index]
          : fallbackPortion;
      return value.isFinite && value > 0 ? value : 0.0;
    });

    final sum = source.fold<double>(0, (acc, value) => acc + value);
    if (sum <= 0 || totalPortionGrams <= 0) {
      return List<double>.filled(mealsPerDay, fallbackPortion, growable: false);
    }

    return source
        .map((value) => totalPortionGrams * (value / sum))
        .toList(growable: false);
  }

  static DateTime normalizeDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isPlanActiveOn({required DateTime startDate, DateTime? date}) {
    final targetDay = normalizeDay(date ?? DateTime.now());
    final startDay = normalizeDay(startDate);
    return !targetDay.isBefore(startDay);
  }

  static String todayKeyForCat(String catId, [DateTime? date]) {
    return _scheduleRepository.catDayKey(catId, date);
  }

  static String todayKeyForGroup(String groupId, [DateTime? date]) {
    return _scheduleRepository.groupDayKey(groupId, date);
  }

  static Map<String, dynamic>? loadTodayForCat(String catId, [DateTime? date]) {
    return _scheduleRepository.readSchedule(todayKeyForCat(catId, date));
  }

  static Map<String, dynamic>? loadTodayForGroup(
    String groupId, [
    DateTime? date,
  ]) {
    return _scheduleRepository.readSchedule(todayKeyForGroup(groupId, date));
  }

  static Map<String, dynamic> ensureTodaySchedule({
    required CatProfile cat,
    required DietPlan plan,
    DateTime? date,
  }) {
    final key = todayKeyForCat(cat.id, date);
    final existing = _scheduleRepository.readSchedule(key);
    final currentPlanTimestamp = plan.createdAt.toIso8601String();
    if (existing != null) {
      final existingMap = Map<String, dynamic>.from(existing);
      if (existingMap['planCreatedAt'] == currentPlanTimestamp) {
        return existingMap;
      }
    }

    final dateRef = normalizeDay(date ?? DateTime.now());
    final override = _effectiveOverrideFor(plan: plan, date: dateRef);
    final mealsPerDay = _resolveOverrideInt(
      override: override,
      key: 'mealsPerDay',
      fallback: plan.mealsPerDay,
    );
    final targetKcalPerDay = _resolveOverrideDouble(
      override: override,
      key: 'targetKcalPerDay',
      fallback: plan.targetKcalPerDay,
    );
    final portionGramsPerDay = _resolveOverrideDouble(
      override: override,
      key: 'portionGramsPerDay',
      fallback: plan.portionGramsPerDay,
    );
    final mealTimes = normalizeMealTimes(
      _resolveOverrideStringList(
        override: override,
        key: 'mealTimes',
        fallback: plan.mealTimes,
      ),
      mealsPerDay: mealsPerDay,
    );
    final mealLabels = normalizeMealLabels(
      _resolveOverrideStringList(
        override: override,
        key: 'mealLabels',
        fallback: plan.mealLabels,
      ),
      mealsPerDay: mealsPerDay,
    );
    final mealPortions = normalizeMealPortions(
      mealPortions: _resolveOverrideDoubleList(
        override: override,
        key: 'mealPortionGrams',
        fallback: plan.mealPortionGrams,
      ),
      totalPortionGrams: portionGramsPerDay,
      mealsPerDay: mealsPerDay,
    );
    final foodLabel = _foodLabelForPlan(plan);
    final unit = plan.portionUnit.trim().isEmpty
        ? 'g'
        : plan.portionUnit.trim();

    final items = List.generate(mealsPerDay, (index) {
      final grams = mealPortions[index];
      final kcal = portionGramsPerDay <= 0
          ? 0.0
          : targetKcalPerDay * (grams / portionGramsPerDay);
      final unitAmount = plan.portionUnitGrams <= 0
          ? grams
          : PortionUnitService.convertGramsToUnits(
              grams: grams,
              unit: unit,
              overrides: {unit.toLowerCase(): plan.portionUnitGrams},
            );
      return <String, dynamic>{
        'id': 'meal_${index + 1}',
        'title': mealLabels[index],
        'subtitle':
            '$foodLabel • ${kcal.toStringAsFixed(0)} kcal • ${PortionUnitService.formatPortion(amount: unitAmount, unit: unit)} (${grams.toStringAsFixed(1)} g)',
        'time': mealTimes[index],
        'grams': grams,
        'kcal': kcal,
        'completed': false,
        'type': 'meal',
      };
    });
    items.addAll(_defaultOperationalItems(isGroup: false));

    final schedule = <String, dynamic>{
      'catId': cat.id,
      'date': (date ?? DateTime.now()).toIso8601String(),
      'planCreatedAt': currentPlanTimestamp,
      'items': items,
    };

    _scheduleRepository.saveSchedule(key, schedule);
    return schedule;
  }

  static Map<String, dynamic> ensureTodayGroupSchedule({
    required CatGroup group,
    required GroupDietPlan plan,
    DateTime? date,
  }) {
    final key = todayKeyForGroup(group.id, date);
    final existing = _scheduleRepository.readSchedule(key);
    final currentPlanTimestamp = plan.createdAt.toIso8601String();
    if (existing != null) {
      final existingMap = Map<String, dynamic>.from(existing);
      if (existingMap['planCreatedAt'] == currentPlanTimestamp) {
        return existingMap;
      }
    }

    final mealTimes = normalizeMealTimes(
      plan.mealTimes,
      mealsPerDay: plan.mealsPerDay,
    );
    final mealLabels = normalizeMealLabels(
      plan.mealLabels,
      mealsPerDay: plan.mealsPerDay,
    );
    final mealPortions = normalizeMealPortions(
      mealPortions: plan.mealPortionGrams,
      totalPortionGrams: plan.portionGramsPerGroupPerDay,
      mealsPerDay: plan.mealsPerDay,
    );

    final unit = plan.portionUnit.trim().isEmpty
        ? 'g'
        : plan.portionUnit.trim();
    final items = List.generate(plan.mealsPerDay, (index) {
      final grams = mealPortions[index];
      final kcal = plan.portionGramsPerGroupPerDay <= 0
          ? 0.0
          : plan.targetKcalPerGroupPerDay *
                (grams / plan.portionGramsPerGroupPerDay);
      final unitAmount = plan.portionUnitGrams <= 0
          ? grams
          : PortionUnitService.convertGramsToUnits(
              grams: grams,
              unit: unit,
              overrides: {unit.toLowerCase(): plan.portionUnitGrams},
            );
      return <String, dynamic>{
        'id': 'group_meal_${index + 1}',
        'title': mealLabels[index],
        'subtitle':
            '${_foodLabelForGroupPlan(plan)} • ${kcal.toStringAsFixed(0)} kcal • ${PortionUnitService.formatPortion(amount: unitAmount, unit: unit)} total (${grams.toStringAsFixed(1)} g)',
        'time': mealTimes[index],
        'grams': grams,
        'kcal': kcal,
        'completed': false,
        'type': 'meal',
      };
    });
    items.addAll(_defaultOperationalItems(isGroup: true));

    final schedule = <String, dynamic>{
      'groupId': group.id,
      'date': (date ?? DateTime.now()).toIso8601String(),
      'planCreatedAt': currentPlanTimestamp,
      'items': items,
    };

    _scheduleRepository.saveSchedule(key, schedule);
    return schedule;
  }

  static Future<void> markMealCompleted({
    required String catId,
    required String mealId,
    required bool completed,
    DateTime? date,
  }) async {
    final key = todayKeyForCat(catId, date);
    final current = _scheduleRepository.readSchedule(key);
    if (current == null) return;

    final schedule = Map<String, dynamic>.from(current);
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    for (final item in items) {
      if (item['id'] == mealId) {
        item['completed'] = completed;
      }
    }

    schedule['items'] = items;
    await _scheduleRepository.saveSchedule(key, schedule);
  }

  static Future<void> updateMealEntry({
    required String catId,
    required String mealId,
    required bool completed,
    String? context,
    String? notes,
    String? time,
    double? quantity,
    String? quantityUnit,
    DateTime? date,
  }) async {
    final key = todayKeyForCat(catId, date);
    final current = _scheduleRepository.readSchedule(key);
    if (current == null) return;

    final schedule = Map<String, dynamic>.from(current);
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    for (final item in items) {
      if (item['id'] == mealId) {
        item['completed'] = completed;
        item['mealContext'] = context;
        item['mealNotes'] = notes == null || notes.trim().isEmpty
            ? null
            : notes.trim();
        if (time != null && time.trim().isNotEmpty) {
          item['time'] = time.trim();
        }
        if (quantity != null) {
          item['quantity'] = quantity;
        }
        if (quantityUnit != null) {
          item['quantityUnit'] = quantityUnit;
        }
      }
    }

    schedule['items'] = items;
    await _scheduleRepository.saveSchedule(key, schedule);
  }

  static Future<void> markGroupMealCompleted({
    required String groupId,
    required String mealId,
    required bool completed,
    DateTime? date,
  }) async {
    final key = todayKeyForGroup(groupId, date);
    final current = _scheduleRepository.readSchedule(key);
    if (current == null) return;

    final schedule = Map<String, dynamic>.from(current);
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    for (final item in items) {
      if (item['id'] == mealId) {
        item['completed'] = completed;
      }
    }

    schedule['items'] = items;
    await _scheduleRepository.saveSchedule(key, schedule);
  }

  static Future<void> updateGroupMealEntry({
    required String groupId,
    required String mealId,
    required bool completed,
    String? context,
    String? notes,
    String? time,
    double? quantity,
    String? quantityUnit,
    DateTime? date,
  }) async {
    final key = todayKeyForGroup(groupId, date);
    final current = _scheduleRepository.readSchedule(key);
    if (current == null) return;

    final schedule = Map<String, dynamic>.from(current);
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    for (final item in items) {
      if (item['id'] == mealId) {
        item['completed'] = completed;
        item['mealContext'] = context;
        item['mealNotes'] = notes == null || notes.trim().isEmpty
            ? null
            : notes.trim();
        if (time != null && time.trim().isNotEmpty) {
          item['time'] = time.trim();
        }
        if (quantity != null) {
          item['quantity'] = quantity;
        }
        if (quantityUnit != null) {
          item['quantityUnit'] = quantityUnit;
        }
      }
    }

    schedule['items'] = items;
    await _scheduleRepository.saveSchedule(key, schedule);
  }

  static int completedMealsCount(Map<String, dynamic> schedule) {
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .where((item) => item['type'] == 'meal');
    return items.where((item) => item['completed'] == true).length;
  }

  static int totalMealsCount(Map<String, dynamic> schedule) {
    final items = ((schedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .where((item) => item['type'] == 'meal');
    return items.length;
  }

  static String mealLabel(int index) => _mealTitle(index);

  static String _mealTitle(int index) {
    switch (index) {
      case 0:
        return 'Breakfast';
      case 1:
        return 'Lunch';
      case 2:
        return 'Afternoon Meal';
      case 3:
        return 'Dinner';
      case 4:
        return 'Late Meal';
      default:
        return 'Meal ${index + 1}';
    }
  }

  static String _foodLabelForPlan(DietPlan plan) {
    final names = plan.foodNames
        .where((name) => name.trim().isNotEmpty)
        .toList();
    if (names.isNotEmpty) return names.join(' + ');
    return plan.foodName;
  }

  static String _foodLabelForGroupPlan(GroupDietPlan plan) {
    if (plan.foodKeys.length <= 1) return plan.foodName;
    return '${plan.foodName} + ${plan.foodKeys.length - 1} more';
  }

  static Map<dynamic, dynamic>? _effectiveOverrideFor({
    required DietPlan plan,
    required DateTime date,
  }) {
    final weekday = date.weekday;
    final direct = plan.dailyOverrides[weekday];
    if (direct != null) return Map<dynamic, dynamic>.from(direct);
    final dynamic weekendFallback = plan.dailyOverrides[0];
    if (weekendFallback is Map &&
        (weekday == DateTime.saturday || weekday == DateTime.sunday)) {
      return Map<dynamic, dynamic>.from(weekendFallback);
    }
    return null;
  }

  static double _resolveOverrideDouble({
    required Map<dynamic, dynamic>? override,
    required String key,
    required double fallback,
  }) {
    final raw = override?[key];
    if (raw is num) return raw.toDouble();
    return fallback;
  }

  static int _resolveOverrideInt({
    required Map<dynamic, dynamic>? override,
    required String key,
    required int fallback,
  }) {
    final raw = override?[key];
    if (raw is num) return raw.toInt();
    return fallback;
  }

  static List<String> _resolveOverrideStringList({
    required Map<dynamic, dynamic>? override,
    required String key,
    required List<String> fallback,
  }) {
    final raw = override?[key];
    if (raw is List) {
      return raw.map((item) => item.toString()).toList(growable: false);
    }
    return fallback;
  }

  static List<double> _resolveOverrideDoubleList({
    required Map<dynamic, dynamic>? override,
    required String key,
    required List<double> fallback,
  }) {
    final raw = override?[key];
    if (raw is List) {
      return raw
          .map((item) => item is num ? item.toDouble() : 0.0)
          .toList(growable: false);
    }
    return fallback;
  }

  static Future<void> duplicateYesterdayForCat(String catId) async {
    final today = normalizeDay(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdaySchedule = loadTodayForCat(catId, yesterday);
    if (yesterdaySchedule == null) return;

    final items = ((yesterdaySchedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .map((item) {
          item['completed'] = false;
          item['mealContext'] = null;
          item['mealNotes'] = null;
          if (item['type'] != 'meal') {
            item['quantity'] = 0.0;
          }
          return item;
        })
        .toList(growable: false);

    final schedule = <String, dynamic>{
      'catId': catId,
      'date': today.toIso8601String(),
      'planCreatedAt': yesterdaySchedule['planCreatedAt'],
      'items': items,
      'duplicatedFrom': yesterday.toIso8601String(),
    };
    await _scheduleRepository.saveSchedule(
      todayKeyForCat(catId, today),
      schedule,
    );
  }

  static Future<void> duplicateYesterdayForGroup(String groupId) async {
    final today = normalizeDay(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdaySchedule = loadTodayForGroup(groupId, yesterday);
    if (yesterdaySchedule == null) return;

    final items = ((yesterdaySchedule['items'] as List?) ?? const [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .map((item) {
          item['completed'] = false;
          item['mealContext'] = null;
          item['mealNotes'] = null;
          if (item['type'] != 'meal') {
            item['quantity'] = 0.0;
          }
          return item;
        })
        .toList(growable: false);

    final schedule = <String, dynamic>{
      'groupId': groupId,
      'date': today.toIso8601String(),
      'planCreatedAt': yesterdaySchedule['planCreatedAt'],
      'items': items,
      'duplicatedFrom': yesterday.toIso8601String(),
    };
    await _scheduleRepository.saveSchedule(
      todayKeyForGroup(groupId, today),
      schedule,
    );
  }

  static List<Map<String, dynamic>> _defaultOperationalItems({
    required bool isGroup,
  }) {
    final scope = isGroup ? 'group' : 'cat';
    return <Map<String, dynamic>>[
      {
        'id': '${scope}_water',
        'title': isGroup ? 'Water (Group)' : 'Water',
        'subtitle': isGroup
            ? 'Register water intake for the group'
            : 'Register water intake for the cat',
        'time': 'Anytime',
        'completed': false,
        'type': 'water',
        'quantity': 0.0,
        'quantityUnit': 'ml',
      },
      {
        'id': '${scope}_snacks',
        'title': isGroup ? 'Snacks (Group)' : 'Snacks',
        'subtitle': isGroup
            ? 'Register snacks offered to the group'
            : 'Register snacks offered today',
        'time': 'Anytime',
        'completed': false,
        'type': 'snacks',
        'quantity': 0.0,
        'quantityUnit': 'g',
      },
      {
        'id': '${scope}_supplements',
        'title': isGroup ? 'Supplements (Group)' : 'Supplements',
        'subtitle': isGroup
            ? 'Register supplements for the group'
            : 'Register supplements for the cat',
        'time': 'Anytime',
        'completed': false,
        'type': 'supplements',
        'quantity': 0.0,
        'quantityUnit': 'dose',
      },
    ];
  }
}

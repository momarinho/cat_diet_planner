import 'dart:convert';
import 'dart:typed_data';

import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/data/models/weight_record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class BackupImportSummary {
  const BackupImportSummary({
    required this.cats,
    required this.groups,
    required this.foods,
    required this.plans,
    required this.groupPlans,
    required this.weights,
    required this.meals,
  });

  final int cats;
  final int groups;
  final int foods;
  final int plans;
  final int groupPlans;
  final int weights;
  final int meals;
}

class DataExportService {
  static const int _schemaVersion = 2;

  static Future<void> exportJsonBackup() async {
    final payload = createBackupPayload();
    final bytes = Uint8List.fromList(
      const Utf8Encoder().convert(
        const JsonEncoder.withIndent('  ').convert(payload),
      ),
    );
    final timestamp = DateTime.now()
        .toIso8601String()
        .split('.')
        .first
        .replaceAll(':', '-');

    final file = XFile.fromData(
      bytes,
      mimeType: 'application/json',
      name: 'catdiet_backup_$timestamp.json',
    );

    await Share.shareXFiles([file], text: 'CatDiet Planner backup export');
  }

  static Map<String, dynamic> createBackupPayload() {
    return {
      'schemaVersion': _schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'boxes': {
        'appSettings': _normalize(HiveService.appSettingsBox.toMap()),
        'catGroups': _exportTypedEntries<CatGroup>(
          HiveService.catGroupsBox.toMap(),
          _catGroupToMap,
        ),
        'cats': _exportTypedEntries<CatProfile>(
          HiveService.catsBox.toMap(),
          _catToMap,
        ),
        'dietPlans': _exportTypedEntries<DietPlan>(
          HiveService.dietPlansBox.toMap(),
          _planToMap,
        ),
        'foods': _exportTypedEntries<FoodItem>(
          HiveService.foodsBox.toMap(),
          _foodToMap,
        ),
        'groupDietPlans': _exportTypedEntries<GroupDietPlan>(
          HiveService.groupDietPlansBox.toMap(),
          _groupPlanToMap,
        ),
        'weights': _exportTypedEntries<WeightRecord>(
          HiveService.weightsBox.toMap(),
          _weightToMap,
        ),
        'meals': _normalize(HiveService.mealsBox.toMap()),
      },
    };
  }

  static Future<BackupImportSummary?> importJsonBackup() async {
    final picked = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    final file = picked?.files.singleOrNull;
    final bytes = file?.bytes;
    if (bytes == null || bytes.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map) {
      throw const FormatException('Backup payload must be a JSON object.');
    }

    return importBackupPayload(Map<String, dynamic>.from(decoded));
  }

  static Future<BackupImportSummary> importBackupPayload(
    Map<String, dynamic> payload,
  ) async {
    final version = payload['schemaVersion'];
    if (version is! int || version < 1 || version > _schemaVersion) {
      throw const FormatException('Unsupported backup schema version.');
    }

    final rawBoxes = payload['boxes'];
    if (rawBoxes is! Map) {
      throw const FormatException('Backup payload does not contain boxes.');
    }

    final boxes = Map<String, dynamic>.from(rawBoxes);
    final appSettings = Map<String, dynamic>.from(
      (boxes['appSettings'] as Map?) ?? const {},
    );
    final catGroups = _readEntryList(boxes['catGroups']);
    final cats = _readEntryList(boxes['cats']);
    final dietPlans = _readEntryList(boxes['dietPlans']);
    final foods = _readEntryList(boxes['foods']);
    final groupDietPlans = _readEntryList(boxes['groupDietPlans']);
    final weights = _readEntryList(boxes['weights']);
    final meals = Map<String, dynamic>.from(
      (boxes['meals'] as Map?) ?? const {},
    );

    await HiveService.groupDietPlansBox.clear();
    await HiveService.dietPlansBox.clear();
    await HiveService.mealsBox.clear();
    await HiveService.weightsBox.clear();
    await HiveService.catsBox.clear();
    await HiveService.catGroupsBox.clear();
    await HiveService.foodsBox.clear();
    await HiveService.appSettingsBox.clear();

    for (final entry in appSettings.entries) {
      await HiveService.appSettingsBox.put(entry.key, _normalize(entry.value));
    }
    for (final entry in catGroups) {
      await HiveService.catGroupsBox.put(
        entry.key,
        _catGroupFromMap(Map<String, dynamic>.from(entry.value as Map)),
      );
    }
    for (final entry in cats) {
      await HiveService.catsBox.put(
        entry.key,
        _catFromMap(Map<String, dynamic>.from(entry.value as Map)),
      );
    }
    for (final entry in foods) {
      await HiveService.foodsBox.put(
        entry.key,
        _foodFromMap(Map<String, dynamic>.from(entry.value as Map)),
      );
    }
    for (final entry in dietPlans) {
      await HiveService.dietPlansBox.put(
        entry.key,
        _planFromMap(Map<String, dynamic>.from(entry.value as Map)),
      );
    }
    for (final entry in groupDietPlans) {
      await HiveService.groupDietPlansBox.put(
        entry.key,
        _groupPlanFromMap(Map<String, dynamic>.from(entry.value as Map)),
      );
    }
    for (final entry in weights) {
      await HiveService.weightsBox.put(
        entry.key,
        _weightFromMap(Map<String, dynamic>.from(entry.value as Map)),
      );
    }
    for (final entry in meals.entries) {
      await HiveService.mealsBox.put(
        entry.key,
        _normalize(entry.value) as Map<dynamic, dynamic>,
      );
    }

    return BackupImportSummary(
      cats: cats.length,
      groups: catGroups.length,
      foods: foods.length,
      plans: dietPlans.length,
      groupPlans: groupDietPlans.length,
      weights: weights.length,
      meals: meals.length,
    );
  }

  static List<Map<String, dynamic>> _exportTypedEntries<T>(
    Map<dynamic, T> source,
    Map<String, dynamic> Function(T value) toMap,
  ) {
    return source.entries
        .map((entry) => {'key': entry.key, 'value': toMap(entry.value)})
        .toList(growable: false);
  }

  static List<MapEntry<dynamic, dynamic>> _readEntryList(dynamic raw) {
    final list = raw as List?;
    if (list == null) return const [];
    return list
        .whereType<Map>()
        .map((entry) => MapEntry(entry['key'], entry['value']))
        .toList(growable: false);
  }

  static Map<String, dynamic> _catGroupToMap(CatGroup group) {
    return {
      'id': group.id,
      'name': group.name,
      'catCount': group.catCount,
      'description': group.description,
      'colorValue': group.colorValue,
      'createdAt': group.createdAt.toIso8601String(),
      'catIds': group.catIds,
      'subgroup': group.subgroup,
      'category': group.category,
      'feedingShareByCat': group.feedingShareByCat,
      'enclosure': group.enclosure,
      'environment': group.environment,
      'shiftMorningNotes': group.shiftMorningNotes,
      'shiftAfternoonNotes': group.shiftAfternoonNotes,
      'shiftNightNotes': group.shiftNightNotes,
      'secondaryColorValue': group.secondaryColorValue,
      'iconName': group.iconName,
      'badgeEmoji': group.badgeEmoji,
    };
  }

  static CatGroup _catGroupFromMap(Map<String, dynamic> map) {
    return CatGroup(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      catCount: _asInt(map['catCount']),
      description: map['description']?.toString(),
      colorValue: _asInt(map['colorValue']),
      createdAt: DateTime.parse(map['createdAt'].toString()),
      catIds: _asStringList(map['catIds']),
      subgroup: map['subgroup']?.toString(),
      category: map['category']?.toString(),
      feedingShareByCat: _asStringDoubleMap(map['feedingShareByCat']),
      enclosure: map['enclosure']?.toString(),
      environment: map['environment']?.toString(),
      shiftMorningNotes: map['shiftMorningNotes']?.toString(),
      shiftAfternoonNotes: map['shiftAfternoonNotes']?.toString(),
      shiftNightNotes: map['shiftNightNotes']?.toString(),
      secondaryColorValue: map['secondaryColorValue'] as int?,
      iconName: map['iconName']?.toString(),
      badgeEmoji: map['badgeEmoji']?.toString(),
    );
  }

  static Map<String, dynamic> _catToMap(CatProfile cat) {
    return {
      'id': cat.id,
      'name': cat.name,
      'weight': cat.weight,
      'age': cat.age,
      'neutered': cat.neutered,
      'activityLevel': cat.activityLevel,
      'goal': cat.goal,
      'createdAt': cat.createdAt.toIso8601String(),
      'weightHistory': cat.weightHistory.map(_weightToMap).toList(),
      'photoPath': cat.photoPath,
      'photoBase64': cat.photoBase64,
      'preferredMealsPerDay': cat.preferredMealsPerDay,
      'manualTargetKcal': cat.manualTargetKcal,
      'notes': cat.notes,
      'idealWeight': cat.idealWeight,
      'bcs': cat.bcs,
      'sex': cat.sex,
      'breed': cat.breed,
      'birthDate': cat.birthDate?.toIso8601String(),
      'customActivityLevel': cat.customActivityLevel,
      'clinicalConditions': cat.clinicalConditions,
      'allergies': cat.allergies,
      'dietaryPreferences': cat.dietaryPreferences,
      'vetNotes': cat.vetNotes,
      'activePlanId': cat.activePlanId,
      'weightGoalMinKg': cat.weightGoalMinKg,
      'weightGoalMaxKg': cat.weightGoalMaxKg,
      'weightAlertDeltaKg': cat.weightAlertDeltaKg,
      'weightAlertDeltaPercent': cat.weightAlertDeltaPercent,
    };
  }

  static CatProfile _catFromMap(Map<String, dynamic> map) {
    return CatProfile(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      weight: _asDouble(map['weight']),
      age: _asInt(map['age']),
      neutered: map['neutered'] as bool? ?? false,
      activityLevel: map['activityLevel']?.toString() ?? 'sedentary',
      goal: map['goal']?.toString() ?? 'maintenance',
      createdAt: DateTime.parse(map['createdAt'].toString()),
      weightHistory: _asWeightHistory(map['weightHistory']),
      photoPath: map['photoPath']?.toString(),
      photoBase64: map['photoBase64']?.toString(),
      preferredMealsPerDay: _asInt(map['preferredMealsPerDay'], fallback: 4),
      manualTargetKcal: _asNullableDouble(map['manualTargetKcal']),
      notes: map['notes']?.toString(),
      idealWeight: _asNullableDouble(map['idealWeight']),
      bcs: map['bcs'] as int?,
      sex: map['sex']?.toString() ?? 'unknown',
      breed: map['breed']?.toString(),
      birthDate: map['birthDate'] == null
          ? null
          : DateTime.parse(map['birthDate'].toString()),
      customActivityLevel: map['customActivityLevel']?.toString(),
      clinicalConditions: _asStringList(map['clinicalConditions']),
      allergies: _asStringList(map['allergies']),
      dietaryPreferences: _asStringList(map['dietaryPreferences']),
      vetNotes: map['vetNotes']?.toString(),
      activePlanId: map['activePlanId']?.toString(),
      weightGoalMinKg: _asNullableDouble(map['weightGoalMinKg']),
      weightGoalMaxKg: _asNullableDouble(map['weightGoalMaxKg']),
      weightAlertDeltaKg: _asNullableDouble(map['weightAlertDeltaKg']),
      weightAlertDeltaPercent: _asNullableDouble(
        map['weightAlertDeltaPercent'],
      ),
    );
  }

  static Map<String, dynamic> _foodToMap(FoodItem food) {
    return {
      'barcode': food.barcode,
      'name': food.name,
      'brand': food.brand,
      'kcalPer100g': food.kcalPer100g,
      'protein': food.protein,
      'fat': food.fat,
      'category': food.category,
      'manufacturer': food.manufacturer,
      'productLine': food.productLine,
      'flavor': food.flavor,
      'texture': food.texture,
      'packageSize': food.packageSize,
      'servingUnit': food.servingUnit,
      'fiber': food.fiber,
      'moisture': food.moisture,
      'carbohydrate': food.carbohydrate,
      'sodium': food.sodium,
      'palatabilityNotes': food.palatabilityNotes,
      'userTags': food.userTags,
    };
  }

  static FoodItem _foodFromMap(Map<String, dynamic> map) {
    return FoodItem(
      barcode: map['barcode']?.toString(),
      name: map['name']?.toString() ?? '',
      brand: map['brand']?.toString(),
      kcalPer100g: _asDouble(map['kcalPer100g']),
      protein: _asNullableDouble(map['protein']),
      fat: _asNullableDouble(map['fat']),
      category: map['category']?.toString(),
      manufacturer: map['manufacturer']?.toString(),
      productLine: map['productLine']?.toString(),
      flavor: map['flavor']?.toString(),
      texture: map['texture']?.toString(),
      packageSize: map['packageSize']?.toString(),
      servingUnit: map['servingUnit']?.toString(),
      fiber: _asNullableDouble(map['fiber']),
      moisture: _asNullableDouble(map['moisture']),
      carbohydrate: _asNullableDouble(map['carbohydrate']),
      sodium: _asNullableDouble(map['sodium']),
      palatabilityNotes: map['palatabilityNotes']?.toString(),
      userTags: _asStringList(map['userTags']),
    );
  }

  static Map<String, dynamic> _weightToMap(WeightRecord record) {
    return {
      'catId': record.catId,
      'date': record.date.toIso8601String(),
      'weight': record.weight,
      'notes': record.notes,
      'weightContext': record.weightContext,
      'appetite': record.appetite,
      'stool': record.stool,
      'vomit': record.vomit,
      'energy': record.energy,
      'clinicalAssessment': record.clinicalAssessment,
      'clinicalPlan': record.clinicalPlan,
      'clinicalAlertLevel': record.clinicalAlertLevel,
      'alertTriggered': record.alertTriggered,
    };
  }

  static WeightRecord _weightFromMap(Map<String, dynamic> map) {
    return WeightRecord(
      catId: map['catId']?.toString() ?? '',
      date: DateTime.parse(map['date'].toString()),
      weight: _asDouble(map['weight']),
      notes: map['notes']?.toString(),
      weightContext: map['weightContext']?.toString(),
      appetite: map['appetite']?.toString(),
      stool: map['stool']?.toString(),
      vomit: map['vomit']?.toString(),
      energy: map['energy']?.toString(),
      clinicalAssessment: map['clinicalAssessment']?.toString(),
      clinicalPlan: map['clinicalPlan']?.toString(),
      clinicalAlertLevel: map['clinicalAlertLevel']?.toString(),
      alertTriggered: map['alertTriggered'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> _planToMap(DietPlan plan) {
    return {
      'catId': plan.catId,
      'foodKey': plan.foodKey,
      'foodName': plan.foodName,
      'targetKcalPerDay': plan.targetKcalPerDay,
      'portionGramsPerDay': plan.portionGramsPerDay,
      'mealsPerDay': plan.mealsPerDay,
      'portionGramsPerMeal': plan.portionGramsPerMeal,
      'createdAt': plan.createdAt.toIso8601String(),
      'goal': plan.goal,
      'mealTimes': plan.mealTimes,
      'mealLabels': plan.mealLabels,
      'mealPortionGrams': plan.mealPortionGrams,
      'startDate': plan.startDate.toIso8601String(),
      'planId': plan.planId,
      'foodKeys': _normalize(plan.foodKeys),
      'foodNames': plan.foodNames,
      'portionUnit': plan.portionUnit,
      'portionUnitGrams': plan.portionUnitGrams,
      'dailyOverrides': _normalize(plan.dailyOverrides),
      'operationalNotes': plan.operationalNotes,
    };
  }

  static DietPlan _planFromMap(Map<String, dynamic> map) {
    return DietPlan(
      catId: map['catId']?.toString() ?? '',
      foodKey: map['foodKey'],
      foodName: map['foodName']?.toString() ?? '',
      targetKcalPerDay: _asDouble(map['targetKcalPerDay']),
      portionGramsPerDay: _asDouble(map['portionGramsPerDay']),
      mealsPerDay: _asInt(map['mealsPerDay']),
      portionGramsPerMeal: _asDouble(map['portionGramsPerMeal']),
      createdAt: DateTime.parse(map['createdAt'].toString()),
      goal: map['goal']?.toString() ?? 'maintenance',
      mealTimes: _asStringList(map['mealTimes']),
      mealLabels: _asStringList(map['mealLabels']),
      mealPortionGrams: _asDoubleList(map['mealPortionGrams']),
      startDate: DateTime.parse(map['startDate'].toString()),
      planId: map['planId']?.toString(),
      foodKeys: _asDynamicList(map['foodKeys']),
      foodNames: _asStringList(map['foodNames']),
      portionUnit: map['portionUnit']?.toString() ?? 'g',
      portionUnitGrams: _asDouble(map['portionUnitGrams'], fallback: 1.0),
      dailyOverrides: _asDayOverrideMap(map['dailyOverrides']),
      operationalNotes: map['operationalNotes']?.toString(),
    );
  }

  static Map<String, dynamic> _groupPlanToMap(GroupDietPlan plan) {
    return {
      'groupId': plan.groupId,
      'foodKey': plan.foodKey,
      'foodName': plan.foodName,
      'catCount': plan.catCount,
      'targetKcalPerCatPerDay': plan.targetKcalPerCatPerDay,
      'targetKcalPerGroupPerDay': plan.targetKcalPerGroupPerDay,
      'portionGramsPerCatPerDay': plan.portionGramsPerCatPerDay,
      'portionGramsPerGroupPerDay': plan.portionGramsPerGroupPerDay,
      'mealsPerDay': plan.mealsPerDay,
      'portionGramsPerGroupPerMeal': plan.portionGramsPerGroupPerMeal,
      'createdAt': plan.createdAt.toIso8601String(),
      'mealTimes': plan.mealTimes,
      'mealLabels': plan.mealLabels,
      'mealPortionGrams': plan.mealPortionGrams,
      'startDate': plan.startDate.toIso8601String(),
      'manualTargetKcal': plan.manualTargetKcal,
      'foodKeys': _normalize(plan.foodKeys),
      'portionUnit': plan.portionUnit,
      'portionUnitGrams': plan.portionUnitGrams,
      'operationalNotes': plan.operationalNotes,
      'perCatShareWeights': plan.perCatShareWeights,
    };
  }

  static GroupDietPlan _groupPlanFromMap(Map<String, dynamic> map) {
    return GroupDietPlan(
      groupId: map['groupId']?.toString() ?? '',
      foodKey: map['foodKey'],
      foodName: map['foodName']?.toString() ?? '',
      catCount: _asInt(map['catCount']),
      targetKcalPerCatPerDay: _asDouble(map['targetKcalPerCatPerDay']),
      targetKcalPerGroupPerDay: _asDouble(map['targetKcalPerGroupPerDay']),
      portionGramsPerCatPerDay: _asDouble(map['portionGramsPerCatPerDay']),
      portionGramsPerGroupPerDay: _asDouble(map['portionGramsPerGroupPerDay']),
      mealsPerDay: _asInt(map['mealsPerDay']),
      portionGramsPerGroupPerMeal: _asDouble(
        map['portionGramsPerGroupPerMeal'],
      ),
      createdAt: DateTime.parse(map['createdAt'].toString()),
      mealTimes: _asStringList(map['mealTimes']),
      mealLabels: _asStringList(map['mealLabels']),
      mealPortionGrams: _asDoubleList(map['mealPortionGrams']),
      startDate: DateTime.parse(map['startDate'].toString()),
      manualTargetKcal: _asNullableDouble(map['manualTargetKcal']),
      foodKeys: _asDynamicList(map['foodKeys']),
      portionUnit: map['portionUnit']?.toString() ?? 'g',
      portionUnitGrams: _asDouble(map['portionUnitGrams'], fallback: 1.0),
      operationalNotes: map['operationalNotes']?.toString(),
      perCatShareWeights: _asStringDoubleMap(map['perCatShareWeights']),
    );
  }

  static List<WeightRecord> _asWeightHistory(dynamic raw) {
    final list = raw as List?;
    if (list == null) return const [];
    return list
        .whereType<Map>()
        .map((entry) => _weightFromMap(Map<String, dynamic>.from(entry)))
        .toList(growable: false);
  }

  static List<String> _asStringList(dynamic raw) {
    final list = raw as List?;
    if (list == null) return const [];
    return list.map((value) => value.toString()).toList(growable: false);
  }

  static List<double> _asDoubleList(dynamic raw) {
    final list = raw as List?;
    if (list == null) return const [];
    return list.map((value) => _asDouble(value)).toList(growable: false);
  }

  static List<dynamic> _asDynamicList(dynamic raw) {
    final list = raw as List?;
    if (list == null) return const [];
    return list.map(_normalize).toList(growable: false);
  }

  static Map<String, double> _asStringDoubleMap(dynamic raw) {
    final map = raw as Map?;
    if (map == null) return const {};
    return map.map((key, value) => MapEntry(key.toString(), _asDouble(value)));
  }

  static Map<int, Map<dynamic, dynamic>> _asDayOverrideMap(dynamic raw) {
    final map = raw as Map?;
    if (map == null) return const {};
    return map.map((key, value) {
      final nested = value is Map
          ? Map<dynamic, dynamic>.from(
              value.map(
                (nestedKey, nestedValue) =>
                    MapEntry(nestedKey, _normalize(nestedValue)),
              ),
            )
          : <dynamic, dynamic>{};
      return MapEntry(int.tryParse(key.toString()) ?? 0, nested);
    })..remove(0);
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double _asDouble(dynamic value, {double fallback = 0}) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double? _asNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static dynamic _normalize(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, nested) => MapEntry(key.toString(), _normalize(nested)),
      );
    }
    if (value is List) {
      return value.map(_normalize).toList(growable: false);
    }
    return value;
  }
}

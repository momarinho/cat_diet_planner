import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/widgets/app_loading_state.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_groups_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/daily/services/daily_meal_schedule_service.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';
import 'package:cat_diet_planner/features/plans/services/portion/portion_unit_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  FoodItem? _selectedFood;
  String? _selectedCatId;
  String? _selectedGroupId;
  String? _hydratedCatId;
  String? _hydratedGroupId;
  int _mealsPerDay = 4;
  bool _planningForGroup = false;
  bool _isSaving = false;
  // Allow selecting multiple foods in the UI (basic toggle)
  bool _allowMultipleFoods = false;
  // When multiple foods are selected we store the selected keys here
  final Set<dynamic> _selectedFoodKeys = <dynamic>{};
  late final TextEditingController _groupKcalController;
  late final TextEditingController _operationalNotesController;
  late final TextEditingController _portionUnitGramsController;
  late final TextEditingController _weekendKcalFactorController;
  late final Map<int, TextEditingController> _weekdayKcalFactorControllers;
  final Map<int, bool> _weekdayOverridesEnabled = <int, bool>{};
  String _portionUnit = 'g';
  bool _weekendAlternative = false;
  List<String> _mealTimes = DailyMealScheduleService.suggestedMealTimes(4);
  List<TextEditingController> _mealLabelControllers = [];
  List<TextEditingController> _mealShareControllers = [];
  DateTime _planStartDate = DailyMealScheduleService.normalizeDay(
    DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _groupKcalController = TextEditingController(text: '220');
    _operationalNotesController = TextEditingController();
    _portionUnitGramsController = TextEditingController(text: '1');
    _weekendKcalFactorController = TextEditingController(text: '100');
    _weekdayKcalFactorControllers = {
      for (var weekday = 1; weekday <= 7; weekday++)
        weekday: TextEditingController(text: '100'),
    };
    for (var weekday = 1; weekday <= 7; weekday++) {
      _weekdayOverridesEnabled[weekday] = false;
    }
    _syncMealLabelControllers(
      DailyMealScheduleService.suggestedMealLabels(_mealsPerDay),
    );
    _syncMealShareControllers(
      List<double>.filled(_mealsPerDay, 100 / _mealsPerDay),
    );
  }

  @override
  void dispose() {
    _groupKcalController.dispose();
    _operationalNotesController.dispose();
    _portionUnitGramsController.dispose();
    _weekendKcalFactorController.dispose();
    for (final controller in _weekdayKcalFactorControllers.values) {
      controller.dispose();
    }
    for (final controller in _mealLabelControllers) {
      controller.dispose();
    }
    for (final controller in _mealShareControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncMealLabelControllers(List<String> labels) {
    for (final controller in _mealLabelControllers) {
      controller.dispose();
    }
    _mealLabelControllers = labels
        .map((label) => TextEditingController(text: label))
        .toList();
  }

  List<String> _currentMealLabels() {
    return _mealLabelControllers
        .map((controller) => controller.text.trim())
        .toList();
  }

  void _syncMealShareControllers(List<double> shares) {
    for (final controller in _mealShareControllers) {
      controller.dispose();
    }
    _mealShareControllers = shares
        .map((share) => TextEditingController(text: share.toStringAsFixed(0)))
        .toList();
  }

  List<double> _normalizedMealShares() {
    final source = _mealShareControllers.map((controller) {
      final parsed = double.tryParse(
        controller.text.trim().replaceAll(',', '.'),
      );
      return parsed != null && parsed > 0 ? parsed : 0.0;
    }).toList();

    final sum = source.fold<double>(0, (acc, value) => acc + value);
    if (sum <= 0 || source.isEmpty) {
      return List<double>.filled(
        _mealsPerDay,
        100 / _mealsPerDay,
        growable: false,
      );
    }

    return source.map((value) => (value / sum) * 100).toList(growable: false);
  }

  List<double> _normalizedMealSharesForCount(int mealsPerDay) {
    final source = List<double>.generate(mealsPerDay, (index) {
      if (index >= _mealShareControllers.length) {
        return 100 / mealsPerDay;
      }
      final parsed = double.tryParse(
        _mealShareControllers[index].text.trim().replaceAll(',', '.'),
      );
      return parsed != null && parsed > 0 ? parsed : 0.0;
    });

    final sum = source.fold<double>(0, (acc, value) => acc + value);
    if (sum <= 0 || source.isEmpty) {
      return List<double>.filled(
        mealsPerDay,
        100 / mealsPerDay,
        growable: false,
      );
    }

    return source.map((value) => (value / sum) * 100).toList(growable: false);
  }

  List<double> _mealPortionsFromTotal(double totalPortionGrams) {
    final shares = _normalizedMealShares();
    return shares
        .map((share) => totalPortionGrams * (share / 100))
        .toList(growable: false);
  }

  List<double> _sharesFromPortions({
    required List<double>? portions,
    required double totalPortionGrams,
    required int mealsPerDay,
  }) {
    final normalized = DailyMealScheduleService.normalizeMealPortions(
      mealPortions: portions,
      totalPortionGrams: totalPortionGrams,
      mealsPerDay: mealsPerDay,
    );
    if (totalPortionGrams <= 0) {
      return List<double>.filled(
        mealsPerDay,
        100 / mealsPerDay,
        growable: false,
      );
    }
    return normalized
        .map((portion) => (portion / totalPortionGrams) * 100)
        .toList(growable: false);
  }

  CatProfile? _findCatById(List<CatProfile> cats, String? id) {
    if (id == null) return null;
    for (final cat in cats) {
      if (cat.id == id) return cat;
    }
    return null;
  }

  CatGroup? _findGroupById(List<CatGroup> groups, String? id) {
    if (id == null) return null;
    for (final group in groups) {
      if (group.id == id) return group;
    }
    return null;
  }

  void _hydratePlanForCat(CatProfile cat, WidgetRef ref) {
    final repository = ref.read(planRepositoryProvider);
    final existingPlan = repository.getPlanForCat(cat.id);
    _hydratedCatId = cat.id;
    _selectedFood = existingPlan == null
        ? null
        : repository.findFoodByKey(existingPlan.foodKey);
    final hydratedKeys = existingPlan?.foodKeys ?? const <dynamic>[];
    _selectedFoodKeys
      ..clear()
      ..addAll(
        hydratedKeys.isNotEmpty ? hydratedKeys : [existingPlan?.foodKey],
      );
    _allowMultipleFoods = _selectedFoodKeys.length > 1;
    _mealsPerDay = existingPlan?.mealsPerDay ?? cat.preferredMealsPerDay;
    _mealTimes = DailyMealScheduleService.normalizeMealTimes(
      existingPlan?.mealTimes,
      mealsPerDay: _mealsPerDay,
    );
    _syncMealLabelControllers(
      DailyMealScheduleService.normalizeMealLabels(
        existingPlan?.mealLabels,
        mealsPerDay: _mealsPerDay,
      ),
    );
    _syncMealShareControllers(
      _sharesFromPortions(
        portions: existingPlan?.mealPortionGrams,
        totalPortionGrams: existingPlan?.portionGramsPerDay ?? 0,
        mealsPerDay: _mealsPerDay,
      ),
    );
    _planStartDate = DailyMealScheduleService.normalizeDay(
      existingPlan?.startDate ?? DateTime.now(),
    );
    _portionUnit = existingPlan?.portionUnit ?? 'g';
    _portionUnitGramsController.text = (existingPlan?.portionUnitGrams ?? 1.0)
        .toStringAsFixed(2);
    _operationalNotesController.text = existingPlan?.operationalNotes ?? '';
    final weekendOverride = existingPlan?.dailyOverrides[0];
    final weekendFactor = weekendOverride?['kcalFactorPercent'];
    _weekendAlternative = weekendOverride != null;
    _weekendKcalFactorController.text =
        (weekendFactor is num ? weekendFactor.toDouble() : 100.0)
            .toStringAsFixed(0);
    for (var weekday = 1; weekday <= 7; weekday++) {
      final override = existingPlan?.dailyOverrides[weekday];
      final factor = override?['kcalFactorPercent'];
      _weekdayOverridesEnabled[weekday] = override != null;
      _weekdayKcalFactorControllers[weekday]!.text =
          (factor is num ? factor.toDouble() : 100.0).toStringAsFixed(0);
    }
    setState(() {});
  }

  void _hydratePlanForGroup(String groupId, WidgetRef ref) {
    final repository = ref.read(planRepositoryProvider);
    final existingPlan = repository.getPlanForGroup(groupId);
    _hydratedGroupId = groupId;
    _selectedFood = existingPlan == null
        ? null
        : repository.findFoodByKey(existingPlan.foodKey);
    final hydratedKeys = existingPlan?.foodKeys ?? const <dynamic>[];
    _selectedFoodKeys
      ..clear()
      ..addAll(
        hydratedKeys.isNotEmpty ? hydratedKeys : [existingPlan?.foodKey],
      );
    _allowMultipleFoods = _selectedFoodKeys.length > 1;
    _mealsPerDay = existingPlan?.mealsPerDay ?? 4;
    _mealTimes = DailyMealScheduleService.normalizeMealTimes(
      existingPlan?.mealTimes,
      mealsPerDay: _mealsPerDay,
    );
    _syncMealLabelControllers(
      DailyMealScheduleService.normalizeMealLabels(
        existingPlan?.mealLabels,
        mealsPerDay: _mealsPerDay,
      ),
    );
    _syncMealShareControllers(
      _sharesFromPortions(
        portions: existingPlan?.mealPortionGrams,
        totalPortionGrams: existingPlan?.portionGramsPerGroupPerDay ?? 0,
        mealsPerDay: _mealsPerDay,
      ),
    );
    _planStartDate = DailyMealScheduleService.normalizeDay(
      existingPlan?.startDate ?? DateTime.now(),
    );
    _groupKcalController.text = existingPlan == null
        ? '220'
        : existingPlan.targetKcalPerCatPerDay.toStringAsFixed(0);
    _portionUnit = existingPlan?.portionUnit ?? 'g';
    _portionUnitGramsController.text = (existingPlan?.portionUnitGrams ?? 1.0)
        .toStringAsFixed(2);
    _operationalNotesController.text = existingPlan?.operationalNotes ?? '';
    _weekendAlternative = false;
    _weekendKcalFactorController.text = '100';
    for (var weekday = 1; weekday <= 7; weekday++) {
      _weekdayOverridesEnabled[weekday] = false;
      _weekdayKcalFactorControllers[weekday]!.text = '100';
    }
    setState(() {});
  }

  Future<void> _pickPlanStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _planStartDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _planStartDate = DailyMealScheduleService.normalizeDay(picked);
    });
  }

  String _formatDate(DateTime date) {
    final normalized = DailyMealScheduleService.normalizeDay(date);
    final day = normalized.day.toString().padLeft(2, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    return '$day/$month/${normalized.year}';
  }

  Future<void> _pickMealTime(BuildContext context, int index) async {
    final initialTime = _parseStoredTime(
      _mealTimes[index],
      fallbackIndex: index,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked == null || !mounted) return;

    setState(() {
      _mealTimes[index] = picked.format(context);
    });
  }

  TimeOfDay _parseStoredTime(String value, {required int fallbackIndex}) {
    final sanitized = value.trim().toUpperCase();
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    ).firstMatch(sanitized);
    if (match == null) {
      return _defaultTimeForIndex(fallbackIndex);
    }

    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    final period = match.group(3);
    if (hour == null || minute == null || period == null) {
      return _defaultTimeForIndex(fallbackIndex);
    }

    var convertedHour = hour % 12;
    if (period == 'PM') convertedHour += 12;
    return TimeOfDay(hour: convertedHour, minute: minute);
  }

  TimeOfDay _defaultTimeForIndex(int index) {
    final fallback = DailyMealScheduleService.suggestedMealTimes(
      index + 1,
    )[index];
    return _parseStoredTime(fallback, fallbackIndex: 0);
  }

  double _portionUnitGramsValue() {
    final parsed = double.tryParse(
      _portionUnitGramsController.text.trim().replaceAll(',', '.'),
    );
    if (parsed != null && parsed > 0) return parsed;
    return _portionUnit == 'g'
        ? 1.0
        : PortionUnitService.gramsPerUnit(_portionUnit);
  }

  String _weekdayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Day $weekday';
    }
  }

  Map<int, Map<dynamic, dynamic>> _buildDailyOverrides({
    required double targetKcalPerDay,
    required double portionGramsPerDay,
  }) {
    final overrides = <int, Map<dynamic, dynamic>>{};
    for (var weekday = 1; weekday <= 7; weekday++) {
      if (_weekdayOverridesEnabled[weekday] != true) continue;
      final factor =
          (double.tryParse(
                _weekdayKcalFactorControllers[weekday]!.text.trim().replaceAll(
                  ',',
                  '.',
                ),
              ) ??
              100.0) /
          100;
      final dayKcal = targetKcalPerDay * factor;
      final dayPortion = portionGramsPerDay * factor;
      overrides[weekday] = <dynamic, dynamic>{
        'targetKcalPerDay': dayKcal,
        'portionGramsPerDay': dayPortion,
        'mealsPerDay': _mealsPerDay,
        'mealTimes': List<String>.from(_mealTimes),
        'mealLabels': DailyMealScheduleService.normalizeMealLabels(
          _currentMealLabels(),
          mealsPerDay: _mealsPerDay,
        ),
        'mealPortionGrams': _mealPortionsFromTotal(dayPortion),
        'kcalFactorPercent': factor * 100,
      };
    }
    if (!_weekendAlternative) return overrides;
    final factor =
        (double.tryParse(
              _weekendKcalFactorController.text.trim().replaceAll(',', '.'),
            ) ??
            100.0) /
        100;
    final weekendKcal = targetKcalPerDay * factor;
    final weekendPortion = portionGramsPerDay * factor;
    final weekendMealPortions = _mealPortionsFromTotal(weekendPortion);
    overrides[0] = <dynamic, dynamic>{
      'targetKcalPerDay': weekendKcal,
      'portionGramsPerDay': weekendPortion,
      'mealsPerDay': _mealsPerDay,
      'mealTimes': List<String>.from(_mealTimes),
      'mealLabels': DailyMealScheduleService.normalizeMealLabels(
        _currentMealLabels(),
        mealsPerDay: _mealsPerDay,
      ),
      'mealPortionGrams': weekendMealPortions,
      'kcalFactorPercent': factor * 100,
    };
    return overrides;
  }

  Future<void> _setActivePlanForCat({
    required CatProfile cat,
    required String planId,
  }) async {
    await ref
        .read(planRepositoryProvider)
        .setActivePlanForCat(catId: cat.id, planId: planId);
    if (!mounted) return;
    setState(() => _hydratedCatId = null);
  }

  Future<void> _deletePlanForCat({
    required CatProfile cat,
    required String planId,
  }) async {
    await ref.read(planRepositoryProvider).deletePlanById(planId);
    if (!mounted) return;
    setState(() => _hydratedCatId = null);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Plan deleted.')));
    final remaining = ref.read(planRepositoryProvider).getPlansForCat(cat.id);
    if (remaining.isNotEmpty) {
      final fallbackId = remaining.first.planId;
      if (fallbackId != null) {
        await _setActivePlanForCat(cat: cat, planId: fallbackId);
      }
    }
  }

  Future<void> _saveIndividualPlan(CatProfile cat) async {
    if (_selectedFoodKeys.isEmpty) return;
    final food = _selectedFood;
    if (food == null) return;
    final repository = ref.read(planRepositoryProvider);
    setState(() => _isSaving = true);

    try {
      DietCalculatorService.validateInputs(
        weightKg: cat.weight,
        ageMonths: cat.age,
        kcalPer100g: food.kcalPer100g,
        mealsPerDay: _mealsPerDay,
      );

      final targetKcalPerDay =
          cat.manualTargetKcal ??
          DietCalculatorService.suggestTargetKcal(
            weightKg: cat.weight,
            idealWeightKg: cat.idealWeight,
            ageMonths: cat.age,
            neutered: cat.neutered,
            activityLevel: cat.activityLevel,
            goal: cat.goal,
            bcs: cat.bcs,
          );
      final dailyPortionGrams =
          DietCalculatorService.calculateDailyPortionGrams(
            targetKcal: targetKcalPerDay,
            kcalPer100g: food.kcalPer100g,
          );
      final perMealGrams = DietCalculatorService.calculatePortionPerMealGrams(
        portionPerDayGrams: dailyPortionGrams,
        mealsPerDay: _mealsPerDay,
      );
      final mealPortions = _mealPortionsFromTotal(dailyPortionGrams);
      final selectedFoods = _selectedFoodKeys
          .map((key) => repository.findFoodByKey(key))
          .whereType<FoodItem>()
          .toList(growable: false);
      final unitGrams = _portionUnitGramsValue();
      final notes = _operationalNotesController.text.trim();
      final dailyOverrides = _buildDailyOverrides(
        targetKcalPerDay: targetKcalPerDay,
        portionGramsPerDay: dailyPortionGrams,
      );

      final plan = DietPlan(
        catId: cat.id,
        // maintain backward-compatible single-key fields; choose a representative
        // when multiple foods are selected so older callers that read first entry work.
        foodKey: _allowMultipleFoods
            ? (_selectedFoodKeys.isNotEmpty
                  ? _selectedFoodKeys.first
                  : food.key)
            : food.key,
        foodName: _allowMultipleFoods
            ? (_selectedFoodKeys.isNotEmpty
                  ? (repository.findFoodByKey(_selectedFoodKeys.first)?.name ??
                        '')
                  : food.name)
            : food.name,
        targetKcalPerDay: targetKcalPerDay,
        portionGramsPerDay: dailyPortionGrams,
        mealsPerDay: _mealsPerDay,
        portionGramsPerMeal: perMealGrams,
        createdAt: DateTime.now(),
        goal: cat.goal,
        mealTimes: List<String>.from(_mealTimes),
        mealLabels: DailyMealScheduleService.normalizeMealLabels(
          _currentMealLabels(),
          mealsPerDay: _mealsPerDay,
        ),
        mealPortionGrams: mealPortions,
        startDate: _planStartDate,
        // New multi-food fields (kept optional so legacy data stays compatible)
        foodKeys: selectedFoods.map((f) => f.key).toList(growable: false),
        foodNames: selectedFoods.map((f) => f.name).toList(growable: false),
        portionUnit: _portionUnit,
        portionUnitGrams: unitGrams,
        dailyOverrides: dailyOverrides,
        operationalNotes: notes.isEmpty ? null : notes,
      );

      final savedPlanId = await repository.savePlanForCat(plan);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Plan saved for ${cat.name}')));
      setState(() {
        _hydratedCatId = cat.id;
      });
      await repository.setActivePlanForCat(catId: cat.id, planId: savedPlanId);
    } on ArgumentError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message.toString())));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveGroupPlan(CatGroup group) async {
    if (_selectedFoodKeys.isEmpty) return;
    final food = _selectedFood;
    if (food == null) return;
    final repository = ref.read(planRepositoryProvider);

    final targetPerCat = double.tryParse(_groupKcalController.text.trim());
    if (targetPerCat == null || targetPerCat <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid kcal target per cat.')),
      );
      return;
    }
    setState(() => _isSaving = true);

    try {
      final linkedCatCount = group.catIds.length;
      final effectiveCatCount = linkedCatCount > 0
          ? linkedCatCount
          : group.catCount;
      final hasUnevenDistribution =
          group.feedingShareByCat.isNotEmpty && linkedCatCount > 0;
      final weightedCats = hasUnevenDistribution
          ? group.catIds.fold<double>(
              0.0,
              (sum, catId) => sum + (group.feedingShareByCat[catId] ?? 1.0),
            )
          : effectiveCatCount.toDouble();
      final portionPerCat = DietCalculatorService.calculateDailyPortionGrams(
        targetKcal: targetPerCat,
        kcalPer100g: food.kcalPer100g,
      );
      final totalKcal = targetPerCat * weightedCats;
      final totalPortion = portionPerCat * weightedCats;
      final portionPerGroupMeal =
          DietCalculatorService.calculatePortionPerMealGrams(
            portionPerDayGrams: totalPortion,
            mealsPerDay: _mealsPerDay,
          );
      final mealPortions = _mealPortionsFromTotal(totalPortion);
      final selectedFoods = _selectedFoodKeys
          .map((key) => repository.findFoodByKey(key))
          .whereType<FoodItem>()
          .toList(growable: false);
      final notes = _operationalNotesController.text.trim();

      final plan = GroupDietPlan(
        groupId: group.id,
        foodKey: food.key,
        foodName: food.name,
        catCount: effectiveCatCount,
        targetKcalPerCatPerDay: targetPerCat,
        targetKcalPerGroupPerDay: totalKcal,
        portionGramsPerCatPerDay: portionPerCat,
        portionGramsPerGroupPerDay: totalPortion,
        mealsPerDay: _mealsPerDay,
        portionGramsPerGroupPerMeal: portionPerGroupMeal,
        createdAt: DateTime.now(),
        mealTimes: List<String>.from(_mealTimes),
        mealLabels: DailyMealScheduleService.normalizeMealLabels(
          _currentMealLabels(),
          mealsPerDay: _mealsPerDay,
        ),
        mealPortionGrams: mealPortions,
        startDate: _planStartDate,
        manualTargetKcal: targetPerCat,
        foodKeys: selectedFoods.map((f) => f.key).toList(growable: false),
        portionUnit: _portionUnit,
        portionUnitGrams: _portionUnitGramsValue(),
        operationalNotes: notes.isEmpty ? null : notes,
        perCatShareWeights: hasUnevenDistribution
            ? {
                for (final catId in group.catIds)
                  catId: group.feedingShareByCat[catId] ?? 1.0,
              }
            : const {},
      );

      await repository.savePlanForGroup(plan);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Plan saved for ${group.name}')));
      setState(() => _hydratedGroupId = group.id);
    } on ArgumentError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message.toString())));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(catProfilesProvider);
    final groups = ref.watch(catGroupsProvider);
    final activeCat = ref.watch(selectedCatProvider);
    final repository = ref.read(planRepositoryProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    final selectedCat =
        _findCatById(cats, _selectedCatId) ??
        _findCatById(cats, activeCat?.id) ??
        (cats.isNotEmpty ? cats.first : null);
    final selectedGroup =
        _findGroupById(groups, _selectedGroupId) ??
        (groups.isNotEmpty ? groups.first : null);

    if (!_planningForGroup &&
        selectedCat != null &&
        _hydratedCatId != selectedCat.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hydratePlanForCat(selectedCat, ref);
      });
    }

    if (_planningForGroup &&
        selectedGroup != null &&
        _hydratedGroupId != selectedGroup.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hydratePlanForGroup(selectedGroup.id, ref);
      });
    }

    final showIndividualEmpty = !_planningForGroup && cats.isEmpty;
    final showGroupEmpty = _planningForGroup && groups.isEmpty;
    final selectedCatPlans = selectedCat == null
        ? const <DietPlan>[]
        : (repository.getPlansForCat(selectedCat.id)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
    final activePlanId = selectedCat == null
        ? null
        : repository.getActivePlanIdForCat(selectedCat.id);
    final groupKcalPresets = <double>{
      160,
      180,
      200,
      220,
      250,
      if (selectedGroup != null)
        repository.getPlanForGroup(selectedGroup.id)?.targetKcalPerCatPerDay ??
            0,
    }.where((value) => value > 0).toList()..sort();
    final canPreviewIndividual =
        !_planningForGroup &&
        selectedCat != null &&
        _selectedFood != null &&
        _selectedFoodKeys.isNotEmpty;
    final canPreviewGroup =
        _planningForGroup &&
        selectedGroup != null &&
        _selectedFood != null &&
        _selectedFoodKeys.isNotEmpty &&
        (double.tryParse(_groupKcalController.text.trim()) ?? 0) > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans'),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _SectionCard(
            primary: primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Build Plan',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text('Individual'),
                      selected: !_planningForGroup,
                      onSelected: (_) {
                        setState(() {
                          _planningForGroup = false;
                          _hydratedCatId = null;
                          _mealTimes =
                              DailyMealScheduleService.normalizeMealTimes(
                                _mealTimes,
                                mealsPerDay: _mealsPerDay,
                              );
                          _syncMealLabelControllers(
                            DailyMealScheduleService.normalizeMealLabels(
                              _currentMealLabels(),
                              mealsPerDay: _mealsPerDay,
                            ),
                          );
                          _syncMealShareControllers(
                            _normalizedMealSharesForCount(_mealsPerDay),
                          );
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Group'),
                      selected: _planningForGroup,
                      onSelected: (_) {
                        setState(() {
                          _planningForGroup = true;
                          _hydratedGroupId = null;
                          _mealTimes =
                              DailyMealScheduleService.normalizeMealTimes(
                                _mealTimes,
                                mealsPerDay: _mealsPerDay,
                              );
                          _syncMealLabelControllers(
                            DailyMealScheduleService.normalizeMealLabels(
                              _currentMealLabels(),
                              mealsPerDay: _mealsPerDay,
                            ),
                          );
                          _syncMealShareControllers(
                            _normalizedMealSharesForCount(_mealsPerDay),
                          );
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (!_planningForGroup)
                  DropdownButtonFormField<String>(
                    initialValue: selectedCat?.id,
                    decoration: const InputDecoration(
                      labelText: 'Cat Profile',
                      border: OutlineInputBorder(),
                    ),
                    items: cats.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: cats.isEmpty
                        ? null
                        : (value) {
                            if (value == null) return;
                            final nextCat = _findCatById(cats, value);
                            if (nextCat == null) return;
                            ref.read(selectedCatProvider.notifier).state =
                                nextCat;
                            setState(() {
                              _selectedCatId = value;
                              _hydratedCatId = null;
                            });
                          },
                  )
                else ...[
                  DropdownButtonFormField<String>(
                    initialValue: selectedGroup?.id,
                    decoration: const InputDecoration(
                      labelText: 'Group',
                      border: OutlineInputBorder(),
                    ),
                    items: groups.map((group) {
                      return DropdownMenuItem(
                        value: group.id,
                        child: Text('${group.name} (${group.catCount} cats)'),
                      );
                    }).toList(),
                    onChanged: groups.isEmpty
                        ? null
                        : (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedGroupId = value;
                              _hydratedGroupId = null;
                            });
                          },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _groupKcalController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Target kcal per cat / day',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: groupKcalPresets.map((preset) {
                      return ActionChip(
                        label: Text('${preset.toStringAsFixed(0)} kcal'),
                        onPressed: () {
                          setState(() {
                            _groupKcalController.text = preset.toStringAsFixed(
                              0,
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.catGroup);
                      },
                      icon: const Icon(Icons.groups_outlined),
                      label: const Text('Create Group'),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(4, (index) {
                    final meals = index + 3;
                    final selected = meals == _mealsPerDay;
                    return ChoiceChip(
                      label: Text('$meals meals/day'),
                      selected: selected,
                      onSelected: (_) => setState(() {
                        _mealsPerDay = meals;
                        _mealTimes =
                            DailyMealScheduleService.normalizeMealTimes(
                              _mealTimes,
                              mealsPerDay: meals,
                            );
                        _syncMealLabelControllers(
                          DailyMealScheduleService.normalizeMealLabels(
                            _currentMealLabels(),
                            mealsPerDay: meals,
                          ),
                        );
                        _syncMealShareControllers(
                          _normalizedMealSharesForCount(meals),
                        );
                      }),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Text(
                  'Plan Start Date',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _pickPlanStartDate(context),
                  icon: const Icon(Icons.event_rounded),
                  label: Text('Starts on ${_formatDate(_planStartDate)}'),
                ),
                const SizedBox(height: 14),
                Text(
                  'Portion Unit',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _portionUnit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  items: PortionUnitService.supportedUnits().map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _portionUnit = value;
                      _portionUnitGramsController.text =
                          PortionUnitService.gramsPerUnit(
                            value,
                          ).toStringAsFixed(2);
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _portionUnitGramsController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Grams per unit',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: _weekendAlternative,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Weekend alternative'),
                  subtitle: const Text(
                    'Apply a different kcal/portion factor on Saturday and Sunday.',
                  ),
                  onChanged: _planningForGroup
                      ? null
                      : (value) => setState(() => _weekendAlternative = value),
                ),
                if (_weekendAlternative && !_planningForGroup) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _weekendKcalFactorController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Weekend kcal factor (%)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                if (!_planningForGroup) ...[
                  const SizedBox(height: 8),
                  Text(
                    'By Weekday',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enable specific days and set a kcal/portion factor for each day.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(7, (index) {
                    final weekday = index + 1;
                    final enabled = _weekdayOverridesEnabled[weekday] == true;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(_weekdayLabel(weekday)),
                              value: enabled,
                              onChanged: (value) {
                                setState(() {
                                  _weekdayOverridesEnabled[weekday] = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 130,
                            child: TextFormField(
                              controller:
                                  _weekdayKcalFactorControllers[weekday],
                              enabled: enabled,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Factor %',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 8),
                TextFormField(
                  controller: _operationalNotesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Operational notes',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Meal Labels',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(_mealLabelControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _mealLabelControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Meal ${index + 1} name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Text(
                  'Meal Portions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Set the percentage of the daily portion served in each meal. The app normalizes the total to 100%.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
                ),
                const SizedBox(height: 12),
                ...List.generate(_mealShareControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _mealShareControllers[index],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText:
                            '${_mealLabelControllers[index].text.trim().isEmpty ? 'Meal ${index + 1}' : _mealLabelControllers[index].text.trim()} share (%)',
                        border: const OutlineInputBorder(),
                        suffixText: '%',
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Text(
                  'Meal Schedule',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose the time for each meal. Daily and Home will use this schedule.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
                ),
                const SizedBox(height: 12),
                ...List.generate(_mealTimes.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton.icon(
                      onPressed: () => _pickMealTime(context, index),
                      icon: const Icon(Icons.schedule_rounded),
                      label: Text(
                        '${DailyMealScheduleService.mealLabel(index)} • ${_mealTimes[index]}',
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (showIndividualEmpty) ...[
            const SizedBox(height: 16),
            _EmptyPlanState(
              primary: primary,
              secondary: secondary,
              title: 'No cat profiles available',
              message:
                  'Create a cat profile before building an individual meal plan.',
            ),
          ],
          if (showGroupEmpty) ...[
            const SizedBox(height: 16),
            _EmptyPlanState(
              primary: primary,
              secondary: secondary,
              title: 'No groups available',
              message: 'Create a group before building a shared meal plan.',
            ),
          ],
          if (!_planningForGroup && selectedCat != null) ...[
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: repository.individualPlanListenable(),
              builder: (context, Box<DietPlan> box, _) {
                final plans = selectedCatPlans;
                if (plans.isEmpty) return const SizedBox.shrink();
                final activePlan = plans.firstWhere(
                  (plan) => plan.planId == activePlanId,
                  orElse: () => repository.getPlanForCat(selectedCat.id)!,
                );
                final activePlanFoods = activePlan.foodNames.isEmpty
                    ? activePlan.foodName
                    : activePlan.foodNames.join(' + ');

                return _SavedPlanCard(
                  title: 'Saved Individual Plan',
                  metrics: [
                    _PlanMetric(label: 'Food', value: activePlanFoods),
                    _PlanMetric(
                      label: 'Daily Goal',
                      value:
                          '${activePlan.targetKcalPerDay.toStringAsFixed(0)} kcal',
                    ),
                    _PlanMetric(
                      label: 'Per Day',
                      value:
                          '${activePlan.portionGramsPerDay.toStringAsFixed(1)} g',
                    ),
                    _PlanMetric(
                      label: 'Per Meal',
                      value:
                          '${activePlan.portionGramsPerMeal.toStringAsFixed(1)} g',
                    ),
                    _PlanMetric(
                      label: 'Schedule',
                      value: activePlan.mealTimes.join(' • '),
                    ),
                    _PlanMetric(
                      label: 'Meal Names',
                      value: activePlan.mealLabels.join(' • '),
                    ),
                    _PlanMetric(
                      label: 'Starts',
                      value: _formatDate(activePlan.startDate),
                    ),
                    _PlanMetric(
                      label: 'Portions',
                      value: activePlan.mealPortionGrams
                          .map((value) => '${value.toStringAsFixed(1)} g')
                          .join(' • '),
                    ),
                    _PlanMetric(
                      label: 'Unit',
                      value:
                          '${activePlan.portionUnit} (${activePlan.portionUnitGrams.toStringAsFixed(2)} g)',
                    ),
                    _PlanMetric(
                      label: 'Notes',
                      value: activePlan.operationalNotes ?? '-',
                    ),
                    _PlanMetric(
                      label: 'Weekend Alt',
                      value: activePlan.dailyOverrides.containsKey(0)
                          ? 'Enabled'
                          : 'Disabled',
                    ),
                    _PlanMetric(
                      label: 'Weekday Overrides',
                      value: activePlan.dailyOverrides.keys
                          .where((key) => key >= 1 && key <= 7)
                          .length
                          .toString(),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        initialValue: activePlan.planId,
                        decoration: const InputDecoration(
                          labelText: 'Active plan',
                          border: OutlineInputBorder(),
                        ),
                        items: plans.where((plan) => plan.planId != null).map((
                          plan,
                        ) {
                          return DropdownMenuItem<String>(
                            value: plan.planId!,
                            child: Text(
                              '${_formatDate(plan.startDate)} • ${plan.createdAt.hour.toString().padLeft(2, '0')}:${plan.createdAt.minute.toString().padLeft(2, '0')}',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          await _setActivePlanForCat(
                            cat: selectedCat,
                            planId: value,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: plans
                            .where((plan) => plan.planId != null)
                            .map((plan) {
                              final isActive = plan.planId == activePlanId;
                              return OutlinedButton.icon(
                                onPressed: isActive
                                    ? null
                                    : () async {
                                        await _setActivePlanForCat(
                                          cat: selectedCat,
                                          planId: plan.planId!,
                                        );
                                      },
                                icon: const Icon(Icons.check_circle_outline),
                                label: Text(
                                  'Use ${_formatDate(plan.startDate)}',
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: activePlan.planId == null
                            ? null
                            : () async {
                                await _deletePlanForCat(
                                  cat: selectedCat,
                                  planId: activePlan.planId!,
                                );
                              },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete active plan'),
                      ),
                    ),
                  ],
                  primary: primary,
                );
              },
            ),
          ],
          if (_planningForGroup && selectedGroup != null) ...[
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: repository.groupPlanListenable(selectedGroup.id),
              builder: (context, Box<GroupDietPlan> box, _) {
                final plan = box.get(selectedGroup.id);
                if (plan == null) return const SizedBox.shrink();

                return _SavedPlanCard(
                  title: 'Saved Group Plan',
                  metrics: [
                    _PlanMetric(
                      label: 'Food',
                      value: plan.foodKeys.length > 1
                          ? '${plan.foodName} + ${plan.foodKeys.length - 1} more'
                          : plan.foodName,
                    ),
                    _PlanMetric(label: 'Cats', value: '${plan.catCount}'),
                    _PlanMetric(
                      label: 'Per Cat',
                      value:
                          '${plan.targetKcalPerCatPerDay.toStringAsFixed(0)} kcal',
                    ),
                    _PlanMetric(
                      label: 'Group Total',
                      value:
                          '${plan.targetKcalPerGroupPerDay.toStringAsFixed(0)} kcal',
                    ),
                    _PlanMetric(
                      label: 'Group / Day',
                      value:
                          '${plan.portionGramsPerGroupPerDay.toStringAsFixed(1)} g',
                    ),
                    _PlanMetric(
                      label: 'Group / Meal',
                      value:
                          '${plan.portionGramsPerGroupPerMeal.toStringAsFixed(1)} g',
                    ),
                    _PlanMetric(
                      label: 'Schedule',
                      value: plan.mealTimes.join(' • '),
                    ),
                    _PlanMetric(
                      label: 'Meal Names',
                      value: plan.mealLabels.join(' • '),
                    ),
                    _PlanMetric(
                      label: 'Starts',
                      value: _formatDate(plan.startDate),
                    ),
                    _PlanMetric(
                      label: 'Portions',
                      value: plan.mealPortionGrams
                          .map((value) => '${value.toStringAsFixed(1)} g')
                          .join(' • '),
                    ),
                    _PlanMetric(
                      label: 'Unit',
                      value:
                          '${plan.portionUnit} (${plan.portionUnitGrams.toStringAsFixed(2)} g)',
                    ),
                    _PlanMetric(
                      label: 'Notes',
                      value: plan.operationalNotes ?? '-',
                    ),
                    _PlanMetric(
                      label: 'Distribution',
                      value: plan.perCatShareWeights.isEmpty
                          ? 'Equal'
                          : 'Unequal (${plan.perCatShareWeights.length} cats)',
                    ),
                  ],
                  primary: primary,
                );
              },
            ),
          ],
          if (canPreviewIndividual) ...[
            const SizedBox(height: 16),
            _IndividualPlanSummaryCard(
              cat: selectedCat,
              food: _selectedFood!,
              mealsPerDay: _mealsPerDay,
              mealTimes: _mealTimes,
              mealLabels: DailyMealScheduleService.normalizeMealLabels(
                _currentMealLabels(),
                mealsPerDay: _mealsPerDay,
              ),
              mealPortions: _mealPortionsFromTotal(
                DietCalculatorService.calculateDailyPortionGrams(
                  targetKcal:
                      selectedCat.manualTargetKcal ??
                      DietCalculatorService.suggestTargetKcal(
                        weightKg: selectedCat.weight,
                        idealWeightKg: selectedCat.idealWeight,
                        ageMonths: selectedCat.age,
                        neutered: selectedCat.neutered,
                        activityLevel: selectedCat.activityLevel,
                        goal: selectedCat.goal,
                        bcs: selectedCat.bcs,
                      ),
                  kcalPer100g: _selectedFood!.kcalPer100g,
                ),
              ),
              startDate: _planStartDate,
            ),
          ],
          if (canPreviewGroup) ...[
            const SizedBox(height: 16),
            _GroupPlanSummaryCard(
              group: selectedGroup,
              food: _selectedFood!,
              mealsPerDay: _mealsPerDay,
              targetKcalPerCat: double.parse(_groupKcalController.text.trim()),
              mealTimes: _mealTimes,
              mealLabels: DailyMealScheduleService.normalizeMealLabels(
                _currentMealLabels(),
                mealsPerDay: _mealsPerDay,
              ),
              mealPortions: _mealPortionsFromTotal(
                DietCalculatorService.calculateDailyPortionGrams(
                      targetKcal: double.parse(
                        _groupKcalController.text.trim(),
                      ),
                      kcalPer100g: _selectedFood!.kcalPer100g,
                    ) *
                    selectedGroup.catCount,
              ),
              startDate: _planStartDate,
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Available Foods',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: repository.foodsListenable(),
            builder: (context, Box<FoodItem> box, _) {
              final foods = repository.getAllFoods();

              if (foods.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.pets_rounded,
                  title: 'No foods available',
                  description:
                      'Add foods in Food Database before creating a plan.',
                );
              }

              return Column(
                children: [
                  SwitchListTile(
                    value: _allowMultipleFoods,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Multiple foods'),
                    subtitle: const Text(
                      'Allow selecting multiple foods for the plan',
                    ),
                    onChanged: (v) => setState(() => _allowMultipleFoods = v),
                  ),
                  ...List<Widget>.generate(foods.length, (index) {
                    final food = foods[index];
                    final selected = _allowMultipleFoods
                        ? _selectedFoodKeys.contains(food.key)
                        : _selectedFood?.key == food.key;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => setState(() {
                          // If multiple selection mode is active, toggle the food key
                          if (_allowMultipleFoods) {
                            final key = food.key;
                            if (_selectedFoodKeys.contains(key)) {
                              _selectedFoodKeys.remove(key);
                            } else {
                              _selectedFoodKeys.add(key);
                            }
                            // Keep `_selectedFood` in sync with a single representative when needed
                            _selectedFood = _selectedFoodKeys.isNotEmpty
                                ? repository.findFoodByKey(
                                    _selectedFoodKeys.first,
                                  )
                                : null;
                          } else {
                            // Single selection behaviour (existing)
                            _selectedFood = food;
                            _selectedFoodKeys
                              ..clear()
                              ..add(food.key);
                          }
                        }),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final narrow = constraints.maxWidth < 360;
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected
                                      ? primary
                                      : primary.withValues(alpha: 0.10),
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: narrow
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 22,
                                              backgroundColor: primary
                                                  .withValues(alpha: 0.10),
                                              child: Icon(
                                                Icons.pets_rounded,
                                                color: primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    food.name,
                                                    style: theme
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    food.brand ??
                                                        'Unknown brand',
                                                    style: theme
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: secondary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          '${food.kcalPer100g.toStringAsFixed(0)} kcal',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                color: primary,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor: primary.withValues(
                                            alpha: 0.10,
                                          ),
                                          child: Icon(
                                            Icons.pets_rounded,
                                            color: primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                food.name,
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                food.brand ?? 'Unknown brand',
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: secondary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${food.kcalPer100g.toStringAsFixed(0)} kcal',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                color: primary,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ],
                                    ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _isSaving
                ? null
                : _selectedFood == null || _selectedFoodKeys.isEmpty
                ? null
                : _planningForGroup
                ? (selectedGroup == null
                      ? null
                      : () => _saveGroupPlan(selectedGroup))
                : (selectedCat == null
                      ? null
                      : () => _saveIndividualPlan(selectedCat)),
            icon: _isSaving
                ? const SizedBox.shrink()
                : const Icon(Icons.save_rounded),
            label: _isSaving
                ? const AppLoadingState(compact: true, label: 'Saving...')
                : Text(_planningForGroup ? 'Save Group Plan' : 'Save Plan'),
          ),
        ],
      ),
    );
  }
}

class _PlanMetric extends StatelessWidget {
  const _PlanMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _IndividualPlanSummaryCard extends StatelessWidget {
  const _IndividualPlanSummaryCard({
    required this.cat,
    required this.food,
    required this.mealsPerDay,
    required this.mealTimes,
    required this.mealLabels,
    required this.mealPortions,
    required this.startDate,
  });

  final CatProfile cat;
  final FoodItem food;
  final int mealsPerDay;
  final List<String> mealTimes;
  final List<String> mealLabels;
  final List<double> mealPortions;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);
    final targetKcal =
        cat.manualTargetKcal ??
        DietCalculatorService.suggestTargetKcal(
          weightKg: cat.weight,
          idealWeightKg: cat.idealWeight,
          ageMonths: cat.age,
          neutered: cat.neutered,
          activityLevel: cat.activityLevel,
          goal: cat.goal,
          bcs: cat.bcs,
        );
    final dailyPortion = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: targetKcal,
      kcalPer100g: food.kcalPer100g,
    );
    final perMeal = DietCalculatorService.calculatePortionPerMealGrams(
      portionPerDayGrams: dailyPortion,
      mealsPerDay: mealsPerDay,
    );
    final alert = DietCalculatorService.healthAlertForWeight(cat.weight);

    return _SectionCard(
      primary: primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan Preview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${cat.name} with ${food.name}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${food.kcalPer100g.toStringAsFixed(0)} kcal per 100g',
            style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PlanMetric(
                label: 'Daily Goal',
                value: '${targetKcal.toStringAsFixed(0)} kcal',
              ),
              _PlanMetric(
                label: 'Daily Portion',
                value: '${dailyPortion.toStringAsFixed(1)} g',
              ),
              _PlanMetric(
                label: 'Per Meal',
                value: '${perMeal.toStringAsFixed(1)} g',
              ),
              _PlanMetric(label: 'Goal', value: catGoalLabel(cat.goal)),
              _PlanMetric(label: 'Meals/day', value: mealsPerDay.toString()),
              _PlanMetric(
                label: 'Starts',
                value:
                    '${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}',
              ),
              _PlanMetric(label: 'Meal Names', value: mealLabels.join(' • ')),
              _PlanMetric(label: 'Schedule', value: mealTimes.join(' • ')),
              _PlanMetric(
                label: 'Portions',
                value: mealPortions
                    .map((value) => '${value.toStringAsFixed(1)} g')
                    .join(' • '),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              alert,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupPlanSummaryCard extends StatelessWidget {
  const _GroupPlanSummaryCard({
    required this.group,
    required this.food,
    required this.mealsPerDay,
    required this.targetKcalPerCat,
    required this.mealTimes,
    required this.mealLabels,
    required this.mealPortions,
    required this.startDate,
  });

  final CatGroup group;
  final FoodItem food;
  final int mealsPerDay;
  final double targetKcalPerCat;
  final List<String> mealTimes;
  final List<String> mealLabels;
  final List<double> mealPortions;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

    final portionPerCat = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: targetKcalPerCat,
      kcalPer100g: food.kcalPer100g,
    );
    final totalKcal = targetKcalPerCat * group.catCount;
    final totalPortion = portionPerCat * group.catCount;
    final perGroupMeal = DietCalculatorService.calculatePortionPerMealGrams(
      portionPerDayGrams: totalPortion,
      mealsPerDay: mealsPerDay,
    );

    return _SectionCard(
      primary: primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Group Plan Preview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${group.name} with ${food.name}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${group.catCount} cats • ${food.kcalPer100g.toStringAsFixed(0)} kcal per 100g',
            style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PlanMetric(
                label: 'Per Cat',
                value: '${targetKcalPerCat.toStringAsFixed(0)} kcal',
              ),
              _PlanMetric(
                label: 'Group Total',
                value: '${totalKcal.toStringAsFixed(0)} kcal',
              ),
              _PlanMetric(
                label: 'Cat / Day',
                value: '${portionPerCat.toStringAsFixed(1)} g',
              ),
              _PlanMetric(
                label: 'Group / Day',
                value: '${totalPortion.toStringAsFixed(1)} g',
              ),
              _PlanMetric(
                label: 'Group / Meal',
                value: '${perGroupMeal.toStringAsFixed(1)} g',
              ),
              _PlanMetric(
                label: 'Starts',
                value:
                    '${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}',
              ),
              _PlanMetric(label: 'Meal Names', value: mealLabels.join(' • ')),
              _PlanMetric(label: 'Schedule', value: mealTimes.join(' • ')),
              _PlanMetric(
                label: 'Portions',
                value: mealPortions
                    .map((value) => '${value.toStringAsFixed(1)} g')
                    .join(' • '),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'This shared plan uses a single kcal target per cat and scales the total portion by the group size.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedPlanCard extends StatelessWidget {
  const _SavedPlanCard({
    required this.title,
    required this.metrics,
    required this.primary,
  });

  final String title;
  final List<Widget> metrics;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _SectionCard(
        primary: primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 12, runSpacing: 12, children: metrics),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, required this.primary});

  final Widget child;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.10)),
      ),
      child: child,
    );
  }
}

class _EmptyPlanState extends StatelessWidget {
  const _EmptyPlanState({
    required this.primary,
    required this.secondary,
    required this.title,
    required this.message,
  });

  final Color primary;
  final Color secondary;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      primary: primary,
      child: Column(
        children: [
          Icon(Icons.pets_rounded, size: 42, color: primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
          ),
        ],
      ),
    );
  }
}

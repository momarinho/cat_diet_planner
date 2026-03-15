import 'package:cat_diet_planner/core/localization/app_formatters.dart';
import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/localization/app_feedback_localizer.dart';
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
import 'package:cat_diet_planner/features/plans/models/plan_preview_data.dart';
import 'package:cat_diet_planner/features/plans/providers/plan_repository_provider.dart';
import 'package:cat_diet_planner/features/plans/repositories/plan_repository.dart';
import 'package:cat_diet_planner/features/plans/services/plan_preview_builder.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';
import 'package:cat_diet_planner/features/plans/services/portion/portion_unit_service.dart';
import 'package:cat_diet_planner/features/plans/widgets/plan_inspector_sheet.dart';
import 'package:cat_diet_planner/features/suggestions/widgets/cat_suggestions_section.dart';
import 'package:cat_diet_planner/l10n/app_localizations.dart';
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

  void _handleDraftChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _groupKcalController = TextEditingController(text: '220');
    _operationalNotesController = TextEditingController();
    _portionUnitGramsController = TextEditingController(text: '1');
    _weekendKcalFactorController = TextEditingController(text: '100');
    _groupKcalController.addListener(_handleDraftChanged);
    _operationalNotesController.addListener(_handleDraftChanged);
    _portionUnitGramsController.addListener(_handleDraftChanged);
    _weekendKcalFactorController.addListener(_handleDraftChanged);
    _weekdayKcalFactorControllers = {
      for (var weekday = 1; weekday <= 7; weekday++)
        weekday: TextEditingController(text: '100')
          ..addListener(_handleDraftChanged),
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
        .map(
          (label) =>
              TextEditingController(text: label)
                ..addListener(_handleDraftChanged),
        )
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
        .map(
          (share) =>
              TextEditingController(text: share.toStringAsFixed(0))
                ..addListener(_handleDraftChanged),
        )
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

  String _catHydrationKey(String catId, DietPlan? plan) {
    return '$catId:${plan?.planId ?? 'none'}:${plan?.createdAt.toIso8601String() ?? 'none'}';
  }

  String _groupHydrationKey(String groupId, GroupDietPlan? plan) {
    return '$groupId:${plan?.createdAt.toIso8601String() ?? 'none'}';
  }

  List<FoodItem> _selectedFoods(PlanRepository repository) {
    return _selectedFoodKeys
        .map((key) => repository.findFoodByKey(key))
        .whereType<FoodItem>()
        .toList(growable: false);
  }

  PlanPreviewData? _buildIndividualPreview({
    required CatProfile cat,
    required PlanRepository repository,
  }) {
    final selectedFoods = _selectedFoods(repository);
    if (selectedFoods.isEmpty) return null;
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
    final portionGramsPerDay = DietCalculatorService.calculateDailyPortionGrams(
      targetKcal: targetKcalPerDay,
      kcalPer100g: selectedFoods.first.kcalPer100g,
    );
    final dailyOverrides = _buildDailyOverrides(
      targetKcalPerDay: targetKcalPerDay,
      portionGramsPerDay: portionGramsPerDay,
    );

    return PlanPreviewBuilder.buildIndividual(
      cat: cat,
      selectedFoods: selectedFoods,
      mealsPerDay: _mealsPerDay,
      mealTimes: List<String>.from(_mealTimes),
      mealLabels: _currentMealLabels(),
      normalizedMealShares: _normalizedMealShares(),
      startDate: _planStartDate,
      portionUnit: _portionUnit,
      portionUnitGrams: _portionUnitGramsValue(),
      dailyOverrides: dailyOverrides,
      operationalNotes: _operationalNotesController.text.trim().isEmpty
          ? null
          : _operationalNotesController.text.trim(),
    );
  }

  PlanPreviewData? _buildGroupPreview({
    required CatGroup group,
    required PlanRepository repository,
  }) {
    final selectedFoods = _selectedFoods(repository);
    final targetKcalPerCat = double.tryParse(_groupKcalController.text.trim());
    if (selectedFoods.isEmpty ||
        targetKcalPerCat == null ||
        targetKcalPerCat <= 0) {
      return null;
    }

    return PlanPreviewBuilder.buildGroup(
      groupName: group.name,
      catCount: group.catCount,
      targetKcalPerCat: targetKcalPerCat,
      selectedFoods: selectedFoods,
      mealsPerDay: _mealsPerDay,
      mealTimes: List<String>.from(_mealTimes),
      mealLabels: _currentMealLabels(),
      normalizedMealShares: _normalizedMealShares(),
      startDate: _planStartDate,
      portionUnit: _portionUnit,
      portionUnitGrams: _portionUnitGramsValue(),
      operationalNotes: _operationalNotesController.text.trim().isEmpty
          ? null
          : _operationalNotesController.text.trim(),
    );
  }

  void _hydratePlanForCat(CatProfile cat, WidgetRef ref) {
    final repository = ref.read(planRepositoryProvider);
    final existingPlan = repository.getPlanForCat(cat.id);
    _hydratedCatId = _catHydrationKey(cat.id, existingPlan);
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
    _hydratedGroupId = _groupHydrationKey(groupId, existingPlan);
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
    return AppFormatters.formatDate(context, normalized);
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

  String _weekdayLabel(BuildContext context, int weekday) {
    final l10n = AppLocalizations.of(context);
    switch (weekday) {
      case DateTime.monday:
        return l10n.mondayLabel;
      case DateTime.tuesday:
        return l10n.tuesdayLabel;
      case DateTime.wednesday:
        return l10n.wednesdayLabel;
      case DateTime.thursday:
        return l10n.thursdayLabel;
      case DateTime.friday:
        return l10n.fridayLabel;
      case DateTime.saturday:
        return l10n.saturdayLabel;
      case DateTime.sunday:
        return l10n.sundayLabel;
      default:
        return l10n.dayFallbackLabel(weekday);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).planDeletedMessage)),
    );
    final remaining = ref.read(planRepositoryProvider).getPlansForCat(cat.id);
    if (remaining.isNotEmpty) {
      final fallbackId = remaining.first.planId;
      if (fallbackId != null) {
        await _setActivePlanForCat(cat: cat, planId: fallbackId);
      }
    }
  }

  Future<void> _saveIndividualPlan(CatProfile cat) async {
    final repository = ref.read(planRepositoryProvider);
    final preview = _buildIndividualPreview(cat: cat, repository: repository);
    final selectedFoods = _selectedFoods(repository);
    if (preview == null || selectedFoods.isEmpty) return;
    final food = selectedFoods.first;
    setState(() => _isSaving = true);

    try {
      DietCalculatorService.validateInputs(
        weightKg: cat.weight,
        ageMonths: cat.age,
        kcalPer100g: food.kcalPer100g,
        mealsPerDay: _mealsPerDay,
      );

      final plan = DietPlan(
        catId: cat.id,
        foodKey: _allowMultipleFoods ? selectedFoods.first.key : food.key,
        foodName: _allowMultipleFoods ? selectedFoods.first.name : food.name,
        targetKcalPerDay: preview.targetKcalPerDay,
        portionGramsPerDay: preview.portionGramsPerDay,
        mealsPerDay: preview.mealsPerDay,
        portionGramsPerMeal: preview.portionGramsPerMeal,
        createdAt: DateTime.now(),
        goal: cat.goal,
        mealTimes: preview.mealTimes,
        mealLabels: preview.mealLabels,
        mealPortionGrams: preview.mealPortionGrams,
        startDate: preview.startDate,
        foodKeys: selectedFoods.map((f) => f.key).toList(growable: false),
        foodNames: selectedFoods.map((f) => f.name).toList(growable: false),
        portionUnit: preview.portionUnit,
        portionUnitGrams: preview.portionUnitGrams,
        dailyOverrides: preview.dailyOverrides,
        operationalNotes: preview.operationalNotes,
      );

      final savedPlanId = await repository.savePlanForCat(plan);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).planSavedForCatMessage(cat.name),
          ),
        ),
      );
      setState(() {
        _hydratedCatId = null;
      });
      await repository.setActivePlanForCat(catId: cat.id, planId: savedPlanId);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizeErrorMessage(AppLocalizations.of(context), error),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveGroupPlan(CatGroup group) async {
    final repository = ref.read(planRepositoryProvider);
    final preview = _buildGroupPreview(group: group, repository: repository);
    final selectedFoods = _selectedFoods(repository);
    if (preview == null || selectedFoods.isEmpty) return;
    final food = selectedFoods.first;

    final targetPerCat = double.tryParse(_groupKcalController.text.trim());
    if (targetPerCat == null || targetPerCat <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).enterValidKcalPerCatMessage,
          ),
        ),
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
      final plan = GroupDietPlan(
        groupId: group.id,
        foodKey: food.key,
        foodName: food.name,
        catCount: effectiveCatCount,
        targetKcalPerCatPerDay: targetPerCat,
        targetKcalPerGroupPerDay: totalKcal,
        portionGramsPerCatPerDay: portionPerCat,
        portionGramsPerGroupPerDay: preview.portionGramsPerDay,
        mealsPerDay: preview.mealsPerDay,
        portionGramsPerGroupPerMeal: preview.portionGramsPerMeal,
        createdAt: DateTime.now(),
        mealTimes: preview.mealTimes,
        mealLabels: preview.mealLabels,
        mealPortionGrams: preview.mealPortionGrams,
        startDate: preview.startDate,
        manualTargetKcal: targetPerCat,
        foodKeys: selectedFoods.map((f) => f.key).toList(growable: false),
        portionUnit: preview.portionUnit,
        portionUnitGrams: preview.portionUnitGrams,
        operationalNotes: preview.operationalNotes,
        perCatShareWeights: hasUnevenDistribution
            ? {
                for (final catId in group.catIds)
                  catId: group.feedingShareByCat[catId] ?? 1.0,
              }
            : const {},
      );

      await repository.savePlanForGroup(plan);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).planSavedForGroupMessage(group.name),
          ),
        ),
      );
      setState(() => _hydratedGroupId = null);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizeErrorMessage(AppLocalizations.of(context), error),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _openPlanInspector({
    required PlanRepository repository,
    required Color primary,
    required CatProfile? selectedCat,
    required CatGroup? selectedGroup,
    required PlanPreviewData? individualPreview,
    required PlanPreviewData? groupPreview,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        final navigator = Navigator.of(context);
        return PlanInspectorSheet(
          planningForGroup: _planningForGroup,
          selectedCat: selectedCat,
          selectedGroup: selectedGroup,
          individualPreview: individualPreview,
          groupPreview: groupPreview,
          repository: repository,
          primary: primary,
          formatDate: _formatDate,
          onSetActivePlanForCat: (cat, planId) async {
            await _setActivePlanForCat(cat: cat, planId: planId);
          },
          onDeletePlanForCat: (cat, planId) async {
            await _deletePlanForCat(cat: cat, planId: planId);
            if (!mounted) return;
            if (navigator.canPop()) {
              navigator.pop();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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

    final selectedCatHydrationKey = selectedCat == null
        ? null
        : _catHydrationKey(
            selectedCat.id,
            repository.getPlanForCat(selectedCat.id),
          );
    final selectedGroupHydrationKey = selectedGroup == null
        ? null
        : _groupHydrationKey(
            selectedGroup.id,
            repository.getPlanForGroup(selectedGroup.id),
          );

    if (!_planningForGroup &&
        selectedCat != null &&
        _hydratedCatId != selectedCatHydrationKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hydratePlanForCat(selectedCat, ref);
      });
    }

    if (_planningForGroup &&
        selectedGroup != null &&
        _hydratedGroupId != selectedGroupHydrationKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hydratePlanForGroup(selectedGroup.id, ref);
      });
    }

    final showIndividualEmpty = !_planningForGroup && cats.isEmpty;
    final showGroupEmpty = _planningForGroup && groups.isEmpty;
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
    final individualPreview = !_planningForGroup && selectedCat != null
        ? _buildIndividualPreview(cat: selectedCat, repository: repository)
        : null;
    final groupPreview = _planningForGroup && selectedGroup != null
        ? _buildGroupPreview(group: selectedGroup, repository: repository)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.plansTitle),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.planInspectorTooltip,
            onPressed: () => _openPlanInspector(
              repository: repository,
              primary: primary,
              selectedCat: selectedCat,
              selectedGroup: selectedGroup,
              individualPreview: individualPreview,
              groupPreview: groupPreview,
            ),
            icon: const Icon(Icons.visibility_outlined),
          ),
        ],
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
                  l10n.buildPlanTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.individualPlanMode),
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
                      label: Text(l10n.groupPlanMode),
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
                    decoration: InputDecoration(
                      labelText: l10n.catProfileLabel,
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
                    decoration: InputDecoration(
                      labelText: l10n.groupLabel,
                      border: OutlineInputBorder(),
                    ),
                    items: groups.map((group) {
                      return DropdownMenuItem(
                        value: group.id,
                        child: Text(
                          l10n.groupWithCats(group.name, group.catCount),
                        ),
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
                    decoration: InputDecoration(
                      labelText: l10n.targetKcalPerCatPerDayLabel,
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
                      label: Text(l10n.createGroupAction),
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
                      label: Text(l10n.mealsPerDayChip(meals)),
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
                  l10n.planStartDateTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _pickPlanStartDate(context),
                  icon: const Icon(Icons.event_rounded),
                  label: Text(l10n.startsOnLabel(_formatDate(_planStartDate))),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.portionUnitTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _portionUnit,
                  decoration: InputDecoration(
                    labelText: l10n.unitLabel,
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
                  decoration: InputDecoration(
                    labelText: l10n.gramsPerUnitLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: _weekendAlternative,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.weekendAlternativeTitle),
                  subtitle: Text(l10n.weekendAlternativeDescription),
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
                    decoration: InputDecoration(
                      labelText: l10n.weekendKcalFactorLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                if (!_planningForGroup) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.byWeekdayTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.byWeekdayDescription,
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
                              title: Text(_weekdayLabel(context, weekday)),
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
                              decoration: InputDecoration(
                                labelText: l10n.factorPercentLabel,
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
                  decoration: InputDecoration(
                    labelText: l10n.operationalNotesLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.mealLabelsTitle,
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
                        labelText: l10n.mealNameLabel(index + 1),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Text(
                  l10n.mealPortionsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.mealPortionsDescription,
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
                        labelText: l10n.mealShareLabel(
                          _mealLabelControllers[index].text.trim().isEmpty
                              ? l10n.mealFallbackTitle(index + 1)
                              : _mealLabelControllers[index].text.trim(),
                        ),
                        border: const OutlineInputBorder(),
                        suffixText: '%',
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Text(
                  l10n.mealScheduleTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.mealScheduleDescription,
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
                        '${AppLocalizations.of(context).mealFallbackTitle(index + 1)} • ${AppFormatters.formatStoredMealTime(context, _mealTimes[index])}',
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          if (!_planningForGroup && selectedCat != null) ...[
            const SizedBox(height: 16),
            CatSuggestionsSection(
              cat: selectedCat,
              title: l10n.suggestionsTitle,
              maxItems: 3,
            ),
          ],
          if (showIndividualEmpty) ...[
            const SizedBox(height: 16),
            _EmptyPlanState(
              primary: primary,
              secondary: secondary,
              title: l10n.noCatProfilesAvailableTitle,
              message: l10n.noCatProfilesAvailableMessage,
            ),
          ],
          if (showGroupEmpty) ...[
            const SizedBox(height: 16),
            _EmptyPlanState(
              primary: primary,
              secondary: secondary,
              title: l10n.noGroupsAvailableTitle,
              message: l10n.noGroupsAvailableMessage,
            ),
          ],
          const SizedBox(height: 16),
          Text(
            l10n.availableFoodsTitle,
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
                return AppEmptyState(
                  icon: Icons.pets_rounded,
                  title: l10n.noFoodsAvailableTitle,
                  description: l10n.noFoodsAvailableDescription,
                );
              }

              return Column(
                children: [
                  SwitchListTile(
                    value: _allowMultipleFoods,
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.multipleFoodsTitle),
                    subtitle: Text(l10n.multipleFoodsDescription),
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
                                                        l10n.unknownBrand,
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
                                                food.brand ?? l10n.unknownBrand,
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
                : _planningForGroup
                ? (groupPreview == null || selectedGroup == null
                      ? null
                      : () => _saveGroupPlan(selectedGroup))
                : (individualPreview == null || selectedCat == null
                      ? null
                      : () => _saveIndividualPlan(selectedCat)),
            icon: _isSaving
                ? const SizedBox.shrink()
                : const Icon(Icons.save_rounded),
            label: _isSaving
                ? AppLoadingState(compact: true, label: l10n.savingLabel)
                : Text(
                    _planningForGroup
                        ? l10n.saveGroupPlanAction
                        : l10n.savePlanAction,
                  ),
          ),
        ],
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

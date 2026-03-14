import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/core/widgets/app_loading_state.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_group.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_groups_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/cat_profiles_provider.dart';
import 'package:cat_diet_planner/features/cat_profile/providers/selected_cat_provider.dart';
import 'package:cat_diet_planner/features/plans/services/diet_calculator_service.dart';
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
  late final TextEditingController _groupKcalController;

  @override
  void initState() {
    super.initState();
    _groupKcalController = TextEditingController(text: '220');
  }

  @override
  void dispose() {
    _groupKcalController.dispose();
    super.dispose();
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

  FoodItem? _findFoodByKey(dynamic key) {
    if (key == null) return null;
    for (final food in HiveService.foodsBox.values) {
      if (food.key == key) return food;
    }
    return null;
  }

  void _hydratePlanForCat(String catId) {
    final existingPlan = HiveService.dietPlansBox.get(catId);
    _hydratedCatId = catId;
    _selectedFood = existingPlan == null
        ? null
        : _findFoodByKey(existingPlan.foodKey);
    _mealsPerDay = existingPlan?.mealsPerDay ?? 4;
    setState(() {});
  }

  void _hydratePlanForGroup(String groupId) {
    final existingPlan = HiveService.groupDietPlansBox.get(groupId);
    _hydratedGroupId = groupId;
    _selectedFood = existingPlan == null
        ? null
        : _findFoodByKey(existingPlan.foodKey);
    _mealsPerDay = existingPlan?.mealsPerDay ?? 4;
    _groupKcalController.text = existingPlan == null
        ? '220'
        : existingPlan.targetKcalPerCatPerDay.toStringAsFixed(0);
    setState(() {});
  }

  Future<void> _saveIndividualPlan(CatProfile cat) async {
    final food = _selectedFood;
    if (food == null) return;
    setState(() => _isSaving = true);

    try {
      DietCalculatorService.validateInputs(
        weightKg: cat.weight,
        ageMonths: cat.age,
        kcalPer100g: food.kcalPer100g,
        mealsPerDay: _mealsPerDay,
      );

      final targetKcalPerDay = DietCalculatorService.calculateMer(
        weightKg: cat.weight,
        ageMonths: cat.age,
        neutered: cat.neutered,
        activityLevel: cat.activityLevel,
        goal: cat.goal,
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

      final plan = DietPlan(
        catId: cat.id,
        foodKey: food.key,
        foodName: food.name,
        targetKcalPerDay: targetKcalPerDay,
        portionGramsPerDay: dailyPortionGrams,
        mealsPerDay: _mealsPerDay,
        portionGramsPerMeal: perMealGrams,
        createdAt: DateTime.now(),
        goal: cat.goal,
      );

      await HiveService.dietPlansBox.put(cat.id, plan);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Plan saved for ${cat.name}')));
      setState(() => _hydratedCatId = cat.id);
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
    final food = _selectedFood;
    if (food == null) return;

    final targetPerCat = double.tryParse(_groupKcalController.text.trim());
    if (targetPerCat == null || targetPerCat <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid kcal target per cat.')),
      );
      return;
    }
    setState(() => _isSaving = true);

    try {
      final portionPerCat = DietCalculatorService.calculateDailyPortionGrams(
        targetKcal: targetPerCat,
        kcalPer100g: food.kcalPer100g,
      );
      final totalKcal = targetPerCat * group.catCount;
      final totalPortion = portionPerCat * group.catCount;
      final portionPerGroupMeal =
          DietCalculatorService.calculatePortionPerMealGrams(
            portionPerDayGrams: totalPortion,
            mealsPerDay: _mealsPerDay,
          );

      final plan = GroupDietPlan(
        groupId: group.id,
        foodKey: food.key,
        foodName: food.name,
        catCount: group.catCount,
        targetKcalPerCatPerDay: targetPerCat,
        targetKcalPerGroupPerDay: totalKcal,
        portionGramsPerCatPerDay: portionPerCat,
        portionGramsPerGroupPerDay: totalPortion,
        mealsPerDay: _mealsPerDay,
        portionGramsPerGroupPerMeal: portionPerGroupMeal,
        createdAt: DateTime.now(),
      );

      await HiveService.groupDietPlansBox.put(group.id, plan);

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
        _hydratePlanForCat(selectedCat.id);
      });
    }

    if (_planningForGroup &&
        selectedGroup != null &&
        _hydratedGroupId != selectedGroup.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hydratePlanForGroup(selectedGroup.id);
      });
    }

    final showIndividualEmpty = !_planningForGroup && cats.isEmpty;
    final showGroupEmpty = _planningForGroup && groups.isEmpty;
    final canPreviewIndividual =
        !_planningForGroup && selectedCat != null && _selectedFood != null;
    final canPreviewGroup =
        _planningForGroup &&
        selectedGroup != null &&
        _selectedFood != null &&
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
                      onSelected: (_) => setState(() => _mealsPerDay = meals),
                    );
                  }),
                ),
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
              valueListenable: HiveService.dietPlansBox.listenable(
                keys: [selectedCat.id],
              ),
              builder: (context, Box<DietPlan> box, _) {
                final plan = box.get(selectedCat.id);
                if (plan == null) return const SizedBox.shrink();

                return _SavedPlanCard(
                  title: 'Saved Individual Plan',
                  metrics: [
                    _PlanMetric(label: 'Food', value: plan.foodName),
                    _PlanMetric(
                      label: 'Daily Goal',
                      value: '${plan.targetKcalPerDay.toStringAsFixed(0)} kcal',
                    ),
                    _PlanMetric(
                      label: 'Per Day',
                      value: '${plan.portionGramsPerDay.toStringAsFixed(1)} g',
                    ),
                    _PlanMetric(
                      label: 'Per Meal',
                      value: '${plan.portionGramsPerMeal.toStringAsFixed(1)} g',
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
              valueListenable: HiveService.groupDietPlansBox.listenable(
                keys: [selectedGroup.id],
              ),
              builder: (context, Box<GroupDietPlan> box, _) {
                final plan = box.get(selectedGroup.id);
                if (plan == null) return const SizedBox.shrink();

                return _SavedPlanCard(
                  title: 'Saved Group Plan',
                  metrics: [
                    _PlanMetric(label: 'Food', value: plan.foodName),
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
            ),
          ],
          if (canPreviewGroup) ...[
            const SizedBox(height: 16),
            _GroupPlanSummaryCard(
              group: selectedGroup,
              food: _selectedFood!,
              mealsPerDay: _mealsPerDay,
              targetKcalPerCat: double.parse(_groupKcalController.text.trim()),
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
            valueListenable: HiveService.foodsBox.listenable(),
            builder: (context, Box<FoodItem> box, _) {
              final foods = box.values.toList();

              if (foods.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.pets_rounded,
                  title: 'No foods available',
                  description:
                      'Add foods in Food Database before creating a plan.',
                );
              }

              return Column(
                children: foods.map((food) {
                  final selected = _selectedFood?.key == food.key;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => setState(() => _selectedFood = food),
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
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              food.brand ?? 'Unknown brand',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(color: secondary),
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
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _isSaving
                ? null
                : _selectedFood == null
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
  });

  final CatProfile cat;
  final FoodItem food;
  final int mealsPerDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);
    final targetKcal = DietCalculatorService.calculateMer(
      weightKg: cat.weight,
      ageMonths: cat.age,
      neutered: cat.neutered,
      activityLevel: cat.activityLevel,
      goal: cat.goal,
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
              _PlanMetric(label: 'Goal', value: cat.goal),
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
  });

  final CatGroup group;
  final FoodItem food;
  final int mealsPerDay;
  final double targetKcalPerCat;

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

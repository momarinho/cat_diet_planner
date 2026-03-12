import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/cat_profile.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
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
  String? _hydratedCatId;
  int _mealsPerDay = 4;

  CatProfile? _findCatById(List<CatProfile> cats, String? id) {
    if (id == null) return null;
    for (final cat in cats) {
      if (cat.id == id) return cat;
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

  Future<void> _savePlan(CatProfile cat) async {
    final food = _selectedFood;
    if (food == null) return;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(catProfilesProvider);
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

    if (selectedCat != null && _hydratedCatId != selectedCat.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hydratePlanForCat(selectedCat.id);
      });
    }

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
          if (cats.isEmpty)
            _EmptyPlanState(primary: primary, secondary: secondary),
          if (cats.isNotEmpty && selectedCat != null) ...[
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
                  DropdownButtonFormField<String>(
                    initialValue: selectedCat.id,
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
                    onChanged: (value) {
                      if (value == null) return;
                      final nextCat = _findCatById(cats, value);
                      if (nextCat == null) return;
                      ref.read(selectedCatProvider.notifier).state = nextCat;
                      setState(() {
                        _selectedCatId = value;
                        _hydratedCatId = null;
                      });
                    },
                  ),
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
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: HiveService.dietPlansBox.listenable(
                keys: [selectedCat.id],
              ),
              builder: (context, Box<DietPlan> box, _) {
                final plan = box.get(selectedCat.id);
                if (plan == null) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _SectionCard(
                    primary: primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Plan',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _PlanMetric(label: 'Food', value: plan.foodName),
                            _PlanMetric(
                              label: 'Daily Goal',
                              value:
                                  '${plan.targetKcalPerDay.toStringAsFixed(0)} kcal',
                            ),
                            _PlanMetric(
                              label: 'Per Day',
                              value:
                                  '${plan.portionGramsPerDay.toStringAsFixed(1)} g',
                            ),
                            _PlanMetric(
                              label: 'Per Meal',
                              value:
                                  '${plan.portionGramsPerMeal.toStringAsFixed(1)} g',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          if (_selectedFood != null && selectedCat != null)
            _PlanSummaryCard(
              cat: selectedCat,
              food: _selectedFood!,
              mealsPerDay: _mealsPerDay,
            ),
          if (_selectedFood != null && selectedCat != null)
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
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: primary.withValues(alpha: 0.10)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.pets_rounded, size: 42, color: primary),
                      const SizedBox(height: 12),
                      Text(
                        'No foods available',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add foods in Food Database before creating a plan.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: secondary,
                        ),
                      ),
                    ],
                  ),
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
                      child: Container(
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
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: primary.withValues(alpha: 0.10),
                              child: Icon(Icons.pets_rounded, color: primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    food.brand ?? 'Unknown brand',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${food.kcalPer100g.toStringAsFixed(0)} kcal',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          if (selectedCat != null) ...[
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _selectedFood == null
                  ? null
                  : () => _savePlan(selectedCat),
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Plan'),
            ),
          ],
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

class _PlanSummaryCard extends StatelessWidget {
  const _PlanSummaryCard({
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
  const _EmptyPlanState({required this.primary, required this.secondary});

  final Color primary;
  final Color secondary;

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
            'No cat profiles available',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create a cat profile before building a meal plan.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: secondary),
          ),
        ],
      ),
    );
  }
}

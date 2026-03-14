import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/diet_plan.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/models/group_diet_plan.dart';
import 'package:cat_diet_planner/features/food_database/screens/add_food_screen.dart';
import 'package:cat_diet_planner/features/food_database/widgets/food_card.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FoodDatabaseScreen extends StatefulWidget {
  const FoodDatabaseScreen({super.key});

  @override
  State<FoodDatabaseScreen> createState() => _FoodDatabaseScreenState();
}

class _FoodDatabaseScreenState extends State<FoodDatabaseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesQuery(FoodItem food, String query) {
    if (query.isEmpty) return true;

    final q = query.toLowerCase().trim();
    return food.name.toLowerCase().contains(q) ||
        (food.brand?.toLowerCase().contains(q) ?? false) ||
        (food.barcode?.toLowerCase().contains(q) ?? false) ||
        (food.category?.toLowerCase().contains(q) ?? false) ||
        (food.manufacturer?.toLowerCase().contains(q) ?? false) ||
        (food.productLine?.toLowerCase().contains(q) ?? false) ||
        (food.flavor?.toLowerCase().contains(q) ?? false) ||
        (food.texture?.toLowerCase().contains(q) ?? false) ||
        (food.packageSize?.toLowerCase().contains(q) ?? false) ||
        (food.servingUnit?.toLowerCase().contains(q) ?? false) ||
        food.userTags.any((tag) => tag.toLowerCase().contains(q));
  }

  List<FoodItem> _buildRecentFoods(Box<FoodItem> box) {
    final recentKeys = box.keys.toList().reversed.take(4).toList();
    return recentKeys.map((key) => box.get(key)).whereType<FoodItem>().toList();
  }

  List<FoodItem> _buildPopularFoods(List<FoodItem> foods) {
    final usage = <dynamic, int>{};

    for (final DietPlan plan in HiveService.dietPlansBox.values) {
      usage.update(plan.foodKey, (count) => count + 1, ifAbsent: () => 1);
    }

    for (final GroupDietPlan plan in HiveService.groupDietPlansBox.values) {
      usage.update(plan.foodKey, (count) => count + 1, ifAbsent: () => 1);
    }

    final ranked = [...foods]
      ..sort((a, b) {
        final bCount = usage[b.key] ?? 0;
        final aCount = usage[a.key] ?? 0;
        if (bCount != aCount) return bCount.compareTo(aCount);
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    return ranked.where((food) => (usage[food.key] ?? 0) > 0).take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Database'),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: (value) => setState(() => _query = value),
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: 'Search by name, brand, category, tags, barcode...',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 380;
              final scanButton = OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.scanner),
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: const Text('Scan Barcode'),
              );
              final addButton = FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddFoodScreen()),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Manually'),
              );

              if (narrow) {
                return Column(
                  children: [
                    SizedBox(width: double.infinity, child: scanButton),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, child: addButton),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: scanButton),
                  const SizedBox(width: 12),
                  Expanded(child: addButton),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: HiveService.foodsBox.listenable(),
            builder: (context, Box<FoodItem> box, _) {
              final foods = box.values.toList();
              final filteredFoods = foods
                  .where((food) => _matchesQuery(food, _query))
                  .toList();
              final recentFoods = _buildRecentFoods(box);
              final popularFoods = _buildPopularFoods(foods);

              if (foods.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.pets_rounded,
                  title: 'No foods yet',
                  description:
                      'Foods added manually or confirmed in the scanner will appear here.',
                );
              }

              if (filteredFoods.isEmpty) {
                return const AppEmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No matches found',
                  description: 'Try a different name, brand, or barcode.',
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_query.isEmpty && recentFoods.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Recently Added',
                      subtitle: 'Newest foods in your local database',
                    ),
                    const SizedBox(height: 12),
                    ...recentFoods.map((food) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FoodCard(food: food),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                  if (_query.isEmpty && popularFoods.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Popular in Plans',
                      subtitle: 'Foods already being reused in saved plans',
                    ),
                    const SizedBox(height: 12),
                    ...popularFoods.map((food) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FoodCard(food: food),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                  _SectionHeader(
                    title: _query.isEmpty ? 'All Foods' : 'Search Results',
                    subtitle: _query.isEmpty
                        ? '${filteredFoods.length} item(s) available locally'
                        : '${filteredFoods.length} item(s) matched "${_query.trim()}"',
                  ),
                  const SizedBox(height: 12),
                  ...filteredFoods.map((food) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FoodCard(food: food),
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFF7A7678);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

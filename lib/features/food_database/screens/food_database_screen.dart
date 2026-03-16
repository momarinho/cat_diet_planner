import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/core/widgets/app_empty_state.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/food_database/providers/food_repository_provider.dart';
import 'package:cat_diet_planner/features/food_database/screens/add_food_screen.dart';
import 'package:cat_diet_planner/features/food_database/widgets/food_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FoodDatabaseScreen extends ConsumerStatefulWidget {
  const FoodDatabaseScreen({super.key});

  @override
  ConsumerState<FoodDatabaseScreen> createState() => _FoodDatabaseScreenState();
}

class _FoodDatabaseScreenState extends ConsumerState<FoodDatabaseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repository = ref.read(foodRepositoryProvider);

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
            valueListenable: repository.foodsListenable(),
            builder: (context, Box<FoodItem> box, _) {
              final foods = repository.getFoodsFromBox(box);
              final filteredFoods = foods
                  .where((food) => repository.matchesQuery(food, _query))
                  .toList();
              final recentFoods = repository.buildRecentFoods(box);
              final popularFoods = repository.buildPopularFoods(foods);

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
                        child: FoodCard(
                          food: food,
                          onEdit: () => _openFoodEditor(food),
                        ),
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
                        child: FoodCard(
                          food: food,
                          onEdit: () => _openFoodEditor(food),
                        ),
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
                      child: FoodCard(
                        food: food,
                        onEdit: () => _openFoodEditor(food),
                      ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFoodEditor(FoodItem food) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => AddFoodScreen(initialFood: food)));
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

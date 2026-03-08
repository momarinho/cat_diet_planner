import 'package:cat_diet_planner/core/navigation/app_routes.dart';
import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
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
        (food.barcode?.toLowerCase().contains(q) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        const Color(0xFF7A7678);

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
              hintText: 'Search by name, brand, or barcode',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.scanner),
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan Barcode'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddFoodScreen()),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Manually'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: HiveService.foodsBox.listenable(),
            builder: (context, Box<FoodItem> box, _) {
              final foods = box.values.toList();
              final filteredFoods = foods
                  .where((food) => _matchesQuery(food, _query))
                  .toList();

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
                        'No foods yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Foods added manually or confirmed in the scanner will appear here.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: secondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (filteredFoods.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: primary.withValues(alpha: 0.10)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 42, color: primary),
                      const SizedBox(height: 12),
                      Text(
                        'No matches found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try a different name, brand, or barcode.',
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
                children: filteredFoods.map((food) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FoodCard(food: food),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

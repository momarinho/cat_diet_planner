import 'package:cat_diet_planner/data/hive_service/hive_service.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/food_database/widgets/food_card.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class FoodDatabaseScreen extends StatelessWidget {
  const FoodDatabaseScreen({super.key});

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
            decoration: InputDecoration(
              hintText: 'Search by brand, type or barcode',
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
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan Barcode'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
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

              return Column(
                children: foods.map((food) {
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

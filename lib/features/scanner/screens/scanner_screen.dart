import 'package:cat_diet_planner/features/food_database/screens/add_food_screen.dart';
import 'package:cat_diet_planner/features/scanner/services/scanner_product_service.dart';
import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  Future<void> _confirmProduct(BuildContext context) async {
    final result = await ScannerProductService.lookupMockProduct();

    if (!context.mounted) return;

    if (result.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food already exists in database')),
      );
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddFoodScreen(initialBarcode: result.barcode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.75),
        elevation: 0,
        title: const Text('Scanner'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF101010)),
          Center(
            child: Container(
              width: 260,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primary, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 150,
            child: Text(
              'Align barcode within frame',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primary.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pets_rounded, color: primary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Wellness Core Wet',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddFoodScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_note_rounded),
                          label: const Text('Manual Entry'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _confirmProduct(context),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Confirm Product'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

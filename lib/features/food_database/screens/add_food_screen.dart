import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/features/food_database/providers/food_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFoodScreen extends ConsumerStatefulWidget {
  final String? initialBarcode;

  const AddFoodScreen({super.key, this.initialBarcode});

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  static const _categories = [
    'seca',
    'umida',
    'natural',
    'petisco',
    'suplemento',
  ];
  static const _servingUnits = ['g', 'lata', 'sache', 'xicara', 'colher'];

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _lineController = TextEditingController();
  final _flavorController = TextEditingController();
  final _textureController = TextEditingController();
  final _packageSizeController = TextEditingController();
  final _kcalController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _fiberController = TextEditingController();
  final _moistureController = TextEditingController();
  final _carbohydrateController = TextEditingController();
  final _sodiumController = TextEditingController();
  final _palatabilityController = TextEditingController();
  final _tagsController = TextEditingController();
  String? _selectedCategory;
  String _selectedServingUnit = 'g';

  @override
  void initState() {
    super.initState();
    _barcodeController.text = widget.initialBarcode ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _manufacturerController.dispose();
    _lineController.dispose();
    _flavorController.dispose();
    _textureController.dispose();
    _packageSizeController.dispose();
    _kcalController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _moistureController.dispose();
    _carbohydrateController.dispose();
    _sodiumController.dispose();
    _palatabilityController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  double? _optionalDouble(TextEditingController controller) {
    final raw = controller.text.trim();
    if (raw.isEmpty) return null;
    return double.tryParse(raw.replaceAll(',', '.'));
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate()) return;

    final food = FoodItem(
      name: _nameController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      kcalPer100g: double.parse(_kcalController.text.trim()),
      protein: _optionalDouble(_proteinController),
      fat: _optionalDouble(_fatController),
      category: _selectedCategory,
      manufacturer: _manufacturerController.text.trim().isEmpty
          ? null
          : _manufacturerController.text.trim(),
      productLine: _lineController.text.trim().isEmpty
          ? null
          : _lineController.text.trim(),
      flavor: _flavorController.text.trim().isEmpty
          ? null
          : _flavorController.text.trim(),
      texture: _textureController.text.trim().isEmpty
          ? null
          : _textureController.text.trim(),
      packageSize: _packageSizeController.text.trim().isEmpty
          ? null
          : _packageSizeController.text.trim(),
      servingUnit: _selectedServingUnit,
      fiber: _optionalDouble(_fiberController),
      moisture: _optionalDouble(_moistureController),
      carbohydrate: _optionalDouble(_carbohydrateController),
      sodium: _optionalDouble(_sodiumController),
      palatabilityNotes: _palatabilityController.text.trim().isEmpty
          ? null
          : _palatabilityController.text.trim(),
      userTags: _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(growable: false),
    );

    await ref.read(foodRepositoryProvider).addFood(food);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Food name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter the food name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Brand (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _manufacturerController,
              decoration: const InputDecoration(
                labelText: 'Manufacturer (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lineController,
              decoration: const InputDecoration(
                labelText: 'Line (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _flavorController,
              decoration: const InputDecoration(
                labelText: 'Flavor (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _textureController,
              decoration: const InputDecoration(
                labelText: 'Texture (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _packageSizeController,
              decoration: const InputDecoration(
                labelText: 'Package size (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedServingUnit,
              decoration: const InputDecoration(
                labelText: 'Serving unit',
                border: OutlineInputBorder(),
              ),
              items: _servingUnits
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedServingUnit = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: 'Barcode (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _kcalController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'kcal per 100g',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter kcal per 100g';
                }

                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid kcal value';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _proteinController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Protein % (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fatController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Fat % (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fiberController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Fiber % (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _moistureController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Moisture % (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _carbohydrateController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Carbohydrate % (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sodiumController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Sodium mg/100g (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _palatabilityController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Palatability notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Custom tags (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _saveFood, child: const Text('Save Food')),
          ],
        ),
      ),
    );
  }
}

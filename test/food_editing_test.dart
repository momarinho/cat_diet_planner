import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/repositories/food_repository.dart';
import 'package:cat_diet_planner/features/food_database/providers/food_repository_provider.dart';
import 'package:cat_diet_planner/features/food_database/screens/add_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/hive_test_helper.dart';

void main() {
  group('food editing', () {
    testWidgets('edit screen pre-fills visible fields for an existing food', (
      tester,
    ) async {
      final food = FoodItem(
        name: 'Dry Food',
        brand: 'Brand A',
        barcode: '123456',
        kcalPer100g: 380,
        manufacturer: 'ACME',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodRepositoryProvider.overrideWithValue(_FakeFoodRepository()),
          ],
          child: MaterialApp(home: AddFoodScreen(initialFood: food)),
        ),
      );

      final manufacturerField = _textFieldWithValue('ACME');

      expect(find.text('Edit Food'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Dry Food'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Brand A'), findsOneWidget);
      expect(
        tester.widget<TextFormField>(manufacturerField).controller!.text,
        'ACME',
      );
    });

    test(
      'repository saveFood updates an existing record instead of duplicating',
      () async {
        await HiveTestHelper.init();
        addTearDown(HiveTestHelper.dispose);

        final repository = FoodRepository();
        await repository.addFood(
          FoodItem(
            name: 'Dry Food',
            brand: 'Brand A',
            barcode: '123456',
            kcalPer100g: 380,
            sodium: 120,
          ),
        );

        final existingFood = repository.getAllFoods().single;

        await repository.saveFood(
          FoodItem(
            name: 'Dry Food',
            brand: 'Brand A',
            barcode: '123456',
            kcalPer100g: 380,
            sodium: 155,
          ),
          existingKey: existingFood.key,
        );

        final foods = repository.getAllFoods();
        expect(foods, hasLength(1));
        expect(foods.single.name, 'Dry Food');
        expect(foods.single.sodium, 155);
      },
    );
  });
}

class _FakeFoodRepository extends FoodRepository {
  FoodItem? savedFood;

  @override
  Future<void> saveFood(FoodItem food, {dynamic existingKey}) async {
    savedFood = food;
  }
}

Finder _textFieldWithValue(String value) {
  return find.byWidgetPredicate(
    (widget) => widget is TextFormField && widget.controller?.text == value,
    description: 'TextFormField with controller value "$value"',
  );
}

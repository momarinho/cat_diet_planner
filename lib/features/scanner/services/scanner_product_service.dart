import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';

class ScannerLookupResult {
  final bool exists;
  final String barcode;
  final FoodItem? food;

  const ScannerLookupResult({
    required this.exists,
    required this.barcode,
    this.food,
  });
}

class ScannerProductService {
  static Future<ScannerLookupResult> lookupByBarcode(String barcode) async {
    final normalizedBarcode = barcode.trim();
    final foods = HiveService.foodsBox.values.toList();

    for (final food in foods) {
      if (food.barcode == normalizedBarcode) {
        return ScannerLookupResult(
          exists: true,
          barcode: normalizedBarcode,
          food: food,
        );
      }
    }

    return ScannerLookupResult(exists: false, barcode: normalizedBarcode);
  }

  static Future<ScannerLookupResult> lookupMockProduct() async {
    return lookupByBarcode('123456789');
  }
}

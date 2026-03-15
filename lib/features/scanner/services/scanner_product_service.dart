import 'package:cat_diet_planner/data/models/food_item.dart';
import 'package:cat_diet_planner/data/repositories/food_repository.dart';

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
    final food = FoodRepository().findByBarcode(normalizedBarcode);
    if (food != null) {
      return ScannerLookupResult(
        exists: true,
        barcode: normalizedBarcode,
        food: food,
      );
    }

    return ScannerLookupResult(exists: false, barcode: normalizedBarcode);
  }
}

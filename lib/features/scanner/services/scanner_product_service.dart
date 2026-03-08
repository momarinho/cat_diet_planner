import 'package:cat_diet_planner/data/local/hive_service.dart';
import 'package:cat_diet_planner/data/models/food_item.dart';

class ScannerLookupResult {
  final bool exists;
  final String barcode;

  const ScannerLookupResult({required this.exists, required this.barcode});
}

class ScannerProductService {
  static Future<ScannerLookupResult> lookupMockProduct() async {
    const barcode = '123456789';
    final foods = HiveService.foodsBox.values.toList();

    for (final food in foods) {
      if (food.barcode == barcode) {
        return ScannerLookupResult(exists: true, barcode: barcode);
      }
    }

    return const ScannerLookupResult(exists: false, barcode: barcode);
  }
}

/*
 * PortionUnitService
 *
 * Helper utilities to convert between common portion units and grams.
 *
 * Responsibilities:
 * - Provide a default mapping between user-facing portion units (e.g. 'can',
 *   'sachet', 'scoop', 'g') and their gram equivalents.
 * - Convert unit counts -> grams and grams -> unit counts.
 * - Allow callers to provide override mappings (for custom unit sizes).
 * - Provide formatting helpers for display.
 *
 * Usage examples:
 *   final grams = PortionUnitService.convertUnitsToGrams(units: 2, unit: 'can');
 *   final cans = PortionUnitService.convertGramsToUnits(grams: 170, unit: 'can');
 *   final formatted = PortionUnitService.formatPortion(amount: 1.5, unit: 'scoop');
 *
 * Notes:
 * - All unit identifiers are treated case-insensitively.
 * - By default 'g' is 1.0 (grams), so converting grams -> g returns the same value.
 * - If a unit is not known, you may pass an `overrides` map where the key is the
 *   unit string and the value is grams-per-unit.
 */

class PortionUnitService {
  // Default gram equivalents for common portion units.
  // These are sensible defaults that can be overridden by callers.
  static const Map<String, double> _defaultUnitToGrams = <String, double>{
    'g': 1.0, // gram
    'gram': 1.0,
    'can': 85.0, // typical small wet-food can for cats (approx. 85 g)
    'sachet': 100.0, // wet pouch
    'pouch': 100.0,
    'scoop': 10.0, // approximate scoop size in grams (user can override)
    'cup': 240.0, // kitchen cup in grams — approximate and depends on food
    'tbsp': 15.0, // tablespoon
    'tsp': 5.0, // teaspoon
  };

  /// Returns the merged unit -> grams mapping using defaults plus optional overrides.
  /// Overrides' keys are treated case-insensitively.
  static Map<String, double> getUnitMap({Map<String, double>? overrides}) {
    if (overrides == null || overrides.isEmpty) {
      return Map<String, double>.unmodifiable(_defaultUnitToGrams);
    }

    final out = <String, double>{};
    // copy defaults first
    _defaultUnitToGrams.forEach((k, v) => out[k.toLowerCase()] = v);
    // apply overrides (lowercase keys)
    overrides.forEach((k, v) {
      if (k.trim().isEmpty) return;
      out[k.toLowerCase()] = v;
    });
    return Map<String, double>.unmodifiable(out);
  }

  /// Returns grams per single [unit].
  ///
  /// - [unit] is case-insensitive.
  /// - If the unit is missing from defaults, [overrides] may provide a mapping.
  /// - Throws [ArgumentError] if unit is unknown and no override exists.
  static double gramsPerUnit(String unit, {Map<String, double>? overrides}) {
    final key = unit.trim().toLowerCase();
    final map = getUnitMap(overrides: overrides);
    final value = map[key];
    if (value == null) {
      throw ArgumentError(
        'Unknown portion unit `$unit`. Provide an override if needed.',
      );
    }
    return value;
  }

  /// Convert [units] of [unit] into grams using optional [overrides].
  ///
  /// Example: convertUnitsToGrams(units: 2, unit: 'can') -> 170.0 (if can=85g)
  static double convertUnitsToGrams({
    required double units,
    required String unit,
    Map<String, double>? overrides,
  }) {
    final perUnit = gramsPerUnit(unit, overrides: overrides);
    return units * perUnit;
  }

  /// Convert [grams] into the equivalent number of [unit] using optional [overrides].
  ///
  /// Example: convertGramsToUnits(grams: 170, unit: 'can') -> 2.0 (if can=85g)
  static double convertGramsToUnits({
    required double grams,
    required String unit,
    Map<String, double>? overrides,
  }) {
    final perUnit = gramsPerUnit(unit, overrides: overrides);
    if (perUnit == 0) {
      throw ArgumentError('Unit `$unit` has a zero gram equivalent.');
    }
    return grams / perUnit;
  }

  /// Formats a portion amount with unit for display.
  ///
  /// Small heuristics:
  /// - for 'g' shows integer grams (e.g. "120 g")
  /// - for other units shows 1 decimal if not whole (e.g. "1.5 can")
  static String formatPortion({
    required double amount,
    required String unit,
    int decimalsForNonGram = 1,
  }) {
    final u = unit.trim();
    if (u.toLowerCase() == 'g' || u.toLowerCase() == 'gram') {
      // grams typically displayed as whole numbers
      return '${amount.round()} g';
    }

    final isWhole = amount == amount.roundToDouble();
    if (isWhole) {
      return '${amount.toStringAsFixed(0)} $u';
    }
    return '${amount.toStringAsFixed(decimalsForNonGram)} $u';
  }

  /// Convenience: compute per-food portions for multiple foods where each food has
  /// a relative share (weights sum to 1.0). The input is:
  ///  - [totalGrams] total grams to split
  ///  - [shares] map foodKey -> share (share values should sum to ~1.0)
  /// Returns a new map foodKey -> grams assigned.
  ///
  /// If shares are empty or do not sum to > 0, the function will distribute equally.
  static Map<dynamic, double> splitGramsByShare({
    required double totalGrams,
    required Map<dynamic, double> shares,
  }) {
    if (totalGrams <= 0) return {};
    if (shares.isEmpty) {
      return {};
    }

    final positiveShares = <dynamic, double>{};
    double total = 0.0;
    shares.forEach((k, v) {
      final val = v.isNaN ? 0.0 : (v < 0 ? 0.0 : v);
      if (val > 0) {
        positiveShares[k] = val;
        total += val;
      }
    });

    if (positiveShares.isEmpty) {
      // fallback to equal distribution among keys
      final per = totalGrams / shares.length;
      return {for (final k in shares.keys) k: per};
    }

    // normalize and split
    final out = <dynamic, double>{};
    positiveShares.forEach((k, v) {
      final share = v / total;
      out[k] = share * totalGrams;
    });
    return out;
  }

  /// Returns a list of supported unit identifiers (from defaults plus optional overrides).
  static List<String> supportedUnits({Map<String, double>? overrides}) {
    return getUnitMap(overrides: overrides).keys.toList();
  }
}

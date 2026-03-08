class DietCalculatorService {
  static double calculateDailyPortionGrams({
    required double targetKcal,
    required double kcalPer100g,
  }) {
    return (targetKcal * 100) / kcalPer100g;
  }
}

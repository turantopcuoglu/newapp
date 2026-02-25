import '../core/enums.dart';

class NutritionSummary {
  final DateTime startDate;
  final DateTime endDate;
  final int totalMeals;
  final Map<MealType, int> mealTypeDistribution;
  final Map<NutrientLevel, int> proteinDistribution;
  final Map<NutrientLevel, int> fiberDistribution;
  final Map<CarbType, int> carbTypeDistribution;
  final Map<String, int> ingredientFrequency;
  final int avgCalories;

  const NutritionSummary({
    required this.startDate,
    required this.endDate,
    this.totalMeals = 0,
    this.mealTypeDistribution = const {},
    this.proteinDistribution = const {},
    this.fiberDistribution = const {},
    this.carbTypeDistribution = const {},
    this.ingredientFrequency = const {},
    this.avgCalories = 0,
  });
}

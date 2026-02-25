import '../core/enums.dart';
import '../models/daily_summary.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';

class SummaryService {
  NutritionSummary generateSummary({
    required List<MealPlanEntry> entries,
    required Map<String, Recipe> recipeMap,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Filter entries within date range
    final filtered = entries.where((e) =>
        !e.date.isBefore(startDate) &&
        !e.date.isAfter(endDate.add(const Duration(days: 1))));

    final mealTypeDist = <MealType, int>{};
    final proteinDist = <NutrientLevel, int>{};
    final fiberDist = <NutrientLevel, int>{};
    final carbDist = <CarbType, int>{};
    final ingredientFreq = <String, int>{};
    int totalCalories = 0;
    int mealCount = 0;

    for (final entry in filtered) {
      final recipe = recipeMap[entry.recipeId];
      if (recipe == null) continue;

      mealCount++;

      // Meal type distribution
      mealTypeDist[entry.mealType] =
          (mealTypeDist[entry.mealType] ?? 0) + 1;

      // Protein distribution
      proteinDist[recipe.proteinLevel] =
          (proteinDist[recipe.proteinLevel] ?? 0) + 1;

      // Fiber distribution
      fiberDist[recipe.fiberLevel] =
          (fiberDist[recipe.fiberLevel] ?? 0) + 1;

      // Carb distribution
      carbDist[recipe.carbType] = (carbDist[recipe.carbType] ?? 0) + 1;

      // Ingredient frequency
      for (final id in recipe.ingredientIds) {
        ingredientFreq[id] = (ingredientFreq[id] ?? 0) + 1;
      }

      totalCalories += recipe.macros.calories;
    }

    // Sort ingredient frequency, keep top 10
    final sortedIngredients = ingredientFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topIngredients = Map.fromEntries(sortedIngredients.take(10));

    return NutritionSummary(
      startDate: startDate,
      endDate: endDate,
      totalMeals: mealCount,
      mealTypeDistribution: mealTypeDist,
      proteinDistribution: proteinDist,
      fiberDistribution: fiberDist,
      carbTypeDistribution: carbDist,
      ingredientFrequency: topIngredients,
      avgCalories: mealCount > 0 ? totalCalories ~/ mealCount : 0,
    );
  }

  NutritionSummary dailySummary({
    required List<MealPlanEntry> entries,
    required Map<String, Recipe> recipeMap,
    required DateTime date,
  }) =>
      generateSummary(
        entries: entries,
        recipeMap: recipeMap,
        startDate: DateTime(date.year, date.month, date.day),
        endDate: DateTime(date.year, date.month, date.day, 23, 59, 59),
      );

  NutritionSummary weeklySummary({
    required List<MealPlanEntry> entries,
    required Map<String, Recipe> recipeMap,
    required DateTime weekStart,
  }) =>
      generateSummary(
        entries: entries,
        recipeMap: recipeMap,
        startDate: weekStart,
        endDate: weekStart.add(const Duration(days: 6)),
      );

  NutritionSummary monthlySummary({
    required List<MealPlanEntry> entries,
    required Map<String, Recipe> recipeMap,
    required int year,
    required int month,
  }) =>
      generateSummary(
        entries: entries,
        recipeMap: recipeMap,
        startDate: DateTime(year, month, 1),
        endDate: DateTime(year, month + 1, 0),
      );
}

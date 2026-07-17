import '../core/enums.dart';
import '../data/ingredient_nutrition_data.dart';
import '../models/recipe.dart';

/// Result of an ingredient-based nutrition computation.
class ComputedNutrition {
  final MacroEstimation macros;

  /// True when the recipe declared explicit ingredient quantities; false when
  /// per-ingredient default serving sizes were used as a fallback.
  final bool fromQuantities;

  /// Ingredient ids that have no entry in [ingredientNutritionData] and were
  /// therefore ignored. Non-empty coverage gaps make the estimate low.
  final List<String> missingNutritionData;

  const ComputedNutrition({
    required this.macros,
    required this.fromQuantities,
    this.missingNutritionData = const [],
  });
}

/// Computes recipe nutrition from ingredient data instead of trusting
/// hand-written totals, so ingredient data stays the single source of truth.
///
/// - With explicit `Recipe.quantities`, units are converted to grams and the
///   per-100 g values are scaled exactly.
/// - Without quantities, each ingredient's `defaultServingG` approximates a
///   typical amount. This keeps an estimate available for legacy recipes and
///   powers the deviation report that flags suspect hand-written values.
class NutritionCalculator {
  /// Grams represented by one unit, for units that don't depend on the
  /// ingredient itself. `piece` is resolved via `defaultServingG`.
  static const Map<QuantityUnit, double> _gramsPerUnit = {
    QuantityUnit.g: 1,
    QuantityUnit.ml: 1, // close enough for kitchen liquids
    QuantityUnit.L: 1000,
    QuantityUnit.tablespoon: 15,
    QuantityUnit.teaspoon: 5,
    QuantityUnit.cup: 240,
    QuantityUnit.slice: 30,
    QuantityUnit.bunch: 100,
    QuantityUnit.pinch: 0.5,
    QuantityUnit.clove: 5,
  };

  /// Nutrition for the whole recipe (all servings).
  ComputedNutrition compute(Recipe recipe) {
    final hasQuantities = recipe.quantities.isNotEmpty;
    final missing = <String>[];
    double calories = 0, protein = 0, carbs = 0, fat = 0, fiber = 0;

    for (final id in recipe.ingredientIds) {
      final nutrition = ingredientNutritionData[id];
      if (nutrition == null) {
        missing.add(id);
        continue;
      }

      final grams = hasQuantities
          ? _toGrams(recipe.quantities[id], nutrition)
          : nutrition.defaultServingG;
      final factor = grams / 100;

      calories += nutrition.caloriesPer100g * factor;
      protein += nutrition.proteinPer100g * factor;
      carbs += nutrition.carbsPer100g * factor;
      fat += nutrition.fatPer100g * factor;
      fiber += nutrition.fiberPer100g * factor;
    }

    return ComputedNutrition(
      macros: MacroEstimation(
        calories: calories.round(),
        proteinG: protein.round(),
        carbsG: carbs.round(),
        fatG: fat.round(),
        fiberG: fiber.round(),
      ),
      fromQuantities: hasQuantities,
      missingNutritionData: missing,
    );
  }

  /// Nutrition for a single serving.
  ComputedNutrition computePerServing(Recipe recipe) {
    final total = compute(recipe);
    final servings = recipe.servings < 1 ? 1 : recipe.servings;
    if (servings == 1) return total;
    return ComputedNutrition(
      macros: MacroEstimation(
        calories: (total.macros.calories / servings).round(),
        proteinG: (total.macros.proteinG / servings).round(),
        carbsG: (total.macros.carbsG / servings).round(),
        fatG: (total.macros.fatG / servings).round(),
        fiberG: (total.macros.fiberG / servings).round(),
      ),
      fromQuantities: total.fromQuantities,
      missingNutritionData: total.missingNutritionData,
    );
  }

  /// Per-serving macros to display and track: ingredient-computed when the
  /// recipe declares quantities (single source of truth), otherwise the
  /// hand-written estimate.
  MacroEstimation effectiveMacros(Recipe recipe) {
    if (recipe.quantities.isEmpty) return recipe.macros;
    return computePerServing(recipe).macros;
  }

  /// Relative deviation between a recipe's hand-written calories and the
  /// ingredient-computed estimate, e.g. 0.25 = 25% apart. Null when either
  /// side is unusable (no manual value, or no computable ingredients).
  double? calorieDeviation(Recipe recipe) {
    final manual = recipe.macros.calories;
    if (manual <= 0) return null;
    final computed = computePerServing(recipe);
    if (computed.macros.calories <= 0 ||
        computed.missingNutritionData.length == recipe.ingredientIds.length) {
      return null;
    }
    return (computed.macros.calories - manual).abs() / manual;
  }

  double _toGrams(IngredientQuantity? quantity, IngredientNutrition nutrition) {
    if (quantity == null) return nutrition.defaultServingG;
    if (quantity.unit == QuantityUnit.piece) {
      return quantity.amount * nutrition.defaultServingG;
    }
    return quantity.amount * (_gramsPerUnit[quantity.unit] ?? 1);
  }
}

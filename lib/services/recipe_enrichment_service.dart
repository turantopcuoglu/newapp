import '../core/enums.dart';
import '../data/ingredient_nutrition_data.dart';
import '../models/recipe.dart';

class RecipeEnrichmentService {
  const RecipeEnrichmentService._();

  static Recipe enrich(
    Recipe recipe, {
    required bool defaultExploreFlag,
  }) {
    final inferredQuantities = _buildQuantities(recipe);
    final macros = _computeMacros(recipe.ingredientIds, inferredQuantities);

    return Recipe(
      id: recipe.id,
      name: recipe.name,
      description: recipe.description,
      mealType: recipe.mealType,
      ingredientIds: recipe.ingredientIds,
      allergenTags: recipe.allergenTags,
      checkInTags: recipe.checkInTags,
      proteinLevel: recipe.proteinLevel,
      fiberLevel: recipe.fiberLevel,
      carbType: recipe.carbType,
      macros: macros,
      steps: recipe.steps,
      imagePath: recipe.imagePath,
      isUserCreated: recipe.isUserCreated,
      quantities: inferredQuantities,
      cuisineId: recipe.cuisineId,
      isExploreRecipe: recipe.isExploreRecipe || defaultExploreFlag,
    );
  }

  static Map<String, IngredientQuantity> _buildQuantities(Recipe recipe) {
    if (recipe.ingredientIds.isEmpty) return const {};

    final seeded = <String, IngredientQuantity>{...recipe.quantities};
    for (final id in recipe.ingredientIds) {
      if (seeded.containsKey(id)) continue;
      seeded[id] = _defaultQuantityForIngredient(id);
    }
    return seeded;
  }

  static IngredientQuantity _defaultQuantityForIngredient(String ingredientId) {
    final nutrition = ingredientNutritionData[ingredientId];
    final amountG = nutrition?.defaultServingG ?? 100;
    final unit = _inferUnit(ingredientId);

    switch (unit) {
      case QuantityUnit.piece:
        final gramsPerPiece = (nutrition?.defaultServingG ?? 60).clamp(30, 120);
        return IngredientQuantity(
          amount: (amountG / gramsPerPiece).clamp(1, 6).toDouble(),
          unit: QuantityUnit.piece,
        );
      case QuantityUnit.L:
        return IngredientQuantity(
          amount: amountG / 1000,
          unit: QuantityUnit.L,
        );
      case QuantityUnit.ml:
        return IngredientQuantity(
          amount: amountG,
          unit: QuantityUnit.ml,
        );
      default:
        return IngredientQuantity(
          amount: amountG,
          unit: QuantityUnit.g,
        );
    }
  }

  static QuantityUnit _inferUnit(String ingredientId) {
    final id = ingredientId.toLowerCase();

    if (id.contains('egg') || id.contains('yumurta')) {
      return QuantityUnit.piece;
    }
    if (id.contains('milk') ||
        id.contains('broth') ||
        id.contains('water') ||
        id.contains('juice')) {
      return QuantityUnit.L;
    }
    if (id.contains('oil') || id.contains('sauce')) {
      return QuantityUnit.ml;
    }
    return QuantityUnit.g;
  }

  static MacroEstimation _computeMacros(
    List<String> ingredientIds,
    Map<String, IngredientQuantity> quantities,
  ) {
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;
    double fiber = 0;

    for (final id in ingredientIds) {
      final nutrition = ingredientNutritionData[id];
      if (nutrition == null) continue;

      final quantity = quantities[id] ?? _defaultQuantityForIngredient(id);
      final grams = _quantityToGrams(quantity, nutrition.defaultServingG);
      final factor = grams / 100;

      calories += nutrition.caloriesPer100g * factor;
      protein += nutrition.proteinPer100g * factor;
      carbs += nutrition.carbsPer100g * factor;
      fat += nutrition.fatPer100g * factor;
      fiber += nutrition.fiberPer100g * factor;
    }

    return MacroEstimation(
      calories: calories.round(),
      proteinG: protein.round(),
      carbsG: carbs.round(),
      fatG: fat.round(),
      fiberG: fiber.round(),
    );
  }

  static double _quantityToGrams(IngredientQuantity quantity, double pieceG) {
    switch (quantity.unit) {
      case QuantityUnit.g:
        return quantity.amount;
      case QuantityUnit.ml:
        return quantity.amount;
      case QuantityUnit.L:
        return quantity.amount * 1000;
      case QuantityUnit.piece:
        return quantity.amount * pieceG;
      case QuantityUnit.tablespoon:
        return quantity.amount * 15;
      case QuantityUnit.teaspoon:
        return quantity.amount * 5;
      case QuantityUnit.cup:
        return quantity.amount * 240;
      case QuantityUnit.bunch:
        return quantity.amount * 50;
      case QuantityUnit.slice:
        return quantity.amount * 30;
      case QuantityUnit.pinch:
        return quantity.amount * 0.5;
      case QuantityUnit.clove:
        return quantity.amount * 5;
    }
  }
}

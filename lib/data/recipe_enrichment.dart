import '../core/enums.dart';
import '../models/recipe.dart';
import 'ingredient_nutrition_data.dart';
import 'ingredient_units.dart';

/// Enriches a recipe with auto-populated quantities and recalculated macros
/// if the recipe doesn't already have quantities set.
Recipe enrichRecipe(Recipe recipe) {
  if (recipe.quantities.isNotEmpty) return recipe;

  final quantities = <String, IngredientQuantity>{};
  for (final id in recipe.ingredientIds) {
    final unit = getDefaultUnit(id);
    final amount = getDefaultAmount(id);
    quantities[id] = IngredientQuantity(amount: amount, unit: unit);
  }

  // Recalculate macros based on quantities
  double cal = 0, prot = 0, carbs = 0, fat = 0, fiber = 0;
  for (final entry in quantities.entries) {
    final nutrition = ingredientNutritionData[entry.key];
    if (nutrition == null) continue;
    final grams = convertToGrams(entry.key, entry.value.amount, entry.value.unit);
    final factor = grams / 100.0;
    cal += nutrition.caloriesPer100g * factor;
    prot += nutrition.proteinPer100g * factor;
    carbs += nutrition.carbsPer100g * factor;
    fat += nutrition.fatPer100g * factor;
    fiber += nutrition.fiberPer100g * factor;
  }

  final macros = MacroEstimation(
    calories: cal.round(),
    proteinG: prot.round(),
    carbsG: carbs.round(),
    fatG: fat.round(),
    fiberG: fiber.round(),
  );

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
    isExplore: recipe.isExplore,
    cuisineType: recipe.cuisineType,
    quantities: quantities,
  );
}

/// Enriches all recipes in a list.
List<Recipe> enrichRecipes(List<Recipe> recipes) =>
    recipes.map(enrichRecipe).toList();

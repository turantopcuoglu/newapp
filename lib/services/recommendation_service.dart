import '../core/enums.dart';
import '../models/recipe.dart';
import '../models/user_profile.dart';

class ScoredRecipe {
  final Recipe recipe;
  final double compatibilityScore;
  final List<String> availableIngredients;
  final List<String> missingIngredients;

  const ScoredRecipe({
    required this.recipe,
    required this.compatibilityScore,
    required this.availableIngredients,
    required this.missingIngredients,
  });

  int get compatibilityPercent => (compatibilityScore * 100).round();
}

class RecommendationService {
  /// Main recommendation algorithm.
  /// Filtering order:
  /// 1. Exclude recipes with allergens or disliked ingredients
  /// 2. Filter by check-in category
  /// 3. Compare with kitchen inventory
  /// 4. Calculate compatibility score
  /// 5. Sort by compatibility, meal type relevance, nutritional balance
  Map<MealType, List<ScoredRecipe>> getRecommendations({
    required List<Recipe> allRecipes,
    required UserProfile profile,
    required CheckInType checkIn,
    required Set<String> inventoryIds,
  }) {
    // Step 1: Exclude allergens and disliked ingredients
    final safeRecipes = allRecipes.where((recipe) {
      // Check allergens
      for (final allergen in recipe.allergenTags) {
        if (profile.allergies
            .any((a) => a.toLowerCase() == allergen.toLowerCase())) {
          return false;
        }
      }
      // Check disliked ingredients
      for (final ingredientId in recipe.ingredientIds) {
        if (profile.dislikedIngredients
            .any((d) => d.toLowerCase() == ingredientId.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();

    // Step 2: Filter by check-in category
    // Period-related types also match PMS-tagged recipes
    final checkInTypes = <CheckInType>{checkIn};
    if (checkIn == CheckInType.periodCramps ||
        checkIn == CheckInType.periodFatigue) {
      checkInTypes.add(CheckInType.pms);
    }
    final matchingRecipes = safeRecipes
        .where((recipe) =>
            recipe.checkInTags.any((tag) => checkInTypes.contains(tag)))
        .toList();

    // Step 3 & 4: Score by inventory compatibility
    final scored = matchingRecipes.map((recipe) {
      final available = <String>[];
      final missing = <String>[];

      for (final id in recipe.ingredientIds) {
        if (inventoryIds.contains(id)) {
          available.add(id);
        } else {
          missing.add(id);
        }
      }

      final ingredientScore = recipe.ingredientIds.isEmpty
          ? 0.0
          : available.length / recipe.ingredientIds.length;

      // Nutritional balance bonus (small weight)
      double nutritionBonus = 0;
      if (recipe.proteinLevel == NutrientLevel.high) nutritionBonus += 0.05;
      if (recipe.fiberLevel == NutrientLevel.high) nutritionBonus += 0.05;
      if (recipe.carbType == CarbType.complex) nutritionBonus += 0.03;

      final score = (ingredientScore * 0.85) + (nutritionBonus * 0.15);

      return ScoredRecipe(
        recipe: recipe,
        compatibilityScore: score.clamp(0.0, 1.0),
        availableIngredients: available,
        missingIngredients: missing,
      );
    }).toList();

    // Step 5: Sort by compatibility
    scored.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));

    // Group by meal type
    final result = <MealType, List<ScoredRecipe>>{};
    for (final mealType in MealType.values) {
      result[mealType] =
          scored.where((s) => s.recipe.mealType == mealType).toList();
    }

    return result;
  }

  /// Get all recipes filtered only by safety (allergens + disliked),
  /// scored by inventory. Used for browsing/planner.
  List<ScoredRecipe> getAllSafeRecipes({
    required List<Recipe> allRecipes,
    required UserProfile profile,
    required Set<String> inventoryIds,
  }) {
    final safeRecipes = allRecipes.where((recipe) {
      for (final allergen in recipe.allergenTags) {
        if (profile.allergies
            .any((a) => a.toLowerCase() == allergen.toLowerCase())) {
          return false;
        }
      }
      for (final ingredientId in recipe.ingredientIds) {
        if (profile.dislikedIngredients
            .any((d) => d.toLowerCase() == ingredientId.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();

    return safeRecipes.map((recipe) {
      final available = <String>[];
      final missing = <String>[];
      for (final id in recipe.ingredientIds) {
        if (inventoryIds.contains(id)) {
          available.add(id);
        } else {
          missing.add(id);
        }
      }
      final score = recipe.ingredientIds.isEmpty
          ? 0.0
          : available.length / recipe.ingredientIds.length;
      return ScoredRecipe(
        recipe: recipe,
        compatibilityScore: score,
        availableIngredients: available,
        missingIngredients: missing,
      );
    }).toList()
      ..sort(
          (a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
  }
}

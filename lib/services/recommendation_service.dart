import '../core/enums.dart';
import '../models/recipe.dart';
import '../models/user_profile.dart';
import '../data/explore_data.dart';
import 'diet_classifier.dart';
import 'special_category_matcher.dart';

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

  int get compatibilityPercent {
    final total = availableIngredients.length + missingIngredients.length;
    if (total == 0) return 0;
    return ((availableIngredients.length / total) * 100).round();
  }
}

class RecommendationService {
  /// Used to honor diet preferences (vegetarian etc.). When null, diet
  /// preferences are ignored.
  final DietClassifier? dietClassifier;

  RecommendationService({this.dietClassifier});

  /// Main recommendation algorithm.
  /// Filtering order:
  /// 1. Exclude recipes with allergens, disliked ingredients, or that don't
  ///    satisfy the profile's diet preferences (hard filter)
  /// 2. Score by check-in and health-condition match (soft bonus, never
  ///    excludes)
  /// 3. Compare with kitchen inventory
  /// 4. Calculate compatibility score
  /// 5. Sort by compatibility, meal type relevance, nutritional balance
  Map<MealType, List<ScoredRecipe>> getRecommendations({
    required List<Recipe> allRecipes,
    required UserProfile profile,
    required CheckInType checkIn,
    required Set<String> inventoryIds,
  }) {
    // Step 1: Exclude allergens, disliked ingredients, diet mismatches
    final safeRecipes =
        allRecipes.where((recipe) => _isSafe(recipe, profile)).toList();

    // Step 2: Check-in match as a soft bonus instead of a hard filter.
    // With a hard filter, sparse (check-in x meal type) combinations produce
    // empty recommendation lists; here non-matching recipes stay eligible but
    // rank below matching ones.
    // Period-related types also match PMS-tagged recipes.
    final checkInTypes = <CheckInType>{checkIn};
    if (checkIn == CheckInType.periodCramps ||
        checkIn == CheckInType.periodFatigue) {
      checkInTypes.add(CheckInType.pms);
    }

    // Step 3 & 4: Score by check-in match + inventory compatibility
    final scored = safeRecipes.map((recipe) {
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

      final checkInMatch = recipe.checkInTags
          .any((tag) => checkInTypes.contains(tag));

      // Health conditions are a standing need, not a mood: a recipe that
      // suits every declared condition ranks highest, one that suits none
      // gets no bonus. Soft like the check-in, so nothing disappears.
      final healthMatch = _healthMatchRatio(recipe, profile);

      // Nutritional balance bonus (small weight)
      double nutritionBonus = 0;
      if (recipe.proteinLevel == NutrientLevel.high) nutritionBonus += 0.05;
      if (recipe.fiberLevel == NutrientLevel.high) nutritionBonus += 0.05;
      if (recipe.carbType == CarbType.complex) nutritionBonus += 0.03;

      final score = (ingredientScore * 0.45) +
          (checkInMatch ? 0.28 : 0.0) +
          (healthMatch * 0.20) +
          (nutritionBonus * 0.07);

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
    final safeRecipes =
        allRecipes.where((recipe) => _isSafe(recipe, profile)).toList();

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

  /// Fraction of the profile's health conditions a recipe suits, 0..1.
  /// Returns 0 when no condition is declared, so the term drops out for
  /// users who have not filled that in.
  static double _healthMatchRatio(Recipe recipe, UserProfile profile) {
    final conditions = profile.healthConditions;
    if (conditions.isEmpty) return 0;

    var matches = 0;
    for (final condition in conditions) {
      final category = specialCategories
          .where((c) => c.healthCondition == condition)
          .firstOrNull;
      if (category == null) continue;
      if (matchesSpecialCategory(recipe, category)) matches++;
    }
    return matches / conditions.length;
  }

  /// Hard safety/suitability filter: allergens, disliked ingredients, and
  /// diet preferences (a recipe must satisfy every selected preference).
  bool _isSafe(Recipe recipe, UserProfile profile) {
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
    final classifier = dietClassifier;
    if (classifier != null && profile.dietPreferences.isNotEmpty) {
      final tags = classifier.tagsFor(recipe);
      for (final preference in profile.dietPreferences) {
        if (!tags.contains(preference)) return false;
      }
    }
    return true;
  }
}

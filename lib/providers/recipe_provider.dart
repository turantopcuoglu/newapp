import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../models/recipe.dart';
import '../data/mock_recipes.dart';
import '../services/recommendation_service.dart';
import 'check_in_provider.dart';
import 'inventory_provider.dart';
import 'my_recipes_provider.dart';
import 'profile_provider.dart';

/// All recipes: mock + user-created.
final allRecipesProvider = Provider<List<Recipe>>((ref) {
  final myRecipes = ref.watch(myRecipesProvider);
  return [...allMockRecipes, ...myRecipes];
});

/// Map of recipe ID -> Recipe for quick lookup.
final recipeMapProvider = Provider<Map<String, Recipe>>((ref) {
  final recipes = ref.watch(allRecipesProvider);
  return {for (final r in recipes) r.id: r};
});

/// Recommendation service instance.
final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  return RecommendationService();
});

/// Recommendations based on current check-in, profile, and inventory.
final recommendationsProvider =
    Provider<Map<MealType, List<ScoredRecipe>>?>((ref) {
  final checkIn = ref.watch(checkInProvider);
  if (checkIn == null) return null;

  final profile = ref.watch(profileProvider);
  final inventoryIds = ref.watch(inventoryIdsProvider);
  final allRecipes = ref.watch(allRecipesProvider);
  final service = ref.watch(recommendationServiceProvider);

  return service.getRecommendations(
    allRecipes: allRecipes,
    profile: profile,
    checkIn: checkIn,
    inventoryIds: inventoryIds,
  );
});

/// All safe recipes (filtered by allergens/disliked) scored by inventory.
final safeScoredRecipesProvider = Provider<List<ScoredRecipe>>((ref) {
  final profile = ref.watch(profileProvider);
  final inventoryIds = ref.watch(inventoryIdsProvider);
  final allRecipes = ref.watch(allRecipesProvider);
  final service = ref.watch(recommendationServiceProvider);

  return service.getAllSafeRecipes(
    allRecipes: allRecipes,
    profile: profile,
    inventoryIds: inventoryIds,
  );
});

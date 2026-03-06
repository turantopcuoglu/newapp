import '../core/enums.dart';
import '../models/recipe.dart';
import 'mock_recipes_breakfast.dart';
import 'mock_recipes_lunch.dart';
import 'mock_recipes_dinner.dart';
import 'mock_recipes_snack.dart';

/// Cuisine type assignments derived from the world cuisines data.
/// Maps recipe ID → CuisineType.
const Map<String, CuisineType> _recipeCuisineMap = {
  // Turkish
  'd002': CuisineType.turkish, 'd005': CuisineType.turkish,
  'd006': CuisineType.turkish, 'd007': CuisineType.turkish,
  'd008': CuisineType.turkish, 'd009': CuisineType.turkish,
  'd010': CuisineType.turkish, 'd011': CuisineType.turkish,
  'd013': CuisineType.turkish, 'd015': CuisineType.turkish,
  'b003': CuisineType.turkish, 'b006': CuisineType.turkish,
  'b010': CuisineType.turkish,
  'l002': CuisineType.turkish, 'l005': CuisineType.turkish,
  'l008': CuisineType.turkish, 'l013': CuisineType.turkish,
  // Italian
  'd004': CuisineType.italian, 'd012': CuisineType.italian,
  'l003': CuisineType.italian,
  // Asian
  'd003': CuisineType.asian,
  'l004': CuisineType.asian, 'l007': CuisineType.asian,
  'l010': CuisineType.asian,
  // Middle Eastern
  'd014': CuisineType.middleEastern,
  'l006': CuisineType.middleEastern, 'l009': CuisineType.middleEastern,
  // Mediterranean
  'd001': CuisineType.mediterranean,
  'l001': CuisineType.mediterranean,
  'b002': CuisineType.mediterranean, 'b007': CuisineType.mediterranean,
  // American
  'b001': CuisineType.american, 'b004': CuisineType.american,
  'b005': CuisineType.american, 'b008': CuisineType.american,
  'l011': CuisineType.american, 'l012': CuisineType.american,
  // Mexican
  'l014': CuisineType.mexican, 'l015': CuisineType.mexican,
  // Healthy
  's001': CuisineType.healthy, 's002': CuisineType.healthy,
  's003': CuisineType.healthy, 's004': CuisineType.healthy,
  's005': CuisineType.healthy, 's006': CuisineType.healthy,
  's007': CuisineType.healthy, 's008': CuisineType.healthy,
  's009': CuisineType.healthy, 's010': CuisineType.healthy,
  's011': CuisineType.healthy, 's012': CuisineType.healthy,
  's013': CuisineType.healthy, 's014': CuisineType.healthy,
  's015': CuisineType.healthy,
  'b009': CuisineType.healthy,
};

/// All built-in recipes are marked as isExplore: true (explore-only).
/// User-created recipes will have isExplore: false by default.
List<Recipe> get allMockRecipes => [
      ...mockBreakfastRecipes,
      ...mockLunchRecipes,
      ...mockDinnerRecipes,
      ...mockSnackRecipes,
    ].map((r) => Recipe(
          id: r.id,
          name: r.name,
          description: r.description,
          mealType: r.mealType,
          ingredientIds: r.ingredientIds,
          allergenTags: r.allergenTags,
          checkInTags: r.checkInTags,
          proteinLevel: r.proteinLevel,
          fiberLevel: r.fiberLevel,
          carbType: r.carbType,
          macros: r.macros,
          steps: r.steps,
          imagePath: r.imagePath,
          isUserCreated: r.isUserCreated,
          isExplore: true,
          cuisineType: _recipeCuisineMap[r.id],
          quantities: r.quantities,
        )).toList();

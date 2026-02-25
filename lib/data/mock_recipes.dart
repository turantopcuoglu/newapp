import '../models/recipe.dart';
import 'mock_recipes_breakfast.dart';
import 'mock_recipes_lunch.dart';
import 'mock_recipes_dinner.dart';
import 'mock_recipes_snack.dart';

/// All mock recipes combined from all meal types.
List<Recipe> get allMockRecipes => [
      ...mockBreakfastRecipes,
      ...mockLunchRecipes,
      ...mockDinnerRecipes,
      ...mockSnackRecipes,
    ];

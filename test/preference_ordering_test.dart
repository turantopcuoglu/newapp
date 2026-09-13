import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/models/ingredient.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/models/user_profile.dart';
import 'package:nutri_guide/services/diet_classifier.dart';
import 'package:nutri_guide/services/preference_matcher.dart';
import 'package:nutri_guide/services/recommendation_service.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  final classifier = DietClassifier(mockIngredients);
  final service = RecommendationService(dietClassifier: classifier);

  List<ScoredRecipe> browse(UserProfile profile) => service.getBrowsableRecipes(
        allRecipes: recipes,
        profile: profile,
        inventoryIds: const {},
      );

  group('browsing keeps recipes visible', () {
    test('a diet preference demotes recipes instead of hiding them', () {
      // The bug this replaces: declaring "vegan" emptied ingredient tiles and
      // cuisine lists, which reads as broken rather than as a preference.
      const vegan = UserProfile(dietPreferences: [DietClassifier.vegan]);
      final browsed = browse(vegan);

      expect(browsed.length, recipes.length);
      expect(browsed.any((sr) => !sr.preferenceFit.fits), isTrue);
    });

    test('what the user can eat comes first', () {
      const vegetarian =
          UserProfile(dietPreferences: [DietClassifier.vegetarian]);
      final browsed = browse(vegetarian);

      final firstDemoted =
          browsed.indexWhere((sr) => !sr.preferenceFit.fits);
      final lastFitting =
          browsed.lastIndexWhere((sr) => sr.preferenceFit.fits);

      expect(firstDemoted, greaterThan(-1));
      expect(lastFitting, lessThan(firstDemoted));
    });

    test('a disliked ingredient demotes and names itself', () {
      const disliked = UserProfile(dislikedIngredients: ['spinach']);
      final browsed = browse(disliked);

      final withSpinach = browsed
          .where((sr) => sr.recipe.ingredientIds.contains('spinach'))
          .toList();
      expect(withSpinach, isNotEmpty);
      for (final sr in withSpinach) {
        expect(sr.preferenceFit.fits, isFalse, reason: sr.recipe.id);
        expect(sr.preferenceFit.dislikedIngredientIds, contains('spinach'));
      }
      // And they are all behind the recipes that do fit.
      expect(browsed.last.preferenceFit.fits, isFalse);
    });

    test('no preferences means nothing is demoted', () {
      const empty = UserProfile();
      expect(browse(empty).every((sr) => sr.preferenceFit.fits), isTrue);
    });
  });

  group('allergens stay a hard exclusion', () {
    test('browsing never surfaces a recipe with a declared allergen', () {
      // Preferences are negotiable, allergens are not: demotion must never
      // apply to them.
      const allergic = UserProfile(allergies: ['gluten']);
      for (final sr in browse(allergic)) {
        expect(sr.recipe.allergenTags, isNot(contains('gluten')),
            reason: sr.recipe.id);
      }
    });

    test('recommendations still hard-filter preferences', () {
      // Home recommendations are a suggestion, not a catalogue: a vegan user
      // should not be offered meat there.
      const vegan = UserProfile(dietPreferences: [DietClassifier.vegan]);
      final recommended = service.getAllSafeRecipes(
        allRecipes: recipes,
        profile: vegan,
        inventoryIds: const {},
      );

      for (final sr in recommended) {
        expect(classifier.tagsFor(sr.recipe), contains(DietClassifier.vegan),
            reason: sr.recipe.id);
      }
    });
  });

  group('ingredient-level fit', () {
    Ingredient? byId(String id) =>
        mockIngredients.where((i) => i.id == id).firstOrNull;

    test('meat fails vegetarian, greens do not', () {
      const vegetarian =
          UserProfile(dietPreferences: [DietClassifier.vegetarian]);

      expect(ingredientPreferenceFit(byId('ground_beef')!, vegetarian).fits,
          isFalse);
      expect(
          ingredientPreferenceFit(byId('spinach')!, vegetarian).fits, isTrue);
    });

    test('eggs and dairy fail vegan but pass vegetarian', () {
      const vegan = UserProfile(dietPreferences: [DietClassifier.vegan]);
      const vegetarian =
          UserProfile(dietPreferences: [DietClassifier.vegetarian]);

      expect(ingredientPreferenceFit(byId('eggs')!, vegan).fits, isFalse);
      expect(ingredientPreferenceFit(byId('eggs')!, vegetarian).fits, isTrue);
      expect(ingredientPreferenceFit(byId('yogurt')!, vegan).fits, isFalse);
    });

    test('a disliked ingredient fails on its own', () {
      const disliked = UserProfile(dislikedIngredients: ['walnut']);
      final fit = ingredientPreferenceFit(byId('walnut')!, disliked);

      expect(fit.fits, isFalse);
      expect(fit.dislikedIngredientIds, ['walnut']);
      expect(ingredientPreferenceFit(byId('almond')!, disliked).fits, isTrue);
    });
  });
}

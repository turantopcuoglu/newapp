import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/ingredient_nutrition_data.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/diet_classifier.dart';

void main() {
  // flutter test runs from the project root, so bundle files resolve directly.
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];
  final ingredientIds = {for (final i in mockIngredients) i.id};
  final cuisineIds = {for (final c in worldCuisines) c.id};

  test('recipe ids are unique', () {
    final ids = recipes.map((r) => r.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('every recipe is localized in tr and en', () {
    for (final r in recipes) {
      for (final locale in ['tr', 'en']) {
        expect(r.name[locale], isNotEmpty, reason: '${r.id} name.$locale');
        expect(r.description[locale], isNotEmpty,
            reason: '${r.id} description.$locale');
        expect(r.steps[locale], isNotEmpty, reason: '${r.id} steps.$locale');
      }
    }
  });

  test('every recipe ingredient exists in the ingredient catalog', () {
    for (final r in recipes) {
      expect(r.ingredientIds, isNotEmpty, reason: r.id);
      for (final id in r.ingredientIds) {
        expect(ingredientIds.contains(id), isTrue,
            reason: '${r.id} references unknown ingredient "$id"');
      }
    }
  });

  test('every recipe ingredient has nutrition data', () {
    for (final r in recipes) {
      for (final id in r.ingredientIds) {
        expect(ingredientNutritionData.containsKey(id), isTrue,
            reason: '${r.id}: no nutrition data for "$id"');
      }
    }
  });

  test('every recipe has positive calories and at least one cuisine tag', () {
    for (final r in recipes) {
      expect(r.macros.calories, greaterThan(0), reason: r.id);
      expect(r.cuisineIds, isNotEmpty, reason: r.id);
      for (final c in r.cuisineIds) {
        expect(cuisineIds.contains(c), isTrue,
            reason: '${r.id} references unknown cuisine "$c"');
      }
    }
  });

  test('every cuisine category has at least one recipe', () {
    for (final cuisine in worldCuisines) {
      final count =
          recipes.where((r) => r.cuisineIds.contains(cuisine.id)).length;
      expect(count, greaterThan(0), reason: cuisine.id);
    }
  });

  test('diet classifier: meat recipes are never vegetarian or vegan', () {
    final classifier = DietClassifier(mockIngredients);
    for (final r in recipes) {
      final tags = classifier.tagsFor(r);
      final hasMeat = r.ingredientIds.any((id) => const {
            'chicken_breast', 'ground_beef', 'salmon', 'lamb', 'beef_steak',
            'tuna', 'cod', 'shrimp', 'sardine', 'pork_chop',
          }.contains(id));
      if (hasMeat) {
        expect(tags, isNot(contains(DietClassifier.vegetarian)), reason: r.id);
        expect(tags, isNot(contains(DietClassifier.vegan)), reason: r.id);
      }
    }
  });
}

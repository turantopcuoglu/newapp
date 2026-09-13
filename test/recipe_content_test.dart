import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/data/allergens.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/models/recipe.dart';

/// Content checks over the recipe library: what the method says has to match
/// what the ingredient list holds.
void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  final ingredientAllergens = {
    for (final i in mockIngredients) i.id: i.allergenTags,
  };

  Recipe byId(String id) => recipes.firstWhere((r) => r.id == id);

  String trSteps(Recipe r) => r.localizedSteps('tr').join(' ').toLowerCase();

  group('allergen safety', () {
    test('declared allergens cover what the ingredients carry', () {
      // The hard filter reads allergenTags. Under-declaring means an allergic
      // user is served the recipe — 27 recipes were in that state, including
      // nut and dairy ones.
      for (final recipe in recipes) {
        final implied = <String>{
          for (final id in recipe.ingredientIds)
            ...?ingredientAllergens[id],
        };
        expect(recipe.allergenTags.toSet(), containsAll(implied),
            reason: recipe.id);
      }
    });

    test('every tag is one the profile can actually select', () {
      // "tree_nuts" was tagged on twelve recipes and matched no profile
      // allergen, so the nut filter passed straight over them.
      for (final recipe in recipes) {
        for (final tag in recipe.allergenTags) {
          expect(knownAllergenTags, contains(tag), reason: recipe.id);
        }
      }
    });
  });

  group('the method matches the ingredient list', () {
    test('a recipe that rolls out dough lists something to make it from', () {
      // Mantı asked the cook to roll out a sheet of dough and listed no
      // flour, no egg, nothing.
      const doughPhrases = [
        'hamur açıp', 'hamuru açın', 'hamuru unlanmış', 'yufka',
        'roll out a thin sheet', 'roll the dough',
      ];
      const doughIngredients = {
        'flour', 'whole_wheat_flour', 'semolina', 'cornmeal', 'phyllo_dough',
        'puff_pastry', 'bread', 'pita_bread', 'tortilla_wrap', 'breadcrumbs',
      };

      for (final recipe in recipes) {
        final text = trSteps(recipe) +
            recipe.localizedSteps('en').join(' ').toLowerCase();
        if (!doughPhrases.any(text.contains)) continue;
        expect(recipe.ingredientIds.any(doughIngredients.contains), isTrue,
            reason: '${recipe.id} works a dough with no dough ingredient');
      }
    });

    test('Mantı carries its dough and its butter', () {
      final manti = byId('d015');
      expect(manti.ingredientIds, containsAll(['flour', 'eggs', 'butter']));
      expect(manti.quantities.keys, containsAll(['flour', 'eggs', 'butter']));
      // And the method actually makes the dough before rolling it.
      expect(trSteps(manti), contains('yoğurun'));
      expect(manti.allergenTags, containsAll(['gluten', 'eggs', 'dairy']));
    });

    test('tahin pekmez uses molasses, not pomegranate molasses', () {
      final recipe = byId('s034');
      expect(recipe.ingredientIds, contains('molasses'));
      expect(recipe.ingredientIds, isNot(contains('pomegranate_molasses')));
      expect(trSteps(recipe), contains('pekmez'));
    });

    test('kuru fasulye is made with white beans', () {
      final recipe = byId('l025');
      expect(recipe.ingredientIds, contains('white_bean'));
      expect(recipe.ingredientIds, isNot(contains('kidney_bean')));
    });

    test('recipes named after an ingredient contain it', () {
      const promises = {
        'b005': 'hazelnut', // "Fındıklı" parfait held walnuts
        'b023': 'cottage_cheese', // "Lor Peyniri" bowl held only yoghurt
        's025': 'dates', // "Hurmalı" bliss balls had no dates
      };
      promises.forEach((id, ingredient) {
        expect(byId(id).ingredientIds, contains(ingredient), reason: id);
      });
    });

    test('the salsa in Cips ve Sos has ingredients behind it', () {
      final recipe = byId('s028');
      expect(recipe.ingredientIds,
          containsAll(['tomato', 'onion', 'parsley', 'lemon', 'salt']));
    });

    test('nothing is listed that the trail mix never uses', () {
      expect(byId('s026').ingredientIds, isNot(contains('coconut_milk')));
    });
  });

  group('quantities stay in step with the ingredient list', () {
    test('every ingredient has a quantity and every quantity an ingredient',
        () {
      for (final recipe in recipes) {
        expect(recipe.quantities.keys.toSet(),
            equals(recipe.ingredientIds.toSet()),
            reason: recipe.id);
      }
    });
  });
}

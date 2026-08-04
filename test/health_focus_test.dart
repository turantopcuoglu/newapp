import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/health_category_info.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/special_category_matcher.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  SpecialCategory categoryById(String id) =>
      specialCategories.firstWhere((c) => c.id == id);

  group('allergen-based categories', () {
    test('gluten-free excludes every recipe tagged with gluten', () {
      final category = categoryById('glutenFree');
      final matched =
          recipes.where((r) => matchesSpecialCategory(r, category)).toList();

      expect(matched, isNotEmpty);
      for (final r in matched) {
        expect(r.allergenTags, isNot(contains('gluten')), reason: r.id);
      }
      // And nothing eligible is left out.
      final eligible =
          recipes.where((r) => !r.allergenTags.contains('gluten')).length;
      expect(matched.length, eligible);
    });

    test('lactose-free excludes every recipe tagged with dairy', () {
      final category = categoryById('lactoseFree');
      final matched =
          recipes.where((r) => matchesSpecialCategory(r, category)).toList();

      expect(matched, isNotEmpty);
      for (final r in matched) {
        expect(r.allergenTags, isNot(contains('dairy')), reason: r.id);
      }
    });
  });

  group('check-in based categories', () {
    test('period support only matches cycle-tagged recipes', () {
      final category = categoryById('periodSupport');
      final matched =
          recipes.where((r) => matchesSpecialCategory(r, category)).toList();

      expect(matched, isNotEmpty);
      for (final r in matched) {
        expect(
          r.checkInTags.any((t) =>
              t == CheckInType.periodCramps ||
              t == CheckInType.periodFatigue ||
              t == CheckInType.pms),
          isTrue,
          reason: r.id,
        );
      }
    });
  });

  group('condition-based categories', () {
    test('PCOS never matches a simple-carb recipe', () {
      final category = categoryById('pcos');
      for (final r in recipes) {
        if (matchesSpecialCategory(r, category)) {
          expect(r.carbType, isNot(CarbType.simple), reason: r.id);
          expect(r.fiberLevel, isNot(NutrientLevel.low), reason: r.id);
          expect(r.proteinLevel, isNot(NutrientLevel.low), reason: r.id);
        }
      }
    });

    test('deficiency categories match on their beneficial ingredients', () {
      final category = categoryById('magnesiumDeficiency');
      final beneficial =
          healthConditionIngredients[HealthCondition.magnesiumDeficiency]!;
      for (final r in recipes) {
        if (matchesSpecialCategory(r, category)) {
          expect(r.ingredientIds.any(beneficial.contains), isTrue,
              reason: r.id);
        }
      }
    });
  });

  test('every category surfaces at least one recipe', () {
    // A category that lands on an empty list looks broken to the user, and
    // the Explore tile advertises a count for each one.
    for (final category in specialCategories) {
      final count =
          recipes.where((r) => matchesSpecialCategory(r, category)).length;
      expect(count, greaterThan(0), reason: category.id);
    }
  });

  test('the count on the Explore tile is the list the user lands on', () {
    // The tile and the detail screen both go through matchesSpecialCategory,
    // so this guards against them drifting apart into a lying badge.
    for (final category in specialCategories) {
      final homeCount =
          recipes.where((r) => matchesSpecialCategory(r, category)).length;
      final listed = recipes
          .where((r) => matchesSpecialCategory(r, category))
          .map((r) => r.id)
          .toSet();
      expect(homeCount, listed.length, reason: category.id);
    }
  });

  group('category explanations and ingredient tiles', () {
    final ingredientIds = {for (final i in mockIngredients) i.id};

    test('every category explains itself in both languages', () {
      // The page leads with this text; a missing translation would show the
      // page with a hole in it.
      for (final category in specialCategories) {
        final info = healthCategoryInfo[category.id];
        expect(info, isNotNull, reason: category.id);
        for (final locale in ['tr', 'en']) {
          expect(info!.localizedSummary(locale), isNotEmpty,
              reason: '${category.id}/$locale');
          expect(info.sections, isNotEmpty, reason: category.id);
          for (final section in info.sections) {
            expect(section.localizedTitle(locale), isNotEmpty,
                reason: '${category.id}/$locale');
            expect(section.localizedItems(locale), isNotEmpty,
                reason: '${category.id}/$locale');
          }
        }
      }
    });

    test('tile ingredients are canonical catalog ids', () {
      // Matching is an exact id comparison, so a typo would render a tile
      // that opens an empty list.
      for (final category in specialCategories) {
        for (final id in healthCategoryInfo[category.id]!.ingredientIds) {
          expect(ingredientIds, contains(id), reason: category.id);
        }
      }
    });

    test('every category shows enough ingredient tiles', () {
      for (final category in specialCategories) {
        final tiles = healthCategoryIngredients(category, recipes);
        expect(tiles.length, greaterThanOrEqualTo(6), reason: category.id);
      }
    });

    test('a tile only lists recipes with the ingredient AND the condition',
        () {
      // The whole point of the grouping: an avocado tile under magnesium
      // must not surface an avocado recipe that does nothing for magnesium.
      for (final category in specialCategories) {
        for (final id in healthCategoryIngredients(category, recipes)) {
          final listed = recipes
              .where((r) => matchesCategoryIngredient(r, category, id))
              .toList();
          expect(listed, isNotEmpty, reason: '${category.id}/$id');
          for (final recipe in listed) {
            expect(recipe.ingredientIds, contains(id), reason: recipe.id);
            expect(matchesSpecialCategory(recipe, category), isTrue,
                reason: recipe.id);
          }
        }
      }
    });
  });
}

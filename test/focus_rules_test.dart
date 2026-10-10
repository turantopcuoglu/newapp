import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/focus_guidance.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/services/focus_rules.dart';

void main() {
  final recipes = [
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];
  const derived = [
    CheckInType.stressed,
    CheckInType.anxious,
    CheckInType.poorSleep,
  ];

  test('caffeine sources are catalogue ids', () {
    final ids = {for (final i in mockIngredients) i.id};
    expect(ids.containsAll(caffeineSources), isTrue);
  });

  test('every rule-based mood has enough recipes to rank', () {
    for (final focus in derived) {
      final count = recipes.where((r) => recipeHasFocus(r, focus)).length;
      expect(count, greaterThanOrEqualTo(25), reason: focus.name);
    }
  });

  // The reason sentence says "caffeine-free" (and "light" for sleep); it
  // may only say so because the rule checked it.
  test('what the reason claims holds for every recipe it is shown for', () {
    for (final focus in derived) {
      expect(focusGuidance[focus]!.reasonTr, contains('kafein içermeyen'));
      for (final recipe in recipes.where((r) => recipeMatchesFocus(r, focus))) {
        expect(
          recipe.ingredientIds.any(caffeineSources.contains),
          isFalse,
          reason: '${focus.name}: ${recipe.id}',
        );
        expect(recipe.carbType, isNot(CarbType.simple), reason: recipe.id);
      }
    }
    for (final recipe in recipes.where(
      (r) => recipeMatchesFocus(r, CheckInType.poorSleep),
    )) {
      expect(
        recipe.macros.calories,
        lessThanOrEqualTo(lightMealMaxKcal),
        reason: recipe.id,
      );
    }
  });

  test('rule-based moods ignore hand tags; the original nine use them', () {
    for (final focus in derived) {
      expect(derivedFocusMatch(recipes.first, focus), isNotNull);
      expect(focusRuleText[focus], isNotNull, reason: focus.name);
    }
    for (final focus in CheckInType.values.where((f) => !derived.contains(f))) {
      expect(derivedFocusMatch(recipes.first, focus), isNull);
    }
  });

  test('the three new moods do not collapse into one list', () {
    Set<String> ids(CheckInType f) => {
      for (final r in recipes.where((r) => recipeHasFocus(r, f))) r.id,
    };
    expect(ids(CheckInType.stressed), isNot(ids(CheckInType.anxious)));
    expect(ids(CheckInType.anxious), isNot(ids(CheckInType.poorSleep)));
  });
}

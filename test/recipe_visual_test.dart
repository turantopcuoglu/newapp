import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/components/recipe_visual.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/models/recipe.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  Widget host(Recipe recipe) => MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: RecipeVisual(recipe: recipe),
          ),
        ),
      );

  testWidgets('every bundled recipe renders a visual without error',
      (tester) async {
    for (final recipe in recipes) {
      await tester.pumpWidget(host(recipe));
      expect(tester.takeException(), isNull, reason: recipe.id);
      // The illustration draws the emoji twice (watermark + centred glyph),
      // so finding it proves the placeholder actually painted.
      expect(find.text(RecipeVisual(recipe: recipe).emoji), findsWidgets,
          reason: recipe.id);
    }
  });

  test('every bundled recipe resolves a non-empty emoji', () {
    for (final recipe in recipes) {
      final emoji = RecipeVisual(recipe: recipe).emoji;
      expect(emoji, isNotEmpty, reason: recipe.id);
    }
  });

  test('emoji picks name keywords before ingredients', () {
    const soup = Recipe(
      id: 'x',
      name: {'en': 'Lentil Soup'},
      description: {'en': ''},
      // Ingredient would map to the bean glyph; the name must win.
      ingredientIds: ['red_lentil'],
      cuisineIds: ['turkish'],
    );
    expect(RecipeVisual(recipe: soup).emoji, '🍲');
  });

  test('falls back to the meal-type emoji when nothing matches', () {
    const plain = Recipe(
      id: 'y',
      name: {'en': 'Something Unusual'},
      description: {'en': ''},
      ingredientIds: ['salt'],
      mealType: MealType.breakfast,
    );
    expect(RecipeVisual(recipe: plain).emoji, '🍳');
  });

  testWidgets('unknown cuisine still renders (gradient falls back)',
      (tester) async {
    const orphan = Recipe(
      id: 'z',
      name: {'en': 'Orphan Dish'},
      description: {'en': ''},
      cuisineIds: ['no_such_cuisine'],
    );
    await tester.pumpWidget(host(orphan));
    expect(tester.takeException(), isNull);
  });
}

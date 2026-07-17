// Recipe data integrity + calorie deviation report over assets/recipes/*.json.
//
// Run after `flutter pub get`:
//   dart run tool/data_report.dart               # report only
//   dart run tool/data_report.dart --strict      # non-zero exit on errors
//   dart run tool/data_report.dart --fix-macros  # recompute macros from
//                                                # ingredient data and write
//                                                # them back into the JSON
//
// Checks every recipe for: localized name/description/steps (tr+en),
// ingredient ids that exist in the ingredient catalog, nutrition-data
// coverage, positive calories, and at least one cuisine tag. Also compares
// stored calories against the ingredient-computed value.
//
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/ingredient_nutrition_data.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/nutrition_calculator.dart';

const recipeFiles = [
  'assets/recipes/breakfast.json',
  'assets/recipes/lunch.json',
  'assets/recipes/dinner.json',
  'assets/recipes/snack.json',
];

void main(List<String> args) {
  final strict = args.contains('--strict');
  final fixMacros = args.contains('--fix-macros');

  final ingredientIds = {for (final i in mockIngredients) i.id};
  final cuisineIds = {for (final c in worldCuisines) c.id};
  final calculator = NutritionCalculator();

  final errors = <String>[];
  final warnings = <String>[];
  final deviations = <(String, String, int, int, double)>[];
  var totalRecipes = 0;

  for (final path in recipeFiles) {
    final list = jsonDecode(File(path).readAsStringSync()) as List<dynamic>;
    final recipes = list
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
    totalRecipes += recipes.length;

    if (fixMacros) {
      final fixed = recipes.map((recipe) {
        if (recipe.quantities.isEmpty) return recipe.toJson();
        final json = recipe.toJson();
        json['macros'] = calculator.computePerServing(recipe).macros.toJson();
        return json;
      }).toList();
      const encoder = JsonEncoder.withIndent('  ');
      File(path).writeAsStringSync('${encoder.convert(fixed)}\n');
      // Re-read so the report below reflects the written values.
      recipes.clear();
      recipes.addAll(fixed.map(Recipe.fromJson));
    }

    for (final recipe in recipes) {
      final name = recipe.name['en'] ?? recipe.id;

      for (final locale in ['en', 'tr']) {
        if ((recipe.name[locale] ?? '').isEmpty) {
          errors.add('${recipe.id} ($name): missing $locale name');
        }
        if ((recipe.description[locale] ?? '').isEmpty) {
          errors.add('${recipe.id} ($name): missing $locale description');
        }
        if ((recipe.steps[locale] ?? []).isEmpty) {
          errors.add('${recipe.id} ($name): missing $locale steps');
        }
      }

      if (recipe.ingredientIds.isEmpty) {
        errors.add('${recipe.id} ($name): no ingredients');
      }
      for (final id in recipe.ingredientIds) {
        if (!ingredientIds.contains(id)) {
          errors.add('${recipe.id} ($name): unknown ingredient "$id"');
        } else if (!ingredientNutritionData.containsKey(id)) {
          warnings.add('${recipe.id} ($name): no nutrition data for "$id"');
        }
      }

      if (recipe.cuisineIds.isEmpty) {
        errors.add('${recipe.id} ($name): no cuisine tag');
      }
      for (final c in recipe.cuisineIds) {
        if (!cuisineIds.contains(c)) {
          errors.add('${recipe.id} ($name): unknown cuisine "$c"');
        }
      }
      if (recipe.macros.calories <= 0) {
        errors.add('${recipe.id} ($name): calories must be > 0');
      }
      if (recipe.quantities.isEmpty) {
        warnings.add('${recipe.id} ($name): no ingredient quantities');
      } else {
        for (final id in recipe.quantities.keys) {
          if (!recipe.ingredientIds.contains(id)) {
            errors.add('${recipe.id} ($name): quantity for "$id" '
                'which is not in ingredientIds');
          }
        }
        for (final id in recipe.ingredientIds) {
          if (!recipe.quantities.containsKey(id)) {
            errors.add('${recipe.id} ($name): missing quantity for "$id"');
          }
        }
      }

      final deviation = calculator.calorieDeviation(recipe);
      if (deviation != null) {
        final computed = calculator.computePerServing(recipe).macros.calories;
        deviations.add(
            (recipe.id, name, recipe.macros.calories, computed, deviation));
      }
    }
  }

  print('Recipes checked: $totalRecipes');
  print('Integrity errors: ${errors.length}');
  for (final e in errors) {
    print('  ERROR $e');
  }
  print('Warnings: ${warnings.length}');
  for (final w in warnings) {
    print('  WARN  $w');
  }

  deviations.sort((a, b) => b.$5.compareTo(a.$5));
  final over = deviations.where((d) => d.$5 > 0.15).toList();
  print('\nCalorie deviation (stored vs ingredient-computed):');
  print('  >15% deviation: ${over.length}/${deviations.length} recipes');
  if (over.isNotEmpty) {
    print('  Worst 15:');
    for (final d in deviations.take(15)) {
      final pct = (d.$5 * 100).toStringAsFixed(0);
      print('    ${d.$1} ${d.$2}: stored ${d.$3} kcal, '
          'computed ${d.$4} kcal ($pct%)');
    }
  }

  if (strict && errors.isNotEmpty) {
    throw StateError('${errors.length} integrity error(s)');
  }
}

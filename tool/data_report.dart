// Recipe data integrity + calorie deviation report.
//
// Run with a plain Dart SDK (no Flutter needed):
//   dart tool/data_report.dart          # report only
//   dart tool/data_report.dart --strict # non-zero exit on integrity errors
//
// Checks every recipe for: localized name/description/steps (tr+en),
// ingredient ids that exist in the ingredient catalog, nutrition-data
// coverage, positive calories, and at least one cuisine tag. Also compares
// hand-written calories against the ingredient-computed estimate and lists
// the recipes that deviate the most.

import '../lib/data/ingredient_nutrition_data.dart';
import '../lib/data/mock_ingredients.dart';
import '../lib/data/mock_recipes.dart';
import '../lib/services/nutrition_calculator.dart';

void main(List<String> args) {
  final strict = args.contains('--strict');
  final ingredientIds = {for (final i in mockIngredients) i.id};
  final calculator = NutritionCalculator();

  final errors = <String>[];
  final warnings = <String>[];
  final deviations = <(String, String, int, int, double)>[];

  for (final recipe in allMockRecipes) {
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
    if (recipe.macros.calories <= 0) {
      errors.add('${recipe.id} ($name): calories must be > 0');
    }

    final deviation = calculator.calorieDeviation(recipe);
    if (deviation != null) {
      final computed = calculator.computePerServing(recipe).macros.calories;
      deviations.add(
          (recipe.id, name, recipe.macros.calories, computed, deviation));
    }
  }

  print('Recipes checked: ${allMockRecipes.length}');
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
  print('\nCalorie deviation (hand-written vs ingredient-computed):');
  print('  >15% deviation: ${over.length}/${deviations.length} recipes');
  print('  Worst 15:');
  for (final d in deviations.take(15)) {
    final pct = (d.$5 * 100).toStringAsFixed(0);
    print('    ${d.$1} ${d.$2}: manual ${d.$3} kcal, '
        'computed ${d.$4} kcal ($pct%)');
  }

  if (strict && errors.isNotEmpty) {
    throw StateError('${errors.length} integrity error(s)');
  }
}

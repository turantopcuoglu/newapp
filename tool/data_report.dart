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

import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/allergens.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/health_category_info.dart';
import 'package:nutri_guide/data/ingredient_nutrition_data.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/nutrition_calculator.dart';
import 'package:nutri_guide/services/special_category_matcher.dart';

/// Two recipes sharing this fraction of their *characteristic* ingredients
/// read as the same dish to a user, even when the names differ.
const double nearDuplicateThreshold = 0.70;

/// Malzemeleri örtüşen iki tarifin *yöntemi* de bu kadar örtüşüyorsa gerçek
/// kopyadır; altındaysa aynı malzemelerden başka yemek yapılıyor demektir.
const double nearDuplicateMethodThreshold = 0.50;

/// Seasonings, fats and sweeteners appear in most recipes, so counting them
/// makes unrelated dishes look alike (salt alone is in half the library).
/// Similarity is judged on what actually defines the dish.
const Set<String> commonBaseIngredients = {
  'salt', 'sugar', 'brown_sugar', 'powdered_sugar',
  'black_pepper', 'white_pepper', 'red_pepper_flakes', 'paprika',
  'cumin', 'oregano', 'thyme', 'basil', 'mint', 'parsley', 'dill',
  'bay_leaf', 'rosemary', 'cinnamon', 'turmeric', 'coriander', 'nutmeg',
  'clove', 'cardamom', 'sumac', 'curry_powder', 'ginger_powder',
  'garlic_powder', 'onion_powder', 'vanilla',
  'olive_oil', 'sunflower_oil', 'canola_oil', 'coconut_oil', 'sesame_oil',
  'avocado_oil', 'grape_seed_oil', 'butter', 'ghee',
  'water',
};

/// İki tarifin hazırlanış adımlarındaki kelime örtüşmesi (Jaccard).
double _methodOverlap(Recipe a, Recipe b) {
  Set<String> words(Recipe r) => (r.steps['tr'] ?? const [])
      .expand((s) => s.toLowerCase().split(RegExp(r'[^a-zçğıöşü0-9]+')))
      .where((w) => w.length > 3)
      .toSet();
  final wa = words(a);
  final wb = words(b);
  if (wa.isEmpty || wb.isEmpty) return 0;
  return wa.intersection(wb).length / wa.union(wb).length;
}

/// Minimum steps to be cookable. Snacks are legitimately simpler than a
/// main course, so padding them to a main's length would only add filler.
///
/// The corrected recipe corpus writes each method as a few dense steps; the
/// importer re-splits them at sentence boundaries, which lands most recipes
/// at 4-8. Four is the floor for "this is a method, not a one-liner" —
/// padding beyond that would mean inventing text the recipe source does not
/// have.
int minStepsFor(MealType mealType) => 4;

/// Below this, the dish is likely under-specified.
const int minIngredients = 4;

/// A health category with fewer matches than this looks broken to a user.
const int minRecipesPerHealthCategory = 15;

/// Fewer tiles than this and the category page looks empty under its
/// explanation, so the ingredient lists need filling out.
const int minIngredientTilesPerCategory = 6;

/// Step wording that only makes sense when the recipe includes a dough.
/// "Hamur" also means a nut paste, so the paste words are excluded below.
const List<String> doughWords = [
  'hamuru açın', 'hamur açıp', 'hamuru aç', 'yufka', 'roll out a thin sheet',
  'roll the dough', 'knead the flour',
];

const Set<String> doughIngredients = {
  'flour', 'whole_wheat_flour', 'semolina', 'cornmeal', 'phyllo_dough',
  'puff_pastry', 'bread', 'pita_bread', 'tortilla_wrap', 'breadcrumbs',
};

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
  final allRecipes = <Recipe>[];
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

    allRecipes.addAll(recipes);

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
      for (final locale in ['en', 'tr']) {
        final steps = recipe.steps[locale] ?? const [];
        final required = minStepsFor(recipe.mealType);
        if (steps.isNotEmpty && steps.length < required) {
          errors.add('${recipe.id} ($name): only ${steps.length} $locale '
              'steps, needs at least $required');
        }
      }
      if (recipe.ingredientIds.length < minIngredients) {
        warnings.add('${recipe.id} ($name): only '
            '${recipe.ingredientIds.length} ingredients');
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

  // ── Allergen safety ────────────────────────────────────────────────────
  // A recipe's allergenTags are what the hard filter reads. If the tags say
  // less than the ingredients do, an allergic user is shown the recipe — the
  // one failure mode in this app that can actually hurt someone. Twelve
  // recipes also carried a "tree_nuts" tag that no profile can ever select,
  // so the nut filter passed straight over them.
  final ingredientAllergens = {
    for (final i in mockIngredients) i.id: i.allergenTags,
  };
  for (final recipe in allRecipes) {
    final declared = recipe.allergenTags.toSet();
    for (final tag in declared) {
      if (!knownAllergenTags.contains(tag)) {
        errors.add('${recipe.id}: unknown allergen tag "$tag" — the profile '
            'cannot select it, so it filters nothing');
      }
    }
    final implied = <String>{
      for (final id in recipe.ingredientIds) ...?ingredientAllergens[id],
    };
    final gap = implied.difference(declared);
    if (gap.isNotEmpty) {
      errors.add('${recipe.id}: ingredients contain ${gap.join(", ")} but the '
          'recipe does not declare it');
    }
  }

  // ── Dough: named in the steps, missing from the list ───────────────────
  // "Roll out a thin sheet of dough" with no flour anywhere is how Mantı
  // shipped: the method assumed a component the ingredient list never had.
  for (final recipe in allRecipes) {
    final steps = [
      ...?recipe.steps['tr'],
      ...?recipe.steps['en'],
    ].join(' ').toLowerCase();
    final claimsDough = doughWords.any(steps.contains);
    if (!claimsDough) continue;
    final hasDough = recipe.ingredientIds.any(doughIngredients.contains);
    if (!hasDough) {
      errors.add('${recipe.id}: the steps work a dough but no dough '
          'ingredient (flour, phyllo, …) is listed');
    }
  }

  // ── Health category filters ────────────────────────────────────────────
  // Matching is an exact id comparison, so a stale id here hides recipes from
  // a whole category without any visible failure.
  healthConditionIngredients.forEach((condition, ids) {
    for (final id in ids) {
      if (!ingredientIds.contains(id)) {
        errors.add('healthConditionIngredients[${condition.name}]: '
            'unknown ingredient "$id"');
      }
    }
    final matching = allRecipes
        .where((r) => r.ingredientIds.any(ids.contains))
        .length;
    if (matching < minRecipesPerHealthCategory) {
      warnings.add('health category ${condition.name} matches only '
          '$matching recipes');
    }
  });

  // ── Health category editorial content ──────────────────────────────────
  // The ingredient tiles under a category come from healthCategoryInfo; a
  // stale id there renders a tile that opens an empty list, and a category
  // without content silently falls back to the plain recipe list.
  for (final category in specialCategories) {
    final info = healthCategoryInfo[category.id];
    if (info == null) {
      errors.add('healthCategoryInfo: no content for category '
          '"${category.id}"');
      continue;
    }
    for (final locale in ['tr', 'en']) {
      if ((info.summary[locale] ?? '').trim().isEmpty) {
        errors.add('healthCategoryInfo[${category.id}]: missing $locale '
            'summary');
      }
      for (final section in info.sections) {
        if ((section.title[locale] ?? '').trim().isEmpty ||
            (section.items[locale] ?? const []).isEmpty) {
          errors.add('healthCategoryInfo[${category.id}]: incomplete '
              '$locale section');
        }
      }
    }
    for (final id in info.ingredientIds) {
      if (!ingredientIds.contains(id)) {
        errors.add('healthCategoryInfo[${category.id}]: unknown ingredient '
            '"$id"');
      }
    }
    final withRecipes = healthCategoryIngredients(category, allRecipes);
    if (withRecipes.length < minIngredientTilesPerCategory) {
      warnings.add('health category ${category.id} shows only '
          '${withRecipes.length} ingredient tiles');
    }
  }

  // ── Cross-recipe checks: duplicates and near-duplicates ────────────────
  // A library that repeats itself feels smaller than it is, so these are
  // errors rather than warnings.
  for (final locale in ['tr', 'en']) {
    final byName = <String, List<String>>{};
    for (final recipe in allRecipes) {
      final name = (recipe.name[locale] ?? '').trim().toLowerCase();
      if (name.isEmpty) continue;
      byName.putIfAbsent(name, () => []).add(recipe.id);
    }
    byName.forEach((name, ids) {
      if (ids.length > 1) {
        errors.add('duplicate $locale name "$name": ${ids.join(", ")}');
      }
    });
  }

  for (var i = 0; i < allRecipes.length; i++) {
    for (var j = i + 1; j < allRecipes.length; j++) {
      final a = allRecipes[i];
      final b = allRecipes[j];
      final sa = a.ingredientIds.toSet()..removeAll(commonBaseIngredients);
      final sb = b.ingredientIds.toSet()..removeAll(commonBaseIngredients);
      if (sa.isEmpty || sb.isEmpty) continue;
      final overlap =
          sa.intersection(sb).length / sa.union(sb).length;
      if (overlap >= nearDuplicateThreshold) {
        final pct = (overlap * 100).round();
        // Aynı malzemeleri paylaşan iki tarif kopya olmak zorunda değil:
        // menemen ile şakşuka, karnıyarık ile musakka aynı malzemelerden
        // başka yemekler yapar. Kopyayı yöntem ele verir — adımlar da
        // örtüşüyorsa hata, örtüşmüyorsa insanın bakması için uyarı.
        final methodOverlap = _methodOverlap(a, b);
        final line = 'near-duplicate ($pct% same ingredients, '
            '${(methodOverlap * 100).round()}% same method): '
            '${a.id} "${a.name['tr'] ?? a.id}" vs '
            '${b.id} "${b.name['tr'] ?? b.id}"';
        if (methodOverlap >= nearDuplicateMethodThreshold) {
          errors.add(line);
        } else {
          warnings.add(line);
        }
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

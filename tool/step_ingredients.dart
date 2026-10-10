// Seeds and audits `stepIngredients` — which ingredients each step uses —
// in assets/recipes/*.json. The cooking screen shows those ingredients with
// their amounts on each step.
//
//   dart run tool/step_ingredients.dart          # report: coverage, gaps
//   dart run tool/step_ingredients.dart --write  # fill recipes that have no
//                                                # stepIngredients yet
//
// The guess comes from the step wording (lib/services/step_ingredient_matcher
// .dart). Once written, the JSON is the source of truth and is edited by
// hand; --write never overwrites a recipe that already has the field.
// An ingredient no step uses is reported: either the steps forgot it (fix
// the steps — CLAUDE.md data rules) or the wording needs an alias. So is a
// step that names a catalog ingredient the list lacks.
//
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/step_ingredient_matcher.dart';

const recipeFiles = [
  'assets/recipes/breakfast.json',
  'assets/recipes/lunch.json',
  'assets/recipes/dinner.json',
  'assets/recipes/snack.json',
];

void main(List<String> args) {
  final write = args.contains('--write');
  var ingredients = 0, placed = 0, written = 0;
  final drift = <String>[];
  final gaps = <String>[];
  final unlisted = <String>[];

  for (final path in recipeFiles) {
    final raw = jsonDecode(File(path).readAsStringSync()) as List<dynamic>;
    var changed = false;
    for (final json in raw.cast<Map<String, dynamic>>()) {
      final recipe = Recipe.fromJson(json);
      final guess = matchStepIngredients(recipe);
      final stored = recipe.stepIngredients;
      final used = (stored.isEmpty ? guess : stored).expand((s) => s).toSet();
      ingredients += recipe.ingredientIds.length;
      placed += recipe.ingredientIds.where(used.contains).length;
      for (final id in recipe.ingredientIds.where((i) => !used.contains(i))) {
        gaps.add('${recipe.id} $id');
      }
      unlistedStepMentions(recipe).forEach((step, ids) {
        unlisted.add('${recipe.id} step ${step + 1}: ${ids.join(', ')}');
      });
      if (stored.isNotEmpty) {
        for (var i = 0; i < stored.length && i < guess.length; i++) {
          final missing = guess[i].where((id) => !stored[i].contains(id));
          if (missing.isEmpty) continue;
          drift.add('${recipe.id} step ${i + 1}: ${missing.join(', ')}');
        }
      } else if (write) {
        // Insert right after `steps` so the file reads in the same order
        // as the model.
        final entries = json.entries.toList();
        json.clear();
        for (final e in entries) {
          json[e.key] = e.value;
          if (e.key == 'steps') json['stepIngredients'] = guess;
        }
        written++;
        changed = true;
      }
    }
    if (changed) {
      const encoder = JsonEncoder.withIndent('  ');
      File(path).writeAsStringSync('${encoder.convert(raw)}\n');
    }
  }

  final pct = ingredients == 0 ? 0 : placed * 100 / ingredients;
  print(
    'Ingredients placed in a step: $placed/$ingredients '
    '(${pct.toStringAsFixed(1)}%)',
  );
  if (write) print('Wrote stepIngredients for $written recipes.');
  if (drift.isNotEmpty) {
    print(
      '\nStored steps leaving out an ingredient the wording names '
      '(${drift.length}) — fine when it was removed by hand on purpose:',
    );
    for (final d in drift) {
      print('  $d');
    }
  }
  if (unlisted.isNotEmpty) {
    print(
      '\nSteps naming a catalog ingredient the recipe does not list '
      '(${unlisted.length}) — add it, or the wording is a look-alike:',
    );
    for (final u in unlisted) {
      print('  $u');
    }
  }
  if (gaps.isNotEmpty) {
    print('\nIngredients no step uses (${gaps.length}):');
    for (final g in gaps) {
      print('  $g');
    }
  }
}

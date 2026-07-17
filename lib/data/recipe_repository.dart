import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/recipe.dart';

/// Bundled recipe content lives in assets/recipes/*.json so recipes can be
/// fixed and extended without touching code (and, later, fetched remotely).
class RecipeRepository {
  static const List<String> bundleFiles = [
    'assets/recipes/breakfast.json',
    'assets/recipes/lunch.json',
    'assets/recipes/dinner.json',
    'assets/recipes/snack.json',
  ];

  /// Loads all bundled recipes. Called once at startup (see main.dart).
  static Future<List<Recipe>> loadBundled() async {
    final recipes = <Recipe>[];
    for (final path in bundleFiles) {
      final raw = await rootBundle.loadString(path);
      recipes.addAll(decodeRecipeList(raw));
    }
    return recipes;
  }

  /// Decodes a JSON array of recipe objects.
  static List<Recipe> decodeRecipeList(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

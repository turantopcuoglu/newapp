import '../core/turkish_string_helper.dart';
import '../data/ingredient_visual.dart';
import '../models/recipe.dart';

/// Matches a recipe on its name, its description or any ingredient it uses,
/// so "avokado" finds the dishes that contain it, not just the ones named
/// after it. Turkish-aware casing: "ISPANAK" finds "ıspanak".
bool recipeMatchesQuery(Recipe recipe, String query, String locale) {
  final q = query.trim();
  if (q.isEmpty) return true;
  if (TurkishStringHelper.containsTr(recipe.localizedName(locale), q) ||
      TurkishStringHelper.containsTr(recipe.localizedDescription(locale), q)) {
    return true;
  }
  for (final id in recipe.ingredientIds) {
    final name = ingredientById(id)?.localizedName(locale) ?? id;
    if (TurkishStringHelper.containsTr(name, q)) return true;
  }
  return false;
}

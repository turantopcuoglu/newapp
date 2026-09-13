import '../models/recipe.dart';

/// Editorial estimates from the bundled instructions, including stated waits.
/// They are estimates, not measured cooking times. Unknown recipes stay unknown.
abstract final class RecipeTiming {
  static const _estimates = <String, int>{
    'b001': 15,
    'b002': 15,
    'b004': 15,
    'b005': 15,
    'l001': 40,
    'l002': 40,
    'l004': 35,
    'l005': 35,
    'd001': 40,
    'd002': 45,
    'd003': 30,
    'd004': 35,
    'd005': 90,
    's001': 110,
    's002': 10,
    's003': 260,
    's005': 10,
  };
  static int? minutes(Recipe recipe) =>
      recipe.prepTimeMin ??
      (recipe.isUserCreated ? null : _estimates[recipe.id]);
  static bool isEstimate(Recipe recipe) =>
      recipe.prepTimeMin == null && minutes(recipe) != null;
}

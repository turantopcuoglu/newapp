import '../core/enums.dart';
import '../data/explore_data.dart';
import '../data/health_category_info.dart';
import '../models/recipe.dart';

/// Whether a recipe belongs in a health category.
///
/// Single source of truth: the home screen shows a recipe count per category
/// and the detail screen lists them, so both must apply exactly the same rule
/// or the count becomes a lie.
///
/// Three kinds of category:
/// - deficiency conditions match on beneficial ingredients
/// - PCOS / insulin resistance match on nutrient profile
/// - gluten-free, lactose-free and period support match on allergen tags or
///   check-in tags
bool matchesSpecialCategory(Recipe recipe, SpecialCategory category) {
  final condition = category.healthCondition;

  if (condition == null) {
    final excluded = category.relatedAllergenExclusions;
    final checkIns = category.relatedCheckInTypes;
    if (excluded.isEmpty && checkIns.isEmpty) return true;

    final allergenOk =
        excluded.isEmpty || !recipe.allergenTags.any(excluded.contains);
    final checkInOk =
        checkIns.isEmpty || recipe.checkInTags.any(checkIns.contains);
    return allergenOk && checkInOk;
  }

  switch (condition) {
    case HealthCondition.pcos:
      // Low glycemic load: complex carbs with enough fibre and protein to
      // blunt the blood sugar response.
      return recipe.carbType != CarbType.simple &&
          _isMediumOrHigh(recipe.fiberLevel) &&
          _isMediumOrHigh(recipe.proteinLevel);

    case HealthCondition.insulinResistance:
      return recipe.carbType != CarbType.simple &&
          _isMediumOrHigh(recipe.fiberLevel);

    case HealthCondition.ironDeficiency:
    case HealthCondition.vitaminB12Deficiency:
    case HealthCondition.magnesiumDeficiency:
    case HealthCondition.anemia:
      final beneficial = healthConditionIngredients[condition] ?? const [];
      return recipe.ingredientIds.any(beneficial.contains);
  }
}

bool _isMediumOrHigh(NutrientLevel level) =>
    level == NutrientLevel.medium || level == NutrientLevel.high;

/// Whether a recipe belongs under one ingredient tile of a health category.
///
/// Both halves have to hold: the recipe must contain the ingredient *and*
/// still match the category, otherwise a tile under "Magnesium" would list
/// recipes that have nothing to do with magnesium.
bool matchesCategoryIngredient(
  Recipe recipe,
  SpecialCategory category,
  String ingredientId,
) =>
    recipe.ingredientIds.contains(ingredientId) &&
    matchesSpecialCategory(recipe, category);

/// The category's ingredients that actually have recipes behind them.
///
/// The editorial list in [healthCategoryInfo] is written by hand and the
/// recipe collection grows separately, so an ingredient with no recipe yet is
/// dropped here rather than shown as an empty tile.
List<String> healthCategoryIngredients(
  SpecialCategory category,
  List<Recipe> recipes,
) {
  final info = healthCategoryInfo[category.id];
  if (info == null) return const [];
  return info.ingredientIds
      .where((id) =>
          recipes.any((r) => matchesCategoryIngredient(r, category, id)))
      .toList();
}

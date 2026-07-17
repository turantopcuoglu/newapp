import '../models/ingredient.dart';
import '../models/recipe.dart';

/// Diet suitability tags derived from a recipe's ingredients.
///
/// A recipe's explicit `dietTags` (if any) take precedence; this classifier
/// fills the gap for recipes that don't declare them, so filters and badges
/// never depend on hand-tagging every recipe.
class DietClassifier {
  static const String vegetarian = 'vegetarian';
  static const String vegan = 'vegan';
  static const String glutenFree = 'glutenFree';
  static const String dairyFree = 'dairyFree';

  /// Ingredient ids that are animal flesh (meat, poultry, fish, seafood).
  static const Set<String> _meatAndFishIds = {
    'chicken_breast', 'chicken_thigh', 'chicken_wing', 'ground_beef',
    'beef_steak', 'veal', 'lamb', 'pork_chop', 'duck_breast',
    'turkey_breast', 'ground_turkey', 'liver', 'salmon', 'tuna', 'cod',
    'anchovy', 'sea_bass', 'sea_bream', 'sardine', 'shrimp', 'squid',
    'mussel', 'octopus', 'gelatin',
  };

  /// Animal-derived (non-flesh) ingredient ids that break vegan suitability.
  static const Set<String> _animalProductIds = {'eggs', 'honey'};

  final Map<String, Ingredient> _ingredientsById;

  DietClassifier(List<Ingredient> ingredients)
      : _ingredientsById = {for (final i in ingredients) i.id: i};

  /// Effective diet tags: explicit recipe tags win, otherwise derived.
  List<String> tagsFor(Recipe recipe) =>
      recipe.dietTags.isNotEmpty ? recipe.dietTags : derive(recipe);

  List<String> derive(Recipe recipe) {
    final allergens = <String>{...recipe.allergenTags};
    var hasMeatOrFish = false;
    var hasAnimalProduct = false;

    for (final id in recipe.ingredientIds) {
      if (_meatAndFishIds.contains(id)) hasMeatOrFish = true;
      if (_animalProductIds.contains(id)) hasAnimalProduct = true;
      final ingredient = _ingredientsById[id];
      if (ingredient != null) allergens.addAll(ingredient.allergenTags);
    }

    final isDairyFree = !allergens.contains('dairy');
    final isVegetarian = !hasMeatOrFish && !allergens.contains('fish');

    return [
      if (isVegetarian) vegetarian,
      if (isVegetarian &&
          isDairyFree &&
          !hasAnimalProduct &&
          !allergens.contains('eggs'))
        vegan,
      if (!allergens.contains('gluten')) glutenFree,
      if (isDairyFree) dairyFree,
    ];
  }
}

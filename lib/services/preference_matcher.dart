import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/user_profile.dart';
import 'diet_classifier.dart';

/// How well something fits the profile's *preferences* — disliked foods and
/// diet choices. Allergens are not in here on purpose: those are a safety
/// filter, not a preference, and stay hard-excluded everywhere.
///
/// Browsing screens use this to demote rather than hide. Hiding made recipes
/// and whole ingredient tiles vanish with no explanation the moment the user
/// declared a preference, which reads as a bug; now they sink to the bottom
/// carrying the reason.
class PreferenceFit {
  /// Ingredient ids the user marked as disliked.
  final List<String> dislikedIngredientIds;

  /// Diet preference ids (see [DietClassifier]) the item fails.
  final List<String> unmetDietPreferences;

  const PreferenceFit({
    this.dislikedIngredientIds = const [],
    this.unmetDietPreferences = const [],
  });

  static const PreferenceFit clean = PreferenceFit();

  bool get fits =>
      dislikedIngredientIds.isEmpty && unmetDietPreferences.isEmpty;

  /// Sort weight: 0 fits, higher sinks further down the list.
  int get demotion =>
      dislikedIngredientIds.length + unmetDietPreferences.length * 2;
}

/// Whether an allergen the profile declared appears in [allergenTags].
bool hasAllergenConflict(Iterable<String> allergenTags, UserProfile profile) {
  for (final tag in allergenTags) {
    if (profile.allergies.any((a) => a.toLowerCase() == tag.toLowerCase())) {
      return true;
    }
  }
  return false;
}

PreferenceFit recipePreferenceFit(
  Recipe recipe,
  UserProfile profile,
  DietClassifier classifier,
) {
  final disliked = recipe.ingredientIds
      .where((id) => profile.dislikedIngredients
          .any((d) => d.toLowerCase() == id.toLowerCase()))
      .toList();

  final tags = classifier.tagsFor(recipe);
  final unmet = profile.dietPreferences
      .where((preference) => !tags.contains(preference))
      .toList();

  return PreferenceFit(
    dislikedIngredientIds: disliked,
    unmetDietPreferences: unmet,
  );
}

/// The same judgement for a single ingredient, used by the ingredient tiles.
///
/// An ingredient carries a diet preference only when it is itself the reason
/// the preference would fail — meat under "vegetarian", dairy under
/// "dairy-free" — so a tile like spinach stays clean for every diet.
PreferenceFit ingredientPreferenceFit(
  Ingredient ingredient,
  UserProfile profile,
) {
  final disliked = profile.dislikedIngredients
          .any((d) => d.toLowerCase() == ingredient.id.toLowerCase())
      ? [ingredient.id]
      : <String>[];

  final allergens = ingredient.allergenTags;
  final isMeatOrFish = DietClassifier.isMeatOrFish(ingredient.id) ||
      allergens.contains('fish') ||
      allergens.contains('shellfish');
  final isAnimalProduct = DietClassifier.isAnimalProduct(ingredient.id) ||
      allergens.contains('eggs') ||
      allergens.contains('dairy');

  final unmet = <String>[];
  for (final preference in profile.dietPreferences) {
    switch (preference) {
      case DietClassifier.vegetarian:
        if (isMeatOrFish) unmet.add(preference);
      case DietClassifier.vegan:
        if (isMeatOrFish || isAnimalProduct) unmet.add(preference);
      case DietClassifier.glutenFree:
        if (allergens.contains('gluten')) unmet.add(preference);
      case DietClassifier.dairyFree:
        if (allergens.contains('dairy')) unmet.add(preference);
    }
  }

  return PreferenceFit(
    dislikedIngredientIds: disliked,
    unmetDietPreferences: unmet,
  );
}

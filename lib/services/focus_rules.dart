import '../core/enums.dart';
import '../data/explore_data.dart';
import '../models/recipe.dart';

/// Which recipes a check-in choice pushes up.
///
/// The original nine choices use the hand-set `checkInTags` in the recipe
/// JSON. The three added in phase 4 (stressed, anxious, slept badly) are
/// derived from each recipe's own data instead, like `DietClassifier` does
/// for vegetarian or gluten-free: the rule is written once, here, and covers
/// every recipe, new and user-created ones included. Each rule is a health-
/// adjacent claim, so its plain-language form ([focusRuleText]) goes to the
/// physician review page; until reviewed the reason sentence only says the
/// recipes were "marked" for the day.

/// Ingredients that carry caffeine (cocoa and chocolate; the catalogue has
/// no coffee or tea). Ids must exist in `mock_ingredients.dart` — a test
/// checks.
const Set<String> caffeineSources = {
  'dark_chocolate',
  'chocolate_bar',
  'cocoa_powder',
};

/// Per-serving ceiling for "light" on a slept-badly day.
const int lightMealMaxKcal = 550;

bool _caffeineFree(Recipe r) => !r.ingredientIds.any(caffeineSources.contains);
bool _notSimpleCarb(Recipe r) => r.carbType != CarbType.simple;
bool _atLeastMedium(NutrientLevel l) => l != NutrientLevel.low;

/// `null` for choices that use the hand-set tags.
bool? derivedFocusMatch(Recipe recipe, CheckInType focus) => switch (focus) {
  CheckInType.poorSleep =>
    _caffeineFree(recipe) &&
        _notSimpleCarb(recipe) &&
        recipe.macros.calories <= lightMealMaxKcal,
  CheckInType.stressed =>
    _caffeineFree(recipe) &&
        _notSimpleCarb(recipe) &&
        recipe.ingredientIds.any(
          (healthConditionIngredients[HealthCondition.magnesiumDeficiency] ??
                  const <String>[])
              .contains,
        ) &&
        (recipe.fiberLevel == NutrientLevel.high ||
            recipe.proteinLevel == NutrientLevel.high),
  CheckInType.anxious =>
    _caffeineFree(recipe) &&
        _notSimpleCarb(recipe) &&
        _atLeastMedium(recipe.proteinLevel) &&
        _atLeastMedium(recipe.fiberLevel),
  _ => null,
};

/// Whether [recipe] is marked for [focus], by rule or by tag.
bool recipeHasFocus(Recipe recipe, CheckInType focus) =>
    derivedFocusMatch(recipe, focus) ?? recipe.checkInTags.contains(focus);

/// The rules in words, for the physician review page.
const Map<CheckInType, (String, String)> focusRuleText = {
  CheckInType.poorSleep: (
    'Kafein içermeyen (kakao, çikolata yok), basit şeker ağırlıklı olmayan '
        've porsiyonu $lightMealMaxKcal kcal\'yi geçmeyen tarifler.',
    'Caffeine-free (no cocoa or chocolate), not simple-sugar based, at most '
        '$lightMealMaxKcal kcal per serving.',
  ),
  CheckInType.stressed: (
    'Kafein içermeyen, basit şeker ağırlıklı olmayan, en az bir magnezyum '
        'kaynağı içeren ve lifi ya da proteini yüksek tarifler.',
    'Caffeine-free, not simple-sugar based, with at least one magnesium '
        'source and high fibre or protein.',
  ),
  CheckInType.anxious: (
    'Kafein içermeyen, basit şeker ağırlıklı olmayan, proteini ve lifi en '
        'az orta düzeyde olan (kan şekerini dalgalandırmayan dengeli tabak) '
        'tarifler.',
    'Caffeine-free, not simple-sugar based, with at least medium protein and '
        'fibre (a balanced plate that avoids blood-sugar swings).',
  ),
};

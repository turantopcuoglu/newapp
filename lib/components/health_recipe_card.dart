import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../services/recommendation_service.dart';
import 'preference_warning.dart';
import 'recipe_visual.dart';
import 'save_recipe_button.dart';

/// Recipe row used by the health category screens: thumbnail, badges, macros
/// and a save button.
///
/// Shared so the category page and the per-ingredient page cannot drift into
/// two different-looking lists of the same recipes.
class HealthRecipeCard extends StatelessWidget {
  final ScoredRecipe scored;
  final String locale;
  final VoidCallback onTap;

  const HealthRecipeCard({
    super.key,
    required this.scored,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final recipe = scored.recipe;
    final l10n = AppLocalizations.of(context);
    final mealColor = _mealTypeColor(recipe.mealType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Leading thumbnail
              SizedBox(
                width: 64,
                child: RecipeVisual(
                  recipe: recipe,
                  height: 64,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges wrap: "Akşam Yemeği" plus "Alerjen Yok" does not
                    // fit next to the thumbnail on a narrow phone.
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: mealColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _mealTypeName(recipe.mealType, l10n),
                            style: TextStyle(
                              color: mealColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (recipe.allergenTags.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen.withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.exploreAllergenFree,
                              style: const TextStyle(
                                color: AppTheme.successGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.localizedName(locale),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recipe.localizedDescription(locale),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Macros: they wrap, because "Lif" and the numbers grow
                    // with the locale and the card is only so wide.
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _MacroBadge(
                          label: '${recipe.macros.calories} kcal',
                          color: AppTheme.accentOrange,
                        ),
                        _MacroBadge(
                          label: '${recipe.macros.proteinG}g P',
                          color: AppTheme.accentTeal,
                        ),
                        _MacroBadge(
                          label: '${recipe.macros.fiberG}g ${l10n.recipeFiber}',
                          color: AppTheme.successGreen,
                        ),
                        // Says why this card sits at the bottom of the list.
                        PreferenceMismatchChip(fit: scored.preferenceFit),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SaveRecipeButton(recipeId: recipe.id, size: 44),
            ],
          ),
        ),
      ),
    );
  }

  Color _mealTypeColor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return AppTheme.breakfastColor;
      case MealType.lunch:
        return AppTheme.lunchColor;
      case MealType.dinner:
        return AppTheme.dinnerColor;
      case MealType.snack:
        return AppTheme.snackColor;
    }
  }

  String _mealTypeName(MealType type, AppLocalizations l10n) {
    switch (type) {
      case MealType.breakfast:
        return l10n.recipeBreakfast;
      case MealType.lunch:
        return l10n.recipeLunch;
      case MealType.dinner:
        return l10n.recipeDinner;
      case MealType.snack:
        return l10n.recipeSnack;
    }
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MacroBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/category_cover.dart';
import '../../components/empty_state_artwork.dart';
import '../../components/preference_warning.dart';
import '../../components/recipe_visual.dart';
import '../../components/save_recipe_button.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/explore_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/recipe_provider.dart';
import '../../services/preference_matcher.dart';
import '../../services/recommendation_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class CuisineDetailScreen extends ConsumerWidget {
  final CuisineCategory cuisine;

  const CuisineDetailScreen({super.key, required this.cuisine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    // Recipes belong to a cuisine via their cuisineIds tags. The browsable
    // list is already ordered by diet fit first and pantry match second, so
    // what the user can eat sits at the top and what they avoid at the bottom
    // — visible, with the reason, instead of missing.
    final cuisineRecipes = ref
        .watch(browsableScoredRecipesProvider)
        .where((sr) => sr.recipe.cuisineIds.contains(cuisine.id))
        .toList();
    final hasDemoted = cuisineRecipes.any((sr) => !sr.preferenceFit.fits);

    return Scaffold(
      backgroundColor: context.palette.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CategoryCoverHeader(
              imagePath: cuisine.coverImage,
              title: cuisine.localizedName(locale),
              count: '${cuisineRecipes.length} ${l10n.recipeBookTotalRecipes}',
            ),
          ),

          // Recipe list
          if (cuisineRecipes.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const EmptyStateArtwork(name: 'no_results'),
                      Text(
                        l10n.recipeBookEmpty,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.palette.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            if (hasDemoted)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: PreferenceWarningCard(fit: _listFitOf(cuisineRecipes)),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final scored = cuisineRecipes[index];

                  return _RecipeCard(
                    scored: scored,
                    locale: locale,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailScreen(scoredRecipe: scored),
                      ),
                    ),
                  );
                }, childCount: cuisineRecipes.length),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Reasons gathered from the demoted recipes, for the banner above them.
  PreferenceFit _listFitOf(List<ScoredRecipe> recipes) {
    final diets = <String>{};
    final disliked = <String>{};
    for (final sr in recipes) {
      diets.addAll(sr.preferenceFit.unmetDietPreferences);
      disliked.addAll(sr.preferenceFit.dislikedIngredientIds);
    }
    return PreferenceFit(
      dislikedIngredientIds: disliked.toList(),
      unmetDietPreferences: diets.toList(),
    );
  }
}

// ── Recipe Card ───────────────────────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final ScoredRecipe scored;
  final String locale;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.scored,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final recipe = scored.recipe;
    final l10n = AppLocalizations.of(context);
    final mealColor = _mealTypeColor(context, recipe.mealType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.palette.surface,
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
              // Left: recipe info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal type badge
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
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      recipe.localizedName(locale),
                      style: TextStyle(
                        color: context.palette.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Description
                    Text(
                      recipe.localizedDescription(locale),
                      style: TextStyle(
                        color: context.palette.textSecondary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Macros row
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _MacroBadge(
                          label: '${recipe.macros.calories} kcal',
                          color: context.palette.accentOrange,
                        ),
                        _MacroBadge(
                          label: '${recipe.macros.proteinG}g P',
                          color: context.palette.accentTeal,
                        ),
                        if (scored.compatibilityPercent > 0)
                          _MacroBadge(
                            label:
                                '${scored.compatibilityPercent}% ${l10n.recipeCompatibility}',
                            color: context.palette.successGreen,
                          ),
                      ],
                    ),
                    if (!scored.preferenceFit.fits) ...[
                      const SizedBox(height: 6),
                      PreferenceMismatchChip(fit: scored.preferenceFit),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right: save button
              SaveRecipeButton(recipeId: recipe.id, size: 44),
            ],
          ),
        ),
      ),
    );
  }

  Color _mealTypeColor(BuildContext context, MealType type) {
    switch (type) {
      case MealType.breakfast:
        return context.palette.breakfastColor;
      case MealType.lunch:
        return context.palette.lunchColor;
      case MealType.dinner:
        return context.palette.dinnerColor;
      case MealType.snack:
        return context.palette.snackColor;
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

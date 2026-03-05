import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/explore_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/recommendation_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class CuisineDetailScreen extends ConsumerWidget {
  final CuisineCategory cuisine;

  const CuisineDetailScreen({super.key, required this.cuisine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final allRecipes = ref.watch(recipeMapProvider);
    final favorites = ref.watch(favoritesProvider);
    final scoredRecipes = ref.watch(safeScoredRecipesProvider);

    final cuisineRecipeIds = {
      ...cuisine.recipeIds,
      ...allRecipes.values
          .where((recipe) => recipe.cuisineId == cuisine.id)
          .map((recipe) => recipe.id),
    };

    // Get recipes matching this cuisine's recipe IDs
    final cuisineRecipes = cuisineRecipeIds
        .where((id) => allRecipes.containsKey(id))
        .map((id) {
      // Find scored version if available
      final scored = scoredRecipes
          .where((sr) => sr.recipe.id == id)
          .firstOrNull;
      return scored ??
          ScoredRecipe(
            recipe: allRecipes[id]!,
            compatibilityScore: 0,
            availableIngredients: [],
            missingIngredients: allRecipes[id]!.ingredientIds,
          );
    }).toList();

    final gradientColors = cuisineGradients[cuisine.gradient] ??
        cuisineGradients['healthy']!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(gradientColors[0]),
                    Color(gradientColors[1]),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        cuisine.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cuisine.localizedName(locale),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${cuisineRecipes.length} ${l10n.recipeBookTotalRecipes}',
                              style: TextStyle(
                                color: Colors.white.withAlpha(200),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recipe list
          if (cuisineRecipes.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    l10n.recipeBookEmpty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final scored = cuisineRecipes[index];
                    final recipe = scored.recipe;
                    final isFav = favorites.contains(recipe.id);

                    return _RecipeCard(
                      scored: scored,
                      locale: locale,
                      isFavorite: isFav,
                      onFavoriteTap: () => ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(recipe.id),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecipeDetailScreen(scoredRecipe: scored),
                        ),
                      ),
                    );
                  },
                  childCount: cuisineRecipes.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Recipe Card ───────────────────────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final ScoredRecipe scored;
  final String locale;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.scored,
    required this.locale,
    required this.isFavorite,
    required this.onFavoriteTap,
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
                    // Description
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
                    // Macros row
                    Row(
                      children: [
                        _MacroBadge(
                          label: '${recipe.macros.calories} kcal',
                          color: AppTheme.accentOrange,
                        ),
                        const SizedBox(width: 6),
                        _MacroBadge(
                          label: '${recipe.macros.proteinG}g P',
                          color: AppTheme.accentTeal,
                        ),
                        const SizedBox(width: 6),
                        if (scored.compatibilityPercent > 0)
                          _MacroBadge(
                            label: '${scored.compatibilityPercent}% ${l10n.recipeCompatibility}',
                            color: AppTheme.successGreen,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right: favorite button
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onFavoriteTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isFavorite
                            ? AppTheme.warmCoral.withAlpha(20)
                            : AppTheme.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isFavorite
                              ? AppTheme.warmCoral.withAlpha(80)
                              : AppTheme.dividerColor,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isFavorite
                            ? AppTheme.warmCoral
                            : AppTheme.textLight,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
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

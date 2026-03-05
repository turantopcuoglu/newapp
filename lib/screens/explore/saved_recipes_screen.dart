import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/recommendation_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class SavedRecipesScreen extends ConsumerWidget {
  final bool showAppBar;

  const SavedRecipesScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final favoriteIds = ref.watch(favoritesProvider);
    final recipeMap = ref.watch(recipeMapProvider);
    final scoredRecipes = ref.watch(safeScoredRecipesProvider);

    final savedRecipes = favoriteIds.where((id) => recipeMap.containsKey(id)).map((id) {
      final scored = scoredRecipes.where((sr) => sr.recipe.id == id).firstOrNull;
      return scored ??
          ScoredRecipe(
            recipe: recipeMap[id]!,
            compatibilityScore: 0,
            availableIngredients: [],
            missingIngredients: recipeMap[id]!.ingredientIds,
          );
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: showAppBar ? AppBar(title: Text(l10n.exploreSavedRecipes)) : null,
      body: _SavedRecipesBody(
        savedRecipes: savedRecipes,
        locale: locale,
        l10n: l10n,
      ),
    );
  }
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

class _SavedRecipesBody extends ConsumerWidget {
  final List<ScoredRecipe> savedRecipes;
  final String locale;
  final AppLocalizations l10n;

  const _SavedRecipesBody({
    required this.savedRecipes,
    required this.locale,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (savedRecipes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.warmCoral.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: AppTheme.warmCoral.withAlpha(120),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.exploreSavedEmpty,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: savedRecipes.length,
      itemBuilder: (context, index) {
        final scored = savedRecipes[index];
        final recipe = scored.recipe;
        final mealColor = _mealTypeColor(recipe.mealType);

        return Dismissible(
          key: Key(recipe.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red.shade400,
              size: 24,
            ),
          ),
          onDismissed: (_) => ref.read(favoritesProvider.notifier).toggleFavorite(recipe.id),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(scoredRecipe: scored),
              ),
            ),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(recipe.id),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.warmCoral.withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.warmCoral.withAlpha(80),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.bookmark_rounded,
                          color: AppTheme.warmCoral,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

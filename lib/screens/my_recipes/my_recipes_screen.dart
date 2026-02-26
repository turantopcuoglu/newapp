import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/recipe.dart';
import '../../providers/my_recipes_provider.dart';
import '../../services/recommendation_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';
import 'create_recipe_screen.dart';

class MyRecipesScreen extends ConsumerWidget {
  const MyRecipesScreen({super.key});

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

  String _mealTypeLabel(MealType type, AppLocalizations l10n) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final recipes = ref.watch(myRecipesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myRecipesTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
        ),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(l10n.myRecipesEmpty,
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateRecipeScreen()),
                    ),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.myRecipesCreate),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final mealColor = _mealTypeColor(recipe.mealType);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _openRecipeDetail(context, recipe),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Meal type color indicator
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: mealColor.withAlpha(40),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _mealTypeIcon(recipe.mealType),
                              color: mealColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.localizedName(locale),
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: mealColor.withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _mealTypeLabel(recipe.mealType, l10n),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: mealColor,
                                        ),
                                      ),
                                    ),
                                    if (recipe.localizedDescription(locale)
                                        .isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          recipe.localizedDescription(locale),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.delete_outline,
                                color: Colors.red.shade300),
                            onPressed: () => _confirmDelete(
                                context, ref, recipe, l10n),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _mealTypeIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie_outlined;
    }
  }

  void _openRecipeDetail(BuildContext context, Recipe recipe) {
    final scoredRecipe = ScoredRecipe(
      recipe: recipe,
      compatibilityScore: 1.0,
      availableIngredients: recipe.ingredientIds,
      missingIngredients: [],
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(scoredRecipe: scoredRecipe),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, Recipe recipe, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(
            '${recipe.localizedName(l10n.locale.languageCode)} - ${l10n.confirm}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(myRecipesProvider.notifier)
                  .removeRecipe(recipe.id);
              Navigator.pop(ctx);
            },
            child: Text(l10n.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

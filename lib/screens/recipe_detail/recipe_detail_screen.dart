import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/ingredient_chip.dart';
import '../../components/meal_type_badge.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/mock_ingredients.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../services/recommendation_service.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final ScoredRecipe scoredRecipe;

  const RecipeDetailScreen({super.key, required this.scoredRecipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final recipe = scoredRecipe.recipe;
    final theme = Theme.of(context);
    final inventoryIds = ref.watch(inventoryIdsProvider);

    final ingredientMap = {for (final i in mockIngredients) i.id: i};

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.localizedName(locale)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header badges
            Row(
              children: [
                MealTypeBadge(mealType: recipe.mealType),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.successGreen.withAlpha(80)),
                  ),
                  child: Text(
                    '${scoredRecipe.compatibilityPercent}% ${l10n.recipeCompatibility}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(recipe.localizedDescription(locale),
                style: theme.textTheme.bodyLarge),

            const SizedBox(height: 24),

            // Nutrition card
            _buildSectionTitle(
                l10n.recipeNutrition, Icons.pie_chart_outline, theme),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NutritionItem(
                      l10n.recipeCalories,
                      '${recipe.macros.calories}',
                      'kcal',
                      AppTheme.accentOrange,
                    ),
                    _divider(),
                    _NutritionItem(
                      l10n.recipeProtein,
                      '${recipe.macros.proteinG}',
                      'g',
                      AppTheme.softLavender,
                    ),
                    _divider(),
                    _NutritionItem(
                      l10n.recipeCarbs,
                      '${recipe.macros.carbsG}',
                      'g',
                      AppTheme.accentTeal,
                    ),
                    _divider(),
                    _NutritionItem(
                      l10n.recipeFiber,
                      '${recipe.macros.fiberG}',
                      'g',
                      AppTheme.successGreen,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Ingredients
            _buildSectionTitle(
                l10n.recipeIngredients, Icons.kitchen, theme),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: recipe.ingredientIds.map((id) {
                    final ingredient = ingredientMap[id];
                    final name =
                        ingredient?.localizedName(locale) ?? id;
                    final inKitchen = inventoryIds.contains(id);
                    return IngredientChip(
                        label: name, isAvailable: inKitchen);
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Steps
            _buildSectionTitle(
                l10n.recipeSteps, Icons.format_list_numbered, theme),
            const SizedBox(height: 10),
            ...recipe
                .localizedSteps(locale)
                .asMap()
                .entries
                .map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          entry.value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 28),

            // Actions
            if (scoredRecipe.missingIngredients.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(shoppingProvider.notifier)
                        .addMissingIngredients(
                          scoredRecipe.missingIngredients,
                          forRecipeId: recipe.id,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${scoredRecipe.missingIngredients.length} items added')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(l10n.recipeAddMissing),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _showAddToPlanner(context, ref),
                icon: const Icon(Icons.calendar_today),
                label: Text(l10n.recipeAddToPlanner),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: AppTheme.dividerColor,
    );
  }

  void _showAddToPlanner(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;

    final mealType = await showDialog<MealType>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(AppLocalizations.of(context).plannerSelectMealType),
        children: MealType.values
            .map((type) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, type),
                  child:
                      Text(type.name[0].toUpperCase() + type.name.substring(1)),
                ))
            .toList(),
      ),
    );
    if (mealType == null || !context.mounted) return;

    ref.read(mealPlanProvider.notifier).addEntry(
          recipeId: scoredRecipe.recipe.id,
          date: date,
          mealType: mealType,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to planner')),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _NutritionItem(this.label, this.value, this.unit, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                )),
        Text(unit, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 11)),
      ],
    );
  }
}

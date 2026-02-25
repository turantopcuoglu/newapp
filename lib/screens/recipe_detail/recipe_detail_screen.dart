import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/ingredient_chip.dart';
import '../../components/meal_type_badge.dart';
import '../../components/section_header.dart';
import '../../core/enums.dart';
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
            // Header
            Row(
              children: [
                MealTypeBadge(mealType: recipe.mealType),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${scoredRecipe.compatibilityPercent}% ${l10n.recipeCompatibility}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(recipe.localizedDescription(locale),
                style: theme.textTheme.bodyMedium),

            // Nutrition
            SectionHeader(title: l10n.recipeNutrition),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NutritionItem(
                        l10n.recipeCalories, '${recipe.macros.calories}', 'kcal'),
                    _NutritionItem(
                        l10n.recipeProtein, '${recipe.macros.proteinG}', 'g'),
                    _NutritionItem(
                        l10n.recipeCarbs, '${recipe.macros.carbsG}', 'g'),
                    _NutritionItem(
                        l10n.recipeFiber, '${recipe.macros.fiberG}', 'g'),
                  ],
                ),
              ),
            ),

            // Ingredients
            SectionHeader(title: l10n.recipeIngredients),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: recipe.ingredientIds.map((id) {
                final ingredient = ingredientMap[id];
                final name =
                    ingredient?.localizedName(locale) ?? id;
                final inKitchen = inventoryIds.contains(id);
                return IngredientChip(label: name, isAvailable: inKitchen);
              }).toList(),
            ),

            // Steps
            SectionHeader(title: l10n.recipeSteps),
            ...recipe.localizedSteps(locale).asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: theme.colorScheme.primary.withAlpha(25),
                      child: Text('${entry.key + 1}',
                          style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(entry.value,
                          style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Actions
            if (scoredRecipe.missingIngredients.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(shoppingProvider.notifier).addMissingIngredients(
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
                  child: Text(type.name[0].toUpperCase() + type.name.substring(1)),
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

  const _NutritionItem(this.label, this.value, this.unit);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
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

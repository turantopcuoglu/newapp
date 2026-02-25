import 'package:flutter/material.dart';
import '../core/enums.dart';
import '../l10n/app_localizations.dart';
import '../models/recipe.dart';
import '../services/recommendation_service.dart';
import 'meal_type_badge.dart';

class RecipeCard extends StatelessWidget {
  final ScoredRecipe scoredRecipe;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.scoredRecipe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final recipe = scoredRecipe.recipe;
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      recipe.localizedName(locale),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  MealTypeBadge(mealType: recipe.mealType),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                recipe.localizedDescription(locale),
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _NutrientChip(
                    label: l10n.recipeProtein,
                    level: recipe.proteinLevel,
                  ),
                  const SizedBox(width: 6),
                  _NutrientChip(
                    label: l10n.recipeFiber,
                    level: recipe.fiberLevel,
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _compatibilityColor(scoredRecipe.compatibilityScore)
                          .withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${scoredRecipe.compatibilityPercent}% ${l10n.recipeCompatibility}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _compatibilityColor(
                            scoredRecipe.compatibilityScore),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (recipe.macros.calories > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '${recipe.macros.calories} kcal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _compatibilityColor(double score) {
    if (score >= 0.7) return const Color(0xFF4CAF50);
    if (score >= 0.4) return const Color(0xFFFFA726);
    return const Color(0xFFEF5350);
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final NutrientLevel level;

  const _NutrientChip({required this.label, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: ${level.name}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
      ),
    );
  }
}

/// Simpler card for recipe selection (planner, etc.)
class RecipeSelectCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeSelectCard({
    super.key,
    required this.recipe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale.languageCode;
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        title: Text(recipe.localizedName(locale),
            style: theme.textTheme.titleMedium),
        subtitle: Text(recipe.localizedDescription(locale),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: MealTypeBadge(mealType: recipe.mealType),
        onTap: onTap,
      ),
    );
  }
}

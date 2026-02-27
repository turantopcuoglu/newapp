import 'package:flutter/material.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../services/recommendation_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class MealRecommendationsScreen extends StatelessWidget {
  final MealType mealType;
  final List<ScoredRecipe> recipes;

  const MealRecommendationsScreen({
    super.key,
    required this.mealType,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(_getMealTitle(l10n)),
        backgroundColor: AppTheme.background,
      ),
      body: recipes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_menu_rounded,
                      size: 64,
                      color: AppTheme.textLight.withAlpha(120),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.recipeNoResults,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final scored = recipes[index];
                final recipe = scored.recipe;
                final macros = recipe.macros;
                final color = _getMealColor();

                // Available/missing counts
                final availableCount = scored.availableIngredients.length;
                final totalCount = recipe.ingredientIds.length;

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecipeDetailScreen(scoredRecipe: scored),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top colored bar with rank
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withAlpha(30),
                                color.withAlpha(10),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color.withAlpha(40),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  recipe.localizedName(locale),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _getCompatibilityColor(
                                          scored.compatibilityPercent)
                                      .withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${scored.compatibilityPercent}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _getCompatibilityColor(
                                        scored.compatibilityPercent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Body
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.localizedDescription(locale),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Macro chips
                              Row(
                                children: [
                                  _MacroChip(
                                    icon: Icons.local_fire_department_rounded,
                                    label: '${macros.calories} kcal',
                                    color: AppTheme.accentOrange,
                                  ),
                                  const SizedBox(width: 8),
                                  _MacroChip(
                                    icon: Icons.fitness_center_rounded,
                                    label:
                                        '${macros.proteinG}g ${l10n.recipeProtein.toLowerCase()}',
                                    color: AppTheme.accentTeal,
                                  ),
                                  const SizedBox(width: 8),
                                  _MacroChip(
                                    icon: Icons.eco_rounded,
                                    label: '${macros.fiberG}g ${l10n.recipeFiber.toLowerCase()}',
                                    color: AppTheme.successGreen,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Ingredient availability bar
                              Row(
                                children: [
                                  Icon(
                                    Icons.kitchen_rounded,
                                    size: 16,
                                    color: AppTheme.textLight,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: totalCount > 0
                                            ? availableCount / totalCount.toDouble()
                                            : 0,
                                        backgroundColor:
                                            AppTheme.dividerColor,
                                        valueColor:
                                            AlwaysStoppedAnimation(color),
                                        minHeight: 6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$availableCount/$totalCount',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: AppTheme.textLight,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getMealTitle(AppLocalizations l10n) {
    switch (mealType) {
      case MealType.breakfast:
        return l10n.homeMealBreakfastTitle;
      case MealType.lunch:
        return l10n.homeMealLunchTitle;
      case MealType.dinner:
        return l10n.homeMealDinnerTitle;
      case MealType.snack:
        return l10n.homeMealSnackTitle;
    }
  }

  Color _getMealColor() {
    switch (mealType) {
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

  Color _getCompatibilityColor(int percent) {
    if (percent >= 70) return AppTheme.successGreen;
    if (percent >= 40) return AppTheme.warningAmber;
    return AppTheme.warmCoral;
  }
}

class _MacroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MacroChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

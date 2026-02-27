import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/ingredient_nutrition_data.dart';
import '../l10n/app_localizations.dart';

/// Displays a real-time nutrition summary based on selected ingredients and
/// their serving sizes in grams.
class NutritionLiveCard extends StatelessWidget {
  /// Map of ingredient id → serving weight in grams.
  final Map<String, double> servings;

  const NutritionLiveCard({super.key, required this.servings});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Calculate totals
    double totalCal = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    for (final entry in servings.entries) {
      final nutrition = ingredientNutritionData[entry.key];
      if (nutrition == null) continue;
      final factor = entry.value / 100.0;
      totalCal += nutrition.caloriesPer100g * factor;
      totalProtein += nutrition.proteinPer100g * factor;
      totalCarbs += nutrition.carbsPer100g * factor;
      totalFat += nutrition.fatPer100g * factor;
      totalFiber += nutrition.fiberPer100g * factor;
    }

    if (servings.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2838), Color(0xFF2D3E50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_fire_department,
                    color: AppTheme.accentOrange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.nutritionLive,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${servings.length} ${l10n.recipeIngredients.toLowerCase()}',
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Calorie highlight
          Center(
            child: Column(
              children: [
                Text(
                  '${totalCal.round()}',
                  style: const TextStyle(
                    color: AppTheme.accentOrange,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  l10n.recipeCalories,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Macro bars
          Row(
            children: [
              _MacroItem(
                label: l10n.recipeProtein,
                value: totalProtein,
                color: const Color(0xFF5B6FE6),
                icon: Icons.fitness_center,
              ),
              const SizedBox(width: 8),
              _MacroItem(
                label: l10n.recipeCarbs,
                value: totalCarbs,
                color: AppTheme.warningAmber,
                icon: Icons.bolt,
              ),
              const SizedBox(width: 8),
              _MacroItem(
                label: l10n.recipeFat,
                value: totalFat,
                color: AppTheme.warmCoral,
                icon: Icons.opacity,
              ),
              const SizedBox(width: 8),
              _MacroItem(
                label: l10n.recipeFiber,
                value: totalFiber,
                color: AppTheme.successGreen,
                icon: Icons.eco,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              '${value.round()}g',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

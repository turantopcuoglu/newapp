import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/mock_ingredients.dart';
import '../l10n/app_localizations.dart';
import '../models/recipe.dart';
import '../services/quantity_format.dart';
import '../services/step_ingredient_matcher.dart';

/// The ingredients one step uses, each with its amount: "Zeytinyağı ·
/// 1 yemek kaşığı". The amount is the recipe's whole amount; when the
/// ingredient comes back in another step it is marked "toplam" so nobody
/// pours it all in at the first mention.
class StepIngredients extends StatelessWidget {
  final Recipe recipe;
  final int step;

  /// Precomputed [stepIngredientsFor] when the caller already has it.
  final List<List<String>>? perStep;
  final bool large;

  const StepIngredients({
    super.key,
    required this.recipe,
    required this.step,
    this.perStep,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final all = perStep ?? stepIngredientsFor(recipe);
    if (step >= all.length || all[step].isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final names = {for (final i in mockIngredients) i.id: i};
    final uses = <String, int>{};
    for (final ids in all) {
      for (final id in ids) {
        uses[id] = (uses[id] ?? 0) + 1;
      }
    }
    final palette = context.palette;
    final size = large ? 15.0 : 13.0;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final id in all[step])
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: large ? 12 : 10,
              vertical: large ? 8 : 5,
            ),
            decoration: BoxDecoration(
              color: palette.mint.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.mint.withValues(alpha: .35)),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: names[id]?.localizedName(locale) ?? id,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  if (formatQuantity(recipe.quantities[id], l10n)
                      case final amount?)
                    TextSpan(
                      text: ' · $amount',
                      style: TextStyle(color: palette.textPrimary),
                    ),
                  if ((uses[id] ?? 0) > 1 && recipe.quantities[id] != null)
                    TextSpan(
                      text: locale == 'tr' ? ' (toplam)' : ' (total)',
                      style: TextStyle(color: palette.textSecondary),
                    ),
                ],
              ),
              style: TextStyle(fontSize: size, height: 1.3),
            ),
          ),
      ],
    );
  }
}

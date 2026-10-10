import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/empty_state_artwork.dart';
import '../../components/health_recipe_card.dart';
import '../../components/ingredient_image.dart';
import '../../components/preference_warning.dart';
import '../../core/theme.dart';
import '../../data/explore_data.dart';
import '../../data/ingredient_visual.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/preference_matcher.dart';
import '../../services/recommendation_service.dart';
import '../../services/special_category_matcher.dart';
import '../recipe_detail/recipe_detail_screen.dart';

/// Recipes of a health category, optionally narrowed to one ingredient.
///
/// With [ingredientId] set this is the page behind a product tile — e.g.
/// "Avocado" under magnesium — and it lists only recipes that carry both the
/// ingredient and the condition. Without it, the full category list.
class HealthRecipeListScreen extends ConsumerWidget {
  final SpecialCategory category;
  final String? ingredientId;

  const HealthRecipeListScreen({
    super.key,
    required this.category,
    this.ingredientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    // Browsable, not "safe": a disliked food or a diet preference must not
    // empty this page out, it only pushes those recipes down.
    final scored = ref.watch(browsableScoredRecipesProvider);
    final profile = ref.watch(profileProvider);

    final recipes = scored.where((sr) {
      final id = ingredientId;
      return id == null
          ? matchesSpecialCategory(sr.recipe, category)
          : matchesCategoryIngredient(sr.recipe, category, id);
    }).toList();

    final ingredient = ingredientId == null
        ? null
        : ingredientById(ingredientId!);
    final title = ingredient?.localizedName(locale) ?? l10n.healthAllRecipes;

    // The warning names the ingredient when there is one, otherwise it speaks
    // for the demoted recipes further down the list.
    final warningFit = ingredient != null
        ? ingredientPreferenceFit(ingredient, profile)
        : _listFitOf(recipes);

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.background,
        foregroundColor: context.palette.textPrimary,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            if (ingredientId != null) ...[
              SizedBox.square(
                dimension: 36,
                child: IngredientImage(id: ingredientId!),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${category.localizedName(locale)} · '
                    '${l10n.healthRecipeCount(recipes.length)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: context.palette.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const EmptyStateArtwork(name: 'no_results'),
                    const SizedBox(height: 16),
                    Text(
                      l10n.healthIngredientEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.palette.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                if (!warningFit.fits) ...[
                  PreferenceWarningCard(
                    fit: warningFit,
                    subject: ingredient?.localizedName(locale),
                  ),
                  const SizedBox(height: 14),
                ],
                ...recipes.map(
                  (sr) => HealthRecipeCard(
                    scored: sr,
                    locale: locale,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(scoredRecipe: sr),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// Combined reasons across the demoted recipes, so the banner above a whole
  /// list says the same thing the cards below it do.
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

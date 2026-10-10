import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/category_cover.dart';
import '../../components/health_recipe_card.dart';
import '../../components/ingredient_image.dart';
import '../../components/preference_warning.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import '../../data/explore_data.dart';
import '../../data/health_category_info.dart';
import '../../data/ingredient_visual.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/preference_matcher.dart';
import '../../services/special_category_matcher.dart';
import '../recipe_detail/recipe_detail_screen.dart';
import 'health_recipe_list_screen.dart';

/// One health category: what the condition means, then its recipes grouped by
/// the ingredient that carries them.
///
/// The flat recipe list this screen used to be never explained *why* those
/// recipes were picked, and scrolling 100 cards is not browsing. Now the page
/// reads top to bottom: header → explanation → ingredient tiles, each tile
/// opening the recipes that contain that ingredient and match the condition.
class SpecialDetailScreen extends ConsumerWidget {
  final SpecialCategory category;

  const SpecialDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    // Browsable: allergens are out, preferences only reorder. Counting from
    // the same list the tiles open means the numbers cannot lie.
    final scoredRecipes = ref.watch(browsableScoredRecipesProvider);
    final profile = ref.watch(profileProvider);
    final browsable = scoredRecipes.map((sr) => sr.recipe).toList();

    final filteredRecipes = scoredRecipes
        .where((sr) => matchesSpecialCategory(sr.recipe, category))
        .toList();

    final info = healthCategoryInfo[category.id];

    // Ingredients the user avoids stay on the page, they just move to the
    // end and carry a warning — the tile disappearing was the bug.
    final ingredientFits = {
      for (final id in healthCategoryIngredients(category, browsable))
        id: ingredientById(id) == null
            ? PreferenceFit.clean
            : ingredientPreferenceFit(ingredientById(id)!, profile),
    };
    final ingredientIds = ingredientFits.keys.toList()
      ..sort(
        (a, b) =>
            ingredientFits[a]!.demotion.compareTo(ingredientFits[b]!.demotion),
      );

    final accent = context.palette.mint;

    return Scaffold(
      backgroundColor: context.palette.background,
      body: CustomScrollView(
        slivers: [
          // Shared photo cover and readable title.
          SliverToBoxAdapter(
            child: CategoryCoverHeader(
              imagePath: category.coverImage,
              title: category.localizedName(locale),
              subtitle: category.localizedSubtitle(locale),
              count: l10n.healthRecipeCount(filteredRecipes.length),
            ),
          ),

          // Explanation of the condition.
          if (info != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                child: _HealthInfoCard(
                  info: info,
                  locale: locale,
                  l10n: l10n,
                  accent: accent,
                ),
              ),
            ),

          // Ingredient tiles: photo, name, how many recipes it opens.
          if (ingredientIds.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.healthIngredientsTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.healthIngredientsHint,
                            style: TextStyle(
                              color: context.palette.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // The tiles cover the ingredients we wrote about; this
                    // keeps the whole category reachable in one tap.
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HealthRecipeListScreen(category: category),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        foregroundColor: accent,
                      ),
                      child: Text(
                        l10n.healthAllRecipes,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  // Photo plus two lines of text; the text part grows with
                  // the user's font size instead of eating the photo.
                  mainAxisExtent:
                      210 +
                      (MediaQuery.textScalerOf(context).scale(15) - 15) * 4,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final id = ingredientIds[index];
                  final count = browsable
                      .where((r) => matchesCategoryIngredient(r, category, id))
                      .length;
                  return _IngredientTile(
                    ingredientId: id,
                    locale: locale,
                    recipeCount: count,
                    fit: ingredientFits[id]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HealthRecipeListScreen(
                          category: category,
                          ingredientId: id,
                        ),
                      ),
                    ),
                  );
                }, childCount: ingredientIds.length),
              ),
            ),
          ] else
            // No editorial ingredients for this category yet: fall back to the
            // plain list rather than showing an empty page.
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final scored = filteredRecipes[index];
                  return HealthRecipeCard(
                    scored: scored,
                    locale: locale,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailScreen(scoredRecipe: scored),
                      ),
                    ),
                  );
                }, childCount: filteredRecipes.length),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Condition explanation ─────────────────────────────────────────────────

class _HealthInfoCard extends StatelessWidget {
  final HealthCategoryInfo info;
  final String locale;
  final AppLocalizations l10n;
  final Color accent;

  const _HealthInfoCard({
    required this.info,
    required this.locale,
    required this.l10n,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accent.withAlpha(28),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.healthAboutTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            info.localizedSummary(locale),
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: context.palette.textPrimary,
            ),
          ),
          for (final section in info.sections) ...[
            const SizedBox(height: 16),
            Text(
              section.localizedTitle(locale),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
            const SizedBox(height: 6),
            ...section
                .localizedItems(locale)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: accent.withAlpha(150),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: context.palette.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          // Shown only once the physician has signed the entry off.
          if (info.visibleRedFlags(locale) case final flags
              when flags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.palette.warmCoral),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale == 'tr'
                        ? 'Şu durumlarda hekimine başvur'
                        : 'See a doctor if you have',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (final flag in flags)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $flag',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Text(
            l10n.healthInfoDisclaimer,
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: context.palette.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ingredient tile ───────────────────────────────────────────────────────

class _IngredientTile extends StatelessWidget {
  final String ingredientId;
  final String locale;
  final int recipeCount;
  final PreferenceFit fit;
  final VoidCallback onTap;

  const _IngredientTile({
    required this.ingredientId,
    required this.locale,
    required this.recipeCount,
    required this.fit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name =
        ingredientById(ingredientId)?.localizedName(locale) ?? ingredientId;

    return Semantics(
      button: true,
      child: MotionTap(
        onTap: onTap,
        builder: (context, _) => Opacity(
          // Still tappable, just visibly out of the way.
          opacity: fit.fits ? 1 : 0.55,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.palette.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: IngredientImage(id: ingredientId)),
                      if (!fit.fits)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Tooltip(
                            message: preferenceReasons(fit, l10n).join(' · '),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: context.palette.background.withAlpha(
                                  200,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: context.palette.textPrimary,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.healthRecipeCount(recipeCount),
                  style: TextStyle(
                    color: context.palette.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

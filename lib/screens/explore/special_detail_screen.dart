import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/health_recipe_card.dart';
import '../../core/theme.dart';
import '../../data/explore_data.dart';
import '../../data/health_category_info.dart';
import '../../data/ingredient_visual.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/recipe_provider.dart';
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
    final scoredRecipes = ref.watch(safeScoredRecipesProvider);
    final allRecipes = ref.watch(allRecipesProvider);

    final filteredRecipes = scoredRecipes
        .where((sr) => matchesSpecialCategory(sr.recipe, category))
        .toList();

    final info = healthCategoryInfo[category.id];
    final ingredientIds = healthCategoryIngredients(category, allRecipes);

    final gradientColors =
        cuisineGradients[category.gradient] ?? cuisineGradients['healthy']!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header — unchanged: emoji, name, subtitle and the recipe count.
          SliverToBoxAdapter(
            child: _CategoryHeader(
              category: category,
              locale: locale,
              recipeCount: filteredRecipes.length,
              gradientColors: gradientColors,
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
                  accent: Color(gradientColors[0]),
                ),
              ),
            ),

          // Ingredient tiles, in the world-cuisine card style.
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
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
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
                        foregroundColor: Color(gradientColors[0]),
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
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final id = ingredientIds[index];
                    final count = allRecipes
                        .where((r) =>
                            matchesCategoryIngredient(r, category, id))
                        .length;
                    return _IngredientTile(
                      ingredientId: id,
                      locale: locale,
                      recipeCount: count,
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
                  },
                  childCount: ingredientIds.length,
                ),
              ),
            ),
          ] else
            // No editorial ingredients for this category yet: fall back to the
            // plain list rather than showing an empty page.
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                  },
                  childCount: filteredRecipes.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _CategoryHeader extends StatelessWidget {
  final SpecialCategory category;
  final String locale;
  final int recipeCount;
  final List<int> gradientColors;

  const _CategoryHeader({
    required this.category,
    required this.locale,
    required this.recipeCount,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(gradientColors[0]), Color(gradientColors[1])],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.localizedName(locale),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.localizedSubtitle(locale),
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$recipeCount ${l10n.recipeBookTotalRecipes}',
              style: TextStyle(
                color: Colors.white.withAlpha(230),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
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
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppTheme.textPrimary,
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
            ...section.localizedItems(locale).map(
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
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.45,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
          const SizedBox(height: 14),
          Text(
            l10n.healthInfoDisclaimer,
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: AppTheme.textLight,
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
  final VoidCallback onTap;

  const _IngredientTile({
    required this.ingredientId,
    required this.locale,
    required this.recipeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = ingredientGradient(ingredientId);
    final name =
        ingredientById(ingredientId)?.localizedName(locale) ?? ingredientId;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(colors[0]), Color(colors[1])],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(colors[0]).withAlpha(55),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Oversized watermark, same trick the cuisine tiles use.
            Positioned(
              right: -6,
              bottom: -10,
              child: Text(
                ingredientEmoji(ingredientId),
                style: TextStyle(
                  fontSize: 64,
                  color: Colors.white.withAlpha(35),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        ingredientEmoji(ingredientId),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.healthRecipeCount(recipeCount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

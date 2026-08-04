import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/explore_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/diet_classifier.dart';
import '../../services/special_category_matcher.dart';
import 'cuisine_detail_screen.dart';
import 'special_detail_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 8,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.navExplore,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.exploreSubtitle,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tab bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: const Color(0xFF0096C7),
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      labelPadding: EdgeInsets.zero,
                      padding: const EdgeInsets.all(4),
                      tabs: [
                        Tab(text: l10n.exploreWorldCuisine),
                        Tab(text: l10n.exploreSpecialForYou),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _WorldCuisineGrid(locale: locale),
            _SpecialCategoryGrid(locale: locale),
          ],
        ),
      ),
    );
  }
}

// ── World Cuisine Grid ────────────────────────────────────────────────────

class _WorldCuisineGrid extends ConsumerWidget {
  final String locale;

  const _WorldCuisineGrid({required this.locale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = ref.watch(recipeMapProvider);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: worldCuisines.length,
      itemBuilder: (context, index) {
        final cuisine = worldCuisines[index];
        final recipeCount = allRecipes.values
            .where((r) => r.cuisineIds.contains(cuisine.id))
            .length;
        return _CuisineTile(
          cuisine: cuisine,
          recipeCount: recipeCount,
          locale: locale,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CuisineDetailScreen(cuisine: cuisine),
            ),
          ),
        );
      },
    );
  }
}

class _CuisineTile extends StatelessWidget {
  final CuisineCategory cuisine;
  final int recipeCount;
  final String locale;
  final VoidCallback onTap;

  const _CuisineTile({
    required this.cuisine,
    required this.recipeCount,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = cuisineGradients[cuisine.gradient] ??
        cuisineGradients['healthy']!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(colors[0]), Color(colors[1])],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Color(colors[0]).withAlpha(60),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background emoji pattern
            Positioned(
              right: -8,
              bottom: -8,
              child: Text(
                cuisine.emoji,
                style: TextStyle(
                  fontSize: 72,
                  color: Colors.white.withAlpha(35),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        cuisine.emoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    cuisine.localizedName(locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$recipeCount ${AppLocalizations.of(context).recipeBookTotalRecipes}',
                      style: TextStyle(
                        color: Colors.white.withAlpha(230),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
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

// ── Special Category Grid ─────────────────────────────────────────────────

class _SpecialCategoryGrid extends ConsumerWidget {
  final String locale;

  const _SpecialCategoryGrid({required this.locale});

  /// Diet preference ids mapped to the category that represents them.
  static const Map<String, String> _preferenceToCategory = {
    DietClassifier.glutenFree: 'glutenFree',
    DietClassifier.dairyFree: 'lactoseFree',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);
    final selectedConditions = profile.healthConditions;
    final recipes = ref.watch(allRecipesProvider);

    // This tab is the only way into health areas now, so nothing is filtered
    // out: the user's own areas come first and the rest stay browsable.
    final mineIds = <String>{
      for (final c in specialCategories)
        if (c.healthCondition != null &&
            selectedConditions.contains(c.healthCondition))
          c.id,
      for (final preference in profile.dietPreferences)
        if (_preferenceToCategory.containsKey(preference))
          _preferenceToCategory[preference]!,
    };

    final visibleCategories = [
      ...specialCategories.where((c) => mineIds.contains(c.id)),
      ...specialCategories.where((c) => !mineIds.contains(c.id)),
    ];

    return CustomScrollView(
      slivers: [
        // Health condition selection header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.medical_information_outlined,
                      color: AppTheme.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.healthConditionSelectTitle,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.healthConditionSelectSubtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: HealthCondition.values.map((condition) {
                    final isSelected = selectedConditions.contains(condition);
                    final cat = specialCategories.firstWhere(
                      (c) => c.healthCondition == condition,
                    );
                    final colors =
                        cuisineGradients[cat.gradient] ??
                        cuisineGradients['healthy']!;
                    return GestureDetector(
                      onTap: () => ref
                          .read(profileProvider.notifier)
                          .toggleHealthCondition(condition),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(colors[0]).withAlpha(25)
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(colors[0])
                                : AppTheme.dividerColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cat.emoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              cat.localizedName(locale),
                              style: TextStyle(
                                color: isSelected
                                    ? Color(colors[0])
                                    : AppTheme.textSecondary,
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.check_circle_rounded,
                                color: Color(colors[0]),
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (selectedConditions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => ref
                        .read(profileProvider.notifier)
                        .updateHealthConditions([]),
                    child: Text(
                      l10n.healthConditionClearAll,
                      style: TextStyle(
                        color: AppTheme.accentTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Divider
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: AppTheme.dividerColor, height: 1),
          ),
        ),

        // Category grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              // Taller than the text needs: the tiles now carry a recipe
              // count under the subtitle and must not clip it.
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = visibleCategories[index];
                return _SpecialTile(
                  category: category,
                  locale: locale,
                  isMine: mineIds.contains(category.id),
                  // Same matcher the detail screen uses, so the count on the
                  // tile is exactly the list the user lands on.
                  recipeCount: recipes
                      .where((r) => matchesSpecialCategory(r, category))
                      .length,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SpecialDetailScreen(category: category),
                    ),
                  ),
                );
              },
              childCount: visibleCategories.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _SpecialTile extends StatelessWidget {
  final SpecialCategory category;
  final String locale;
  final bool isMine;
  final int recipeCount;
  final VoidCallback onTap;

  const _SpecialTile({
    required this.category,
    required this.locale,
    required this.isMine,
    required this.recipeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = cuisineGradients[category.gradient] ??
        cuisineGradients['healthy']!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(colors[0]), Color(colors[1])],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Color(colors[0]).withAlpha(60),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background emoji
            Positioned(
              right: -8,
              bottom: -8,
              child: Text(
                category.emoji,
                style: TextStyle(
                  fontSize: 72,
                  color: Colors.white.withAlpha(35),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Emoji badge
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            category.emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isMine)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(45),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    category.localizedName(locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.localizedSubtitle(locale),
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

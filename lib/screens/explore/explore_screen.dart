import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/category_cover.dart';
import '../../components/health_condition_chips.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import '../../data/explore_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/diet_classifier.dart';
import '../../services/special_category_matcher.dart';
import '../wellness/moonlit_page.dart';
import 'cuisine_detail_screen.dart';
import 'special_detail_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});
  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
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
      backgroundColor: context.palette.background,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(),
                  ),
                  SceneTitle(
                    title: l10n.navExplore,
                    subtitle: l10n.exploreSubtitle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: context.palette.mint,
                      unselectedLabelColor: context.palette.textSecondary,
                      indicatorColor: context.palette.mint,
                      dividerColor: context.palette.dividerColor,
                      tabs: [
                        Tab(text: l10n.exploreWorldCuisine),
                        Tab(text: l10n.exploreSpecialForYou),
                      ],
                    ),
                  ),
                ],
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
      ),
    );
  }
}

SliverGridDelegate _grid(BuildContext context, {bool detailed = false}) =>
    SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      // Text grows without stealing the photograph's entire visible area.
      mainAxisExtent:
          (detailed ? 260 : 205) +
          (MediaQuery.textScalerOf(context).scale(14) - 14) *
              (detailed ? 9 : 6),
    );

class _WorldCuisineGrid extends ConsumerWidget {
  final String locale;
  const _WorldCuisineGrid({required this.locale});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(browsableScoredRecipesProvider);
    final l10n = AppLocalizations.of(context);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      gridDelegate: _grid(context),
      itemCount: worldCuisines.length,
      itemBuilder: (context, index) {
        final cuisine = worldCuisines[index];
        final count = recipes
            .where((r) => r.recipe.cuisineIds.contains(cuisine.id))
            .length;
        return _CategoryTile(
          imagePath: cuisine.coverImage,
          title: cuisine.localizedName(locale),
          count: '$count ${l10n.recipeBookTotalRecipes}',
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

class _SpecialCategoryGrid extends ConsumerWidget {
  final String locale;
  const _SpecialCategoryGrid({required this.locale});
  static const _preferenceToCategory = {
    DietClassifier.glutenFree: 'glutenFree',
    DietClassifier.dairyFree: 'lactoseFree',
  };
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);
    final recipes = ref.watch(browsableScoredRecipesProvider);
    final mineIds = <String>{
      for (final c in specialCategories)
        if (c.healthCondition != null &&
            profile.healthConditions.contains(c.healthCondition))
          c.id,
      for (final preference in profile.dietPreferences)
        if (_preferenceToCategory.containsKey(preference))
          _preferenceToCategory[preference]!,
    };
    final categories = [
      ...specialCategories.where((c) => mineIds.contains(c.id)),
      ...specialCategories.where((c) => !mineIds.contains(c.id)),
    ];
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.healthConditionSelectTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.healthConditionSelectSubtitle,
                  style: TextStyle(
                    color: context.palette.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                const HealthConditionChips(),
                if (profile.healthConditions.isNotEmpty)
                  TextButton(
                    onPressed: () => ref
                        .read(profileProvider.notifier)
                        .updateHealthConditions([]),
                    child: Text(l10n.healthConditionClearAll),
                  ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          sliver: SliverGrid(
            gridDelegate: _grid(context, detailed: true),
            delegate: SliverChildBuilderDelegate((context, index) {
              final category = categories[index];
              final count = recipes
                  .where((r) => matchesSpecialCategory(r.recipe, category))
                  .length;
              return _CategoryTile(
                imagePath: category.coverImage,
                title: category.localizedName(locale),
                subtitle: category.localizedSubtitle(locale),
                count: l10n.healthRecipeCount(count),
                isMine: mineIds.contains(category.id),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpecialDetailScreen(category: category),
                  ),
                ),
              );
            }, childCount: categories.length),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String imagePath, title, count;
  final String? subtitle;
  final bool isMine;
  final VoidCallback onTap;
  const _CategoryTile({
    required this.imagePath,
    required this.title,
    required this.count,
    required this.onTap,
    this.subtitle,
    this.isMine = false,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: MotionTap(
      onTap: onTap,
      builder: (context, _) => CategoryCover(
        imagePath: imagePath,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMine)
                const Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              const Spacer(),
              Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

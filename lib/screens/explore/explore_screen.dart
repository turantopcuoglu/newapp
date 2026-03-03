import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../data/explore_data.dart';
import '../../l10n/app_localizations.dart';
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

class _WorldCuisineGrid extends StatelessWidget {
  final String locale;

  const _WorldCuisineGrid({required this.locale});

  @override
  Widget build(BuildContext context) {
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
        return _CuisineTile(
          cuisine: cuisine,
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
  final String locale;
  final VoidCallback onTap;

  const _CuisineTile({
    required this.cuisine,
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
                      '${cuisine.recipeIds.length} ${AppLocalizations.of(context).recipeBookTotalRecipes}',
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

class _SpecialCategoryGrid extends StatelessWidget {
  final String locale;

  const _SpecialCategoryGrid({required this.locale});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: specialCategories.length,
      itemBuilder: (context, index) {
        final category = specialCategories[index];
        return _SpecialTile(
          category: category,
          locale: locale,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SpecialDetailScreen(category: category),
            ),
          ),
        );
      },
    );
  }
}

class _SpecialTile extends StatelessWidget {
  final SpecialCategory category;
  final String locale;
  final VoidCallback onTap;

  const _SpecialTile({
    required this.category,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

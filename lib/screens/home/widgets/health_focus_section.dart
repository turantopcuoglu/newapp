import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../data/explore_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/recipe_provider.dart';
import '../../../services/diet_classifier.dart';
import '../../../services/special_category_matcher.dart';
import '../../explore/special_detail_screen.dart';

/// Surfaces health areas on the home screen.
///
/// The profile already knows the user's health conditions and diet
/// preferences, but until now that only reordered a tab two taps away. Here
/// the areas they picked come first as full-width cards, and the rest stay
/// browsable in a strip below so the feature is discoverable even before the
/// profile is filled in.
class HealthFocusSection extends ConsumerWidget {
  const HealthFocusSection({super.key});

  /// Diet preference ids mapped to the category that represents them.
  static const Map<String, String> _preferenceToCategory = {
    DietClassifier.glutenFree: 'glutenFree',
    DietClassifier.dairyFree: 'lactoseFree',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider);
    final recipes = ref.watch(allRecipesProvider);

    // A user's areas come from two places: declared conditions and the diet
    // preferences they set for filtering.
    final mineIds = <String>{
      for (final c in specialCategories)
        if (c.healthCondition != null &&
            profile.healthConditions.contains(c.healthCondition))
          c.id,
      for (final preference in profile.dietPreferences)
        if (_preferenceToCategory.containsKey(preference))
          _preferenceToCategory[preference]!,
    };

    final mine =
        specialCategories.where((c) => mineIds.contains(c.id)).toList();
    final others =
        specialCategories.where((c) => !mineIds.contains(c.id)).toList();

    int countFor(SpecialCategory category) =>
        recipes.where((r) => matchesSpecialCategory(r, category)).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mine.isNotEmpty) ...[
          _SectionHeading(
            title: l10n.healthForYouTitle,
            subtitle: l10n.healthForYouHint,
            icon: Icons.favorite_rounded,
            color: AppTheme.warmCoral,
            theme: theme,
          ),
          const SizedBox(height: 10),
          ...mine.map((category) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WideHealthCard(
                  category: category,
                  locale: locale,
                  recipeCount: countFor(category),
                  onTap: () => _open(context, category),
                ),
              )),
          const SizedBox(height: 18),
        ],
        _SectionHeading(
          title: l10n.healthExploreTitle,
          subtitle: mine.isEmpty
              ? l10n.healthSetUpPrompt
              : l10n.healthExploreHint,
          icon: Icons.health_and_safety_rounded,
          color: AppTheme.accentTeal,
          theme: theme,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: others.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = others[index];
              return _CompactHealthCard(
                category: category,
                locale: locale,
                recipeCount: countFor(category),
                onTap: () => _open(context, category),
              );
            },
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context, SpecialCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SpecialDetailScreen(category: category),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final ThemeData theme;

  const _SectionHeading({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withAlpha(28),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Full-width card for an area the user actually has.
class _WideHealthCard extends StatelessWidget {
  final SpecialCategory category;
  final String locale;
  final int recipeCount;
  final VoidCallback onTap;

  const _WideHealthCard({
    required this.category,
    required this.locale,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(colors[0]), Color(colors[1])],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Color(colors[0]).withAlpha(50),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.localizedName(locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    category.localizedSubtitle(locale),
                    style: TextStyle(
                      color: Colors.white.withAlpha(210),
                      fontSize: 12,
                      height: 1.25,
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
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Compact tile used in the discovery strip.
class _CompactHealthCard extends StatelessWidget {
  final SpecialCategory category;
  final String locale;
  final int recipeCount;
  final VoidCallback onTap;

  const _CompactHealthCard({
    required this.category,
    required this.locale,
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
        width: 132,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(colors[0]), Color(colors[1])],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 24)),
            const Spacer(),
            Text(
              category.localizedName(locale),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              l10n.healthRecipeCount(recipeCount),
              style: TextStyle(
                color: Colors.white.withAlpha(205),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

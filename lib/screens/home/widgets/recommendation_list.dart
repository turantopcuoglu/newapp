import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums.dart';
import '../../../components/recipe_card.dart';
import '../../../components/section_header.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/recipe_provider.dart';
import '../../../services/recommendation_service.dart';
import '../../recipe_detail/recipe_detail_screen.dart';

class RecommendationList extends ConsumerWidget {
  const RecommendationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recommendations = ref.watch(recommendationsProvider);

    if (recommendations == null) {
      return const SizedBox.shrink();
    }

    final sections = <Widget>[];

    for (final mealType in MealType.values) {
      final recipes = recommendations[mealType] ?? [];
      if (recipes.isEmpty) continue;

      sections.add(SectionHeader(title: _mealTypeLabel(l10n, mealType)));
      sections.addAll(recipes.take(5).map((sr) => RecipeCard(
            scoredRecipe: sr,
            onTap: () => _openDetail(context, sr),
          )));
    }

    if (sections.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l10n.recipeNoResults,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  void _openDetail(BuildContext context, ScoredRecipe sr) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(scoredRecipe: sr),
      ),
    );
  }

  String _mealTypeLabel(AppLocalizations l10n, MealType type) {
    switch (type) {
      case MealType.breakfast:
        return l10n.recipeBreakfast;
      case MealType.lunch:
        return l10n.recipeLunch;
      case MealType.dinner:
        return l10n.recipeDinner;
      case MealType.snack:
        return l10n.recipeSnack;
    }
  }
}

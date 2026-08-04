import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';

/// Toggles a recipe in "Saved Recipes".
///
/// Saving lives in exactly one place — [favoritesProvider] — so every preview
/// card and the detail screen can drop this widget in and stay in sync: tap it
/// anywhere and every other copy on screen flips with it.
class SaveRecipeButton extends ConsumerWidget {
  final String recipeId;

  /// Size of the tappable square. 44 matches the explore cards.
  final double size;

  const SaveRecipeButton({
    super.key,
    required this.recipeId,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isSaved = ref.watch(favoritesProvider).contains(recipeId);

    return Tooltip(
      message: isSaved ? l10n.recipeUnsave : l10n.recipeSave,
      child: GestureDetector(
        onTap: () => toggleSavedRecipe(context, ref, recipeId),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isSaved
                ? AppTheme.warmCoral.withAlpha(20)
                : AppTheme.background,
            borderRadius: BorderRadius.circular(size * 0.32),
            border: Border.all(
              color: isSaved
                  ? AppTheme.warmCoral.withAlpha(80)
                  : AppTheme.dividerColor,
              width: 1.5,
            ),
          ),
          child: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: isSaved ? AppTheme.warmCoral : AppTheme.textLight,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// Full-width labelled variant for the recipe detail screen, where it sits
/// next to the other primary actions.
class SaveRecipeWideButton extends ConsumerWidget {
  final String recipeId;

  const SaveRecipeWideButton({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isSaved = ref.watch(favoritesProvider).contains(recipeId);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => toggleSavedRecipe(context, ref, recipeId),
        icon: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        ),
        label: Text(isSaved ? l10n.recipeUnsave : l10n.recipeSave),
        style: OutlinedButton.styleFrom(
          foregroundColor: isSaved ? AppTheme.warmCoral : null,
          side: isSaved
              ? const BorderSide(color: AppTheme.warmCoral, width: 1.5)
              : null,
        ),
      ),
    );
  }
}

/// Flips the saved state and confirms it, so a tap on a small icon does not
/// leave the user guessing whether it registered.
void toggleSavedRecipe(BuildContext context, WidgetRef ref, String recipeId) {
  final l10n = AppLocalizations.of(context);
  final wasSaved = ref.read(favoritesProvider).contains(recipeId);
  ref.read(favoritesProvider.notifier).toggleFavorite(recipeId);

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(wasSaved ? l10n.recipeUnsaved : l10n.recipeSaved),
        duration: const Duration(milliseconds: 1500),
      ),
    );
}

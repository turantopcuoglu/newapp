import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../services/diet_classifier.dart';
import '../services/preference_matcher.dart';
import '../screens/settings_screen.dart';

/// Human-readable reasons behind a [PreferenceFit], e.g. "Vegan", "Disliked".
List<String> preferenceReasons(PreferenceFit fit, AppLocalizations l10n) {
  final labels = {
    DietClassifier.vegetarian: l10n.dietVegetarian,
    DietClassifier.vegan: l10n.dietVegan,
    DietClassifier.glutenFree: l10n.dietGlutenFree,
    DietClassifier.dairyFree: l10n.dietDairyFree,
  };
  return [
    for (final preference in fit.unmetDietPreferences)
      labels[preference] ?? preference,
    if (fit.dislikedIngredientIds.isNotEmpty) l10n.preferenceReasonDisliked,
  ];
}

/// Small chip on a card that does not match the user's preferences.
class PreferenceMismatchChip extends StatelessWidget {
  final PreferenceFit fit;

  const PreferenceMismatchChip({super.key, required this.fit});

  @override
  Widget build(BuildContext context) {
    if (fit.fits) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    // The short label keeps the chip inside a card; the full reasons live in
    // the tooltip and in the banner above the list.
    return Tooltip(
      message: preferenceReasons(fit, l10n).join(' · '),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.warningAmber.withAlpha(22),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 11, color: AppTheme.warningAmber),
            const SizedBox(width: 4),
            Text(
              l10n.preferenceMismatchShort,
              style: const TextStyle(
                color: AppTheme.warningAmber,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Explains why an ingredient or a list sits at the bottom, and offers the
/// one thing that changes it: editing the diet preferences.
class PreferenceWarningCard extends StatelessWidget {
  final PreferenceFit fit;

  /// Named ingredient the warning is about; null for a whole list.
  final String? subject;

  const PreferenceWarningCard({
    super.key,
    required this.fit,
    this.subject,
  });

  @override
  Widget build(BuildContext context) {
    if (fit.fits) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final reasons = preferenceReasons(fit, l10n).join(' · ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.warningAmber.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.warningAmber.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 18, color: AppTheme.warningAmber),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  subject == null
                      ? l10n.preferenceWarningList
                      : l10n.preferenceWarningIngredient(subject!),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (reasons.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                reasons,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.preferenceChangeCta,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accentTeal,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      size: 20, color: AppTheme.accentTeal),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

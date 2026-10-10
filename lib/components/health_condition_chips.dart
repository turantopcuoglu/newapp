import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../core/theme.dart';
import '../data/explore_data.dart';
import '../providers/profile_provider.dart';

/// The health conditions a profile can carry, as toggle chips. Their
/// names come from the matching Explore category, so the chip and the
/// category page it leads to always read the same.
class HealthConditionChips extends ConsumerWidget {
  const HealthConditionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final selected = ref.watch(profileProvider).healthConditions;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final condition in HealthCondition.values)
          _chip(context, ref, condition, selected.contains(condition), locale),
      ],
    );
  }

  Widget _chip(
    BuildContext context,
    WidgetRef ref,
    HealthCondition condition,
    bool isSelected,
    String locale,
  ) {
    final category = specialCategories.firstWhere(
      (c) => c.healthCondition == condition,
    );
    final accent = context.palette.mint;
    return FilterChip(
      selected: isSelected,
      showCheckmark: true,
      checkmarkColor: accent,
      label: Text(category.localizedName(locale)),
      side: BorderSide(
        color: isSelected ? accent : context.palette.dividerColor,
        width: isSelected ? 1.5 : 1,
      ),
      selectedColor: accent.withAlpha(30),
      onSelected: (_) =>
          ref.read(profileProvider.notifier).toggleHealthCondition(condition),
    );
  }
}

/// What the user is told every time they are asked about health
/// conditions. Selecting one changes ordering and which areas come first; it
/// never diagnoses or replaces care.
String healthConditionDisclaimer(String locale) => locale == 'tr'
    ? 'Seçtiklerin yalnızca tarif sırasını ve Keşfet\'te hangi sağlık alanlarının önde görüneceğini etkiler. Tanı koymaz, tedavinin yerine geçmez.'
    : 'Your choices only change recipe order and which health areas come first in Explore. They do not diagnose or replace care.';

Future<void> showHealthConditionSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheet) {
        final locale = Localizations.localeOf(sheet).languageCode;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locale == 'tr' ? 'Sağlık durumun' : 'Your health',
                style: Theme.of(sheet).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                healthConditionDisclaimer(locale),
                style: const TextStyle(fontSize: 13, height: 1.35),
              ),
              const SizedBox(height: 16),
              const HealthConditionChips(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(sheet),
                  child: Text(locale == 'tr' ? 'Tamam' : 'Done'),
                ),
              ),
            ],
          ),
        );
      },
    );

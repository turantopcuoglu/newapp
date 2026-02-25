import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/check_in_provider.dart';
import '../../../providers/profile_provider.dart';

class CheckInSheet extends ConsumerWidget {
  const CheckInSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);
    final currentCheckIn = ref.watch(checkInProvider);
    final theme = Theme.of(context);

    final options = <_CheckInOption>[
      _CheckInOption(CheckInType.lowEnergy, l10n.checkInLowEnergy, Icons.battery_1_bar),
      _CheckInOption(CheckInType.bloated, l10n.checkInBloated, Icons.water_drop_outlined),
      _CheckInOption(CheckInType.cravingSweets, l10n.checkInCravingSweets, Icons.cookie_outlined),
      _CheckInOption(CheckInType.cantFocus, l10n.checkInCantFocus, Icons.psychology_outlined),
      if (profile.isFemale)
        _CheckInOption(CheckInType.pms, l10n.checkInPms, Icons.favorite_border),
      _CheckInOption(CheckInType.postWorkout, l10n.checkInPostWorkout, Icons.fitness_center),
      _CheckInOption(CheckInType.feelingBalanced, l10n.checkInFeelingBalanced, Icons.balance),
      _CheckInOption(CheckInType.noSpecificIssue, l10n.checkInNoSpecificIssue, Icons.check_circle_outline),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.checkInTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(l10n.checkInSubtitle, style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((opt) {
              final isSelected = currentCheckIn == opt.type;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(opt.icon, size: 18,
                        color: isSelected ? Colors.white : theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(opt.label),
                  ],
                ),
                selected: isSelected,
                selectedColor: theme.colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                ),
                onSelected: (_) {
                  ref.read(checkInProvider.notifier).setCheckIn(opt.type);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CheckInOption {
  final CheckInType type;
  final String label;
  final IconData icon;
  const _CheckInOption(this.type, this.label, this.icon);
}

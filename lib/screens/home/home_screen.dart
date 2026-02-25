import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/check_in_provider.dart';
import '../../providers/inventory_provider.dart';
import 'widgets/check_in_sheet.dart';
import 'widgets/recommendation_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final checkIn = ref.watch(checkInProvider);
    final inventoryCount = ref.watch(inventoryProvider).length;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(l10n.homeGreeting, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(l10n.homeHowAreYou, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),

            // Check-in card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.self_improvement,
                            color: theme.colorScheme.primary, size: 24),
                        const SizedBox(width: 10),
                        Text(l10n.homeCheckIn,
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (checkIn != null) ...[
                      Chip(
                        avatar: const Icon(Icons.check, size: 16),
                        label: Text(_checkInLabel(l10n, checkIn)),
                        backgroundColor:
                            theme.colorScheme.primary.withAlpha(25),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showCheckIn(context),
                          child: Text(l10n.edit),
                        ),
                      ),
                    ] else ...[
                      Text(l10n.homeNoCheckIn,
                          style: theme.textTheme.bodySmall),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => _showCheckIn(context),
                          child: Text(l10n.homeStartCheckIn),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Kitchen inventory summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.kitchen,
                        color: theme.colorScheme.primary, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.homeKitchenInventory,
                              style: theme.textTheme.titleMedium),
                          Text('$inventoryCount ${l10n.homeItemsInKitchen}',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    if (inventoryCount > 0)
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text('$inventoryCount',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ),
                  ],
                ),
              ),
            ),

            // Recommendations
            if (checkIn != null) ...[
              const SizedBox(height: 8),
              Text(l10n.homeRecommendations,
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              const RecommendationList(),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showCheckIn(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CheckInSheet(),
    );
  }

  String _checkInLabel(AppLocalizations l10n, CheckInType type) {
    switch (type) {
      case CheckInType.lowEnergy:
        return l10n.checkInLowEnergy;
      case CheckInType.bloated:
        return l10n.checkInBloated;
      case CheckInType.cravingSweets:
        return l10n.checkInCravingSweets;
      case CheckInType.cantFocus:
        return l10n.checkInCantFocus;
      case CheckInType.pms:
        return l10n.checkInPms;
      case CheckInType.postWorkout:
        return l10n.checkInPostWorkout;
      case CheckInType.feelingBalanced:
        return l10n.checkInFeelingBalanced;
      case CheckInType.noSpecificIssue:
        return l10n.checkInNoSpecificIssue;
    }
  }
}

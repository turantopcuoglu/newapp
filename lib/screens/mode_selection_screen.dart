import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/daily_mode_provider.dart';
import '../providers/profile_provider.dart';

class ModeSelectionScreen extends ConsumerWidget {
  final VoidCallback onModeSelected;

  const ModeSelectionScreen({super.key, required this.onModeSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider);

    final generalOptions = <_ModeOption>[
      _ModeOption(
        CheckInType.lowEnergy,
        l10n.checkInLowEnergy,
        Icons.battery_1_bar_rounded,
        const Color(0xFFFF9800),
        l10n.modeDescLowEnergy,
      ),
      _ModeOption(
        CheckInType.bloated,
        l10n.checkInBloated,
        Icons.water_drop_outlined,
        const Color(0xFF42A5F5),
        l10n.modeDescBloated,
      ),
      _ModeOption(
        CheckInType.cravingSweets,
        l10n.checkInCravingSweets,
        Icons.cookie_outlined,
        const Color(0xFFE91E63),
        l10n.modeDescCravingSweets,
      ),
      _ModeOption(
        CheckInType.cantFocus,
        l10n.checkInCantFocus,
        Icons.psychology_outlined,
        const Color(0xFF7C4DFF),
        l10n.modeDescCantFocus,
      ),
      _ModeOption(
        CheckInType.postWorkout,
        l10n.checkInPostWorkout,
        Icons.fitness_center_rounded,
        const Color(0xFF26A69A),
        l10n.modeDescPostWorkout,
      ),
      _ModeOption(
        CheckInType.feelingBalanced,
        l10n.checkInFeelingBalanced,
        Icons.balance_rounded,
        AppTheme.successGreen,
        l10n.modeDescFeelingBalanced,
      ),
      _ModeOption(
        CheckInType.noSpecificIssue,
        l10n.checkInNoSpecificIssue,
        Icons.check_circle_outline_rounded,
        AppTheme.textSecondary,
        l10n.modeDescNoSpecificIssue,
      ),
    ];

    final periodOptions = <_ModeOption>[
      _ModeOption(
        CheckInType.pms,
        l10n.checkInPms,
        Icons.favorite_border_rounded,
        AppTheme.snackColor,
        l10n.modeDescPms,
      ),
      _ModeOption(
        CheckInType.periodCramps,
        l10n.checkInPeriodCramps,
        Icons.healing_rounded,
        const Color(0xFFAD1457),
        l10n.modeDescPeriodCramps,
      ),
      _ModeOption(
        CheckInType.periodFatigue,
        l10n.checkInPeriodFatigue,
        Icons.nightlight_round,
        const Color(0xFF6A1B9A),
        l10n.modeDescPeriodFatigue,
      ),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B2838),
              Color(0xFF2D3E50),
              Color(0xFF1B2838),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentOrange.withAlpha(80),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sunny_snowing,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.modeSelectionTitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.modeSelectionSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withAlpha(160),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Scrollable mode cards
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Period section for female users
                      if (profile.isFemale) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_rounded,
                                color: AppTheme.snackColor.withAlpha(200),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.checkInPeriodSection,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.snackColor.withAlpha(200),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...periodOptions.map(
                          (opt) => _ModeCard(
                            option: opt,
                            onTap: () => _selectMode(ref, opt.type),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            l10n.modeGeneralSection,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withAlpha(140),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],

                      // General options
                      ...generalOptions.map(
                        (opt) => _ModeCard(
                          option: opt,
                          onTap: () => _selectMode(ref, opt.type),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectMode(WidgetRef ref, CheckInType type) {
    ref.read(dailyModeProvider.notifier).setMode(type);
    onModeSelected();
  }
}

class _ModeOption {
  final CheckInType type;
  final String label;
  final IconData icon;
  final Color color;
  final String description;

  const _ModeOption(this.type, this.label, this.icon, this.color, this.description);
}

class _ModeCard extends StatelessWidget {
  final _ModeOption option;
  final VoidCallback onTap;

  const _ModeCard({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withAlpha(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: option.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(120),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white.withAlpha(60),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../models/wellness.dart';
import '../../providers/wellness_provider.dart';
import '../../providers/daily_mode_provider.dart';
import '../../l10n/app_localizations.dart';
import 'wellness_ui.dart';
import 'moonlit_assets.dart';
import 'moonlit_page.dart';

class WellnessCheckInScreen extends ConsumerStatefulWidget {
  const WellnessCheckInScreen({super.key});
  @override
  ConsumerState<WellnessCheckInScreen> createState() => _CheckInState();
}

class _CheckInState extends ConsumerState<WellnessCheckInScreen> {
  int? mood, energy, sleep, stress, prep;
  CheckInType? focus;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    final previous = ref.read(todayCheckInProvider);
    mood = previous?.mood;
    energy = previous?.energy;
    sleep = previous?.sleepQuality;
    stress = previous?.stress;
    prep = previous?.prepMinutes;
    focus = previous?.focus;
  }

  Widget choices(
    IconData icon,
    String title,
    int? selected,
    List<String> labels,
    ValueChanged<int?> changed, {
    List<int>? values,
  }) => Container(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: context.palette.dividerColor.withAlpha(140),
          width: .5,
        ),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 21),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 15)),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final large = MediaQuery.textScalerOf(context).scale(1) > 1.2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(labels.length, (i) {
                final value = values?[i] ?? i + 1;
                final active = selected == value;
                return SizedBox(
                  width: large
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 3,
                  child: ChoiceChip(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    backgroundColor: Colors.transparent,
                    selectedColor: context.palette.surface,
                    side: BorderSide(
                      color: active
                          ? context.palette.mint
                          : context.palette.textSecondary.withAlpha(160),
                      width: .65,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    label: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Text(
                            labels[i],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        if (active)
                          Positioned(
                            right: 0,
                            top: -5,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.palette.mint,
                              ),
                            ),
                          ),
                      ],
                    ),
                    selected: active,
                    onSelected: saving
                        ? null
                        : (on) => setState(() => changed(on ? value : null)),
                  ),
                );
              }),
            );
          },
        ),
      ],
    ),
  );

  Future<void> save() async {
    setState(() => saving = true);
    try {
      await ref
          .read(wellnessProvider.notifier)
          .checkIn(
            DailyCheckIn(
              recordedAt: DateTime.now(),
              mood: mood,
              energy: energy,
              sleepQuality: sleep,
              stress: stress,
              prepMinutes: prep == 0 ? null : prep,
              focus: focus,
            ),
          );
      if (focus != null) ref.read(dailyModeProvider.notifier).setMode(focus!);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) wellnessError(context);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(
        context.w('Günlük durum', 'Daily check-in'),
        style: const TextStyle(fontSize: 16),
      ),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          children: [
            MoonlitHeader(
              moon: false,
              minHeight: 129,
              child: Text(
                context.w(
                  'Kendine\nbir an ayır.',
                  'Take a moment\nfor yourself.',
                ),
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 36, height: 1.06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.w(
                      'Bugünkü planını birlikte şekillendirelim.',
                      'Let’s shape your day together.',
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: context.palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  choices(
                    Icons.favorite_border,
                    context.w('Ruh halin', 'Your mood'),
                    mood,
                    [
                      context.w('Zorlanıyorum', 'Struggling'),
                      context.w('Dengeli', 'Steady'),
                      context.w('İyi', 'Good'),
                    ],
                    (v) => mood = v,
                  ),
                  choices(
                    Icons.bolt_outlined,
                    context.w('Enerjin', 'Your energy'),
                    energy,
                    [
                      context.w('Düşük', 'Low'),
                      context.w('Orta', 'Medium'),
                      context.w('Yüksek', 'High'),
                    ],
                    (v) => energy = v,
                  ),
                  choices(
                    Icons.bedtime_outlined,
                    context.w('Uykun nasıldı?', 'How was your sleep?'),
                    sleep,
                    [
                      context.w('Zayıf', 'Poor'),
                      context.w('Orta', 'Fair'),
                      context.w('İyi', 'Good'),
                    ],
                    (v) => sleep = v,
                  ),
                  choices(
                    Icons.schedule_outlined,
                    context.w('Öğün hazırlamak için', 'Time to prepare a meal'),
                    prep,
                    [
                      context.w('15 dk', '15 min'),
                      context.w('30 dk', '30 min'),
                      context.w('Esneğim', 'Flexible'),
                    ],
                    (v) => prep = v,
                    values: [15, 30, 0],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.palette.textSecondary.withAlpha(150),
                        width: .6,
                      ),
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      collapsedShape: const Border(),
                      title: Text(
                        context.w('Başka bir durum ekle', 'Add more context'),
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.add, size: 22),
                      childrenPadding: const EdgeInsets.all(12),
                      children: [
                        choices(
                          Icons.waves_outlined,
                          context.w('Hissettiğin stres', 'Perceived stress'),
                          stress,
                          [
                            context.w('Az', 'Low'),
                            context.w('Orta', 'Medium'),
                            context.w('Yoğun', 'High'),
                          ],
                          (v) => stress = v,
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: CheckInType.values
                              .map(
                                (type) => ChoiceChip(
                                  label: Text(_focusLabel(type)),
                                  selected: focus == type,
                                  onSelected: saving
                                      ? null
                                      : (v) => setState(
                                          () => focus = v ? type : null,
                                        ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  MoonButton(
                    label: context.w(
                      'Bugünkü planımı hazırla',
                      'Prepare my day',
                    ),
                    onPressed:
                        saving ||
                            [
                              mood,
                              energy,
                              sleep,
                              stress,
                              prep,
                              focus,
                            ].every((v) => v == null)
                        ? null
                        : save,
                  ),
                  const SizedBox(height: 7),
                  TextButton(
                    onPressed: saving ? null : () => Navigator.pop(context),
                    child: Text(context.w('Şimdilik atla', 'Skip for now')),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    context.w(
                      'Paylaşmak istemediklerini atlayabilirsin.',
                      'You can skip anything you prefer not to share.',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  String _focusLabel(CheckInType type) {
    final l = AppLocalizations.of(context);
    return switch (type) {
      CheckInType.lowEnergy => l.checkInLowEnergy,
      CheckInType.bloated => l.checkInBloated,
      CheckInType.cravingSweets => l.checkInCravingSweets,
      CheckInType.cantFocus => l.checkInCantFocus,
      CheckInType.pms => l.checkInPms,
      CheckInType.periodCramps => l.checkInPeriodCramps,
      CheckInType.periodFatigue => l.checkInPeriodFatigue,
      CheckInType.postWorkout => l.checkInPostWorkout,
      CheckInType.noSpecificIssue => l.checkInNoSpecificIssue,
    };
  }
}

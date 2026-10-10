import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/day_boundary.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import '../../providers/wellness_provider.dart';
import 'check_in_screen.dart';
import 'mood_widgets.dart';
import 'moonlit_assets.dart';
import 'wellness_ui.dart';

class MoodPickerScreen extends ConsumerStatefulWidget {
  final bool appearanceOnly;
  const MoodPickerScreen({super.key, this.appearanceOnly = false});
  @override
  ConsumerState<MoodPickerScreen> createState() => _MoodPickerState();
}

class _MoodPickerState extends ConsumerState<MoodPickerScreen> {
  bool period = false, saving = false;
  Future<void> select(CheckInType mode) async {
    if (saving) return;
    setState(() => saving = true);
    try {
      final notifier = ref.read(wellnessProvider.notifier);
      if (widget.appearanceOnly) {
        await notifier.update(
          (s) => s.copyWith(themeMode: mode.name, appearanceLocked: true),
        );
        if (mounted) Navigator.pop(context);
        return;
      }
      await notifier.selectFocus(mode, ref.read(wellnessNowProvider));
      ref.read(wellnessRecipeChoiceProvider.notifier).state = null;
      // Step two of the same check-in: energy and time shape the
      // recommendation, so they are asked right here rather than on a
      // separate screen the user has to find.
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const WellnessCheckInScreen(),
          ),
        );
      }
    } catch (_) {
      if (mounted) wellnessError(context);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> skip() async {
    setState(() => saving = true);
    try {
      await ref
          .read(wellnessProvider.notifier)
          .update(
            (s) => s.copyWith(
              contextPromptDay: DayBoundary.keyFor(
                ref.read(wellnessNowProvider),
              ),
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) wellnessError(context);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final modes = period
        ? [CheckInType.pms, CheckInType.periodCramps, CheckInType.periodFatigue]
        : [
            CheckInType.lowEnergy,
            CheckInType.bloated,
            CheckInType.cravingSweets,
            CheckInType.cantFocus,
            CheckInType.stressed,
            CheckInType.anxious,
            CheckInType.poorSleep,
            CheckInType.postWorkout,
          ];
    final data = ref.watch(wellnessProvider);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    // "İyiyim" is the absence of the others, so it sits apart: one wide
    // card under the grid, laid out like the period cards.
    Widget card(CheckInType mode, {bool wide = false}) {
      final m = MoodPalette.all[mode]!;
      final title = context.w(m.tr, m.en);
      return Theme(
        data: AppTheme.forPalette(m),
        child: Builder(
          builder: (context) => ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: m.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: m.dividerColor, width: .8),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: .65,
                      child: MoodLandscape(mode: mode),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            m.surface.withValues(alpha: .55),
                            m.surface.withValues(alpha: .12),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: MotionTap(
                      onTap: saving ? null : () => select(mode),
                      builder: (context, t) => Padding(
                        padding: EdgeInsets.fromLTRB(
                          14,
                          period || wide ? 20 : 24,
                          14,
                          16,
                        ),
                        child: period || wide
                            ? Row(
                                children: [
                                  MoodGlyph(m.icon, size: 64, progress: t),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w600,
                                        color: m.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MoodGlyph(m.icon, size: 56, progress: t),
                                  const SizedBox(height: 14),
                                  Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: m.textPrimary,
                                      height: 1.14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: InfoDot(
                      title: title,
                      description: context.w(
                        'Bu seçimin uygulamanın atmosferini ve sana gösterilen tarif sırasını düzenler. Alerji ve beslenme tercihlerin her zaman korunur. İstediğin an değiştirebilirsin.',
                        'This choice shapes the atmosphere and recipe order. Your allergy and food preferences remain active. Change it whenever you wish.',
                      ),
                    ),
                  ),
                  if ((widget.appearanceOnly
                      ? data.themeMode == mode.name
                      : ref.watch(todayCheckInProvider)?.focus == mode))
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Icon(Icons.check_circle, size: 20, color: m.mint),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                MoonlitHeader(
                  minHeight: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NutriGuide', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 6),
                      Text(
                        context.w(
                          widget.appearanceOnly
                              ? 'Atmosferini seç'
                              : 'Bugün nasılsın?',
                          widget.appearanceOnly
                              ? 'Choose your atmosphere'
                              : 'How are you today?',
                        ),
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.w(
                          'Bugün öne çıkan durumu seç.',
                          'Choose what stands out today.',
                        ),
                        style: TextStyle(color: p.textPrimary, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SegmentedButton<bool>(
                        segments: [
                          ButtonSegment(
                            value: false,
                            label: Text(context.w('Günlük', 'Everyday')),
                          ),
                          ButtonSegment(
                            value: true,
                            label: Text(context.w('Regl dönemi', 'Period')),
                          ),
                        ],
                        selected: {period},
                        showSelectedIcon: false,
                        onSelectionChanged: saving
                            ? null
                            : (s) => setState(() => period = s.first),
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? p.onAction
                                : p.textPrimary,
                          ),
                          minimumSize: const WidgetStatePropertyAll(
                            Size(0, 48),
                          ),
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? p.mint
                                : p.surface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      MotionSize(
                        duration: reducedMotion(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 350),
                        curve: Curves.easeInOutCubic,
                        child: period
                            ? Column(
                                children: modes
                                    .map(
                                      (m) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: SizedBox(
                                          height: 142 + (scale - 1) * 65,
                                          child: LiftIn(child: card(m)),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FeatureGrid(
                                    height: 164,
                                    children: modes
                                        .map((m) => card(m))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 120 + (scale - 1) * 65,
                                    child: LiftIn(
                                      order: modes.length,
                                      child: card(
                                        CheckInType.noSpecificIssue,
                                        wide: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      if (widget.appearanceOnly)
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            context.w(
                              'Durumuma göre değişsin',
                              'Follow my check-in',
                            ),
                          ),
                          value: !data.appearanceLocked,
                          onChanged: (on) => saveWellness(
                            context,
                            () => ref
                                .read(wellnessProvider.notifier)
                                .update(
                                  (s) => s.copyWith(
                                    appearanceLocked: !on,
                                    themeMode: on
                                        ? ref
                                              .read(todayCheckInProvider)
                                              ?.focus
                                              ?.name
                                        : null,
                                  ),
                                ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: saving ? null : skip,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            context.w(
                              widget.appearanceOnly ? 'Kapat' : 'Şimdilik atla',
                              widget.appearanceOnly ? 'Close' : 'Skip for now',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

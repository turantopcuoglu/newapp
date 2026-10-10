import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/ingredient_image.dart';
import '../../components/step_ingredients.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import '../../l10n/app_localizations.dart';
import '../../models/recipe.dart';
import '../../providers/cooked_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/preference_matcher.dart';
import '../../services/quantity_format.dart';
import '../../services/step_ingredient_matcher.dart';
import '../../services/step_timer.dart';
import 'moonlit_page.dart';
import 'nourish_screen.dart';
import 'wellness_ui.dart';

/// Cooking mode: a prep list first (everything on the counter, with
/// amounts), then one step at a time with that step's ingredients and a
/// timer for every wait the step names. Timers keep running while the cook
/// moves on to the next step.
class CookingScreen extends ConsumerStatefulWidget {
  final Recipe recipe;

  /// Wall clock; tests pass a fake one to step past a locked screen.
  final DateTime Function() now;

  const CookingScreen({
    super.key,
    required this.recipe,
    this.now = DateTime.now,
  });

  @override
  ConsumerState<CookingScreen> createState() => _CookingScreenState();
}

typedef _TimerKey = ({int step, int index});

/// Wall-clock countdown, not a Stopwatch: the oven keeps going when the
/// phone locks, and so must this.
class _StepClock {
  final Duration total;
  DateTime? since;
  Duration banked = Duration.zero;
  bool done = false;

  _StepClock(this.total);

  bool get running => since != null;

  Duration remaining(DateTime now) {
    final elapsed = running ? banked + now.difference(since!) : banked;
    final left = total - elapsed;
    return left.isNegative ? Duration.zero : left;
  }
}

class _CookingScreenState extends ConsumerState<CookingScreen>
    with WidgetsBindingObserver {
  /// 0 is the prep list; 1..n are the steps.
  int page = 0;
  bool saved = false;
  final ready = <String>{};
  final clocks = <_TimerKey, _StepClock>{};
  final scroll = ScrollController();
  Timer? ticker;

  /// Every page starts at its top; the list is shared between pages.
  void _go(int to) {
    setState(() => page = to);
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Timers do not fire while the app is suspended; catch up on return.
    if (state == AppLifecycleState.resumed) _tick();
  }

  @override
  void dispose() {
    ticker?.cancel();
    scroll.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool get _anyRunning => clocks.values.any((c) => c.running);

  void _tick() {
    if (!mounted) return;
    final now = widget.now();
    final finished = <_TimerKey>[];
    for (final entry in clocks.entries) {
      final clock = entry.value;
      if (clock.running && clock.remaining(now) == Duration.zero) {
        clock
          ..since = null
          ..banked = clock.total
          ..done = true;
        finished.add(entry.key);
      }
    }
    if (!_anyRunning) {
      ticker?.cancel();
      ticker = null;
    }
    setState(() {});
    if (finished.isNotEmpty) _announce(finished.first);
  }

  void _announce(_TimerKey key) {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            context.w(
              '${key.step + 1}. adımın süresi doldu',
              'Step ${key.step + 1}: time is up',
            ),
          ),
          action: page == key.step + 1
              ? null
              : SnackBarAction(
                  label: context.w('Göster', 'Show'),
                  onPressed: () => _go(key.step + 1),
                ),
        ),
      );
  }

  void _toggle(_TimerKey key, StepDuration duration) {
    final now = widget.now();
    setState(() {
      final clock = clocks.putIfAbsent(
        key,
        () => _StepClock(duration.duration),
      );
      if (clock.done) return;
      if (clock.running) {
        clock
          ..banked = clock.total - clock.remaining(now)
          ..since = null;
      } else {
        clock.since = now;
        ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
      }
    });
  }

  void _reset(_TimerKey key) => setState(() => clocks.remove(key));

  Future<bool> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.w('Zamanlayıcı çalışıyor', 'A timer is running')),
        content: Text(
          context.w('Çıkarsan zamanlayıcı durur.', 'Leaving stops the timer.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.w('Kal', 'Stay')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.w('Çık', 'Leave')),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final safe = !recipeHasAllergenConflict(recipe, ref.watch(profileProvider));
    final locale = Localizations.localeOf(context).languageCode;
    final steps = recipe.localizedSteps(locale);
    final perStep = stepIngredientsFor(recipe);
    final Widget body;
    Widget? actions;
    if (!safe) {
      body = _Message(
        title: context.w('Tercihlerin değişti.', 'Your preferences changed.'),
        text: context.w(
          'Bu tarif güncel alerji veya hassasiyet seçimlerine uygun değil.',
          'This recipe does not match your current allergy or sensitivity settings.',
        ),
      );
    } else if (steps.isEmpty) {
      body = _Message(
        title: context.w(
          'Kendi temponda hazırla.',
          'Prepare at your own pace.',
        ),
        text: context.w(
          'Tarif adımları bulunamadı.',
          'Recipe instructions are missing.',
        ),
      );
    } else {
      body = _content(context, recipe, steps, perStep);
      actions = _actions(context, recipe, steps.length);
    }
    return PopScope(
      canPop: !_anyRunning,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await _confirmLeave() && mounted) {
          ticker?.cancel();
          clocks.clear();
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(recipe.localizedName(locale))),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: body,
          ),
        ),
        // Always in reach: hands are busy and the step text can be long.
        bottomNavigationBar: actions,
      ),
    );
  }

  Widget _actions(BuildContext context, Recipe recipe, int total) {
    final onPrep = page == 0;
    final last = page == total;
    final Widget primary;
    if (onPrep) {
      primary = MoonButton(
        label: context.w('Adımlara geç', 'Go to the steps'),
        onPressed: () => _go(1),
      );
    } else if (!last) {
      primary = MoonButton(
        label: context.w('Sonraki adım', 'Next step'),
        onPressed: () => _go(page + 1),
      );
    } else {
      primary = MoonButton(
        label: saved
            ? context.w('Pişirdiğin kaydedildi', 'Logged as cooked')
            : context.w('Pişirdim, kaydet', 'I cooked it, save'),
        onPressed: saved
            ? null
            : () {
                ref.read(cookedProvider.notifier).markCooked(recipe);
                setState(() => saved = true);
              },
      );
    }
    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 22, 12),
            child: Row(
              children: [
                if (!onPrep && !saved)
                  TextButton(
                    onPressed: () => _go(page - 1),
                    child: Text(context.w('Geri', 'Back')),
                  )
                else
                  const SizedBox(width: 6),
                const SizedBox(width: 8),
                Expanded(child: primary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    Recipe recipe,
    List<String> steps,
    List<List<String>> perStep,
  ) {
    final total = steps.length;
    final onPrep = page == 0;
    final stepIndex = page - 1;
    final palette = context.palette;
    final elsewhere = [
      for (final e in clocks.entries)
        if (e.key.step != stepIndex && (e.value.running || e.value.done)) e,
    ]..sort((a, b) => a.key.step.compareTo(b.key.step));

    return ListView(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: page / total,
            minHeight: 4,
            color: palette.mint,
            backgroundColor: palette.dividerColor,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          onPrep
              ? context.w('HAZIRLIK', 'GET READY')
              : context.w(
                  'ADIM ${stepIndex + 1} / $total',
                  'STEP ${stepIndex + 1} / $total',
                ),
          style: TextStyle(color: palette.moon, letterSpacing: .6),
        ),
        if (elsewhere.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in elsewhere)
                ActionChip(
                  avatar: Icon(
                    e.value.done
                        ? Icons.alarm_on_rounded
                        : Icons.timer_outlined,
                    size: 18,
                    color: e.value.done ? palette.mint : palette.textSecondary,
                  ),
                  label: Text(
                    e.value.done
                        ? context.w(
                            '${e.key.step + 1}. adım · süre doldu',
                            'Step ${e.key.step + 1} · time is up',
                          )
                        : context.w(
                            '${e.key.step + 1}. adım · ${_clockText(e.value.remaining(widget.now()))}',
                            'Step ${e.key.step + 1} · ${_clockText(e.value.remaining(widget.now()))}',
                          ),
                  ),
                  onPressed: () => _go(e.key.step + 1),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: reducedMotion(context)
              ? Duration.zero
              : const Duration(milliseconds: 220),
          child: KeyedSubtree(
            key: ValueKey(page),
            child: onPrep
                ? _PrepList(
                    recipe: recipe,
                    ready: ready,
                    onToggle: (id) => setState(
                      () =>
                          ready.contains(id) ? ready.remove(id) : ready.add(id),
                    ),
                  )
                : _StepView(
                    recipe: recipe,
                    step: stepIndex,
                    text: steps[stepIndex],
                    perStep: perStep,
                    clocks: clocks,
                    now: widget.now,
                    onToggle: _toggle,
                    onReset: _reset,
                  ),
          ),
        ),
      ],
    );
  }
}

String _clockText(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

class _Message extends StatelessWidget {
  final String title;
  final String text;
  const _Message({required this.title, required this.text});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 30),
      Text(text),
    ],
  );
}

/// Everything on the counter before the first step: the "mise en place".
class _PrepList extends ConsumerWidget {
  final Recipe recipe;
  final Set<String> ready;
  final ValueChanged<String> onToggle;

  const _PrepList({
    required this.recipe,
    required this.ready,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final inventory = ref.watch(inventoryIdsProvider);
    final palette = context.palette;
    final ids = recipe.ingredientIds;
    // Only worth saying when the user keeps a kitchen list at all.
    final missing = inventory.isEmpty
        ? 0
        : ids.where((id) => !inventory.contains(id)).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.w('Önce hepsini hazırla', 'Set everything out first'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          context.w(
            'Ölç, tezgâha koy, işaretle. Miktarlar ${recipe.servings} porsiyon için.',
            'Measure, set it on the counter, tick it off. Amounts are for ${recipe.servings} ${recipe.servings == 1 ? 'serving' : 'servings'}.',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.w(
            '${ready.length} / ${ids.length} hazır'
                '${missing > 0 ? ' · $missing tanesi mutfağında kayıtlı değil' : ''}',
            '${ready.length} / ${ids.length} ready'
                '${missing > 0 ? ' · $missing not in your kitchen list' : ''}',
          ),
          style: TextStyle(color: palette.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 14),
        WellnessCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              for (final id in ids)
                CheckboxListTile(
                  value: ready.contains(id),
                  onChanged: (_) => onToggle(id),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: palette.mint,
                  secondary: SizedBox.square(
                    dimension: 40,
                    child: IngredientImage(id: id),
                  ),
                  title: Text(
                    foodName(id, locale),
                    style: TextStyle(
                      fontSize: 15,
                      color: palette.textPrimary,
                      decoration: ready.contains(id)
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    formatQuantity(recipe.quantities[id], l10n) ??
                        context.w('Miktar belirtilmemiş', 'No amount given'),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepView extends StatelessWidget {
  final Recipe recipe;
  final int step;
  final String text;
  final List<List<String>> perStep;
  final Map<_TimerKey, _StepClock> clocks;
  final DateTime Function() now;
  final void Function(_TimerKey, StepDuration) onToggle;
  final void Function(_TimerKey) onReset;

  const _StepView({
    required this.recipe,
    required this.step,
    required this.text,
    required this.perStep,
    required this.clocks,
    required this.now,
    required this.onToggle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final durations = parseStepDurations(text);
    final hasIngredients = step < perStep.length && perStep[step].isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: const TextStyle(fontSize: 22, height: 1.5)),
        if (hasIngredients) ...[
          const SizedBox(height: 22),
          Text(
            context.w('Bu adımda', 'In this step'),
            style: TextStyle(color: context.palette.moon, fontSize: 13),
          ),
          const SizedBox(height: 10),
          StepIngredients(
            recipe: recipe,
            step: step,
            perStep: perStep,
            large: true,
          ),
        ],
        for (var i = 0; i < durations.length; i++) ...[
          const SizedBox(height: 16),
          _TimerCard(
            duration: durations[i],
            clock: clocks[(step: step, index: i)],
            now: now,
            onToggle: () => onToggle((step: step, index: i), durations[i]),
            onReset: () => onReset((step: step, index: i)),
          ),
        ],
      ],
    );
  }
}

class _TimerCard extends StatelessWidget {
  final StepDuration duration;
  final _StepClock? clock;
  final DateTime Function() now;
  final VoidCallback onToggle;
  final VoidCallback onReset;

  const _TimerCard({
    required this.duration,
    required this.clock,
    required this.now,
    required this.onToggle,
    required this.onReset,
  });

  String _label(BuildContext context) {
    final amount = duration.isRange
        ? '${duration.from}–${duration.to}'
        : '${duration.from}';
    final unit = switch (duration.unit) {
      StepTimeUnit.second => context.w('sn', 'sec'),
      StepTimeUnit.minute => context.w('dk', 'min'),
      StepTimeUnit.hour => context.w('saat', 'h'),
    };
    return '$amount $unit';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final c = clock;
    final done = c?.done ?? false;
    final running = c?.running ?? false;
    final started = c != null;
    final String headline;
    final String caption;
    if (done) {
      headline = context.w('Süre doldu', 'Time is up');
      caption = duration.isRange
          ? context.w(
              'Kontrol et; tarif ${_label(context)} diyor.',
              'Check it; the recipe says ${_label(context)}.',
            )
          : context.w('Kontrol et.', 'Check it.');
    } else if (started) {
      headline = _clockText(c.remaining(now()));
      caption = running
          ? context.w('Sayıyor', 'Counting down')
          : context.w('Duraklatıldı', 'Paused');
    } else {
      headline = _label(context);
      caption = duration.isRange
          ? context.w('Kısa süreyi sayar', 'Counts the shorter time')
          : context.w('Zamanlayıcı', 'Timer');
    }
    return WellnessCard(
      padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
      color: done ? palette.mint.withValues(alpha: .18) : null,
      child: Row(
        children: [
          Icon(
            done ? Icons.alarm_on_rounded : Icons.timer_outlined,
            color: done ? palette.mint : palette.textSecondary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: TextStyle(
                    fontSize: started && !done ? 28 : 18,
                    fontWeight: started && !done
                        ? FontWeight.w300
                        : FontWeight.w600,
                    color: palette.textPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  caption,
                  style: TextStyle(fontSize: 12, color: palette.textSecondary),
                ),
              ],
            ),
          ),
          if (started)
            IconButton(
              tooltip: context.w('Sıfırla', 'Reset'),
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt_rounded),
            ),
          if (!done)
            IconButton.filledTonal(
              tooltip: running
                  ? context.w('Duraklat', 'Pause')
                  : context.w('Başlat', 'Start'),
              onPressed: onToggle,
              icon: Icon(
                running ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            ),
        ],
      ),
    );
  }
}

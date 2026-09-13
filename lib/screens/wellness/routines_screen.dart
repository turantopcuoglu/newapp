import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/day_boundary.dart';
import '../../core/atmosphere_surface.dart';
import '../../core/wellness_motion.dart';
import '../../models/wellness.dart';
import '../../providers/wellness_provider.dart';
import 'wellness_ui.dart';
import 'moonlit_page.dart';
import 'moonlit_assets.dart';
import 'moonlit_icon.dart';
import 'routine_visual.dart';
import '../beverages/beverages_screen.dart';

class RoutineSpec {
  final String id, tr, en, trGuide, enGuide;
  final IconData icon;
  final int minutes;
  const RoutineSpec(
    this.id,
    this.tr,
    this.en,
    this.icon,
    this.minutes,
    this.trGuide,
    this.enGuide,
  );
}

const routineLibrary = [
  RoutineSpec(
    'breathe',
    'Bir nefeslik ara',
    'A breathing break',
    Icons.air_rounded,
    2,
    'Omuzlarını rahat bırak. Nefesini tutmadan, rahat ettiğin tempoda nefes al ve ver. Halka yalnızca görsel bir rehber; ona uymak zorunda değilsin.',
    'Let your shoulders relax. Breathe at a comfortable pace without holding your breath. The circle is a visual guide; you do not need to follow it.',
  ),
  RoutineSpec(
    'mindful',
    'Şimdiye dön',
    'Return to the present',
    Icons.spa_outlined,
    3,
    'Rahat bir pozisyon bul. Etrafındaki bir sesi fark et. Sonra bedeninin oturduğun yere temasına odaklan. Dikkatin dağılırsa yargılamadan geri dön.',
    'Find a comfortable position. Notice a sound around you, then the contact between your body and your seat. If your attention wanders, gently return.',
  ),
  RoutineSpec(
    'walk',
    'Kısa bir yürüyüş',
    'A short walk',
    Icons.directions_walk_rounded,
    10,
    'Sana uygun, rahat bir tempoda yürü. İstersen daha kısa tutabilir veya oturduğun yerde bir hareket molası seçebilirsin. Bu zamanlayıcı adım ölçmez.',
    'Walk at a comfortable pace. You can shorten the session or choose a seated movement break. This timer does not measure steps.',
  ),
  RoutineSpec(
    'stretch',
    'Omuzlarına alan aç',
    'Room for your shoulders',
    Icons.accessibility_new_rounded,
    5,
    'Rahatça otur veya ayakta dur. Omuzlarını zorlamadan gevşet, ellerini açıp kapat. Ağrısız hareket aralığında kal ve istediğin anda bitir.',
    'Sit or stand comfortably. Gently relax your shoulders and open and close your hands. Stay within a pain-free range and stop whenever you wish.',
  ),
];

void openRoutine(BuildContext context, RoutineSpec routine) => Navigator.push(
  context,
  MaterialPageRoute<void>(
    builder: (_) => RoutineSessionScreen(routine: routine),
  ),
);

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(wellnessProvider);
    final now = ref.watch(wellnessNowProvider);
    return SleepContent(
      extra: [
        WellnessSection(context.w('Bir an seç', 'Choose a moment')),
        ...routineLibrary.map(
          (r) => WellnessTile(
            icon: r.icon,
            title: context.w(r.tr, r.en),
            subtitle:
                '${durationLabel(context, r.minutes)} · ${context.w('Rehberli rutin', 'Guided routine')}',
            onTap: () => openRoutine(context, r),
          ),
        ),
        WellnessSection(context.w('Alışkanlıkların', 'Your habits')),
        if (data.habits.isEmpty)
          Text(
            context.w(
              'Küçük bir alışkanlık ekle. Her gün işaretlemek zorunda değilsin.',
              'Add a small habit. You do not have to check it off every day.',
            ),
          ),
        ...data.habits.map(
          (habit) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(habit),
            value: (data.habitChecks[DayBoundary.keyFor(now)] ?? []).contains(
              habit,
            ),
            onChanged: (_) => saveWellness(
              context,
              () => ref.read(wellnessProvider.notifier).toggleHabit(habit, now),
            ),
            secondary: WellnessIconButton(
              tooltip: context.w('Alışkanlığı kaldır', 'Remove habit'),
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => saveWellness(
                context,
                () => ref
                    .read(wellnessProvider.notifier)
                    .update(
                      (s) => s.copyWith(
                        habits: s.habits.where((h) => h != habit).toList(),
                      ),
                    ),
              ),
            ),
          ),
        ),
        if (data.habits.length < 12)
          TextButton.icon(
            onPressed: () => _addHabit(context, ref),
            icon: const Icon(Icons.add),
            label: Text(context.w('Alışkanlık ekle', 'Add a habit')),
          ),
      ],
    );
  }

  Future<void> _addHabit(BuildContext context, WidgetRef ref) async {
    var value = '';
    final result = await showDialog<String>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(context.w('Küçük bir alışkanlık', 'A small habit')),
        content: TextField(
          autofocus: true,
          maxLength: 60,
          onChanged: (v) => value = v,
          decoration: InputDecoration(
            hintText: context.w(
              'Örn. öğle molasında dışarı çık',
              'e.g. Go outside at lunch',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: Text(context.w('Vazgeç', 'Cancel')),
          ),
          TextButton(
            onPressed: () {
              if (value.trim().isNotEmpty) {
                Navigator.pop(dialog, value.trim());
              }
            },
            child: Text(context.w('Ekle', 'Add')),
          ),
        ],
      ),
    );
    if (result != null && context.mounted) {
      await saveWellness(
        context,
        () => ref
            .read(wellnessProvider.notifier)
            .update((s) => s.copyWith(habits: {...s.habits, result}.toList())),
      );
    }
  }
}

class RoutineSessionScreen extends ConsumerStatefulWidget {
  final RoutineSpec routine;
  const RoutineSessionScreen({super.key, required this.routine});
  @override
  ConsumerState<RoutineSessionScreen> createState() => _RoutineSessionState();
}

class _RoutineSessionState extends ConsumerState<RoutineSessionScreen>
    with WidgetsBindingObserver {
  final Stopwatch watch = Stopwatch();
  Timer? timer;
  bool started = false, finished = false, saving = false, saved = false;
  int breathCycle = 8000;
  int get total => widget.routine.minutes * 60;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && watch.isRunning) {
      watch.stop();
      timer?.cancel();
      timer = null;
      setState(() {});
    }
  }

  void toggle() {
    setState(() {
      started = true;
      watch.isRunning ? watch.stop() : watch.start();
      timer?.cancel();
      timer = null;
      if (watch.isRunning) {
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          if (watch.elapsed.inSeconds >= total) {
            watch.stop();
            finished = true;
            timer?.cancel();
            timer = null;
          }
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    watch.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.routine;
    final remaining = (total - watch.elapsed.inSeconds).clamp(0, total);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          r.id == 'breathe'
              ? context.w('Nefes molası', 'Breathing break')
              : context.w(r.tr, r.en),
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
            children: [
              Text(
                context.w(
                  'Bir an\nkendine dön.',
                  'Take a moment\nto return to yourself.',
                ),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 35, height: 1.15),
              ),
              const SizedBox(height: 12),
              Text(
                context.w(
                  '${r.minutes} dakikalık mola',
                  'A ${r.minutes}-minute break',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RoutineVisual(
                kind: r.id,
                running: watch.isRunning,
                completed: finished,
                elapsedMilliseconds: watch.elapsedMilliseconds,
                cycleMilliseconds: r.id == 'breathe' ? breathCycle : null,
              ),
              const SizedBox(height: 12),
              Text(
                '${(remaining ~/ 60).toString().padLeft(2, '0')} : ${(remaining % 60).toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                  color: context.palette.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                finished
                    ? context.w(
                        'Kendine ayırdığın bu an tamamlandı.',
                        'Your moment is complete.',
                      )
                    : r.id == 'breathe'
                    ? context.w(
                        'Nefesini tutmadan, rahat bir tempoda.',
                        'At a comfortable pace, without holding your breath.',
                      )
                    : context.w(
                        'Kendi ritminde. İstediğin an duraklat.',
                        'At your pace. Pause whenever you wish.',
                      ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 22),
              if (r.id == 'breathe' && !finished) ...[
                Center(
                  child: SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: [
                      for (final seconds in [6, 8, 10])
                        ButtonSegment(
                          value: seconds * 1000,
                          label: Text(context.w('$seconds sn', '$seconds s')),
                          tooltip: context.w(
                            'Görsel nefes döngüsü: $seconds saniye',
                            'Visual breathing cycle: $seconds seconds',
                          ),
                        ),
                    ],
                    selected: {breathCycle},
                    onSelectionChanged: (value) =>
                        setState(() => breathCycle = value.first),
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected)
                            ? context.palette.onAction
                            : context.palette.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              if (!finished)
                Semantics(
                  button: true,
                  child: MotionTap(
                    onTap: toggle,
                    builder: (context, t) => AtmosphereSurface(
                      primary: true,
                      activity: t,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(end: watch.isRunning ? 1 : 0),
                              duration: reducedMotion(context)
                                  ? Duration.zero
                                  : const Duration(milliseconds: 380),
                              builder: (context, value, _) => AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: AlwaysStoppedAnimation(value),
                                size: 27,
                                color: context.palette.onAction,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                watch.isRunning
                                    ? context.w('Duraklat', 'Pause')
                                    : started
                                    ? context.w('Devam et', 'Resume')
                                    : context.w('Başlat', 'Start'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: context.palette.onAction,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                MoonButton(
                  label: saved
                      ? context.w('Kaydedildi', 'Saved')
                      : context.w('Rutini kaydet', 'Save routine'),
                  onPressed: saving || saved
                      ? null
                      : () async {
                          setState(() => saving = true);
                          try {
                            await ref
                                .read(wellnessProvider.notifier)
                                .logRoutine(r.id, total);
                            if (mounted) setState(() => saved = true);
                          } catch (_) {
                            if (context.mounted) wellnessError(context);
                          } finally {
                            if (mounted) setState(() => saving = false);
                          }
                        },
                ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  context.w('Bitir', 'Finish'),
                  style: TextStyle(
                    fontSize: 17,
                    color: context.palette.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.w(
                  'Rahatsız hissedersen durabilirsin.',
                  'You can stop if you feel uncomfortable.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 18),
              ExpansionTile(
                title: Text(
                  context.w('Rutin rehberi', 'Routine guide'),
                  style: const TextStyle(fontSize: 13),
                ),
                children: [Text(context.w(r.trGuide, r.enGuide))],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.w('Uykuya hazırlık', 'Prepare for sleep')),
    ),
    body: const SleepContent(),
  );
}

class SleepContent extends ConsumerWidget {
  final List<Widget> extra;
  const SleepContent({super.key, this.extra = const []});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(wellnessNowProvider);
    final data = ref.watch(wellnessProvider);
    final checked = data.eveningChecks[DayBoundary.keyFor(now)] ?? [];
    final bedtime = data.bedtimeMinutes;
    final sleep =
        data.manualSleepMinutes(now) ??
        data.health?.minutesFor(
          'sleep',
          now,
          preferredSource: data.sleepSource,
        );
    final items = [
      (
        'lights',
        Icons.light_mode_outlined,
        context.w('Işıkları azalt', 'Dim the lights'),
      ),
      (
        'screen',
        Icons.phone_android_outlined,
        context.w('Ekranlara ara ver', 'Take a screen break'),
      ),
      (
        'settle',
        Icons.waves_outlined,
        context.w('Kısa bir gevşeme molası', 'A short relaxation break'),
      ),
    ];
    return MoonlitPage(
      header: MoonlitHeader(
        minHeight: 269,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.nights_stay_outlined,
                  size: 22,
                  color: context.palette.moon,
                ),
                const SizedBox(width: 10),
                Text(
                  context.w('AKŞAM RUTİNİN', 'YOUR EVENING RITUAL'),
                  style: TextStyle(fontSize: 12, color: context.palette.moon),
                ),
              ],
            ),
            const SizedBox(height: 17),
            Text(
              context.w('Günü yavaşça\nkapat.', 'Gently close\nthe day.'),
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: 35, height: 1.12),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () async {
                final selected = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: bedtime == null ? 23 : bedtime ~/ 60,
                    minute: bedtime == null ? 0 : bedtime % 60,
                  ),
                );
                if (selected != null && context.mounted) {
                  await saveWellness(
                    context,
                    () => ref
                        .read(wellnessProvider.notifier)
                        .update(
                          (s) => s.copyWith(
                            bedtimeMinutes:
                                selected.hour * 60 + selected.minute,
                          ),
                        ),
                  );
                }
              },
              icon: Icon(
                Icons.edit_outlined,
                size: 15,
                color: context.palette.textPrimary,
              ),
              label: Text(
                bedtime == null
                    ? context.w('Yatış saatini seç', 'Choose your bedtime')
                    : '${context.w('Yatış saatin', 'Your bedtime')} ${TimeOfDay(hour: bedtime ~/ 60, minute: bedtime % 60).format(context)}',
                style: TextStyle(
                  fontSize: 13,
                  color: context.palette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
      children: [
        const SizedBox(height: 20),
        Text(
          context.w('Uykuya hazırlan', 'Prepare for sleep'),
          style: TextStyle(fontSize: 18, color: context.palette.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          context.w(
            'Bugün kendine küçük bir alan aç',
            'Make a little room for yourself today',
          ),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: WellnessCard(
              padding: EdgeInsets.zero,
              color: context.palette.surface,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 3,
                ),
                leading: MoonlitIcon(
                  item.$1 == 'lights'
                      ? 'sun'
                      : item.$1 == 'screen'
                      ? 'phone'
                      : 'waves',
                  size: 27,
                ),
                title: Text(item.$3, style: const TextStyle(fontSize: 15)),
                trailing: Icon(
                  checked.contains(item.$1)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: checked.contains(item.$1)
                      ? context.palette.mint
                      : context.palette.textPrimary,
                  size: 25,
                ),
                onTap: () => saveWellness(
                  context,
                  () => ref
                      .read(wellnessProvider.notifier)
                      .toggleEvening(item.$1, now),
                ),
              ),
            ),
          ),
        ),
        WellnessCard(
          padding: EdgeInsets.zero,
          color: context.palette.surface,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 5,
            ),
            leading: const MoonlitIcon('cup', size: 28),
            title: Text(
              context.w('Akşam içeceğin', 'Your evening drink'),
              style: const TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              context.w(
                'İstersen kafeinsiz bir seçenek seç.',
                'Choose a caffeine-free option if you like.',
              ),
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right, size: 21),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const BeveragesScreen()),
            ),
          ),
        ),
        const SizedBox(height: 17),
        MoonButton(
          label: context.w(
            'Akşam rutinini başlat',
            'Start your evening ritual',
          ),
          onPressed: () => openRoutine(context, routineLibrary.first),
        ),
        const SizedBox(height: 17),
        FineRow(
          icon: Icons.bedtime_outlined,
          title:
              '${context.w('Son uyku kaydın', 'Latest sleep record')} · ${durationLabel(context, sleep)}',
          trailing: const Icon(Icons.edit_outlined, size: 20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const SleepEntryScreen()),
          ),
        ),
        ...extra,
      ],
    );
  }
}

class SleepEntryScreen extends ConsumerStatefulWidget {
  const SleepEntryScreen({super.key});
  @override
  ConsumerState<SleepEntryScreen> createState() => _SleepEntryState();
}

class _SleepEntryState extends ConsumerState<SleepEntryScreen> {
  DateTime day = DateTime.now();
  TimeOfDay? start, end;
  bool saving = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.w('Uyku günlüğü', 'Sleep journal'))),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          context.w(
            'Uyandığın günü ve yaklaşık saatleri seç.',
            'Choose the day you woke up and approximate times.',
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          title: Text(context.w('Uyandığım gün', 'Day I woke up')),
          subtitle: Text(
            MaterialLocalizations.of(context).formatMediumDate(day),
          ),
          trailing: const Icon(Icons.calendar_today_outlined),
          onTap: saving
              ? null
              : () async {
                  final value = await showDatePicker(
                    context: context,
                    initialDate: day,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (value != null && mounted) setState(() => day = value);
                },
        ),
        ...[true, false].map(
          (isStart) => ListTile(
            title: Text(
              isStart
                  ? context.w('Uyku başlangıcı', 'Sleep start')
                  : context.w('Uyanış', 'Woke up'),
            ),
            subtitle: Text(
              (isStart ? start : end)?.format(context) ??
                  context.w('Saat seç', 'Choose time'),
            ),
            trailing: const Icon(Icons.schedule),
            onTap: saving
                ? null
                : () async {
                    final value = await showTimePicker(
                      context: context,
                      initialTime:
                          (isStart ? start : end) ??
                          const TimeOfDay(hour: 7, minute: 0),
                    );
                    if (value != null && mounted) {
                      setState(() {
                        if (isStart) {
                          start = value;
                        } else {
                          end = value;
                        }
                      });
                    }
                  },
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: saving || start == null || end == null
              ? null
              : () async {
                  var from = DateTime(
                    day.year,
                    day.month,
                    day.day,
                    start!.hour,
                    start!.minute,
                  );
                  final to = DateTime(
                    day.year,
                    day.month,
                    day.day,
                    end!.hour,
                    end!.minute,
                  );
                  if (from.isAfter(to)) {
                    from = DateTime(
                      day.year,
                      day.month,
                      day.day - 1,
                      start!.hour,
                      start!.minute,
                    );
                  }
                  if (!to.isAfter(from) ||
                      to.isAfter(DateTime.now()) ||
                      to.difference(from).inHours >= 24) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.w(
                            'Geçmişte biten, 24 saatten kısa bir uyku aralığı seç.',
                            'Choose a sleep interval shorter than 24 hours that ended in the past.',
                          ),
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => saving = true);
                  try {
                    await ref
                        .read(wellnessProvider.notifier)
                        .logSleep(SleepLog(start: from, end: to));
                    if (context.mounted) Navigator.pop(context);
                  } catch (_) {
                    if (context.mounted) wellnessError(context);
                  } finally {
                    if (mounted) setState(() => saving = false);
                  }
                },
          child: Text(context.w('Uyku kaydını kaydet', 'Save sleep record')),
        ),
        const SizedBox(height: 16),
        Text(
          context.w(
            'Başlangıç saati uyanıştan sonraysa önceki gece kabul edilir. Aynı uyanış gününe eklediğin yeni kayıt önceki manuel kaydını günceller.',
            'If the start time is later than wake-up time, it belongs to the previous night. A new entry for the same wake-up day replaces your previous manual entry.',
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

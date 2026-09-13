import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/day_boundary.dart';
import '../../core/theme.dart';
import '../../models/wellness.dart';
import '../../providers/wellness_provider.dart';
import '../nutrition/nutrition_stats_screen.dart';
import 'wellness_ui.dart';
import 'moonlit_page.dart';
import '../../providers/cooked_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});
  @override
  ConsumerState<ProgressScreen> createState() => _ProgressState();
}

class _ProgressState extends ConsumerState<ProgressScreen> {
  bool month = false;
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(wellnessProvider);
    final now = ref.watch(wellnessNowProvider);
    final today = DateTime.parse(DayBoundary.keyFor(now));
    final length = month ? 30 : 7;
    final dates = List.generate(
      length,
      (i) => DateTime(today.year, today.month, today.day - length + 1 + i),
    );
    final keys = dates.map(calendarDay).toSet();
    final checks = data.checkIns.where((c) => keys.contains(c.dayKey)).toList();
    final energyCount = checks.where((c) => c.energy != null).length;
    final routines = data.routines
        .where((r) => keys.contains(r.dayKey))
        .toList();
    final cooked = ref
        .watch(cookedProvider)
        .where((e) => keys.contains(DayBoundary.keyFor(e.dateTime)))
        .length;
    final locale = Localizations.localeOf(context).languageCode;
    return MoonlitPage(
      header: SceneTitle(title: context.w('Gelişimin', 'Your progress')),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                '${DateFormat('d MMM', locale).format(dates.first)} – ${DateFormat('d MMM', locale).format(dates.last)}',
                style: TextStyle(
                  fontSize: 14,
                  color: context.palette.textPrimary,
                ),
              ),
              SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(
                    fontFamily: 'WellnessSans',
                    fontSize: 12,
                  ),
                  selectedBackgroundColor: context.palette.surface,
                  selectedForegroundColor: context.palette.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: false,
                    label: Text(context.w('Hafta', 'Week')),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text(context.w('Ay', 'Month')),
                  ),
                ],
                selected: {month},
                onSelectionChanged: (s) => setState(() => month = s.first),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: .5),
        const SizedBox(height: 19),
        Text(
          context.w('Enerji kayıtların', 'Your energy records'),
          style: TextStyle(fontSize: 18, color: context.palette.textPrimary),
        ),
        const SizedBox(height: 5),
        Text(
          context.w(
            'Kendi bildirimin · $energyCount/$length gün',
            'Self-reported · $energyCount/$length days',
          ),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, size) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: month ? 1300 : size.maxWidth,
              height:
                  164 + (MediaQuery.textScalerOf(context).scale(12) - 12) * 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 43,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        ...[
                          context.w('Yüksek', 'High'),
                          context.w('Orta', 'Medium'),
                          context.w('Düşük', 'Low'),
                        ].map(
                          (v) => SizedBox(
                            height: 34,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                v,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...dates.map((day) {
                    final energy = checks
                        .where((c) => c.dayKey == calendarDay(day))
                        .firstOrNull
                        ?.energy;
                    return Expanded(
                      child: InkWell(
                        onTap: () => _detail(context, ref, day),
                        child: Semantics(
                          button: true,
                          label:
                              '${DateFormat.yMMMd(locale).format(day)}: ${energy ?? context.w('kayıt yok', 'no record')}',
                          child: Column(
                            children: [
                              Text(
                                month
                                    ? '${day.day}'
                                    : DateFormat.E(locale).format(day),
                                style: const TextStyle(fontSize: 11),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 103,
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        26,
                                        (_) => Container(
                                          width: .5,
                                          height: 2,
                                          color: context.palette.dividerColor,
                                        ),
                                      ),
                                    ),
                                    if (energy != null)
                                      Positioned(
                                        top: (3 - energy) * 34 + 13,
                                        child: Container(
                                          width: 13,
                                          height: 13,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: context.palette.mint,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (energy == null)
                                Text(
                                  context.w('Kayıt\nyok', 'No\nrecord'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    height: 1.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          context.w(
            'Eksik günler ortalamaya katılmaz.',
            'Missing days are excluded from averages.',
          ),
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 13),
        const Divider(height: 1, thickness: .5),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      context.w('$cooked öğün', '$cooked meals'),
                      style: TextStyle(
                        fontSize: 26,
                        color: context.palette.textPrimary,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      context.w('pişirdin', 'cooked'),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                width: .5,
                height: 45,
                color: context.palette.dividerColor,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      context.w(
                        '${routines.length} mola',
                        '${routines.length} breaks',
                      ),
                      style: TextStyle(
                        fontSize: 26,
                        color: context.palette.textPrimary,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      context.w('tamamladın', 'completed'),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        WellnessCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.wb_twilight_outlined,
                    size: 28,
                    color: context.palette.moon,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.w('Bu hafta fark ettiğin', 'What you noticed'),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.palette.moon,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                energyCount == 0
                    ? context.w(
                        'İlk kaydınla hikâyen başlasın.',
                        'Let your story begin with your first entry.',
                      )
                    : context.w(
                        '$energyCount gün enerjine alan açtın.',
                        'You made room for your energy on $energyCount days.',
                      ),
                style: TextStyle(
                  fontSize: 18,
                  color: context.palette.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.w(
                  'Kayıtlarına dayalı gözlem',
                  'An observation from your records',
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _detail(context, ref, today),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.w('Kayıtlarımı gör', 'View my records')),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FineRow(
          icon: Icons.restaurant_outlined,
          title: context.w('Beslenme geçmişim', 'My nutrition history'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const NutritionStatsScreen(),
            ),
          ),
        ),
        ...dates.reversed.map(
          (day) => FineRow(
            icon: Icons.edit_note,
            title: DateFormat.yMMMd(locale).format(day),
            onTap: () => _detail(context, ref, day),
          ),
        ),
      ],
    );
  }

  void _detail(BuildContext context, WidgetRef ref, DateTime day) {
    final data = ref.read(wellnessProvider);
    final entry = data.checkIns
        .where((c) => c.dayKey == calendarDay(day))
        .lastOrNull;
    String level(int? value) =>
        value == null ? context.w('Kayıt yok', 'No record') : '$value / 3';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd(
                  Localizations.localeOf(context).languageCode,
                ).format(day),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text('${context.w('Ruh hali', 'Mood')}: ${level(entry?.mood)}'),
              Text('${context.w('Enerji', 'Energy')}: ${level(entry?.energy)}'),
              Text(
                '${context.w('Uyku hissi', 'Sleep feeling')}: ${level(entry?.sleepQuality)}',
              ),
              Text(
                '${context.w('Hissedilen stres', 'Perceived stress')}: ${level(entry?.stress)}',
              ),
              const SizedBox(height: 16),
              Text(
                context.w(
                  'Durum kayıtları 06.00’da başlayan güne aittir. Cihaz ve uyku kayıtları kendi yerel takvim günleriyle gösterilir.',
                  'Check-ins use a day starting at 06:00. Device and sleep records use their local calendar dates.',
                ),
              ),
              if (entry != null)
                TextButton.icon(
                  onPressed: () async {
                    try {
                      await ref
                          .read(wellnessProvider.notifier)
                          .update(
                            (s) => s.copyWith(
                              checkIns: s.checkIns
                                  .where((c) => c.dayKey != entry.dayKey)
                                  .toList(),
                            ),
                          );
                      if (sheet.mounted) Navigator.pop(sheet);
                    } catch (_) {
                      if (context.mounted) wellnessError(context);
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: Text(
                    context.w('Bu durum kaydını sil', 'Delete this check-in'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

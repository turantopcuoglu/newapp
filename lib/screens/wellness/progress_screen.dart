import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../components/empty_state_artwork.dart';
import '../../components/scene_banner.dart';
import '../../core/atmosphere_surface.dart';
import '../../core/day_boundary.dart';
import '../../core/theme.dart';
import '../../models/wellness.dart';
import '../../providers/cooked_provider.dart';
import '../../providers/wellness_provider.dart';
import '../../services/weekly_insight.dart';
import '../nutrition/nutrition_stats_screen.dart';
import 'moonlit_page.dart';
import 'wellness_ui.dart';

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
    final evenings = {
      for (final e in data.evenings)
        if (keys.contains(e.dayKey)) e.dayKey: e,
    };
    final eveningCount = evenings.values.where((e) => e.energy != null).length;
    final routines = data.routines
        .where((r) => keys.contains(r.dayKey))
        .toList();
    final cookedLog = ref.watch(cookedProvider);
    final cooked = cookedLog
        .where((e) => keys.contains(DayBoundary.keyFor(e.dateTime)))
        .length;
    // The observation always covers the last seven app-days, whichever range
    // the chart shows.
    final insight = WeeklyInsight.from(
      dayKeys: List.generate(
        7,
        (i) => calendarDay(DateTime(today.year, today.month, today.day - i)),
      ),
      evenings: data.evenings,
      cookedDays: {for (final e in cookedLog) DayBoundary.keyFor(e.dateTime)},
      breakDays: {for (final r in data.routines) r.dayKey},
    );
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
        if (checks.isEmpty &&
            evenings.isEmpty &&
            routines.isEmpty &&
            cooked == 0) ...[
          const EmptyStateArtwork(name: 'progress'),
          Text(
            context.w(
              'Bu dönem için ilk kaydınla başla.',
              'Start with your first record for this period.',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.palette.textSecondary),
          ),
          const SizedBox(height: 20),
        ],
        const Divider(height: 1, thickness: .5),
        const SizedBox(height: 19),
        Text(
          context.w('Enerji kayıtların', 'Your energy records'),
          style: TextStyle(fontSize: 18, color: context.palette.textPrimary),
        ),
        const SizedBox(height: 5),
        Text(
          context.w(
            'Kendi bildirimin · sabah $energyCount, akşam $eveningCount / $length gün',
            'Self-reported · morning $energyCount, evening $eveningCount / $length days',
          ),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, size) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width:
                  ((month ? 1300.0 : 351.0) *
                          MediaQuery.textScalerOf(context).scale(12) /
                          12)
                      .clamp(size.maxWidth, double.infinity),
              // Day label + 103 px track + two-line "no record" label;
              // 172 leaves room for fonts with taller line boxes.
              height:
                  172 + (MediaQuery.textScalerOf(context).scale(12) - 12) * 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 43 * MediaQuery.textScalerOf(context).scale(12) / 12,
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
                    final evening = evenings[calendarDay(day)]?.energy;
                    double top(int level) => (3 - level) * 34 + 13;
                    return Expanded(
                      child: InkWell(
                        onTap: () => _detail(context, ref, day),
                        child: Semantics(
                          button: true,
                          label:
                              '${DateFormat.yMMMd(locale).format(day)}: '
                              '${context.w('sabah', 'morning')} ${energy ?? context.w('kayıt yok', 'no record')}, '
                              '${context.w('akşam', 'evening')} ${evening ?? context.w('kayıt yok', 'no record')}',
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
                                    // Morning: filled dot, left. Evening:
                                    // ring, right. Same level stays readable.
                                    if (energy != null)
                                      Positioned(
                                        top: top(energy),
                                        child: Transform.translate(
                                          offset: Offset(
                                            evening == null ? 0 : -5,
                                            0,
                                          ),
                                          child: const _EnergyMark(),
                                        ),
                                      ),
                                    if (evening != null)
                                      Positioned(
                                        top: top(evening),
                                        child: Transform.translate(
                                          offset: Offset(
                                            energy == null ? 0 : 5,
                                            0,
                                          ),
                                          child: const _EnergyMark(
                                            evening: true,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (energy == null && evening == null)
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
        Wrap(
          spacing: 14,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _EnergyMark(),
                const SizedBox(width: 6),
                Text(
                  context.w('Sabah', 'Morning'),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _EnergyMark(evening: true),
                const SizedBox(width: 6),
                Text(
                  context.w('Akşam', 'Evening'),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Text(
              context.w(
                'Eksik günler ortalamaya katılmaz.',
                'Missing days are excluded from averages.',
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ],
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
        _WeeklyInsightCard(
          insight: insight,
          onRecords: () => _detail(context, ref, today),
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
    final evening = data.evenings
        .where((e) => e.dayKey == calendarDay(day))
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
                context.w('Akşam', 'Evening'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                '${context.w('Enerji', 'Energy')}: ${level(evening?.energy)}',
              ),
              Text('${context.w('Ruh hali', 'Mood')}: ${level(evening?.mood)}'),
              if (evening?.note case final note?) Text('“$note”'),
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
              if (evening != null)
                TextButton.icon(
                  onPressed: () async {
                    try {
                      await ref
                          .read(wellnessProvider.notifier)
                          .deleteEvening(evening.dayKey);
                      if (sheet.mounted) Navigator.pop(sheet);
                    } catch (_) {
                      if (context.mounted) wellnessError(context);
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: Text(
                    context.w('Akşam kaydını sil', 'Delete evening record'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One energy level on the chart: the morning answer is a filled dot, the
/// evening one a ring, so both fit on the same day without a second chart.
class _EnergyMark extends StatelessWidget {
  final bool evening;
  const _EnergyMark({this.evening = false});
  @override
  Widget build(BuildContext context) => Container(
    width: 13,
    height: 13,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: evening ? null : context.palette.mint,
      border: evening
          ? Border.all(color: context.palette.mint, width: 2.2)
          : null,
    ),
  );
}

/// The week in one sentence, from the user's own records. It says how often
/// two things happened together, never why.
class _WeeklyInsightCard extends StatelessWidget {
  final WeeklyInsight insight;
  final VoidCallback onRecords;
  const _WeeklyInsightCard({required this.insight, required this.onRecords});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return AtmosphereSurface(
      radius: 18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SceneBanner(
              scene: 'weekly_insight',
              height: 112,
              title: context.w('Bu hafta fark ettiğin', 'What you noticed'),
              subtitle: context.w('Son 7 gün', 'Last 7 days'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.text(locale),
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.35,
                      color: context.palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insight.kind == InsightKind.notEnough
                        ? context.w(
                            'Akşam kartı Bugün sekmesinde 19.00’dan sonra açılır.',
                            'The evening card opens on Today after 19:00.',
                          )
                        : context.w(
                            'Kayıtlarına dayalı bir gözlem; neden-sonuç iddiası değil.',
                            'An observation from your records, not a cause.',
                          ),
                    style: const TextStyle(fontSize: 13),
                  ),
                  TextButton(
                    onPressed: onRecords,
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
          ],
        ),
      ),
    );
  }
}

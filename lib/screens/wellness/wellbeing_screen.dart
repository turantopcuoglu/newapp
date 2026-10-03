import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/beverage_provider.dart';
import '../../providers/wellness_provider.dart';
import '../beverages/beverages_screen.dart';
import 'health_connections_screen.dart';
import 'routines_screen.dart';
import 'moonlit_page.dart';
import 'mood_widgets.dart';
import 'wellness_ui.dart';

/// Everything that is not food: short guided breaks, then the things that
/// run across the day. Food lives in Nourish and the day's picks in Today,
/// so no tile here repeats another tab.
class WellbeingScreen extends ConsumerWidget {
  const WellbeingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(wellnessProvider);
    ref.watch(beverageProvider);
    final water = ref.read(beverageProvider.notifier).totalWaterToday();
    void open(Widget child) =>
        Navigator.push(context, MaterialPageRoute<void>(builder: (_) => child));
    // Tile names are one word: the routine's own title ("Omuzlarına alan
    // aç") wraps to two lines and leaves no room for the duration.
    final tiles = {
      'breathe': ('wind', context.w('Nefes', 'Breathe')),
      'mindful': ('meditation', context.w('Meditasyon', 'Meditate')),
      'walk': ('walk', context.w('Yürüyüş', 'Walk')),
      'stretch': ('stretch', context.w('Esneme', 'Stretch')),
    };
    final bedtime = data.bedtimeMinutes;
    return MoonlitPage(
      header: SceneTitle(
        eyebrow: 'NutriGuide',
        title: context.w('İyi oluş', 'Wellbeing'),
        subtitle: context.w(
          'Kısa molalar ve günün ritmi.',
          'Short breaks and the rhythm of your day.',
        ),
      ),
      children: [
        Text(
          context.w('Bir mola seç', 'Choose a break'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        FeatureGrid(
          height: 156,
          children: [
            for (final r in routineLibrary)
              FeatureTile(
                title: tiles[r.id]?.$2 ?? context.w(r.tr, r.en),
                kind: tiles[r.id]?.$1 ?? 'leaf',
                detail: durationLabel(context, r.minutes),
                onTap: () => openRoutine(context, r),
              ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          context.w('Gün boyu', 'Through the day'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        FeatureGrid(
          height: 156,
          children: [
            FeatureTile(
              title: context.w('Uyku', 'Sleep'),
              kind: 'moon',
              detail: bedtime == null
                  ? context.w('Saat seç', 'Set a time')
                  : '${bedtime ~/ 60}:${(bedtime % 60).toString().padLeft(2, '0')}',
              onTap: () => open(const SleepScreen()),
            ),
            FeatureTile(
              title: context.w('Alışkanlıklar', 'Habits'),
              kind: 'calendar',
              detail: data.habits.isEmpty
                  ? context.w('Bir tane ekle', 'Add one')
                  : context.w(
                      '${data.habits.length} alışkanlık',
                      '${data.habits.length} habits',
                    ),
              onTap: () => open(
                Scaffold(
                  appBar: AppBar(
                    title: Text(
                      context.w(
                        'Rutinler ve alışkanlıklar',
                        'Routines and habits',
                      ),
                    ),
                  ),
                  body: const RoutinesScreen(),
                ),
              ),
            ),
            FeatureTile(
              title: context.w('Su', 'Water'),
              kind: 'water',
              detail: context.w('Bugün $water ml', '$water ml today'),
              onTap: () => open(const BeveragesScreen()),
            ),
            FeatureTile(
              title: context.w('Sağlık verileri', 'Health data'),
              kind: 'heart',
              detail: data.healthEnabled
                  ? context.w('Bağlı', 'Connected')
                  : context.w('Bağlı değil', 'Not connected'),
              onTap: () => open(const HealthConnectionsScreen()),
            ),
          ],
        ),
      ],
    );
  }
}

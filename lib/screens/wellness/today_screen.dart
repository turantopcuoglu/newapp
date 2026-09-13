import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import '../../core/atmosphere_surface.dart';
import '../../core/enums.dart';
import '../../providers/profile_provider.dart';
import '../../providers/beverage_provider.dart';
import '../../providers/wellness_provider.dart';
import '../beverages/beverages_screen.dart';
import 'discover_screen.dart';
import 'mood_picker_screen.dart';
import 'mood_widgets.dart';
import 'nourish_screen.dart';
import 'routines_screen.dart';
import 'wellness_ui.dart';
import 'moonlit_assets.dart';
import 'moonlit_page.dart';

class TodayScreen extends ConsumerWidget {
  final ValueChanged<int> navigate;
  const TodayScreen({super.key, required this.navigate});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final check = ref.watch(todayCheckInProvider);
    final profile = ref.watch(profileProvider);
    final recipes = ref.watch(wellnessRecipesProvider);
    final name = profile.name?.trim();
    void choose() => Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const MoodPickerScreen()),
    );
    final label = check?.focus == null
        ? context.w('Bugün nasılsın?', 'How are you?')
        : context.w(
            MoodPalette.all[check!.focus]!.tr,
            MoodPalette.all[check.focus]!.en,
          );
    return MoonlitPage(
      header: MoonlitHeader(
        minHeight: 174,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NutriGuide', style: TextStyle(fontSize: 17)),
                      Text(
                        context.w('Bugün', 'Today'),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                          color: p.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 48),
                    side: BorderSide(color: p.dividerColor, width: .8),
                  ),
                  onPressed: () => navigate(4),
                  child: Text(
                    name?.isNotEmpty == true
                        ? name!.characters.first.toUpperCase()
                        : 'N',
                    style: TextStyle(fontSize: 18, color: p.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            IntrinsicWidth(
              child: MotionTap(
                onTap: choose,
                builder: (context, t) => AtmosphereSurface(
                  radius: 28,
                  activity: t,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MoodGlyph(
                          check?.focus == null
                              ? p.icon
                              : MoodPalette.all[check!.focus]!.icon,
                          size: 25,
                          progress: t,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              color: p.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: p.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.w('Kendi ritminde.', 'At your own pace.'),
              style: TextStyle(fontSize: 15, color: p.textPrimary),
            ),
          ],
        ),
      ),
      children: [
        LiftIn(
          child: recipes.isNotEmpty
              ? WellnessFoodCard(
                  scored: recipes.first,
                  onExplore: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          title: Text(context.w('Beslenme', 'Nourish')),
                        ),
                        body: const NourishScreen(),
                      ),
                    ),
                  ),
                  compact: true,
                )
              : SizedBox(
                  height: 168,
                  child: FeatureTile(
                    title: context.w('Beslenme', 'Nourish'),
                    kind: 'bowl',
                    info: context.w(
                      'Tercihlerinle eşleşen tarif bulunamadı. Beslenme ayarlarını inceleyebilirsin.',
                      'No recipes match your choices. Review your food preferences.',
                    ),
                    onTap: () => navigate(1),
                  ),
                ),
        ),
        const SizedBox(height: 10),
        FeatureGrid(
          height: 136,
          children: [
            FeatureTile(
              title: context.w('Nefes', 'Breathe'),
              kind: 'wind',
              info: context.w(
                'İki dakikalık bir mola. Işık halkası rahat bir tempoya eşlik eder; nefesini tutman gerekmez.',
                'A two-minute break. The light ring accompanies a comfortable pace; no breath holding needed.',
              ),
              onTap: () => openRoutine(context, routineLibrary[0]),
            ),
            FeatureTile(
              title: context.w('Uyku', 'Sleep'),
              kind: 'moon',
              info: context.w(
                'Uyku saatini seç, akşam hazırlığını düzenle ve uyku kaydını gör.',
                'Choose a bedtime, prepare your evening and see your sleep log.',
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const SleepScreen()),
              ),
            ),
            FeatureTile(
              title: context.w('Hareket', 'Move'),
              kind: 'walk',
              info: context.w(
                'Kısa bir yürüyüş veya esneme molası seç. Seanslar sen başlattığında çalışır.',
                'Choose a short walk or stretch. Sessions begin when you start them.',
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const MovementScreen()),
              ),
            ),
            FeatureTile(
              title: context.w('Su', 'Water'),
              kind: 'water',
              info: context.w(
                'İçtiğin suyu kaydet. Kayıt miktarını sen seçersin; tek dokunuşla geri alabilirsin.',
                'Log the water you drink. You choose the amount and can undo a log.',
              ),
              onTap: () => showWaterSheet(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 10),
        MotionTap(
          onTap: choose,
          builder: (context, t) => AtmosphereSurface(
            radius: 16,
            activity: t,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MoodGlyph('settings', size: 26, progress: t),
                  const SizedBox(width: 12),
                  Text(
                    context.w('Durumu değiştir', 'Change check-in'),
                    style: TextStyle(fontSize: 15, color: p.textPrimary),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showWaterSheet(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _WaterBreakSheet(),
    );

class _WaterBreakSheet extends ConsumerStatefulWidget {
  const _WaterBreakSheet();
  @override
  ConsumerState<_WaterBreakSheet> createState() => _WaterBreakState();
}

class _WaterBreakState extends ConsumerState<_WaterBreakSheet> {
  String? lastId;
  @override
  Widget build(BuildContext context) {
    ref.watch(beverageProvider);
    final water = ref.read(beverageProvider.notifier).totalWaterToday();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MoodGlyph('water', size: 74),
          const SizedBox(height: 12),
          Text(
            context.w('Su molası', 'Water break'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: reducedMotion(context)
                ? Duration.zero
                : const Duration(milliseconds: 350),
            child: Text(
              '$water ml',
              key: ValueKey(water),
              style: TextStyle(fontSize: 36, color: context.palette.mint),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [150, 250, 500]
                .map(
                  (amount) => FilledButton(
                    onPressed: () {
                      ref
                          .read(beverageProvider.notifier)
                          .addEntry(
                            type: BeverageType.water,
                            milliliters: amount,
                          );
                      setState(
                        () => lastId = ref.read(beverageProvider).last.id,
                      );
                    },
                    child: Text('+$amount ml'),
                  ),
                )
                .toList(),
          ),
          if (lastId != null)
            TextButton.icon(
              icon: const Icon(Icons.undo),
              label: Text(context.w('Geri al', 'Undo')),
              onPressed: () {
                ref.read(beverageProvider.notifier).removeEntry(lastId!);
                setState(() => lastId = null);
              },
            ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.push(
                MaterialPageRoute<void>(
                  builder: (_) => const BeveragesScreen(),
                ),
              );
            },
            child: Text(
              context.w('Tüm içecekler ve kayıtlar', 'All drinks and records'),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showGoalPicker(BuildContext context, WidgetRef ref) async {
  final selected = ref.read(wellnessProvider).goals.toSet();
  final choices = [
    (
      'nutrition',
      context.w('Dengeli beslenme', 'Balanced eating'),
      Icons.restaurant_outlined,
    ),
    (
      'sleep',
      context.w('Uyku düzeni', 'Sleep routine'),
      Icons.bedtime_outlined,
    ),
    (
      'movement',
      context.w('Günlük hareket', 'Daily movement'),
      Icons.directions_walk,
    ),
    (
      'calm',
      context.w('Sakinleşme ve odak', 'Calm and focus'),
      Icons.spa_outlined,
    ),
  ];
  final result = await showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, setSheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.w(
                  'Neye alan açmak istersin?',
                  'What would you like to make room for?',
                ),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                context.w(
                  'En fazla üç alan seç. Sonra değiştirebilirsin.',
                  'Choose up to three areas. You can change them later.',
                ),
              ),
              ...choices.map(
                (c) => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: Icon(c.$3, color: context.palette.mint),
                  title: Text(c.$2),
                  value: selected.contains(c.$1),
                  onChanged: (on) => setSheet(() {
                    if (on == true && selected.length < 3) {
                      selected.add(c.$1);
                    } else if (on == false) {
                      selected.remove(c.$1);
                    }
                  }),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: selected.isEmpty
                      ? null
                      : () => Navigator.pop(sheet, selected.toList()),
                  child: Text(context.w('Bana göre düzenle', 'Make it mine')),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  if (result != null && context.mounted) {
    await saveWellness(
      context,
      () => ref
          .read(wellnessProvider.notifier)
          .update((s) => s.copyWith(goals: result, setupDone: true)),
    );
  }
}

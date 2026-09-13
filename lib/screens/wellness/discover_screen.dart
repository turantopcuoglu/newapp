import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/wellness_provider.dart';
import '../planner/planner_screen.dart';
import '../shopping/shopping_screen.dart';
import '../recipe_book/recipe_book_screen.dart';
import '../beverages/beverages_screen.dart';
import 'check_in_screen.dart';
import 'health_connections_screen.dart';
import 'nourish_screen.dart';
import 'routines_screen.dart';
import 'moonlit_page.dart';
import 'mood_widgets.dart';
import 'wellness_ui.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context) {
    void open(Widget child) =>
        Navigator.push(context, MaterialPageRoute<void>(builder: (_) => child));
    return MoonlitPage(
      header: SceneTitle(
        eyebrow: 'NutriGuide',
        title: context.w('Keşfet', 'Explore'),
        subtitle: context.w(
          'Kendine bir alan aç.',
          'Make a little room for yourself.',
        ),
      ),
      children: [
        FeatureGrid(
          children: [
            FeatureTile(
              title: context.w('Beslenme', 'Nourish'),
              kind: 'bowl',
              onTap: () => open(
                Scaffold(
                  appBar: AppBar(title: Text(context.w('Beslenme', 'Nourish'))),
                  body: const NourishScreen(),
                ),
              ),
              info: context.w(
                'Durumun, alerjilerin ve mutfağına uygun besinler ve tarifler.',
                'Food and recipes for your check-in, allergies and pantry.',
              ),
            ),
            FeatureTile(
              title: context.w('Nefes', 'Breathe'),
              kind: 'wind',
              onTap: () => openRoutine(context, routineLibrary[0]),
              info: context.w(
                'İki dakikalık görsel rehberli nefes molası.',
                'A two-minute breathing break with a visual guide.',
              ),
            ),
            FeatureTile(
              title: context.w('Meditasyon', 'Meditate'),
              kind: 'meditation',
              onTap: () => openRoutine(context, routineLibrary[1]),
              info: context.w(
                'Üç dakikalık farkındalık molası. Ses, temas ve dikkat için kısa bir rehber.',
                'A three-minute mindfulness break with a short guide to sound, contact and attention.',
              ),
            ),
            FeatureTile(
              title: context.w('Uyku', 'Sleep'),
              kind: 'moon',
              onTap: () => open(const SleepScreen()),
              info: context.w(
                'Akşam hazırlığı, yatış saati ve uyku kayıtları.',
                'Evening preparation, bedtime and sleep records.',
              ),
            ),
            FeatureTile(
              title: context.w('Hareket', 'Move'),
              kind: 'walk',
              onTap: () => open(const MovementScreen()),
              info: context.w(
                'Yürüyüş ve esneme seansları. İstediğin zaman duraklatabilirsin.',
                'Walking and stretching sessions. Pause whenever you wish.',
              ),
            ),
            FeatureTile(
              title: context.w('Su', 'Water'),
              kind: 'water',
              onTap: () => open(const BeveragesScreen()),
              info: context.w(
                'Su ve diğer içeceklerini miktarıyla birlikte kaydet.',
                'Record water and other drinks with their amounts.',
              ),
            ),
            FeatureTile(
              title: context.w('Alışkanlıklar', 'Habits'),
              kind: 'calendar',
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
              info: context.w(
                'Kendi küçük alışkanlıklarını oluştur ve tamamladığında işaretle.',
                'Create your own small habits and check them off when completed.',
              ),
            ),
            FeatureTile(
              title: context.w('Sağlık verileri', 'Health data'),
              kind: 'heart',
              onTap: () => open(const HealthConnectionsScreen()),
              info: context.w(
                'Desteklenen cihaz kaynaklarından uyku, adım ve egzersiz verileri. Her veri türü için izin kontrolün sende.',
                'Sleep, steps and workouts from supported device sources. You control access to each data type.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          context.w('Mutfak araçların', 'Your kitchen tools'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        FeatureGrid(
          children: [
            FeatureTile(
              title: context.w('Tarif kitabı', 'Recipe book'),
              kind: 'bowl',
              onTap: () => open(const RecipeBookScreen()),
            ),
            FeatureTile(
              title: context.w('Öğün planı', 'Meal plan'),
              kind: 'calendar',
              onTap: () => open(const PlannerScreen()),
            ),
            FeatureTile(
              title: context.w('Alışveriş', 'Shopping'),
              kind: 'leaf',
              onTap: () => open(const ShoppingScreen()),
            ),
            FeatureTile(
              title: context.w('Günlük kayıt', 'Check-in'),
              kind: 'settings',
              onTap: () => open(const WellnessCheckInScreen()),
            ),
          ],
        ),
      ],
    );
  }
}

class MovementScreen extends StatelessWidget {
  const MovementScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.w('Hareket', 'Move'))),
    body: MoonlitPage(
      header: SceneTitle(
        title: context.w(
          'Biraz hareket.\nSana göre.',
          'A little movement.\nAt your pace.',
        ),
      ),
      children: [
        FeatureGrid(
          height: 180,
          children: [
            FeatureTile(
              title: context.w('Yürüyüş', 'Walk'),
              kind: 'walk',
              detail: context.w('10 dakika', '10 minutes'),
              info: context.w(
                routineLibrary[2].trGuide,
                routineLibrary[2].enGuide,
              ),
              onTap: () => openRoutine(context, routineLibrary[2]),
            ),
            FeatureTile(
              title: context.w('Esneme', 'Stretch'),
              kind: 'stretch',
              detail: context.w('5 dakika', '5 minutes'),
              info: context.w(
                routineLibrary[3].trGuide,
                routineLibrary[3].enGuide,
              ),
              onTap: () => openRoutine(context, routineLibrary[3]),
            ),
          ],
        ),
      ],
    ),
  );
}

class DailyPlanScreen extends ConsumerWidget {
  const DailyPlanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(wellnessProvider);
    void open(Widget child) =>
        Navigator.push(context, MaterialPageRoute<void>(builder: (_) => child));
    return MoonlitPage(
      header: SceneTitle(
        eyebrow: 'NutriGuide',
        title: context.w('Planın', 'Your plan'),
        subtitle: context.w(
          'Gününe küçük molalar ekle.',
          'Make room for small breaks.',
        ),
      ),
      children: [
        FeatureGrid(
          height: 160,
          children: [
            FeatureTile(
              title: context.w('Öğünler', 'Meals'),
              kind: 'bowl',
              onTap: () => open(const PlannerScreen()),
            ),
            FeatureTile(
              title: context.w('Akşam hazırlığı', 'Wind down'),
              kind: 'moon',
              detail: data.bedtimeMinutes == null
                  ? null
                  : '${data.bedtimeMinutes! ~/ 60}:${(data.bedtimeMinutes! % 60).toString().padLeft(2, '0')}',
              onTap: () => open(const SleepScreen()),
            ),
            FeatureTile(
              title: context.w('Alışkanlıklar', 'Habits'),
              kind: 'calendar',
              detail: context.w(
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
              title: context.w('Günlük kayıt', 'Check-in'),
              kind: 'heart',
              onTap: () => open(const WellnessCheckInScreen()),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          context.w('Bir mola seç', 'Choose a break'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        FeatureGrid(
          children: List.generate(routineLibrary.length, (i) {
            final r = routineLibrary[i];
            return FeatureTile(
              title: context.w(
                ['Nefes', 'Meditasyon', 'Yürüyüş', 'Esneme'][i],
                ['Breathe', 'Meditate', 'Walk', 'Stretch'][i],
              ),
              kind: ['wind', 'meditation', 'walk', 'stretch'][i],
              detail: context.w('${r.minutes} dakika', '${r.minutes} minutes'),
              onTap: () => openRoutine(context, r),
            );
          }),
        ),
      ],
    );
  }
}

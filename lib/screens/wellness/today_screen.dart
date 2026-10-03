import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/cooked_tick.dart';
import '../../components/meal_type_badge.dart';
import '../../core/atmosphere_surface.dart';
import '../../core/day_boundary.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import '../../data/focus_guidance.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/beverage_provider.dart';
import '../../providers/cooked_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/wellness_provider.dart';
import '../../services/day_meal_list.dart';
import '../../services/recipe_timing.dart';
import '../beverages/beverages_screen.dart';
import '../planner/planner_screen.dart';
import 'mood_picker_screen.dart';
import 'mood_widgets.dart';
import 'moonlit_assets.dart';
import 'moonlit_page.dart';
import 'nourish_screen.dart';
import 'routines_screen.dart';
import 'wellness_ui.dart';

/// Tab index of Nourish in [MainShell]; Today hands off to it for more
/// recipes instead of pushing a second copy of the screen.
const int nourishTabIndex = 1;

/// The check-in chip under the title; its label changes with the day's
/// focus, so tests find it by key.
const todayCheckInKey = ValueKey('today-check-in');

/// The day in one screen: how you are, what to eat and why, two small
/// steps, and what you have eaten so far. Each block answers "what now?";
/// browsing lives in the other tabs.
class TodayScreen extends ConsumerWidget {
  final ValueChanged<int> navigate;
  const TodayScreen({super.key, required this.navigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final check = ref.watch(todayCheckInProvider);
    final profile = ref.watch(profileProvider);
    final now = ref.watch(wellnessNowProvider);
    final name = profile.name?.trim();
    void checkIn() => Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const MoodPickerScreen()),
    );
    final focus = check?.focus;
    final label = focus == null
        ? context.w('Bugün nasılsın?', 'How are you?')
        : context.w(MoodPalette.all[focus]!.tr, MoodPalette.all[focus]!.en);
    final greeting = now.hour < 12
        ? context.w('Günaydın', 'Good morning')
        : now.hour < 18
        ? context.w('İyi günler', 'Good afternoon')
        : context.w('İyi akşamlar', 'Good evening');
    return MoonlitPage(
      header: MoonlitHeader(
        minHeight: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name?.isNotEmpty == true
                            ? '$greeting, $name'
                            : greeting,
                        style: const TextStyle(fontSize: 17),
                      ),
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
            // Before the day's check-in the prompt card below asks the same
            // question, so the chip only appears once there is an answer.
            if (check != null) ...[
              const SizedBox(height: 12),
              IntrinsicWidth(
                child: MotionTap(
                  key: todayCheckInKey,
                  onTap: checkIn,
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
                            focus == null
                                ? p.icon
                                : MoodPalette.all[focus]!.icon,
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
            ],
          ],
        ),
      ),
      children: [
        if (check == null) ...[
          LiftIn(child: _CheckInPrompt(onStart: checkIn)),
          const SizedBox(height: 22),
        ],
        LiftIn(
          order: 1,
          child: _ForYou(onMore: () => navigate(nourishTabIndex)),
        ),
        const SizedBox(height: 26),
        LiftIn(
          order: 2,
          child: _SmallSteps(focus: focus, hour: now.hour),
        ),
        const SizedBox(height: 26),
        LiftIn(order: 3, child: _TodayMeals(now: now)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: context.palette.textPrimary,
      ),
    ),
  );
}

/// Shown until the day's check-in exists. Without it the recommendation
/// falls back to pantry order, and the card says so.
class _CheckInPrompt extends StatelessWidget {
  final VoidCallback onStart;
  const _CheckInPrompt({required this.onStart});
  @override
  Widget build(BuildContext context) => AtmosphereSurface(
    radius: 18,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.w('Bugün nasılsın?', 'How are you today?'),
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: context.palette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.w(
              'İki dokunuşluk bir kayıt. Önerdiğimiz öğünü ve küçük adımları buna göre seçeriz.',
              'Two taps. We pick your meal and small steps from it.',
            ),
            style: const TextStyle(fontSize: 14, height: 1.3),
          ),
          const SizedBox(height: 14),
          MoonButton(
            label: context.w('Başlayalım', 'Let’s start'),
            onPressed: onStart,
          ),
        ],
      ),
    ),
  );
}

/// The day's recommendation, with the sentence that says why it came first.
class _ForYou extends ConsumerWidget {
  final VoidCallback onMore;
  const _ForYou({required this.onMore});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(wellnessRecipesProvider);
    final check = ref.watch(todayCheckInProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final chosen = recipes.firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(context.w('Bugün senin için', 'For you today')),
        if (chosen == null)
          Text(
            context.w(
              'Seçimlerinle eşleşen tarif bulamadık. Hazırlık süresini veya beslenme tercihlerini değiştirmeyi deneyebilirsin.',
              'No recipe matches your choices. Try another preparation time or food preference.',
            ),
          )
        else ...[
          WellnessFoodCard(scored: chosen),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 22,
                color: context.palette.moon,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  [
                    recommendationReason(chosen.recipe, check?.focus, locale),
                    if (RecipeTiming.minutes(chosen.recipe) case final m?)
                      context.w('Hazırlık ~$m dk.', 'About $m min to make.'),
                  ].join(' '),
                  style: const TextStyle(fontSize: 13, height: 1.35),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onMore,
              child: Text(context.w('Başka öneriler', 'More suggestions')),
            ),
          ),
        ],
      ],
    );
  }
}

/// Two steps chosen by the check-in. In the evening the second one becomes
/// the wind-down, since that is what the time of day calls for.
class _SmallSteps extends ConsumerWidget {
  final CheckInType? focus;
  final int hour;
  const _SmallSteps({required this.focus, required this.hour});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = [
      ...(focusGuidance[focus]?.steps ?? const ['walk', 'breathe']),
    ].take(2).toList();
    if (hour >= 19) steps[steps.length - 1] = 'sleep';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(context.w('Küçük adımlar', 'Small steps')),
        for (final step in steps) _step(context, ref, step),
      ],
    );
  }

  Widget _step(BuildContext context, WidgetRef ref, String id) {
    if (id == 'water') {
      ref.watch(beverageProvider);
      final ml = ref.read(beverageProvider.notifier).totalWaterToday();
      return FineRow(
        icon: Icons.water_drop_outlined,
        title: context.w('Su · bugün $ml ml', 'Water · $ml ml today'),
        trailing: const Icon(Icons.add_circle_outline, size: 22),
        onTap: () => showWaterSheet(context, ref),
      );
    }
    if (id == 'sleep') {
      return FineRow(
        icon: Icons.bedtime_outlined,
        title: context.w('Akşam hazırlığı', 'Wind down for the night'),
        trailing: const Icon(Icons.chevron_right, size: 22),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const SleepScreen()),
        ),
      );
    }
    final routine = routineLibrary.firstWhere((r) => r.id == id);
    return FineRow(
      icon: routine.icon,
      title:
          '${context.w(routine.tr, routine.en)} · ${durationLabel(context, routine.minutes)}',
      trailing: const Icon(Icons.play_circle_outline, size: 24),
      onTap: () => openRoutine(context, routine),
    );
  }
}

/// Planned and cooked meals for the app-day. The tick is the one way a meal
/// counts as eaten: the plan alone never feeds the totals.
class _TodayMeals extends ConsumerWidget {
  final DateTime now;
  const _TodayMeals({required this.now});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    // The app-day, so a late-night meal stays on the day it belongs to.
    final day = DateTime.parse(DayBoundary.keyFor(now));
    final items = buildDayMealList(
      date: day,
      plans: ref.watch(mealPlanProvider),
      cooked: ref.watch(cookedProvider),
    );
    final recipes = ref.watch(recipeMapProvider);
    final totals = ref.watch(consumedTodayProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(context.w('Bugünkü öğünlerin', 'Today’s meals')),
        if (items.isEmpty)
          Text(
            context.w(
              'Bir tarifi pişirdiğinde ya da planına eklediğinde burada görünür.',
              'Meals appear here once you cook or plan a recipe.',
            ),
            style: const TextStyle(fontSize: 13),
          ),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                CookedTick(
                  isCooked: item.isCooked,
                  size: 28,
                  tooltip: item.isCooked
                      ? l10n.mealListMarkNotCooked
                      : l10n.mealListMarkCooked,
                  onTap: recipes[item.recipeId] == null
                      ? null
                      : () => ref
                            .read(cookedProvider.notifier)
                            .toggleForDay(recipes[item.recipeId]!, day),
                ),
                const SizedBox(width: 10),
                MealTypeBadge(mealType: item.mealType),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    recipes[item.recipeId]?.localizedName(locale) ??
                        context.w('Silinmiş tarif', 'Deleted recipe'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (totals.mealCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              context.w(
                'Bugün ${totals.mealCount} öğün · ${totals.calories} kcal',
                '${totals.mealCount} meals today · ${totals.calories} kcal',
              ),
              style: TextStyle(fontSize: 13, color: context.palette.moon),
            ),
          ),
        FineRow(
          icon: Icons.calendar_month_outlined,
          title: context.w('Öğün planım', 'My meal plan'),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const PlannerScreen()),
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
                : const Duration(milliseconds: 250),
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

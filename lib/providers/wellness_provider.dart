import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/day_boundary.dart';
import '../core/enums.dart';
import '../core/mood_palette.dart';
import '../models/wellness.dart';
import '../services/wellness_store.dart';
import '../services/recipe_timing.dart';
import 'recipe_provider.dart';
import '../services/recommendation_service.dart';

final wellnessStoreProvider = Provider<WellnessStore>(
  (ref) => throw UnimplementedError('WellnessStore must be opened at startup'),
);

class WellnessNotifier extends StateNotifier<WellnessData> {
  final WellnessStore store;
  Future<void> _tail = Future.value();
  WellnessNotifier(this.store) : super(store.initial);

  Future<void> update(WellnessData Function(WellnessData) change) {
    final operation = _tail.then((_) async {
      final next = change(state);
      await store.save(next);
      if (mounted) state = next;
    });
    _tail = operation.catchError((Object _) {});
    return operation;
  }

  Future<void> checkIn(DailyCheckIn entry) => update(
    (s) => s.copyWith(
      themeMode: s.appearanceLocked ? s.themeMode : entry.focus?.name,
      contextPromptDay: entry.dayKey,
      checkIns: [...s.checkIns.where((e) => e.dayKey != entry.dayKey), entry],
    ),
  );

  Future<void> selectFocus(CheckInType focus, DateTime at) => update((s) {
    final previous = s.checkInFor(at);
    final entry = DailyCheckIn(
      recordedAt: at,
      focus: focus,
      mood: previous?.mood,
      energy: previous?.energy,
      sleepQuality: previous?.sleepQuality,
      stress: previous?.stress,
      prepMinutes: previous?.prepMinutes,
    );
    return s.copyWith(
      themeMode: s.appearanceLocked ? s.themeMode : focus.name,
      contextPromptDay: entry.dayKey,
      checkIns: [...s.checkIns.where((e) => e.dayKey != entry.dayKey), entry],
    );
  });
  Future<void> logRoutine(String id, int seconds, {DateTime? at}) => update(
    (s) => s.copyWith(
      routines: [
        ...s.routines,
        RoutineLog(id: id, at: at ?? DateTime.now(), seconds: seconds),
      ],
    ),
  );
  Future<void> logSleep(SleepLog entry) {
    if (entry.minutes <= 0 ||
        entry.minutes > 24 * 60 ||
        entry.end.isAfter(DateTime.now())) {
      return Future.error(ArgumentError('Invalid sleep interval'));
    }
    return update(
      (s) => s.copyWith(
        sleep: [...s.sleep.where((e) => e.dayKey != entry.dayKey), entry],
      ),
    );
  }

  Future<void> toggleEvening(String id, DateTime day) => update((s) {
    final key = DayBoundary.keyFor(day);
    final checks = [...s.eveningChecks[key] ?? <String>[]];
    checks.contains(id) ? checks.remove(id) : checks.add(id);
    return s.copyWith(eveningChecks: {...s.eveningChecks, key: checks});
  });
  Future<void> toggleHabit(String id, DateTime day) => update((s) {
    final key = DayBoundary.keyFor(day);
    final checks = [...s.habitChecks[key] ?? <String>[]];
    checks.contains(id) ? checks.remove(id) : checks.add(id);
    return s.copyWith(habitChecks: {...s.habitChecks, key: checks});
  });
  Future<void> deleteAll() => update((_) => const WellnessData());
}

final wellnessProvider = StateNotifierProvider<WellnessNotifier, WellnessData>(
  (ref) => WellnessNotifier(ref.watch(wellnessStoreProvider)),
);

/// Clock is injectable; the shell invalidates it on resume and each minute.
final wellnessNowProvider = Provider<DateTime>((ref) => DateTime.now());
final todayCheckInProvider = Provider<DailyCheckIn?>(
  (ref) =>
      ref.watch(wellnessProvider).checkInFor(ref.watch(wellnessNowProvider)),
);

final moodPaletteProvider = Provider<MoodPalette>((ref) {
  final data = ref.watch(wellnessProvider);
  final mode =
      CheckInType.values.where((m) => m.name == data.themeMode).firstOrNull ??
      data.checkIns.lastOrNull?.focus ??
      CheckInType.lowEnergy;
  return MoodPalette.all[mode]!;
});

final wellnessRecipeChoiceProvider = StateProvider<String?>((ref) => null);
final wellnessRecipesProvider = Provider<List<ScoredRecipe>>((ref) {
  final selectedRecipe = ref.watch(wellnessRecipeChoiceProvider);
  final safe = ref.watch(safeScoredRecipesProvider);
  final checkIn = ref.watch(todayCheckInProvider);
  final minutes = checkIn?.prepMinutes;
  final hour = ref.watch(wellnessNowProvider).hour;
  final meal = hour < 11
      ? MealType.breakfast
      : hour < 16
      ? MealType.lunch
      : MealType.dinner;
  // Time is a real constraint, not an unsupported medical ranking signal.
  final result = safe
      .where(
        (s) =>
            minutes == null ||
            (RecipeTiming.minutes(s.recipe) != null &&
                RecipeTiming.minutes(s.recipe)! <= minutes),
      )
      .toList();
  result.sort((a, b) {
    final selected =
        (b.recipe.id == selectedRecipe ? 1 : 0) -
        (a.recipe.id == selectedRecipe ? 1 : 0);
    if (selected != 0) return selected;
    // Context affects ranking only after the mandatory allergy/diet filters.
    // Period-specific contexts retain the existing PMS tag fallback.
    bool matches(ScoredRecipe item) =>
        checkIn?.focus != null &&
        (item.recipe.checkInTags.contains(checkIn!.focus) ||
            ((checkIn.focus == CheckInType.periodCramps ||
                    checkIn.focus == CheckInType.periodFatigue) &&
                item.recipe.checkInTags.contains(CheckInType.pms)));
    final byFocus = (matches(b) ? 1 : 0) - (matches(a) ? 1 : 0);
    if (byFocus != 0) return byFocus;
    final byMeal =
        (b.recipe.mealType == meal ? 1 : 0) -
        (a.recipe.mealType == meal ? 1 : 0);
    if (byMeal != 0) return byMeal;
    if (checkIn?.energy == 1) {
      final quick = (RecipeTiming.minutes(a.recipe) ?? 10000).compareTo(
        RecipeTiming.minutes(b.recipe) ?? 10000,
      );
      if (quick != 0) return quick;
    }
    final byPantry = b.compatibilityScore.compareTo(a.compatibilityScore);
    return byPantry != 0 ? byPantry : a.recipe.id.compareTo(b.recipe.id);
  });
  return result;
});

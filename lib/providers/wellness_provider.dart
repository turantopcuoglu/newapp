import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/day_boundary.dart';
import '../core/enums.dart';
import '../core/mood_palette.dart';
import '../data/explore_data.dart';
import '../data/focus_guidance.dart';
import '../data/ingredient_visual.dart';
import '../models/recipe.dart';
import '../models/wellness.dart';
import '../services/wellness_store.dart';
import '../services/recipe_timing.dart';
import 'recipe_provider.dart';
import '../services/focus_rules.dart';
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

  /// Merges one evening answer into the day's record. Each tap saves, so a
  /// half-answered card is never lost; `clearNote` removes the note.
  Future<void> saveEvening(
    DateTime at, {
    int? energy,
    int? mood,
    String? note,
    bool clearNote = false,
  }) => update((s) {
    final previous = s.eveningFor(at);
    final entry = EveningCheckIn(
      recordedAt: at,
      energy: energy ?? previous?.energy,
      mood: mood ?? previous?.mood,
      note: clearNote ? null : note ?? previous?.note,
    );
    return s.copyWith(
      evenings: [...s.evenings.where((e) => e.dayKey != entry.dayKey), entry],
    );
  });

  Future<void> deleteEvening(String dayKey) => update(
    (s) => s.copyWith(
      evenings: s.evenings.where((e) => e.dayKey != dayKey).toList(),
    ),
  );

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

final todayEveningProvider = Provider<EveningCheckIn?>(
  (ref) =>
      ref.watch(wellnessProvider).eveningFor(ref.watch(wellnessNowProvider)),
);

/// The closing card belongs to the end of the app-day: from 19:00 until the
/// 06:00 reset, so a late answer still lands on the day it describes.
bool isEveningHour(DateTime now) =>
    now.hour >= 19 || now.hour < DayBoundary.resetHour;

final moodPaletteProvider = Provider<MoodPalette>((ref) {
  final data = ref.watch(wellnessProvider);
  final mode =
      CheckInType.values.where((m) => m.name == data.themeMode).firstOrNull ??
      data.checkIns.lastOrNull?.focus ??
      CheckInType.lowEnergy;
  return MoodPalette.all[mode]!;
});

/// Whether [recipe] is one the day's check-in pushes up the list. Ranking and
/// the "why this recipe" sentence both ask this, so the sentence can never
/// claim a priority the ranking did not apply. Period-specific contexts keep
/// the PMS tag as a fallback.
bool recipeMatchesFocus(Recipe recipe, CheckInType? focus) =>
    focus != null &&
    (recipeHasFocus(recipe, focus) ||
        ((focus == CheckInType.periodCramps ||
                focus == CheckInType.periodFatigue) &&
            recipe.checkInTags.contains(CheckInType.pms)));

/// The sentence under the day's recommendation. Everything specific in it
/// comes from the recipe's own data, never from the focus alone.
String recommendationReason(Recipe recipe, CheckInType? focus, String locale) {
  final tr = locale == 'tr';
  final guidance = focusGuidance[focus];
  if (guidance == null || !recipeMatchesFocus(recipe, focus)) {
    return tr ? genericReasonTr : genericReasonEn;
  }
  final parts = [guidance.reason(locale)];
  final source = guidance.nutrientSource;
  if (source != null) {
    final listed = healthConditionIngredients[source] ?? const <String>[];
    final names = recipe.ingredientIds
        .where(listed.contains)
        .take(2)
        .map((id) => ingredientById(id)?.localizedName(locale) ?? id)
        .toList();
    if (names.isNotEmpty) {
      final joined = names.join(tr ? ' ve ' : ' and ');
      final one = names.length == 1;
      parts.add(
        tr
            ? 'Bu tarifteki ${guidance.nutrientTr} '
                  '${one ? 'kaynağı' : 'kaynakları'}: $joined.'
            : '${one ? 'Source' : 'Sources'} of ${guidance.nutrientEn} '
                  'here: $joined.',
      );
    }
  }
  if (guidance.mentionsProteinFibre) {
    final protein = recipe.proteinLevel == NutrientLevel.high;
    final fibre = recipe.fiberLevel == NutrientLevel.high;
    if (protein && fibre) {
      parts.add(tr ? 'Protein ve lifi yüksek.' : 'High in protein and fibre.');
    } else if (protein) {
      parts.add(tr ? 'Proteini yüksek.' : 'High in protein.');
    } else if (fibre) {
      parts.add(tr ? 'Lifi yüksek.' : 'High in fibre.');
    }
  }
  return parts.join(' ');
}

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
    bool matches(ScoredRecipe item) =>
        recipeMatchesFocus(item.recipe, checkIn?.focus);
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

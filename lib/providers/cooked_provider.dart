import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/day_boundary.dart';
import '../models/cooked_entry.dart';
import '../models/recipe.dart';
import '../services/nutrition_calculator.dart';
import '../services/storage_service.dart';
import 'recipe_provider.dart';
import 'storage_provider.dart';

const _uuid = Uuid();

/// The log of recipes the user actually cooked. This — not the meal plan —
/// is what "consumed calories" is computed from.
class CookedNotifier extends StateNotifier<List<CookedEntry>> {
  final StorageService _storage;
  final NutritionCalculator _calculator;

  CookedNotifier(this._storage, this._calculator)
      : super(List.of(_storage.getCookedEntries()));

  /// Logs a recipe as cooked, snapshotting its per-serving macros.
  CookedEntry markCooked(
    Recipe recipe, {
    double servings = 1,
    DateTime? at,
  }) {
    final entry = CookedEntry(
      id: _uuid.v4(),
      recipeId: recipe.id,
      dateTime: at ?? DateTime.now(),
      mealType: recipe.mealType,
      servings: servings,
      macrosPerServing: _calculator.effectiveMacros(recipe),
    );
    state = [...state, entry];
    _storage.addCookedEntry(entry);
    return entry;
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
    _storage.removeCookedEntry(id);
  }

  /// Removes the most recent log of a recipe on the current app-day.
  /// Returns false when there is nothing to undo.
  bool undoToday(String recipeId) {
    final today = DayBoundary.today();
    final match = state
        .where((e) => e.recipeId == recipeId && e.dayKey == today)
        .lastOrNull;
    if (match == null) return false;
    removeEntry(match.id);
    return true;
  }

  List<CookedEntry> entriesForDay(DateTime day) {
    final key = DayBoundary.keyFor(day);
    return state.where((e) => e.dayKey == key).toList();
  }

  List<CookedEntry> entriesBetween(DateTime start, DateTime end) => state
      .where((e) =>
          !e.dateTime.isBefore(start) && e.dateTime.isBefore(end))
      .toList();
}

final cookedProvider =
    StateNotifierProvider<CookedNotifier, List<CookedEntry>>((ref) {
  return CookedNotifier(
    ref.watch(storageProvider),
    ref.watch(nutritionCalculatorProvider),
  );
});

/// Totals consumed on the current app-day.
final consumedTodayProvider = Provider<ConsumedTotals>((ref) {
  final entries = ref.watch(cookedProvider);
  final today = DayBoundary.today();
  return ConsumedTotals.from(entries.where((e) => e.dayKey == today));
});

/// Recipe ids logged as cooked on the current app-day.
final cookedTodayIdsProvider = Provider<Set<String>>((ref) {
  final entries = ref.watch(cookedProvider);
  final today = DayBoundary.today();
  return entries.where((e) => e.dayKey == today).map((e) => e.recipeId).toSet();
});

/// Summed macros over a set of cooked entries.
class ConsumedTotals {
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int fiberG;
  final int mealCount;

  const ConsumedTotals({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.fiberG = 0,
    this.mealCount = 0,
  });

  factory ConsumedTotals.from(Iterable<CookedEntry> entries) {
    var calories = 0, protein = 0, carbs = 0, fat = 0, fiber = 0, count = 0;
    for (final e in entries) {
      calories += e.calories;
      protein += e.proteinG;
      carbs += e.carbsG;
      fat += e.fatG;
      fiber += e.fiberG;
      count++;
    }
    return ConsumedTotals(
      calories: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      fiberG: fiber,
      mealCount: count,
    );
  }
}

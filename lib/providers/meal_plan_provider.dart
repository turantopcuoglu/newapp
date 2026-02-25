import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/enums.dart';
import '../models/meal_plan.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

const _uuid = Uuid();

class MealPlanNotifier extends StateNotifier<List<MealPlanEntry>> {
  final StorageService _storage;

  MealPlanNotifier(this._storage) : super(_storage.getMealPlans());

  void addEntry({
    required String recipeId,
    required DateTime date,
    required MealType mealType,
  }) {
    final entry = MealPlanEntry(
      id: _uuid.v4(),
      recipeId: recipeId,
      date: DateTime(date.year, date.month, date.day),
      mealType: mealType,
    );
    state = [...state, entry];
    _storage.addMealPlan(entry);
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
    _storage.removeMealPlan(id);
  }

  List<MealPlanEntry> entriesForDate(DateTime date) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return state.where((e) => e.dateKey == key).toList();
  }

  List<MealPlanEntry> entriesForWeek(DateTime weekStart) {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(const Duration(days: 7));
    return state
        .where((e) => !e.date.isBefore(start) && e.date.isBefore(end))
        .toList();
  }
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, List<MealPlanEntry>>((ref) {
  final storage = ref.watch(storageProvider);
  return MealPlanNotifier(storage);
});

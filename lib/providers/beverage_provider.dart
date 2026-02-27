import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../core/enums.dart';
import '../models/beverage_entry.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

const _uuid = Uuid();

class BeverageNotifier extends StateNotifier<List<BeverageEntry>> {
  final StorageService _storage;

  BeverageNotifier(this._storage) : super(List.of(_storage.getBeverages()));

  void addEntry({
    required BeverageType type,
    required int milliliters,
    int calories = 0,
    DateTime? dateTime,
  }) {
    final entry = BeverageEntry(
      id: _uuid.v4(),
      type: type,
      milliliters: milliliters,
      dateTime: dateTime ?? DateTime.now(),
      calories: calories,
    );
    state = [...state, entry];
    _storage.addBeverage(entry);
  }

  void removeEntry(String id) {
    state = state.where((e) => e.id != id).toList();
    _storage.removeBeverage(id);
  }

  List<BeverageEntry> entriesForDate(DateTime date) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return state.where((e) => e.dateKey == key).toList();
  }

  int totalWaterToday() {
    final today = DateTime.now();
    return entriesForDate(today)
        .where((e) => e.type == BeverageType.water)
        .fold(0, (sum, e) => sum + e.milliliters);
  }

  int totalCaloriesToday() {
    final today = DateTime.now();
    return entriesForDate(today).fold(0, (sum, e) => sum + e.calories);
  }
}

final beverageProvider =
    StateNotifierProvider<BeverageNotifier, List<BeverageEntry>>((ref) {
  final storage = ref.watch(storageProvider);
  return BeverageNotifier(storage);
});

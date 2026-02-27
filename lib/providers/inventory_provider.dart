import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ingredient.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class InventoryNotifier extends StateNotifier<List<InventoryItem>> {
  final StorageService _storage;

  InventoryNotifier(this._storage) : super(List.of(_storage.getInventory()));

  void addItem(String ingredientId) {
    if (state.any((item) => item.ingredientId == ingredientId)) return;
    final item = InventoryItem(ingredientId: ingredientId);
    state = [...state, item];
    _storage.addInventoryItem(item);
  }

  void removeItem(String ingredientId) {
    state = state
        .where((item) => item.ingredientId != ingredientId)
        .toList();
    _storage.removeInventoryItem(ingredientId);
  }

  void toggleItem(String ingredientId) {
    if (state.any((item) => item.ingredientId == ingredientId)) {
      removeItem(ingredientId);
    } else {
      addItem(ingredientId);
    }
  }

  bool hasItem(String ingredientId) =>
      state.any((item) => item.ingredientId == ingredientId);

  Set<String> get ingredientIds =>
      state.map((item) => item.ingredientId).toSet();

  void clear() {
    state = [];
    _storage.clearInventory();
  }
}

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<InventoryItem>>((ref) {
  final storage = ref.watch(storageProvider);
  return InventoryNotifier(storage);
});

/// Convenience: just the set of ingredient IDs in the kitchen.
final inventoryIdsProvider = Provider<Set<String>>((ref) {
  final items = ref.watch(inventoryProvider);
  return items.map((i) => i.ingredientId).toSet();
});

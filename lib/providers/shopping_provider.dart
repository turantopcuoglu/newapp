import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/shopping_item.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

const _uuid = Uuid();

class ShoppingNotifier extends StateNotifier<List<ShoppingItem>> {
  final StorageService _storage;

  ShoppingNotifier(this._storage) : super(_storage.getShoppingList());

  void addItem(String name, {String? forRecipeId}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    // Prevent duplicates
    if (state.any(
        (i) => i.name.toLowerCase() == trimmed.toLowerCase())) {
      return;
    }
    final item = ShoppingItem(
      id: _uuid.v4(),
      name: trimmed,
      forRecipeId: forRecipeId,
    );
    state = [...state, item];
    _storage.addShoppingItem(item);
  }

  void addMissingIngredients(List<String> ingredientIds,
      {String? forRecipeId}) {
    for (final id in ingredientIds) {
      addItem(id, forRecipeId: forRecipeId);
    }
  }

  void togglePurchased(String id) {
    state = state.map((item) {
      if (item.id == id) {
        final updated = item.copyWith(isPurchased: !item.isPurchased);
        _storage.updateShoppingItem(updated);
        return updated;
      }
      return item;
    }).toList();
  }

  void removeItem(String id) {
    state = state.where((i) => i.id != id).toList();
    _storage.removeShoppingItem(id);
  }

  void clearPurchased() {
    final toRemove = state.where((i) => i.isPurchased).toList();
    for (final item in toRemove) {
      _storage.removeShoppingItem(item.id);
    }
    state = state.where((i) => !i.isPurchased).toList();
  }

  void clearAll() {
    state = [];
    _storage.clearShoppingList();
  }
}

final shoppingProvider =
    StateNotifierProvider<ShoppingNotifier, List<ShoppingItem>>((ref) {
  final storage = ref.watch(storageProvider);
  return ShoppingNotifier(storage);
});

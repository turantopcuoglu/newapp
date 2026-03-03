import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class FavoritesNotifier extends StateNotifier<List<String>> {
  final StorageService _storage;

  FavoritesNotifier(this._storage)
      : super(List.of(_storage.getFavoriteRecipeIds()));

  void toggleFavorite(String recipeId) {
    if (state.contains(recipeId)) {
      state = state.where((id) => id != recipeId).toList();
    } else {
      state = [...state, recipeId];
    }
    _storage.saveFavoriteRecipeIds(state);
  }

  bool isFavorite(String recipeId) => state.contains(recipeId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final storage = ref.watch(storageProvider);
  return FavoritesNotifier(storage);
});

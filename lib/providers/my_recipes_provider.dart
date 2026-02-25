import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

class MyRecipesNotifier extends StateNotifier<List<Recipe>> {
  final StorageService _storage;

  MyRecipesNotifier(this._storage) : super(_storage.getMyRecipes());

  void addRecipe(Recipe recipe) {
    state = [...state, recipe];
    _storage.addMyRecipe(recipe);
  }

  void removeRecipe(String id) {
    state = state.where((r) => r.id != id).toList();
    _storage.removeMyRecipe(id);
  }
}

final myRecipesProvider =
    StateNotifierProvider<MyRecipesNotifier, List<Recipe>>((ref) {
  final storage = ref.watch(storageProvider);
  return MyRecipesNotifier(storage);
});

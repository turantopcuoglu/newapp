import 'package:flutter/foundation.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../services/claude_service.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storage;

  List<Ingredient> _pantry = [];
  List<ShoppingItem> _shoppingList = [];
  List<Recipe> _suggestedRecipes = [];
  Recipe? _searchedRecipe;
  bool _isLoading = false;
  String? _error;
  String? _apiKey;

  AppProvider(this._storage) {
    _loadData();
  }

  // --- Getters ---
  List<Ingredient> get pantry => List.unmodifiable(_pantry);
  List<ShoppingItem> get shoppingList => List.unmodifiable(_shoppingList);
  List<Recipe> get suggestedRecipes => List.unmodifiable(_suggestedRecipes);
  Recipe? get searchedRecipe => _searchedRecipe;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get apiKey => _apiKey;
  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  List<String> get pantryNames =>
      _pantry.map((i) => i.localizedName('tr')).toList();

  // --- Init ---
  void _loadData() {
    _pantry = List.of(_storage.getPantryIngredients());
    _shoppingList = List.of(_storage.getShoppingList());
    _apiKey = _storage.getApiKey();
    notifyListeners();
  }

  /// Reload shopping list from storage (call after external changes).
  void reloadShoppingList() {
    _shoppingList = List.of(_storage.getShoppingList());
    notifyListeners();
  }

  /// Reload pantry from storage (call after external changes).
  void reloadPantry() {
    _pantry = List.of(_storage.getPantryIngredients());
    notifyListeners();
  }

  // --- API Key ---
  Future<void> setApiKey(String key) async {
    _apiKey = key;
    await _storage.saveApiKey(key);
    notifyListeners();
  }

  Future<void> removeApiKey() async {
    _apiKey = null;
    await _storage.removeApiKey();
    notifyListeners();
  }

  // --- Pantry ---
  Future<void> addIngredient(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final ingredient = Ingredient(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: {'en': trimmed, 'tr': trimmed},
    );

    if (_pantry.any((i) =>
        i.localizedName('tr').toLowerCase() == trimmed.toLowerCase())) {
      return;
    }

    _pantry.add(ingredient);
    await _storage.savePantryIngredients(_pantry);
    notifyListeners();
  }

  Future<void> addMultipleIngredients(List<String> names) async {
    for (final name in names) {
      final trimmed = name.trim();
      if (trimmed.isEmpty) continue;
      if (_pantry.any((i) =>
          i.localizedName('tr').toLowerCase() == trimmed.toLowerCase())) {
        continue;
      }
      _pantry.add(Ingredient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: {'en': trimmed, 'tr': trimmed},
      ));
    }
    await _storage.savePantryIngredients(_pantry);
    notifyListeners();
  }

  Future<void> removeIngredient(String id) async {
    _pantry.removeWhere((i) => i.id == id);
    await _storage.savePantryIngredients(_pantry);
    notifyListeners();
  }

  Future<void> clearPantry() async {
    _pantry.clear();
    await _storage.savePantryIngredients(_pantry);
    notifyListeners();
  }

  // --- AI Recipe Suggestions ---
  Future<void> suggestRecipesFromPantry() async {
    if (!hasApiKey) {
      _error = 'Lutfen Ayarlar\'dan API anahtarinizi girin.';
      notifyListeners();
      return;
    }

    if (_pantry.isEmpty) {
      _error = 'Dolabinizda malzeme yok. Once malzeme ekleyin.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _suggestedRecipes = [];
    notifyListeners();

    try {
      final service = ClaudeService(apiKey: _apiKey!);
      _suggestedRecipes = await service.suggestRecipes(pantryNames);
    } catch (e) {
      _error = 'Tarif onerilirken hata olustu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- Recipe Search ---
  Future<void> searchRecipe(String query) async {
    if (!hasApiKey) {
      _error = 'Lutfen Ayarlar\'dan API anahtarinizi girin.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _searchedRecipe = null;
    notifyListeners();

    try {
      final service = ClaudeService(apiKey: _apiKey!);
      _searchedRecipe = await service.searchRecipe(
        query: query,
        pantryIngredients: pantryNames,
      );
    } catch (e) {
      _error = 'Tarif aranirken hata olustu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchedRecipe = null;
    _error = null;
    notifyListeners();
  }

  void clearSuggestions() {
    _suggestedRecipes = [];
    _error = null;
    notifyListeners();
  }

  // --- Shopping List ---
  Future<void> addToShoppingList(String itemName,
      {String? forRecipeId}) async {
    final trimmed = itemName.trim();
    if (trimmed.isEmpty) return;

    if (_shoppingList
        .any((i) => i.name.toLowerCase() == trimmed.toLowerCase())) {
      return;
    }

    _shoppingList.add(ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmed,
      forRecipeId: forRecipeId,
    ));
    await _storage.saveShoppingList(_shoppingList);
    notifyListeners();
  }

  Future<void> toggleShoppingItem(int index) async {
    if (index < 0 || index >= _shoppingList.length) return;
    _shoppingList[index] = _shoppingList[index].copyWith(
      isPurchased: !_shoppingList[index].isPurchased,
    );
    await _storage.saveShoppingList(_shoppingList);
    notifyListeners();
  }

  Future<void> removeShoppingItem(int index) async {
    if (index < 0 || index >= _shoppingList.length) return;
    _shoppingList.removeAt(index);
    await _storage.saveShoppingList(_shoppingList);
    notifyListeners();
  }

  Future<void> clearShoppingList() async {
    _shoppingList.clear();
    await _storage.saveShoppingList(_shoppingList);
    notifyListeners();
  }

  Future<void> clearCheckedItems() async {
    _shoppingList.removeWhere((item) => item.isPurchased);
    await _storage.saveShoppingList(_shoppingList);
    notifyListeners();
  }

  Future<void> addMissingToShoppingList(Recipe recipe) async {
    final missing = recipe.ingredientIds.where((id) {
      return !_pantry.any(
          (p) => p.localizedName('tr').toLowerCase() == id.toLowerCase());
    }).toList();

    for (final name in missing) {
      await addToShoppingList(name, forRecipeId: recipe.id);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

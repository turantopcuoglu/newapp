import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';

class StorageService {
  static const String _pantryKey = 'pantry_ingredients';
  static const String _shoppingKey = 'shopping_list';
  static const String _apiKeyKey = 'claude_api_key';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // --- API Key ---
  String? getApiKey() => _prefs.getString(_apiKeyKey);

  Future<void> saveApiKey(String key) => _prefs.setString(_apiKeyKey, key);

  Future<void> removeApiKey() => _prefs.remove(_apiKeyKey);

  // --- Pantry ---
  List<Ingredient> getPantryIngredients() {
    final jsonStr = _prefs.getString(_pantryKey);
    if (jsonStr == null) return [];

    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> savePantryIngredients(List<Ingredient> ingredients) async {
    final jsonStr = jsonEncode(ingredients.map((i) => i.toJson()).toList());
    await _prefs.setString(_pantryKey, jsonStr);
  }

  // --- Shopping List ---
  List<ShoppingItem> getShoppingList() {
    final jsonStr = _prefs.getString(_shoppingKey);
    if (jsonStr == null) return [];

    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((item) => ShoppingItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveShoppingList(List<ShoppingItem> items) async {
    final jsonStr = jsonEncode(items.map((i) => i.toJson()).toList());
    await _prefs.setString(_shoppingKey, jsonStr);
  }
}

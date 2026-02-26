import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ingredient.dart';
import '../models/shopping_item.dart';

class StorageService {
  final SharedPreferences _prefs;

  static const String _pantryKey = 'pantry_ingredients';
  static const String _shoppingListKey = 'shopping_list';
  static const String _apiKeyKey = 'api_key';

  StorageService(this._prefs);

  // --- Pantry ---
  List<Ingredient> getPantryIngredients() {
    final data = _prefs.getString(_pantryKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> savePantryIngredients(List<Ingredient> ingredients) async {
    final data = jsonEncode(ingredients.map((e) => e.toJson()).toList());
    await _prefs.setString(_pantryKey, data);
  }

  // --- Shopping List ---
  List<ShoppingItem> getShoppingList() {
    final data = _prefs.getString(_shoppingListKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveShoppingList(List<ShoppingItem> items) async {
    final data = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_shoppingListKey, data);
  }

  // --- API Key ---
  String? getApiKey() => _prefs.getString(_apiKeyKey);

  Future<void> saveApiKey(String key) async {
    await _prefs.setString(_apiKeyKey, key);
  }

  Future<void> removeApiKey() async {
    await _prefs.remove(_apiKeyKey);
  }
}

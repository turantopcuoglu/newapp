import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/enums.dart';
import '../models/beverage_entry.dart';
import '../models/ingredient.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../models/user_profile.dart';

class StorageService {
  final SharedPreferences _prefs;

  static const String _pantryKey = 'pantry_ingredients';
  static const String _shoppingListKey = 'shopping_list';
  static const String _apiKeyKey = 'api_key';
  static const String _mealPlansKey = 'meal_plans';
  static const String _profileKey = 'user_profile';
  static const String _myRecipesKey = 'my_recipes';
  static const String _inventoryKey = 'inventory';
  static const String _localeKey = 'locale';
  static const String _checkInKey = 'today_check_in';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _beveragesKey = 'beverages';
  static const String _dailyModeKey = 'daily_mode';
  static const String _dailyModeDateKey = 'daily_mode_date';

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

  Future<void> addShoppingItem(ShoppingItem item) async {
    final items = getShoppingList();
    items.add(item);
    await saveShoppingList(items);
  }

  Future<void> updateShoppingItem(ShoppingItem updated) async {
    final items = getShoppingList();
    final index = items.indexWhere((i) => i.id == updated.id);
    if (index != -1) {
      items[index] = updated;
      await saveShoppingList(items);
    }
  }

  Future<void> removeShoppingItem(String id) async {
    final items = getShoppingList();
    items.removeWhere((i) => i.id == id);
    await saveShoppingList(items);
  }

  Future<void> clearShoppingList() async {
    await _prefs.remove(_shoppingListKey);
  }

  // --- API Key ---
  String? getApiKey() => _prefs.getString(_apiKeyKey);

  Future<void> saveApiKey(String key) async {
    await _prefs.setString(_apiKeyKey, key);
  }

  Future<void> removeApiKey() async {
    await _prefs.remove(_apiKeyKey);
  }

  // --- Meal Plans ---
  List<MealPlanEntry> getMealPlans() {
    final data = _prefs.getString(_mealPlansKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => MealPlanEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveMealPlans(List<MealPlanEntry> plans) async {
    final data = jsonEncode(plans.map((e) => e.toJson()).toList());
    await _prefs.setString(_mealPlansKey, data);
  }

  Future<void> addMealPlan(MealPlanEntry entry) async {
    final plans = getMealPlans();
    plans.add(entry);
    await _saveMealPlans(plans);
  }

  Future<void> removeMealPlan(String id) async {
    final plans = getMealPlans();
    plans.removeWhere((e) => e.id == id);
    await _saveMealPlans(plans);
  }

  // --- User Profile ---
  UserProfile? getProfile() {
    final data = _prefs.getString(_profileKey);
    if (data == null) return null;
    return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_profileKey, profile.encode());
  }

  // --- My Recipes ---
  List<Recipe> getMyRecipes() {
    final data = _prefs.getString(_myRecipesKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addMyRecipe(Recipe recipe) async {
    final recipes = getMyRecipes();
    recipes.add(recipe);
    final data = jsonEncode(recipes.map((e) => e.toJson()).toList());
    await _prefs.setString(_myRecipesKey, data);
  }

  Future<void> removeMyRecipe(String id) async {
    final recipes = getMyRecipes();
    recipes.removeWhere((r) => r.id == id);
    final data = jsonEncode(recipes.map((e) => e.toJson()).toList());
    await _prefs.setString(_myRecipesKey, data);
  }

  // --- Inventory ---
  List<InventoryItem> getInventory() {
    final data = _prefs.getString(_inventoryKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveInventory(List<InventoryItem> items) async {
    final data = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_inventoryKey, data);
  }

  Future<void> addInventoryItem(InventoryItem item) async {
    final items = getInventory();
    if (items.any((i) => i.ingredientId == item.ingredientId)) return;
    items.add(item);
    await _saveInventory(items);
  }

  Future<void> removeInventoryItem(String ingredientId) async {
    final items = getInventory();
    items.removeWhere((i) => i.ingredientId == ingredientId);
    await _saveInventory(items);
  }

  Future<void> clearInventory() async {
    await _prefs.remove(_inventoryKey);
  }

  // --- Check-In ---
  CheckInType? getTodayCheckIn() {
    final value = _prefs.getString(_checkInKey);
    if (value == null) return null;
    return CheckInType.values.where((e) => e.name == value).firstOrNull;
  }

  Future<void> saveTodayCheckIn(CheckInType type) async {
    await _prefs.setString(_checkInKey, type.name);
  }

  // --- Onboarding ---
  bool isOnboardingCompleted() => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  // --- Beverages ---
  List<BeverageEntry> getBeverages() {
    final data = _prefs.getString(_beveragesKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => BeverageEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveBeverages(List<BeverageEntry> items) async {
    final data = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_beveragesKey, data);
  }

  Future<void> addBeverage(BeverageEntry entry) async {
    final items = getBeverages();
    items.add(entry);
    await _saveBeverages(items);
  }

  Future<void> removeBeverage(String id) async {
    final items = getBeverages();
    items.removeWhere((e) => e.id == id);
    await _saveBeverages(items);
  }

  // --- Daily Mode ---
  /// Returns the "mode day" string for a given DateTime.
  /// The mode day resets at 6 AM, so 00:00-05:59 belongs to the previous day.
  static String _modeDayKey(DateTime dt) {
    final effective = dt.hour < 6 ? dt.subtract(const Duration(days: 1)) : dt;
    return '${effective.year}-${effective.month.toString().padLeft(2, '0')}-${effective.day.toString().padLeft(2, '0')}';
  }

  /// Get today's daily mode, respecting the 6 AM reset boundary.
  CheckInType? getDailyMode() {
    final storedDate = _prefs.getString(_dailyModeDateKey);
    final today = _modeDayKey(DateTime.now());
    if (storedDate != today) return null;
    final value = _prefs.getString(_dailyModeKey);
    if (value == null) return null;
    return CheckInType.values.where((e) => e.name == value).firstOrNull;
  }

  /// Save the daily mode with today's mode-day date.
  Future<void> saveDailyMode(CheckInType type) async {
    final today = _modeDayKey(DateTime.now());
    await _prefs.setString(_dailyModeKey, type.name);
    await _prefs.setString(_dailyModeDateKey, today);
  }

  /// Check if the daily mode has been selected for the current mode-day.
  bool isDailyModeSet() => getDailyMode() != null;

  // --- Locale ---
  String getLocale() => _prefs.getString(_localeKey) ?? 'tr';

  Future<void> saveLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
  }
}

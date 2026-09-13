import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/day_boundary.dart';
import '../core/enums.dart';
import '../models/beverage_entry.dart';
import '../models/cooked_entry.dart';
import '../models/ingredient.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../models/user_profile.dart';
import 'private_storage.dart';

class StorageService {
  final SharedPreferences _prefs;
  final PrivateStorage? _privateData;

  static const String _pantryKey = 'pantry_ingredients';
  static const String _shoppingListKey = 'shopping_list';
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
  static const String _disclaimerAcceptedKey = 'disclaimer_accepted';
  static const String _favoriteRecipesKey = 'favorite_recipes';
  static const String _cookedEntriesKey = 'cooked_entries';
  static const String _remindersEnabledKey = 'reminders_enabled';

  StorageService(this._prefs, {PrivateStorage? privateData})
      : _privateData = privateData;

  String? _readString(String key) =>
      _privateData != null && PrivateStorage.protectedKeys.contains(key)
          ? _privateData.read(key)
          : _prefs.getString(key);
  Future<void> _writeString(String key, String value) async {
    if (_privateData != null && PrivateStorage.protectedKeys.contains(key)) {
      await _privateData.write(key, value);
    } else {
      if (!await _prefs.setString(key, value)) {
        throw StateError('Storage write failed');
      }
    }
  }

  Future<void> _remove(String key) async {
    if (_privateData != null && PrivateStorage.protectedKeys.contains(key)) {
      await _privateData.write(key, null);
    } else {
      await _prefs.remove(key);
    }
  }

  // --- Pantry ---
  List<Ingredient> getPantryIngredients() {
    final data = _readString(_pantryKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> savePantryIngredients(List<Ingredient> ingredients) async {
    final data = jsonEncode(ingredients.map((e) => e.toJson()).toList());
    await _writeString(_pantryKey, data);
  }

  // --- Shopping List ---
  List<ShoppingItem> getShoppingList() {
    final data = _readString(_shoppingListKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveShoppingList(List<ShoppingItem> items) async {
    final data = jsonEncode(items.map((e) => e.toJson()).toList());
    await _writeString(_shoppingListKey, data);
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
    await _remove(_shoppingListKey);
  }

  // --- Meal Plans ---
  List<MealPlanEntry> getMealPlans() {
    final data = _readString(_mealPlansKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => MealPlanEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveMealPlans(List<MealPlanEntry> plans) async {
    final data = jsonEncode(plans.map((e) => e.toJson()).toList());
    await _writeString(_mealPlansKey, data);
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
    final data = _readString(_profileKey);
    if (data == null) return null;
    return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _writeString(_profileKey, profile.encode());
  }

  // --- My Recipes ---
  List<Recipe> getMyRecipes() {
    final data = _readString(_myRecipesKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> addMyRecipe(Recipe recipe) async {
    final recipes = getMyRecipes();
    recipes.add(recipe);
    final data = jsonEncode(recipes.map((e) => e.toJson()).toList());
    await _writeString(_myRecipesKey, data);
  }

  Future<void> removeMyRecipe(String id) async {
    final recipes = getMyRecipes();
    recipes.removeWhere((r) => r.id == id);
    final data = jsonEncode(recipes.map((e) => e.toJson()).toList());
    await _writeString(_myRecipesKey, data);
  }

  // --- Inventory ---
  List<InventoryItem> getInventory() {
    final data = _readString(_inventoryKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveInventory(List<InventoryItem> items) async {
    final data = jsonEncode(items.map((e) => e.toJson()).toList());
    await _writeString(_inventoryKey, data);
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
    await _remove(_inventoryKey);
  }

  // --- Check-In ---
  CheckInType? getTodayCheckIn() {
    final value = _readString(_checkInKey);
    if (value == null) return null;
    return CheckInType.values.where((e) => e.name == value).firstOrNull;
  }

  Future<void> saveTodayCheckIn(CheckInType type) async {
    await _writeString(_checkInKey, type.name);
  }

  // --- Onboarding ---
  bool isOnboardingCompleted() => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  // --- Beverages ---
  List<BeverageEntry> getBeverages() {
    final data = _readString(_beveragesKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => BeverageEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveBeverages(List<BeverageEntry> items) async {
    final data = jsonEncode(items.map((e) => e.toJson()).toList());
    await _writeString(_beveragesKey, data);
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
  /// The "mode day" for a given moment (06:00 reset, see [DayBoundary]).
  static String _modeDayKey(DateTime dt) => DayBoundary.keyFor(dt);

  /// Get today's daily mode, respecting the 6 AM reset boundary.
  CheckInType? getDailyMode() {
    final storedDate = _readString(_dailyModeDateKey);
    final today = _modeDayKey(DateTime.now());
    if (storedDate != today) return null;
    final value = _readString(_dailyModeKey);
    if (value == null) return null;
    return CheckInType.values.where((e) => e.name == value).firstOrNull;
  }

  /// Save the daily mode with today's mode-day date.
  Future<void> saveDailyMode(CheckInType type) async {
    final today = _modeDayKey(DateTime.now());
    await _writeString(_dailyModeKey, type.name);
    await _writeString(_dailyModeDateKey, today);
  }

  /// Check if the daily mode has been selected for the current mode-day.
  bool isDailyModeSet() => getDailyMode() != null;

  // --- Disclaimer ---
  bool isDisclaimerAccepted() =>
      _prefs.getBool(_disclaimerAcceptedKey) ?? false;

  Future<void> setDisclaimerAccepted() async {
    await _prefs.setBool(_disclaimerAcceptedKey, true);
  }

  // --- Reminders ---
  bool areRemindersEnabled() => _prefs.getBool(_remindersEnabledKey) ?? false;

  Future<void> setRemindersEnabled(bool enabled) async {
    await _prefs.setBool(_remindersEnabledKey, enabled);
  }

  // --- Cooked Entries (consumed calorie log) ---
  List<CookedEntry> getCookedEntries() {
    final data = _readString(_cookedEntriesKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list
        .map((e) => CookedEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveCookedEntries(List<CookedEntry> entries) async {
    final data = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _writeString(_cookedEntriesKey, data);
  }

  Future<void> addCookedEntry(CookedEntry entry) async {
    final entries = getCookedEntries();
    entries.add(entry);
    await _saveCookedEntries(entries);
  }

  Future<void> removeCookedEntry(String id) async {
    final entries = getCookedEntries();
    entries.removeWhere((e) => e.id == id);
    await _saveCookedEntries(entries);
  }

  // --- Favorite Recipes ---
  List<String> getFavoriteRecipeIds() {
    final data = _prefs.getStringList(_favoriteRecipesKey);
    return data ?? [];
  }

  Future<void> saveFavoriteRecipeIds(List<String> ids) async {
    await _prefs.setStringList(_favoriteRecipesKey, ids);
  }

  // --- Locale ---
  String getLocale() => _readString(_localeKey) ?? 'tr';

  Future<void> saveLocale(String languageCode) async {
    await _writeString(_localeKey, languageCode);
  }
}

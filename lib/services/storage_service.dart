import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import '../models/user_profile.dart';
import '../models/ingredient.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import '../models/shopping_item.dart';
import '../core/enums.dart';

class StorageService {
  late Box _profileBox;
  late Box _inventoryBox;
  late Box _shoppingBox;
  late Box _mealPlanBox;
  late Box _myRecipesBox;
  late Box _checkInBox;
  late Box _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _profileBox = await Hive.openBox(AppConstants.profileBox);
    _inventoryBox = await Hive.openBox(AppConstants.inventoryBox);
    _shoppingBox = await Hive.openBox(AppConstants.shoppingBox);
    _mealPlanBox = await Hive.openBox(AppConstants.mealPlanBox);
    _myRecipesBox = await Hive.openBox(AppConstants.myRecipesBox);
    _checkInBox = await Hive.openBox(AppConstants.checkInBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  // --- Profile ---
  UserProfile? getProfile() {
    final data = _profileBox.get(AppConstants.profileKey) as String?;
    if (data == null) return null;
    return UserProfile.decode(data);
  }

  Future<void> saveProfile(UserProfile profile) =>
      _profileBox.put(AppConstants.profileKey, profile.encode());

  // --- Locale ---
  String getLocale() =>
      _settingsBox.get(AppConstants.localeKey, defaultValue: 'en') as String;

  Future<void> saveLocale(String locale) =>
      _settingsBox.put(AppConstants.localeKey, locale);

  // --- Kitchen Inventory ---
  List<InventoryItem> getInventory() {
    final items = <InventoryItem>[];
    for (final key in _inventoryBox.keys) {
      final data = _inventoryBox.get(key) as String?;
      if (data != null) {
        items.add(InventoryItem.decode(data));
      }
    }
    return items;
  }

  Future<void> addInventoryItem(InventoryItem item) =>
      _inventoryBox.put(item.ingredientId, item.encode());

  Future<void> removeInventoryItem(String ingredientId) =>
      _inventoryBox.delete(ingredientId);

  Future<void> clearInventory() => _inventoryBox.clear();

  bool hasIngredient(String ingredientId) =>
      _inventoryBox.containsKey(ingredientId);

  // --- Shopping List ---
  List<ShoppingItem> getShoppingList() {
    final items = <ShoppingItem>[];
    for (final key in _shoppingBox.keys) {
      final data = _shoppingBox.get(key) as String?;
      if (data != null) {
        items.add(ShoppingItem.decode(data));
      }
    }
    return items;
  }

  Future<void> addShoppingItem(ShoppingItem item) =>
      _shoppingBox.put(item.id, item.encode());

  Future<void> updateShoppingItem(ShoppingItem item) =>
      _shoppingBox.put(item.id, item.encode());

  Future<void> removeShoppingItem(String id) => _shoppingBox.delete(id);

  Future<void> clearShoppingList() => _shoppingBox.clear();

  // --- Meal Plans ---
  List<MealPlanEntry> getMealPlans() {
    final entries = <MealPlanEntry>[];
    for (final key in _mealPlanBox.keys) {
      final data = _mealPlanBox.get(key) as String?;
      if (data != null) {
        entries.add(MealPlanEntry.decode(data));
      }
    }
    return entries;
  }

  Future<void> addMealPlan(MealPlanEntry entry) =>
      _mealPlanBox.put(entry.id, entry.encode());

  Future<void> removeMealPlan(String id) => _mealPlanBox.delete(id);

  Future<void> clearMealPlans() => _mealPlanBox.clear();

  // --- My Recipes ---
  List<Recipe> getMyRecipes() {
    final recipes = <Recipe>[];
    for (final key in _myRecipesBox.keys) {
      final data = _myRecipesBox.get(key) as String?;
      if (data != null) {
        recipes.add(Recipe.decode(data));
      }
    }
    return recipes;
  }

  Future<void> addMyRecipe(Recipe recipe) =>
      _myRecipesBox.put(recipe.id, recipe.encode());

  Future<void> removeMyRecipe(String id) => _myRecipesBox.delete(id);

  // --- Check-in ---
  CheckInType? getTodayCheckIn() {
    final today = _todayKey();
    final data = _checkInBox.get(today) as String?;
    if (data == null) return null;
    return CheckInType.values.firstWhere((e) => e.name == data);
  }

  Future<void> saveTodayCheckIn(CheckInType type) =>
      _checkInBox.put(_todayKey(), type.name);

  Map<String, CheckInType> getCheckInHistory() {
    final history = <String, CheckInType>{};
    for (final key in _checkInBox.keys) {
      final data = _checkInBox.get(key) as String?;
      if (data != null) {
        try {
          history[key as String] =
              CheckInType.values.firstWhere((e) => e.name == data);
        } catch (_) {}
      }
    }
    return history;
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

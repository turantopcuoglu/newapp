import '../core/enums.dart';
import 'ingredient_nutrition_data.dart';

/// Maps ingredient IDs to their natural/default QuantityUnit.
/// e.g. eggs → piece, milk → ml, spices → teaspoon, etc.
const Map<String, QuantityUnit> ingredientDefaultUnit = {
  // ── Protein ──
  'chicken_breast': QuantityUnit.g,
  'ground_beef': QuantityUnit.g,
  'salmon': QuantityUnit.g,
  'eggs': QuantityUnit.piece,
  'shrimp': QuantityUnit.g,
  'turkey_breast': QuantityUnit.g,
  'lamb': QuantityUnit.g,
  'tuna': QuantityUnit.g,
  'chicken_thigh': QuantityUnit.g,
  'beef_steak': QuantityUnit.g,
  'cod': QuantityUnit.g,
  'tofu': QuantityUnit.g,
  'pork_chop': QuantityUnit.g,
  'duck_breast': QuantityUnit.g,
  'anchovy': QuantityUnit.g,
  'veal': QuantityUnit.g,
  'ground_turkey': QuantityUnit.g,
  'sea_bass': QuantityUnit.g,
  'sardine': QuantityUnit.g,
  'squid': QuantityUnit.g,
  'mussel': QuantityUnit.g,
  'octopus': QuantityUnit.g,
  'liver': QuantityUnit.g,
  'chicken_wing': QuantityUnit.piece,
  'sea_bream': QuantityUnit.g,

  // ── Dairy ──
  'milk': QuantityUnit.ml,
  'yogurt': QuantityUnit.g,
  'cheddar_cheese': QuantityUnit.g,
  'feta_cheese': QuantityUnit.g,
  'butter': QuantityUnit.tablespoon,
  'cream': QuantityUnit.ml,
  'mozzarella': QuantityUnit.g,
  'parmesan': QuantityUnit.g,
  'cottage_cheese': QuantityUnit.g,
  'kefir': QuantityUnit.ml,
  'greek_yogurt': QuantityUnit.g,
  'cream_cheese': QuantityUnit.tablespoon,
  'ricotta': QuantityUnit.g,
  'goat_cheese': QuantityUnit.g,
  'labne': QuantityUnit.tablespoon,
  'sour_cream': QuantityUnit.tablespoon,
  'condensed_milk': QuantityUnit.ml,
  'whipped_cream': QuantityUnit.ml,

  // ── Grain ──
  'rice': QuantityUnit.cup,
  'white_rice': QuantityUnit.cup,
  'pasta': QuantityUnit.g,
  'bread': QuantityUnit.slice,
  'flour': QuantityUnit.cup,
  'oats': QuantityUnit.cup,
  'bulgur': QuantityUnit.cup,
  'couscous': QuantityUnit.cup,
  'cornmeal': QuantityUnit.cup,
  'brown_rice': QuantityUnit.cup,
  'quinoa': QuantityUnit.cup,
  'whole_wheat_flour': QuantityUnit.cup,
  'semolina': QuantityUnit.cup,
  'tortilla_wrap': QuantityUnit.piece,
  'noodle': QuantityUnit.g,
  'pita_bread': QuantityUnit.piece,
  'basmati_rice': QuantityUnit.cup,
  'buckwheat': QuantityUnit.cup,
  'barley': QuantityUnit.cup,
  'phyllo_dough': QuantityUnit.piece,
  'puff_pastry': QuantityUnit.piece,

  // ── Vegetable ──
  'tomato': QuantityUnit.piece,
  'onion': QuantityUnit.piece,
  'garlic': QuantityUnit.clove,
  'potato': QuantityUnit.piece,
  'carrot': QuantityUnit.piece,
  'bell_pepper': QuantityUnit.piece,
  'cucumber': QuantityUnit.piece,
  'spinach': QuantityUnit.g,
  'broccoli': QuantityUnit.g,
  'zucchini': QuantityUnit.piece,
  'eggplant': QuantityUnit.piece,
  'lettuce': QuantityUnit.piece,
  'mushroom': QuantityUnit.g,
  'green_beans': QuantityUnit.g,
  'cauliflower': QuantityUnit.g,
  'celery': QuantityUnit.piece,
  'sweet_potato': QuantityUnit.piece,
  'leek': QuantityUnit.piece,
  'cabbage': QuantityUnit.g,
  'artichoke': QuantityUnit.piece,
  'corn': QuantityUnit.piece,
  'peas': QuantityUnit.g,
  'asparagus': QuantityUnit.bunch,
  'radish': QuantityUnit.piece,
  'beet': QuantityUnit.piece,
  'okra': QuantityUnit.g,
  'spring_onion': QuantityUnit.bunch,
  'red_cabbage': QuantityUnit.g,
  'kale': QuantityUnit.g,
  'arugula': QuantityUnit.g,
  'swiss_chard': QuantityUnit.bunch,
  'turnip': QuantityUnit.piece,
  'ginger': QuantityUnit.g,
  'hot_pepper': QuantityUnit.piece,
  'brussels_sprouts': QuantityUnit.g,
  'red_onion': QuantityUnit.piece,
  'fennel_bulb': QuantityUnit.piece,
  'celeriac': QuantityUnit.piece,
  'watercress': QuantityUnit.bunch,
  'purslane': QuantityUnit.bunch,

  // ── Fruit ──
  'apple': QuantityUnit.piece,
  'banana': QuantityUnit.piece,
  'lemon': QuantityUnit.piece,
  'orange': QuantityUnit.piece,
  'strawberry': QuantityUnit.g,
  'avocado': QuantityUnit.piece,
  'pomegranate': QuantityUnit.piece,
  'grape': QuantityUnit.g,
  'watermelon': QuantityUnit.slice,
  'peach': QuantityUnit.piece,
  'cherry': QuantityUnit.g,
  'fig': QuantityUnit.piece,
  'mango': QuantityUnit.piece,
  'pineapple': QuantityUnit.slice,
  'kiwi': QuantityUnit.piece,
  'pear': QuantityUnit.piece,
  'blueberry': QuantityUnit.g,
  'raspberry': QuantityUnit.g,
  'dates': QuantityUnit.piece,
  'apricot': QuantityUnit.piece,
  'plum': QuantityUnit.piece,
  'melon': QuantityUnit.slice,
  'tangerine': QuantityUnit.piece,
  'grapefruit': QuantityUnit.piece,
  'coconut': QuantityUnit.piece,
  'blackberry': QuantityUnit.g,
  'lime': QuantityUnit.piece,
  'quince': QuantityUnit.piece,

  // ── Spice ──
  'black_pepper': QuantityUnit.pinch,
  'cumin': QuantityUnit.teaspoon,
  'paprika': QuantityUnit.teaspoon,
  'red_pepper_flakes': QuantityUnit.teaspoon,
  'cinnamon': QuantityUnit.teaspoon,
  'oregano': QuantityUnit.teaspoon,
  'turmeric': QuantityUnit.teaspoon,
  'mint': QuantityUnit.teaspoon,
  'parsley': QuantityUnit.bunch,
  'bay_leaf': QuantityUnit.piece,
  'dill': QuantityUnit.bunch,
  'thyme': QuantityUnit.teaspoon,
  'rosemary': QuantityUnit.teaspoon,
  'basil': QuantityUnit.g,
  'coriander': QuantityUnit.teaspoon,
  'nutmeg': QuantityUnit.pinch,
  'clove': QuantityUnit.piece,
  'cardamom': QuantityUnit.piece,
  'sumac': QuantityUnit.teaspoon,
  'curry_powder': QuantityUnit.teaspoon,
  'ginger_powder': QuantityUnit.teaspoon,
  'garlic_powder': QuantityUnit.teaspoon,
  'onion_powder': QuantityUnit.teaspoon,
  'white_pepper': QuantityUnit.pinch,
  'vanilla': QuantityUnit.teaspoon,

  // ── Oil ──
  'olive_oil': QuantityUnit.tablespoon,
  'sunflower_oil': QuantityUnit.tablespoon,
  'coconut_oil': QuantityUnit.tablespoon,
  'sesame_oil': QuantityUnit.tablespoon,
  'canola_oil': QuantityUnit.tablespoon,
  'avocado_oil': QuantityUnit.tablespoon,
  'grape_seed_oil': QuantityUnit.tablespoon,
  'ghee': QuantityUnit.tablespoon,

  // ── Nut & Seed ──
  'walnut': QuantityUnit.g,
  'walnuts': QuantityUnit.g,
  'almond': QuantityUnit.g,
  'almonds': QuantityUnit.g,
  'hazelnut': QuantityUnit.g,
  'pistachio': QuantityUnit.g,
  'peanut': QuantityUnit.g,
  'peanuts': QuantityUnit.g,
  'cashew': QuantityUnit.g,
  'cashews': QuantityUnit.g,
  'pine_nut': QuantityUnit.tablespoon,
  'chestnut': QuantityUnit.piece,
  'sesame_seeds': QuantityUnit.tablespoon,
  'sunflower_seeds': QuantityUnit.tablespoon,
  'pumpkin_seeds': QuantityUnit.tablespoon,
  'flax_seeds': QuantityUnit.tablespoon,
  'chia_seeds': QuantityUnit.tablespoon,
  'poppy_seeds': QuantityUnit.tablespoon,

  // ── Legume ──
  'red_lentil': QuantityUnit.cup,
  'red_lentils': QuantityUnit.cup,
  'green_lentil': QuantityUnit.cup,
  'lentils': QuantityUnit.cup,
  'chickpea': QuantityUnit.cup,
  'chickpeas': QuantityUnit.cup,
  'white_bean': QuantityUnit.cup,
  'black_eyed_pea': QuantityUnit.cup,
  'black_bean': QuantityUnit.cup,
  'kidney_bean': QuantityUnit.cup,
  'fava_bean': QuantityUnit.cup,
  'edamame': QuantityUnit.cup,
  'split_pea': QuantityUnit.cup,

  // ── Condiment ──
  'salt': QuantityUnit.pinch,
  'sugar': QuantityUnit.tablespoon,
  'soy_sauce': QuantityUnit.tablespoon,
  'tomato_paste': QuantityUnit.tablespoon,
  'apple_cider_vinegar': QuantityUnit.tablespoon,
  'mustard': QuantityUnit.teaspoon,
  'honey': QuantityUnit.tablespoon,
  'tahini': QuantityUnit.tablespoon,
  'pomegranate_molasses': QuantityUnit.tablespoon,
  'peanut_butter': QuantityUnit.tablespoon,
  'coconut_milk': QuantityUnit.ml,
  'ketchup': QuantityUnit.tablespoon,
  'mayonnaise': QuantityUnit.tablespoon,
  'balsamic_vinegar': QuantityUnit.tablespoon,
  'white_vinegar': QuantityUnit.tablespoon,
  'hot_sauce': QuantityUnit.teaspoon,
  'maple_syrup': QuantityUnit.tablespoon,
  'brown_sugar': QuantityUnit.tablespoon,
  'olives': QuantityUnit.g,
  'pickles': QuantityUnit.piece,
  'dried_tomatoes': QuantityUnit.g,
  'almond_butter': QuantityUnit.tablespoon,

  // ── Snack Food ──
  'potato_chips': QuantityUnit.g,
  'tortilla_chips': QuantityUnit.g,
  'popcorn': QuantityUnit.g,
  'chocolate_bar': QuantityUnit.g,
  'dark_chocolate': QuantityUnit.g,
  'ice_cream': QuantityUnit.g,
  'cookies': QuantityUnit.piece,
  'crackers': QuantityUnit.piece,
  'mixed_nuts': QuantityUnit.g,
  'dried_fruit': QuantityUnit.g,
  'granola_bar': QuantityUnit.piece,
  'rice_cake': QuantityUnit.piece,

  // ── Other ──
  'baking_powder': QuantityUnit.teaspoon,
  'yeast': QuantityUnit.g,
  'baking_soda': QuantityUnit.teaspoon,
  'cornstarch': QuantityUnit.tablespoon,
  'gelatin': QuantityUnit.g,
  'breadcrumbs': QuantityUnit.g,
  'cocoa_powder': QuantityUnit.tablespoon,
  'coconut_flakes': QuantityUnit.tablespoon,
  'powdered_sugar': QuantityUnit.tablespoon,
  'rose_water': QuantityUnit.tablespoon,
};

/// Default amounts per unit type for recipe auto-generation.
/// These represent typical single-serving amounts.
const Map<QuantityUnit, double> _defaultAmountPerUnit = {
  QuantityUnit.piece: 1,
  QuantityUnit.g: 100,
  QuantityUnit.ml: 200,
  QuantityUnit.L: 0.25,
  QuantityUnit.tablespoon: 1,
  QuantityUnit.teaspoon: 1,
  QuantityUnit.cup: 1,
  QuantityUnit.bunch: 1,
  QuantityUnit.slice: 2,
  QuantityUnit.pinch: 1,
  QuantityUnit.clove: 2,
};

/// Specific default amounts for well-known ingredients.
const Map<String, double> _ingredientSpecificAmounts = {
  // Proteins
  'chicken_breast': 150,
  'ground_beef': 150,
  'salmon': 150,
  'eggs': 2,
  'shrimp': 100,
  'turkey_breast': 150,
  'lamb': 150,
  'tuna': 150,
  'chicken_thigh': 150,
  'beef_steak': 200,
  'cod': 150,
  'tofu': 150,
  'liver': 100,
  'chicken_wing': 4,

  // Dairy
  'milk': 200,
  'yogurt': 200,
  'cheddar_cheese': 30,
  'feta_cheese': 50,
  'butter': 1,
  'cream': 50,
  'mozzarella': 50,
  'parmesan': 15,
  'cottage_cheese': 100,
  'kefir': 200,
  'greek_yogurt': 150,
  'cream_cheese': 2,
  'labne': 2,
  'sour_cream': 2,

  // Grains
  'pasta': 200,
  'bread': 2,
  'oats': 1,
  'bulgur': 1,
  'noodle': 150,

  // Vegetables
  'tomato': 1,
  'onion': 1,
  'garlic': 2,
  'potato': 2,
  'carrot': 1,
  'bell_pepper': 1,
  'cucumber': 1,
  'spinach': 100,
  'broccoli': 150,
  'zucchini': 1,
  'eggplant': 1,
  'mushroom': 100,
  'green_beans': 150,
  'cauliflower': 150,
  'cabbage': 200,
  'peas': 100,
  'kale': 100,
  'arugula': 50,

  // Fruits
  'banana': 1,
  'apple': 1,
  'lemon': 1,
  'orange': 1,
  'strawberry': 150,
  'avocado': 1,
  'blueberry': 100,
  'raspberry': 100,
  'dates': 3,

  // Spices (default is fine: 1 teaspoon/pinch)
  'parsley': 1,
  'dill': 1,
  'basil': 10,

  // Oils (default 1 tablespoon is fine)
  'olive_oil': 2,

  // Nuts
  'walnut': 30,
  'walnuts': 30,
  'almond': 30,
  'almonds': 30,
  'hazelnut': 30,
  'pistachio': 30,
  'cashew': 30,
  'cashews': 30,
  'peanuts': 30,
  'mixed_nuts': 30,

  // Legumes
  'red_lentil': 1,
  'red_lentils': 1,
  'lentils': 1,
  'green_lentil': 1,
  'chickpea': 1,
  'chickpeas': 1,
  'white_bean': 1,

  // Condiments
  'honey': 1,
  'tomato_paste': 2,
  'soy_sauce': 2,
  'coconut_milk': 200,
  'peanut_butter': 2,
  'tahini': 2,
  'sugar': 1,
};

/// Gets the default QuantityUnit for an ingredient.
QuantityUnit getDefaultUnit(String ingredientId) {
  return ingredientDefaultUnit[ingredientId] ?? QuantityUnit.g;
}

/// Gets the default amount for an ingredient based on its unit.
double getDefaultAmount(String ingredientId) {
  if (_ingredientSpecificAmounts.containsKey(ingredientId)) {
    return _ingredientSpecificAmounts[ingredientId]!;
  }
  final unit = getDefaultUnit(ingredientId);
  return _defaultAmountPerUnit[unit] ?? 100;
}

/// Converts an amount with a unit to grams for calorie calculation.
double convertToGrams(String ingredientId, double amount, QuantityUnit unit) {
  final nutrition = ingredientNutritionData[ingredientId];

  switch (unit) {
    case QuantityUnit.g:
      return amount;
    case QuantityUnit.ml:
      // Approximate: 1 ml ≈ 1 g for most liquids
      return amount;
    case QuantityUnit.L:
      return amount * 1000;
    case QuantityUnit.piece:
      // Use defaultServingG as weight per piece
      return amount * (nutrition?.defaultServingG ?? 100);
    case QuantityUnit.tablespoon:
      return amount * 15; // ~15g per tablespoon
    case QuantityUnit.teaspoon:
      return amount * 5; // ~5g per teaspoon
    case QuantityUnit.cup:
      return amount * 240; // ~240ml/g per cup
    case QuantityUnit.bunch:
      return amount * 30; // ~30g per small bunch
    case QuantityUnit.slice:
      return amount * 30; // ~30g per slice
    case QuantityUnit.pinch:
      return amount * 1; // ~1g per pinch
    case QuantityUnit.clove:
      return amount * 5; // ~5g per clove
  }
}

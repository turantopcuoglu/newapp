import '../core/enums.dart';
import '../models/ingredient.dart';
import 'mock_ingredients.dart';

/// Look and feel for an ingredient tile: an emoji and a gradient.
///
/// The health categories show ingredients as cards in the same style as the
/// world cuisines, and there are no photos in this app — the emoji is the
/// picture. Anything without its own emoji falls back to its food category, so
/// a new ingredient still renders something sensible.

const Map<String, String> _ingredientEmoji = {
  // Protein
  'chicken_breast': '🍗', 'chicken_thigh': '🍗', 'chicken_wing': '🍗',
  'turkey_breast': '🦃', 'ground_turkey': '🦃',
  'ground_beef': '🥩', 'beef_steak': '🥩', 'lamb': '🥩', 'veal': '🥩',
  'liver': '🫀', 'pork_chop': '🥓', 'duck_breast': '🦆',
  'salmon': '🐟', 'tuna': '🐟', 'cod': '🐟', 'sea_bass': '🐟',
  'sea_bream': '🐟', 'sardine': '🐟', 'anchovy': '🐟',
  'shrimp': '🦐', 'squid': '🦑', 'octopus': '🐙', 'mussel': '🦪',
  'eggs': '🥚', 'tofu': '🧊',
  // Dairy
  'milk': '🥛', 'yogurt': '🥛', 'greek_yogurt': '🥛', 'kefir': '🥛',
  'cheddar_cheese': '🧀', 'feta_cheese': '🧀', 'parmesan': '🧀',
  'mozzarella': '🧀', 'goat_cheese': '🧀', 'ricotta': '🧀',
  'cottage_cheese': '🧀', 'labne': '🧀', 'butter': '🧈',
  // Grains
  'white_rice': '🍚', 'brown_rice': '🍚', 'basmati_rice': '🍚',
  'quinoa': '🌾', 'buckwheat': '🌾', 'bulgur': '🌾', 'oats': '🥣',
  'cornmeal': '🌽', 'whole_wheat_flour': '🌾', 'barley': '🌾',
  'pasta': '🍝', 'bread': '🍞',
  // Vegetables
  'spinach': '🥬', 'kale': '🥬', 'swiss_chard': '🥬', 'lettuce': '🥬',
  'arugula': '🥬', 'cabbage': '🥬', 'broccoli': '🥦', 'cauliflower': '🥦',
  'tomato': '🍅', 'potato': '🥔', 'sweet_potato': '🍠', 'carrot': '🥕',
  'bell_pepper': '🫑', 'hot_pepper': '🌶️', 'cucumber': '🥒',
  'zucchini': '🥒', 'eggplant': '🍆', 'corn': '🌽', 'mushroom': '🍄',
  'onion': '🧅', 'red_onion': '🧅', 'garlic': '🧄', 'ginger': '🫚',
  'parsley': '🌿', 'mint': '🌿', 'dill': '🌿',
  // Fruit
  'avocado': '🥑', 'banana': '🍌', 'apple': '🍎', 'pear': '🍐',
  'strawberry': '🍓', 'blueberry': '🫐', 'blackberry': '🫐',
  'raspberry': '🫐', 'orange': '🍊', 'tangerine': '🍊',
  'grapefruit': '🍊', 'lemon': '🍋', 'lime': '🍋', 'pomegranate': '🍎',
  'grape': '🍇', 'peach': '🍑', 'cherry': '🍒', 'fig': '🫒',
  'mango': '🥭', 'pineapple': '🍍', 'kiwi': '🥝', 'melon': '🍈',
  'watermelon': '🍉', 'apricot': '🍑', 'dates': '🌴', 'plum': '🍑',
  'coconut': '🥥',
  // Nuts and seeds
  'walnut': '🌰', 'almond': '🌰', 'hazelnut': '🌰', 'chestnut': '🌰',
  'pistachio': '🥜', 'peanut': '🥜', 'cashew': '🥜', 'pine_nut': '🥜',
  'pumpkin_seeds': '🎃', 'sunflower_seeds': '🌻', 'sesame_seeds': '🌰',
  'chia_seeds': '🌱', 'flax_seeds': '🌱', 'poppy_seeds': '🌱',
  // Legumes
  'red_lentil': '🫘', 'green_lentil': '🫘', 'chickpea': '🫘',
  'white_bean': '🫘', 'black_bean': '🫘', 'kidney_bean': '🫘',
  'fava_bean': '🫘', 'black_eyed_pea': '🫘', 'split_pea': '🫘',
  'edamame': '🫛', 'peas': '🫛',
  // Fats, condiments, others
  'olive_oil': '🫒', 'olives': '🫒', 'avocado_oil': '🥑',
  'coconut_oil': '🥥', 'coconut_milk': '🥥', 'tahini': '🥣',
  'peanut_butter': '🥜', 'almond_butter': '🥜', 'honey': '🍯',
  'dark_chocolate': '🍫', 'cocoa_powder': '🍫', 'cinnamon': '🪵',
};

const Map<IngredientCategory, String> _categoryEmoji = {
  IngredientCategory.protein: '🍖',
  IngredientCategory.dairy: '🥛',
  IngredientCategory.grain: '🌾',
  IngredientCategory.vegetable: '🥬',
  IngredientCategory.fruit: '🍎',
  IngredientCategory.spice: '🧂',
  IngredientCategory.oil: '🫒',
  IngredientCategory.nut: '🥜',
  IngredientCategory.legume: '🫘',
  IngredientCategory.condiment: '🥣',
  IngredientCategory.snackFood: '🍪',
  IngredientCategory.beverage: '🥤',
  IngredientCategory.other: '🍽️',
};

/// Gradient pairs per food group, so the tiles read as a family.
const Map<IngredientCategory, List<int>> _categoryGradient = {
  IngredientCategory.protein: [0xFFC62828, 0xFFEF5350],
  IngredientCategory.dairy: [0xFF1565C0, 0xFF64B5F6],
  IngredientCategory.grain: [0xFFB8860B, 0xFFE0B252],
  IngredientCategory.vegetable: [0xFF2E7D32, 0xFF81C784],
  IngredientCategory.fruit: [0xFFC2185B, 0xFFF06292],
  IngredientCategory.spice: [0xFF8D6E63, 0xFFBCAAA4],
  IngredientCategory.oil: [0xFF827717, 0xFFC0CA33],
  IngredientCategory.nut: [0xFFE65100, 0xFFFFB74D],
  IngredientCategory.legume: [0xFF6D4C41, 0xFFA1887F],
  IngredientCategory.condiment: [0xFF00695C, 0xFF4DB6AC],
  IngredientCategory.snackFood: [0xFF4E342E, 0xFF8D6E63],
  IngredientCategory.beverage: [0xFF00838F, 0xFF4DD0E1],
  IngredientCategory.other: [0xFF455A64, 0xFF90A4AE],
};

final Map<String, Ingredient> _byId = {
  for (final ingredient in mockIngredients) ingredient.id: ingredient,
};

Ingredient? ingredientById(String id) => _byId[id];

String ingredientEmoji(String id) =>
    _ingredientEmoji[id] ??
    _categoryEmoji[_byId[id]?.category ?? IngredientCategory.other]!;

List<int> ingredientGradient(String id) =>
    _categoryGradient[_byId[id]?.category ?? IngredientCategory.other]!;

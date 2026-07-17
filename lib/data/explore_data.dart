import '../core/enums.dart';

/// Represents a cuisine category in the Explore screen.
/// Recipes belong to a category via their `cuisineIds` field — there is no
/// hand-maintained recipe list here.
class CuisineCategory {
  final String id;
  final Map<String, String> name;
  final String emoji;
  final String gradient; // gradient key for visual styling

  const CuisineCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.gradient,
  });

  String localizedName(String locale) =>
      name[locale] ?? name['en'] ?? name.values.first;
}

/// Represents a special-needs category (health/condition based).
class SpecialCategory {
  final String id;
  final Map<String, String> name;
  final Map<String, String> subtitle;
  final String emoji;
  final String gradient;
  final HealthCondition? healthCondition;
  final List<CheckInType> relatedCheckInTypes;
  final List<String> relatedAllergenExclusions;

  const SpecialCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    this.healthCondition,
    this.relatedCheckInTypes = const [],
    this.relatedAllergenExclusions = const [],
  });

  String localizedName(String locale) =>
      name[locale] ?? name['en'] ?? name.values.first;

  String localizedSubtitle(String locale) =>
      subtitle[locale] ?? subtitle['en'] ?? subtitle.values.first;
}

// ── World Cuisine Categories ──────────────────────────────────────────────

const List<CuisineCategory> worldCuisines = [
  CuisineCategory(
    id: 'turkish',
    name: {'en': 'Turkish', 'tr': 'Türk Mutfağı'},
    emoji: '🇹🇷',
    gradient: 'turkish',
  ),
  CuisineCategory(
    id: 'italian',
    name: {'en': 'Italian', 'tr': 'İtalyan Mutfağı'},
    emoji: '🇮🇹',
    gradient: 'italian',
  ),
  CuisineCategory(
    id: 'asian',
    name: {'en': 'Asian', 'tr': 'Asya Mutfağı'},
    emoji: '🥢',
    gradient: 'asian',
  ),
  CuisineCategory(
    id: 'middleEastern',
    name: {'en': 'Middle Eastern', 'tr': 'Ortadoğu Mutfağı'},
    emoji: '🧆',
    gradient: 'middleEastern',
  ),
  CuisineCategory(
    id: 'mediterranean',
    name: {'en': 'Mediterranean', 'tr': 'Akdeniz Mutfağı'},
    emoji: '🫒',
    gradient: 'mediterranean',
  ),
  CuisineCategory(
    id: 'american',
    name: {'en': 'American', 'tr': 'Amerikan Mutfağı'},
    emoji: '🍔',
    gradient: 'american',
  ),
  CuisineCategory(
    id: 'mexican',
    name: {'en': 'Mexican', 'tr': 'Meksika Mutfağı'},
    emoji: '🌮',
    gradient: 'mexican',
  ),
  CuisineCategory(
    id: 'international',
    name: {'en': 'International & Fusion', 'tr': 'Dünya & Füzyon'},
    emoji: '🌍',
    gradient: 'international',
  ),
];

// ── Health Condition Categories ──────────────────────────────────────────

const List<SpecialCategory> specialCategories = [
  SpecialCategory(
    id: 'pcos',
    name: {'en': 'PCOS Friendly', 'tr': 'PCOS Dostu'},
    subtitle: {
      'en': 'Low glycemic, anti-inflammatory meals',
      'tr': 'Düşük glisemik, iltihap önleyici öğünler',
    },
    emoji: '🩺',
    gradient: 'pcos',
    healthCondition: HealthCondition.pcos,
  ),
  SpecialCategory(
    id: 'insulinResistance',
    name: {'en': 'Insulin Resistance', 'tr': 'İnsülin Direnci'},
    subtitle: {
      'en': 'Blood sugar balancing recipes',
      'tr': 'Kan şekerini dengeleyen tarifler',
    },
    emoji: '🔬',
    gradient: 'insulinResistance',
    healthCondition: HealthCondition.insulinResistance,
  ),
  SpecialCategory(
    id: 'ironDeficiency',
    name: {'en': 'Iron Deficiency', 'tr': 'Demir Eksikliği'},
    subtitle: {
      'en': 'Iron-rich nutritious recipes',
      'tr': 'Demir açısından zengin tarifler',
    },
    emoji: '🥩',
    gradient: 'ironDeficiency',
    healthCondition: HealthCondition.ironDeficiency,
  ),
  SpecialCategory(
    id: 'vitaminB12',
    name: {'en': 'Vitamin B12 Deficiency', 'tr': 'B12 Vitamini Eksikliği'},
    subtitle: {
      'en': 'B12-rich meals for energy',
      'tr': 'Enerji için B12 açısından zengin öğünler',
    },
    emoji: '💊',
    gradient: 'vitaminB12',
    healthCondition: HealthCondition.vitaminB12Deficiency,
  ),
  SpecialCategory(
    id: 'magnesiumDeficiency',
    name: {'en': 'Magnesium Deficiency', 'tr': 'Magnezyum Eksikliği'},
    subtitle: {
      'en': 'Magnesium-rich calming recipes',
      'tr': 'Magnezyum açısından zengin tarifler',
    },
    emoji: '🥬',
    gradient: 'magnesiumDeficiency',
    healthCondition: HealthCondition.magnesiumDeficiency,
  ),
  SpecialCategory(
    id: 'anemia',
    name: {'en': 'Anemia', 'tr': 'Kansızlık'},
    subtitle: {
      'en': 'Blood-building nutritious meals',
      'tr': 'Kan yapıcı besleyici öğünler',
    },
    emoji: '❤️‍🩹',
    gradient: 'anemia',
    healthCondition: HealthCondition.anemia,
  ),
];

// ── Gradient Definitions ──────────────────────────────────────────────────

const Map<String, List<int>> cuisineGradients = {
  'turkish': [0xFFE53935, 0xFFFF7043],
  'italian': [0xFF388E3C, 0xFF66BB6A],
  'asian': [0xFFD84315, 0xFFFF8A65],
  'middleEastern': [0xFFC2185B, 0xFFE91E63],
  'mediterranean': [0xFF1565C0, 0xFF42A5F5],
  'american': [0xFF1565C0, 0xFFEF5350],
  'mexican': [0xFFE65100, 0xFFFFB74D],
  'international': [0xFF00695C, 0xFF4DB6AC],
  'healthy': [0xFF2E7D32, 0xFF81C784],
  // Health condition categories
  'pcos': [0xFF7B1FA2, 0xFFBA68C8],
  'insulinResistance': [0xFF5C6BC0, 0xFF7986CB],
  'ironDeficiency': [0xFFE64A19, 0xFFFF8A65],
  'vitaminB12': [0xFFEC407A, 0xFFF48FB1],
  'magnesiumDeficiency': [0xFF00897B, 0xFF4DB6AC],
  'anemia': [0xFFC62828, 0xFFEF5350],
};

// ── Health Condition Ingredient Filters ───────────────────────────────────
// Ingredients considered beneficial for each health condition.

const Map<HealthCondition, List<String>> healthConditionIngredients = {
  HealthCondition.ironDeficiency: [
    'beef', 'lamb', 'ground_beef', 'red_meat', 'spinach', 'lentils',
    'red_lentils', 'chickpeas', 'eggs', 'liver', 'kidney_beans',
    'dark_chocolate', 'quinoa', 'tofu', 'pumpkin_seeds',
  ],
  HealthCondition.vitaminB12Deficiency: [
    'beef', 'lamb', 'ground_beef', 'red_meat', 'chicken', 'chicken_breast',
    'chicken_thigh', 'fish', 'salmon', 'tuna', 'sardine', 'eggs',
    'milk', 'yogurt', 'cheese', 'feta_cheese', 'liver',
  ],
  HealthCondition.magnesiumDeficiency: [
    'spinach', 'almonds', 'walnuts', 'cashews', 'pumpkin_seeds',
    'sunflower_seeds', 'chia_seeds', 'flaxseeds', 'banana', 'avocado',
    'dark_chocolate', 'black_beans', 'kidney_beans', 'lentils',
    'chickpeas', 'oats', 'quinoa', 'tofu', 'edamame',
  ],
  HealthCondition.anemia: [
    'beef', 'lamb', 'ground_beef', 'red_meat', 'spinach', 'lentils',
    'red_lentils', 'chickpeas', 'eggs', 'liver', 'kidney_beans',
    'dark_chocolate', 'quinoa', 'tofu', 'pumpkin_seeds',
    'lemon', 'orange', 'tomato', 'bell_pepper', 'broccoli',
  ],
};

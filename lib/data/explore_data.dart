import '../core/enums.dart';

/// Represents a cuisine category in the Explore screen.
class CuisineCategory {
  final String id;
  final Map<String, String> name;
  final String emoji;
  final String gradient; // gradient key for visual styling
  final List<String> recipeIds;

  const CuisineCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.gradient,
    this.recipeIds = const [],
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
    recipeIds: [
      'b006', 'b017',
      'd002', 'd006', 'd007', 'd008', 'd010', 'd011', 'd013', 'd015',
      'l002', 'l005', 'l008', 'l010', 'l013', 'l015', 'l025',
    ],
  ),
  CuisineCategory(
    id: 'italian',
    name: {'en': 'Italian', 'tr': 'İtalyan Mutfağı'},
    emoji: '🇮🇹',
    gradient: 'italian',
    recipeIds: [
      'd004', 'd012',
      'l017', 'l026',
    ],
  ),
  CuisineCategory(
    id: 'asian',
    name: {'en': 'Asian', 'tr': 'Asya Mutfağı'},
    emoji: '🥢',
    gradient: 'asian',
    recipeIds: [
      'd003',
      'l009', 'l014',
    ],
  ),
  CuisineCategory(
    id: 'middleEastern',
    name: {'en': 'Middle Eastern', 'tr': 'Ortadoğu Mutfağı'},
    emoji: '🧆',
    gradient: 'middleEastern',
    recipeIds: [
      'd014',
      'l006',
      's004', 's016',
    ],
  ),
  CuisineCategory(
    id: 'mediterranean',
    name: {'en': 'Mediterranean', 'tr': 'Akdeniz Mutfağı'},
    emoji: '🫒',
    gradient: 'mediterranean',
    recipeIds: [
      'b002', 'b012',
      'd001',
      'l001', 'l011', 'l016', 'l018', 'l021',
      's006', 's022',
    ],
  ),
  CuisineCategory(
    id: 'american',
    name: {'en': 'American', 'tr': 'Amerikan Mutfağı'},
    emoji: '🍔',
    gradient: 'american',
    recipeIds: [
      'b004', 'b010', 'b020', 'b025',
      'd009',
      'l012', 'l019',
    ],
  ),
  CuisineCategory(
    id: 'mexican',
    name: {'en': 'Mexican', 'tr': 'Meksika Mutfağı'},
    emoji: '🌮',
    gradient: 'mexican',
    recipeIds: [
      'l024', 'l027',
      's028',
    ],
  ),
  CuisineCategory(
    id: 'healthy',
    name: {'en': 'Healthy & Light', 'tr': 'Sağlıklı & Hafif'},
    emoji: '🥗',
    gradient: 'healthy',
    recipeIds: [
      'b001', 'b008', 'b011', 'b014', 'b016', 'b019', 'b021', 'b023', 'b024',
      's001', 's002', 's003', 's005', 's006', 's007', 's008', 's009', 's010',
      's011', 's012', 's013', 's014', 's015', 's017', 's018', 's019', 's020',
      's021', 's022', 's023', 's024', 's025', 's026', 's031', 's032', 's033',
    ],
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

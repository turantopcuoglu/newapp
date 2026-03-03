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
  final List<CheckInType> relatedCheckInTypes;
  final List<String> relatedAllergenExclusions;

  const SpecialCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
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
      'd002', 'd005', 'd006', 'd007', 'd008', 'd009', 'd010', 'd011',
      'd013', 'd015', // dinner
      'b003', 'b006', 'b010', // breakfast (menemen, simit, gözleme)
      'l002', 'l005', 'l008', 'l013', // lunch
    ],
  ),
  CuisineCategory(
    id: 'italian',
    name: {'en': 'Italian', 'tr': 'İtalyan Mutfağı'},
    emoji: '🇮🇹',
    gradient: 'italian',
    recipeIds: [
      'd004', 'd012', // pasta, risotto
      'l003', // lunch
    ],
  ),
  CuisineCategory(
    id: 'asian',
    name: {'en': 'Asian', 'tr': 'Asya Mutfağı'},
    emoji: '🥢',
    gradient: 'asian',
    recipeIds: [
      'd003', // stir-fry
      'l004', 'l007', 'l010', // lunch
    ],
  ),
  CuisineCategory(
    id: 'middleEastern',
    name: {'en': 'Middle Eastern', 'tr': 'Ortadoğu Mutfağı'},
    emoji: '🧆',
    gradient: 'middleEastern',
    recipeIds: [
      'd014', // shawarma
      'l006', 'l009', // lunch
    ],
  ),
  CuisineCategory(
    id: 'mediterranean',
    name: {'en': 'Mediterranean', 'tr': 'Akdeniz Mutfağı'},
    emoji: '🫒',
    gradient: 'mediterranean',
    recipeIds: [
      'd001', 'd013', // salmon, imam bayildi
      'l001', 'l002', // salad, wrap
      'b002', 'b007', // breakfast
    ],
  ),
  CuisineCategory(
    id: 'american',
    name: {'en': 'American', 'tr': 'Amerikan Mutfağı'},
    emoji: '🍔',
    gradient: 'american',
    recipeIds: [
      'b001', 'b004', 'b005', 'b008', // breakfast (oatmeal, pancake, smoothie, avocado toast)
      'l011', 'l012', // lunch
    ],
  ),
  CuisineCategory(
    id: 'mexican',
    name: {'en': 'Mexican', 'tr': 'Meksika Mutfağı'},
    emoji: '🌮',
    gradient: 'mexican',
    recipeIds: [
      'l014', 'l015', // lunch
    ],
  ),
  CuisineCategory(
    id: 'healthy',
    name: {'en': 'Healthy & Light', 'tr': 'Sağlıklı & Hafif'},
    emoji: '🥗',
    gradient: 'healthy',
    recipeIds: [
      's001', 's002', 's003', 's004', 's005', 's006', 's007', 's008',
      's009', 's010', 's011', 's012', 's013', 's014', 's015', // snacks
      'b009', // chia pudding
    ],
  ),
];

// ── Special Needs Categories ──────────────────────────────────────────────

const List<SpecialCategory> specialCategories = [
  SpecialCategory(
    id: 'diabetic',
    name: {'en': 'Diabetic Friendly', 'tr': 'Şeker Dostu'},
    subtitle: {
      'en': 'Low glycemic, balanced meals',
      'tr': 'Düşük glisemik, dengeli öğünler',
    },
    emoji: '🩺',
    gradient: 'diabetic',
    relatedCheckInTypes: [CheckInType.feelingBalanced],
  ),
  SpecialCategory(
    id: 'postWorkout',
    name: {'en': 'Post-Workout', 'tr': 'Spor Sonrası'},
    subtitle: {
      'en': 'High protein recovery meals',
      'tr': 'Yüksek proteinli toparlanma öğünleri',
    },
    emoji: '💪',
    gradient: 'postWorkout',
    relatedCheckInTypes: [CheckInType.postWorkout],
  ),
  SpecialCategory(
    id: 'fatigue',
    name: {'en': 'Energy Boost', 'tr': 'Enerji Artırıcı'},
    subtitle: {
      'en': 'Combat fatigue with right nutrition',
      'tr': 'Doğru beslenmeyle yorgunluğu yen',
    },
    emoji: '⚡',
    gradient: 'fatigue',
    relatedCheckInTypes: [
      CheckInType.lowEnergy,
      CheckInType.periodFatigue,
    ],
  ),
  SpecialCategory(
    id: 'bloating',
    name: {'en': 'Anti-Bloating', 'tr': 'Şişkinlik Giderici'},
    subtitle: {
      'en': 'Light, digestion-friendly recipes',
      'tr': 'Hafif, sindirim dostu tarifler',
    },
    emoji: '🍃',
    gradient: 'bloating',
    relatedCheckInTypes: [CheckInType.bloated],
  ),
  SpecialCategory(
    id: 'allergyFree',
    name: {'en': 'Allergy Friendly', 'tr': 'Alerji Dostu'},
    subtitle: {
      'en': 'Free from common allergens',
      'tr': 'Yaygın alerjenlerden arındırılmış',
    },
    emoji: '🛡️',
    gradient: 'allergyFree',
    relatedAllergenExclusions: [
      'gluten', 'dairy', 'eggs', 'nuts', 'tree_nuts', 'soy', 'fish',
    ],
  ),
  SpecialCategory(
    id: 'pms',
    name: {'en': 'PMS Relief', 'tr': 'PMS Rahatlatıcı'},
    subtitle: {
      'en': 'Ease symptoms with comfort food',
      'tr': 'Semptomları hafifletecek tarifler',
    },
    emoji: '🌸',
    gradient: 'pms',
    relatedCheckInTypes: [
      CheckInType.pms,
      CheckInType.periodCramps,
      CheckInType.periodFatigue,
    ],
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
  // Special categories
  'diabetic': [0xFF5C6BC0, 0xFF7986CB],
  'postWorkout': [0xFFE64A19, 0xFFFF8A65],
  'fatigue': [0xFFFFB300, 0xFFFFD54F],
  'bloating': [0xFF00897B, 0xFF4DB6AC],
  'allergyFree': [0xFF7B1FA2, 0xFFBA68C8],
  'pms': [0xFFEC407A, 0xFFF48FB1],
};

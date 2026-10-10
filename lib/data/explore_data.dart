import '../core/enums.dart';

/// Represents a cuisine category in the Explore screen.
/// Recipes belong to a category via their `cuisineIds` field — there is no
/// hand-maintained recipe list here.
class CuisineCategory {
  final String id;
  final Map<String, String> name;
  final String coverImage;

  const CuisineCategory({
    required this.id,
    required this.name,
    required this.coverImage,
  });

  String localizedName(String locale) =>
      name[locale] ?? name['en'] ?? name.values.first;
}

/// Represents a special-needs category (health/condition based).
class SpecialCategory {
  final String id;
  final Map<String, String> name;
  final Map<String, String> subtitle;
  final String coverImage;
  final HealthCondition? healthCondition;
  final List<CheckInType> relatedCheckInTypes;
  final List<String> relatedAllergenExclusions;

  const SpecialCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.coverImage,
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
    coverImage: 'assets/images/explore/cuisine_turkish.jpg',
    name: {'en': 'Turkish', 'tr': 'Türk Mutfağı'},
  ),
  CuisineCategory(
    id: 'italian',
    coverImage: 'assets/images/explore/cuisine_italian.jpg',
    name: {'en': 'Italian', 'tr': 'İtalyan Mutfağı'},
  ),
  CuisineCategory(
    id: 'asian',
    coverImage: 'assets/images/explore/cuisine_asian.jpg',
    name: {'en': 'Asian', 'tr': 'Asya Mutfağı'},
  ),
  CuisineCategory(
    id: 'middleEastern',
    coverImage: 'assets/images/explore/cuisine_middleEastern.jpg',
    name: {'en': 'Middle Eastern', 'tr': 'Ortadoğu Mutfağı'},
  ),
  CuisineCategory(
    id: 'mediterranean',
    coverImage: 'assets/images/explore/cuisine_mediterranean.jpg',
    name: {'en': 'Mediterranean', 'tr': 'Akdeniz Mutfağı'},
  ),
  CuisineCategory(
    id: 'american',
    coverImage: 'assets/images/explore/cuisine_american.jpg',
    name: {'en': 'American', 'tr': 'Amerikan Mutfağı'},
  ),
  CuisineCategory(
    id: 'mexican',
    coverImage: 'assets/images/explore/cuisine_mexican.jpg',
    name: {'en': 'Mexican', 'tr': 'Meksika Mutfağı'},
  ),
  CuisineCategory(
    id: 'international',
    coverImage: 'assets/images/explore/cuisine_international.jpg',
    name: {'en': 'International & Fusion', 'tr': 'Dünya & Füzyon'},
  ),
];

// ── Health Condition Categories ──────────────────────────────────────────

const List<SpecialCategory> specialCategories = [
  SpecialCategory(
    id: 'pcos',
    coverImage: 'assets/images/explore/health_pcos.jpg',
    // "PCOS'ta beslenme", not "for PCOS": the app supports eating, it does
    // not treat a condition (medical-device line, roadmap phase 4).
    name: {'en': 'Eating with PCOS', 'tr': 'PCOS\'ta Beslenme'},
    subtitle: {
      'en': 'Low-glycaemic meals with fibre and protein',
      'tr': 'Lif ve protein içeren, düşük glisemik öğünler',
    },
    healthCondition: HealthCondition.pcos,
  ),
  SpecialCategory(
    id: 'insulinResistance',
    coverImage: 'assets/images/explore/health_insulinResistance.jpg',
    name: {'en': 'Insulin Resistance', 'tr': 'İnsülin Direnci'},
    subtitle: {
      'en': 'Fibre and protein first',
      'tr': 'Lif ve proteini öne çıkan tarifler',
    },
    healthCondition: HealthCondition.insulinResistance,
  ),
  SpecialCategory(
    id: 'ironDeficiency',
    coverImage: 'assets/images/explore/health_ironDeficiency.jpg',
    name: {'en': 'Iron Deficiency', 'tr': 'Demir Eksikliği'},
    subtitle: {
      'en': 'Recipes with iron sources',
      'tr': 'Demir kaynağı içeren tarifler',
    },
    healthCondition: HealthCondition.ironDeficiency,
  ),
  SpecialCategory(
    id: 'vitaminB12',
    coverImage: 'assets/images/explore/health_vitaminB12.jpg',
    name: {'en': 'Vitamin B12 Deficiency', 'tr': 'B12 Vitamini Eksikliği'},
    subtitle: {
      'en': 'Meals with B12 sources',
      'tr': 'B12 kaynağı içeren öğünler',
    },
    healthCondition: HealthCondition.vitaminB12Deficiency,
  ),
  SpecialCategory(
    id: 'magnesiumDeficiency',
    coverImage: 'assets/images/explore/health_magnesiumDeficiency.jpg',
    name: {'en': 'Magnesium Deficiency', 'tr': 'Magnezyum Eksikliği'},
    subtitle: {
      'en': 'Recipes with magnesium sources',
      'tr': 'Magnezyum kaynağı içeren tarifler',
    },
    healthCondition: HealthCondition.magnesiumDeficiency,
  ),
  SpecialCategory(
    id: 'anemia',
    coverImage: 'assets/images/explore/health_anemia.jpg',
    name: {'en': 'Anemia', 'tr': 'Kansızlık'},
    subtitle: {
      'en': 'Iron and vitamin C on one plate',
      'tr': 'Demir ve C vitamini bir arada',
    },
    healthCondition: HealthCondition.anemia,
  ),

  // Categories driven by allergen exclusion or check-in tags rather than a
  // HealthCondition — gluten and lactose intolerance and cycle support are
  // what users actually search for, but they are not "conditions" in the
  // deficiency sense above.
  SpecialCategory(
    id: 'glutenFree',
    coverImage: 'assets/images/explore/health_glutenFree.jpg',
    name: {'en': 'Gluten-Free', 'tr': 'Glutensiz'},
    subtitle: {
      'en': 'No wheat, no barley, no worry',
      'tr': 'Buğday ve arpa içermeyen tarifler',
    },
    relatedAllergenExclusions: ['gluten'],
  ),
  SpecialCategory(
    id: 'lactoseFree',
    coverImage: 'assets/images/explore/health_lactoseFree.jpg',
    name: {'en': 'Lactose-Free', 'tr': 'Laktozsuz'},
    subtitle: {
      'en': 'Dairy-free meals that still satisfy',
      'tr': 'Süt ürünü içermeyen doyurucu öğünler',
    },
    relatedAllergenExclusions: ['dairy'],
  ),
  SpecialCategory(
    id: 'periodSupport',
    coverImage: 'assets/images/explore/health_periodSupport.jpg',
    name: {'en': 'Period Support', 'tr': 'Regl Dönemi'},
    subtitle: {
      'en': 'Meals with magnesium and iron',
      'tr': 'Magnezyum ve demir içeren öğünler',
    },
    relatedCheckInTypes: [
      CheckInType.periodCramps,
      CheckInType.periodFatigue,
      CheckInType.pms,
    ],
  ),
];

// ── Health Condition Ingredient Filters ───────────────────────────────────
// Ingredients considered beneficial for each health condition.
//
// These must be canonical ids from mock_ingredients.dart: matching is an exact
// id comparison, so a generic term like 'fish' or a plural like 'walnuts'
// silently matches nothing and hides recipes from the category. The data
// report validates every id here for exactly that reason.

const Map<HealthCondition, List<String>> healthConditionIngredients = {
  HealthCondition.ironDeficiency: [
    'ground_beef',
    'beef_steak',
    'veal',
    'lamb',
    'liver',
    'spinach',
    'swiss_chard',
    'red_lentil',
    'green_lentil',
    'chickpea',
    'kidney_bean',
    'white_bean',
    'black_bean',
    'fava_bean',
    'eggs',
    'dark_chocolate',
    'quinoa',
    'tofu',
    'pumpkin_seeds',
    'sesame_seeds',
    'apricot',
    'dates',
  ],
  HealthCondition.vitaminB12Deficiency: [
    'ground_beef',
    'beef_steak',
    'veal',
    'lamb',
    'liver',
    'chicken_breast',
    'chicken_thigh',
    'chicken_wing',
    'turkey_breast',
    'ground_turkey',
    'salmon',
    'tuna',
    'cod',
    'sardine',
    'anchovy',
    'sea_bass',
    'sea_bream',
    'mussel',
    'squid',
    'octopus',
    'shrimp',
    'eggs',
    'milk',
    'yogurt',
    'greek_yogurt',
    'kefir',
    'cheddar_cheese',
    'feta_cheese',
    'parmesan',
    'mozzarella',
    'goat_cheese',
    'ricotta',
  ],
  HealthCondition.magnesiumDeficiency: [
    'spinach',
    'swiss_chard',
    'kale',
    'almond',
    'walnut',
    'cashew',
    'hazelnut',
    'pistachio',
    'peanut',
    'pumpkin_seeds',
    'sunflower_seeds',
    'sesame_seeds',
    'chia_seeds',
    'flax_seeds',
    'tahini',
    'banana',
    'avocado',
    'dark_chocolate',
    'cocoa_powder',
    'black_bean',
    'kidney_bean',
    'white_bean',
    'red_lentil',
    'green_lentil',
    'chickpea',
    'oats',
    'quinoa',
    'buckwheat',
    'bulgur',
    'tofu',
    'edamame',
  ],
  HealthCondition.anemia: [
    'ground_beef', 'beef_steak', 'veal', 'lamb', 'liver', 'spinach',
    'swiss_chard', 'red_lentil', 'green_lentil', 'chickpea', 'kidney_bean',
    'white_bean', 'eggs', 'dark_chocolate', 'quinoa', 'tofu',
    'pumpkin_seeds', 'apricot', 'dates', 'pomegranate',
    // Vitamin C sources: iron is poorly absorbed without them.
    'lemon', 'lime', 'orange', 'tangerine', 'grapefruit', 'tomato',
    'bell_pepper', 'broccoli', 'parsley', 'strawberry',
  ],
};

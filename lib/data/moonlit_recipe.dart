import '../models/recipe.dart';
import '../core/enums.dart';

/// Recipe represented by the approved food photography. Prepared ingredients
/// are explicit; the 15 minutes do not promise cooking dried chickpeas.
const moonlitBowl = Recipe(
  id: 'moonlit_bulgur_bowl',
  name: {'tr': 'Nohutlu bulgur kasesi', 'en': 'Chickpea bulgur bowl'},
  description: {
    'tr':
        'Hazır nohut ve önceden pişmiş bulgurla, domates ve maydanozlu bir kase. 15 dakika, hazır malzemeleri birleştirme süresidir.',
    'en':
        'A bowl of ready-cooked chickpeas and bulgur, tomato and parsley. The 15 minutes cover assembly with prepared ingredients.',
  },
  prepTimeMin: 15,
  mealType: MealType.lunch,
  ingredientIds: [
    'chickpea',
    'bulgur',
    'tomato',
    'parsley',
    'olive_oil',
    'lemon',
  ],
  allergenTags: ['gluten'],
  dietTags: ['vegan', 'vegetarian', 'dairyFree'],
  quantities: {
    'chickpea': IngredientQuantity(amount: 120),
    // Dry-equivalent weight, matching the existing nutrition catalog.
    'bulgur': IngredientQuantity(amount: 30),
    'tomato': IngredientQuantity(amount: 100),
    'parsley': IngredientQuantity(amount: 5),
    'olive_oil': IngredientQuantity(amount: 5),
    'lemon': IngredientQuantity(amount: 10),
  },
  steps: {
    'tr': [
      '120 g hazır haşlanmış nohudu süzüp durula. Önceden 30 g kuru bulgurdan pişirdiğin bulguru hazırla; bu ön pişirme 15 dakikaya dahil değildir.',
      '100 g domatesi doğra. Maydanozu yıkayıp ince kıy.',
      'Nohut, pişmiş bulgur ve domatesi bir kasede birleştir.',
      'Zeytinyağı, limon ve maydanozu ekleyip karıştır. Ürünlerin alerjen etiketlerini kontrol et.',
    ],
    'en': [
      'Drain and rinse 120 g ready-cooked chickpeas. Use bulgur previously cooked from 30 g dry bulgur; this prior cooking is not included in the 15 minutes.',
      'Chop 100 g tomato. Wash and chop the parsley.',
      'Combine the chickpeas, cooked bulgur and tomato in a bowl.',
      'Add olive oil, lemon and parsley. Check the products’ allergen labels.',
    ],
  },
);

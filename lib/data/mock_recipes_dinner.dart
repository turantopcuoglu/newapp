import '../models/recipe.dart';
import '../core/enums.dart';

const List<Recipe> mockDinnerRecipes = [
  // ── d001 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd001',
    name: {
      'en': 'Baked Salmon with Vegetables',
      'tr': 'Fırında Sebzeli Somon',
    },
    description: {
      'en':
          'Tender baked salmon fillet with roasted seasonal vegetables and a touch of lemon.',
      'tr':
          'Mevsim sebzeleri ile fırınlanmış yumuşacık somon fileto, limon dokunuşuyla.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'salmon',
      'broccoli',
      'carrot',
      'olive_oil',
      'lemon',
      'garlic',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['fish'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.feelingBalanced,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 420,
      proteinG: 38,
      carbsG: 15,
      fatG: 24,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Preheat oven to 200°C (400°F).',
        'Place salmon on a baking tray, season with salt, pepper, and lemon juice.',
        'Toss broccoli and carrots with olive oil and garlic, arrange around the salmon.',
        'Bake for 18-20 minutes until salmon is cooked through.',
        'Serve immediately with a squeeze of fresh lemon.',
      ],
      'tr': [
        'Fırını 200°C\'ye önceden ısıtın.',
        'Somonu fırın tepsisine yerleştirin, tuz, karabiber ve limon suyu ile tatlandırın.',
        'Brokoli ve havuçları zeytinyağı ve sarımsakla karıştırın, somonun etrafına dizin.',
        'Somon pişene kadar 18-20 dakika fırınlayın.',
        'Taze limon sıkarak hemen servis edin.',
      ],
    },
  ),

  // ── d002 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd002',
    name: {
      'en': 'Lentil Soup',
      'tr': 'Mercimek Çorbası',
    },
    description: {
      'en':
          'A classic Turkish red lentil soup, hearty and comforting, perfect for cold evenings.',
      'tr':
          'Klasik Türk mutfağının vazgeçilmezi, doyurucu ve içinizi ısıtan kırmızı mercimek çorbası.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'red_lentils',
      'onion',
      'carrot',
      'potato',
      'olive_oil',
      'cumin',
      'salt',
      'black_pepper',
      'lemon',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.bloated,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 280,
      proteinG: 16,
      carbsG: 42,
      fatG: 6,
      fiberG: 12,
    ),
    steps: {
      'en': [
        'Dice onion, carrot, and potato into small pieces.',
        'Sauté vegetables in olive oil until softened.',
        'Add rinsed red lentils and enough water to cover.',
        'Bring to a boil, then simmer for 20 minutes until lentils are tender.',
        'Blend until smooth, season with cumin, salt, and pepper. Serve with lemon.',
      ],
      'tr': [
        'Soğanı, havucu ve patatesi küçük küçük doğrayın.',
        'Sebzeleri zeytinyağında yumuşayana kadar kavurun.',
        'Yıkanmış kırmızı mercimeği ve üzerini geçecek kadar su ekleyin.',
        'Kaynatın, sonra mercimekler yumuşayana kadar 20 dakika pişirin.',
        'Pürüzsüz olana kadar blendırdan geçirin, kimyon, tuz ve karabiberle tatlandırın. Limonla servis edin.',
      ],
    },
  ),

  // ── d003 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd003',
    name: {
      'en': 'Chicken Stir-Fry with Rice',
      'tr': 'Pirinçli Tavuk Sote',
    },
    description: {
      'en':
          'Quick and flavorful chicken stir-fry with colorful vegetables, served over steamed rice.',
      'tr':
          'Rengarenk sebzelerle hazırlanan hızlı ve lezzetli tavuk sote, buğulanmış pilav eşliğinde.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'chicken_breast',
      'rice',
      'bell_pepper',
      'onion',
      'garlic',
      'soy_sauce',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['soy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.lowEnergy,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 480,
      proteinG: 35,
      carbsG: 52,
      fatG: 14,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Cook rice according to package instructions.',
        'Cut chicken breast into strips and season with salt and pepper.',
        'Stir-fry chicken in olive oil over high heat until golden.',
        'Add sliced bell pepper, onion, and garlic, cook for 3-4 minutes.',
        'Add soy sauce, toss everything together, and serve over rice.',
      ],
      'tr': [
        'Pirinci paket talimatlarına göre pişirin.',
        'Tavuk göğsünü şeritler halinde kesin, tuz ve karabiberle tatlandırın.',
        'Tavuğu zeytinyağında yüksek ateşte altın rengine kadar kavurun.',
        'Dilimlenmiş biber, soğan ve sarımsağı ekleyin, 3-4 dakika pişirin.',
        'Soya sosu ekleyin, karıştırın ve pilavın üzerine servis edin.',
      ],
    },
  ),

  // ── d004 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd004',
    name: {
      'en': 'Vegetable Pasta',
      'tr': 'Sebzeli Makarna',
    },
    description: {
      'en':
          'Wholesome pasta tossed with fresh seasonal vegetables and a light garlic olive oil sauce.',
      'tr':
          'Taze mevsim sebzeleri ve hafif sarımsaklı zeytinyağı sosuyla hazırlanan sağlıklı makarna.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'pasta',
      'zucchini',
      'tomato',
      'garlic',
      'olive_oil',
      'parmesan',
      'basil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 410,
      proteinG: 14,
      carbsG: 58,
      fatG: 14,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Cook pasta in salted boiling water until al dente, drain.',
        'Slice zucchini and tomatoes.',
        'Sauté garlic in olive oil until fragrant, add zucchini and cook for 3 minutes.',
        'Add tomatoes and cook for another 2 minutes.',
        'Toss with pasta, top with parmesan and fresh basil. Season and serve.',
      ],
      'tr': [
        'Makarnayı tuzlu kaynar suda al dente olana kadar pişirin, süzün.',
        'Kabağı ve domatesleri dilimleyin.',
        'Sarımsağı zeytinyağında kokusu çıkana kadar kavurun, kabağı ekleyip 3 dakika pişirin.',
        'Domatesleri ekleyin ve 2 dakika daha pişirin.',
        'Makarna ile karıştırın, parmesan ve taze fesleğen ile süsleyin. Tatlandırıp servis edin.',
      ],
    },
  ),

  // ── d005 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd005',
    name: {
      'en': 'Stuffed Bell Peppers',
      'tr': 'Etli Biber Dolması',
    },
    description: {
      'en':
          'Colorful bell peppers stuffed with a savory mixture of ground beef, rice, and herbs.',
      'tr':
          'Kıyma, pirinç ve baharatlarla hazırlanan iç harcıyla doldurulmuş renkli biber dolması.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'bell_pepper',
      'ground_beef',
      'rice',
      'onion',
      'tomato',
      'parsley',
      'olive_oil',
      'salt',
      'black_pepper',
      'cumin',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.postWorkout,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 450,
      proteinG: 28,
      carbsG: 38,
      fatG: 20,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Cut off the tops of bell peppers and remove seeds.',
        'Mix ground beef, partially cooked rice, diced onion, tomato, parsley, and spices.',
        'Stuff the peppers with the mixture.',
        'Place in a pot, add water halfway up the peppers.',
        'Cover and simmer for 45 minutes until peppers are tender.',
      ],
      'tr': [
        'Biberlerin üst kısımlarını kesin ve çekirdeklerini çıkarın.',
        'Kıymayı, yarı pişmiş pirinci, doğranmış soğanı, domatesi, maydanozu ve baharatları karıştırın.',
        'Biberleri karışımla doldurun.',
        'Tencereye yerleştirin, biberlerin yarısına kadar su ekleyin.',
        'Kapağı kapatıp biberler yumuşayana kadar 45 dakika pişirin.',
      ],
    },
  ),
];

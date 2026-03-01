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

  // ── d006 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd006',
    name: {
      'en': 'Turkish Karnıyarık (Stuffed Eggplant)',
      'tr': 'Karnıyarık',
    },
    description: {
      'en':
          'Classic Turkish stuffed eggplant with seasoned ground beef, tomatoes, and green peppers.',
      'tr':
          'Kıymalı, domatesli ve biberli geleneksel Türk mutfağının sevilen lezzeti karnıyarık.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'eggplant',
      'ground_beef',
      'onion',
      'tomato',
      'garlic',
      'bell_pepper',
      'parsley',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 380,
      proteinG: 24,
      carbsG: 18,
      fatG: 26,
      fiberG: 8,
    ),
    steps: {
      'en': [
        'Peel eggplants in stripes and fry until golden brown.',
        'Sauté ground beef with onions, garlic, and green peppers.',
        'Add diced tomatoes, salt, and pepper to the meat mixture.',
        'Slit the eggplants lengthwise and stuff with the meat filling.',
        'Place in a baking dish, top with tomato slices and bake at 180°C for 20 minutes.',
      ],
      'tr': [
        'Patlıcanları alacalı soyun ve kızarana kadar kızartın.',
        'Kıymayı soğan, sarımsak ve biberlerle kavurun.',
        'Doğranmış domatesleri, tuz ve karabiberi et karışımına ekleyin.',
        'Patlıcanları boydan yarın ve et harcıyla doldurun.',
        'Fırın kabına yerleştirin, üzerine domates dilimi koyun ve 180°C\'de 20 dakika pişirin.',
      ],
    },
  ),

  // ── d007 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd007',
    name: {
      'en': 'Grilled Meatballs (Köfte)',
      'tr': 'Izgara Köfte',
    },
    description: {
      'en':
          'Juicy Turkish-style grilled meatballs seasoned with onion, parsley, and cumin.',
      'tr':
          'Soğan, maydanoz ve kimyonla tatlandırılmış sulu Türk usulü ızgara köfte.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'ground_beef',
      'onion',
      'parsley',
      'garlic',
      'cumin',
      'salt',
      'black_pepper',
      'bread',
    ],
    allergenTags: ['gluten'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.lowEnergy,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 350,
      proteinG: 30,
      carbsG: 12,
      fatG: 20,
      fiberG: 1,
    ),
    steps: {
      'en': [
        'Grate the onion and squeeze out excess liquid.',
        'Mix ground beef, grated onion, minced parsley, garlic, cumin, salt, and pepper.',
        'Add soaked and squeezed bread, knead well for 5 minutes.',
        'Shape into oval patties and let rest for 30 minutes.',
        'Grill on high heat for 3-4 minutes each side until charred and cooked through.',
      ],
      'tr': [
        'Soğanı rendeleyin ve fazla suyunu sıkın.',
        'Kıymayı, rendelenmiş soğanı, kıyılmış maydanozu, sarımsağı, kimyonu, tuzu ve karabiberi karıştırın.',
        'Islatılıp sıkılmış ekmeği ekleyin, 5 dakika iyice yoğurun.',
        'Oval köfteler şekillendirin ve 30 dakika dinlendirin.',
        'Yüksek ateşte her tarafı 3-4 dakika ızgara yapın.',
      ],
    },
  ),

  // ── d008 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd008',
    name: {
      'en': 'Spinach and Feta Börek',
      'tr': 'Ispanaklı Börek',
    },
    description: {
      'en':
          'Flaky Turkish börek filled with spinach and feta cheese, baked until golden and crispy.',
      'tr':
          'Ispanak ve beyaz peynirle hazırlanan, altın rengi ve çıtır çıtır fırınlanmış Türk böreği.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'spinach',
      'feta_cheese',
      'eggs',
      'onion',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['gluten', 'dairy', 'eggs'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 320,
      proteinG: 14,
      carbsG: 30,
      fatG: 18,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Wash spinach and sauté with diced onion until wilted.',
        'Mix with crumbled feta cheese, salt, and pepper.',
        'Layer yufka sheets in a greased baking pan, brushing each with olive oil.',
        'Spread spinach filling between layers.',
        'Brush top with egg wash and bake at 190°C for 30-35 minutes until golden.',
      ],
      'tr': [
        'Ispanağı yıkayın ve doğranmış soğanla suyunu salana kadar kavurun.',
        'Ufalanmış beyaz peynir, tuz ve karabiberle karıştırın.',
        'Yağlanmış fırın tepsisine yufka serip her birini zeytinyağı ile yağlayın.',
        'Katlar arasına ıspanak harcı yayın.',
        'Üzerine yumurta sarısı sürüp 190°C\'de 30-35 dakika altın rengi olana kadar pişirin.',
      ],
    },
  ),

  // ── d009 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd009',
    name: {
      'en': 'Shepherd\'s Stew (Güveç)',
      'tr': 'Sebzeli Güveç',
    },
    description: {
      'en':
          'A hearty Turkish clay pot stew with lamb, potatoes, tomatoes, and peppers.',
      'tr':
          'Kuzu eti, patates, domates ve biberlerle hazırlanan doyurucu Türk güveci.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'lamb',
      'potato',
      'tomato',
      'bell_pepper',
      'onion',
      'garlic',
      'olive_oil',
      'salt',
      'black_pepper',
      'cumin',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.postWorkout,
      CheckInType.periodFatigue,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 520,
      proteinG: 32,
      carbsG: 35,
      fatG: 28,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Cut lamb into cubes and brown in olive oil.',
        'Add diced onion and garlic, sauté until softened.',
        'Add cubed potatoes, tomatoes, and bell peppers.',
        'Season with cumin, salt, and pepper. Add water to cover.',
        'Transfer to a clay pot and bake at 180°C for 1.5 hours until tender.',
      ],
      'tr': [
        'Kuzu etini küp küp doğrayın ve zeytinyağında kızartın.',
        'Doğranmış soğan ve sarımsağı ekleyip yumuşayana kadar kavurun.',
        'Küp doğranmış patates, domates ve biberleri ekleyin.',
        'Kimyon, tuz ve karabiberle tatlandırın. Üzerini geçecek kadar su ekleyin.',
        'Güveç kabına aktarın ve 180°C\'de 1.5 saat yumuşayana kadar pişirin.',
      ],
    },
  ),

  // ── d010 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd010',
    name: {
      'en': 'Turkish Pide (Meat Flatbread)',
      'tr': 'Kıymalı Pide',
    },
    description: {
      'en':
          'Boat-shaped Turkish flatbread topped with spiced ground meat, tomatoes, and peppers.',
      'tr':
          'Baharatlı kıyma, domates ve biberle hazırlanan kayık şeklinde Türk pidesi.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'ground_beef',
      'tomato',
      'bell_pepper',
      'onion',
      'parsley',
      'salt',
      'black_pepper',
      'cumin',
    ],
    allergenTags: ['gluten'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.noSpecificIssue,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 480,
      proteinG: 26,
      carbsG: 48,
      fatG: 20,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Prepare dough with flour, yeast, water, and salt. Let rise for 1 hour.',
        'Mix ground beef with diced tomato, pepper, onion, parsley, and spices.',
        'Roll dough into oval shapes and spread meat mixture on top.',
        'Fold edges up to form a boat shape.',
        'Bake at 220°C for 12-15 minutes until golden and crispy.',
      ],
      'tr': [
        'Un, maya, su ve tuzla hamur hazırlayın. 1 saat mayalanmaya bırakın.',
        'Kıymayı doğranmış domates, biber, soğan, maydanoz ve baharatlarla karıştırın.',
        'Hamuru oval açın ve üzerine et harcını yayın.',
        'Kenarları kaldırarak kayık şekli verin.',
        '220°C\'de 12-15 dakika altın rengi ve çıtır olana kadar pişirin.',
      ],
    },
  ),

  // ── d011 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd011',
    name: {
      'en': 'Stuffed Grape Leaves (Sarma)',
      'tr': 'Etli Yaprak Sarması',
    },
    description: {
      'en':
          'Tender grape leaves stuffed with a savory mixture of rice, ground meat, and herbs.',
      'tr':
          'Pirinç, kıyma ve baharatlarla sarılmış yumuşacık asma yaprağı sarması.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'rice',
      'ground_beef',
      'onion',
      'tomato',
      'parsley',
      'olive_oil',
      'lemon',
      'salt',
      'black_pepper',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 340,
      proteinG: 18,
      carbsG: 36,
      fatG: 14,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Blanch grape leaves in boiling water for 2 minutes, then drain.',
        'Mix rice, ground meat, diced onion, tomato, parsley, and seasonings.',
        'Place a spoonful of filling on each leaf and roll tightly.',
        'Arrange rolls seam-side down in a pot, add water and lemon juice.',
        'Cover and simmer on low heat for 50-60 minutes until rice is cooked.',
      ],
      'tr': [
        'Asma yapraklarını kaynar suda 2 dakika haşlayın, süzün.',
        'Pirinci, kıymayı, doğranmış soğanı, domatesi, maydanozu ve baharatları karıştırın.',
        'Her yaprağın üzerine bir kaşık harç koyup sıkıca sarın.',
        'Sarmaları dikişleri alta gelecek şekilde tencereye dizin, su ve limon suyu ekleyin.',
        'Kapağı kapatıp kısık ateşte 50-60 dakika pirinç pişene kadar pişirin.',
      ],
    },
  ),

  // ── d012 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd012',
    name: {
      'en': 'Creamy Mushroom Risotto',
      'tr': 'Kremalı Mantar Risotto',
    },
    description: {
      'en':
          'Rich and creamy Italian risotto with sautéed mushrooms and parmesan cheese.',
      'tr':
          'Sote mantarlı ve parmesan peynirli zengin ve kremalı İtalyan risottosu.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'rice',
      'mushroom',
      'onion',
      'garlic',
      'parmesan',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.feelingBalanced,
      CheckInType.cantFocus,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 420,
      proteinG: 12,
      carbsG: 56,
      fatG: 16,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Sauté sliced mushrooms in olive oil until golden, set aside.',
        'In the same pan, sauté diced onion and garlic until soft.',
        'Add rice and toast for 2 minutes, then add warm broth one ladle at a time.',
        'Stir continuously, adding broth as it absorbs, for about 18 minutes.',
        'Stir in mushrooms, parmesan, salt, and pepper. Serve immediately.',
      ],
      'tr': [
        'Dilimlenmiş mantarları zeytinyağında altın rengi olana kadar kavurun, kenara alın.',
        'Aynı tavada doğranmış soğan ve sarımsağı yumuşayana kadar kavurun.',
        'Pirinci ekleyip 2 dakika kavurun, sonra ılık et suyunu kepçe kepçe ekleyin.',
        'Sürekli karıştırarak yaklaşık 18 dakika boyunca et suyu ekleyin.',
        'Mantarları, parmesanı, tuzu ve karabiberi karıştırın. Hemen servis edin.',
      ],
    },
  ),

  // ── d013 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd013',
    name: {
      'en': 'Turkish İmam Bayıldı',
      'tr': 'İmam Bayıldı',
    },
    description: {
      'en':
          'A beloved Turkish dish of eggplant stuffed with onions, tomatoes, and garlic in olive oil.',
      'tr':
          'Soğan, domates ve sarımsakla zeytinyağında pişirilen sevilen Türk patlıcan yemeği.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'eggplant',
      'onion',
      'tomato',
      'garlic',
      'parsley',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.feelingBalanced,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 220,
      proteinG: 4,
      carbsG: 22,
      fatG: 14,
      fiberG: 8,
    ),
    steps: {
      'en': [
        'Peel eggplants in stripes and fry until softened.',
        'Sauté sliced onions in olive oil for 10 minutes until caramelized.',
        'Add diced tomatoes, garlic, parsley, salt, and pepper to onions.',
        'Slit eggplants and fill with the onion-tomato mixture.',
        'Arrange in a pan, add water, and simmer for 30 minutes. Serve cold or warm.',
      ],
      'tr': [
        'Patlıcanları alacalı soyun ve yumuşayana kadar kızartın.',
        'Dilimlenmiş soğanları zeytinyağında 10 dakika karamelize olana kadar kavurun.',
        'Doğranmış domatesleri, sarımsağı, maydanozu, tuzu ve karabiberi soğanlara ekleyin.',
        'Patlıcanları yarın ve soğan-domates karışımıyla doldurun.',
        'Tepsiye dizin, su ekleyin ve 30 dakika pişirin. Soğuk veya ılık servis edin.',
      ],
    },
  ),

  // ── d014 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd014',
    name: {
      'en': 'Chicken Shawarma Bowl',
      'tr': 'Tavuk Döner Kasesi',
    },
    description: {
      'en':
          'Spiced chicken shawarma served over rice with fresh vegetables and yogurt sauce.',
      'tr':
          'Baharatlı tavuk döner, pilav üzerine taze sebzeler ve yoğurt sosuyla servis edilir.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'chicken_breast',
      'rice',
      'yogurt',
      'lettuce',
      'tomato',
      'cucumber',
      'garlic',
      'olive_oil',
      'lemon',
      'cumin',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.lowEnergy,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 520,
      proteinG: 40,
      carbsG: 48,
      fatG: 16,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Marinate chicken in olive oil, lemon juice, cumin, garlic, salt, and pepper for 30 minutes.',
        'Grill or pan-fry chicken until golden and cooked through, then slice.',
        'Cook rice according to package instructions.',
        'Mix yogurt with minced garlic and a pinch of salt for sauce.',
        'Assemble bowls: rice, sliced chicken, chopped vegetables, and yogurt sauce.',
      ],
      'tr': [
        'Tavuğu zeytinyağı, limon suyu, kimyon, sarımsak, tuz ve karabiberle 30 dakika marine edin.',
        'Tavuğu ızgarada veya tavada altın rengi olana kadar pişirip dilimleyin.',
        'Pirinci paket talimatlarına göre pişirin.',
        'Yoğurdu kıyılmış sarımsak ve bir tutam tuzla karıştırarak sos yapın.',
        'Kaselere pilav, dilimlenmiş tavuk, doğranmış sebzeler ve yoğurt sosu yerleştirin.',
      ],
    },
  ),

  // ── d015 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'd015',
    name: {
      'en': 'Turkish Mantı (Dumplings)',
      'tr': 'Mantı',
    },
    description: {
      'en':
          'Tiny Turkish dumplings filled with spiced meat, topped with yogurt and garlic butter sauce.',
      'tr':
          'Baharatlı kıyma dolgulu minik Türk mantısı, yoğurt ve sarımsaklı tereyağı sosuyla.',
    },
    mealType: MealType.dinner,
    ingredientIds: [
      'ground_beef',
      'onion',
      'yogurt',
      'garlic',
      'salt',
      'black_pepper',
      'cumin',
    ],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 460,
      proteinG: 28,
      carbsG: 42,
      fatG: 20,
      fiberG: 2,
    ),
    steps: {
      'en': [
        'Make dough with flour, eggs, water, and salt. Rest for 30 minutes.',
        'Mix ground beef with grated onion, salt, pepper, and cumin for filling.',
        'Roll dough thin, cut into small squares, and place filling in each.',
        'Pinch corners together to seal the dumplings.',
        'Boil in salted water for 10-12 minutes. Serve with yogurt-garlic sauce and paprika butter.',
      ],
      'tr': [
        'Un, yumurta, su ve tuzla hamur yapın. 30 dakika dinlendirin.',
        'Kıymayı rendelenmiş soğan, tuz, karabiber ve kimyonla karıştırın.',
        'Hamuru ince açın, küçük kareler kesin ve her birine iç harç koyun.',
        'Köşeleri birleştirip kapatın.',
        'Tuzlu suda 10-12 dakika haşlayın. Yoğurt-sarımsak sosu ve biberli tereyağı ile servis edin.',
      ],
    },
  ),
];

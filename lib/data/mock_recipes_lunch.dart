import '../models/recipe.dart';
import '../core/enums.dart';

const List<Recipe> mockLunchRecipes = [
  // ---------------------------------------------------------------
  // l001 – Grilled Chicken Salad
  // ---------------------------------------------------------------
  Recipe(
    id: 'l001',
    name: {
      'en': 'Grilled Chicken Salad',
      'tr': 'Izgara Tavuk Salatası',
    },
    description: {
      'en':
          'A hearty salad with grilled chicken breast, mixed greens, cherry tomatoes, and a lemon vinaigrette.',
      'tr':
          'Izgara tavuk göğsü, karışık yeşillikler, cherry domates ve limon soslu doyurucu bir salata.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'chicken_breast',
      'lettuce',
      'tomato',
      'cucumber',
      'lemon',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.feelingBalanced,
      CheckInType.lowEnergy,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 380,
      proteinG: 42,
      carbsG: 12,
      fatG: 18,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Season the chicken breast with salt, pepper, and a squeeze of lemon juice.',
        'Grill the chicken on medium-high heat for 6-7 minutes per side until cooked through.',
        'Wash and chop the lettuce, tomatoes, and cucumber into bite-sized pieces.',
        'Slice the grilled chicken and place it over the salad.',
        'Drizzle with olive oil and lemon juice, season with salt and pepper, and serve.',
      ],
      'tr': [
        'Tavuk göğsünü tuz, karabiber ve limon suyu ile marine edin.',
        'Tavuğu orta-yüksek ateşte her iki tarafını 6-7 dakika pişirin.',
        'Marul, domates ve salatalığı yıkayıp doğrayın.',
        'Izgara tavuğu dilimleyip salatanın üzerine yerleştirin.',
        'Zeytinyağı ve limon suyu gezdirip tuz ve karabiberle tatlandırarak servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l002 – Mercimek Çorbası (Turkish Red Lentil Soup)
  // ---------------------------------------------------------------
  Recipe(
    id: 'l002',
    name: {
      'en': 'Turkish Red Lentil Soup',
      'tr': 'Mercimek Çorbası',
    },
    description: {
      'en':
          'A classic Turkish red lentil soup seasoned with cumin and served with a squeeze of lemon.',
      'tr':
          'Kimyon ile tatlandırılmış, limon sıkılarak servis edilen klasik Türk mercimek çorbası.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'lentils',
      'onion',
      'carrot',
      'potato',
      'garlic',
      'tomato_paste',
      'cumin',
      'olive_oil',
      'lemon',
      'salt',
      'black_pepper',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.bloated,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 290,
      proteinG: 16,
      carbsG: 42,
      fatG: 6,
      fiberG: 12,
    ),
    steps: {
      'en': [
        'Dice the onion, carrot, and potato. Mince the garlic.',
        'Sauté the onion and garlic in olive oil until softened, then add the carrot and potato.',
        'Add the rinsed lentils, tomato paste, cumin, and enough water to cover. Bring to a boil.',
        'Reduce heat and simmer for 25-30 minutes until lentils are soft.',
        'Blend with an immersion blender until smooth. Season with salt and pepper.',
        'Serve hot with a wedge of lemon on the side.',
      ],
      'tr': [
        'Soğanı, havucu ve patatesi küp küp doğrayın. Sarımsağı ince kıyın.',
        'Soğan ve sarımsağı zeytinyağında kavurun, ardından havuç ve patatesi ekleyin.',
        'Yıkanmış mercimeği, salçayı, kimyonu ve üzerini geçecek kadar su ekleyip kaynatın.',
        'Ateşi kısıp 25-30 dakika mercimekler yumuşayana kadar pişirin.',
        'Blender ile pürüzsüz hale getirin. Tuz ve karabiberle tatlandırın.',
        'Sıcak olarak yanında limon dilimi ile servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l003 – Quinoa & Black Bean Bowl
  // ---------------------------------------------------------------
  Recipe(
    id: 'l003',
    name: {
      'en': 'Quinoa & Black Bean Bowl',
      'tr': 'Kinoa ve Siyah Fasulye Kasesi',
    },
    description: {
      'en':
          'A protein-packed grain bowl with quinoa, black beans, corn, avocado, and a zesty lime dressing.',
      'tr':
          'Kinoa, siyah fasulye, mısır, avokado ve ferahlatıcı limon sosu ile protein dolu bir kase.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'quinoa',
      'black_beans',
      'corn',
      'avocado',
      'tomato',
      'onion',
      'lemon',
      'olive_oil',
      'cumin',
      'salt',
      'black_pepper',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.cravingSweets,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 445,
      proteinG: 18,
      carbsG: 58,
      fatG: 16,
      fiberG: 14,
    ),
    steps: {
      'en': [
        'Cook quinoa according to package instructions and let it cool slightly.',
        'Rinse and drain the black beans. Dice the tomato, onion, and avocado.',
        'Combine quinoa, black beans, corn, tomato, and onion in a large bowl.',
        'Whisk together olive oil, lemon juice, cumin, salt, and pepper for the dressing.',
        'Pour the dressing over the bowl, top with avocado slices, and serve.',
      ],
      'tr': [
        'Kinoayı paket talimatlarına göre pişirin ve biraz soğumaya bırakın.',
        'Siyah fasulyeyi durulayıp süzün. Domates, soğan ve avokadoyu doğrayın.',
        'Kinoa, siyah fasulye, mısır, domates ve soğanı büyük bir kasede karıştırın.',
        'Zeytinyağı, limon suyu, kimyon, tuz ve karabiberi çırparak sos hazırlayın.',
        'Sosu kasenin üzerine dökün, avokado dilimleri ile süsleyip servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l004 – Salmon & Broccoli Rice Bowl
  // ---------------------------------------------------------------
  Recipe(
    id: 'l004',
    name: {
      'en': 'Salmon & Broccoli Rice Bowl',
      'tr': 'Somon ve Brokoli Pilav Kasesi',
    },
    description: {
      'en':
          'Baked salmon served over fluffy rice with steamed broccoli and a soy-sesame glaze.',
      'tr':
          'Fırında somon, pirinç pilavı üzerinde buharda brokoli ve soya-susam sosu ile servis edilir.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'salmon',
      'rice',
      'broccoli',
      'soy_sauce',
      'sesame_oil',
      'garlic',
      'lemon',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['fish', 'soy', 'sesame'],
    checkInTags: [
      CheckInType.cantFocus,
      CheckInType.lowEnergy,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 520,
      proteinG: 38,
      carbsG: 48,
      fatG: 18,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Cook the rice according to package instructions.',
        'Season the salmon fillet with salt, pepper, garlic, and a drizzle of sesame oil.',
        'Bake the salmon at 200°C (400°F) for 12-15 minutes.',
        'Steam the broccoli florets for 4-5 minutes until tender-crisp.',
        'Mix soy sauce and sesame oil to make the glaze.',
        'Serve the salmon over rice with broccoli on the side, drizzled with the glaze.',
      ],
      'tr': [
        'Pirinci paket talimatlarına göre pişirin.',
        'Somon filetosunu tuz, karabiber, sarımsak ve susam yağı ile tatlandırın.',
        'Somonu 200°C fırında 12-15 dakika pişirin.',
        'Brokoli çiçeklerini 4-5 dakika buharda pişirin.',
        'Soya sosu ve susam yağını karıştırarak sos hazırlayın.',
        'Somonu pirinç üzerinde brokoli ile birlikte sosu gezdirerek servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l005 – Turkish Chicken Wrap (Tavuk Dürüm)
  // ---------------------------------------------------------------
  Recipe(
    id: 'l005',
    name: {
      'en': 'Turkish Chicken Wrap',
      'tr': 'Tavuk Dürüm',
    },
    description: {
      'en':
          'Spiced grilled chicken wrapped in a warm tortilla with fresh vegetables and yogurt sauce.',
      'tr':
          'Baharatlı ızgara tavuk, taze sebzeler ve yoğurt sosu ile sıcak lavaşa sarılmış dürüm.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'chicken_breast',
      'tortilla',
      'yogurt',
      'tomato',
      'lettuce',
      'onion',
      'paprika',
      'cumin',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.noSpecificIssue,
      CheckInType.feelingBalanced,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 460,
      proteinG: 36,
      carbsG: 38,
      fatG: 16,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Season chicken breast with paprika, cumin, salt, and pepper, then grill until cooked through.',
        'Slice the grilled chicken into strips.',
        'Warm the tortilla on a dry pan for about 30 seconds per side.',
        'Spread yogurt sauce on the tortilla, add lettuce, tomato, onion, and chicken strips.',
        'Roll the tortilla tightly and serve.',
      ],
      'tr': [
        'Tavuk göğsünü kırmızı biber, kimyon, tuz ve karabiberle marine edip ızgarada pişirin.',
        'Izgara tavuğu şeritler halinde dilimleyin.',
        'Lavaşı kuru tavada her iki tarafını yaklaşık 30 saniye ısıtın.',
        'Lavaşın üzerine yoğurt sosu sürün, marul, domates, soğan ve tavuk şeritlerini ekleyin.',
        'Lavaşı sıkıca sarıp servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l006 – Eggplant Moussaka
  // ---------------------------------------------------------------
  Recipe(
    id: 'l006',
    name: {
      'en': 'Eggplant Moussaka',
      'tr': 'Patlıcan Musakka',
    },
    description: {
      'en':
          'Layers of fried eggplant and seasoned ground beef baked with a tomato sauce topping.',
      'tr':
          'Kızarmış patlıcan ve kıyma katmanları, domates sosu ile fırında pişirilmiş musakka.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'eggplant',
      'ground_beef',
      'tomato',
      'onion',
      'garlic',
      'bell_pepper',
      'tomato_paste',
      'olive_oil',
      'salt',
      'black_pepper',
      'oregano',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.noSpecificIssue,
      CheckInType.bloated,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 420,
      proteinG: 26,
      carbsG: 22,
      fatG: 26,
      fiberG: 7,
    ),
    steps: {
      'en': [
        'Slice the eggplant into rounds, salt them, and let sit for 20 minutes to draw out moisture.',
        'Pan-fry the eggplant slices in olive oil until golden on both sides. Set aside.',
        'Sauté the onion, garlic, and bell pepper, then add the ground beef and cook until browned.',
        'Stir in tomato paste, diced tomatoes, salt, pepper, and oregano. Simmer for 10 minutes.',
        'Layer eggplant and meat sauce in a baking dish. Bake at 180°C (350°F) for 25 minutes.',
        'Let it rest for 5 minutes before serving.',
      ],
      'tr': [
        'Patlıcanları yuvarlak dilimleyip tuzlayın ve 20 dakika suyunu salması için bekletin.',
        'Patlıcan dilimlerini zeytinyağında her iki tarafı altın rengi olana kadar kızartın.',
        'Soğan, sarımsak ve biberi kavurun, ardından kıymayı ekleyip kızarana kadar pişirin.',
        'Salça, doğranmış domates, tuz, karabiber ve kekiği ekleyip 10 dakika kaynatın.',
        'Patlıcan ve kıymalı sosu fırın kabında katlar halinde dizin. 180°C fırında 25 dakika pişirin.',
        'Servis etmeden önce 5 dakika dinlendirin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l007 – Tuna & Avocado Sandwich
  // ---------------------------------------------------------------
  Recipe(
    id: 'l007',
    name: {
      'en': 'Tuna & Avocado Sandwich',
      'tr': 'Ton Balıklı Avokadolu Sandviç',
    },
    description: {
      'en':
          'A light and satisfying sandwich filled with tuna salad, creamy avocado, and crunchy lettuce.',
      'tr':
          'Ton balığı salatası, kremamsı avokado ve çıtır marul ile hazırlanmış hafif ve doyurucu bir sandviç.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'tuna',
      'avocado',
      'bread',
      'lettuce',
      'lemon',
      'onion',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['fish', 'gluten'],
    checkInTags: [
      CheckInType.cantFocus,
      CheckInType.pms,
      CheckInType.cravingSweets,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 410,
      proteinG: 30,
      carbsG: 32,
      fatG: 18,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Drain the tuna and mix it with finely diced onion, lemon juice, olive oil, salt, and pepper.',
        'Mash the avocado with a fork and season lightly with salt and lemon juice.',
        'Toast the bread slices lightly.',
        'Spread the mashed avocado on one slice, add lettuce and the tuna mixture on top.',
        'Close with the second slice, cut in half, and serve.',
      ],
      'tr': [
        'Ton balığının suyunu süzün, ince doğranmış soğan, limon suyu, zeytinyağı, tuz ve karabiberle karıştırın.',
        'Avokadoyu çatalla ezin, hafifçe tuz ve limon suyu ile tatlandırın.',
        'Ekmek dilimlerini hafifçe kızartın.',
        'Bir dilime ezilmiş avokado sürün, üzerine marul ve ton balığı karışımını koyun.',
        'Diğer dilimle kapatıp ikiye kesin ve servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l008 – Bulgur Pilaf with Chickpeas
  // ---------------------------------------------------------------
  Recipe(
    id: 'l008',
    name: {
      'en': 'Bulgur Pilaf with Chickpeas',
      'tr': 'Nohutlu Bulgur Pilavı',
    },
    description: {
      'en':
          'A traditional Turkish bulgur pilaf cooked with chickpeas, tomato paste, and warm spices.',
      'tr':
          'Nohut, salça ve sıcak baharatlarla pişirilmiş geleneksel Türk bulgur pilavı.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'bulgur',
      'chickpeas',
      'onion',
      'tomato_paste',
      'butter',
      'salt',
      'black_pepper',
      'chili_flakes',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.bloated,
      CheckInType.cravingSweets,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 385,
      proteinG: 14,
      carbsG: 62,
      fatG: 10,
      fiberG: 11,
    ),
    steps: {
      'en': [
        'Dice the onion finely and sauté in butter until translucent.',
        'Add tomato paste and chili flakes, stir for 1 minute.',
        'Add the drained chickpeas and stir to coat.',
        'Add bulgur and hot water (1:1.5 ratio). Season with salt and pepper.',
        'Cover and cook on low heat for 12-15 minutes until the water is absorbed.',
        'Fluff with a fork, let rest for 5 minutes, and serve.',
      ],
      'tr': [
        'Soğanı ince doğrayıp tereyağında pembeleşene kadar kavurun.',
        'Salça ve pul biberi ekleyip 1 dakika karıştırın.',
        'Süzülmüş nohutları ekleyip karıştırın.',
        'Bulguru ve sıcak suyu (1:1.5 oranında) ekleyin. Tuz ve karabiberle tatlandırın.',
        'Kapağını kapatıp kısık ateşte 12-15 dakika su çekilene kadar pişirin.',
        'Çatalla kabartın, 5 dakika dinlendirin ve servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l009 – Shrimp Stir-Fry with Rice Noodles
  // ---------------------------------------------------------------
  Recipe(
    id: 'l009',
    name: {
      'en': 'Shrimp Stir-Fry with Rice Noodles',
      'tr': 'Karidesli Pirinç Noodle Sote',
    },
    description: {
      'en':
          'Quick and flavorful shrimp stir-fry with rice noodles, vegetables, and a savory soy-sesame sauce.',
      'tr':
          'Pirinç noodle, sebzeler ve soya-susam sosu ile hızlı ve lezzetli karides sote.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'shrimp',
      'rice_noodles',
      'bell_pepper',
      'carrot',
      'zucchini',
      'garlic',
      'soy_sauce',
      'sesame_oil',
      'vegetable_oil',
      'salt',
    ],
    allergenTags: ['shellfish', 'soy', 'sesame'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.pms,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 430,
      proteinG: 28,
      carbsG: 50,
      fatG: 12,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Cook rice noodles according to package instructions, drain and set aside.',
        'Heat vegetable oil in a wok or large pan over high heat.',
        'Add the shrimp and cook for 2 minutes per side until pink. Remove and set aside.',
        'Stir-fry sliced bell pepper, carrot, and zucchini with garlic for 3-4 minutes.',
        'Return the shrimp, add the noodles, soy sauce, and sesame oil. Toss to combine.',
        'Serve immediately while hot.',
      ],
      'tr': [
        'Pirinç noodle\'ları paket talimatlarına göre pişirip süzün.',
        'Wok veya büyük tavada bitkisel yağı yüksek ateşte ısıtın.',
        'Karidesleri ekleyip her tarafını 2 dakika pembeleşene kadar pişirin. Ayırın.',
        'Dilimlenmiş biber, havuç ve kabağı sarımsakla 3-4 dakika soteleyin.',
        'Karidesleri geri ekleyin, noodle, soya sosu ve susam yağını ilave edip karıştırın.',
        'Sıcak olarak hemen servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l010 – Karnıyarık (Turkish Stuffed Eggplant)
  // ---------------------------------------------------------------
  Recipe(
    id: 'l010',
    name: {
      'en': 'Turkish Stuffed Eggplant',
      'tr': 'Karnıyarık',
    },
    description: {
      'en':
          'Fried eggplant halves stuffed with a savory ground beef, tomato, and pepper filling, baked until tender.',
      'tr':
          'Kızartılmış patlıcanların içine kıymalı, domatesli ve biberli harç doldurularak fırında pişirilmiş karnıyarık.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'eggplant',
      'ground_beef',
      'onion',
      'garlic',
      'tomato',
      'bell_pepper',
      'tomato_paste',
      'olive_oil',
      'salt',
      'black_pepper',
      'parsley',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.noSpecificIssue,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 450,
      proteinG: 28,
      carbsG: 18,
      fatG: 30,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Peel the eggplants in stripes and deep fry or pan-fry until softened. Place in a baking dish.',
        'Sauté diced onion and garlic in olive oil until golden.',
        'Add the ground beef and cook until browned. Stir in diced pepper, tomato paste, salt, and pepper.',
        'Make a slit along each eggplant and stuff with the meat mixture. Top with tomato slices.',
        'Bake at 180°C (350°F) for 20-25 minutes until everything is tender and heated through.',
      ],
      'tr': [
        'Patlıcanları alacalı soyup kızartın veya tavada yumuşayana kadar pişirin. Fırın kabına dizin.',
        'Doğranmış soğan ve sarımsağı zeytinyağında altın rengi olana kadar kavurun.',
        'Kıymayı ekleyip kızarana kadar pişirin. Doğranmış biber, salça, tuz ve karabiberi ekleyin.',
        'Her patlıcanın ortasını yarıp kıymalı harçla doldurun. Üzerine domates dilimleri koyun.',
        '180°C fırında 20-25 dakika her şey yumuşayana kadar pişirin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l011 – Mediterranean Chickpea Salad
  // ---------------------------------------------------------------
  Recipe(
    id: 'l011',
    name: {
      'en': 'Mediterranean Chickpea Salad',
      'tr': 'Akdeniz Nohut Salatası',
    },
    description: {
      'en':
          'A refreshing salad with chickpeas, cucumber, tomato, feta cheese, olives, and a lemon-herb dressing.',
      'tr':
          'Nohut, salatalık, domates, beyaz peynir ve limonlu ot sosu ile ferahlatıcı bir Akdeniz salatası.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'chickpeas',
      'cucumber',
      'tomato',
      'feta_cheese',
      'onion',
      'lemon',
      'olive_oil',
      'oregano',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.feelingBalanced,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 350,
      proteinG: 16,
      carbsG: 38,
      fatG: 16,
      fiberG: 10,
    ),
    steps: {
      'en': [
        'Drain and rinse the chickpeas.',
        'Dice the cucumber, tomato, and onion. Crumble the feta cheese.',
        'Combine all vegetables and chickpeas in a large bowl.',
        'Whisk together olive oil, lemon juice, oregano, salt, and pepper.',
        'Pour the dressing over the salad, toss gently, and serve.',
      ],
      'tr': [
        'Nohutları süzüp durulayın.',
        'Salatalık, domates ve soğanı doğrayın. Beyaz peyniri ufalayın.',
        'Tüm sebzeleri ve nohutları büyük bir kasede birleştirin.',
        'Zeytinyağı, limon suyu, kekik, tuz ve karabiberi çırparak sos hazırlayın.',
        'Sosu salatanın üzerine dökün, hafifçe karıştırın ve servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l012 – Beef Steak with Sweet Potato
  // ---------------------------------------------------------------
  Recipe(
    id: 'l012',
    name: {
      'en': 'Beef Steak with Sweet Potato',
      'tr': 'Biftek ve Tatlı Patates',
    },
    description: {
      'en':
          'Pan-seared beef steak served alongside roasted sweet potato wedges and a side of green beans.',
      'tr':
          'Tavada pişirilmiş biftek, fırında tatlı patates dilimleri ve yanında yeşil fasulye ile servis edilir.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'beef_steak',
      'sweet_potato',
      'green_beans',
      'olive_oil',
      'garlic',
      'salt',
      'black_pepper',
      'butter',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.lowEnergy,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 550,
      proteinG: 40,
      carbsG: 38,
      fatG: 24,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Cut the sweet potato into wedges, toss with olive oil, salt, and pepper. Roast at 200°C (400°F) for 25 minutes.',
        'Season the beef steak with salt, pepper, and garlic.',
        'Heat a skillet to high, add a knob of butter, and sear the steak 3-4 minutes per side for medium.',
        'Blanch the green beans in salted boiling water for 3 minutes, then toss with olive oil.',
        'Let the steak rest for 5 minutes before slicing. Serve with sweet potato and green beans.',
      ],
      'tr': [
        'Tatlı patatesi dilimleyip zeytinyağı, tuz ve karabiberle harmanlayın. 200°C fırında 25 dakika pişirin.',
        'Bifteği tuz, karabiber ve sarımsakla tatlandırın.',
        'Tavayı yüksek ateşte ısıtın, tereyağı ekleyin ve bifteği her tarafını 3-4 dakika kızartın.',
        'Yeşil fasulyeleri kaynar tuzlu suda 3 dakika haşlayıp zeytinyağı ile karıştırın.',
        'Bifteği 5 dakika dinlendirdikten sonra dilimleyin. Tatlı patates ve fasulye ile servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l013 – Spinach & Feta Börek
  // ---------------------------------------------------------------
  Recipe(
    id: 'l013',
    name: {
      'en': 'Spinach & Feta Börek',
      'tr': 'Ispanaklı Börek',
    },
    description: {
      'en':
          'Flaky Turkish pastry layers filled with a savory spinach and feta cheese mixture.',
      'tr':
          'Ispanak ve beyaz peynir karışımı ile hazırlanmış geleneksel kat kat Türk böreği.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'flour',
      'spinach',
      'feta_cheese',
      'eggs',
      'onion',
      'butter',
      'olive_oil',
      'yogurt',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['gluten', 'dairy', 'eggs'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.noSpecificIssue,
      CheckInType.bloated,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 390,
      proteinG: 18,
      carbsG: 34,
      fatG: 20,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Wash and chop the spinach. Sauté with diced onion until wilted. Let cool.',
        'Mix the cooled spinach with crumbled feta cheese, one egg, salt, and pepper.',
        'Lay out a sheet of dough, brush with a mixture of melted butter, olive oil, and yogurt.',
        'Spread the spinach filling along one edge and roll tightly. Repeat with remaining dough.',
        'Arrange rolls in a greased baking tray, brush tops with egg wash.',
        'Bake at 180°C (350°F) for 30-35 minutes until golden brown.',
      ],
      'tr': [
        'Ispanağı yıkayıp doğrayın. Doğranmış soğanla birlikte suyunu salıp kavurun. Soğutun.',
        'Soğumuş ıspanağı ufalanmış beyaz peynir, bir yumurta, tuz ve karabiberle karıştırın.',
        'Yufkayı serin, eritilmiş tereyağı, zeytinyağı ve yoğurt karışımı ile fırçalayın.',
        'Ispanak harcını bir kenara yayıp sıkıca sarın. Kalan yufkalarla tekrarlayın.',
        'Yağlanmış fırın tepsisine dizin, üzerini yumurta ile fırçalayın.',
        '180°C fırında 30-35 dakika altın rengi olana kadar pişirin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l014 – Tofu & Vegetable Stir-Fry
  // ---------------------------------------------------------------
  Recipe(
    id: 'l014',
    name: {
      'en': 'Tofu & Vegetable Stir-Fry',
      'tr': 'Tofu ve Sebze Sote',
    },
    description: {
      'en':
          'Crispy pan-fried tofu with colorful stir-fried vegetables in a soy-garlic sauce, served over rice.',
      'tr':
          'Soya-sarımsak sosunda renkli sebzelerle sotelenmiş çıtır tofu, pirinç üzerinde servis edilir.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'tofu',
      'rice',
      'broccoli',
      'bell_pepper',
      'carrot',
      'mushroom',
      'soy_sauce',
      'garlic',
      'sesame_oil',
      'vegetable_oil',
      'salt',
    ],
    allergenTags: ['soy', 'sesame'],
    checkInTags: [
      CheckInType.feelingBalanced,
      CheckInType.pms,
      CheckInType.cravingSweets,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 400,
      proteinG: 20,
      carbsG: 48,
      fatG: 14,
      fiberG: 8,
    ),
    steps: {
      'en': [
        'Press the tofu to remove excess moisture, then cut into cubes.',
        'Pan-fry the tofu in vegetable oil until golden and crispy on all sides. Set aside.',
        'Cook rice according to package instructions.',
        'Stir-fry sliced broccoli, bell pepper, carrot, and mushroom with garlic for 4-5 minutes.',
        'Add the tofu back, pour in soy sauce and sesame oil, toss to coat.',
        'Serve the stir-fry over the cooked rice.',
      ],
      'tr': [
        'Tofunun fazla suyunu süzün ve küpler halinde kesin.',
        'Tofuyu bitkisel yağda her tarafı altın rengi ve çıtır olana kadar kızartın. Ayırın.',
        'Pirinci paket talimatlarına göre pişirin.',
        'Dilimlenmiş brokoli, biber, havuç ve mantarı sarımsakla 4-5 dakika soteleyin.',
        'Tofuyu geri ekleyin, soya sosu ve susam yağını döküp karıştırın.',
        'Soteyi pişmiş pirinç üzerinde servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l015 – Turkish Lamb Stew (Kuzu Haşlama)
  // ---------------------------------------------------------------
  Recipe(
    id: 'l015',
    name: {
      'en': 'Turkish Lamb Stew',
      'tr': 'Kuzu Haşlama',
    },
    description: {
      'en':
          'A slow-cooked Turkish lamb stew with potatoes, carrots, and aromatic herbs.',
      'tr':
          'Patates, havuç ve aromatik otlarla yavaş pişirilmiş geleneksel kuzu haşlama.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'lamb',
      'potato',
      'carrot',
      'onion',
      'garlic',
      'tomato',
      'tomato_paste',
      'butter',
      'salt',
      'black_pepper',
      'oregano',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.postWorkout,
      CheckInType.bloated,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 510,
      proteinG: 34,
      carbsG: 32,
      fatG: 26,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Cut the lamb into chunks. Sear in butter over high heat until browned on all sides.',
        'Add diced onion and garlic, cook until softened.',
        'Stir in tomato paste, diced tomatoes, and enough water to cover the meat.',
        'Bring to a boil, then reduce heat and simmer for 1 hour.',
        'Add cubed potatoes and carrots. Season with salt, pepper, and oregano.',
        'Continue to simmer for another 30 minutes until vegetables are tender. Serve hot.',
      ],
      'tr': [
        'Kuzuyu parçalara ayırın. Tereyağında yüksek ateşte her tarafını kızartın.',
        'Doğranmış soğan ve sarımsağı ekleyip yumuşayana kadar pişirin.',
        'Salça, doğranmış domates ve eti geçecek kadar su ekleyin.',
        'Kaynatın, ardından ateşi kısıp 1 saat pişirin.',
        'Küp doğranmış patates ve havucu ekleyin. Tuz, karabiber ve kekikle tatlandırın.',
        '30 dakika daha sebzeler yumuşayana kadar pişirip sıcak servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l016 – Couscous with Grilled Vegetables
  // ---------------------------------------------------------------
  Recipe(
    id: 'l016',
    name: {
      'en': 'Couscous with Grilled Vegetables',
      'tr': 'Izgara Sebzeli Kuskus',
    },
    description: {
      'en':
          'Fluffy couscous served with a medley of grilled zucchini, bell pepper, and eggplant.',
      'tr':
          'Izgara kabak, biber ve patlıcan eşliğinde kabarık kuskus.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'couscous',
      'zucchini',
      'bell_pepper',
      'eggplant',
      'tomato',
      'olive_oil',
      'lemon',
      'garlic',
      'cumin',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['gluten'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 360,
      proteinG: 10,
      carbsG: 56,
      fatG: 12,
      fiberG: 8,
    ),
    steps: {
      'en': [
        'Slice zucchini, bell pepper, and eggplant. Toss with olive oil, garlic, salt, and pepper.',
        'Grill the vegetables on a grill pan or under the broiler for 3-4 minutes per side.',
        'Prepare the couscous by pouring boiling water over it (1:1 ratio), cover and let sit for 5 minutes.',
        'Fluff the couscous with a fork, add cumin, lemon juice, and a drizzle of olive oil.',
        'Plate the couscous topped with grilled vegetables and serve.',
      ],
      'tr': [
        'Kabak, biber ve patlıcanı dilimleyip zeytinyağı, sarımsak, tuz ve karabiberle harmanlayın.',
        'Sebzeleri ızgara tavada veya fırının üst ızgarasında her tarafını 3-4 dakika pişirin.',
        'Kuskusun üzerine kaynar su dökün (1:1 oranında), kapatıp 5 dakika bekletin.',
        'Kuskusu çatalla kabartın, kimyon, limon suyu ve zeytinyağı ekleyin.',
        'Kuskusu tabağa alıp üzerine ızgara sebzeleri yerleştirerek servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l017 – Turkey & Mushroom Pasta
  // ---------------------------------------------------------------
  Recipe(
    id: 'l017',
    name: {
      'en': 'Turkey & Mushroom Pasta',
      'tr': 'Hindili Mantarlı Makarna',
    },
    description: {
      'en':
          'Penne pasta tossed with sautéed ground turkey, mushrooms, and a light cream sauce.',
      'tr':
          'Sotelenmiş hindi kıyma, mantar ve hafif kremalı sos ile hazırlanmış penne makarna.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'ground_turkey',
      'pasta',
      'mushroom',
      'onion',
      'garlic',
      'cream',
      'parmesan',
      'olive_oil',
      'salt',
      'black_pepper',
      'oregano',
    ],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.lowEnergy,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 520,
      proteinG: 32,
      carbsG: 52,
      fatG: 20,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Cook the pasta in salted boiling water until al dente. Reserve a cup of pasta water, then drain.',
        'Sauté diced onion and garlic in olive oil, then add the ground turkey and cook until browned.',
        'Add sliced mushrooms and cook for 3-4 minutes until softened.',
        'Pour in the cream, season with salt, pepper, and oregano. Simmer for 2 minutes.',
        'Toss the pasta into the sauce, adding pasta water as needed for consistency.',
        'Serve topped with grated Parmesan.',
      ],
      'tr': [
        'Makarnayı tuzlu kaynar suda al dente pişirin. Bir fincan makarna suyunu ayırıp süzün.',
        'Soğan ve sarımsağı zeytinyağında kavurun, hindi kıymayı ekleyip kızarana kadar pişirin.',
        'Dilimlenmiş mantarları ekleyip 3-4 dakika yumuşayana kadar pişirin.',
        'Kremayı ekleyin, tuz, karabiber ve kekikle tatlandırın. 2 dakika kaynatın.',
        'Makarnayı sosun içine atıp kıvam için makarna suyu ekleyin.',
        'Rendelenmiş parmesan ile süsleyerek servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l018 – Kale & Walnut Salad
  // ---------------------------------------------------------------
  Recipe(
    id: 'l018',
    name: {
      'en': 'Kale & Walnut Salad',
      'tr': 'Karalahana ve Cevizli Salata',
    },
    description: {
      'en':
          'Massaged kale tossed with toasted walnuts, pomegranate seeds, and a tangy lemon dressing.',
      'tr':
          'Ovulmuş karalahana, kavrulmuş ceviz, nar taneleri ve ekşi limon sosu ile hazırlanmış salata.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'kale',
      'walnuts',
      'pomegranate',
      'lemon',
      'olive_oil',
      'garlic',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['tree_nuts'],
    checkInTags: [
      CheckInType.pms,
      CheckInType.bloated,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 280,
      proteinG: 8,
      carbsG: 22,
      fatG: 20,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Wash the kale, remove the tough stems, and tear into bite-sized pieces.',
        'Massage the kale with a drizzle of olive oil and a pinch of salt for 2 minutes until softened.',
        'Toast the walnuts in a dry pan over medium heat for 3-4 minutes.',
        'Whisk together lemon juice, olive oil, minced garlic, salt, and pepper for the dressing.',
        'Toss the kale with walnuts, pomegranate seeds, and dressing. Serve immediately.',
      ],
      'tr': [
        'Karalahana yapraklarını yıkayın, sert saplarını çıkarın ve parçalayın.',
        'Zeytinyağı ve bir tutam tuzla 2 dakika ovarak yumuşatın.',
        'Cevizleri kuru tavada orta ateşte 3-4 dakika kavurun.',
        'Limon suyu, zeytinyağı, kıyılmış sarımsak, tuz ve karabiberi çırparak sos hazırlayın.',
        'Karalahana, ceviz, nar taneleri ve sosu karıştırıp hemen servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l019 – Grilled Pork Chop with Potato Salad
  // ---------------------------------------------------------------
  Recipe(
    id: 'l019',
    name: {
      'en': 'Grilled Pork Chop with Potato Salad',
      'tr': 'Izgara Domuz Pirzola ve Patates Salatası',
    },
    description: {
      'en':
          'Juicy grilled pork chop accompanied by a classic potato salad with mustard dressing.',
      'tr':
          'Sulu ızgara domuz pirzola, hardallı sos ile klasik patates salatası eşliğinde.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'pork_chop',
      'potato',
      'onion',
      'mustard',
      'vinegar',
      'olive_oil',
      'salt',
      'black_pepper',
      'paprika',
    ],
    allergenTags: ['mustard'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.cantFocus,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 530,
      proteinG: 38,
      carbsG: 34,
      fatG: 26,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Season the pork chop with salt, pepper, and paprika. Let it sit for 15 minutes.',
        'Grill the pork chop on medium-high heat for 5-6 minutes per side until cooked through.',
        'Boil cubed potatoes in salted water until fork-tender, about 15 minutes. Drain and cool slightly.',
        'Mix the potatoes with finely diced onion, mustard, vinegar, olive oil, salt, and pepper.',
        'Serve the grilled pork chop alongside the potato salad.',
      ],
      'tr': [
        'Domuz pirzolanın tuz, karabiber ve kırmızı biberle marine edip 15 dakika bekletin.',
        'Pirzolanın her tarafını orta-yüksek ateşte 5-6 dakika ızgara edin.',
        'Küp doğranmış patatesleri tuzlu suda çatalla dağılana kadar yaklaşık 15 dakika haşlayın. Süzüp biraz soğutun.',
        'Patatesleri ince doğranmış soğan, hardal, sirke, zeytinyağı, tuz ve karabiberle karıştırın.',
        'Izgara pirzolanın yanında patates salatası ile servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l020 – Egg & Vegetable Frittata
  // ---------------------------------------------------------------
  Recipe(
    id: 'l020',
    name: {
      'en': 'Egg & Vegetable Frittata',
      'tr': 'Sebzeli Frittata',
    },
    description: {
      'en':
          'A fluffy baked frittata loaded with spinach, bell peppers, mushrooms, and cheddar cheese.',
      'tr':
          'Ispanak, biber, mantar ve kaşar peyniri ile hazırlanmış kabarık fırında frittata.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'eggs',
      'spinach',
      'bell_pepper',
      'mushroom',
      'cheddar_cheese',
      'onion',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['eggs', 'dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.feelingBalanced,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 340,
      proteinG: 24,
      carbsG: 10,
      fatG: 24,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Preheat the oven to 180°C (350°F).',
        'Sauté diced onion, bell pepper, and mushrooms in an oven-safe skillet with olive oil.',
        'Add the spinach and cook until just wilted.',
        'Beat the eggs with salt, pepper, and half the cheddar cheese. Pour over the vegetables.',
        'Sprinkle the remaining cheddar on top and bake for 18-20 minutes until set and golden.',
        'Let cool for a few minutes, slice, and serve.',
      ],
      'tr': [
        'Fırını 180°C\'ye ön ısıtma yapın.',
        'Fırına dayanıklı tavada soğan, biber ve mantarı zeytinyağında kavurun.',
        'Ispanağı ekleyip hafifçe soldurulana kadar pişirin.',
        'Yumurtaları tuz, karabiber ve kaşar peynirinin yarısı ile çırpın. Sebzelerin üzerine dökün.',
        'Kalan kaşar peynirini üzerine serpin ve 18-20 dakika pişene kadar fırınlayın.',
        'Birkaç dakika soğutun, dilimleyin ve servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l021 – Sardine & White Bean Salad
  // ---------------------------------------------------------------
  Recipe(
    id: 'l021',
    name: {
      'en': 'Sardine & White Bean Salad',
      'tr': 'Sardalya ve Kuru Fasulye Salatası',
    },
    description: {
      'en':
          'A Mediterranean-inspired salad combining sardines, white beans, celery, and a bright lemon dressing.',
      'tr':
          'Sardalya, kuru fasulye, kereviz ve limon sosu ile Akdeniz esintili bir salata.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'sardines',
      'white_beans',
      'celery',
      'onion',
      'lemon',
      'olive_oil',
      'salt',
      'black_pepper',
      'chili_flakes',
    ],
    allergenTags: ['fish'],
    checkInTags: [
      CheckInType.pms,
      CheckInType.cantFocus,
      CheckInType.lowEnergy,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 370,
      proteinG: 26,
      carbsG: 30,
      fatG: 16,
      fiberG: 9,
    ),
    steps: {
      'en': [
        'Drain and rinse the white beans.',
        'Thinly slice the celery and onion.',
        'Combine beans, celery, and onion in a bowl. Gently fold in the sardines.',
        'Whisk together lemon juice, olive oil, chili flakes, salt, and pepper.',
        'Pour the dressing over the salad, toss gently, and serve.',
      ],
      'tr': [
        'Kuru fasulyeleri süzüp durulayın.',
        'Kereviz ve soğanı ince dilimleyin.',
        'Fasulye, kereviz ve soğanı bir kasede birleştirin. Sardalyaları nazikçe ekleyin.',
        'Limon suyu, zeytinyağı, pul biber, tuz ve karabiberi çırparak sos hazırlayın.',
        'Sosu salatanın üzerine dökün, hafifçe karıştırın ve servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l022 – Chicken Thigh & Vegetable Kebab
  // ---------------------------------------------------------------
  Recipe(
    id: 'l022',
    name: {
      'en': 'Chicken Thigh & Vegetable Kebab',
      'tr': 'Tavuk But Sebze Kebabı',
    },
    description: {
      'en':
          'Marinated chicken thigh pieces and colorful vegetables threaded on skewers and grilled to perfection.',
      'tr':
          'Marine edilmiş tavuk but parçaları ve renkli sebzeler şişe dizilip mükemmel şekilde ızgara edilmiş kebap.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'chicken_thigh',
      'bell_pepper',
      'onion',
      'zucchini',
      'tomato',
      'yogurt',
      'olive_oil',
      'paprika',
      'cumin',
      'garlic',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.noSpecificIssue,
      CheckInType.bloated,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 420,
      proteinG: 34,
      carbsG: 14,
      fatG: 26,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Cut chicken thighs into chunks. Marinate in yogurt, olive oil, paprika, cumin, garlic, salt, and pepper for at least 30 minutes.',
        'Cut bell pepper, onion, zucchini, and tomato into similar-sized pieces.',
        'Thread the marinated chicken and vegetables alternately onto skewers.',
        'Grill the skewers on medium-high heat for 12-15 minutes, turning occasionally.',
        'Serve hot with a side of rice or bread.',
      ],
      'tr': [
        'Tavuk butlarını parçalara ayırın. Yoğurt, zeytinyağı, kırmızı biber, kimyon, sarımsak, tuz ve karabiberle en az 30 dakika marine edin.',
        'Biber, soğan, kabak ve domatesi benzer boyutlarda doğrayın.',
        'Marine edilmiş tavuk ve sebzeleri sırayla şişlere dizin.',
        'Şişleri orta-yüksek ateşte ara sıra çevirerek 12-15 dakika ızgarada pişirin.',
        'Yanında pilav veya ekmek ile sıcak servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l023 – Lentil & Vegetable Stew
  // ---------------------------------------------------------------
  Recipe(
    id: 'l023',
    name: {
      'en': 'Lentil & Vegetable Stew',
      'tr': 'Mercimekli Sebze Yahnisi',
    },
    description: {
      'en':
          'A comforting stew of green lentils, carrots, celery, and spinach in a tomato broth.',
      'tr':
          'Yeşil mercimek, havuç, kereviz ve ıspanak ile domates sulu doyurucu bir yahni.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'lentils',
      'carrot',
      'celery',
      'spinach',
      'onion',
      'garlic',
      'tomato_paste',
      'olive_oil',
      'cumin',
      'salt',
      'black_pepper',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cravingSweets,
      CheckInType.lowEnergy,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 310,
      proteinG: 18,
      carbsG: 46,
      fatG: 6,
      fiberG: 14,
    ),
    steps: {
      'en': [
        'Dice the onion, carrot, and celery. Mince the garlic.',
        'Heat olive oil in a pot and sauté the onion, carrot, and celery until softened.',
        'Add garlic and tomato paste, stir for 1 minute.',
        'Add rinsed lentils, cumin, and enough water to cover. Bring to a boil, then simmer for 25 minutes.',
        'Stir in the spinach during the last 5 minutes of cooking. Season with salt and pepper.',
        'Serve hot in deep bowls.',
      ],
      'tr': [
        'Soğan, havuç ve kerevizi doğrayın. Sarımsağı ince kıyın.',
        'Tencerede zeytinyağını ısıtıp soğan, havuç ve kerevizi yumuşayana kadar kavurun.',
        'Sarımsak ve salçayı ekleyip 1 dakika karıştırın.',
        'Yıkanmış mercimek, kimyon ve üzerini geçecek kadar su ekleyin. Kaynatıp 25 dakika pişirin.',
        'Son 5 dakikada ıspanağı ekleyin. Tuz ve karabiberle tatlandırın.',
        'Sıcak olarak derin kaselerde servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l024 – Cod Fish Tacos
  // ---------------------------------------------------------------
  Recipe(
    id: 'l024',
    name: {
      'en': 'Cod Fish Tacos',
      'tr': 'Morina Balıklı Taco',
    },
    description: {
      'en':
          'Lightly seasoned baked cod served in warm tortillas with cabbage slaw and a creamy avocado sauce.',
      'tr':
          'Hafif baharatlarla fırında pişirilmiş morina, sıcak tortilla içinde lahana salatası ve kremamsı avokado sosu ile.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'cod',
      'tortilla',
      'cabbage',
      'avocado',
      'lemon',
      'yogurt',
      'garlic',
      'paprika',
      'cumin',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['fish', 'gluten', 'dairy'],
    checkInTags: [
      CheckInType.feelingBalanced,
      CheckInType.postWorkout,
      CheckInType.noSpecificIssue,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 400,
      proteinG: 32,
      carbsG: 36,
      fatG: 14,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Season the cod with paprika, cumin, salt, pepper, and a drizzle of olive oil. Bake at 200°C (400°F) for 12 minutes.',
        'Shred the cabbage finely and toss with lemon juice and a pinch of salt.',
        'Mash the avocado with yogurt, garlic, lemon juice, salt, and pepper to make the sauce.',
        'Warm the tortillas on a dry pan for 30 seconds per side.',
        'Flake the baked cod and assemble tacos with cabbage slaw and avocado sauce.',
      ],
      'tr': [
        'Morinayı kırmızı biber, kimyon, tuz, karabiber ve zeytinyağı ile tatlandırın. 200°C fırında 12 dakika pişirin.',
        'Lahanayı ince ince rendeleyin, limon suyu ve bir tutam tuzla karıştırın.',
        'Avokadoyu yoğurt, sarımsak, limon suyu, tuz ve karabiberle ezip sos hazırlayın.',
        'Tortillaları kuru tavada her tarafını 30 saniye ısıtın.',
        'Pişmiş morinayı parçalayıp lahana salatası ve avokado sosu ile tacoları hazırlayın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------
  // l025 – Kidney Bean & Rice Bowl (Kuru Fasulye)
  // ---------------------------------------------------------------
  Recipe(
    id: 'l025',
    name: {
      'en': 'Turkish Kidney Bean Stew with Rice',
      'tr': 'Kuru Fasulye Pilav',
    },
    description: {
      'en':
          'A beloved Turkish comfort meal of kidney beans in a rich tomato sauce served over white rice.',
      'tr':
          'Zengin domates sosunda pişirilmiş kuru fasulye, beyaz pirinç pilavı üzerinde servis edilen sevilen Türk yemeği.',
    },
    mealType: MealType.lunch,
    ingredientIds: [
      'kidney_beans',
      'rice',
      'onion',
      'garlic',
      'tomato_paste',
      'tomato',
      'bell_pepper',
      'butter',
      'olive_oil',
      'paprika',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.lowEnergy,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 460,
      proteinG: 18,
      carbsG: 72,
      fatG: 10,
      fiberG: 14,
    ),
    steps: {
      'en': [
        'If using dried beans, soak overnight and boil until tender. Drain.',
        'Sauté diced onion and garlic in olive oil and butter until golden.',
        'Add tomato paste and diced bell pepper, stir for 2 minutes.',
        'Add the cooked beans, diced tomatoes, paprika, salt, pepper, and enough water to cover. Simmer for 30 minutes.',
        'Meanwhile, cook the rice with butter using the absorption method.',
        'Serve the bean stew ladled over fluffy white rice.',
      ],
      'tr': [
        'Kuru fasulye kullanıyorsanız bir gece ıslatıp yumuşayana kadar haşlayın. Süzün.',
        'Doğranmış soğan ve sarımsağı zeytinyağı ve tereyağında altın rengi olana kadar kavurun.',
        'Salça ve doğranmış biberi ekleyip 2 dakika karıştırın.',
        'Haşlanmış fasulye, doğranmış domates, kırmızı biber, tuz, karabiber ve üzerini geçecek kadar su ekleyip 30 dakika pişirin.',
        'Bu sırada tereyağlı pirinç pilavını pişirin.',
        'Fasulye yemeğini pilavın üzerine dökerek servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),
];

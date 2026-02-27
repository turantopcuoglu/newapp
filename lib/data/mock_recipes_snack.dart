import '../models/recipe.dart';
import '../core/enums.dart';

const List<Recipe> mockSnackRecipes = [
  // ---------------------------------------------------------------------------
  // s001 – Banana Almond Energy Balls
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's001',
    name: {
      'en': 'Banana Almond Energy Balls',
      'tr': 'Muzlu Bademli Enerji Topları',
    },
    description: {
      'en':
          'No-bake energy balls made with oats, banana, and almonds for a quick nutrient-dense snack.',
      'tr':
          'Yulaf, muz ve bademle hazırlanan, pişirme gerektirmeyen besleyici enerji topları.',
    },
    mealType: MealType.snack,
    ingredientIds: ['oats', 'banana', 'almonds', 'honey', 'cinnamon'],
    allergenTags: ['gluten', 'tree_nuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 195,
      proteinG: 6,
      carbsG: 28,
      fatG: 8,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Mash the banana in a bowl and mix in oats, chopped almonds, honey, and cinnamon.',
        'Roll the mixture into small balls and place on a lined tray.',
        'Refrigerate for at least 30 minutes until firm.',
      ],
      'tr': [
        'Muzu bir kasede ezin; yulaf, kıyılmış badem, bal ve tarçını ekleyip karıştırın.',
        'Karışımdan küçük toplar yapın ve pişirme kağıdı serili tepsiye dizin.',
        'En az 30 dakika buzdolabında sertleşene kadar bekletin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s002 – Spinach Banana Smoothie
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's002',
    name: {
      'en': 'Spinach Banana Smoothie',
      'tr': 'Ispanaklı Muzlu Smoothie',
    },
    description: {
      'en':
          'A creamy green smoothie packed with spinach, banana, and yogurt for sustained energy.',
      'tr':
          'Ispanak, muz ve yoğurtla hazırlanan kremamsı yeşil smoothie ile enerjinizi koruyun.',
    },
    mealType: MealType.snack,
    ingredientIds: ['spinach', 'banana', 'yogurt', 'honey', 'milk'],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 185,
      proteinG: 9,
      carbsG: 30,
      fatG: 4,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Add spinach, banana, yogurt, milk, and honey to a blender.',
        'Blend until smooth and creamy.',
        'Pour into a glass and serve immediately.',
      ],
      'tr': [
        'Ispanak, muz, yoğurt, süt ve balı blender\'a ekleyin.',
        'Pürüzsüz ve kremamsı olana kadar karıştırın.',
        'Bardağa dökün ve hemen servis yapın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s003 – Mixed Berry Chia Pudding
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's003',
    name: {
      'en': 'Mixed Berry Chia Pudding',
      'tr': 'Karışık Meyveli Chia Puding',
    },
    description: {
      'en':
          'Chia seeds soaked in milk and topped with fresh strawberries and blueberries for a fiber-rich treat.',
      'tr':
          'Sütte bekletilmiş chia tohumları, taze çilek ve yaban mersini ile lif açısından zengin bir atıştırmalık.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'chia_seeds',
      'milk',
      'strawberry',
      'blueberry',
      'honey',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 210,
      proteinG: 7,
      carbsG: 26,
      fatG: 9,
      fiberG: 8,
    ),
    steps: {
      'en': [
        'Mix chia seeds with milk and honey in a jar; stir well.',
        'Refrigerate overnight or for at least 4 hours.',
        'Top with sliced strawberries and blueberries before serving.',
      ],
      'tr': [
        'Chia tohumlarını süt ve bal ile bir kavanozda karıştırın.',
        'Buzdolabında bir gece veya en az 4 saat bekletin.',
        'Servis öncesi dilimlenmiş çilek ve yaban mersini ekleyin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s004 – Classic Hummus with Veggie Sticks
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's004',
    name: {
      'en': 'Classic Hummus with Veggie Sticks',
      'tr': 'Sebze Çubuklu Klasik Humus',
    },
    description: {
      'en':
          'Smooth chickpea hummus served with crunchy carrot, cucumber, and bell pepper sticks.',
      'tr':
          'Havuç, salatalık ve biber çubuklarıyla servis edilen pürüzsüz nohut humusu.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'chickpeas',
      'tahini',
      'lemon',
      'garlic',
      'olive_oil',
      'carrot',
      'cucumber',
      'bell_pepper',
    ],
    allergenTags: ['sesame'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 220,
      proteinG: 9,
      carbsG: 24,
      fatG: 11,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Blend chickpeas, tahini, lemon juice, garlic, and olive oil until smooth.',
        'Season with salt and adjust consistency with a splash of water if needed.',
        'Cut carrots, cucumber, and bell pepper into sticks and serve alongside the hummus.',
      ],
      'tr': [
        'Nohut, tahin, limon suyu, sarımsak ve zeytinyağını pürüzsüz olana kadar karıştırın.',
        'Tuz ekleyin; gerekirse bir miktar su ile kıvamını ayarlayın.',
        'Havuç, salatalık ve biberi çubuklar halinde kesin ve humusla birlikte servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s005 – Apple Slices with Peanut Butter
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's005',
    name: {
      'en': 'Apple Slices with Peanut Butter',
      'tr': 'Fıstık Ezmeli Elma Dilimleri',
    },
    description: {
      'en':
          'Crisp apple slices paired with creamy peanut butter for a satisfying sweet-and-savory snack.',
      'tr':
          'Tatlı ve tuzlu dengesinde, kremamsı fıstık ezmesiyle eşleştirilmiş çıtır elma dilimleri.',
    },
    mealType: MealType.snack,
    ingredientIds: ['apple', 'peanuts', 'cinnamon'],
    allergenTags: ['peanuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 200,
      proteinG: 6,
      carbsG: 25,
      fatG: 10,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Core the apple and cut into thin slices.',
        'Spread or drizzle peanut butter over each slice.',
        'Sprinkle with a pinch of cinnamon and serve.',
      ],
      'tr': [
        'Elmanın çekirdeğini çıkarın ve ince dilimler halinde kesin.',
        'Her dilimin üzerine fıstık ezmesi sürün.',
        'Bir tutam tarçın serpin ve servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s006 – Cucumber Feta Bites
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's006',
    name: {
      'en': 'Cucumber Feta Bites',
      'tr': 'Beyaz Peynirli Salatalık Dilimleri',
    },
    description: {
      'en':
          'Refreshing cucumber rounds topped with crumbled feta, olive oil, and a hint of oregano.',
      'tr':
          'Ufalanmış beyaz peynir, zeytinyağı ve bir tutam kekik ile taze salatalık dilimleri.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'cucumber',
      'feta_cheese',
      'olive_oil',
      'oregano',
      'black_pepper',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 120,
      proteinG: 6,
      carbsG: 5,
      fatG: 9,
      fiberG: 1,
    ),
    steps: {
      'en': [
        'Slice cucumber into thick rounds.',
        'Top each round with crumbled feta cheese.',
        'Drizzle with olive oil, sprinkle oregano and black pepper, then serve.',
      ],
      'tr': [
        'Salatalığı kalın yuvarlak dilimler halinde kesin.',
        'Her dilimin üzerine ufalanmış beyaz peynir koyun.',
        'Zeytinyağı gezdirin, kekik ve karabiber serpin, servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s007 – Oat and Walnut Protein Bars (No-Bake)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's007',
    name: {
      'en': 'Oat and Walnut Protein Bars',
      'tr': 'Yulaflı Cevizli Protein Bar',
    },
    description: {
      'en':
          'No-bake protein bars made with oats, walnuts, honey, and peanut butter for sustained fuel.',
      'tr':
          'Yulaf, ceviz, bal ve fıstık ezmesiyle hazırlanan pişirme gerektirmeyen protein barları.',
    },
    mealType: MealType.snack,
    ingredientIds: ['oats', 'walnuts', 'peanuts', 'honey', 'vanilla_extract'],
    allergenTags: ['gluten', 'tree_nuts', 'peanuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 260,
      proteinG: 10,
      carbsG: 30,
      fatG: 12,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Mix oats, chopped walnuts, peanut butter, honey, and vanilla extract in a bowl.',
        'Press the mixture firmly into a lined baking pan.',
        'Refrigerate for at least 2 hours, then cut into bars.',
      ],
      'tr': [
        'Yulaf, kıyılmış ceviz, fıstık ezmesi, bal ve vanilya özütünü bir kasede karıştırın.',
        'Karışımı pişirme kağıdı serili bir kalıba sıkıca bastırın.',
        'En az 2 saat buzdolabında bekletin, ardından bar şeklinde kesin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s008 – Yogurt with Honey and Walnuts
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's008',
    name: {
      'en': 'Yogurt with Honey and Walnuts',
      'tr': 'Ballı Cevizli Yoğurt',
    },
    description: {
      'en':
          'Creamy yogurt drizzled with honey and topped with crunchy walnuts for a balanced snack.',
      'tr':
          'Bal ve çıtır cevizle zenginleştirilmiş kremamsı yoğurt atıştırmalığı.',
    },
    mealType: MealType.snack,
    ingredientIds: ['yogurt', 'honey', 'walnuts'],
    allergenTags: ['dairy', 'tree_nuts'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 190,
      proteinG: 8,
      carbsG: 22,
      fatG: 9,
      fiberG: 1,
    ),
    steps: {
      'en': [
        'Spoon yogurt into a bowl.',
        'Drizzle honey over the yogurt and top with walnut pieces.',
      ],
      'tr': [
        'Yoğurdu bir kaseye alın.',
        'Üzerine bal gezdirin ve ceviz parçaları ekleyin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s009 – Mango Coconut Smoothie
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's009',
    name: {
      'en': 'Mango Coconut Smoothie',
      'tr': 'Mangolu Hindistancevizli Smoothie',
    },
    description: {
      'en':
          'A tropical smoothie blending mango, coconut, and yogurt for a refreshing pick-me-up.',
      'tr':
          'Mango, hindistancevizi ve yoğurdun harmanlandığı tropikal bir smoothie.',
    },
    mealType: MealType.snack,
    ingredientIds: ['mango', 'coconut', 'yogurt', 'honey'],
    allergenTags: ['dairy', 'tree_nuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 215,
      proteinG: 5,
      carbsG: 36,
      fatG: 7,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Add mango chunks, shredded coconut, yogurt, and honey to a blender.',
        'Blend until smooth.',
        'Pour into a glass and serve chilled.',
      ],
      'tr': [
        'Mango parçaları, rendelenmiş hindistancevizi, yoğurt ve balı blender\'a ekleyin.',
        'Pürüzsüz olana kadar karıştırın.',
        'Bardağa dökün ve soğuk servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s010 – Trail Mix with Almonds and Dark Chocolate
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's010',
    name: {
      'en': 'Trail Mix with Almonds and Dark Chocolate',
      'tr': 'Bademli ve Bitter Çikolatalı Karışık Kuruyemiş',
    },
    description: {
      'en':
          'A balanced trail mix of almonds, walnuts, pumpkin seeds, and dark chocolate chips.',
      'tr':
          'Badem, ceviz, kabak çekirdeği ve bitter çikolata parçalarından oluşan dengeli bir kuruyemiş karışımı.',
    },
    mealType: MealType.snack,
    ingredientIds: ['almonds', 'walnuts', 'cocoa_powder', 'honey'],
    allergenTags: ['tree_nuts'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 250,
      proteinG: 8,
      carbsG: 18,
      fatG: 18,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Measure equal portions of almonds, walnuts, and cocoa nibs into a bowl.',
        'Add a light drizzle of honey and toss to combine.',
        'Divide into snack-sized portions and store in airtight containers.',
      ],
      'tr': [
        'Eşit miktarda badem, ceviz ve kakao parçalarını bir kaseye koyun.',
        'Hafifçe bal gezdirip karıştırın.',
        'Atıştırmalık porsiyonlara ayırın ve hava almayan kaplarda saklayın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s011 – Oat Banana Pancake Bites
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's011',
    name: {
      'en': 'Oat Banana Pancake Bites',
      'tr': 'Yulaflı Muzlu Mini Pankekler',
    },
    description: {
      'en':
          'Mini pancakes made with mashed banana, oats, and egg for a wholesome, naturally sweet snack.',
      'tr':
          'Ezilmiş muz, yulaf ve yumurtayla yapılan doğal tatlılıkta mini pankekler.',
    },
    mealType: MealType.snack,
    ingredientIds: ['oats', 'banana', 'eggs', 'cinnamon', 'coconut_oil'],
    allergenTags: ['gluten', 'eggs'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 175,
      proteinG: 7,
      carbsG: 24,
      fatG: 6,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Mash banana and mix with oats, egg, and cinnamon until a thick batter forms.',
        'Heat coconut oil in a pan over medium heat.',
        'Drop small spoonfuls of batter into the pan and cook until golden on each side.',
      ],
      'tr': [
        'Muzu ezin; yulaf, yumurta ve tarçınla koyu bir hamur elde edene kadar karıştırın.',
        'Hindistancevizi yağını orta ateşte bir tavada ısıtın.',
        'Hamurdan küçük kaşıklar dökün ve her iki tarafı altın rengi olana kadar pişirin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s012 – Egg and Avocado Toast Bites
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's012',
    name: {
      'en': 'Egg and Avocado Toast Bites',
      'tr': 'Yumurtalı Avokadolu Tost Lokmaları',
    },
    description: {
      'en':
          'Bite-sized toasts topped with mashed avocado and sliced boiled egg for a protein-packed snack.',
      'tr':
          'Ezilmiş avokado ve dilimlenmiş haşlanmış yumurta ile protein açısından zengin tost lokmaları.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'bread',
      'avocado',
      'eggs',
      'lemon',
      'salt',
      'black_pepper',
      'chili_flakes',
    ],
    allergenTags: ['gluten', 'eggs'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.postWorkout,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 230,
      proteinG: 11,
      carbsG: 18,
      fatG: 14,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Toast bread slices and cut into bite-sized squares.',
        'Mash avocado with lemon juice, salt, and black pepper.',
        'Spread avocado mixture on each toast square and top with boiled egg slices.',
        'Finish with a sprinkle of chili flakes.',
      ],
      'tr': [
        'Ekmek dilimlerini kızartın ve lokma büyüklüğünde kareler halinde kesin.',
        'Avokadoyu limon suyu, tuz ve karabiberle ezin.',
        'Her tost karesine avokado karışımını sürün ve üzerine haşlanmış yumurta dilimleri koyun.',
        'Pul biber serperek servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s013 – Chocolate Peanut Butter Energy Balls
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's013',
    name: {
      'en': 'Chocolate Peanut Butter Energy Balls',
      'tr': 'Çikolatalı Fıstık Ezmeli Enerji Topları',
    },
    description: {
      'en':
          'Rich no-bake energy balls combining cocoa, peanut butter, oats, and honey.',
      'tr':
          'Kakao, fıstık ezmesi, yulaf ve bal ile hazırlanan pişirme gerektirmeyen enerji topları.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'cocoa_powder',
      'peanuts',
      'oats',
      'honey',
      'flaxseeds',
    ],
    allergenTags: ['gluten', 'peanuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 230,
      proteinG: 9,
      carbsG: 26,
      fatG: 11,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Mix oats, cocoa powder, peanut butter, honey, and ground flaxseeds in a bowl.',
        'Stir until fully combined, then roll into small balls.',
        'Refrigerate for at least 30 minutes before serving.',
      ],
      'tr': [
        'Yulaf, kakao tozu, fıstık ezmesi, bal ve öğütülmüş keten tohumunu bir kasede karıştırın.',
        'Tamamen birleşene kadar karıştırın, ardından küçük toplar yapın.',
        'Servis öncesi en az 30 dakika buzdolabında bekletin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s014 – Kale and Cashew Pesto Dip with Veggies
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's014',
    name: {
      'en': 'Kale Cashew Pesto Dip',
      'tr': 'Karalahanalı Kaju Pesto Dip',
    },
    description: {
      'en':
          'A vibrant dip made with kale, cashews, garlic, and olive oil, served with fresh vegetables.',
      'tr':
          'Karalahana, kaju, sarımsak ve zeytinyağından yapılan canlı bir dip; taze sebzelerle servis edilir.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'kale',
      'cashews',
      'garlic',
      'olive_oil',
      'lemon',
      'carrot',
      'bell_pepper',
    ],
    allergenTags: ['tree_nuts'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 195,
      proteinG: 6,
      carbsG: 14,
      fatG: 14,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Blend kale, cashews, garlic, olive oil, and lemon juice until smooth.',
        'Season with salt and pepper to taste.',
        'Serve with carrot sticks and bell pepper strips.',
      ],
      'tr': [
        'Karalahana, kaju, sarımsak, zeytinyağı ve limon suyunu pürüzsüz olana kadar karıştırın.',
        'Tuz ve karabiberle tatlandırın.',
        'Havuç çubukları ve biber şeritleri ile servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s015 – Strawberry Yogurt Parfait
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's015',
    name: {
      'en': 'Strawberry Yogurt Parfait',
      'tr': 'Çilekli Yoğurt Parfesi',
    },
    description: {
      'en':
          'Layers of yogurt, fresh strawberries, and oats for a light and satisfying parfait.',
      'tr':
          'Yoğurt, taze çilek ve yulaf katmanlarından oluşan hafif ve doyurucu bir parfe.',
    },
    mealType: MealType.snack,
    ingredientIds: ['yogurt', 'strawberry', 'oats', 'honey'],
    allergenTags: ['dairy', 'gluten'],
    checkInTags: [
      CheckInType.pms,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 180,
      proteinG: 8,
      carbsG: 28,
      fatG: 5,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Layer yogurt at the bottom of a glass or jar.',
        'Add a layer of sliced strawberries followed by a layer of oats.',
        'Repeat layers and drizzle honey on top before serving.',
      ],
      'tr': [
        'Bir bardak veya kavanozun altına yoğurt koyun.',
        'Dilimlenmiş çilek katmanı ve ardından yulaf katmanı ekleyin.',
        'Katmanları tekrarlayın ve servis öncesi üzerine bal gezdirin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s016 – Sweet Potato Bites with Tahini
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's016',
    name: {
      'en': 'Sweet Potato Bites with Tahini',
      'tr': 'Tahinli Tatlı Patates Dilimleri',
    },
    description: {
      'en':
          'Roasted sweet potato rounds drizzled with tahini and a sprinkle of sesame seeds.',
      'tr':
          'Fırınlanmış tatlı patates dilimleri, tahin ve susam ile servis edilir.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'sweet_potato',
      'tahini',
      'olive_oil',
      'salt',
      'cumin',
    ],
    allergenTags: ['sesame'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 200,
      proteinG: 4,
      carbsG: 30,
      fatG: 8,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Slice sweet potato into rounds and toss with olive oil, salt, and cumin.',
        'Roast at 200\u00b0C for 20-25 minutes until golden and tender.',
        'Drizzle with tahini and serve warm.',
      ],
      'tr': [
        'Tatlı patatesi yuvarlak dilimler halinde kesin; zeytinyağı, tuz ve kimyonla karıştırın.',
        'Altın rengi ve yumuşak olana kadar 200\u00b0C fırında 20-25 dakika pişirin.',
        'Üzerine tahin gezdirip sıcak servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s017 – Blueberry Flax Smoothie
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's017',
    name: {
      'en': 'Blueberry Flax Smoothie',
      'tr': 'Yaban Mersinli Keten Tohumlu Smoothie',
    },
    description: {
      'en':
          'An antioxidant-rich smoothie with blueberries, flaxseeds, banana, and milk.',
      'tr':
          'Yaban mersini, keten tohumu, muz ve sütle hazırlanan antioksidan açısından zengin smoothie.',
    },
    mealType: MealType.snack,
    ingredientIds: ['blueberry', 'flaxseeds', 'banana', 'milk'],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 175,
      proteinG: 5,
      carbsG: 30,
      fatG: 5,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Add blueberries, banana, ground flaxseeds, and milk to a blender.',
        'Blend until smooth and creamy.',
        'Pour into a glass and serve immediately.',
      ],
      'tr': [
        'Yaban mersini, muz, öğütülmüş keten tohumu ve sütü blender\'a ekleyin.',
        'Pürüzsüz ve kremamsı olana kadar karıştırın.',
        'Bardağa dökün ve hemen servis yapın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s018 – Lentil and Tomato Bruschetta
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's018',
    name: {
      'en': 'Lentil Tomato Bruschetta',
      'tr': 'Mercimekli Domatesli Bruschetta',
    },
    description: {
      'en':
          'Toasted bread topped with seasoned lentils and fresh diced tomatoes for a fiber-rich snack.',
      'tr':
          'Baharatlı mercimek ve taze doğranmış domatesle kaplı kızarmış ekmek dilimleri.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'bread',
      'lentils',
      'tomato',
      'onion',
      'olive_oil',
      'basil',
      'garlic',
    ],
    allergenTags: ['gluten'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 210,
      proteinG: 9,
      carbsG: 30,
      fatG: 6,
      fiberG: 7,
    ),
    steps: {
      'en': [
        'Cook lentils until tender and drain excess water.',
        'Mix lentils with diced tomato, minced onion, garlic, olive oil, and basil.',
        'Toast bread slices and spoon the lentil-tomato mixture on top.',
        'Serve at room temperature.',
      ],
      'tr': [
        'Mercimekleri yumuşayana kadar pişirin ve fazla suyu süzün.',
        'Mercimekleri doğranmış domates, kıyılmış soğan, sarımsak, zeytinyağı ve fesleğenle karıştırın.',
        'Ekmek dilimlerini kızartın ve üzerine mercimek-domates karışımını koyun.',
        'Oda sıcaklığında servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s019 – Pomegranate and Orange Fruit Bowl
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's019',
    name: {
      'en': 'Pomegranate Orange Fruit Bowl',
      'tr': 'Narlı Portakallı Meyve Kasesi',
    },
    description: {
      'en':
          'A vibrant fruit bowl with pomegranate seeds, orange segments, and a drizzle of honey.',
      'tr':
          'Nar taneleri, portakal dilimleri ve bal ile hazırlanan canlı bir meyve kasesi.',
    },
    mealType: MealType.snack,
    ingredientIds: ['pomegranate', 'orange', 'honey', 'cinnamon'],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 140,
      proteinG: 2,
      carbsG: 34,
      fatG: 1,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Peel the orange and separate into segments; place in a bowl.',
        'Scatter pomegranate seeds over the orange segments.',
        'Drizzle with honey and a pinch of cinnamon before serving.',
      ],
      'tr': [
        'Portakalı soyun ve dilimlerine ayırın; bir kaseye koyun.',
        'Portakal dilimlerinin üzerine nar tanelerini serpin.',
        'Servis öncesi bal gezdirin ve bir tutam tarçın ekleyin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s020 – Spiced Chickpea Crunch
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's020',
    name: {
      'en': 'Spiced Chickpea Crunch',
      'tr': 'Baharatlı Çıtır Nohut',
    },
    description: {
      'en':
          'Oven-roasted chickpeas seasoned with cumin and paprika for a crunchy, protein-packed snack.',
      'tr':
          'Kimyon ve kırmızı biberle tatlandırılmış, fırında kavrulmuş çıtır nohut atıştırmalığı.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'chickpeas',
      'olive_oil',
      'cumin',
      'paprika',
      'salt',
      'garlic',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 180,
      proteinG: 9,
      carbsG: 22,
      fatG: 7,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Drain and pat dry canned chickpeas thoroughly.',
        'Toss with olive oil, cumin, paprika, garlic powder, and salt.',
        'Spread on a baking tray and roast at 200\u00b0C for 25-30 minutes until crispy.',
        'Let cool before serving for extra crunch.',
      ],
      'tr': [
        'Konserve nohutları süzün ve iyice kurulayın.',
        'Zeytinyağı, kimyon, kırmızı biber, sarımsak tozu ve tuzla karıştırın.',
        'Fırın tepsisine yayın ve 200\u00b0C\'de 25-30 dakika çıtır olana kadar pişirin.',
        'Ekstra çıtırlık için servis öncesi soğumaya bırakın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s021 – Avocado and Almond Dip
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's021',
    name: {
      'en': 'Avocado Almond Dip',
      'tr': 'Avokadolu Bademli Dip',
    },
    description: {
      'en':
          'A creamy dip blending ripe avocado with almonds, lemon, and garlic, perfect with veggie sticks.',
      'tr':
          'Olgun avokado, badem, limon ve sarımsakla hazırlanan kremamsı dip; sebze çubuklarıyla mükemmel.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'avocado',
      'almonds',
      'lemon',
      'garlic',
      'olive_oil',
      'salt',
      'celery',
      'cucumber',
    ],
    allergenTags: ['tree_nuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.pms,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 235,
      proteinG: 6,
      carbsG: 12,
      fatG: 20,
      fiberG: 7,
    ),
    steps: {
      'en': [
        'Blend avocado, almonds, lemon juice, garlic, and olive oil until smooth.',
        'Season with salt and adjust thickness with water if needed.',
        'Serve with celery and cucumber sticks.',
      ],
      'tr': [
        'Avokado, badem, limon suyu, sarımsak ve zeytinyağını pürüzsüz olana kadar karıştırın.',
        'Tuz ekleyin; gerekirse su ile kıvamını ayarlayın.',
        'Kereviz ve salatalık çubuklarıyla servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s022 – Tuna Cucumber Rolls
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's022',
    name: {
      'en': 'Tuna Cucumber Rolls',
      'tr': 'Ton Balıklı Salatalık Ruloları',
    },
    description: {
      'en':
          'Light cucumber rolls filled with seasoned tuna, lemon, and a touch of mustard.',
      'tr':
          'Baharatlı ton balığı, limon ve bir tutam hardalla doldurulan hafif salatalık ruloları.',
    },
    mealType: MealType.snack,
    ingredientIds: [
      'tuna',
      'cucumber',
      'lemon',
      'mustard',
      'black_pepper',
      'salt',
    ],
    allergenTags: ['fish', 'mustard'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 130,
      proteinG: 18,
      carbsG: 4,
      fatG: 5,
      fiberG: 1,
    ),
    steps: {
      'en': [
        'Mix tuna with lemon juice, mustard, salt, and black pepper.',
        'Slice cucumber lengthwise into thin strips using a peeler.',
        'Place a spoonful of tuna mixture on each cucumber strip and roll tightly.',
      ],
      'tr': [
        'Ton balığını limon suyu, hardal, tuz ve karabiberle karıştırın.',
        'Salatalığı soyucu ile uzunlamasına ince şeritler halinde dilimleyin.',
        'Her salatalık şeridine bir kaşık ton balığı karışımı koyun ve sıkıca sarın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s023 – Cinnamon Baked Apple Chips
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's023',
    name: {
      'en': 'Cinnamon Baked Apple Chips',
      'tr': 'Tarçınlı Fırın Elma Cipsleri',
    },
    description: {
      'en':
          'Thin apple slices baked until crispy with a dusting of cinnamon for a guilt-free chip alternative.',
      'tr':
          'Tarçın serpilmiş ince elma dilimleri, çıtır olana kadar fırınlanmış sağlıklı cips alternatifi.',
    },
    mealType: MealType.snack,
    ingredientIds: ['apple', 'cinnamon', 'lemon'],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.pms,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 105,
      proteinG: 1,
      carbsG: 26,
      fatG: 0,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Thinly slice apples and toss with lemon juice to prevent browning.',
        'Arrange slices in a single layer on a baking tray and dust with cinnamon.',
        'Bake at 110\u00b0C for 1.5-2 hours until crispy, flipping halfway.',
      ],
      'tr': [
        'Elmaları ince dilimleyin ve kararmaması için limon suyuyla karıştırın.',
        'Dilimleri fırın tepsisine tek sıra halinde dizin ve tarçın serpin.',
        '110\u00b0C\'de 1,5-2 saat çıtır olana kadar pişirin; yarısında çevirin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s024 – Edamame with Sea Salt and Lemon
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's024',
    name: {
      'en': 'Edamame with Sea Salt and Lemon',
      'tr': 'Limonlu Tuzlu Soya Fasulyesi',
    },
    description: {
      'en':
          'Steamed edamame (young soybeans) finished with sea salt and a squeeze of fresh lemon.',
      'tr':
          'Buharda pişirilmiş soya fasulyesi, deniz tuzu ve taze limon sıkılarak servis edilir.',
    },
    mealType: MealType.snack,
    ingredientIds: ['soy_sauce', 'lemon', 'salt', 'black_pepper'],
    allergenTags: ['soy'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.postWorkout,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 150,
      proteinG: 13,
      carbsG: 11,
      fatG: 6,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Steam edamame pods for 4-5 minutes until tender.',
        'Toss with a squeeze of lemon juice and a sprinkle of sea salt.',
        'Serve warm or at room temperature.',
      ],
      'tr': [
        'Soya fasulyesi kabuklarını 4-5 dakika buharda yumuşayana kadar pişirin.',
        'Limon suyu sıkın ve deniz tuzu serpin.',
        'Sıcak veya oda sıcaklığında servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s025 – Cashew Date Bliss Balls
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's025',
    name: {
      'en': 'Cashew Date Bliss Balls',
      'tr': 'Kajulu Hurmalı Mutluluk Topları',
    },
    description: {
      'en':
          'Naturally sweet bliss balls made from cashews, dates, coconut, and a hint of vanilla.',
      'tr':
          'Kaju, hurma, hindistancevizi ve vanilya ile doğal tatlılıkta mutluluk topları.',
    },
    mealType: MealType.snack,
    ingredientIds: ['cashews', 'coconut', 'honey', 'vanilla_extract'],
    allergenTags: ['tree_nuts'],
    checkInTags: [
      CheckInType.cantFocus,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 220,
      proteinG: 5,
      carbsG: 28,
      fatG: 11,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Blend cashews and pitted dates in a food processor until a sticky dough forms.',
        'Add shredded coconut and vanilla extract; pulse to combine.',
        'Roll into small balls and coat with extra shredded coconut.',
        'Refrigerate for 20 minutes before serving.',
      ],
      'tr': [
        'Kaju ve çekirdeksiz hurmaları mutfak robotunda yapışkan bir hamur oluşana kadar karıştırın.',
        'Rendelenmiş hindistancevizi ve vanilya özütü ekleyin; kısa süreli karıştırın.',
        'Küçük toplar şeklinde yuvarlayın ve hindistancevizi ile kaplayın.',
        'Servis öncesi 20 dakika buzdolabında bekletin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s026 – Trail Mix with Nuts and Dried Fruits (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's026',
    name: {
      'en': 'Trail Mix with Nuts and Dried Fruits',
      'tr': 'Kuruyemişli Karışım',
    },
    description: {
      'en':
          'A crunchy and chewy mix of mixed nuts, dried fruit, and dark chocolate chips — perfect grab-and-go junk-food-style snack.',
      'tr':
          'Karışık kuruyemiş, kuru meyve ve bitter çikolata parçalarından oluşan çıtır ve lezzetli bir abur cubur karışımı.',
    },
    mealType: MealType.snack,
    ingredientIds: ['mixed_nuts', 'dried_fruit', 'dark_chocolate', 'coconut_milk'],
    allergenTags: ['tree_nuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cantFocus,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 280,
      proteinG: 7,
      carbsG: 24,
      fatG: 18,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Combine mixed nuts, dried fruit, and dark chocolate chips in a large bowl.',
        'Toss everything together until evenly distributed.',
        'Divide into snack-sized portions and store in airtight bags or containers.',
      ],
      'tr': [
        'Karışık kuruyemiş, kuru meyve ve bitter çikolata parçalarını büyük bir kasede birleştirin.',
        'Her şeyi eşit dağılana kadar karıştırın.',
        'Atıştırmalık porsiyonlara ayırın ve hava almayan poşet veya kaplarda saklayın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s027 – Ice Cream Sundae (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's027',
    name: {
      'en': 'Ice Cream Sundae',
      'tr': 'Dondurmalı Kase',
    },
    description: {
      'en':
          'A classic junk food treat — scoops of ice cream topped with chocolate, banana slices, and crushed cookies.',
      'tr':
          'Klasik bir abur cubur keyfi — çikolata sosu, muz dilimleri ve ufalanmış kurabiye ile süslenmiş dondurma kasesi.',
    },
    mealType: MealType.snack,
    ingredientIds: ['ice_cream', 'chocolate_bar', 'banana', 'cookies'],
    allergenTags: ['dairy', 'gluten', 'eggs'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 420,
      proteinG: 6,
      carbsG: 58,
      fatG: 19,
      fiberG: 2,
    ),
    steps: {
      'en': [
        'Place two scoops of ice cream in a bowl.',
        'Melt chocolate and drizzle it over the ice cream.',
        'Add banana slices on the side and crush cookies over the top.',
        'Serve immediately before melting.',
      ],
      'tr': [
        'Bir kaseye iki top dondurma koyun.',
        'Çikolatayı eritin ve dondurmanın üzerine gezdirin.',
        'Kenarlara muz dilimleri ekleyin ve üzerine ufalanmış kurabiye serpin.',
        'Erimeden hemen servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s028 – Chips and Salsa (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's028',
    name: {
      'en': 'Chips and Salsa',
      'tr': 'Cips ve Sos',
    },
    description: {
      'en':
          'Tortilla chips served with a quick homemade tomato salsa — the ultimate casual junk food snack.',
      'tr':
          'Ev yapımı domates sosu ile servis edilen tortilla cipsleri — en klasik abur cubur atıştırmalığı.',
    },
    mealType: MealType.snack,
    ingredientIds: ['tortilla_chips', 'potato_chips', 'crackers'],
    allergenTags: ['gluten'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 320,
      proteinG: 4,
      carbsG: 42,
      fatG: 16,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Arrange tortilla chips on a large serving plate.',
        'Dice tomatoes, onion, and cilantro; mix with lime juice and salt to make salsa.',
        'Pour the salsa into a small bowl and place in the center of the plate.',
        'Dip and enjoy!',
      ],
      'tr': [
        'Tortilla cipslerini büyük bir servis tabağına dizin.',
        'Domates, soğan ve maydanozu doğrayın; limon suyu ve tuzla karıştırarak salsa yapın.',
        'Salsayı küçük bir kaseye koyun ve tabağın ortasına yerleştirin.',
        'Banarak keyfini çıkarın!',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s029 – Chocolate Fondue with Fruit (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's029',
    name: {
      'en': 'Chocolate Fondue with Fruit',
      'tr': 'Çikolata Fondüsü',
    },
    description: {
      'en':
          'Melted dark chocolate served as a dipping fondue with fresh banana slices, strawberries, and dried fruit.',
      'tr':
          'Taze muz dilimleri, çilek ve kuru meyve ile servis edilen eritilmiş bitter çikolata fondüsü.',
    },
    mealType: MealType.snack,
    ingredientIds: ['dark_chocolate', 'banana', 'blueberry', 'raspberry', 'dried_fruit'],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.periodCramps,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 350,
      proteinG: 4,
      carbsG: 48,
      fatG: 17,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Break dark chocolate into pieces and melt in a heatproof bowl over simmering water.',
        'Slice banana and wash berries; arrange on a plate alongside dried fruit.',
        'Pour melted chocolate into a fondue pot or small bowl.',
        'Dip fruit pieces into the warm chocolate and enjoy.',
      ],
      'tr': [
        'Bitter çikolatayı parçalayın ve hafif kaynayan suyun üzerinde ısıya dayanıklı kasede eritin.',
        'Muzu dilimleyin ve meyveleri yıkayın; kuru meyve ile birlikte bir tabağa dizin.',
        'Eritilmiş çikolatayı fondü kabına veya küçük bir kaseye dökün.',
        'Meyve parçalarını sıcak çikolataya batırarak keyfini çıkarın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s030 – Popcorn Party Mix (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's030',
    name: {
      'en': 'Popcorn Party Mix',
      'tr': 'Baharatlı Patlamış Mısır',
    },
    description: {
      'en':
          'Freshly popped popcorn tossed with mixed nuts and a sweet-savory seasoning for a fun party snack.',
      'tr':
          'Taze patlamış mısır, karışık kuruyemiş ve tatlı-tuzlu baharatlarla harmanlanmış eğlenceli parti atıştırmalığı.',
    },
    mealType: MealType.snack,
    ingredientIds: ['popcorn', 'mixed_nuts', 'honey', 'crackers'],
    allergenTags: ['tree_nuts', 'gluten'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 260,
      proteinG: 5,
      carbsG: 34,
      fatG: 13,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Pop popcorn kernels in a large pot with a little oil over medium-high heat.',
        'In a small saucepan, warm honey with a pinch of salt and a dash of paprika.',
        'Toss the popcorn with mixed nuts and crushed crackers in a large bowl.',
        'Drizzle the honey mixture over everything and toss until evenly coated.',
      ],
      'tr': [
        'Mısır patlatma tanelerini büyük bir tencerede az yağ ile orta-yüksek ateşte patlatın.',
        'Küçük bir tavada balı bir tutam tuz ve biraz kırmızı biberle ısıtın.',
        'Patlamış mısırı karışık kuruyemiş ve ufalanmış krakerlerle büyük bir kasede karıştırın.',
        'Bal karışımını her şeyin üzerine gezdirin ve eşit kaplanana kadar karıştırın.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s031 – Greek Yogurt Parfait with Berries (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's031',
    name: {
      'en': 'Greek Yogurt Parfait with Berries',
      'tr': 'Meyveli Yoğurt Parfesi',
    },
    description: {
      'en':
          'Thick Greek yogurt layered with fresh blueberries, raspberries, granola, and a drizzle of honey.',
      'tr':
          'Taze yaban mersini, ahududu, granola ve bal ile katman katman hazırlanan koyu Yunan yoğurdu parfesi.',
    },
    mealType: MealType.snack,
    ingredientIds: ['greek_yogurt', 'blueberry', 'raspberry', 'granola_bar', 'honey'],
    allergenTags: ['dairy', 'gluten'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.postWorkout,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 220,
      proteinG: 14,
      carbsG: 30,
      fatG: 6,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Spoon a thick layer of Greek yogurt into the bottom of a glass or jar.',
        'Add a layer of fresh blueberries and raspberries.',
        'Crumble granola bar pieces over the berries.',
        'Repeat layers and finish with a drizzle of honey on top.',
      ],
      'tr': [
        'Bir bardak veya kavanozun altına kalın bir katman Yunan yoğurdu koyun.',
        'Üzerine taze yaban mersini ve ahududu katmanı ekleyin.',
        'Meyvelerin üzerine ufalanmış granola bar parçaları serpin.',
        'Katmanları tekrarlayın ve üzerine bal gezdirerek servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s032 – Peanut Butter Rice Cakes (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's032',
    name: {
      'en': 'Peanut Butter Rice Cakes',
      'tr': 'Fıstık Ezmeli Pirinç Patlağı',
    },
    description: {
      'en':
          'Light rice cakes spread with peanut butter, topped with banana slices and a drizzle of honey — a quick junk-food-style fix.',
      'tr':
          'Fıstık ezmesi sürülmüş pirinç patlağı, muz dilimleri ve bal ile — hızlı bir abur cubur alternatifi.',
    },
    mealType: MealType.snack,
    ingredientIds: ['rice_cake', 'peanut_butter', 'banana', 'honey'],
    allergenTags: ['peanuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 245,
      proteinG: 8,
      carbsG: 32,
      fatG: 11,
      fiberG: 2,
    ),
    steps: {
      'en': [
        'Spread a generous layer of peanut butter on each rice cake.',
        'Top with thin banana slices arranged in a single layer.',
        'Drizzle honey over the top and serve immediately.',
      ],
      'tr': [
        'Her pirinç patlağının üzerine bol miktarda fıstık ezmesi sürün.',
        'Üzerine ince muz dilimlerini tek sıra halinde dizin.',
        'Bal gezdirin ve hemen servis edin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),

  // ---------------------------------------------------------------------------
  // s033 – Date and Nut Energy Bites (Abur cubur / Junk Food)
  // ---------------------------------------------------------------------------
  Recipe(
    id: 's033',
    name: {
      'en': 'Date and Nut Energy Bites',
      'tr': 'Hurmalı Enerji Topları',
    },
    description: {
      'en':
          'Chewy no-bake energy bites made from dates, mixed nuts, oats, and a touch of dark chocolate — naturally sweet junk food.',
      'tr':
          'Hurma, karışık kuruyemiş, yulaf ve bitter çikolata ile hazırlanan pişirme gerektirmeyen doğal tatlılıkta enerji topları.',
    },
    mealType: MealType.snack,
    ingredientIds: ['dates', 'mixed_nuts', 'oats', 'dark_chocolate', 'honey'],
    allergenTags: ['tree_nuts', 'gluten'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.periodFatigue,
      CheckInType.cravingSweets,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 210,
      proteinG: 5,
      carbsG: 32,
      fatG: 9,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Pit the dates and place them in a food processor with mixed nuts.',
        'Pulse until a chunky, sticky dough forms.',
        'Add oats, chopped dark chocolate, and a drizzle of honey; pulse a few more times.',
        'Roll into bite-sized balls and refrigerate for at least 30 minutes before serving.',
      ],
      'tr': [
        'Hurmaların çekirdeklerini çıkarın ve karışık kuruyemişle birlikte mutfak robotuna koyun.',
        'Parçalı ve yapışkan bir hamur oluşana kadar çalıştırın.',
        'Yulaf, doğranmış bitter çikolata ve bir miktar bal ekleyin; birkaç kez daha çalıştırın.',
        'Lokma büyüklüğünde toplar halinde yuvarlayın ve servis öncesi en az 30 dakika buzdolabında bekletin.',
      ],
    },
    imagePath: null,
    isUserCreated: false,
  ),
];

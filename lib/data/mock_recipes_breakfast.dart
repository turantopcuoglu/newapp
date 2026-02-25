import '../models/recipe.dart';
import '../core/enums.dart';

const List<Recipe> mockBreakfastRecipes = [
  // ── b001 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b001',
    name: {
      'en': 'Oatmeal with Banana and Honey',
      'tr': 'Muzlu ve Balli Yulaf Lapasi',
    },
    description: {
      'en':
          'A warm, energizing breakfast bowl with creamy oats, sliced banana, and a drizzle of honey.',
      'tr':
          'Kremali yulaf, dilimlenmiş muz ve bal ile hazırlanan sıcak ve enerji dolu bir kahvaltı kasesi.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['oats', 'banana', 'honey', 'milk', 'cinnamon'],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cantFocus,
      CheckInType.cravingSweets,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 350,
      proteinG: 12,
      carbsG: 55,
      fatG: 8,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Bring milk to a gentle simmer in a saucepan.',
        'Add oats and cook for 5 minutes, stirring occasionally.',
        'Slice the banana and place on top of the oats.',
        'Drizzle with honey and sprinkle cinnamon before serving.',
      ],
      'tr': [
        'Sütü bir tencerede hafifçe kaynatın.',
        'Yulafı ekleyin ve ara sıra karıştırarak 5 dakika pişirin.',
        'Muzu dilimleyip yulafın üzerine yerleştirin.',
        'Servis öncesi bal gezdirin ve tarçın serpin.',
      ],
    },
  ),

  // ── b002 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b002',
    name: {
      'en': 'Scrambled Eggs with Spinach and Feta',
      'tr': 'Ispanakli ve Peynirli Çırpılmış Yumurta',
    },
    description: {
      'en':
          'Fluffy scrambled eggs loaded with fresh spinach and crumbled feta cheese for a protein-packed start.',
      'tr':
          'Taze ıspanak ve ufalanmış beyaz peynir ile dolu, protein açısından zengin çırpılmış yumurta.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'eggs',
      'spinach',
      'feta_cheese',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['eggs', 'dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.lowEnergy,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 310,
      proteinG: 22,
      carbsG: 4,
      fatG: 23,
      fiberG: 2,
    ),
    steps: {
      'en': [
        'Whisk eggs in a bowl with a pinch of salt and pepper.',
        'Heat olive oil in a non-stick pan over medium heat.',
        'Add spinach and sauté until wilted, about 1 minute.',
        'Pour in eggs and stir gently until just set.',
        'Crumble feta on top and serve immediately.',
      ],
      'tr': [
        'Yumurtaları bir kasede tuz ve karabiber ile çırpın.',
        'Yapışmaz tavada zeytinyağını orta ateşte ısıtın.',
        'Ispanağı ekleyip yaklaşık 1 dakika soteleyin.',
        'Yumurtaları dökün ve hafifçe pişene kadar karıştırın.',
        'Üzerine beyaz peynir ufalayarak hemen servis edin.',
      ],
    },
  ),

  // ── b003 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b003',
    name: {
      'en': 'Berry Banana Smoothie',
      'tr': 'Meyveli Muz Smoothie',
    },
    description: {
      'en':
          'A refreshing and vibrant smoothie blending strawberries, banana, and yogurt for a quick breakfast.',
      'tr':
          'Çilek, muz ve yoğurdun harmanlandığı ferahlatıcı ve pratik bir kahvaltı smoothie\'si.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['strawberry', 'banana', 'yogurt', 'honey', 'chia_seeds'],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.lowEnergy,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 280,
      proteinG: 10,
      carbsG: 45,
      fatG: 6,
      fiberG: 7,
    ),
    steps: {
      'en': [
        'Add strawberries, banana, and yogurt to a blender.',
        'Add chia seeds and a tablespoon of honey.',
        'Blend on high until completely smooth.',
        'Pour into a glass and serve chilled.',
      ],
      'tr': [
        'Çilek, muz ve yoğurdu blender\'a ekleyin.',
        'Chia tohumu ve bir yemek kaşığı bal ekleyin.',
        'Tamamen pürüzsüz olana kadar yüksek hızda karıştırın.',
        'Bir bardağa dökün ve soğuk servis edin.',
      ],
    },
  ),

  // ── b004 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b004',
    name: {
      'en': 'Avocado Toast with Egg',
      'tr': 'Yumurtalı Avokado Tost',
    },
    description: {
      'en':
          'Crispy toast topped with mashed avocado and a perfectly fried egg, seasoned with chili flakes.',
      'tr':
          'Ezilmiş avokado ve mükemmel kızarmış yumurta ile süslenmiş çıtır tost, pul biber ile tatlandırılmış.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'bread',
      'avocado',
      'eggs',
      'olive_oil',
      'chili_flakes',
      'salt',
      'lemon',
    ],
    allergenTags: ['gluten', 'eggs'],
    checkInTags: [
      CheckInType.feelingBalanced,
      CheckInType.cantFocus,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 380,
      proteinG: 14,
      carbsG: 30,
      fatG: 24,
      fiberG: 8,
    ),
    steps: {
      'en': [
        'Toast the bread until golden and crispy.',
        'Mash the avocado with a squeeze of lemon juice and a pinch of salt.',
        'Fry the egg in olive oil until the whites are set.',
        'Spread avocado on toast, top with the fried egg, and sprinkle chili flakes.',
      ],
      'tr': [
        'Ekmeği altın rengi ve çıtır olana kadar kızartın.',
        'Avokadoyu limon suyu ve bir tutam tuz ile ezin.',
        'Yumurtayı zeytinyağında beyazı pişene kadar kızartın.',
        'Avokadoyu tostun üzerine sürün, yumurtayı koyun ve pul biber serpin.',
      ],
    },
  ),

  // ── b005 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b005',
    name: {
      'en': 'Greek Yogurt Parfait with Nuts and Berries',
      'tr': 'Meyveli ve Fındıklı Yoğurt Parfesi',
    },
    description: {
      'en':
          'Layered Greek yogurt with crunchy walnuts, fresh blueberries, and a drizzle of honey.',
      'tr':
          'Çıtır ceviz, taze yaban mersini ve bal ile katman katman hazırlanmış yoğurt parfesi.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['yogurt', 'walnuts', 'blueberry', 'honey', 'oats'],
    allergenTags: ['dairy', 'nuts', 'gluten'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.noSpecificIssue,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 320,
      proteinG: 15,
      carbsG: 35,
      fatG: 14,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Spoon a layer of yogurt into a glass or bowl.',
        'Add a layer of blueberries and a sprinkle of oats.',
        'Add another layer of yogurt and top with walnuts.',
        'Drizzle honey over the top and serve.',
      ],
      'tr': [
        'Bir bardak veya kaseye bir katman yoğurt koyun.',
        'Bir katman yaban mersini ve bir miktar yulaf ekleyin.',
        'Bir katman daha yoğurt koyun ve üzerine ceviz serpin.',
        'Üzerine bal gezdirin ve servis edin.',
      ],
    },
  ),

  // ── b006 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b006',
    name: {
      'en': 'Turkish Menemen',
      'tr': 'Menemen',
    },
    description: {
      'en':
          'A classic Turkish breakfast dish with eggs scrambled in a savory tomato and pepper sauce.',
      'tr':
          'Domates ve biber sosunda pişirilmiş yumurta ile hazırlanan geleneksel Türk kahvaltı yemeği.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'eggs',
      'tomato',
      'bell_pepper',
      'onion',
      'olive_oil',
      'salt',
      'black_pepper',
      'chili_flakes',
    ],
    allergenTags: ['eggs'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.bloated,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 290,
      proteinG: 16,
      carbsG: 12,
      fatG: 20,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Heat olive oil in a pan and sauté diced onion until translucent.',
        'Add chopped bell pepper and cook for 2 minutes.',
        'Add diced tomatoes and cook until they break down into a sauce.',
        'Crack eggs into the pan and stir gently until just set.',
        'Season with salt, pepper, and chili flakes before serving.',
      ],
      'tr': [
        'Tavada zeytinyağını ısıtın ve doğranmış soğanı kavurun.',
        'Doğranmış biberi ekleyip 2 dakika pişirin.',
        'Doğranmış domatesleri ekleyin ve sos kıvamına gelene kadar pişirin.',
        'Yumurtaları tavaya kırın ve hafifçe pişene kadar karıştırın.',
        'Tuz, karabiber ve pul biber ile tatlandırarak servis edin.',
      ],
    },
  ),

  // ── b007 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b007',
    name: {
      'en': 'Peanut Butter Banana Toast',
      'tr': 'Fıstık Ezmeli Muzlu Tost',
    },
    description: {
      'en':
          'Whole grain toast spread with peanut butter and topped with sliced banana and a hint of cinnamon.',
      'tr':
          'Fıstık ezmesi sürülmüş tam tahıllı ekmek üzerine dilimlenmiş muz ve bir tutam tarçın.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['bread', 'peanuts', 'banana', 'cinnamon', 'honey'],
    allergenTags: ['gluten', 'peanuts'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.postWorkout,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 390,
      proteinG: 14,
      carbsG: 48,
      fatG: 16,
      fiberG: 5,
    ),
    steps: {
      'en': [
        'Toast the bread until golden brown.',
        'Spread a generous layer of peanut butter on the toast.',
        'Slice the banana and arrange on top.',
        'Drizzle with honey and dust with cinnamon.',
      ],
      'tr': [
        'Ekmeği altın rengi olana kadar kızartın.',
        'Tostun üzerine bol miktarda fıstık ezmesi sürün.',
        'Muzu dilimleyip üzerine dizin.',
        'Bal gezdirin ve tarçın serpin.',
      ],
    },
  ),

  // ── b008 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b008',
    name: {
      'en': 'Chia Seed Pudding with Mango',
      'tr': 'Mangolu Chia Pudingi',
    },
    description: {
      'en':
          'A creamy overnight chia pudding topped with fresh mango chunks, perfect for a no-cook breakfast.',
      'tr':
          'Taze mango parçaları ile süslenmiş kremali chia pudingi, pişirme gerektirmeyen mükemmel bir kahvaltı.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['chia_seeds', 'milk', 'mango', 'honey', 'vanilla_extract'],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.pms,
      CheckInType.cravingSweets,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 290,
      proteinG: 9,
      carbsG: 38,
      fatG: 12,
      fiberG: 10,
    ),
    steps: {
      'en': [
        'Mix chia seeds with milk, honey, and vanilla extract in a jar.',
        'Stir well and refrigerate overnight or at least 4 hours.',
        'Dice the mango into small chunks.',
        'Top the pudding with mango pieces and serve cold.',
      ],
      'tr': [
        'Chia tohumlarını süt, bal ve vanilya özütü ile bir kavanozda karıştırın.',
        'İyice karıştırın ve en az 4 saat veya gece boyu buzdolabında bekletin.',
        'Mangoyu küçük küpler halinde doğrayın.',
        'Pudingin üzerine mango parçalarını koyun ve soğuk servis edin.',
      ],
    },
  ),

  // ── b009 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b009',
    name: {
      'en': 'Mushroom and Cheese Omelette',
      'tr': 'Mantarlı ve Peynirli Omlet',
    },
    description: {
      'en':
          'A fluffy omelette filled with sautéed mushrooms and melted cheddar cheese.',
      'tr':
          'Soteli mantar ve erimiş kaşar peyniri ile dolu kabarık bir omlet.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'eggs',
      'mushroom',
      'cheddar_cheese',
      'butter',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['eggs', 'dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.noSpecificIssue,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 360,
      proteinG: 24,
      carbsG: 4,
      fatG: 28,
      fiberG: 1,
    ),
    steps: {
      'en': [
        'Whisk eggs with salt and pepper in a bowl.',
        'Melt butter in a pan and sauté sliced mushrooms until golden.',
        'Pour eggs over the mushrooms and cook until the edges set.',
        'Sprinkle cheddar cheese on one half, fold the omelette, and serve.',
      ],
      'tr': [
        'Yumurtaları bir kasede tuz ve karabiber ile çırpın.',
        'Tavada tereyağını eritin ve dilimlenmiş mantarları altın rengi olana kadar soteleyin.',
        'Yumurtaları mantarların üzerine dökün ve kenarları pişene kadar bekleyin.',
        'Bir yarısına kaşar peyniri serpin, omleti katlayın ve servis edin.',
      ],
    },
  ),

  // ── b010 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b010',
    name: {
      'en': 'Fluffy Pancakes with Maple Syrup',
      'tr': 'Akçaağaç Şuruplu Pankek',
    },
    description: {
      'en':
          'Light and fluffy homemade pancakes served with a generous pour of maple syrup.',
      'tr':
          'Bol akçaağaç şurubu ile servis edilen hafif ve kabarık ev yapımı pankekler.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'flour',
      'eggs',
      'milk',
      'butter',
      'maple_syrup',
      'vanilla_extract',
    ],
    allergenTags: ['gluten', 'eggs', 'dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.lowEnergy,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 420,
      proteinG: 10,
      carbsG: 62,
      fatG: 14,
      fiberG: 2,
    ),
    steps: {
      'en': [
        'Mix flour, a pinch of salt, and vanilla extract in a large bowl.',
        'Whisk in eggs and milk until you have a smooth batter.',
        'Melt butter in a pan and pour small circles of batter.',
        'Cook until bubbles form on the surface, then flip and cook until golden.',
        'Serve stacked with maple syrup drizzled on top.',
      ],
      'tr': [
        'Unu, bir tutam tuzu ve vanilya özütünü büyük bir kasede karıştırın.',
        'Yumurta ve sütü ekleyip pürüzsüz bir hamur elde edene kadar çırpın.',
        'Tavada tereyağını eritin ve küçük daireler halinde hamur dökün.',
        'Yüzeyde kabarcıklar oluşunca çevirip altın rengi olana kadar pişirin.',
        'Üst üste dizin ve üzerine akçaağaç şurubu gezdirerek servis edin.',
      ],
    },
  ),

  // ── b011 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b011',
    name: {
      'en': 'Quinoa Breakfast Bowl',
      'tr': 'Kinoa Kahvaltı Kasesi',
    },
    description: {
      'en':
          'A nutrient-dense breakfast bowl with fluffy quinoa, sliced almonds, and fresh strawberries.',
      'tr':
          'Kabarık kinoa, dilimlenmiş badem ve taze çilek ile hazırlanan besin değeri yüksek bir kahvaltı kasesi.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'quinoa',
      'almonds',
      'strawberry',
      'honey',
      'milk',
      'cinnamon',
    ],
    allergenTags: ['nuts', 'dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.bloated,
      CheckInType.lowEnergy,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 370,
      proteinG: 14,
      carbsG: 50,
      fatG: 12,
      fiberG: 7,
    ),
    steps: {
      'en': [
        'Rinse quinoa thoroughly under cold water.',
        'Cook quinoa in milk over medium heat until fluffy, about 15 minutes.',
        'Slice strawberries and roughly chop almonds.',
        'Serve quinoa in a bowl topped with strawberries, almonds, honey, and cinnamon.',
      ],
      'tr': [
        'Kinoayı soğuk su altında iyice yıkayın.',
        'Kinoayı sütte orta ateşte kabarık olana kadar yaklaşık 15 dakika pişirin.',
        'Çilekleri dilimleyin ve bademleri kabaca kırın.',
        'Kinoayı kaseye alıp üzerine çilek, badem, bal ve tarçın koyarak servis edin.',
      ],
    },
  ),

  // ── b012 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b012',
    name: {
      'en': 'Smoked Salmon on Toast',
      'tr': 'Füme Somonlu Tost',
    },
    description: {
      'en':
          'Toasted bread topped with cream cheese, smoked salmon, and a squeeze of lemon for an elegant breakfast.',
      'tr':
          'Krem peynir, füme somon ve limon sıkılmış tost ekmeği ile zarif bir kahvaltı.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'bread',
      'salmon',
      'cream',
      'lemon',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['gluten', 'fish', 'dairy'],
    checkInTags: [
      CheckInType.cantFocus,
      CheckInType.pms,
      CheckInType.feelingBalanced,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 340,
      proteinG: 22,
      carbsG: 25,
      fatG: 16,
      fiberG: 2,
    ),
    steps: {
      'en': [
        'Toast the bread until crispy.',
        'Spread a layer of cream cheese on the toast.',
        'Lay smoked salmon slices on top.',
        'Squeeze fresh lemon juice over the salmon and season with salt and pepper.',
      ],
      'tr': [
        'Ekmeği çıtır olana kadar kızartın.',
        'Tostun üzerine bir katman krem peynir sürün.',
        'Füme somon dilimlerini üzerine yerleştirin.',
        'Somonun üzerine taze limon suyu sıkın, tuz ve karabiber ile tatlandırın.',
      ],
    },
  ),

  // ── b013 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b013',
    name: {
      'en': 'Sweet Potato and Egg Breakfast Hash',
      'tr': 'Tatlı Patatesli ve Yumurtalı Kahvaltı Kavurması',
    },
    description: {
      'en':
          'Cubed sweet potato pan-fried with onions and topped with a sunny-side-up egg.',
      'tr':
          'Soğan ile tavada kızartılmış küp tatlı patates ve üzerine güneş gözü yumurta.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'sweet_potato',
      'eggs',
      'onion',
      'olive_oil',
      'paprika',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['eggs'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.postWorkout,
      CheckInType.pms,
      CheckInType.bloated,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 340,
      proteinG: 13,
      carbsG: 40,
      fatG: 15,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Peel and dice the sweet potato into small cubes.',
        'Heat olive oil in a skillet and fry sweet potato cubes until golden, about 10 minutes.',
        'Add diced onion and cook for 3 more minutes.',
        'Push the hash to the side, crack an egg into the pan, and cook sunny-side up.',
        'Season with paprika, salt, and pepper before serving.',
      ],
      'tr': [
        'Tatlı patatesi soyun ve küçük küpler halinde doğrayın.',
        'Tavada zeytinyağını ısıtın ve tatlı patates küplerini yaklaşık 10 dakika altın rengi olana kadar kızartın.',
        'Doğranmış soğanı ekleyip 3 dakika daha pişirin.',
        'Kavurmayı kenara itin, tavaya bir yumurta kırın ve güneş gözü pişirin.',
        'Kırmızı biber, tuz ve karabiber ile tatlandırarak servis edin.',
      ],
    },
  ),

  // ── b014 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b014',
    name: {
      'en': 'Overnight Oats with Blueberries',
      'tr': 'Yaban Mersinli Gece Yulafı',
    },
    description: {
      'en':
          'No-cook overnight oats soaked in yogurt with fresh blueberries and flaxseeds.',
      'tr':
          'Yoğurt içinde bekletilmiş, taze yaban mersini ve keten tohumu ile hazırlanan pişirme gerektirmeyen yulaf.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['oats', 'yogurt', 'blueberry', 'flaxseeds', 'honey'],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 310,
      proteinG: 12,
      carbsG: 45,
      fatG: 10,
      fiberG: 8,
    ),
    steps: {
      'en': [
        'Combine oats, yogurt, and flaxseeds in a mason jar.',
        'Stir in a spoonful of honey.',
        'Add blueberries on top and seal the jar.',
        'Refrigerate overnight and enjoy cold in the morning.',
      ],
      'tr': [
        'Yulaf, yoğurt ve keten tohumunu bir kavanozda birleştirin.',
        'Bir kaşık bal ekleyip karıştırın.',
        'Üzerine yaban mersini ekleyin ve kavanozu kapatın.',
        'Gece boyu buzdolabında bekletin ve sabah soğuk olarak tadını çıkarın.',
      ],
    },
  ),

  // ── b015 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b015',
    name: {
      'en': 'Veggie Breakfast Wrap',
      'tr': 'Sebzeli Kahvaltı Dürümü',
    },
    description: {
      'en':
          'A warm tortilla filled with scrambled eggs, sautéed vegetables, and a touch of cheese.',
      'tr':
          'Çırpılmış yumurta, sote sebze ve bir tutam peynir ile doldurulmuş sıcak lavaş.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'tortilla',
      'eggs',
      'bell_pepper',
      'spinach',
      'mozzarella',
      'olive_oil',
      'salt',
    ],
    allergenTags: ['gluten', 'eggs', 'dairy'],
    checkInTags: [
      CheckInType.cantFocus,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 400,
      proteinG: 20,
      carbsG: 35,
      fatG: 20,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Heat olive oil in a pan and sauté diced bell pepper and spinach.',
        'Add beaten eggs and scramble until just set.',
        'Warm the tortilla in a dry pan for 30 seconds on each side.',
        'Fill the tortilla with the egg and veggie mixture, sprinkle mozzarella, and roll up.',
      ],
      'tr': [
        'Tavada zeytinyağını ısıtın, doğranmış biberi ve ıspanağı soteleyin.',
        'Çırpılmış yumurtaları ekleyin ve hafifçe pişene kadar karıştırın.',
        'Lavaşı kuru tavada her iki tarafını 30 saniye ısıtın.',
        'Lavaşın içine yumurta ve sebze karışımını koyun, mozzarella serpin ve sarın.',
      ],
    },
  ),

  // ── b016 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b016',
    name: {
      'en': 'Banana Oat Smoothie',
      'tr': 'Muzlu Yulaf Smoothie',
    },
    description: {
      'en':
          'A thick, filling smoothie with banana, oats, and almond butter that keeps you full all morning.',
      'tr':
          'Muz, yulaf ve badem ezmesi ile hazırlanan koyu ve doyurucu bir smoothie.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['banana', 'oats', 'almonds', 'milk', 'honey', 'cinnamon'],
    allergenTags: ['gluten', 'nuts', 'dairy'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.cravingSweets,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 360,
      proteinG: 11,
      carbsG: 52,
      fatG: 13,
      fiberG: 7,
    ),
    steps: {
      'en': [
        'Add banana, oats, a spoonful of almond butter, and milk to a blender.',
        'Add honey and a pinch of cinnamon.',
        'Blend until thick and smooth.',
        'Pour into a glass and enjoy immediately.',
      ],
      'tr': [
        'Muzu, yulafı, bir kaşık badem ezmesini ve sütü blender\'a ekleyin.',
        'Bal ve bir tutam tarçın ekleyin.',
        'Koyu ve pürüzsüz olana kadar karıştırın.',
        'Bir bardağa dökün ve hemen için.',
      ],
    },
  ),

  // ── b017 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b017',
    name: {
      'en': 'Turkish Simit with Feta and Tomato',
      'tr': 'Beyaz Peynirli ve Domatesli Simit',
    },
    description: {
      'en':
          'Traditional Turkish sesame bread ring served with crumbled feta, tomato slices, and cucumber.',
      'tr':
          'Ufalanmış beyaz peynir, domates dilimleri ve salatalık ile servis edilen geleneksel simit.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'bread',
      'feta_cheese',
      'tomato',
      'cucumber',
      'olive_oil',
    ],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
      CheckInType.bloated,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 330,
      proteinG: 13,
      carbsG: 40,
      fatG: 13,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Slice the simit in half or arrange bread on a plate.',
        'Crumble feta cheese over the bread.',
        'Slice tomato and cucumber and arrange alongside.',
        'Drizzle olive oil over the plate and serve.',
      ],
      'tr': [
        'Simidi ikiye kesin veya ekmeği tabağa yerleştirin.',
        'Beyaz peyniri ekmeğin üzerine ufalayın.',
        'Domates ve salatalığı dilimleyip yanına dizin.',
        'Tabağın üzerine zeytinyağı gezdirin ve servis edin.',
      ],
    },
  ),

  // ── b018 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b018',
    name: {
      'en': 'Tofu Scramble with Vegetables',
      'tr': 'Sebzeli Tofu Kavurması',
    },
    description: {
      'en':
          'A plant-based breakfast scramble with crumbled tofu, turmeric, and fresh vegetables.',
      'tr':
          'Ufalanmış tofu, zerdeçal ve taze sebzeler ile hazırlanan bitkisel kahvaltı kavurması.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'tofu',
      'spinach',
      'bell_pepper',
      'onion',
      'turmeric',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['soy'],
    checkInTags: [
      CheckInType.bloated,
      CheckInType.postWorkout,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 250,
      proteinG: 18,
      carbsG: 10,
      fatG: 16,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Drain and press tofu to remove excess moisture, then crumble it.',
        'Heat olive oil and sauté diced onion and bell pepper for 3 minutes.',
        'Add crumbled tofu and turmeric, stirring to coat evenly.',
        'Add spinach and cook until wilted.',
        'Season with salt and pepper and serve warm.',
      ],
      'tr': [
        'Tofunun suyunu süzün ve fazla nemini alın, ardından ufalayın.',
        'Zeytinyağını ısıtın, doğranmış soğan ve biberi 3 dakika soteleyin.',
        'Ufalanmış tofu ve zerdeçali ekleyip eşit şekilde karıştırın.',
        'Ispanağı ekleyin ve solana kadar pişirin.',
        'Tuz ve karabiberle tatlandırıp sıcak servis edin.',
      ],
    },
  ),

  // ── b019 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b019',
    name: {
      'en': 'Apple Cinnamon Oatmeal',
      'tr': 'Tarçınlı Elmalı Yulaf Lapası',
    },
    description: {
      'en':
          'Warm oatmeal cooked with diced apple, cinnamon, and a touch of maple syrup.',
      'tr':
          'Doğranmış elma, tarçın ve bir miktar akçaağaç şurubu ile pişirilmiş sıcak yulaf lapası.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['oats', 'apple', 'cinnamon', 'maple_syrup', 'milk'],
    allergenTags: ['gluten', 'dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.cantFocus,
      CheckInType.bloated,
    ],
    proteinLevel: NutrientLevel.medium,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 330,
      proteinG: 10,
      carbsG: 56,
      fatG: 7,
      fiberG: 7,
    ),
    steps: {
      'en': [
        'Dice the apple into small cubes.',
        'Combine oats and milk in a saucepan over medium heat.',
        'Add diced apple and cinnamon while cooking.',
        'Cook for 5 minutes, stirring occasionally, until creamy.',
        'Drizzle maple syrup on top and serve warm.',
      ],
      'tr': [
        'Elmayı küçük küpler halinde doğrayın.',
        'Yulaf ve sütü bir tencerede orta ateşte birleştirin.',
        'Pişirirken doğranmış elma ve tarçını ekleyin.',
        'Ara sıra karıştırarak kremamsı olana kadar 5 dakika pişirin.',
        'Üzerine akçaağaç şurubu gezdirip sıcak servis edin.',
      ],
    },
  ),

  // ── b020 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b020',
    name: {
      'en': 'Egg and Cheese Breakfast Sandwich',
      'tr': 'Yumurtalı ve Peynirli Kahvaltı Sandviçi',
    },
    description: {
      'en':
          'A hearty sandwich with a fried egg, melted cheddar, and fresh tomato on toasted bread.',
      'tr':
          'Kızarmış ekmek üzerinde kızarmış yumurta, erimiş kaşar peyniri ve taze domates ile doyurucu bir sandviç.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'bread',
      'eggs',
      'cheddar_cheese',
      'tomato',
      'butter',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['gluten', 'eggs', 'dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.lowEnergy,
      CheckInType.cantFocus,
      CheckInType.noSpecificIssue,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.low,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 430,
      proteinG: 22,
      carbsG: 32,
      fatG: 24,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Butter both slices of bread and toast them in a pan until golden.',
        'Fry the egg in the same pan until the whites are set.',
        'Place a slice of cheddar cheese on one bread slice.',
        'Add the fried egg and tomato slices, then close the sandwich.',
      ],
      'tr': [
        'Her iki ekmek dilimine tereyağı sürün ve tavada altın rengi olana kadar kızartın.',
        'Aynı tavada yumurtayı beyazı pişene kadar kızartın.',
        'Bir ekmek dilimine bir dilim kaşar peyniri koyun.',
        'Kızarmış yumurta ve domates dilimlerini ekleyip sandviçi kapatın.',
      ],
    },
  ),

  // ── b021 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b021',
    name: {
      'en': 'Tropical Green Smoothie',
      'tr': 'Tropikal Yeşil Smoothie',
    },
    description: {
      'en':
          'A nutrient-packed green smoothie with spinach, pineapple, banana, and coconut oil.',
      'tr':
          'Ispanak, ananas, muz ve hindistancevizi yağı ile hazırlanan besin değeri yüksek yeşil smoothie.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'spinach',
      'pineapple',
      'banana',
      'coconut_oil',
      'honey',
    ],
    allergenTags: [],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.bloated,
      CheckInType.cantFocus,
      CheckInType.pms,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.high,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 240,
      proteinG: 4,
      carbsG: 45,
      fatG: 7,
      fiberG: 6,
    ),
    steps: {
      'en': [
        'Add spinach, pineapple chunks, and banana to a blender.',
        'Add a teaspoon of coconut oil and a drizzle of honey.',
        'Add half a cup of water and blend until smooth.',
        'Pour into a glass and serve immediately.',
      ],
      'tr': [
        'Ispanak, ananas parçaları ve muzu blender\'a ekleyin.',
        'Bir tatlı kaşığı hindistancevizi yağı ve bir miktar bal ekleyin.',
        'Yarım bardak su ekleyip pürüzsüz olana kadar karıştırın.',
        'Bir bardağa dökün ve hemen servis edin.',
      ],
    },
  ),

  // ── b022 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b022',
    name: {
      'en': 'Shakshuka',
      'tr': 'Şakşuka',
    },
    description: {
      'en':
          'Eggs poached in a spiced tomato and pepper sauce, a satisfying and flavorful breakfast.',
      'tr':
          'Baharatlı domates ve biber sosunda pişirilmiş yumurta, doyurucu ve lezzetli bir kahvaltı.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'eggs',
      'tomato',
      'bell_pepper',
      'onion',
      'garlic',
      'cumin',
      'paprika',
      'olive_oil',
      'salt',
    ],
    allergenTags: ['eggs'],
    checkInTags: [
      CheckInType.lowEnergy,
      CheckInType.feelingBalanced,
      CheckInType.postWorkout,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 310,
      proteinG: 17,
      carbsG: 15,
      fatG: 21,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Heat olive oil and sauté diced onion and garlic until fragrant.',
        'Add chopped bell pepper and cook for 2 minutes.',
        'Add diced tomatoes, cumin, and paprika; simmer for 10 minutes.',
        'Make small wells in the sauce and crack eggs into them.',
        'Cover and cook until the eggs are set, about 5 minutes.',
      ],
      'tr': [
        'Zeytinyağını ısıtın, doğranmış soğan ve sarımsağı kokusu çıkana kadar kavurun.',
        'Doğranmış biberi ekleyip 2 dakika pişirin.',
        'Doğranmış domatesleri, kimyonu ve kırmızı biberi ekleyin; 10 dakika kaynatın.',
        'Sosun içinde küçük çukurlar açıp yumurtaları kırın.',
        'Kapağını kapatıp yumurtalar pişene kadar yaklaşık 5 dakika bekletin.',
      ],
    },
  ),

  // ── b023 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b023',
    name: {
      'en': 'Cottage Cheese Bowl with Walnuts and Honey',
      'tr': 'Cevizli ve Ballı Lor Peyniri Kasesi',
    },
    description: {
      'en':
          'Creamy cottage cheese topped with crunchy walnuts, honey, and a sprinkle of flaxseeds.',
      'tr':
          'Çıtır ceviz, bal ve keten tohumu ile süslenmiş kremali lor peyniri kasesi.',
    },
    mealType: MealType.breakfast,
    ingredientIds: ['yogurt', 'walnuts', 'honey', 'flaxseeds', 'banana'],
    allergenTags: ['dairy', 'nuts'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.pms,
      CheckInType.noSpecificIssue,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.mixed,
    macros: MacroEstimation(
      calories: 320,
      proteinG: 16,
      carbsG: 30,
      fatG: 16,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Spoon yogurt or cottage cheese into a bowl.',
        'Roughly chop walnuts and sprinkle on top.',
        'Add flaxseeds and sliced banana.',
        'Drizzle honey over everything and serve.',
      ],
      'tr': [
        'Yoğurt veya lor peynirini bir kaseye koyun.',
        'Cevizleri kabaca kırıp üzerine serpin.',
        'Keten tohumu ve dilimlenmiş muz ekleyin.',
        'Her şeyin üzerine bal gezdirin ve servis edin.',
      ],
    },
  ),

  // ── b024 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b024',
    name: {
      'en': 'Cornmeal Porridge with Berries',
      'tr': 'Meyveli Mısır Unu Lapası',
    },
    description: {
      'en':
          'A warm, comforting porridge made from cornmeal and topped with fresh strawberries and blueberries.',
      'tr':
          'Mısır unundan yapılmış, taze çilek ve yaban mersini ile süslenmiş sıcak ve rahatlatıcı bir lapa.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'cornmeal',
      'milk',
      'strawberry',
      'blueberry',
      'honey',
      'butter',
    ],
    allergenTags: ['dairy'],
    checkInTags: [
      CheckInType.cravingSweets,
      CheckInType.bloated,
      CheckInType.lowEnergy,
    ],
    proteinLevel: NutrientLevel.low,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.complex,
    macros: MacroEstimation(
      calories: 300,
      proteinG: 8,
      carbsG: 50,
      fatG: 8,
      fiberG: 4,
    ),
    steps: {
      'en': [
        'Bring milk to a simmer in a saucepan.',
        'Slowly whisk in cornmeal to avoid lumps.',
        'Cook for 10 minutes, stirring constantly, until thick and creamy.',
        'Stir in a small pat of butter and drizzle honey on top.',
        'Serve topped with fresh strawberries and blueberries.',
      ],
      'tr': [
        'Sütü bir tencerede kaynatın.',
        'Topaklanmaması için mısır ununu yavaşça çırparak ekleyin.',
        'Sürekli karıştırarak koyu ve kremamsı olana kadar 10 dakika pişirin.',
        'Bir parça tereyağı ekleyin ve üzerine bal gezdirin.',
        'Taze çilek ve yaban mersini ile servis edin.',
      ],
    },
  ),

  // ── b025 ─────────────────────────────────────────────────────────────
  Recipe(
    id: 'b025',
    name: {
      'en': 'Egg Muffin Cups with Broccoli and Cheese',
      'tr': 'Brokolili ve Peynirli Yumurta Muffini',
    },
    description: {
      'en':
          'Baked egg cups loaded with broccoli and parmesan cheese, perfect for meal prep mornings.',
      'tr':
          'Brokoli ve parmesan peyniri ile dolu fırında pişirilmiş yumurta kapları, hazırlıklı sabahlar için mükemmel.',
    },
    mealType: MealType.breakfast,
    ingredientIds: [
      'eggs',
      'broccoli',
      'parmesan',
      'olive_oil',
      'salt',
      'black_pepper',
    ],
    allergenTags: ['eggs', 'dairy'],
    checkInTags: [
      CheckInType.postWorkout,
      CheckInType.feelingBalanced,
      CheckInType.noSpecificIssue,
      CheckInType.cantFocus,
    ],
    proteinLevel: NutrientLevel.high,
    fiberLevel: NutrientLevel.medium,
    carbType: CarbType.simple,
    macros: MacroEstimation(
      calories: 280,
      proteinG: 20,
      carbsG: 6,
      fatG: 20,
      fiberG: 3,
    ),
    steps: {
      'en': [
        'Preheat the oven to 180C and grease a muffin tin with olive oil.',
        'Chop broccoli into very small florets and divide among the muffin cups.',
        'Whisk eggs with salt, pepper, and grated parmesan.',
        'Pour the egg mixture over the broccoli in each cup.',
        'Bake for 18-20 minutes until puffed and golden on top.',
      ],
      'tr': [
        'Fırını 180C\'ye ısıtın ve muffin kalıbını zeytinyağı ile yağlayın.',
        'Brokoliyi çok küçük çiçeklere ayırın ve muffin kalıplarına bölüştürün.',
        'Yumurtaları tuz, karabiber ve rendelenmiş parmesan ile çırpın.',
        'Yumurta karışımını her kalıptaki brokolilerin üzerine dökün.',
        'Kabarıp üzeri altın rengi olana kadar 18-20 dakika fırınlayın.',
      ],
    },
  ),
];

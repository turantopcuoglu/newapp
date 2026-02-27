import '../models/ingredient.dart';
import '../core/enums.dart';

const List<Ingredient> mockIngredients = [
  // ── Protein (15) ──────────────────────────────────────────────────────
  Ingredient(
    id: 'chicken_breast',
    name: {'en': 'Chicken Breast', 'tr': 'Tavuk Göğsü'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'ground_beef',
    name: {'en': 'Ground Beef', 'tr': 'Kıyma'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'salmon',
    name: {'en': 'Salmon', 'tr': 'Somon'},
    category: IngredientCategory.protein,
    allergenTags: ['fish'],
  ),
  Ingredient(
    id: 'eggs',
    name: {'en': 'Eggs', 'tr': 'Yumurta'},
    category: IngredientCategory.protein,
    allergenTags: ['eggs'],
  ),
  Ingredient(
    id: 'shrimp',
    name: {'en': 'Shrimp', 'tr': 'Karides'},
    category: IngredientCategory.protein,
    allergenTags: ['shellfish'],
  ),
  Ingredient(
    id: 'turkey_breast',
    name: {'en': 'Turkey Breast', 'tr': 'Hindi Göğsü'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'lamb',
    name: {'en': 'Lamb', 'tr': 'Kuzu Eti'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'tuna',
    name: {'en': 'Tuna', 'tr': 'Ton Balığı'},
    category: IngredientCategory.protein,
    allergenTags: ['fish'],
  ),
  Ingredient(
    id: 'chicken_thigh',
    name: {'en': 'Chicken Thigh', 'tr': 'Tavuk Butu'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'beef_steak',
    name: {'en': 'Beef Steak', 'tr': 'Biftek'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'cod',
    name: {'en': 'Cod', 'tr': 'Morina Balığı'},
    category: IngredientCategory.protein,
    allergenTags: ['fish'],
  ),
  Ingredient(
    id: 'tofu',
    name: {'en': 'Tofu', 'tr': 'Tofu'},
    category: IngredientCategory.protein,
    allergenTags: ['soy'],
  ),
  Ingredient(
    id: 'pork_chop',
    name: {'en': 'Pork Chop', 'tr': 'Domuz Pirzolası'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'duck_breast',
    name: {'en': 'Duck Breast', 'tr': 'Ördek Göğsü'},
    category: IngredientCategory.protein,
    allergenTags: [],
  ),
  Ingredient(
    id: 'anchovy',
    name: {'en': 'Anchovy', 'tr': 'Hamsi'},
    category: IngredientCategory.protein,
    allergenTags: ['fish'],
  ),

  // ── Dairy (8) ─────────────────────────────────────────────────────────
  Ingredient(
    id: 'milk',
    name: {'en': 'Milk', 'tr': 'Süt'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'yogurt',
    name: {'en': 'Yogurt', 'tr': 'Yoğurt'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'cheddar_cheese',
    name: {'en': 'Cheddar Cheese', 'tr': 'Kaşar Peyniri'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'feta_cheese',
    name: {'en': 'Feta Cheese', 'tr': 'Beyaz Peynir'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'butter',
    name: {'en': 'Butter', 'tr': 'Tereyağı'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'cream',
    name: {'en': 'Heavy Cream', 'tr': 'Krema'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'mozzarella',
    name: {'en': 'Mozzarella', 'tr': 'Mozzarella'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'parmesan',
    name: {'en': 'Parmesan', 'tr': 'Parmesan'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),

  // ── Grain (10) ────────────────────────────────────────────────────────
  Ingredient(
    id: 'white_rice',
    name: {'en': 'White Rice', 'tr': 'Pirinç'},
    category: IngredientCategory.grain,
    allergenTags: [],
  ),
  Ingredient(
    id: 'pasta',
    name: {'en': 'Pasta', 'tr': 'Makarna'},
    category: IngredientCategory.grain,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'bread',
    name: {'en': 'Bread', 'tr': 'Ekmek'},
    category: IngredientCategory.grain,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'flour',
    name: {'en': 'All-Purpose Flour', 'tr': 'Un'},
    category: IngredientCategory.grain,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'oats',
    name: {'en': 'Oats', 'tr': 'Yulaf'},
    category: IngredientCategory.grain,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'bulgur',
    name: {'en': 'Bulgur', 'tr': 'Bulgur'},
    category: IngredientCategory.grain,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'couscous',
    name: {'en': 'Couscous', 'tr': 'Kuskus'},
    category: IngredientCategory.grain,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'cornmeal',
    name: {'en': 'Cornmeal', 'tr': 'Mısır Unu'},
    category: IngredientCategory.grain,
    allergenTags: [],
  ),
  Ingredient(
    id: 'brown_rice',
    name: {'en': 'Brown Rice', 'tr': 'Esmer Pirinç'},
    category: IngredientCategory.grain,
    allergenTags: [],
  ),
  Ingredient(
    id: 'quinoa',
    name: {'en': 'Quinoa', 'tr': 'Kinoa'},
    category: IngredientCategory.grain,
    allergenTags: [],
  ),

  // ── Vegetable (20) ────────────────────────────────────────────────────
  Ingredient(
    id: 'tomato',
    name: {'en': 'Tomato', 'tr': 'Domates'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'onion',
    name: {'en': 'Onion', 'tr': 'Soğan'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'garlic',
    name: {'en': 'Garlic', 'tr': 'Sarımsak'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'potato',
    name: {'en': 'Potato', 'tr': 'Patates'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'carrot',
    name: {'en': 'Carrot', 'tr': 'Havuç'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'bell_pepper',
    name: {'en': 'Bell Pepper', 'tr': 'Dolmalık Biber'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'cucumber',
    name: {'en': 'Cucumber', 'tr': 'Salatalık'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'spinach',
    name: {'en': 'Spinach', 'tr': 'Ispanak'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'broccoli',
    name: {'en': 'Broccoli', 'tr': 'Brokoli'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'zucchini',
    name: {'en': 'Zucchini', 'tr': 'Kabak'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'eggplant',
    name: {'en': 'Eggplant', 'tr': 'Patlıcan'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'lettuce',
    name: {'en': 'Lettuce', 'tr': 'Marul'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'mushroom',
    name: {'en': 'Mushroom', 'tr': 'Mantar'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'green_beans',
    name: {'en': 'Green Beans', 'tr': 'Taze Fasulye'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'cauliflower',
    name: {'en': 'Cauliflower', 'tr': 'Karnabahar'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'celery',
    name: {'en': 'Celery', 'tr': 'Kereviz'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'sweet_potato',
    name: {'en': 'Sweet Potato', 'tr': 'Tatlı Patates'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'leek',
    name: {'en': 'Leek', 'tr': 'Pırasa'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'cabbage',
    name: {'en': 'Cabbage', 'tr': 'Lahana'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'artichoke',
    name: {'en': 'Artichoke', 'tr': 'Enginar'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),

  // ── Fruit (12) ────────────────────────────────────────────────────────
  Ingredient(
    id: 'apple',
    name: {'en': 'Apple', 'tr': 'Elma'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'banana',
    name: {'en': 'Banana', 'tr': 'Muz'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'lemon',
    name: {'en': 'Lemon', 'tr': 'Limon'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'orange',
    name: {'en': 'Orange', 'tr': 'Portakal'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'strawberry',
    name: {'en': 'Strawberry', 'tr': 'Çilek'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'avocado',
    name: {'en': 'Avocado', 'tr': 'Avokado'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'pomegranate',
    name: {'en': 'Pomegranate', 'tr': 'Nar'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'grape',
    name: {'en': 'Grape', 'tr': 'Üzüm'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'watermelon',
    name: {'en': 'Watermelon', 'tr': 'Karpuz'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'peach',
    name: {'en': 'Peach', 'tr': 'Şeftali'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'cherry',
    name: {'en': 'Cherry', 'tr': 'Kiraz'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'fig',
    name: {'en': 'Fig', 'tr': 'İncir'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),

  // ── Spice (10) ────────────────────────────────────────────────────────
  Ingredient(
    id: 'black_pepper',
    name: {'en': 'Black Pepper', 'tr': 'Karabiber'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'cumin',
    name: {'en': 'Cumin', 'tr': 'Kimyon'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'paprika',
    name: {'en': 'Paprika', 'tr': 'Toz Biber'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'red_pepper_flakes',
    name: {'en': 'Red Pepper Flakes', 'tr': 'Pul Biber'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'cinnamon',
    name: {'en': 'Cinnamon', 'tr': 'Tarçın'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'oregano',
    name: {'en': 'Oregano', 'tr': 'Kekik'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'turmeric',
    name: {'en': 'Turmeric', 'tr': 'Zerdeçal'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'mint',
    name: {'en': 'Dried Mint', 'tr': 'Nane'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'parsley',
    name: {'en': 'Parsley', 'tr': 'Maydanoz'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'bay_leaf',
    name: {'en': 'Bay Leaf', 'tr': 'Defne Yaprağı'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),

  // ── Oil (5) ───────────────────────────────────────────────────────────
  Ingredient(
    id: 'olive_oil',
    name: {'en': 'Olive Oil', 'tr': 'Zeytinyağı'},
    category: IngredientCategory.oil,
    allergenTags: [],
  ),
  Ingredient(
    id: 'sunflower_oil',
    name: {'en': 'Sunflower Oil', 'tr': 'Ayçiçek Yağı'},
    category: IngredientCategory.oil,
    allergenTags: [],
  ),
  Ingredient(
    id: 'coconut_oil',
    name: {'en': 'Coconut Oil', 'tr': 'Hindistancevizi Yağı'},
    category: IngredientCategory.oil,
    allergenTags: [],
  ),
  Ingredient(
    id: 'sesame_oil',
    name: {'en': 'Sesame Oil', 'tr': 'Susam Yağı'},
    category: IngredientCategory.oil,
    allergenTags: [],
  ),
  Ingredient(
    id: 'canola_oil',
    name: {'en': 'Canola Oil', 'tr': 'Kanola Yağı'},
    category: IngredientCategory.oil,
    allergenTags: [],
  ),

  // ── Nut (6) ───────────────────────────────────────────────────────────
  Ingredient(
    id: 'walnut',
    name: {'en': 'Walnut', 'tr': 'Ceviz'},
    category: IngredientCategory.nut,
    allergenTags: ['nuts'],
  ),
  Ingredient(
    id: 'almond',
    name: {'en': 'Almond', 'tr': 'Badem'},
    category: IngredientCategory.nut,
    allergenTags: ['nuts'],
  ),
  Ingredient(
    id: 'hazelnut',
    name: {'en': 'Hazelnut', 'tr': 'Fındık'},
    category: IngredientCategory.nut,
    allergenTags: ['nuts'],
  ),
  Ingredient(
    id: 'pistachio',
    name: {'en': 'Pistachio', 'tr': 'Antep Fıstığı'},
    category: IngredientCategory.nut,
    allergenTags: ['nuts'],
  ),
  Ingredient(
    id: 'peanut',
    name: {'en': 'Peanut', 'tr': 'Yer Fıstığı'},
    category: IngredientCategory.nut,
    allergenTags: ['peanuts'],
  ),
  Ingredient(
    id: 'cashew',
    name: {'en': 'Cashew', 'tr': 'Kaju'},
    category: IngredientCategory.nut,
    allergenTags: ['nuts'],
  ),

  // ── Legume (5) ────────────────────────────────────────────────────────
  Ingredient(
    id: 'red_lentil',
    name: {'en': 'Red Lentil', 'tr': 'Kırmızı Mercimek'},
    category: IngredientCategory.legume,
    allergenTags: [],
  ),
  Ingredient(
    id: 'green_lentil',
    name: {'en': 'Green Lentil', 'tr': 'Yeşil Mercimek'},
    category: IngredientCategory.legume,
    allergenTags: [],
  ),
  Ingredient(
    id: 'chickpea',
    name: {'en': 'Chickpea', 'tr': 'Nohut'},
    category: IngredientCategory.legume,
    allergenTags: [],
  ),
  Ingredient(
    id: 'white_bean',
    name: {'en': 'White Bean', 'tr': 'Kuru Fasulye'},
    category: IngredientCategory.legume,
    allergenTags: [],
  ),
  Ingredient(
    id: 'black_eyed_pea',
    name: {'en': 'Black-Eyed Pea', 'tr': 'Börülce'},
    category: IngredientCategory.legume,
    allergenTags: [],
  ),

  // ── Condiment (7) ─────────────────────────────────────────────────────
  Ingredient(
    id: 'salt',
    name: {'en': 'Salt', 'tr': 'Tuz'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),
  Ingredient(
    id: 'sugar',
    name: {'en': 'Sugar', 'tr': 'Şeker'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),
  Ingredient(
    id: 'soy_sauce',
    name: {'en': 'Soy Sauce', 'tr': 'Soya Sosu'},
    category: IngredientCategory.condiment,
    allergenTags: ['soy', 'gluten'],
  ),
  Ingredient(
    id: 'tomato_paste',
    name: {'en': 'Tomato Paste', 'tr': 'Salça'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),
  Ingredient(
    id: 'apple_cider_vinegar',
    name: {'en': 'Apple Cider Vinegar', 'tr': 'Elma Sirkesi'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),
  Ingredient(
    id: 'mustard',
    name: {'en': 'Mustard', 'tr': 'Hardal'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),
  Ingredient(
    id: 'honey',
    name: {'en': 'Honey', 'tr': 'Bal'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),

  // ── Snack Food (12) ──────────────────────────────────────────────────
  Ingredient(
    id: 'potato_chips',
    name: {'en': 'Potato Chips', 'tr': 'Patates Cipsi'},
    category: IngredientCategory.snackFood,
    allergenTags: [],
  ),
  Ingredient(
    id: 'tortilla_chips',
    name: {'en': 'Tortilla Chips', 'tr': 'Tortilla Cipsi'},
    category: IngredientCategory.snackFood,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'popcorn',
    name: {'en': 'Popcorn', 'tr': 'Patlamış Mısır'},
    category: IngredientCategory.snackFood,
    allergenTags: [],
  ),
  Ingredient(
    id: 'chocolate_bar',
    name: {'en': 'Chocolate Bar', 'tr': 'Çikolata'},
    category: IngredientCategory.snackFood,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'dark_chocolate',
    name: {'en': 'Dark Chocolate', 'tr': 'Bitter Çikolata'},
    category: IngredientCategory.snackFood,
    allergenTags: [],
  ),
  Ingredient(
    id: 'ice_cream',
    name: {'en': 'Ice Cream', 'tr': 'Dondurma'},
    category: IngredientCategory.snackFood,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'cookies',
    name: {'en': 'Cookies', 'tr': 'Kurabiye'},
    category: IngredientCategory.snackFood,
    allergenTags: ['gluten', 'dairy'],
  ),
  Ingredient(
    id: 'crackers',
    name: {'en': 'Crackers', 'tr': 'Kraker'},
    category: IngredientCategory.snackFood,
    allergenTags: ['gluten'],
  ),
  Ingredient(
    id: 'mixed_nuts',
    name: {'en': 'Mixed Nuts', 'tr': 'Karışık Kuruyemiş'},
    category: IngredientCategory.snackFood,
    allergenTags: ['nuts'],
  ),
  Ingredient(
    id: 'dried_fruit',
    name: {'en': 'Dried Fruit Mix', 'tr': 'Kuru Meyve Karışımı'},
    category: IngredientCategory.snackFood,
    allergenTags: [],
  ),
  Ingredient(
    id: 'granola_bar',
    name: {'en': 'Granola Bar', 'tr': 'Granola Bar'},
    category: IngredientCategory.snackFood,
    allergenTags: ['gluten', 'nuts'],
  ),
  Ingredient(
    id: 'rice_cake',
    name: {'en': 'Rice Cake', 'tr': 'Pirinç Patlağı'},
    category: IngredientCategory.snackFood,
    allergenTags: [],
  ),

  // ── Additional Vegetables (8) ────────────────────────────────────────
  Ingredient(
    id: 'corn',
    name: {'en': 'Corn', 'tr': 'Mısır'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'peas',
    name: {'en': 'Green Peas', 'tr': 'Bezelye'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'asparagus',
    name: {'en': 'Asparagus', 'tr': 'Kuşkonmaz'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'radish',
    name: {'en': 'Radish', 'tr': 'Turp'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'beet',
    name: {'en': 'Beetroot', 'tr': 'Pancar'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'okra',
    name: {'en': 'Okra', 'tr': 'Bamya'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),
  Ingredient(
    id: 'dill',
    name: {'en': 'Dill', 'tr': 'Dereotu'},
    category: IngredientCategory.spice,
    allergenTags: [],
  ),
  Ingredient(
    id: 'spring_onion',
    name: {'en': 'Spring Onion', 'tr': 'Yeşil Soğan'},
    category: IngredientCategory.vegetable,
    allergenTags: [],
  ),

  // ── Additional Fruits (7) ───────────────────────────────────────────
  Ingredient(
    id: 'mango',
    name: {'en': 'Mango', 'tr': 'Mango'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'pineapple',
    name: {'en': 'Pineapple', 'tr': 'Ananas'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'kiwi',
    name: {'en': 'Kiwi', 'tr': 'Kivi'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'pear',
    name: {'en': 'Pear', 'tr': 'Armut'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'blueberry',
    name: {'en': 'Blueberry', 'tr': 'Yaban Mersini'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'raspberry',
    name: {'en': 'Raspberry', 'tr': 'Ahududu'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),
  Ingredient(
    id: 'dates',
    name: {'en': 'Dates', 'tr': 'Hurma'},
    category: IngredientCategory.fruit,
    allergenTags: [],
  ),

  // ── Additional Condiments (4) ───────────────────────────────────────
  Ingredient(
    id: 'tahini',
    name: {'en': 'Tahini', 'tr': 'Tahin'},
    category: IngredientCategory.condiment,
    allergenTags: ['sesame'],
  ),
  Ingredient(
    id: 'pomegranate_molasses',
    name: {'en': 'Pomegranate Molasses', 'tr': 'Nar Ekşisi'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),
  Ingredient(
    id: 'peanut_butter',
    name: {'en': 'Peanut Butter', 'tr': 'Fıstık Ezmesi'},
    category: IngredientCategory.condiment,
    allergenTags: ['peanuts'],
  ),
  Ingredient(
    id: 'coconut_milk',
    name: {'en': 'Coconut Milk', 'tr': 'Hindistancevizi Sütü'},
    category: IngredientCategory.condiment,
    allergenTags: [],
  ),

  // ── Additional Dairy (3) ────────────────────────────────────────────
  Ingredient(
    id: 'cottage_cheese',
    name: {'en': 'Cottage Cheese', 'tr': 'Lor Peyniri'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'kefir',
    name: {'en': 'Kefir', 'tr': 'Kefir'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),
  Ingredient(
    id: 'greek_yogurt',
    name: {'en': 'Greek Yogurt', 'tr': 'Süzme Yoğurt'},
    category: IngredientCategory.dairy,
    allergenTags: ['dairy'],
  ),

  // ── Other (2) ─────────────────────────────────────────────────────────
  Ingredient(
    id: 'baking_powder',
    name: {'en': 'Baking Powder', 'tr': 'Kabartma Tozu'},
    category: IngredientCategory.other,
    allergenTags: [],
  ),
  Ingredient(
    id: 'yeast',
    name: {'en': 'Yeast', 'tr': 'Maya'},
    category: IngredientCategory.other,
    allergenTags: [],
  ),
];

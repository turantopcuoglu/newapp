/// Editorial content for the health categories in Explore → "For You".
///
/// Per category id from [specialCategories]:
///
/// 1. A plain-language explanation — which foods carry the nutrient and what
///    affects absorption. A list of recipes on its own never told the user
///    *why* those recipes were picked.
/// 2. The ingredients that carry the category. They become the product tiles
///    under the explanation, and each tile lists the recipes that contain that
///    ingredient *and* match the category.
/// 3. Red flags: when to see a doctor rather than adjust the plate.
///
/// Health language (until the physician signs an entry off, roadmap phase 4):
/// describe, do not prescribe. Say which foods *contain* a nutrient and what
/// affects absorption; never "to fix your deficiency", never "you must",
/// never cure/treatment wording ("PCOS'ta beslenmeyi destekleyen", not
/// "PCOS için"). Address the user as "sen". A test enforces the word list.
///
/// Ingredient ids must be canonical ids from `mock_ingredients.dart`: matching
/// is an exact id comparison, so a typo silently produces an empty tile. The
/// data report validates every id here.
library;

class HealthInfoSection {
  final Map<String, String> title;
  final Map<String, List<String>> items;

  const HealthInfoSection({required this.title, required this.items});

  String localizedTitle(String locale) =>
      title[locale] ?? title['en'] ?? title.values.first;

  List<String> localizedItems(String locale) =>
      items[locale] ?? items['en'] ?? items.values.first;
}

class HealthCategoryInfo {
  /// Opening paragraph: what the condition means for the plate.
  final Map<String, String> summary;

  /// Sources, tips — rendered as titled bullet lists.
  final List<HealthInfoSection> sections;

  /// Ingredients related to the condition, most representative first.
  final List<String> ingredientIds;

  /// "See a doctor if…" signs. Drafted by the team, so they stay off screen
  /// until [reviewed]: a symptom list is medical content even when it only
  /// points to a doctor.
  final Map<String, List<String>> redFlags;

  /// Set once the physician has signed the whole entry off, with the date
  /// and any remark in [reviewNote].
  final bool reviewed;
  final String? reviewNote;

  const HealthCategoryInfo({
    required this.summary,
    required this.sections,
    required this.ingredientIds,
    this.redFlags = const {},
    this.reviewed = false,
    this.reviewNote,
  });

  String localizedSummary(String locale) =>
      summary[locale] ?? summary['en'] ?? summary.values.first;

  /// Empty until reviewed; see [redFlags].
  List<String> visibleRedFlags(String locale) =>
      reviewed ? redFlags[locale] ?? redFlags['en'] ?? const [] : const [];
}

const Map<String, HealthCategoryInfo> healthCategoryInfo = {
  // ── Magnesium ────────────────────────────────────────────────────────────
  'magnesiumDeficiency': HealthCategoryInfo(
    summary: {
      'tr':
          'Magnezyum; kabak çekirdeği, ıspanak, badem ve baklagiller gibi besinlerde bulunur. Aşağıdaki malzeme kartları bu kaynakları içeren tarifleri listeler. Magnezyum düzeyinle ilgili bir endişen varsa değerlendirme için hekimine danış.',
      'en':
          'Magnesium is found in foods such as pumpkin seeds, spinach, almonds and legumes. The ingredient cards below list recipes that contain these sources. If you are concerned about your magnesium level, talk to your doctor.',
    },
    sections: [
      HealthInfoSection(
        title: {
          'tr': 'Magnezyum içeren besinler',
          'en': 'Foods that contain magnesium',
        },
        items: {
          'tr': [
            'Kuruyemiş ve tohumlar: kabak çekirdeği, badem, kaju, yer fıstığı',
            'Yeşil yapraklı sebzeler: ıspanak, pazı, kara lahana',
            'Baklagiller ve tahıllar: siyah fasulye, mercimek, nohut, yulaf',
            'Diğerleri: avokado, muz, en az %70 kakaolu bitter çikolata',
          ],
          'en': [
            'Nuts and seeds: pumpkin seeds, almonds, cashews, peanuts',
            'Leafy greens: spinach, swiss chard, kale',
            'Legumes and grains: black beans, lentils, chickpeas, oats',
            'Others: avocado, banana, dark chocolate (70%+)',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Mutfakta', 'en': 'In the kitchen'},
        items: {
          'tr': [
            'Baklagilleri pişirmeden önce suda bekletmek, mineral emilimini azaltan fitatı düşürebilir.',
            'Yeşil yaprakları uzun kaynatmak yerine kısa süre buharda pişirmek, suya geçen mineral kaybını azaltır.',
            'Bu besinleri tek öğünde toplamak yerine gün içine yayabilirsin.',
          ],
          'en': [
            'Soaking legumes before cooking can lower phytate, which reduces mineral absorption.',
            'Steaming greens briefly instead of boiling them keeps more minerals out of the cooking water.',
            'You can spread these foods across the day rather than in one meal.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'pumpkin_seeds',
      'spinach',
      'almond',
      'dark_chocolate',
      'avocado',
      'banana',
      'swiss_chard',
      'kale',
      'cashew',
      'walnut',
      'hazelnut',
      'peanut',
      'tahini',
      'sesame_seeds',
      'chia_seeds',
      'flax_seeds',
      'sunflower_seeds',
      'oats',
      'quinoa',
      'buckwheat',
      'bulgur',
      'black_bean',
      'kidney_bean',
      'white_bean',
      'red_lentil',
      'green_lentil',
      'chickpea',
      'tofu',
      'edamame',
      'cocoa_powder',
    ],
    redFlags: {
      'tr': ['Kas krampları, titreme ya da çarpıntı geçmiyorsa'],
      'en': ['Muscle cramps, tremor or palpitations that do not go away'],
    },
  ),

  // ── Iron ─────────────────────────────────────────────────────────────────
  'ironDeficiency': HealthCategoryInfo(
    summary: {
      'tr':
          'Demir iki biçimde bulunur: et ve balıktaki hem demir daha kolay emilir; baklagil ve yeşilliklerdeki demirin emilimi ise aynı öğünde bir C vitamini kaynağıyla artar. Demir düzeyinle ilgili bir endişen varsa tanı ve takip için hekimine danış.',
      'en':
          'Iron comes in two forms: heme iron in meat and fish is absorbed more easily, while iron from legumes and greens is absorbed better with a vitamin C source in the same meal. If you are concerned about your iron level, talk to your doctor for diagnosis and follow-up.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Demir içeren besinler', 'en': 'Foods that contain iron'},
        items: {
          'tr': [
            'Hayvansal (hem demir): ciğer, kırmızı et, kıyma, kuzu eti',
            'Baklagiller: mercimek, nohut, kuru fasulye, bakla',
            'Yeşillikler ve tohumlar: ıspanak, pazı, kabak çekirdeği, susam',
            'Kuru meyveler: kayısı, hurma',
          ],
          'en': [
            'Animal (heme iron): liver, red meat, ground beef, lamb',
            'Legumes: lentils, chickpeas, white beans, fava beans',
            'Greens and seeds: spinach, swiss chard, pumpkin seeds, sesame',
            'Dried fruit: apricots, dates',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Emilimi etkileyenler', 'en': 'What affects absorption'},
        items: {
          'tr': [
            'C vitamini: mercimeğe limon, salataya domates ya da biber eklemek bitkisel demirin emilimini artırır.',
            'Çay ve kahve: yemekle birlikte değil, bir süre sonra içildiğinde demir emilimini daha az etkiler.',
            'Kalsiyum: aynı öğündeki süt ürünleri demir emilimini azaltabilir.',
          ],
          'en': [
            'Vitamin C: lemon over lentils, tomato or pepper in the salad helps absorb plant iron.',
            'Tea and coffee: they affect iron absorption less when drunk a while after the meal rather than with it.',
            'Calcium: dairy in the same meal can reduce iron absorption.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'liver',
      'ground_beef',
      'beef_steak',
      'lamb',
      'veal',
      'spinach',
      'swiss_chard',
      'red_lentil',
      'green_lentil',
      'chickpea',
      'kidney_bean',
      'white_bean',
      'black_bean',
      'fava_bean',
      'pumpkin_seeds',
      'sesame_seeds',
      'eggs',
      'quinoa',
      'tofu',
      'dark_chocolate',
      'apricot',
      'dates',
    ],
    redFlags: {
      'tr': [
        'Belirgin halsizlik, nefes darlığı, çarpıntı ya da baş dönmesi',
        'Solukluk, tırnaklarda kırılma ya da buz/toprak yeme isteği',
        'Yoğun adet kanaması',
      ],
      'en': [
        'Marked tiredness, shortness of breath, palpitations or dizziness',
        'Pallor, brittle nails or cravings for ice or soil',
        'Heavy periods',
      ],
    },
  ),

  // ── Vitamin B12 ──────────────────────────────────────────────────────────
  'vitaminB12': HealthCategoryInfo(
    summary: {
      'tr':
          'B12 doğal olarak yalnızca hayvansal besinlerde bulunur: et, balık, yumurta ve süt ürünleri. Bitkisel beslenenler için zenginleştirilmiş ürünler ya da takviye gerekebilir; bunu hekiminle ya da diyetisyeninle konuş.',
      'en':
          'B12 occurs naturally only in animal foods: meat, fish, eggs and dairy. On a plant-based diet, fortified foods or a supplement may be needed; discuss this with your doctor or dietitian.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'B12 içeren besinler', 'en': 'Foods that contain B12'},
        items: {
          'tr': [
            'Sakatat ve kırmızı et: ciğer en yoğun kaynaktır',
            'Deniz ürünleri: somon, ton balığı, sardalya, midye, hamsi',
            'Yumurta ve süt ürünleri: yumurta, yoğurt, kefir, peynirler',
            'Kümes hayvanları: tavuk, hindi',
          ],
          'en': [
            'Organ and red meat: liver is the densest source',
            'Seafood: salmon, tuna, sardines, mussels, anchovies',
            'Eggs and dairy: eggs, yoghurt, kefir, cheeses',
            'Poultry: chicken, turkey',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Beslenme biçimine göre', 'en': 'By way of eating'},
        items: {
          'tr': [
            'Balık ve deniz ürünleri haftalık menüde B12 kaynağı olabilir.',
            'Vejetaryen beslenmede yumurta ve süt ürünleri B12 kaynağıdır.',
            'Vegan beslenmede B12 için zenginleştirilmiş ürün ya da takviye gerekir; miktarı hekiminle belirle.',
          ],
          'en': [
            'Fish and seafood can be B12 sources in the weekly menu.',
            'On a vegetarian diet, eggs and dairy provide B12.',
            'On a vegan diet, B12 has to come from fortified foods or a supplement; agree the amount with your doctor.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'liver',
      'salmon',
      'tuna',
      'sardine',
      'mussel',
      'anchovy',
      'eggs',
      'ground_beef',
      'beef_steak',
      'veal',
      'lamb',
      'chicken_breast',
      'chicken_thigh',
      'turkey_breast',
      'cod',
      'sea_bass',
      'sea_bream',
      'shrimp',
      'squid',
      'octopus',
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
    redFlags: {
      'tr': [
        'Ellerde ya da ayaklarda uyuşma, karıncalanma',
        'Denge sorunu, unutkanlık ya da belirgin halsizlik',
      ],
      'en': [
        'Numbness or tingling in hands or feet',
        'Balance problems, forgetfulness or marked tiredness',
      ],
    },
  ),

  // ── Anemia ───────────────────────────────────────────────────────────────
  'anemia': HealthCategoryInfo(
    summary: {
      'tr':
          'Kansızlığın birçok nedeni olabilir; tanısı ve nedeni hekim değerlendirmesiyle konur. Beslenme tarafında, demir içeren besinlerle C vitamini kaynaklarını aynı öğünde buluşturmak bitkisel demirin emilimini artırır.',
      'en':
          'Anemia can have many causes; its diagnosis and cause are for your doctor to assess. On the food side, pairing iron-containing foods with a vitamin C source in the same meal helps absorb plant iron.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Tabakta bir arada', 'en': 'Together on the plate'},
        items: {
          'tr': [
            'Demir içerenler: ciğer, kırmızı et, mercimek, nohut, ıspanak',
            'C vitamini içerenler: limon, portakal, domates, biber, maydanoz',
            'Diğerleri: nar, kuru kayısı, hurma, kabak çekirdeği',
          ],
          'en': [
            'Iron: liver, red meat, lentils, chickpeas, spinach',
            'Vitamin C: lemon, orange, tomato, pepper, parsley',
            'Others: pomegranate, dried apricots, dates, pumpkin seeds',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Pratik', 'en': 'In practice'},
        items: {
          'tr': [
            'Mercimek çorbasına limon sıkmak öğüne C vitamini ekler.',
            'Salataya domates ya da kırmızı biber eklemek de aynı işi görür.',
            'Çayı yemekle birlikte değil, bir süre sonra içmeyi deneyebilirsin.',
          ],
          'en': [
            'A squeeze of lemon adds vitamin C to lentil soup.',
            'Tomato or red pepper in the salad does the same.',
            'You can try having tea a while after the meal rather than with it.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'liver',
      'ground_beef',
      'beef_steak',
      'lamb',
      'spinach',
      'swiss_chard',
      'red_lentil',
      'green_lentil',
      'chickpea',
      'kidney_bean',
      'white_bean',
      'pomegranate',
      'lemon',
      'orange',
      'tangerine',
      'grapefruit',
      'tomato',
      'bell_pepper',
      'broccoli',
      'parsley',
      'strawberry',
      'eggs',
      'quinoa',
      'tofu',
      'pumpkin_seeds',
      'dark_chocolate',
      'apricot',
      'dates',
    ],
    redFlags: {
      'tr': [
        'Nefes darlığı, çarpıntı, göğüs ağrısı ya da bayılma hissi',
        'Siyah dışkı, kanlı dışkı ya da beklenmeyen kanama',
        'Yoğun adet kanaması',
      ],
      'en': [
        'Shortness of breath, palpitations, chest pain or feeling faint',
        'Black or bloody stools, or unexpected bleeding',
        'Heavy periods',
      ],
    },
  ),

  // ── PCOS ─────────────────────────────────────────────────────────────────
  'pcos': HealthCategoryInfo(
    summary: {
      'tr':
          'PCOS\'ta beslenmeyi destekleyen öğünlerde kompleks karbonhidrat genellikle protein, lif ve sağlıklı yağla birlikte yer alır. Bu tür tabaklar kan şekerinin daha dengeli seyretmesine yardımcı olabilir. Beslenme planın için hekimine ya da diyetisyenine danış.',
      'en':
          'Meals that support eating with PCOS usually pair complex carbohydrates with protein, fibre and healthy fat. Plates like these can help keep blood sugar steadier. Talk to your doctor or dietitian about your eating plan.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Öne çıkan besinler', 'en': 'Foods that feature'},
        items: {
          'tr': [
            'Lifli tahıllar: yulaf, kinoa, karabuğday, bulgur',
            'Protein: yumurta, tavuk, somon, yoğurt, baklagiller',
            'Sağlıklı yağlar: avokado, zeytinyağı, ceviz, badem',
            'Sebzeler: brokoli, ıspanak, karnabahar, kabak',
          ],
          'en': [
            'High-fibre grains: oats, quinoa, buckwheat, bulgur',
            'Protein: eggs, chicken, salmon, yoghurt, legumes',
            'Healthy fats: avocado, olive oil, walnuts, almonds',
            'Vegetables: broccoli, spinach, cauliflower, courgette',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Öğün kurarken', 'en': 'Building a meal'},
        items: {
          'tr': [
            'Karbonhidratın yanına bir protein ya da yağ kaynağı ekleyebilirsin.',
            'Rafine şeker ve beyaz un yerine tam tahılları seçebilirsin.',
            'Uzun aralıklar yerine düzenli, dengeli öğünler bir seçenek.',
          ],
          'en': [
            'You can add a protein or fat source next to the carbohydrate.',
            'You can choose whole grains over refined sugar and white flour.',
            'Regular, balanced meals are an option instead of long gaps.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'oats',
      'quinoa',
      'buckwheat',
      'bulgur',
      'eggs',
      'chicken_breast',
      'salmon',
      'greek_yogurt',
      'chickpea',
      'red_lentil',
      'green_lentil',
      'white_bean',
      'avocado',
      'olive_oil',
      'walnut',
      'almond',
      'chia_seeds',
      'flax_seeds',
      'pumpkin_seeds',
      'broccoli',
      'spinach',
      'cauliflower',
      'zucchini',
      'blueberry',
      'cinnamon',
      'tahini',
    ],
    redFlags: {
      'tr': [
        'Adetlerin çok düzensizse ya da hiç olmuyorsa',
        'Kısa sürede belirgin kilo değişimi',
        'Aşırı susama ya da sık idrara çıkma',
      ],
      'en': [
        'Very irregular or absent periods',
        'Marked weight change over a short time',
        'Excessive thirst or frequent urination',
      ],
    },
  ),

  // ── Insulin resistance ───────────────────────────────────────────────────
  'insulinResistance': HealthCategoryInfo(
    summary: {
      'tr':
          'İnsülin direncinde öğüne lif ve proteinle başlayıp karbonhidrata sonra geçmek, kan şekerindeki yükselişi yavaşlatabilir. Beslenme planın için hekimine ya da diyetisyenine danış.',
      'en':
          'With insulin resistance, starting a meal with fibre and protein and having the carbohydrate later can slow the rise in blood sugar. Talk to your doctor or dietitian about your eating plan.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Öne çıkan besinler', 'en': 'Foods that feature'},
        items: {
          'tr': [
            'Tam tahıllar: yulaf, bulgur, kinoa, karabuğday, tam buğday',
            'Baklagiller: mercimek, nohut, kuru fasulye',
            'Protein ve yağ: yumurta, yoğurt, ceviz, badem, zeytinyağı',
            'Düşük glisemik indeksli meyveler: elma, armut, yaban mersini',
          ],
          'en': [
            'Whole grains: oats, bulgur, quinoa, buckwheat, whole wheat',
            'Legumes: lentils, chickpeas, beans',
            'Protein and fat: eggs, yoghurt, walnuts, almonds, olive oil',
            'Low-glycaemic fruit: apple, pear, blueberries',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Alışkanlıklar', 'en': 'Habits'},
        items: {
          'tr': [
            'Meyveyi bir avuç kuruyemişle birlikte yiyebilirsin.',
            'Yemekten sonra 10–15 dakikalık bir yürüyüş, kan şekeri yükselişini azaltabilir.',
            'Meyve suyu yerine meyvenin kendisi: lif meyvede.',
          ],
          'en': [
            'You can have fruit with a handful of nuts.',
            'A 10–15 minute walk after a meal can reduce the rise in blood sugar.',
            'The fruit rather than the juice: the fibre is in the fruit.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'oats',
      'bulgur',
      'quinoa',
      'buckwheat',
      'whole_wheat_flour',
      'red_lentil',
      'green_lentil',
      'chickpea',
      'white_bean',
      'black_bean',
      'eggs',
      'greek_yogurt',
      'yogurt',
      'chicken_breast',
      'salmon',
      'walnut',
      'almond',
      'chia_seeds',
      'flax_seeds',
      'avocado',
      'olive_oil',
      'broccoli',
      'spinach',
      'cauliflower',
      'apple',
      'pear',
      'blueberry',
      'cinnamon',
    ],
    redFlags: {
      'tr': [
        'Aşırı susama, sık idrara çıkma ya da açıklanamayan kilo kaybı',
        'Bulanık görme ya da yaraların geç iyileşmesi',
      ],
      'en': [
        'Excessive thirst, frequent urination or unexplained weight loss',
        'Blurred vision or slow-healing wounds',
      ],
    },
  ),

  // ── Gluten free ──────────────────────────────────────────────────────────
  'glutenFree': HealthCategoryInfo(
    summary: {
      'tr':
          'Glutensiz beslenmede buğday, arpa ve çavdar dışarıda kalır. Karabuğday, kinoa, pirinç ve mısır gibi tahıllar doğal olarak glutensizdir. Çölyak şüphen varsa glutensiz beslenmeye başlamadan önce hekimine danış.',
      'en':
          'A gluten-free diet leaves out wheat, barley and rye. Buckwheat, quinoa, rice and corn are naturally gluten-free. If you suspect coeliac disease, talk to your doctor before going gluten-free.',
    },
    sections: [
      HealthInfoSection(
        title: {
          'tr': 'Glutensiz tahıl ve nişastalar',
          'en': 'Gluten-free grains and starches',
        },
        items: {
          'tr': [
            'Tahıllar: pirinç, kinoa, karabuğday, mısır unu',
            'Nişastalı sebzeler: patates, tatlı patates, mısır',
            'Baklagiller: mercimek, nohut, fasulye',
            'Kuruyemiş ve tohumlar: badem, ceviz, susam, tahin',
          ],
          'en': [
            'Grains: rice, quinoa, buckwheat, cornmeal',
            'Starchy vegetables: potato, sweet potato, corn',
            'Legumes: lentils, chickpeas, beans',
            'Nuts and seeds: almonds, walnuts, sesame, tahini',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Gizli gluten', 'en': 'Hidden gluten'},
        items: {
          'tr': [
            'Sos, çorba bazı ve hazır baharat karışımlarında un olabilir.',
            'Aynı tencerede makarna haşlanmışsa çapraz bulaşma olabilir.',
            'Yulafı yalnızca "glutensiz" etiketliyse seç.',
          ],
          'en': [
            'Sauces, soup bases and spice blends can contain flour.',
            'Cross-contamination can happen if pasta was boiled in the same pot.',
            'Only use oats labelled gluten-free.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'white_rice',
      'brown_rice',
      'basmati_rice',
      'quinoa',
      'buckwheat',
      'cornmeal',
      'corn',
      'potato',
      'sweet_potato',
      'red_lentil',
      'green_lentil',
      'chickpea',
      'white_bean',
      'black_bean',
      'eggs',
      'almond',
      'walnut',
      'tahini',
      'sesame_seeds',
      'avocado',
      'spinach',
      'tomato',
      'yogurt',
      'chicken_breast',
      'salmon',
    ],
    redFlags: {
      'tr': [
        'Uzun süren ishal, karın ağrısı ya da kilo kaybı',
        'Çölyak testi yapılacaksa: glutensiz beslenmeye testten önce başlamak sonucu etkileyebilir',
      ],
      'en': [
        'Long-lasting diarrhoea, abdominal pain or weight loss',
        'If a coeliac test is planned: going gluten-free before the test can affect the result',
      ],
    },
  ),

  // ── Lactose free ─────────────────────────────────────────────────────────
  'lactoseFree': HealthCategoryInfo(
    summary: {
      'tr':
          'Süt ürünlerini azalttığında kalsiyum kaynaklarına dikkat etmek gerekir: tahin, susam, badem, kara lahana ve kılçığıyla yenen sardalya kalsiyum içerir.',
      'en':
          'When you cut down on dairy, calcium is what needs watching: tahini, sesame, almonds, kale and bone-in sardines contain calcium.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Sütsüz kalsiyum kaynakları', 'en': 'Dairy-free calcium'},
        items: {
          'tr': [
            'Tohum ve ezmeler: tahin, susam, chia, badem',
            'Yeşillikler: kara lahana, ıspanak, pazı, brokoli',
            'Deniz ürünleri: sardalya, hamsi',
            'Baklagiller: nohut, beyaz fasulye, tofu',
          ],
          'en': [
            'Seeds and pastes: tahini, sesame, chia, almonds',
            'Greens: kale, spinach, swiss chard, broccoli',
            'Seafood: sardines, anchovies',
            'Legumes: chickpeas, white beans, tofu',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Mutfakta değişiklikler', 'en': 'Swaps in the kitchen'},
        items: {
          'tr': [
            'Kremalı soslarda süt yerine hindistan cevizi sütü kullanabilirsin.',
            'Tereyağı yerine zeytinyağı ya da avokado yağı ile pişirebilirsin.',
            'Yoğurt yerine tahin-limon sosu deneyebilirsin.',
          ],
          'en': [
            'You can use coconut milk instead of dairy in creamy sauces.',
            'You can cook with olive or avocado oil in place of butter.',
            'You can try a tahini-lemon sauce where yoghurt would go.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'tahini',
      'sesame_seeds',
      'almond',
      'kale',
      'spinach',
      'swiss_chard',
      'broccoli',
      'sardine',
      'anchovy',
      'salmon',
      'chickpea',
      'white_bean',
      'tofu',
      'chia_seeds',
      'coconut_milk',
      'olive_oil',
      'avocado',
      'eggs',
      'quinoa',
      'oats',
      'fig',
      'orange',
    ],
    redFlags: {
      'tr': [
        'Süt ürünlerinden sonra şiddetli karın ağrısı, kusma ya da kanlı dışkı',
        'Dudak, dil ya da boğazda şişme, nefes almada zorluk (acil)',
      ],
      'en': [
        'Severe abdominal pain, vomiting or bloody stools after dairy',
        'Swelling of lips, tongue or throat, or difficulty breathing (emergency)',
      ],
    },
  ),

  // ── Period support ───────────────────────────────────────────────────────
  'periodSupport': HealthCategoryInfo(
    summary: {
      'tr':
          'Regl döneminde demir ve magnezyum içeren besinler öne çıkar; sıcak ve sindirimi kolay öğünler de birçok kişiye iyi gelir. Aşağıdaki kartlar bu besinleri içeren tarifleri listeler.',
      'en':
          'During your period, foods with iron and magnesium come forward, and many people find warm, easy-to-digest meals comforting. The cards below list recipes that contain these foods.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Öne çıkan besinler', 'en': 'Foods that feature'},
        items: {
          'tr': [
            'Magnezyum içerenler: kabak çekirdeği, bitter çikolata, tahin, ıspanak',
            'Demir içerenler: ciğer, kırmızı et, mercimek, pazı',
            'Sıcak ve hafif seçenekler: zencefil, nane, muz, yulaf',
            'Omega-3 içerenler: somon, ceviz, chia tohumu',
          ],
          'en': [
            'Magnesium: pumpkin seeds, dark chocolate, tahini, spinach',
            'Iron: liver, red meat, lentils, swiss chard',
            'Warm, light options: ginger, mint, banana, oats',
            'Omega-3: salmon, walnuts, chia seeds',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Bu dönemde', 'en': 'During these days'},
        items: {
          'tr': [
            'Sıcak içecekler ve çorbalar birçok kişiye rahatlatıcı gelir.',
            'Tuzu azaltmak su tutulumuna bağlı şişkinliği azaltabilir.',
            'Şekerli atıştırmalık yerine bitter çikolata ve kuruyemiş seçebilirsin.',
          ],
          'en': [
            'Many people find warm drinks and soups soothing.',
            'Cutting down on salt can reduce bloating from water retention.',
            'You can swap sugary snacks for dark chocolate with nuts.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'pumpkin_seeds',
      'dark_chocolate',
      'tahini',
      'spinach',
      'swiss_chard',
      'banana',
      'oats',
      'ginger',
      'mint',
      'salmon',
      'walnut',
      'chia_seeds',
      'red_lentil',
      'green_lentil',
      'liver',
      'ground_beef',
      'dates',
      'pomegranate',
      'almond',
      'yogurt',
      'sweet_potato',
    ],
    redFlags: {
      'tr': [
        'Ağrı kesiciye yanıt vermeyen ya da günlük işlerini engelleyen ağrı',
        'Bir-iki saatte ped/tampon değiştirecek kadar yoğun kanama',
        'Adet dışı kanama ya da adetin aniden düzensizleşmesi',
      ],
      'en': [
        'Pain that does not respond to painkillers or stops daily activities',
        'Bleeding heavy enough to change a pad or tampon every hour or two',
        'Bleeding between periods or a sudden change in your cycle',
      ],
    },
  ),
};

/// Editorial content for the health categories in Explore → "For You".
///
/// Two things live here, both per category id from [specialCategories]:
///
/// 1. A plain-language explanation of the condition — what to eat, where the
///    nutrient comes from, and how to actually absorb it. A list of recipes on
///    its own never told the user *why* those recipes were picked.
/// 2. The ingredients that carry the category. They become the product tiles
///    under the explanation, and each tile lists the recipes that contain that
///    ingredient *and* match the category.
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

  const HealthCategoryInfo({
    required this.summary,
    required this.sections,
    required this.ingredientIds,
  });

  String localizedSummary(String locale) =>
      summary[locale] ?? summary['en'] ?? summary.values.first;
}

const Map<String, HealthCategoryInfo> healthCategoryInfo = {
  // ── Magnesium ───────────────────────────────────────────────────────────
  'magnesiumDeficiency': HealthCategoryInfo(
    summary: {
      'tr': 'Magnezyum eksikliğini gidermek için günlük diyetinize kabak '
          'çekirdeği, ıspanak ve badem gibi zengin gıdaları eklemelisiniz. Bu '
          'minerali vücudun daha iyi kullanabilmesi için doğru besin '
          'gruplarından seçmek önemlidir.',
      'en': 'To close a magnesium gap, build the day around pumpkin seeds, '
          'spinach and almonds. Choosing the right food groups matters as '
          'much as the amount, because that is what your body can actually '
          'absorb.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'En iyi magnezyum kaynakları', 'en': 'Best sources'},
        items: {
          'tr': [
            'Kuruyemiş ve tohumlar: kabak çekirdeği, badem, kaju, yer fıstığı',
            'Yeşil yapraklı sebzeler: ıspanak, pazı, kara lahana',
            'Baklagiller ve tahıllar: siyah fasulye, mercimek, nohut, yulaf',
            'Meyve ve diğerleri: avokado, muz, en az %70 kakaolu bitter '
                'çikolata',
          ],
          'en': [
            'Nuts and seeds: pumpkin seeds, almonds, cashews, peanuts',
            'Leafy greens: spinach, swiss chard, kale',
            'Legumes and grains: black beans, lentils, chickpeas, oats',
            'Fruit and others: avocado, banana, dark chocolate (70%+)',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Emilimi artıran ipuçları', 'en': 'Absorption tips'},
        items: {
          'tr': [
            'Suda bekletme: kuruyemiş ve baklagilleri yemeden önce suda '
                'bekletmek emilimi artırır.',
            'Hafif pişirme: ıspanak gibi sebzeleri kaynatmak yerine buharda '
                'kısa süre pişirin.',
            'Güne yayın: magnezyumu tek öğünde değil, gün içine dağıtarak alın.',
          ],
          'en': [
            'Soak first: soaking nuts and legumes before cooking improves '
                'absorption.',
            'Cook gently: steam greens like spinach briefly instead of '
                'boiling them.',
            'Spread it out: take magnesium across the day rather than in one '
                'meal.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'pumpkin_seeds', 'spinach', 'almond', 'dark_chocolate', 'avocado',
      'banana', 'swiss_chard', 'kale', 'cashew', 'walnut', 'hazelnut',
      'peanut', 'tahini', 'sesame_seeds', 'chia_seeds', 'flax_seeds',
      'sunflower_seeds', 'oats', 'quinoa', 'buckwheat', 'bulgur',
      'black_bean', 'kidney_bean', 'white_bean', 'red_lentil', 'green_lentil',
      'chickpea', 'tofu', 'edamame', 'cocoa_powder',
    ],
  ),

  // ── Iron ────────────────────────────────────────────────────────────────
  'ironDeficiency': HealthCategoryInfo(
    summary: {
      'tr': 'Demir eksikliğinde iki tür demir işinize yarar: ette bulunan hem '
          'demir kolay emilir, bitkisel kaynaklardaki demir ise C vitamini ile '
          'birlikte alındığında çok daha iyi değerlendirilir. Tabağınızı bu '
          'ikiliyi bir araya getirecek şekilde kurun.',
      'en': 'Two kinds of iron matter here: heme iron from meat is absorbed '
          'easily, while plant iron needs vitamin C alongside it to be used '
          'well. Build the plate so the two meet.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'En iyi demir kaynakları', 'en': 'Best sources'},
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
        title: {'tr': 'Emilimi artıran ipuçları', 'en': 'Absorption tips'},
        items: {
          'tr': [
            'C vitamini ekleyin: mercimek yemeğinin yanına limon, salatanıza '
                'domates veya biber koyun.',
            'Çay ve kahveyi ayırın: yemekle birlikte değil, en az bir saat '
                'sonra için.',
            'Süt ürünlerini aynı öğüne koymayın: kalsiyum demir emilimini '
                'azaltır.',
          ],
          'en': [
            'Add vitamin C: lemon over lentils, tomato or pepper in the salad.',
            'Move tea and coffee: drink them at least an hour after the meal, '
                'not with it.',
            'Keep dairy separate: calcium competes with iron in the same meal.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'liver', 'ground_beef', 'beef_steak', 'lamb', 'veal', 'spinach',
      'swiss_chard', 'red_lentil', 'green_lentil', 'chickpea', 'kidney_bean',
      'white_bean', 'black_bean', 'fava_bean', 'pumpkin_seeds',
      'sesame_seeds', 'eggs', 'quinoa', 'tofu', 'dark_chocolate', 'apricot',
      'dates',
    ],
  ),

  // ── Vitamin B12 ─────────────────────────────────────────────────────────
  'vitaminB12': HealthCategoryInfo(
    summary: {
      'tr': 'B12 yalnızca hayvansal gıdalarda doğal olarak bulunur: et, '
          'balık, yumurta ve süt ürünleri. Bitkisel beslenenlerin '
          'zenginleştirilmiş ürünlere veya takviyeye ihtiyacı olur.',
      'en': 'B12 occurs naturally only in animal foods — meat, fish, eggs and '
          'dairy. On a plant-based diet it has to come from fortified foods '
          'or a supplement.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'En iyi B12 kaynakları', 'en': 'Best sources'},
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
        title: {'tr': 'Dikkat edilecekler', 'en': 'What to watch'},
        items: {
          'tr': [
            'Haftada iki kez balık, B12 ihtiyacının önemli kısmını karşılar.',
            'Vejetaryen beslenmede yumurta ve süt ürünlerini ihmal etmeyin.',
            'Vegan beslenmede B12 mutlaka takviye veya zenginleştirilmiş '
                'ürünle alınmalıdır.',
          ],
          'en': [
            'Fish twice a week covers a large part of the weekly need.',
            'On a vegetarian diet, keep eggs and dairy in the rotation.',
            'On a vegan diet, B12 must come from a supplement or fortified '
                'foods.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'liver', 'salmon', 'tuna', 'sardine', 'mussel', 'anchovy', 'eggs',
      'ground_beef', 'beef_steak', 'veal', 'lamb', 'chicken_breast',
      'chicken_thigh', 'turkey_breast', 'cod', 'sea_bass', 'sea_bream',
      'shrimp', 'squid', 'octopus', 'milk', 'yogurt', 'greek_yogurt',
      'kefir', 'cheddar_cheese', 'feta_cheese', 'parmesan', 'mozzarella',
      'goat_cheese', 'ricotta',
    ],
  ),

  // ── Anemia ──────────────────────────────────────────────────────────────
  'anemia': HealthCategoryInfo(
    summary: {
      'tr': 'Kansızlıkta demir tek başına yetmez: demiri taşıyan besinlerle C '
          'vitamini kaynaklarını aynı öğünde buluşturmak, emilen demir '
          'miktarını kat kat artırır.',
      'en': 'Iron alone is not enough with anemia: pairing iron-rich foods '
          'with vitamin C in the same meal multiplies how much of it you '
          'actually absorb.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Tabakta olması gerekenler', 'en': 'What to put on the plate'},
        items: {
          'tr': [
            'Demir kaynağı: ciğer, kırmızı et, mercimek, nohut, ıspanak',
            'C vitamini kaynağı: limon, portakal, domates, biber, maydanoz',
            'Destekleyiciler: nar, kuru kayısı, hurma, kabak çekirdeği',
          ],
          'en': [
            'Iron: liver, red meat, lentils, chickpeas, spinach',
            'Vitamin C: lemon, orange, tomato, pepper, parsley',
            'Support: pomegranate, dried apricots, dates, pumpkin seeds',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Pratik ipuçları', 'en': 'Practical tips'},
        items: {
          'tr': [
            'Mercimek çorbasını limonsuz içmeyin.',
            'Salatanıza her zaman domates veya kırmızı biber ekleyin.',
            'Yemekten hemen sonra çay içme alışkanlığını bırakın.',
          ],
          'en': [
            'Never drink lentil soup without a squeeze of lemon.',
            'Always add tomato or red pepper to the salad.',
            'Drop the habit of tea right after a meal.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'liver', 'ground_beef', 'beef_steak', 'lamb', 'spinach', 'swiss_chard',
      'red_lentil', 'green_lentil', 'chickpea', 'kidney_bean', 'white_bean',
      'pomegranate', 'lemon', 'orange', 'tangerine', 'grapefruit', 'tomato',
      'bell_pepper', 'broccoli', 'parsley', 'strawberry', 'eggs', 'quinoa',
      'tofu', 'pumpkin_seeds', 'dark_chocolate', 'apricot', 'dates',
    ],
  ),

  // ── PCOS ────────────────────────────────────────────────────────────────
  'pcos': HealthCategoryInfo(
    summary: {
      'tr': 'PCOS\'ta amaç kan şekerini dalgalandırmayan öğünler kurmak: '
          'kompleks karbonhidratı protein, lif ve sağlıklı yağla birlikte '
          'yiyerek insülin yanıtını yumuşatırsınız.',
      'en': 'With PCOS the goal is meals that keep blood sugar steady: pair '
          'complex carbohydrates with protein, fibre and healthy fat to blunt '
          'the insulin response.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Öne çıkan besinler', 'en': 'Foods that help'},
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
        title: {'tr': 'Öğün kurma ipuçları', 'en': 'Building a meal'},
        items: {
          'tr': [
            'Karbonhidratı asla yalnız yemeyin; yanına protein veya yağ '
                'ekleyin.',
            'Rafine şeker ve beyaz un yerine tam tahılı tercih edin.',
            'Öğün atlamak yerine düzenli ve dengeli porsiyonlarla ilerleyin.',
          ],
          'en': [
            'Never eat carbohydrate alone — add protein or fat beside it.',
            'Choose whole grains over refined sugar and white flour.',
            'Keep regular, balanced portions instead of skipping meals.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'oats', 'quinoa', 'buckwheat', 'bulgur', 'eggs', 'chicken_breast',
      'salmon', 'greek_yogurt', 'chickpea', 'red_lentil', 'green_lentil',
      'white_bean', 'avocado', 'olive_oil', 'walnut', 'almond', 'chia_seeds',
      'flax_seeds', 'pumpkin_seeds', 'broccoli', 'spinach', 'cauliflower',
      'zucchini', 'blueberry', 'cinnamon', 'tahini',
    ],
  ),

  // ── Insulin resistance ──────────────────────────────────────────────────
  'insulinResistance': HealthCategoryInfo(
    summary: {
      'tr': 'İnsülin direncinde tabağın sırası önemlidir: lif ve proteinle '
          'başlayıp karbonhidrata sonra geçmek, kan şekerinin daha yavaş '
          'yükselmesini sağlar.',
      'en': 'With insulin resistance the order on the plate matters: starting '
          'with fibre and protein before the carbohydrate slows the rise in '
          'blood sugar.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Tercih edilecekler', 'en': 'What to favour'},
        items: {
          'tr': [
            'Tam tahıllar: yulaf, bulgur, kinoa, karabuğday, tam buğday',
            'Baklagiller: mercimek, nohut, kuru fasulye',
            'Protein ve yağ: yumurta, yoğurt, ceviz, badem, zeytinyağı',
            'Düşük glisemikli meyveler: elma, armut, yaban mersini',
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
        title: {'tr': 'Kan şekerini dengeleyen alışkanlıklar', 'en': 'Habits that steady blood sugar'},
        items: {
          'tr': [
            'Meyveyi tek başına değil, bir avuç kuruyemişle birlikte yiyin.',
            'Yemekten sonra 10-15 dakika yürüyüş şeker yanıtını düşürür.',
            'Meyve suyu yerine meyvenin kendisini tüketin; lif orada.',
          ],
          'en': [
            'Eat fruit with a handful of nuts rather than on its own.',
            'A 10–15 minute walk after a meal lowers the glucose response.',
            'Eat the fruit, not the juice — the fibre is in the fruit.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'oats', 'bulgur', 'quinoa', 'buckwheat', 'whole_wheat_flour',
      'red_lentil', 'green_lentil', 'chickpea', 'white_bean', 'black_bean',
      'eggs', 'greek_yogurt', 'yogurt', 'chicken_breast', 'salmon',
      'walnut', 'almond', 'chia_seeds', 'flax_seeds', 'avocado', 'olive_oil',
      'broccoli', 'spinach', 'cauliflower', 'apple', 'pear', 'blueberry',
      'cinnamon',
    ],
  ),

  // ── Gluten free ─────────────────────────────────────────────────────────
  'glutenFree': HealthCategoryInfo(
    summary: {
      'tr': 'Glutensiz beslenmede buğday, arpa ve çavdar tamamen dışarıda '
          'kalır. İyi haber şu ki karabuğday, kinoa, pirinç ve mısır gibi '
          'doğal olarak glutensiz tahıllar aynı doygunluğu verir.',
      'en': 'A gluten-free diet leaves out wheat, barley and rye entirely. '
          'The good news: buckwheat, quinoa, rice and corn are naturally '
          'gluten-free and just as filling.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'Güvenli tahıl ve nişastalar', 'en': 'Safe grains and starches'},
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
            'Aynı tencerede makarna haşlanmışsa çapraz bulaşma riski vardır.',
            'Yulafı yalnızca "glutensiz" etiketliyse tercih edin.',
          ],
          'en': [
            'Sauces, soup bases and spice blends can contain flour.',
            'Cross-contamination is real if pasta was boiled in the same pot.',
            'Only use oats labelled gluten-free.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'white_rice', 'brown_rice', 'basmati_rice', 'quinoa', 'buckwheat',
      'cornmeal', 'corn', 'potato', 'sweet_potato', 'red_lentil',
      'green_lentil', 'chickpea', 'white_bean', 'black_bean', 'eggs',
      'almond', 'walnut', 'tahini', 'sesame_seeds', 'avocado', 'spinach',
      'tomato', 'yogurt', 'chicken_breast', 'salmon',
    ],
  ),

  // ── Lactose free ────────────────────────────────────────────────────────
  'lactoseFree': HealthCategoryInfo(
    summary: {
      'tr': 'Süt ürünlerini bıraktığınızda asıl dikkat edilecek şey kalsiyum: '
          'tahin, susam, badem, kara lahana ve kılçığıyla yenen sardalya bu '
          'boşluğu doldurur.',
      'en': 'When dairy goes, calcium is what needs watching: tahini, sesame, '
          'almonds, kale and bone-in sardines fill the gap.',
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
        title: {'tr': 'Mutfakta değiştirmeler', 'en': 'Swaps in the kitchen'},
        items: {
          'tr': [
            'Kremalı soslarda süt yerine hindistan cevizi sütü kullanın.',
            'Tereyağı yerine zeytinyağı veya avokado yağı ile pişirin.',
            'Yoğurt yerine tahin-limon sosu deneyin.',
          ],
          'en': [
            'Use coconut milk instead of dairy in creamy sauces.',
            'Cook with olive or avocado oil in place of butter.',
            'Try a tahini-lemon sauce where yoghurt would go.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'tahini', 'sesame_seeds', 'almond', 'kale', 'spinach', 'swiss_chard',
      'broccoli', 'sardine', 'anchovy', 'salmon', 'chickpea', 'white_bean',
      'tofu', 'chia_seeds', 'coconut_milk', 'olive_oil', 'avocado',
      'eggs', 'quinoa', 'oats', 'fig', 'orange',
    ],
  ),

  // ── Period support ──────────────────────────────────────────────────────
  'periodSupport': HealthCategoryInfo(
    summary: {
      'tr': 'Regl döneminde kaybedilen demiri geri koymak ve kramplara iyi '
          'gelen magnezyumu artırmak iki temel hedeftir. Bunun üstüne sıcak, '
          'sindirimi kolay ve şeker dalgalanması yaratmayan öğünler ekleyin.',
      'en': 'Two goals during your period: replace the iron you lose and lift '
          'the magnesium that eases cramps. On top of that, keep meals warm, '
          'easy to digest and free of sugar spikes.',
    },
    sections: [
      HealthInfoSection(
        title: {'tr': 'İşe yarayan besinler', 'en': 'Foods that help'},
        items: {
          'tr': [
            'Magnezyum: kabak çekirdeği, bitter çikolata, tahin, ıspanak',
            'Demir: ciğer, kırmızı et, mercimek, pazı',
            'Yatıştırıcılar: zencefil, nane, muz, yulaf',
            'Omega-3: somon, ceviz, chia tohumu',
          ],
          'en': [
            'Magnesium: pumpkin seeds, dark chocolate, tahini, spinach',
            'Iron: liver, red meat, lentils, swiss chard',
            'Soothing foods: ginger, mint, banana, oats',
            'Omega-3: salmon, walnuts, chia seeds',
          ],
        },
      ),
      HealthInfoSection(
        title: {'tr': 'Krampları hafifletmek için', 'en': 'Easing cramps'},
        items: {
          'tr': [
            'Sıcak içecek ve çorbalar kasılmayı yumuşatır.',
            'Tuzu azaltmak şişkinliği belirgin şekilde düşürür.',
            'Şekerli atıştırmalık yerine bitter çikolata + kuruyemiş seçin.',
          ],
          'en': [
            'Warm drinks and soups relax the cramping.',
            'Cutting salt visibly reduces bloating.',
            'Swap sugary snacks for dark chocolate with nuts.',
          ],
        },
      ),
    ],
    ingredientIds: [
      'pumpkin_seeds', 'dark_chocolate', 'tahini', 'spinach', 'swiss_chard',
      'banana', 'oats', 'ginger', 'mint', 'salmon', 'walnut', 'chia_seeds',
      'red_lentil', 'green_lentil', 'liver', 'ground_beef', 'dates',
      'pomegranate', 'almond', 'yogurt', 'sweet_potato',
    ],
  ),
};

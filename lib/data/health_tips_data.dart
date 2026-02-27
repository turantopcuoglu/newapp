import '../core/enums.dart';

class HealthTip {
  final Map<String, String> title;
  final Map<String, String> body;
  final String icon;

  const HealthTip({
    required this.title,
    required this.body,
    this.icon = '',
  });
}

class MoodFoodTip {
  final CheckInType checkInType;
  final Map<String, String> title;
  final Map<String, String> body;

  const MoodFoodTip({
    required this.checkInType,
    required this.title,
    required this.body,
  });
}

/// Daily health tips - rotating based on day of year
const List<HealthTip> dailyHealthTips = [
  HealthTip(
    title: {
      'en': 'Hydration Matters',
      'tr': 'Su İçmeyi Unutmayın',
    },
    body: {
      'en':
          'Drinking at least 2 liters of water daily supports metabolism, brain function, and skin health. Try starting your morning with a glass of warm water and lemon.',
      'tr':
          'Günde en az 2 litre su içmek metabolizmayı, beyin fonksiyonlarını ve cilt sağlığını destekler. Sabahınıza bir bardak ılık su ve limonla başlamayı deneyin.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Stop Eating Before Bed',
      'tr': 'Yatmadan Önce Yemeyi Bırakın',
    },
    body: {
      'en':
          'Research shows that eating at least 2-3 hours before bedtime improves sleep quality and aids digestion. Late-night eating can disrupt your circadian rhythm and increase acid reflux risk.',
      'tr':
          'Araştırmalar, yatmadan en az 2-3 saat önce yemeyi bırakmanın uyku kalitesini artırdığını ve sindirimi desteklediğini göstermektedir. Gece geç saatte yemek, sirkadiyen ritminizi bozabilir ve mide reflüsü riskini artırabilir.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Reduce Salt Intake',
      'tr': 'Tuz Tüketiminizi Azaltın',
    },
    body: {
      'en':
          'The WHO recommends less than 5g of salt per day. Excess sodium raises blood pressure and increases cardiovascular risk. Enhance flavors with herbs and spices instead.',
      'tr':
          'DSÖ günlük 5 gramdan az tuz tüketilmesini önermektedir. Aşırı sodyum kan basıncını yükseltir ve kalp-damar hastalığı riskini artırır. Yemeklerinize tuz yerine otlar ve baharatlar ekleyerek lezzeti artırabilirsiniz.',
    },
  ),
  HealthTip(
    title: {
      'en': 'The Power of Fiber',
      'tr': 'Lifin Gücü',
    },
    body: {
      'en':
          'A diet rich in fiber (25-30g daily) supports digestive health, helps control blood sugar, and promotes satiety. Include whole grains, legumes, and vegetables in every meal.',
      'tr':
          'Lifli beslenme (günlük 25-30g), sindirim sağlığını destekler, kan şekerini kontrol etmeye yardımcı olur ve tokluk hissi verir. Her öğününüze tam tahıllar, baklagiller ve sebzeler ekleyin.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Eat the Rainbow',
      'tr': 'Gökkuşağı Gibi Beslenin',
    },
    body: {
      'en':
          'Different colored fruits and vegetables contain unique antioxidants and phytochemicals. Aim for at least 5 different colors on your plate daily for optimal micronutrient intake.',
      'tr':
          'Farklı renklerdeki meyve ve sebzeler kendine özgü antioksidanlar ve fitokimyasallar içerir. Optimum mikro besin alımı için her gün tabağınızda en az 5 farklı renk olmaya özen gösterin.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Mindful Eating',
      'tr': 'Bilinçli Beslenme',
    },
    body: {
      'en':
          'Eating slowly and chewing thoroughly can reduce calorie intake by up to 15%. Put your fork down between bites, savor the flavors, and listen to your body\'s satiety signals.',
      'tr':
          'Yavaş yemek ve iyi çiğnemek kalori alımını %15\'e kadar azaltabilir. Lokmalar arasında çatalı bırakın, lezzetlerin tadını çıkarın ve vücudunuzun tokluk sinyallerini dinleyin.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Protein at Every Meal',
      'tr': 'Her Öğünde Protein',
    },
    body: {
      'en':
          'Distributing protein intake throughout the day (20-30g per meal) maximizes muscle protein synthesis and helps maintain muscle mass. Include eggs, yogurt, legumes, or lean meat.',
      'tr':
          'Protein alımını gün boyunca dağıtmak (öğün başına 20-30g), kas protein sentezini en üst düzeye çıkarır ve kas kütlesini korumaya yardımcı olur. Yumurta, yoğurt, baklagiller veya yağsız et tüketin.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Healthy Fats Are Essential',
      'tr': 'Sağlıklı Yağlar Şart',
    },
    body: {
      'en':
          'Omega-3 fatty acids found in fish, walnuts, and flaxseeds reduce inflammation and support brain health. Include healthy fats in your diet—they help absorb vitamins A, D, E, and K.',
      'tr':
          'Balık, ceviz ve keten tohumunda bulunan Omega-3 yağ asitleri iltihabı azaltır ve beyin sağlığını destekler. Diyetinize sağlıklı yağlar ekleyin—A, D, E ve K vitaminlerinin emilimini desteklerler.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Don\'t Skip Breakfast',
      'tr': 'Kahvaltıyı Atlamayın',
    },
    body: {
      'en':
          'A balanced breakfast stabilizes blood sugar, improves concentration, and prevents overeating later. Combine complex carbs, protein, and healthy fats for sustained energy.',
      'tr':
          'Dengeli bir kahvaltı kan şekerini dengeler, konsantrasyonu artırır ve gün içinde aşırı yemeyi önler. Uzun süreli enerji için kompleks karbonhidratları, proteini ve sağlıklı yağları birleştirin.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Limit Processed Foods',
      'tr': 'İşlenmiş Gıdaları Sınırlayın',
    },
    body: {
      'en':
          'Ultra-processed foods often contain excess sugar, sodium, and unhealthy fats. Studies link high consumption to increased risk of obesity, heart disease, and type 2 diabetes.',
      'tr':
          'Aşırı işlenmiş gıdalar genellikle fazla şeker, sodyum ve sağlıksız yağ içerir. Araştırmalar, yüksek tüketimin obezite, kalp hastalığı ve tip 2 diyabet riskini artırdığını göstermektedir.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Fermented Foods for Gut Health',
      'tr': 'Bağırsak Sağlığı İçin Fermente Gıdalar',
    },
    body: {
      'en':
          'Yogurt, kefir, and fermented vegetables contain probiotics that support your gut microbiome. A healthy gut improves immunity, mood, and nutrient absorption.',
      'tr':
          'Yoğurt, kefir ve fermente sebzeler bağırsak mikrobiyomunuzu destekleyen probiyotikler içerir. Sağlıklı bir bağırsak bağışıklığı, ruh halini ve besin emilimini iyileştirir.',
    },
  ),
  HealthTip(
    title: {
      'en': 'The Importance of Magnesium',
      'tr': 'Magnezyumun Önemi',
    },
    body: {
      'en':
          'Magnesium supports over 300 enzyme reactions, including energy production and muscle function. Dark chocolate, avocado, nuts, and leafy greens are excellent sources.',
      'tr':
          'Magnezyum, enerji üretimi ve kas fonksiyonu dahil 300\'den fazla enzim reaksiyonunu destekler. Bitter çikolata, avokado, kuruyemişler ve yeşil yapraklı sebzeler mükemmel kaynaklardır.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Portion Control Tips',
      'tr': 'Porsiyon Kontrolü İpuçları',
    },
    body: {
      'en':
          'Use smaller plates to naturally reduce portions. A protein serving should be palm-sized, carbs should fit in your cupped hand, and fats should be about a thumb-size.',
      'tr':
          'Porsiyonları doğal olarak küçültmek için daha küçük tabaklar kullanın. Protein porsiyonu avuç içi büyüklüğünde, karbonhidratlar avucunuza sığacak kadar, yağlar ise başparmak büyüklüğünde olmalıdır.',
    },
  ),
  HealthTip(
    title: {
      'en': 'Vitamin D and Sunlight',
      'tr': 'D Vitamini ve Güneş Işığı',
    },
    body: {
      'en':
          'Vitamin D is crucial for bone health and immunity. Spend 15-20 minutes in sunlight daily when possible. Fatty fish, eggs, and fortified foods can supplement your intake.',
      'tr':
          'D vitamini kemik sağlığı ve bağışıklık için çok önemlidir. Mümkün olduğunda günde 15-20 dakika güneş ışığından yararlanın. Yağlı balık, yumurta ve zenginleştirilmiş gıdalar alımınızı destekleyebilir.',
    },
  ),
];

/// Mood-based food recommendation tips
const List<MoodFoodTip> moodFoodTips = [
  MoodFoodTip(
    checkInType: CheckInType.lowEnergy,
    title: {
      'en': 'Energy-Boosting Nutrition',
      'tr': 'Enerji Artırıcı Beslenme',
    },
    body: {
      'en':
          'When feeling low on energy, your body may need complex carbohydrates for sustained fuel and iron-rich foods for oxygen transport. Try oatmeal with banana and a handful of nuts, or a spinach salad with quinoa. B vitamins (found in whole grains and eggs) are essential for converting food into energy.',
      'tr':
          'Enerjiniz düşük olduğunda, vücudunuz uzun süreli yakıt için kompleks karbonhidratlara ve oksijen taşınması için demir açısından zengin gıdalara ihtiyaç duyabilir. Muzlu yulaf lapası ve bir avuç kuruyemiş veya kinoalı ıspanak salatası deneyin. B vitaminleri (tam tahıllar ve yumurtada bulunan), besinleri enerjiye dönüştürmek için gereklidir.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.bloated,
    title: {
      'en': 'Foods to Reduce Bloating',
      'tr': 'Şişkinliği Azaltan Besinler',
    },
    body: {
      'en':
          'Bloating can be caused by excess sodium, gas-producing foods, or poor digestion. Try ginger tea to soothe the stomach, cucumber to hydrate and reduce water retention, and peppermint to relax digestive muscles. Avoid carbonated drinks and high-sodium processed foods.',
      'tr':
          'Şişkinlik aşırı sodyum, gaz yapan gıdalar veya kötü sindirimin sonucu olabilir. Mideyi rahatlatmak için zencefil çayı, vücuttaki fazla suyu atmak için salatalık ve sindirim kaslarını gevşetmek için nane deneyin. Gazlı içeceklerden ve yüksek sodyumlu işlenmiş gıdalardan kaçının.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.cravingSweets,
    title: {
      'en': 'Smart Sweet Alternatives',
      'tr': 'Akıllı Tatlı Alternatifleri',
    },
    body: {
      'en':
          'Sweet cravings often indicate blood sugar fluctuations or magnesium deficiency. Reach for naturally sweet options like dates with almond butter, dark chocolate (70%+), or Greek yogurt with berries. These provide sweetness along with fiber and protein to stabilize blood sugar.',
      'tr':
          'Tatlı isteği genellikle kan şekeri dalgalanmalarını veya magnezyum eksikliğini gösterir. Badem ezmeli hurma, bitter çikolata (%70+) veya meyveli Yunan yoğurdu gibi doğal tatlı seçeneklere yönelin. Bunlar, kan şekerini dengelemek için lif ve proteinle birlikte tatlılık sağlar.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.cantFocus,
    title: {
      'en': 'Brain-Boosting Foods',
      'tr': 'Beyin Güçlendiren Besinler',
    },
    body: {
      'en':
          'For better concentration, focus on omega-3 rich foods like salmon and walnuts, which support brain cell communication. Blueberries are loaded with antioxidants that improve memory. Green tea contains L-theanine for calm focus. Avoid heavy meals that redirect blood flow to digestion.',
      'tr':
          'Daha iyi konsantrasyon için beyin hücreleri arasındaki iletişimi destekleyen somon ve ceviz gibi omega-3 açısından zengin gıdalara odaklanın. Yaban mersini, hafızayı geliştiren antioksidanlarla doludur. Yeşil çay, sakin odaklanma için L-teanin içerir. Kan akışını sindirme yönlendiren ağır yemeklerden kaçının.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.pms,
    title: {
      'en': 'Nutrition for PMS Relief',
      'tr': 'PMS Rahatlığı İçin Beslenme',
    },
    body: {
      'en':
          'During PMS, your body benefits from magnesium-rich foods (dark chocolate, leafy greens) to reduce cramps, calcium-rich foods (yogurt, cheese) to improve mood, and vitamin B6 (bananas, chickpeas) to ease hormonal fluctuations. Stay hydrated and limit caffeine and salt.',
      'tr':
          'PMS döneminde vücudunuz krampları azaltmak için magnezyum açısından zengin gıdalardan (bitter çikolata, yeşil yapraklı sebzeler), ruh halini iyileştirmek için kalsiyumdan (yoğurt, peynir) ve hormonal dalgalanmaları hafifletmek için B6 vitamininden (muz, nohut) fayda görür. Bol su için, kafein ve tuzu sınırlayın.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.periodCramps,
    title: {
      'en': 'Foods to Ease Cramps',
      'tr': 'Krampları Hafifleten Besinler',
    },
    body: {
      'en':
          'Anti-inflammatory foods like salmon, ginger, and turmeric can help reduce period cramps. Magnesium from dark chocolate and bananas relaxes muscle contractions. Warm herbal teas (chamomile, ginger) provide comfort. Iron-rich foods help replenish what\'s lost during menstruation.',
      'tr':
          'Somon, zencefil ve zerdeçal gibi anti-inflamatuar besinler regl kramplarını azaltmaya yardımcı olabilir. Bitter çikolata ve muzdaki magnezyum kas kasılmalarını gevşetir. Sıcak bitki çayları (papatya, zencefil) rahatlatır. Demir açısından zengin gıdalar, regl döneminde kaybedileni telafi eder.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.periodFatigue,
    title: {
      'en': 'Fighting Period Fatigue',
      'tr': 'Regl Yorgunluğuyla Mücadele',
    },
    body: {
      'en':
          'Period fatigue is often linked to iron loss. Boost iron intake with red meat, spinach, and lentils (pair with vitamin C for absorption). Complex carbs like oats and sweet potatoes provide sustained energy. Avoid excessive sugar which can cause energy crashes.',
      'tr':
          'Regl yorgunluğu genellikle demir kaybıyla bağlantılıdır. Kırmızı et, ıspanak ve mercimekle demir alımını artırın (emilim için C vitaminiyle birleştirin). Yulaf ve tatlı patates gibi kompleks karbonhidratlar uzun süreli enerji sağlar. Enerji düşüşüne neden olabilecek aşırı şekerden kaçının.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.postWorkout,
    title: {
      'en': 'Post-Workout Recovery Nutrition',
      'tr': 'Egzersiz Sonrası Toparlanma Beslenmesi',
    },
    body: {
      'en':
          'Within 30-60 minutes after exercise, consume a mix of protein (20-30g) for muscle repair and carbs to replenish glycogen. Great options: chicken with rice, Greek yogurt with granola, or a protein smoothie with banana. Don\'t forget to rehydrate with water and electrolytes.',
      'tr':
          'Egzersizden sonraki 30-60 dakika içinde, kas onarımı için protein (20-30g) ve glikojen depolamak için karbonhidrat tüketin. Harika seçenekler: pirinçli tavuk, granolalı Yunan yoğurdu veya muzlu protein smoothie. Su ve elektrolitlerle sıvı takviyesini unutmayın.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.feelingBalanced,
    title: {
      'en': 'Maintain Your Balance',
      'tr': 'Dengenizi Koruyun',
    },
    body: {
      'en':
          'When you\'re feeling balanced, it\'s a great time to maintain your routine! Focus on variety: try a new vegetable, experiment with different spices, or cook a recipe from a different cuisine. A diverse diet ensures you get a wide range of nutrients.',
      'tr':
          'Kendinizi dengeli hissettiğinizde, rutininizi sürdürmek için harika bir zaman! Çeşitliliğe odaklanın: yeni bir sebze deneyin, farklı baharatlar keşfedin veya farklı bir mutfaktan tarif yapın. Çeşitli bir diyet, geniş bir besin yelpazesi almanızı sağlar.',
    },
  ),
  MoodFoodTip(
    checkInType: CheckInType.noSpecificIssue,
    title: {
      'en': 'Daily Nutrition Wisdom',
      'tr': 'Günlük Beslenme Bilgeliği',
    },
    body: {
      'en':
          'Even without specific issues, small nutrition habits make big differences. Eat a variety of colorful vegetables, include a source of protein at every meal, stay hydrated throughout the day, and don\'t forget healthy fats from olive oil, avocado, or nuts.',
      'tr':
          'Belirli bir sorun olmasa bile, küçük beslenme alışkanlıkları büyük farklar yaratır. Çeşitli renkli sebzeler yiyin, her öğüne bir protein kaynağı ekleyin, gün boyunca bol su için ve zeytinyağı, avokado veya kuruyemişlerden sağlıklı yağları unutmayın.',
    },
  ),
];

/// Get the tip of the day (rotates daily)
HealthTip getTipOfTheDay() {
  final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
  return dailyHealthTips[dayOfYear % dailyHealthTips.length];
}

/// Get mood food tip for a specific check-in type
MoodFoodTip? getMoodFoodTip(CheckInType type) {
  return moodFoodTips
      .where((t) => t.checkInType == type)
      .firstOrNull;
}

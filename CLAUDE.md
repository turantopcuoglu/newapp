# NutriGuide (nutri_guide)

> **Yeni oturum:** önce `docs/ROADMAP.md` oku — projenin nerede olduğu,
> sıradaki iş ve bu projede daha önce düşülen tuzaklar orada. Bu dosya
> değişmez kuralları içerir, ROADMAP güncel durumu.

Kişiselleştirilmiş tarif ve beslenme uygulaması: günlük mod (check-in), sağlık
durumu, alerji/beslenme tercihi ve evdeki malzemelere göre tarif önerir;
kalori/makro takibi yapar. Flutter + Riverpod, yerel depolama
(SharedPreferences), TR/EN iki dilli, backend yok.

## Komutlar

> Bu ortamda Flutter kurulu gelmez; kurulum adımları `docs/ROADMAP.md`
> bölüm 0'da. Sürüm 3.32.5 olmalı (3.24.x `intl` ile çakışıyor).

```bash
flutter pub get                            # bağımlılıklar
flutter analyze                            # 0 error beklenir
flutter test                               # tüm testler geçmeli
dart run tool/data_report.dart             # tarif verisi bütünlük + kalori raporu
dart run tool/data_report.dart --strict    # hata varsa non-zero exit (CI)
dart run tool/data_report.dart --fix-macros # makroları miktarlardan yeniden hesaplar

pip install reportlab                       # tek seferlik (PDF üretimi için)
python3 tool/generate_recipe_pdf.py         # docs/NutriGuide-Tarif-Kitabi.pdf
python3 tool/generate_recipe_pdf.py --locale en
```

Tarif kitabı PDF'i tarif verisinden üretilir; içerik değiştiyse yeniden
çalıştırıp `docs/` altındaki dosyayı güncelle.

## Mimari

- `assets/recipes/*.json` — tarif içeriği (breakfast/lunch/dinner/snack).
  Açılışta `RecipeRepository.loadLatest()` (lib/data/recipe_repository.dart)
  ile yüklenir ve `main.dart`'ta `bundledRecipesProvider` override edilir.
  Önbellekte geçerli bir uzak paket varsa o, yoksa bundled asset kullanılır;
  `--dart-define=RECIPE_BUNDLE_URL=...` verilirse açılıştan sonra arka planda
  yeni sürüm indirilir (bir sonraki açılışta geçerli olur). Adres verilmezse
  uygulama tamamen bundled içerikle çalışır.
- `lib/data/` — malzeme kataloğu (`mock_ingredients.dart`, kanonik ID kaynağı),
  besin verisi (`ingredient_nutrition_data.dart`, 100 g bazlı + `defaultServingG`),
  keşfet kategorileri (`explore_data.dart` — tarifler kategoriye `cuisineIds`
  etiketiyle bağlanır, elle ID listesi YOK).
- `lib/services/` — `recommendation_service.dart` (öneri akışı: alerji +
  sevilmeyen + beslenme tercihi sert eleme → check-in eşleşmesi yumuşak bonus →
  kiler eşleşme skoru), `nutrition_calculator.dart` (miktar × besin verisinden
  makro hesabı), `diet_classifier.dart` (malzemelerden vejetaryen/vegan/
  glutensiz/laktozsuz türetimi), `notification_service.dart` (cihaz üstünde
  günlük hatırlatma; sunucu gerekmez).
- **Tüketilen kalori** `cookedProvider`'dan (lib/providers/cooked_provider.dart)
  gelir — kullanıcının "Pişirdim" dediği kayıtlar. `mealPlanProvider` yalnızca
  *plandır*, tüketim sayılmaz; bu ikisini birbirine karıştırma. Yemek listesi
  ikisini `buildDayMealList` (lib/services/day_meal_list.dart) ile birleştirip
  gösterir; satırdaki tik `cookedProvider`'ı değiştirir, beslenme özeti de
  oradan beslenir.
  Gün sınırı tek yerde: `DayBoundary` (06:00 reset). Gün kovası üretirken
  `keyForDate` kullan — `keyFor` zaman damgası içindir ve gece yarısı
  tarihlerini bir gün geriye kaydırır.
- **Tercih ≠ alerjen.** Alerjen her yerde sert elenir (güvenlik, testler
  gevşetilmez). Sevilmeyen besin ve beslenme tercihi ise Keşfet'te yalnızca
  sıralamayı değiştirir: `preference_matcher.dart` + `browsableScoredRecipes
  Provider` uyumsuzu en alta indirir ve nedenini kart üstünde gösterir.
- `lib/providers/` — Riverpod provider'ları; `recipe_provider.dart` merkezi.
- `lib/screens/` — UI; `main_shell.dart` sekmeleri tanımlar.

- `lib/components/recipe_visual.dart` — tarif görseli. Fotoğraf yok; mutfak
  gradyanı + yemek emojisi çizilir. `imagePath` doluysa o kullanılır.

## Veri kuralları (tarif eklerken/düzenlerken)

- Tarif kaynağı YALNIZCA `assets/recipes/*.json`; Dart koduna tarif gömme.
- **Kalori/makro elle yazılmaz**: `quantities` (porsiyon başına miktar) doldurulur,
  `dart run tool/data_report.dart --fix-macros` makroları üretir. Test,
  makroların hesaplananla uyuşmasını zorlar.
- Zorunlu alanlar: TR+EN `name`/`description`/`steps`, ≥1 `cuisineIds`
  (geçerli kategoriler `explore_data.dart`), her malzeme için `quantities`
  girdisi, katalogda var olan `ingredientIds` (kanonik liste
  `mock_ingredients.dart` — ör. `walnut`, `white_rice`, `chickpea`; çoğul
  ID kullanma).
- Yeni malzeme kullanılacaksa önce kataloğa ve `ingredient_nutrition_data.dart`'a
  eklenmeli (rapor eksikleri WARN olarak gösterir). Katalogda olmayan bir
  malzemeyi "yakın olanla" değiştirme — pekmez yerine nar ekşisi yazıldığı için
  tarif yanlış çıktı; doğrusu kataloğa `molasses` eklemekti.
- **Adımlar ile malzeme listesi birbirini tutmalı.** Adımda geçen her şey
  listede olmalı (mantıda hamur açılıyordu ama un/yumurta listede yoktu),
  listedeki her şey de adımlarda kullanılmalı. Rapor hamur kuralını,
  `test/recipe_content_test.dart` bu sınıfın örneklerini bekliyor.
- **`allergenTags` malzemelerin taşıdığı her alerjeni içermeli** ve yalnızca
  `lib/data/allergens.dart` sözlüğündeki etiketler kullanılmalı. Sert filtre
  bu alanı okur: eksik etiket = alerjik kullanıcıya o tarifin gösterilmesi.
  ("tree_nuts" 12 tarifte yazılıydı, hiçbir profil onu seçemediği için fındık
  filtresi bu tarifleri hiç elemiyordu.) Rapor ikisini de hata sayar.
- **Yoğurt adlandırması (sabit kural).** Türkçe metinlerde yalnızca
  **"yoğurt"**, İngilizce metinlerde **"Turkish yogurt"** yazılır; malzeme
  kataloğundaki tek yoğurt girdisi `yogurt` (TR "Yoğurt" / EN "Turkish
  Yogurt"). **"Yunan yoğurdu" / "Greek yogurt" hiçbir yerde geçmez** — ayrı
  bir süzme/Greek yoğurt girdisi de yoktur. Laktozsuz tariflerde biçim
  "laktozsuz yoğurt" / "lactose-free Turkish yogurt" olur.
- Nutrition tablosunda tahıl/bakliyat değerleri pişmiş bazdadır
  (rice/pasta/lentil), yulaf/bulgur/un kuru bazdadır — miktarları buna göre yaz.

## Test politikası

Her veri veya içerik değişikliğinden sonra: `flutter test` +
`dart run tool/data_report.dart --strict`. Alerjen güvenliği testleri
(`test/recommendation_service_test.dart`) asla gevşetilmez.

Rapor kopya/benzerlik hatası verirse tarifi gerçekten farklılaştır —
eşiği gevşetme. Bu kural iki kez gerçek kopyayı yakaladı.

**pubspec'e bağımlılık eklediysen ayrıca `flutter build apk --debug` çalıştır.**
`analyze`/`test` yalnızca Dart tarafını derler, Gradle'a dokunmaz; desugaring
ve AAR metadata hataları sadece APK derlemesinde görünür. (Bu sandbox'ta
Android SDK yok — o durumda kullanıcının cihazda doğrulaması gerekir.)

## Sağlık kategorileri

`explore_data.dart` içindeki `specialCategories` üç tip filtre kullanır:
sağlık durumu (besin profili veya faydalı malzeme), alerjen dışlama
(glutensiz/laktozsuz) ve check-in etiketi (regl). Filtreleme mantığı TEK
yerde: `lib/services/special_category_matcher.dart` — Keşfet'teki sayı ve
açılan liste aynı fonksiyondan geçmeli, yoksa rozet yalan söyler.

Kategorilere **tek giriş** Keşfet → "Sana Özel"; ana sayfada sağlık bölümü
yok. Kategori sayfası şu sırayla: başlık → sağlık durumu açıklaması →
malzeme kartları. Açıklama metni ve kartlardaki malzemeler
`lib/data/health_category_info.dart` içinde (TR+EN zorunlu, malzeme ID'leri
kanonik olmalı — rapor doğruluyor). Bir malzeme kartı yalnızca o malzemeyi
içeren VE kategoriye uyan tarifleri listeler (`matchesCategoryIngredient`).

## Git

- Geliştirme dalı: `claude/recipe-app-strategy-aojpcj`; push:
  `git push -u origin <dal>`. Başka dala izinsiz push yapma.

# NutriGuide (nutri_guide)

## Oturum protokolü (her yeni sohbette, görev ne olursa olsun)

1. **`docs/ROADMAP.md` §3'ü oku** — hangi fazdayız, sıradaki iş ne, neyin
   bilerek yapılmadığı. §5 bu projede düşülen tuzaklar; yeni iş öncesi göz at.
2. **Arayüze dokunacaksan `docs/DESIGN.md`'yi oku** — sekme haritası,
   bileşenler, hareket süreleri, sağlık dili, tasarım borcu.
3. **Görsel gerekiyorsa çizme/uydurma:**
   `docs/design/gorsel-uretim/README.md`'ye ayrıntılı GPT prompt'u ekle
   (aile, referans dosyalar, boyut, dosya adı, durum tablosu satırı).
   Kullanıcı ChatGPT'de üretip `docs/design/gorsel-uretim/teslim/`'e koyar;
   bağlama adımları aynı dosyanın §6'sında. Oturum başında `teslim/`'de
   tabloda **U** işaretsiz dosya varsa kullanıcıya söyle.
4. Kullanıcının verdiği görev ROADMAP'teki sırayla çelişiyorsa kullanıcının
   görevini yap; sıranın neden öyle olduğunu tek cümleyle hatırlat.
5. **Bir iş parçası bitince:** ROADMAP §3'te durumu güncelle (ne bitti, ne
   kaldı, neden), gerekirse DESIGN.md / görsel tablosunu güncelle, doğrula
   (aşağıdaki test politikası), kullanıcı isterse commit at.

**Kullanıcı hakkında:** Turan; Türkçe konuşur, yanıtlar Türkçe. Eşi hekim —
sağlıkla ilgili metinler onun incelemesinden geçecek (faz 4). Commit'i
kullanıcı ister; push yalnız açıkça istenince. Görselleri GPT ile kendisi
üretiyor; prompt'ta referans görsel yolu vermek tutarlılığı artırıyor.

Kişisel iyi oluş + beslenme uygulaması: günlük durum (check-in), sağlık
durumu, alerji/beslenme tercihi ve mutfaktaki malzemelere göre gerekçeli
tarif önerir; kısa rutinler (nefes, yürüyüş, uyku), su ve "pişirdim"
tüketim kaydı tutar. Flutter + Riverpod, yerel depolama (SharedPreferences +
şifreli wellness deposu), TR/EN, backend yok.

## Komutlar

> Kullanıcının Windows makinesinde Flutter **3.44.6** kurulu (pubspec
> `>=3.38.0`). Bulut sandbox'ta kurulum: `docs/ROADMAP.md` §0. 3.24.x `intl`
> ile çakışır.

```bash
flutter pub get                            # bağımlılıklar
flutter analyze                            # 0 error beklenir
flutter test                               # tüm testler geçmeli
dart run tool/data_report.dart             # tarif verisi bütünlük + kalori raporu
dart run tool/data_report.dart --strict    # hata varsa non-zero exit (CI)
dart run tool/data_report.dart --fix-macros # makroları miktarlardan yeniden hesaplar
dart run tool/step_ingredients.dart        # adım↔malzeme denetimi; --write yeni tariflere stepIngredients yazar
flutter test test/wellness_ui_test.dart --dart-define=CAPTURE_WELLNESS=true  # ekran PNG'leri → output/wellness-build/
dart run tool/health_review_export.dart     # hekim inceleme sayfası → docs/hekim-inceleme/ (sonra Artifact'e yeniden yayımla)
powershell -ExecutionPolicy Bypass -File tool/resize_images.ps1 -Source <klasör> -Target <assets/images/...>  # teslim görselleri küçült
```

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
- `lib/providers/` — Riverpod provider'ları; `recipe_provider.dart` (tarif
  havuzu) ve `wellness_provider.dart` (check-in, günlük öneri sıralaması
  `wellnessRecipesProvider`, gerekçe metni `recommendationReason`) merkezi.
- `lib/screens/main_shell.dart` — 5 sekme: Bugün · Beslen · İyi oluş ·
  Gelişim · Profil (`lib/screens/wellness/`). Ekran haritası ve bileşenler:
  `docs/DESIGN.md`.
- **Check-in tek kayıt:** `DailyCheckIn` (`lib/models/wellness.dart`) —
  focus (mod) + enerji/süre/ruh hali/uyku/stres. Akış: `MoodPickerScreen` →
  `WellnessCheckInScreen`. Eski `checkInProvider` yalnız testlerde varsayılan
  olarak kalıyor; `main.dart` `activeRecipeContextProvider`'ı bugünkü
  check-in'e bağlar. Akşam cevabı ayrı kayıt: `EveningCheckIn`
  (`saveEvening` birleştirir, sabah kaydına dokunmaz). Haftalık gözlem
  (`lib/services/weekly_insight.dart`) yalnız kayıtlardan sayar, 4 akşamdan
  azsa iddia kurmaz ve neden-sonuç söylemez — testi bunu zorlar.
- **Mod → tarif eşleşmesi tek yerde:** `lib/services/focus_rules.dart`
  (`recipeHasFocus`). İlk dokuz mod JSON'daki `checkInTags`'i kullanır;
  Stresliyim / Kaygılıyım / Uykusuzum tarif verisinden kuralla türetilir
  (kafeinsiz, basit şeker değil, …) — bu üçü için JSON'a etiket yazma.
  Kuralın sözlü hali `focusRuleText`, hekim inceleme sayfasına gider.
  "Belirli Bir Sorun Yok" artık "İyiyim" (enum adı `noSpecificIssue`).
- `lib/data/focus_guidance.dart` — her mod için gerekçe cümlesi ve küçük
  adımlar; sağlık dili kuralları dosyanın başında. Hekim onayı `reviewed`.
- `lib/components/recipe_visual.dart` — tarif fotoğrafı: önce `imagePath`,
  yoksa atlas hücresi (`lib/data/food_photo_catalog.dart`, 144/144 tarif ve
  233/233 malzemenin fotoğrafı var).

## Veri kuralları (tarif eklerken/düzenlerken)

- Tarif kaynağı YALNIZCA `assets/recipes/*.json`; Dart koduna tarif gömme.
- **Kalori/makro elle yazılmaz**: `quantities` (porsiyon başına miktar) doldurulur,
  `dart run tool/data_report.dart --fix-macros` makroları üretir. Test,
  makroların hesaplananla uyuşmasını zorlar.
- **`stepIngredients`**: adım başına malzeme ID listesi (TR ve EN adımlar
  aynı sırada olmalı). Yeni tarifte `dart run tool/step_ingredients.dart
  --write` tahmini yazar, sonra elle gözden geçir; araç var olanın üstüne
  yazmaz. Pişirme ekranı miktarları buradan gösterir. Rapor hizayı ve
  "listedeki her malzeme bir adımda" kuralını hata sayar.
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

Kategorilere giriş: Beslen sekmesi → "Sağlık alanları ve dünya mutfakları"
(`ExploreScreen`) → "Sana Özel". Kullanıcının sağlık durumu kayıt akışında
(`onboarding_health_screen.dart`) ve Profil'de seçilir; seçilen alanlar
önde listelenir. Kategori sayfası şu sırayla: başlık → sağlık durumu açıklaması →
malzeme kartları. Açıklama metni ve kartlardaki malzemeler
`lib/data/health_category_info.dart` içinde (TR+EN zorunlu, malzeme ID'leri
kanonik olmalı — rapor doğruluyor). Bir malzeme kartı yalnızca o malzemeyi
içeren VE kategoriye uyan tarifleri listeler (`matchesCategoryIngredient`).

## Git

- Çalışma dalı (2026-10 itibarıyla): `claude/recipe-save-ui-fixes-629z7x`
  (önceki: `claude/recipe-app-strategy-aojpcj`). Push yalnız kullanıcı
  isteyince: `git push -u origin <dal>`. Başka dala izinsiz push yapma.
- Commit mesajı İngilizce, "neden"i anlatır; gövde sonunda Co-Authored-By.

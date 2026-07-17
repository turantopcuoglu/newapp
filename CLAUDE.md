# NutriGuide (nutri_guide)

Kişiselleştirilmiş tarif ve beslenme uygulaması: günlük mod (check-in), sağlık
durumu, alerji/beslenme tercihi ve evdeki malzemelere göre tarif önerir;
kalori/makro takibi yapar. Flutter + Riverpod, yerel depolama
(SharedPreferences), TR/EN iki dilli, backend yok.

## Komutlar

```bash
flutter pub get                            # bağımlılıklar
flutter analyze                            # 0 error beklenir
flutter test                               # tüm testler geçmeli
dart run tool/data_report.dart             # tarif verisi bütünlük + kalori raporu
dart run tool/data_report.dart --strict    # hata varsa non-zero exit (CI)
dart run tool/data_report.dart --fix-macros # makroları miktarlardan yeniden hesaplar
```

## Mimari

- `assets/recipes/*.json` — tarif içeriği (breakfast/lunch/dinner/snack).
  Açılışta `RecipeRepository.loadBundled()` (lib/data/recipe_repository.dart)
  ile yüklenir ve `main.dart`'ta `bundledRecipesProvider` override edilir.
- `lib/data/` — malzeme kataloğu (`mock_ingredients.dart`, kanonik ID kaynağı),
  besin verisi (`ingredient_nutrition_data.dart`, 100 g bazlı + `defaultServingG`),
  keşfet kategorileri (`explore_data.dart` — tarifler kategoriye `cuisineIds`
  etiketiyle bağlanır, elle ID listesi YOK).
- `lib/services/` — `recommendation_service.dart` (öneri akışı: alerji +
  sevilmeyen + beslenme tercihi sert eleme → check-in eşleşmesi yumuşak bonus →
  kiler eşleşme skoru), `nutrition_calculator.dart` (miktar × besin verisinden
  makro hesabı), `diet_classifier.dart` (malzemelerden vejetaryen/vegan/
  glutensiz/laktozsuz türetimi).
- `lib/providers/` — Riverpod provider'ları; `recipe_provider.dart` merkezi.
- `lib/screens/` — UI; `main_shell.dart` sekmeleri tanımlar.

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
  eklenmeli (rapor eksikleri WARN olarak gösterir).
- Nutrition tablosunda tahıl/bakliyat değerleri pişmiş bazdadır
  (rice/pasta/lentil), yulaf/bulgur/un kuru bazdadır — miktarları buna göre yaz.

## Test politikası

Her veri veya içerik değişikliğinden sonra: `flutter test` +
`dart run tool/data_report.dart --strict`. Alerjen güvenliği testleri
(`test/recommendation_service_test.dart`) asla gevşetilmez.

## Git

- Geliştirme dalı: `claude/recipe-app-strategy-aojpcj`; push:
  `git push -u origin <dal>`. Başka dala izinsiz push yapma.

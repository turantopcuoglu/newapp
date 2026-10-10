# NutriGuide — Uygulanmış tasarım sistemi

> Kod nasılsa öyle. `docs/design/` altındaki eski panolar ve öneriler
> *tasarım geçmişi*dir; çelişirse **bu dosya ve kod** geçerlidir.
> Son güncelleme: 2026-10-11.

## 1. Ürün iskeleti

Tek günlük döngü: **Nasılsın? → Bugün sana ne iyi gelir (nedeniyle) →
yaptım/yedim → akşam: nasıl geçti? → haftalık gözlem.**

| Sekme | Dosya | Tek işi |
|---|---|---|
| Bugün | `lib/screens/wellness/today_screen.dart` | Günün kararı: check-in daveti/çipi, gerekçeli öneri, 2 küçük adım, öğün listesi |
| Beslen | `wellness/nourish_screen.dart` | Öneriyi değiştir, malzemeler, alışveriş; sağlık alanları ve mutfaklar (`explore/explore_screen.dart`) |
| İyi oluş | `wellness/wellbeing_screen.dart` | Molalar (nefes/meditasyon/yürüyüş/esneme), uyku, alışkanlık, su, sağlık verisi |
| Gelişim | `wellness/progress_screen.dart` | Haftalık kayıtlar, beslenme geçmişi |
| Profil | `wellness/profile_screen.dart` | Atmosfer, tercihler, sağlık durumu, veri ve izinler |

Kural: **bir özellik tek sekmede yaşar.** Başka sekme ona yalnızca bağlam
gerektiğinde (ör. Bugün'deki su adımı) kısa yol verir; aynı kutucuk
ızgarasını ikinci kez koyma. Bu tekrar, kullanıcının "neyi nerede
kullanacağım anlaşılmıyor" şikâyetinin ana nedeniydi.

Modlar (12): Günlük ızgarada Düşük Enerji, Şişkinlik, Tatlı İsteği,
Odaklanamıyorum, Stresliyim, Kaygılıyım, Uykusuzum, Egzersiz Sonrası; altında
geniş "İyiyim" kartı; Regl dönemi sekmesinde PMS, Kramp, Yorgunluk. Manzara
`MoodLandscape` (ilk dokuzu atlas, yeni üçü `assets/images/scenes/mood_*`).

Check-in: `MoodPickerScreen` (mod kartı) → aynı akışta
`WellnessCheckInScreen` (enerji + süre; ruh hali/uyku/stres açılır bölümde).
İkisi tek `DailyCheckIn` kaydını yazar. Akşam kapanışı (Bugün'de 19.00–06.00
arası kart) ayrı `EveningCheckIn` kaydıdır; sabahkinin üzerine yazmaz.
Haftalık gözlem Gelişim'de, `lib/services/weekly_insight.dart`.

## 2. Renk

Tema, günün moduna göre bütün uygulamayı boyar (`lib/core/mood_palette.dart`,
`MoodPalette` ThemeExtension; `context.palette`). 9 palet, varsayılan
"Düşük Enerji". Değerler ve her paletin manzarası:
[gorsel-uretim/README.md §2](design/gorsel-uretim/README.md).

- Renk sabit yazma; `context.palette.textPrimary`, `.surface`, `.mint`
  (vurgu, adı tarihsel), `.moon`, `.dividerColor` kullan.
- "Şişkinlik" **açık** tema. Koyu varsayımıyla yazılmış her şey (ör. beyaz
  metin, siyah vinyet) orada kırılır; bu paleti de test et.
- Eski ekranlarda kalan sabit renkler (camgöbeği/kırmızı gradyanlar) tasarım
  borcudur, kopyalanmaz.

## 3. Bileşenler (önce bunları kullan)

| Bileşen | Dosya | Ne zaman |
|---|---|---|
| `MoonlitPage` + `SceneTitle` / `MoonlitHeader` | `wellness/moonlit_page.dart`, `moonlit_assets.dart` | Her sekme/sayfa iskeleti; ay-ufuk başlığı |
| `AtmosphereSurface`, `AtmosphereBackdrop` | `core/atmosphere_surface.dart` | Kart yüzeyi (saten doku), ekran zemini |
| `FeatureTile` + `FeatureGrid` | `wellness/mood_widgets.dart` | 2 sütunlu ikon kutucukları |
| `FineRow` | `moonlit_page.dart` | Liste satırı (ikon + metin + sağ öğe) |
| `MoonButton` | `moonlit_page.dart` | Birincil eylem (tek ekranda bir tane) |
| `MoodGlyph(kind)` | `mood_widgets.dart` | Çizgi ikonlar: sun, bowl, leaf, bars, person, wind, waves, belly, meditation, moon, walk, stretch, water, calendar, heart, settings, battery, cookie, focus, dumbbell |
| `MotionTap` | `core/wellness_motion.dart` | Dokunulabilir özel yüzey (basma efekti + çift dokunuş koruması) |
| `LiftIn(order:)` | `wellness_motion.dart` | Bölümlerin giriş hareketi |
| `RecipeVisual`, `WellnessFoodCard` | `components/recipe_visual.dart`, `nourish_screen.dart` | Tarif fotoğrafı / büyük öneri kartı |
| `IngredientPhoto` | `moonlit_assets.dart` | Malzeme fotoğrafı |
| `InfoDot` | `mood_widgets.dart` | Ek açıklama. **Az kullan**: açıklama kartın üstünde görünür olmalı |
| `HealthConditionChips` | `components/health_condition_chips.dart` | Sağlık durumu seçimi |
| `CategoryCover` / `CategoryCoverHeader` | `components/category_cover.dart` | Fotoğraflı kategori kartı / sayfa başlığı; yazı her temada koyu scrim üstünde beyaz |
| `OnboardingArtworkHeader` | `components/onboarding_artwork_header.dart` | Kayıt akışı başlığı (C ailesi manzara + başlık) |
| `SceneBanner(scene:)` | `components/scene_banner.dart` | Kartın üstünde C ailesi sahne (`assets/images/scenes/`) + beyaz başlık |
| `ScaleChoices` | `wellness/wellness_ui.dart` | Üç seçenekli ölçek sorusu (1–3); sabah check-in ve akşam kapanışı aynı ölçeği kullanır |
| `StepIngredients` | `components/step_ingredients.dart` | Bir tarif adımının malzeme + miktar çipleri; birden çok adımda geçen malzemede "(toplam)" |
| `CookingScreen` | `wellness/cooking_screen.dart` | Pişirme modu: hazırlık listesi → adım + çipler + zamanlayıcı; eylemler sabit alt çubukta |
| `EmptyStateArtwork(name)` | `components/empty_state_artwork.dart` | Boş liste görseli, 160 px; koyu temada kenarı yumuşak, açık temada yuvarlatılmış kare |

## 4. Hareket kuralları

| Ne | Süre / eğri |
|---|---|
| Dokunuş → eylem | **0 ms gecikme.** Animasyon eylemle aynı anda oynar |
| Çift dokunuş koruması | 300 ms (`Timer`, duvar saati değil) |
| Sekme geçişi | 260 ms fade-through: eski ilk %40'ta kaybolur, yeni %35'te başlar |
| Sayfa geçişi | Android: 18 px yukarı + hızlı opaklık; iOS/macOS: **Cupertino** (kenardan geri kaydırma) |
| `LiftIn` | 320 ms + 40 ms/sıra, `easeOutCubic`, yaylanma yok |
| Tema (mod) geçişi | 450 ms; başlık manzarası 600 ms çapraz geçiş |
| Seçim/durum | 180–250 ms |

- Yaylanan (aşan) eğri kullanma; uygulama sakin bir his vermeli.
- Şeffaf sayfaları çapraz soldurma; üst üste biner.
- `Hero`: etiket `recipeHeroTag(id)`; bir rota içinde aynı tarif iki kez
  görünüyorsa kullanma. Gizli sekmeler `HeroMode(false)` içinde.
- `reducedMotion(context)` doğruysa hareket yok (her yeni animasyonda kontrol).

## 5. Yerleşim ve metin

- Türkçe etiketler İngilizcenin ~1.5 katı. Dar ekran (320–360 px) ve
  `textScale 1.6` testleri taşmayı yakalar; yeni ekran bu testlere girsin.
- `FeatureTile`'da alt satır (`detail`) varsa başlık tek kelime olsun.
- Alt sekme etiketi tek satır (`maxLines: 1`).
- Hitap **"sen"** (`tr.dart` 2026-10-08'de tarandı). Kalan "siz":
  `disclaimer_screen.dart` ve `health_category_info.dart` — hekim
  incelemesiyle faz 4'te yeniden yazılacak.
- Kısa başlık, tek cümlelik açıklama. Açıklamayı `InfoDot` arkasına saklama.

## 6. Sağlık dili (hekim incelemesine kadar)

- Önerinin gerekçesi **yalnız sıralamanın yaptığını** söyler; tarife özgü
  her söz tarifin verisinden türetilir (`recommendationReason`,
  `lib/data/focus_guidance.dart`). Doğrulanmamış sıfat ekleme.
- Eksiklik, tanı, tedavi, iyileştirir, garanti gibi sözcükler gerekçe
  ve kategori metinlerinde yasak (iki test: `today_flow_test`,
  `health_focus_test`). Kategori **adları** ("Demir Eksikliği")
  kullanıcının seçtiği etiketlerdir. Kategori metinleri betimler, buyurmaz:
  "X içerir / X ile emilim artar", "danış"; "eklemelisin", "gidermek
  için" değil.
- Kırmızı bayraklar (`HealthCategoryInfo.redFlags`) ve yeni yasal uyarı
  hekim onayına kadar ekranda değil (`reviewed`). İnceleme sayfası koddan
  üretilir: `dart run tool/health_review_export.dart`.
- Alerjen sert eleme; tercih yalnız sıralar (CLAUDE.md).

## 7. Görseller

Dört aile (A yemek, B malzeme, C ay ışığında kum tepeleri, D saten üstünde
nesne). Yeni görsel **kodla çizilmez/uydurulmaz**: ayrıntılı GPT prompt'u
yazılır, kullanıcı üretir. Tüm akış, durum tablosu ve entegrasyon adımları:
**[docs/design/gorsel-uretim/README.md](design/gorsel-uretim/README.md)**.

Mevcut yükleme yolları: tarif/malzeme fotoğrafları atlas hücresi
(`AtlasImage` + `lib/data/food_photo_catalog.dart`), başlık sahneleri
`ReferenceCrop` (`assets/moonlit/*`), mod manzaraları atlas
(`assets/moods/landscapes.png`, sıra = `CheckInType.index`). Tek dosya
görseller için tarifte `imagePath` var. Teslim edilen tekil görseller
`assets/images/{explore,onboarding,empty}/` altında JPEG (kapaklar 1080 px,
yataylar 1200 px); kategori kapağı yolu `CuisineCategory`/`SpecialCategory`
`coverImage` alanında.

## 8. Ekranı görmek

```bash
flutter test test/wellness_ui_test.dart --dart-define=CAPTURE_WELLNESS=true
flutter test test/mood_experience_test.dart --plain-name "all nine choices" --dart-define=CAPTURE_WELLNESS=true
```
Çıktılar `output/wellness-build/` ve `output/mood-experience/`. Testte emoji
kutu olarak görünür (font yok) — cihazda sorun değil. Tarayıcı paneli bu
uygulamada çok yavaş; animasyon akıcılığı yalnız cihazda değerlendirilir.

## 9. Tasarım borcu (eski görünümde kalanlar)

| Ekran | Sorun | Plan |
|---|---|---|
| `onboarding_screen.dart`, `onboarding_allergies_screen.dart` | Başlık görseli ve "sen" hitabı tamam; kartlar hâlâ eski düzen | Kartlar `AtmosphereSurface`'e |
| `settings_screen.dart`, `disclaimer_screen.dart` | Eski düzen; uyarı metni "bilimsel kaynağa dayanmaz" diyor | Faz 4'te metin + düzen |

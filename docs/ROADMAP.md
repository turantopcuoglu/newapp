# NutriGuide — Durum ve Yol Haritası

> **Yeni oturum buradan başlasın.** Bu dosya projenin nerede olduğunu, neyin
> neden yapıldığını ve sıradaki işi anlatır. `CLAUDE.md` ise değişmez
> kuralları içerir (veri kuralları, komutlar, mimari) — ikisini birlikte oku.
>
> Son güncelleme: 2026-10-03 · Dal: `claude/recipe-save-ui-fixes-629z7x`

---

## 0. Ortam kurulumu (ÖNCE BUNU YAP)

Bu sandbox'ta **Flutter ve Dart kurulu gelmiyor** ve scratchpad her oturumda
sıfırlanıyor. Tek komutla kur:

```bash
source tool/setup_env.sh
```

Script SDK'yı indirir (varsa atlar), `pub get` çalıştırır ve `PATH`'i ayarlar.
`source` ile çalıştırmazsan sonunda yazdırdığı `export PATH=...` satırını
kendin çalıştır. Kurulum dizinini `FLUTTER_INSTALL_ROOT` ile değiştirebilirsin.

Notlar:
- Wellness sürümünden (2026-09) beri pubspec `flutter: ">=3.38.0"` istiyor;
  kullanıcının Windows makinesinde **3.44.6** kurulu. 3.24.x `intl 0.20.2`
  ile çakışır. 3.44+ `CupertinoPageTransitionsBuilder`'ı `material.dart`'tan
  değil `cupertino.dart`'tan verir.
- Web önizleme: `.claude/launch.json` içindeki `web` (port 8099).
- `flutter` root olarak çalışınca uyarı basar, sorun değil.
- Yeni bir Bash çağrısında `PATH` sıfırlanır; `export PATH="$FLUTTER_DIR/bin:$PATH"`
  satırını her komutun başına eklemen gerekebilir.

---

## 1. Şu anki durum

| Ölçüm | Değer |
|---|---|
| Tarif sayısı | **144** (kahvaltı 34 · öğle 30 · akşam 42 · ara öğün 38) |
| Malzeme kataloğu | 232, **hepsinde** besin verisi var |
| Test | **158 test, tümü geçiyor** |
| `flutter analyze` | **0 sorun** |
| `data_report --strict` | **0 hata**, 0 kalori sapması |
| Ortalama adım/tarif | 7.8 |

**Mutfak dağılımı:** turkish 42 · american 29 · international 24 ·
mediterranean 19 · middleEastern 13 · italian 11 · asian 11 · mexican 9

**Sağlık kategorisi kapsaması:** anemi 113 · insülin direnci 98 · B12 92 ·
PCOS 90 · glutensiz 88 · laktozsuz 85 · magnezyum 79 · demir 71 · regl 55

**Check-in kapsaması:** noSpecificIssue 96 · lowEnergy 65 · postWorkout 52 ·
bloated 46 · cantFocus 44 · cravingSweets 44 · pms 38 ·
**periodFatigue 12 · periodCramps 7** ← en zayıf halka

---

## 2. Bitmiş işler (özet)

Kronolojik değil, konu bazlı. Detay için `git log` (28 commit).

**Temizlik ve altyapı**
- Ölü kod silindi: erişilemeyen 5 ekran, mükerrer widget, BYOK AI yığını,
  kullanılmayan `SummaryService`, `flutter_application_1/` çöp klasörü.
- Tarifler Dart kodundan `assets/recipes/*.json`'a taşındı.
- Uzak tarif paketi: `RECIPE_BUNDLE_URL` verilirse arka planda versiyonlu
  paket indirir; bozuk/yarım indirme mevcut içeriği asla bozmaz.
- Yerel bildirimler (sabah check-in + akşam 17:00), sunucu gerekmez.

**Veri doğruluğu — tekrar eden hata sınıfı**
- Kalori artık elle yazılmıyor: `quantities` × besin verisinden hesaplanıyor.
- **57 kırık malzeme referansı** düzeltildi (`walnuts`→`walnut` gibi).
- Malzeme kataloğunun **71'inde besin verisi yoktu**, tamamlandı (232/232).
- **Sağlık kategorilerinde aynı hata**: `explore_data.dart` ölü ID'lere
  işaret ediyordu; düzeltilince magnezyum 46→73, demir 47→64 tarif gösterdi.
- 3 birebir kopya tarif + 15 yakın kopya çözüldü; börek/pidede hamur yoktu.

**Ürün eksikleri**
- **"Pişirdim" günlüğü**: kalori takibi *planlanan* öğünlerden sayıyordu
  (üç ekranda birden). Artık gerçek tüketimden geliyor.
- Malzeme miktarları ekranda hiç gösterilmiyordu — veri vardı, UI çizmiyordu.
- Tarif görselleri: `RecipeVisual` (mutfak gradyanı + yemek emojisi, 40 farklı
  emoji). Asset yok, uygulama boyutu artmıyor.
- Beslenme tercihi filtresi (vejetaryen/vegan/glutensiz/laktozsuz).
- **Sağlık alanları Keşfet'te** (2026-08-04): ana sayfadaki bölüm kaldırıldı,
  tek giriş Keşfet → "Sana Özel". O sekme artık profile uymayan kategorileri
  gizlemiyor; hepsini, kullanıcının kendi alanları önde, tarif sayısıyla
  gösteriyor. Sağlık durumu öneri sıralamasını etkilemeye devam ediyor.
- **Sağlık kategorisi sayfası yeniden kuruldu** (2026-08-04): başlık → sağlık
  durumu açıklaması (`lib/data/health_category_info.dart`, TR+EN özet +
  kaynak/ipucu listeleri) → dünya mutfağı kartı görünümünde **malzeme
  kategorileri**. Bir malzemeye dokununca o malzemeyi içeren *ve* sağlık
  durumuna uyan tarifler açılıyor (`matchesCategoryIngredient`).
- **Tarif kaydetme her yerde** (2026-08-04): `SaveRecipeButton` /
  `SaveRecipeWideButton` — her önizleme kartında ve tarif detayında; hepsi
  `favoritesProvider`'ı okuduğu için durum tek kaynaktan geliyor.
- **Tarif Defterim taşma hatası** (2026-08-04): kendi tariflerinde rozetler ve
  aksiyon butonları tek Row'daydı, TR etiketlerle 97 px taşıyordu. Rozetler
  artık `Wrap`, butonlar ayrı satırda.
- **Yemek listesi ↔ beslenme özeti entegrasyonu** (2026-08-04): "Pişirdim"
  artık ana sayfadaki yemek listesinde görünüyor ve listedeki her satırda
  pişirme tiki var (`CookedTick`). Plan + pişirme tek listede birleşiyor:
  `lib/services/day_meal_list.dart`. Planlayıcı ekranı da aynı tiki kullanıyor.
- **Haftalık/aylık grafik hatası** (2026-08-04): grafik kovaları gece yarısı
  tarihlerinden üretiliyordu, `DayBoundary.keyFor` bunları bir gün geriye
  kaydırdığı için o günün öğünleri hiçbir kovaya düşmüyordu. Yeni
  `DayBoundary.keyForDate` tarih kovaları için; `keyFor` yalnız zaman damgası
  için. Ekranlar `ref.read` yerine `ref.watch` ile canlı güncelleniyor.
- **Alışveriş → mutfak toplu taşıma** (2026-08-04): tik atılan ürünler tek
  tuşla envantere gidiyor (`InventoryNotifier.addAll`).
- **Tercihler artık gizlemiyor, sıralıyor** (2026-08-04): Keşfet'te (mutfak
  listeleri, sağlık kategorileri, malzeme kartları) sevilmeyen besin ve
  beslenme tercihi eşleşmeyen içeriği **silmiyor**, en alta indirip nedenini
  yazıyor + "beslenme tercihini değiştir" bağlantısı veriyor
  (`lib/services/preference_matcher.dart`, `browsableScoredRecipesProvider`).
  **Alerjenler hâlâ sert eleme** — bu güvenlik meselesi, test koruyor.
- **Günün önerileri araması** (2026-08-04): tarif adı, açıklaması *ve*
  malzeme adına göre arama.

**İçerik denetimi (2026-08-05)** — kullanıcı mantı ve tahin-pekmez hatalarını
bildirdi, 144 tarifin tamamı taranıp aynı sınıftan ne varsa düzeltildi:
- **Alerjen etiketleri**: 27 tarif malzemelerinin taşıdığı alerjeni beyan
  etmiyordu (fındık, süt, gluten); 12 tarif hiçbir profilin seçemediği
  `tree_nuts` etiketini taşıyordu. Etiketler artık malzemelerden türetilenin
  üstünü kapsıyor, sözlük tek yerde: `lib/data/allergens.dart`. Rapor + test
  bunu hata sayıyor. **Bu güvenlik tarafı; gevşetme.**
- **Mantı**: adımlar hamur açıyordu, listede un/yumurta/tereyağı yoktu. Hamur
  yoğurma ve dinlendirme adımları eklendi.
- **Tahin Pekmezli Ekmek**: listede pekmez yerine nar ekşisi vardı. Katalogda
  pekmez yoktu — `molasses` eklendi (besin verisiyle).
- **Kuru Fasulye Pilav**: barbunya ile yazılmıştı, kuru fasulyeye çevrildi.
- Adımda geçip listede olmayanlar (d021 sarımsak, d022 yoğurt, d035 karabiber,
  s016 limon, s025 hurma, s028 salsa malzemeleri, s030 tuz/toz biber, s004 ve
  s014 tuz, l010 marul) eklendi; listede olup adımda kullanılmayanlar (s026
  hindistancevizi sütü) çıkarıldı ya da adımlara işlendi (l006 patates+yoğurt,
  s012 krem peynir+salatalık, l004 limon).
- Adı malzemesini tutmayan tarifler düzeltildi: b005 "Fındıklı" (cevizle
  yapılıyordu), b023 "Lor Peyniri" (yoğurtla yapılıyordu), s025 "Hurmalı"
  (hurma yoktu).

---

## 3. Sıradaki iş — Wellness yeniden düzenleme (2026-10-03'te başladı)

Kullanıcı Eylül'de uygulamayı wellness yönüne çevirdi (commit `c5af4db`:
ay ışığı teması, 9 mod paleti, Bugün/Keşfet/Plan/Gelişim/Profil sekmeleri,
rutinler, Health Connect/HealthKit). Şikâyeti: animasyonlar kötü, akış
anlaşılmıyor, özellikler az hissediliyor. Eşi hekim; sağlık içeriği onun
incelemesinden geçecek. Gezinti incelemesinde bulunanlar:

- Nefes/Uyku/Hareket/Su kutucukları üç sekmede tekrar ediyor.
- **İki kopuk check-in**: `MoodPickerScreen` (focus: lowEnergy…) ve
  `WellnessCheckInScreen` (mood/energy/sleep/stress). Düşük Enerji seçilince
  Gelişim "enerji 0/7 gün" gösteriyor.
- Mod→yemek bağı görünmüyor: "Neden bu besinler?" yalnız alerji/tercihten
  söz ediyor. `lib/data/health_tips_data.dart` içindeki `MoodFoodTip`
  (her mod için gerekçe metni) tam bunun için yazılmış ama kullanılmıyor —
  silinmedi, faz 2'de bağlanacak.
- Sağlık durumu (PCOS, anemi…) yalnız eski `ExploreScreen`'den seçilebiliyor;
  oraya Bugün → Beslenme → en alt → "Tüm tarifleri keşfet" ile gidiliyor.
- Yasal uyarı "hiçbir tıbbi kaynağa dayanmaz" diyor; hekim incelemesiyle
  çelişecek.

**Faz sırası:**

1. ✅ **Animasyon + temizlik** (2026-10-03). Dokunuşlar artık bekletilmiyor
   (`MotionTap`/`WellnessIconButton` 90-100 ms gecikmesi kaldırıldı, yerine
   300 ms çift dokunuş koruması); sekme geçişi 520 ms çapraz solmadan 260 ms
   fade-through'ya indi (iki sayfa üst üste görünmüyor); `LiftIn` 630 ms
   yaylı → 320 ms düz; iOS/macOS'ta Cupertino geçişi (kenardan geri kaydırma
   geri geldi); tarif kartı → detay `Hero` (`recipeHeroTag`); tema geçişi
   700 → 450 ms. Silinen ölü ekranlar: `HomeScreen`, `NutritionDetailScreen`,
   `MealRecommendationsScreen`, `CheckInSheet`, `recommendation_list`,
   `ModeSelectionScreen`, `MyRecipesScreen`, `SectionHeader`, `WellnessPage`,
   `BreathingOrb`.
2. ✅ **Döngüyü görünür yap** (2026-10-03).
   - **Tek check-in, iki adım**: mod kartı (`MoodPickerScreen`) → aynı
     akışta `WellnessCheckInScreen` (enerji + hazırlık süresi önde; ruh
     hali/uyku/stres açılır bölümde). İkisi zaten aynı `DailyCheckIn`
     kaydını yazıyordu; kopukluk akıştaydı, veride değil. Eski
     `daily_mode_provider` silindi (yalnız yazılıyordu, okunmuyordu).
   - **Bugün** (`today_screen.dart`): check-in yoksa davet kartı → "Bugün
     senin için" (tarif + gerekçe satırı) → moda göre 2 küçük adım (akşam
     19:00 sonrası ikincisi akşam hazırlığı) → pişirdim tikli öğün listesi
     + günlük toplam. Eski 4 kutucuk ve "Durumu değiştir" kalktı.
   - **Gerekçe metni** `lib/data/focus_guidance.dart` +
     `recommendationReason` (wellness_provider). Yalnız sıralamanın
     uyguladığını söyler; tarife özgü her şey tarifin verisinden gelir
     (magnezyum/demir kaynağı malzemeler `healthConditionIngredients`'tan,
     protein/lif seviyesinden). `reviewed` alanı hekim onayı için hazır.
   - **Sekmeler**: Bugün · Beslen · İyi oluş · Gelişim · Profil. Keşfet ve
     Plan'daki tekrar eden kutucuklar gitti (`wellbeing_screen.dart`).
     Beslen'de "Sağlık alanları ve dünya mutfakları" artık listenin başında.
   - **Sağlık durumu**: kayıt akışında mutfak adımının yerine
     (`onboarding_health_screen.dart`), Profil'de kutucuk + sayfa
     (`health_condition_chips.dart`). Hedef sorusu eklenmedi: `goals`
     kaydediliyor ama hiçbir yer okumuyor; okuyan kod yazılmadan sorma.
   - Malzeme adıyla arama geri geldi (`lib/services/recipe_search.dart`).
   - Bu fazda yeni görsel gerekmedi. Görsel gerekirse prompt'ları
     `docs/design/<konu>/image-prompts.md`'ye yaz; kullanıcı GPT ile
     çizdiriyor, referans görsel yolu ver.
   - **Kalan**: ad/cinsiyet ve alerji kayıt ekranları eski tasarımda ve
     "siz" diyor; mod listesinde stres/kaygı/uykusuzluk yok (yeni
     `CheckInType` = tarif etiketleme işi, faz 4 ile); eski `ExploreScreen`
     hâlâ ayrı tasarımda.
3. **Akşam kapanışı + haftalık gözlem** ("pişirdiğin günlerde enerjin…";
   ilişki, nedensellik değil).
4. **Uzman paketi**: hekim için inceleme tablosu (durum · kural · metin ·
   kaynak · kanıt düzeyi · onay), kırmızı bayrak yönlendirmeleri, güncel
   yasal uyarı. Dil: "PCOS için" değil "PCOS'ta beslenmeyi destekleyen"
   (TİTCK tıbbi cihaz sınırı); hekim adını "incelendi" diye koymadan önce
   tanıtım kısıtlarını kontrol et.

### Görev 27 — sağlık odaklı tarif partileri (faz 4 ile birlikte sürecek)

**Sağlık odaklı tarif partisi.** Kullanıcı dört alana da ağırlık verilmesini
istedi:

1. **Regl dönemi** — en acil. periodCramps 7, periodFatigue 12.
   Magnezyum (kabak çekirdeği, tahin, bitter çikolata, ıspanak, pazı) ve
   demir (ciğer, kırmızı et, mercimek + C vitamini) odaklı tarifler.
   Hedef: her iki etiket de en az 25 tarif.
2. **Bilinçli glutensiz** — 88 tarif tesadüfen glutensiz, özellikle
   tasarlanmış değil. Karabuğday, kinoa, mısır unu, pirinç unu bazlı.
3. **PCOS / insülin direnci** — düşük glisemik, yüksek lif+protein.
   Filtre besin seviyesine bakıyor (`carbType != simple`, fiber/protein
   medium+), tarifleri buna göre etiketle.
4. **Mineral yoğun** — demir/B12/magnezyum için özellikle yazılmış tarifler.

**Üretim yöntemi** (parti başına ~10-16 tarif, her parti ayrı commit):
```bash
# 1. Boşluk haritasını ölç (hangi mutfak×öğün×check-in hücresi boş?)
# 2. Tarifleri assets/recipes/*.json'a ekle (macros: hepsi 0 bırakılır)
dart run tool/data_report.dart --fix-macros   # makroları hesaplar
dart run tool/data_report.dart --strict       # 0 hata olmalı
flutter test                                   # tümü geçmeli
```

> **Dikkat:** Kopya kuralı iki partide de *benim yazdığım* tarifi yakaladı
> (chili'ye çikolata eklemek yeni tarif değil; firik=bulgur olunca mevcut
> pilavla aynı oldu). Rapor hata verirse tarifi gerçekten farklılaştır,
> eşiği gevşetme.

### Sonraki hedef sayı
Kullanıcı 800-1000 dedi, sonra **300-400 bandını da kabul edilebilir buldu**.
Mevcut kalite çıtasında (TR+EN, 6-9 adım, miktarlı, etiketli) parti başına
~10-16 tarif çıkıyor. 300-400 gerçekçi ve rakiplere karşı savunulabilir.

---

## 4. Bekleyen işler (öncelik sırasıyla)

| # | İş | Not |
|---|---|---|
| 27 | Sağlık odaklı tarif partileri | Devam ediyor, yukarı bak |
| 22 | **Tarif görselleri — AI üretimi** | Kullanıcı AI üretimini onayladı. `imagePath` alanı ve `RecipeVisual` fallback hazır; sadece görselleri üretip `assets/images/recipes/<id>.webp` olarak koymak ve `imagePath` doldurmak kaldı. Kullanıcı **gömülü görsel** seçti (1000 görsel ≈ 35-40 MB). |
| — | Hesap + bulut senkron | Backend kararı ertelendi. Cihaz değişiminde veri kaybı şu an %100. |
| — | AI proxy (tarif uyarlama) | BYOK P0'da kaldırıldı; sunucu tarafı anahtar gerekir. |
| — | Video içerik, market entegrasyonu, Apple Health/Google Fit | Uzun vade. |

---

## 5. Bu projede öğrenilen tuzaklar

Yeni oturum bunları bilmeden aynı hatalara düşer:

1. **Çoğul/genel malzeme ID'si = sessiz hata.** Eşleşmeler birebir ID
   karşılaştırması. `walnuts`, `fish`, `cheese` gibi ID'ler hiçbir şeyi
   tutmaz ve hata vermez — sadece daha az sonuç gösterir. Kanonik liste:
   `lib/data/mock_ingredients.dart`. Rapor artık bunu doğruluyor.
2. **Plan ≠ tüketim.** `mealPlanProvider` niyettir, `cookedProvider`
   gerçektir. Kalori/makro toplamları **daima** cooked'dan gelir.
3. **Tanımlı ama okunmayan alanlar.** `relatedAllergenExclusions` /
   `relatedCheckInTypes` aylarca ölüydü ve kategori sessizce her şeyi
   listeliyordu. Yeni alan eklerken okuyan kodu da yaz.
4. **Benzerlik ölçütü baharatı saymamalı.** Tuz/yağ/baharat her tarifte var;
   sayılırsa alakasız yemekler benzer görünür (karnıyarık vs imam bayıldı
   %80 çıkmıştı). `commonBaseIngredients` bunları dışlıyor.
5. **Testin yanlış olabilir.** Sağlık skorlaması testinde skor farkı sağlık
   teriminden değil, mevcut besin bonusundan geliyordu. Test düşünce önce
   testi sorgula.
6. **Keşfet'teki sayı ile açılan liste aynı fonksiyondan geçmeli.**
   `matchesSpecialCategory` tek kaynak; ayrılırlarsa rozet yalan söyler.
   Malzeme kartları için aynı kural `matchesCategoryIngredient`'ta.
8. **Tek Row'a sığdırılan rozet + buton kombinasyonu TR'de taşar.** Türkçe
   etiketler İngilizcenin 1.5 katı olabiliyor; `Spacer`'lı Row taşma
   üretiyor. Rozetleri `Wrap`'e, aksiyonları ayrı satıra al. Dar ekran
   (320 px) widget testi bunu yakalar.
9. **`keyFor` tarih değil zaman damgası içindir.** 06:00 kaydırması yüzünden
   `keyFor(DateTime(y,m,d))` bir önceki günü verir; gün kovası üreten her yer
   `keyForDate` kullanmalı. Bu hata haftalık/aylık grafikleri boş gösterdi.
10. **Tarif verisinde iki yönlü tutarlılık ara.** Yalnızca "listedeki ID
   geçerli mi" yetmez: adımda geçen malzeme listede var mı, listedeki malzeme
   adımlarda kullanılıyor mu, ad neyi vaat ediyor? Üç sorunun üçü de gerçek
   hata yakaladı (hamursuz mantı, kullanılmayan hindistancevizi sütü,
   fındıksız "Fındıklı" parfe).
11. **`allergenTags` elle yazılırsa eksik kalır.** Malzemelerden türet, sonra
   beyanla birleştir; sözlük dışı etiket sessizce hiçbir şeyi elemez.
10. **Tercih filtresi ile alerjen filtresi aynı şey değil.** Tercih (sevilmeyen
   besin, beslenme tercihi) tarama ekranlarında **sıralar**; alerjen her yerde
   **eler**. İkisini tek `_isSafe` altında birleştirmek kategori sayfalarını
   sessizce boşaltıyordu.
7. **`analyze` + `test` platform derlemesini kapsamaz.** Bu ikisi yalnızca
   Dart tarafını derler; Gradle'a hiç dokunmaz. `flutter_local_notifications`
   eklendiğinde Android `checkDebugAarMetadata` aşamasında "core library
   desugaring" hatası verdi ve testler yeşilken kullanıcıya kadar gitti.
   Platform yapılandırması isteyen eklentiler Dart tarafında **sessizdir** —
   bağımlılık eklediysen mutlaka APK derle.
12. **Testte "bugün/dün" = `DateTime.now()` yazma.** Gün 06:00'da döndüğü
   için gece 00-06 arası koşan test bir gün kayar ve düşer (gece 03:43'te
   3 test böyle kırmızıydı). App-günü için `DateTime.parse(DayBoundary.today())`.
13. **Widget zamanlamasında duvar saati kullanma.** Çift dokunuş korumasını
   `DateTime.now()` farkıyla yazmak testlerde Başlat→Duraklat'ı yuttu: test
   saati sahte, `DateTime.now()` ilerlemiyor. `Timer` kullan, `dispose`'ta
   iptal et.
14. **Eylemi animasyon bitsin diye geciktirme.** 90 ms bile her dokunuşu
   "geç" hissettiriyordu; animasyon eylemle *aynı anda* oynar.
15. **Şeffaf sayfalar arasında çapraz solma yapma.** Sekmeler ortak arka
   plan üstünde şeffaf; ikisi aynı anda yarı görünür olunca üst üste biniyor.
   Fade-through kullan (önce eski kaybolur, sonra yeni gelir). Gizli
   sekmeler `HeroMode(enabled: false)` içinde — yoksa aynı `Hero` etiketi
   iki sekmede çakışır.
16. **Gerekçe metni doğrulamadığın sıfatı taşımasın.** "Kramp için sıcak,
   hafif tarifler" yazdık, ilk öneri soğuk ton balıklı sandviçti: etiket
   doğruydu, sıfatlar uydurmaydı. Tarife özgü her söz tarifin verisinden
   türetilmeli; test (`today_flow_test.dart`) adı geçen malzemenin tarifte
   olduğunu doğruluyor.
17. **Ekranı gerçekten gör.** `flutter test test/wellness_ui_test.dart
   --dart-define=CAPTURE_WELLNESS=true` gerçek fontlarla
   `output/wellness-build/` altına PNG yazar (mod bazlı olanlar
   `mood_experience_test.dart` → `output/mood-experience/`). Tarayıcı
   paneli bu uygulamada çok yavaş; görsel kontrol için bunu kullan.

---

## 6. Doğrulama listesi (her değişiklikten sonra)

```bash
flutter analyze                              # 0 error
flutter test                                 # 158+ test, tümü geçmeli
dart run tool/data_report.dart --strict      # 0 hata, 0 sapma
git push -u origin claude/recipe-save-ui-fixes-629z7x
```

İçerik değiştiyse `--fix-macros` çalıştırmayı unutma, yoksa
`data_integrity_test` makro uyuşmazlığından düşer.

**pubspec'e yeni bağımlılık eklediysen** yukarıdakiler YETMEZ:

```bash
flutter build apk --debug     # Gradle/AAR aşamasını da dener
```

`analyze` ve `test` Gradle'a hiç dokunmaz; desugaring, minSdk çakışması ve
AAR metadata hataları yalnızca burada görünür. **Bu sandbox'ta Android SDK
kurulu değil** (`ANDROID_HOME` boş), yani bu adım burada çalıştırılamaz —
platform yapılandırması gerektiren bir bağımlılık eklediysen kullanıcıya
"cihazda derleyip doğrulayın" demen gerekir.

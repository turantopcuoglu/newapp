# NutriGuide — Durum ve Yol Haritası

> **Yeni oturum buradan başlasın.** Bu dosya projenin nerede olduğunu, neyin
> neden yapıldığını ve sıradaki işi anlatır. `CLAUDE.md` ise değişmez
> kuralları içerir (veri kuralları, komutlar, mimari) — ikisini birlikte oku.
>
> Son güncelleme: 2026-08-05 · Dal: `claude/pdf-recipe-list-toc-96vbm1`

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
- Sürüm **3.32.5** olmalı; 3.24.x sabitlenmiş `intl 0.20.2` ile çakışıyor.
- `flutter` root olarak çalışınca uyarı basar, sorun değil.
- Yeni bir Bash çağrısında `PATH` sıfırlanır; `export PATH="$FLUTTER_DIR/bin:$PATH"`
  satırını her komutun başına eklemen gerekebilir.

---

## 1. Şu anki durum

| Ölçüm | Değer |
|---|---|
| Tarif sayısı | **143** (kahvaltı 34 · öğle 30 · akşam 42 · ara öğün 37) |
| Tarif içeriği | `docs/tarif-duzeltme-raporu.md`'den içe aktarıldı (2026-08-05) |
| Malzeme kataloğu | 241, **hepsinde** besin verisi var |
| Test | **119 test, tümü geçiyor** (16 dosya) |
| `flutter analyze` | **0 hata** (22 kozmetik info/warning kaldı) |
| `data_report --strict` | **0 hata**, 0 kalori sapması |
| Ortalama adım/tarif | 5.6 (rapor 4 yoğun adım veriyor, içe aktarıcı cümleden bölüyor) |

**Mutfak dağılımı:** international 58 · turkish 44 · american 34 ·
mediterranean 16 · middleEastern 11 · italian 11 · asian 10 · mexican 8
(rapor birçok tarifi "… Esintili Füzyon" diye etiketliyor; bunlar hem kendi
mutfağında hem Dünya & Füzyon'da görünüyor.)

**Sağlık kategorisi kapsaması:** insülin direnci 119 · anemi 118 · PCOS 92 ·
B12 91 · laktozsuz 82 · regl 81 · magnezyum 79 · glutensiz 77 · demir 73

**Check-in kapsaması:** noSpecificIssue 96 · postWorkout 68 · lowEnergy 65 ·
pms 57 · bloated 46 · cantFocus 44 · periodFatigue 33 · periodCramps 30 ·
cravingSweets 29 (regl etiketleri artık hedefin üstünde)

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

**144 tarifin düzeltilmiş sürümü içe aktarıldı (2026-08-05)** — kullanıcı
`docs/tarif-duzeltme-raporu.md` ile bütün tariflerin düzeltilmiş hâlini verdi;
ad, açıklama, malzeme, miktar, hazırlanış, mutfak ve alerjen artık oradan
geliyor (`tool/recipe_import/`). Bu sırada çıkan kök nedenler:
- **Kuru/pişmiş baz karışıklığı**: rapor tahılları kuru gramla veriyor, besin
  tablosu pişmiş bazdaydı. Tablo hizalandı, kalori sapması 37 tariften 0'a indi.
- Katalog 232 → 241: su, miso, asma yaprağı, pecorino, granola, hindistancevizi
  suyu, kuru kayısı, kuru üzüm, simit eklendi (hiçbiri "yakınıyla" değiştirilmedi).
- Besin seviyeleri (`proteinLevel`/`fiberLevel`/`carbType`) artık makrolardan
  türetiliyor; eskiden elle yazılmıştı ve hiçbir kuralla tutarlı değildi.
- **S020 + S036 birleşti** (kullanıcı kararı): raporda ikisi de 200°C fırın
  nohuttu, tek fark sumaktı. Tek tarif ikisinin baharatını taşıyor, tarif
  sayısı 143. Birleştirme `build_recipes.py` içinde `DROPPED`/`MERGED` ile
  kayıtlı, yeniden içe aktarmada korunur.

**Tarif kitabı PDF (2026-08-05)** — `tool/generate_recipe_pdf.py` bütün
tarifleri tek PDF'e basıyor: kapak, sayfa numaralı **tarif listesi**
(içindekiler) + PDF yer imleri, sonra öğün türüne göre her tarif (künye,
makro şeridi, miktarlı malzemeler, numaralı adımlar, alerjenler). Metin
kaynağı JSON + Dart sözlükleri; PDF'e elle içerik yazılmıyor. Çıktı:
`docs/NutriGuide-Tarif-Kitabi.pdf` (77 sayfa). Türkçe karakterler için
DejaVu fontu gerekiyor, `--locale en` ile İngilizcesi üretilir.

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

## 3. Sıradaki iş — Görev 27 (devam ediyor)

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

---

## 6. Doğrulama listesi (her değişiklikten sonra)

```bash
flutter analyze                              # 0 error
flutter test                                 # 119+ test, tümü geçmeli
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

# NutriGuide — Durum ve Yol Haritası

> **Yeni oturum buradan başlasın.** Bu dosya projenin nerede olduğunu, neyin
> neden yapıldığını ve sıradaki işi anlatır. `CLAUDE.md` ise değişmez
> kuralları içerir (veri kuralları, komutlar, mimari) — ikisini birlikte oku.
>
> Son güncelleme: 2026-08-03 · Dal: `claude/recipe-app-strategy-aojpcj`

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
| Tarif sayısı | **144** (kahvaltı 34 · öğle 30 · akşam 42 · ara öğün 38) |
| Malzeme kataloğu | 232, **hepsinde** besin verisi var |
| Test | **69 test, tümü geçiyor** (10 dosya) |
| `flutter analyze` | **0 hata** (24 kozmetik info/warning kaldı) |
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
- **Sağlık alanları ana sayfada**: kullanıcının kendi alanları geniş kart,
  diğerleri keşif şeridi. Sağlık durumu artık öneri sıralamasını da etkiliyor.

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
6. **Ana sayfadaki sayı ile açılan liste aynı fonksiyondan geçmeli.**
   `matchesSpecialCategory` tek kaynak; ayrılırlarsa rozet yalan söyler.

---

## 6. Doğrulama listesi (her değişiklikten sonra)

```bash
flutter analyze                              # 0 error
flutter test                                 # 69+ test, tümü geçmeli
dart run tool/data_report.dart --strict      # 0 hata, 0 sapma
git push -u origin claude/recipe-app-strategy-aojpcj
```

İçerik değiştiyse `--fix-macros` çalıştırmayı unutma, yoksa
`data_integrity_test` makro uyuşmazlığından düşer.

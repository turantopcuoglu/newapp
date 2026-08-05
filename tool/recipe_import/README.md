# Tarif düzeltme raporunu içe aktarma

`docs/tarif-duzeltme-raporu.md` — 144 tarifin düzeltilmiş hâli (ikisi
birleştiği için uygulamada 143) — tarif
içeriğinin kaynağıdır. Ad, açıklama, malzeme, miktar, hazırlanış, mutfak ve
alerjen bilgisi oradan gelir; `assets/recipes/*.json` bu araçlarla üretilir.

İkinci kaynak `docs/yeni-tarifler.md` (220 yeni tarif, B035-S093). Şeması
farklı olduğu için ayrı ayrıştırıcısı var: `parse_pack.py` + `build_pack.py`.

## Çalıştırma sırası

```bash
python3 tool/recipe_import/build_recipes.py                   # md -> JSON
python3 tool/recipe_import/build_pack.py                      # 220 yeni tarif
dart run tool/data_report.dart --fix-macros                   # makroları hesapla
python3 tool/recipe_import/apply_tags.py                      # seviye + etiket
dart run tool/data_report.dart --strict
flutter test
python3 tool/generate_recipe_pdf.py
```

Sıra önemli: `apply_tags.py` besin seviyelerini **hesaplanmış** makrolardan
türetir, o yüzden `--fix-macros`'tan sonra çalışmalı.

## Dosyalar

| Dosya | İşi |
|---|---|
| `parse_report.py` | Markdown raporu tarif tarif ayrıştırır (`build_recipes.py` bunu çağırır; tek başına çalıştırılırsa ayrıştırmayı dosyaya yazar ve tutarlılık özeti basar). Rapordaki bozuk başlıkları (kırpılmış satırlar, ortadan bölünmüş künye) burada temizler. |
| `ing_map.py` | Rapordaki malzeme adı → kanonik katalog ID(leri). Bir satır birden çok malzeme olabilir ("Tuz ve karabiber"). |
| `table_names.json` | Bölüm özet tablolarından alınan tam Türkçe adlar; 20 tarifte başlık satırı kırpık geldiği için ad buradan okunur. |
| `build_recipes.py` | Ayrıştırılmış raporu `assets/recipes/*.json` üzerine yazar: ad, açıklama, adımlar, malzeme + miktar, mutfak, alerjen, porsiyon. |
| `parse_pack.py` | 220 yeni tarif belgesini ayrıştırır (TR\|EN malzeme tablosu, TR+EN adım satırları). |
| `ing_map_pack.py` | Yeni paketin malzeme adları + katalogda olmayanların besin verisi. Pişmiş→kuru çevrim katsayıları da burada. |
| `build_pack.py` | Yeni tarifleri JSON'a **ekler** (mevcutlara dokunmaz), kopyaları alır dışarıda bırakır. |
| `apply_tags.py` | Yeni makrolardan `proteinLevel`/`fiberLevel`/`carbType` türetir, check-in etiketlerini gözden geçirir. |

## Bilinmesi gerekenler

- **Miktar önceliği:** satır başındaki gram/ml değeri esastır. Parantez içi
  çoğu zaman *pişmiş* ağırlıktır ("50 g (pişince yaklaşık 150 g)") ve besin
  tablosu kuru bazda olduğu için oradan okumak kaloriyi üçe katlar. Parantez
  yalnız "yenebilir" dediğinde (kabuk/çekirdek düşülmüş) kazanır.
- **Kuru/pişmiş baz:** pirinç, makarna, erişte, kuskus, kinoa, arpa, bulgur,
  mercimek, bakla ve yulaf kuru; nohut ve fasulyeler pişmiş bazdadır.
  `ingredient_nutrition_data.dart` de bu ayrıma göre doldurulmuştur.
- **Yoğurt:** raporda Türkçe metinlerde "Türk yoğurdu" yazıyor; kullanıcı
  kuralı gereği Türkçede sade "yoğurt" olur, İngilizcede "Turkish yogurt"
  kalır. Çevrim `build_recipes.py` içindeki `TR_YOGURT` listesinde.
- **Birleştirilen tarif:** raporda S020 ve S036 aynı yemek (200°C fırın
  nohut, tek fark sumak). Kullanıcı kararıyla tek tarifte birleşti:
  `build_recipes.py` içinde S036 `DROPPED`, S020 ise `MERGED` ile ikisinin
  baharatını taşıyor. Bu yüzden tarif sayısı 143.
- **Adımlar:** rapor her tarifi 4 yoğun adımda topluyor; içe aktarıcı bunları
  cümle sınırından bölerek 4-8 adıma çıkarır. Metin birebir korunur.

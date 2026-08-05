# Tarif düzeltme raporunu içe aktarma

`docs/tarif-duzeltme-raporu.md` — 144 tarifin düzeltilmiş hâli — tarif
içeriğinin kaynağıdır. Ad, açıklama, malzeme, miktar, hazırlanış, mutfak ve
alerjen bilgisi oradan gelir; `assets/recipes/*.json` bu araçlarla üretilir.

## Çalıştırma sırası

```bash
python3 tool/recipe_import/parse_report.py /tmp/report.json   # md -> yapısal
python3 tool/recipe_import/build_recipes.py                   # JSON'a yaz
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
| `parse_report.py` | Markdown raporu tarif tarif ayrıştırır. Rapordaki bozuk başlıkları (kırpılmış satırlar, ortadan bölünmüş künye) burada temizler. |
| `ing_map.py` | Rapordaki malzeme adı → kanonik katalog ID(leri). Bir satır birden çok malzeme olabilir ("Tuz ve karabiber"). |
| `table_names.json` | Bölüm özet tablolarından alınan tam Türkçe adlar; 20 tarifte başlık satırı kırpık geldiği için ad buradan okunur. |
| `build_recipes.py` | Ayrıştırılmış raporu `assets/recipes/*.json` üzerine yazar: ad, açıklama, adımlar, malzeme + miktar, mutfak, alerjen, porsiyon. |
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
- **Adımlar:** rapor her tarifi 4 yoğun adımda topluyor; içe aktarıcı bunları
  cümle sınırından bölerek 4-8 adıma çıkarır. Metin birebir korunur.

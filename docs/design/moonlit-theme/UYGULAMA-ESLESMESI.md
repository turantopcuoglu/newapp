# Onaylı çizimin uygulamaya aktarılması

7 Eylül 2026. Mevcut Flutter uygulamasının sekiz ana wellness ekranı, onaylanan gece mavisi çizimler temel alınarak yeniden düzenlendi.

## Görsel eşleşme

| Referans | Uygulama |
|---|---|
| Bugün | Ortak ay ve ufuk sahnesi, iki satırlı başlık, ince durum şeridi, sağa taşan orijinal yemek fotoğrafı, mint ana eylem, ince rutin satırları |
| Günlük durum | Dört kısa seçim grubu, çizgili seçim alanları, ek durumların açılır alanda bulunması, isteğe bağlı kayıt |
| Besin seçimi | Orijinal nohut, bulgur ve domates fotoğrafları, gerçek mutfak durumu, malzeme değiştirme ve alışveriş eylemleri |
| Tarif | Orijinal tabak fotoğrafı, üç kısa açıklama, açılır malzeme listesi, adımlı pişirme |
| Nefes molası | Orijinal ışıklı mavi küre, canlı zamanlayıcı, duraklat/devam et ve tamamla |
| Uykuya hazırlık | Ay ışıklı başlık, yatış saati seçimi, üç hazırlık satırı, içecek bağlantısı, nefes eylemi |
| Gelişim | Hafta/ay geçişi, gerçek özbildirimlerden nokta grafiği, eksik günlerin boş gösterimi, öğün ve mola sayıları |
| Profil | İnce gruplanmış tercih ve veri satırları, alerji/intolerans düzenleme, bağlantılar, wellness JSON önizleme/kopyalama ve silme |

Tema; koyu lacivert zemin, ince normal ağırlıkta başlıklar, sıcak altın yardımcı metinler, mint geçişli düğmeler ve çizgi ikonlu yüzen alt menü etrafında birleştirildi. Büyük yazıda satırlar ve menü yüksekliği uyarlanır. Onaylı görseldeki sabit örnek isim, sağlık değeri ve grafik verileri üretimde kullanılmaz; kullanıcı kayıtları görüntülenir.

## Orijinal görseller

Dört tasarım panosu `assets/moonlit/` içine değişmeden alındı; kaynaklarla SHA-256 değerleri eşleşiyor. `moonlit_assets.dart` kaynak bölgelerini çalışma anında kadrajlar. Ay, ufuk, besin fotoğrafları ve nefes küresi yeniden çizilmiş yaklaşık karşılıkları değildir. Kaynak listesi ve özet değerleri `assets/moonlit/README.md` dosyasındadır.

Nohutlu bulgur kasesi, fotoğraftaki yemeği temsil eden gerçek katalog tarifi olarak eklendi. Bulgurun gluten içerdiği filtrelere dahildir. 15 dakika, önceden pişirilmiş nohut ve bulgurla hazırlama süresidir; tarifte açıkça belirtilir. Uygun olmayan kullanıcıya sırf görseli göstermek için bu tarif sunulmaz. Farklı tariflerin görseli mevcut tarif bileşenini kullanır.

## Doğrulama ve çıktılar

- 139 test: mevcut veri/filtre kontrolleri, sekiz ekranın görüntüleri, büyük yazı ve İngilizce yerleşim, açık tarifte alerji değişmesi ve yalnızca açık “Pişirdim” eyleminde tüketim kaydı.
- Android debug derlemesi ve mevcut emülatör uygulamasının üzerine kurulum. Kullanıcı profili korunur.
- `output/wellness-build/android-moonlit-home.png`: Android emülatöründeki gerçek ana ekran.
- `output/wellness-build/reference-01-today.png`, `reference-2.png` … `reference-5.png`: uygulama widget'larıyla alınmış beş ana sekme. Bu görüntülerde Ece ve wellness kayıtları yalnızca test verisidir.
- `output/wellness-build/06-check-in.png`, `07-breathing.png`, `08-recipe.png`: diğer üç uygulama ekranı.

Bu değişiklik görsel uygulamayı ve ilgili etkileşimleri tamamlar. Sağlık verilerinin fiziksel saat/yüzük üzerinde doğrulanması ve yol haritasının ileri modülleri önceki teslim belgesinde belirtildiği gibi ayrı işlerdir.

# NutriGuide — görerek seçilen wellness deneyimi

8 Eylül 2026. **Analiz ve tasarım önerisi; uygulama değişikliği onay bekliyor.** Bu çalışma yalnızca tasarım belgeleri ve çizimler üretir. `lib/`, platform projeleri ve mevcut uygulama görselleri değiştirilmez.

## 1. Bugün gerçekten ne var?

Önceki liste 18 alanda 115 özellikten oluşan bir yol haritasıydı. Tamamlanmış özellik listesi değildi. Mevcut ürün, yemek uygulamasının korunmuş araçlarına eklenen bir wellness çekirdeğidir. 139 testin geçmesi de 115 ürün özelliğinin tamamlandığı anlamına gelmez; bu önceki teslimin test sonucudur, bu tasarım çalışmasında yeniden çalıştırılmadı.

Kod karşılaştırması: **8 maddede çekirdek akış var; 34 madde kısmi; 5 madde bağlantı altyapısı düzeyinde; 68 madde uygulanmamış.** Bir katalog maddesi birkaç koşul içerdiğinden bu sayılar bir tamamlanma yüzdesi değildir. [115 satırlık durum ve kod kanıtı](OZELLIK-DURUMU.md), [makine okunur eşleştirme](feature-audit.json).

| Durum | Somut kapsam |
|---|---|
| Kullanılabilir çekirdek | Günlük duygu/enerji/stres/uyku hissi; alerji/intolerans/diyet filtreleri; katalogdan tarif; porsiyonlu tüketim; mutfak/alışveriş/öğün planı; su/içecek; dört kısa metinli rutin; alışkanlık; akşam kontrolü; manuel uyku; enerji geçmişi; şifreli yerel kayıt |
| Kısmi | Kişiselleştirilmiş günlük plan; süre/gerekçe/alternatifler; beslenme ve lif istatistiklerinin bütünleşmesi; içerik filtreleri; bildirim kontrolleri; JSON kopyalama; erişilebilirliğin tam cihaz denetimi |
| Bağlantı kodu var | Health Connect / HealthKit üzerinden adım, uyku ve antrenman süresi okuma, kaynak ve izin ekranı. Fiziksel saat/yüzükle uçtan uca doğrulama eksik; iOS derlenmedi. |
| Henüz yok | Marka OAuth bağlantıları; HRV/dinlenik nabız/toparlanma; canlı saat uygulaması; üretken tarif AI ve sohbetli koç; barkod/fotoğraftan öğün; uyku sesleri; yoga/pilates/kuvvet programları; odak aracı; sindirim/döngü günlükleri; sosyal/topluluk; çevre verileri; uzman/laboratuvar modülleri; kapsamlı CSV/PDF raporları |

Tasarımda bir kart çizmek o işlevi hazır hale getirmez. Yeni Keşfet ekranı yalnızca kullanılabilir işlevleri açar. Gelecek modüller için boş butonlar veya çalışmayan “başlat” eylemleri sunulmaz. Geliştirici özellik kataloğundaki durumlar kullanıcı arayüzünden ayrıdır.

## 2. Mevcut deneyimin sorunları

1. Ana ekranın büyük sloganı ve sahnesi ekranın önemli kısmını kaplıyor. Araçlar görülebilmek için uzun kaydırma istiyor.
2. Beslen ekranında öğün planı, alışveriş, içecekler ve tarif defteri malzeme listesinin altında kalıyor. Kullanıcı bunların mevcut olduğunu kolayca anlayamıyor.
3. Rutinler sekmesi doğrudan uyku hazırlığıyla açılıyor. Nefes, farkındalık, yürüyüş, esneme ve alışkanlıklar sayfanın devamında; sekme adı kapsamını göstermiyor.
4. Sağlık bağlantıları Profil içinde. Saat veya yüzük verisi kullanmak isteyen kişi bu yolu keşfetmek zorunda.
5. Açıklamalar, görsel hiyerarşide eylemlerle yarışıyor. İnce, küçük ve birbirine benzeyen satır ikonları hızlı seçim için yeterince ayırt edici değil.
6. Wellness ekranları ve korunmuş tarif araçları farklı yoğunluk/yerleşim dilleri taşıyor. Dönüşüm sadece ana ekranı kapsarsa tutarsızlık devam eder.
7. Öneri motorunda referans nohutlu bulgur kasesi, filtrelerden sonra sabit öne alınıyor (`wellnessRecipesProvider`). Bu, uygun başka tariflerin günlük bağlama göre öne çıkmasını engelleyebilir. Görsel yeniden tasarımın yanında bu ürün borcu açıkça ele alınmalı: fotoğraf gösterme isteği kişiselleştirme sırasını belirlememeli.
8. Mod bilgisi kayıtlı olsa da mevcut tema moda göre değişmiyor. Sağlık verisi de bugün doğrudan gelişmiş besin önerisi üretmiyor.

Bunlar kod/yerleşim incelemesinden çıkarımlardır; yeni kullanıcı araştırması yapılmış gibi sunulmaz. “İnsanlar artık hiç okumuyor” varsayımı yerine, bu ürün için **seçim öncesi okunacak metni azaltma** hedefini test edeceğiz.

## 3. Yeni bilgi mimarisi

Alt menü: **Bugün · Keşfet · Plan · Gelişim · Profil**. Her sekme aynı yerde, ikon ve kısa etiketle kalır. Beslenme ana ekranda tam genişlikte birincil kart ve Keşfet'in ilk alanı olur; ürünün ayırt edici tarafı korunur.

| Sekme | İlk görünüm | Derinleşme |
|---|---|---|
| Bugün | Kısa başlık/mod seçimi; büyük beslenme kartı; Nefes, Uyku, Hareket, Su kartları | Ana ekranı düzenle, günlük durum, ilgili alanın detayları |
| Keşfet | Arama; Beslenme, Uyku, Hareket, Zihin, Su, Alışkanlıklar için 2 sütunlu büyük dikdörtgenler; Sağlık verileri kartı | Alan içindeki kullanılabilir araçlar, isteğe bağlı bilgi |
| Plan | Sabah/Gün/Akşam kısa seçici; seçilmiş öğün ve rutinler, büyük + ekleme kartı | Öğün planlayıcıya bağlantı; rutin planlama için gerekli yeni veri modeli |
| Gelişim | Enerji, Uyku, Hareket, Beslenme için büyük ölçüm kartları | İlgili grafiğe dokun; veri kaynağı ve eksik gün bilgisi |
| Profil | Tercihler, Görünüm, Bağlantılar, Verilerim, Bildirimler büyük ikonlu grupları | İlgili tercih veya izin ekranı |

Keşfet, uygulamanın tamamını tanıtan tek bir dizindir. Tariflere ait eski “Keşfet” sayfası kullanıcıya “Tarifler” olarak açılır; aynı isimli iki farklı merkez bırakılmaz. Aramada yalnız uygulanmış araçlar döner; “nefes”, “rahatla”, “su”, “alışveriş” gibi kısa eş anlamlılar desteklenir. Sonuç yokken “Sonuç yok” ve kategorilere dönme seçeneği vardır.

## 4. Alan içi araç haritası

| Alan | Büyük seçim kartları | Bugünkü kaynak / geliştirme |
|---|---|---|
| Beslenme | Bugünkü tabak, Tarifler, Mutfak, Öğün planı, Alışveriş | Mevcut ekranlar yeniden giydirilir; eski tarif defteri/favoriler Tarifler içinde kalır. |
| Uyku | Hazırlan, Uyku kaydı, Geçmiş | Mevcut akışlar; ses/hikâye/programlar ancak içerik ve oynatıcı geliştirildiğinde eklenir. |
| Hareket | Yürüyüş, Esneme, Aktivite | İlk iki mevcut zamanlayıcı; Aktivite cihaz verisi yoksa bağlantı/manuel oturum durumunu açıklar. |
| Zihin | Nefes, Farkındalık | Mevcut kısa metinli oturumlar; günlük yazma ve sesli meditasyon hazır gibi gösterilmez. |
| Su | Su ekle, İçecekler, Geçmiş | Mevcut kayıtlar; su hedefi ve hatırlatması ayrı ürün işi. |
| Alışkanlıklar | Kendi alışkanlık kartları, + Ekle | Mevcut işaretleme; ileri haftalık hedefler henüz yok. |
| Sağlık verileri | Bağlan, Alan seç, Son okuma, Kaynaklar | İşletim sistemine uygun tek sağlık merkezi; doğrudan saat/yüzük eşleştirdiğimiz izlenimi verilmez. |

Bütün katalog tek ekrana 115 küçük ikon olarak yığılmaz. Önce 6 alan, sonra her alanda 2–6 araç görünür. Kullanıcı istediği araçları ana ekrana sabitleyebilir. Hassas gelecek modüller kişisel seçimle eklenir, varsayılan görünür yapılmaz.

## 5. Kart ve görsel kuralları

- Telefon referansı 390 × 844 mantıksal piksel; yatay kenar boşluğu 20, sütun arası 12. İki sütunda kart eni 169. Kategori yüksekliği 126–148; geniş yemek kartı 164–184. İç boşluk 16; köşe 22. Başlık 26–30, kart etiketi 18–20, kısa durum 13–14. Büyük yazıda sabit yükseklik kalkar ve gerekirse tek sütuna geçilir.
- Temel zemin `#001426`, düz kart `#082337`, ana metin `#F1F6FA`, ikincil metin `#B7CCDA`, mint `#9DE3D0`, ay ışığı `#EED6A4`. Ufuk yalnız başlık/arka plan atmosferinde; metnin altında hareketli veya yoğun doku yok.
- Büyük, sade, tanınabilir 52–64 boyutlu ikonlar: tabak, ay, yürüyen kişi, nefes dalgası, damla, işaretli takvim. Aynı anlam için uygulama boyunca aynı ikon kullanılır. Ayrı ayrı süslü logolar veya emoji fontları kullanılmaz.
- Fotoğraf yalnız yemek gibi içerik tanımayı kolaylaştırdığı yerde. Diğer alanlar tutarlı vektör ikonlar. Yeni çizimdeki yemek fotoğrafı örnek görseldir; uygulama aşamasında kullanıcı onaylı kaynak/asset ayrı teslim edilir ve tarifiyle eşleştirilir.
- Kartta bir büyük ikon, 1–2 kelimelik ad, gerekiyorsa tek kısa durum bulunur. Satır satır tanıtım paragrafları kaldırılır. Yalnız ikon kullanmak yerine kısa etiket korunur: ikonların anlamı bağlama göre belirsiz olabilir. [NN/g ikon kullanılabilirliği](https://www.nngroup.com/articles/icon-usability/).
- Ana dokunma alanları ve “i” için proje hedefi en az 48 × 48 mantıksal piksel. Görsel i çemberi 20–24 olabilir, dokunma kutusu büyüktür. Ekran okuyucu etiketi “Nefes hakkında bilgi”.
- Normal metin kontrastı en az 4.5:1, büyük metin en az 3:1; işlevsel ikonlar 3:1. Bunlar tasarım kabul hedefleridir; üretilmiş raster çizimin her pikseli için sertifika değildir. [WCAG 2.2](https://www.w3.org/TR/WCAG22/).

## 6. “i” davranışı: bilgi istenince açılır

Kartın ana alanı aracı açar. Ayrı “i” düğmesi araç başlatmadan bir alt pencere açar. Kart dokunması ile bilgi düğmesinin olayları ayrılır; iç içe tetikleme oluşmaz. Su kartı Su alanını açar, açıkça işaretli “+250 ml” hızlı eylemi ise kayıt yapar ve geri alma sunar. Bir karta bakmak tüketim veya tamamlanma kaydı oluşturmaz.

İlk bilgi penceresinde: büyük alan ikonu + kısa başlık; en fazla 3 kısa madde; gerektiğinde kaynak/güncellik satırı; “Daha fazla” açılır alanı; görünür kapat düğmesi. Arka plan kararır, içerik okunabilir düz yüzeyde kalır. Geri tuşu kapatır; odak açan düğmeye döner. Uzun bilgi ekran yüksekliği sınırlı kaydırılan alana açılır, kullanıcının ana akışını kaybettirmez.

| Pencere | İlk katmandaki içerik |
|---|---|
| Nefes hakkında | Rahat tempoda; 2 dakika; istediğinde durdur. İsteğe bağlı ayrıntıda rehber ve içerik kaynağı. |
| Neden bu tabak? | Gerçekte uygulanan tercih eşleşmesi, hazırlanma koşulu, besin grupları. Her gerekçe gerçek veriyle üretilir; eşleşme yoksa iddia gösterilmez. |
| Sağlık verileri | Hangi alanlar okunur, hangi sağlık merkezinden gelir, son okuma ve kullanıcı kontrolü. Sistem izin ekranından önce alanlar açıkça listelenir. |
| Enerji | “Senin kaydın”; tarih aralığı/veri kapsamı; cihaz skoru olmadığının açıklaması. |

**İçeri saklanmayacaklar:** alerjen ve tarif engeli, süre/ön hazırlık koşulu, bağlantı yok/veri yok/eski veri durumu, veri okuma izninin kapsamı, silme gibi bir eylemin sonucu. Metni azaltmak bunları belirsizleştirmemeli.

## 7. Moda göre atmosfer

Görsel tema ruh hali kaydından ayrı bir tercihtir. “Moduma uyum sağla” kullanıcı tarafından açılır; manuel “Görünümü sabitle” seçimi her zaman vardır. Kaydı atlayan kişiye soru zorunlu tutulmaz; varsayılan Denge uygulanır. Saat/yüzük değerinden gizlice psikolojik durum çıkarılmaz.

| Örnek kullanıcı seçimi | Atmosfer | Değişmeyenler |
|---|---|---|
| Yorgun → Dinlenme | Lacivert üzerinde mat lavanta `#C8B9EE`; az dokulu yumuşak ufuk; hareket kapalı | Kart sırası, isimler, navigasyon, hedef boyutları ve alerji filtreleri |
| Sakin → Denge | Mevcut gece mavisi, mint `#9DE3D0`, ince şampanya ay çizgisi | Aynı bileşen ve bilgi hiyerarşisi |
| Enerjik → Canlı | Lacivert üzerinde açık turkuaz `#94DFE4`, daha belirgin ama durağan ışık şeridi | Aynı kontrol konumları ve okunaklı düz kart yüzeyleri |

Değişim vurgu, arka plan dokusunun opaklığı ve dekoratif ışıkla sınırlıdır. Anlam taşıyan uyarı/seçim stilleri ayrıca korunur. Kullanıcının yorgunluğu karanlık/kırmızı “kötü durum” ekranıyla cezalandırılmaz. Renklerin sağlığı iyileştirdiği iddia edilmez; bunlar estetik tercihlerdir.

Tema değişimi en fazla 240 ms yumuşak geçiş; azaltılmış hareket etkinse anlık. Sürekli titreşim, yanıp sönme, zorunlu orb animasyonu yok. Kartlar ruh haline göre yer değiştirmez. Öneri içeriği değişebilir; kullanıcının konumsal alışkanlığı korunur. Mod kaydı gece boyunca kalıcı psikolojik etiket sayılmaz; günlük kayıt tarihi gösterilir ve kolayca değiştirilebilir.

## 8. Sağlık bağlantısı yeni dilde nasıl görünür?

Keşfet ve Profil aynı “Sağlık verileri” ekranına gider. Saat/yüzük çizimi sadece bu veri türünü temsil eder; Bluetooth ile doğrudan her markaya bağlanma iddiası değildir. Android'de Health Connect, iOS'ta Apple Health seçeneği görünür. Veri gelmediyse sayısal sıfır veya uydurma başarı puanı gösterilmez.

Durumlar: Bağlantı kur → Veri alanlarını seç → Sistem izni → Okunuyor → Veri alındı / Henüz veri yok / Bazı alanlar okunamadı. Başarılı izin diyaloğu tek başına “bağlandı” olarak yorumlanmaz. Son okuma zamanı ve kaynak görünür; ayrıntılar i penceresinde açılır. Oura/WHOOP doğrudan hesap bağlantıları, HRV ve toparlanma skorları gelecek kapsamdır; çizimde bir logo kullanarak hazırmış gibi gösterilmez.

## 9. Onay sonrasındaki geliştirme sırası

| Paket | Yapılacak iş | Çıkış ölçütü |
|---|---|---|
| A — Bileşen sistemi | Büyük görsel kart, ikon seti, bilgi alt penceresi, durum rozeti, tema tokenları | Gerçek 390 × 844 Flutter görüntüsü çizimin yerleşimiyle karşılaştırılır; onaylı varlıklar manifestte kayıtlıdır. |
| B — Keşif ve gezinme | Yeni 5 sekme; Keşfet; alan sayfaları; mevcut araçlara yönlendirme | Kullanılabilir bütün araçlar Keşfet'ten en fazla 2 seçimde; eski tarif akışları kaybolmaz. |
| C — İç ekranların dönüşümü | Beslenme/tarif/alışveriş/plan/rutin/uyku/gelişim/profil/bağlantılar | Bir karttan girilen eski ekran yeni görsel dille tutarlıdır; boş/hata/başarı durumları tamamdır. |
| D — Kişiselleştirme | Ana ekran sabitle/gizle; görünüm seçimi; isteğe bağlı mod uyumu | Kalıcı tercihler, azaltılmış hareket ve büyük yazı; kullanıcı seçimi otomatik tema tarafından ezilmez. |
| E — Ürün borçları | Sabit referans tarif önceliğini kaldırma; gerçek gerekçe; birleşik öğün/rutin Plan modeli | Uygunluk filtreleri zorunlu, günlük bağlam gerçekten sıralamayı etkiler; öneri ile tüketim ayrıdır. |
| F — Doğrulama | Görsel karşılaştırma, erişilebilirlik, geçişler, gerçek sağlık kaynağı ve iOS | Temel akışlar test edilir; doğrulanmamış bağlantılar tamamlandı sayılmaz. |

Bu paketler yeni görünümü çalışır hale getirir; 68 uygulanmamış katalog maddesini otomatik olarak kapsamına almaz. Yeni ürün modülleri eski yol haritasına göre ayrı geliştirilir ve hazır olduğunda mevcut alanlara eklenir. Bu teklif için takvim/efor tahmini, onaylanan ekran ve modül kapsamı üzerinden çıkarılmalıdır.

## 10. Kabul ölçütleri

- İlk ekranda beslenme + dört hızlı araç görülür; dekoratif başlık bunları aşağı itmez.
- Her ana seçim büyük ikon + kısa etiket içerir. i düğmesi aracı yanlışlıkla başlatmaz.
- Kullanıcı nefes başlatma, su ekleme, tarif açma, alışveriş ve sağlık bağlantısına ulaşma görevlerini çizim/prototipte açıklama almadan deneyebilir. Hedef: her görevde en fazla iki ana seçim; başarı ölçülmeden “daha kolay” sonucu ilan edilmez.
- İki dilde uzun etiketler, 200% yazı boyutu, ekran okuyucu odağı ve hareket azaltma doğrulanır. 360 ve 390 genişlikte kart/düğme kesilmez; 200%'de tüm kartların tek ekran içinde kalması zorlanmaz.
- Aynı moddaki çizim ve gerçek Flutter ekranı aynı test verisiyle yan yana kontrol edilir. Farklı ekran boyutu ve dinamik veri yüzünden doğal değişimler belgelenir.
- Yeni arayüzde olmayan bir özellik çalışır görünen kartla temsil edilmez. Sağlık ölçümü olmayan kullanıcı uygulamayı kullanabilir.
- Uygulamayı değiştirme onayı gelene kadar bu tasarım klasörü dışında ürün koduna müdahale edilmez.

## Çizimlerin okunması

`01-bugun-kesfet.png`: günlük hızlı eylemler ve tüm kullanılabilir alanlar.

`02-beslenme-bilgi.png`: beslenme merkezi ve isteğe bağlı i penceresi.

`03-mod-atmosferleri.png`: aynı ekranın üç görsel modu; yeni bir sağlık değerlendirmesi değildir.

Çizimler yerleşik imagegen ile üretilmiş tasarım önerileridir. Gerçek uygulama ekran görüntüsü değildir. Üretim promptları `image-prompts.json` dosyasında tutulur. Her biri son uygulama için birebir ekran resmi olarak yapıştırılacak dosya değil, geliştirilebilir bileşen ve asset tesliminin görsel referansıdır.

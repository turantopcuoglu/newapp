# NutriGuide - Gece mavisi tasarım sistemi

Uykuya hazırlık sahnesinden türetilen yeni görsel kimlik. 7 Eylül 2026. Tasarım önerisidir; uygulamaya henüz uygulanmamıştır.

## Ana fikir

Uygulamanın tümü, uyku kartındaki gece mavisi ve ay ışığı atmosferini paylaşır. Günlük rehber, yemekler, nefes ve kişisel kayıtlar aynı dünyada bulunur. Yenilikçi his; anlamlı derinlik, güçlü tipografi, içerikle bütünleşen görseller ve duruma yanıt veren küçük hareketlerden gelir.

Ana ekranın omurgası korunur: günlük durum > kişisel besinler > tarif > küçük rutinler. Görsel yenilik bu bağı daha belirgin yapmalıdır.

## Renklerin görevleri

| Rol | Renk | Kullanım |
|---|---|---|
| Ana zemin | #091B2B | Tüm ekranların gece mavisi tabanı. |
| Yüzey | #112D43 | Listeler, bilgi alanları ve bağlamsal paneller. |
| Yükseltilmiş yüzey | #193B54 | Seçim alanları, alt menü ve açılan katmanlar. |
| Ana metin | #F2F5F4 | Başlık ve önemli bilgi. |
| İkincil metin | #ADC4D3 | Açıklama, kaynak ve yardımcı etiket. |
| Yardımcı metin | #86A2B7 | Daha düşük öncelikli bilgi; fotoğraf üstünde kullanılmaz. |
| Ana eylem | #B8E9D8 | Mint buton, seçili durum ve odak. Koyu yazıyla. |
| Ay ışığı | #EAD5AE | Küçük sıcak vurgu, gece sahnesi ve tamamlanma detayı. |
| Sınır | #34546B | İnce ayırıcı ve bileşen konturu; metin yerine kullanılmaz. |

Turuncu ana eylem rengi bu konseptte mint ile değişir. Beslenme ekranındaki sıcaklık yemek fotoğraflarından gelir. Her bölüme başka baskın renk verilmez; ürünün kimliği tutarlı kalır.

## Görsel dil

- **Ufuk:** Başlıkların arkasındaki katmanlı mavi eğriler, gündelik akışa mekansal bir his verir. Metin alanının arkasında yoğun desen olmaz.
- **Dairesel form:** Tabak, besin seçimi ve nefes hareketi benzer yayları kullanır. Bu şekil bir sağlık puanı veya biyolojik ölçüm gibi gösterilmez.
- **Işık:** Aktif seçimde ince mint sınır ve çok hafif yüzey ışığı vardır. Parlama metni yutmaz.
- **Yemek:** Gerçekçi doku, sıcak yan ışık, doğal porsiyon ve seramik kap. Fotoğrafın rengiyle yüzeyin mavisi arasında kontrollü kontrast kurulur.
- **Derinlik:** Üç yüzey seviyesi yeterlidir. Ana eylem ve açılan panel dışında her öğe ayrı kart içine alınmaz.
- **Tipografi:** Büyük ama kısa başlıklar, düzenli gövde, sabit rakam genişliği kullanan süreler. 34/26/20/16/14/12 ölçeği. Lisansı doğrulanmış ve Türkçe destekli tek bir sans-serif aile seçilir; maketteki font görünümü birebir hazır asset kabul edilmez.

## Sekiz ekranın davranışı

| Ekran | Yeni tasarımın önceliği |
|---|---|
| Bugün | Ufukla bütünleşen durum özeti; en büyük alan kişisel besin ve öğün önerisi; altında kısa rutinler. |
| Günlük durum | Ayrı ruh hali/enerji/uyku/süre seçimleri; seçimin anlamı renk, sınır ve işaretle birlikte gösterilir. |
| Besinler | Gerçek besin görselleri ve yer değiştirebilir seçimler; evde olan ile alışveriş gereken ayrı bilgi. |
| Tarif | Büyük iştah açıcı sunum; neden önerildiği; malzemeler ve pişirme eylemi. |
| Nefes | Az öğe, büyük sakin form, süre, duraklat ve bitir. Alt gezinme yok. |
| Uyku | Referanstaki ay ve katmanlı ufuk tüm sahnenin parçası; seçilen yatış saati ve henüz yapılmamış adımlar. |
| Gelişim | Gece mavisi üzerinde açık etiketli kişisel kayıtlar; eksik günler açıkça boş. |
| Profil | Alerji/hassasiyet/tercih ayrımı ve veri kontrolü; aynı yüzey ve seçim dili. |

## Bileşen ve etkileşim sistemi

Ana gezinme: Bugün, Beslen, Rutinler, Gelişim, Profil. Aktif simge mint bir kapsülde, adı görünür. Dock alt güvenli alanı dikkate alır; odaklı günlük kayıt, tarif ve nefes alt akışlarında geri navigasyonu kullanılır.

Ekran kenarı 24, dikey ana aralık 24-32, kart içi 20. Ana eylem yüksekliği 54; en küçük dokunma hedefi 48. Kart yarıçapı 28, kontrol 18. Alt sayfada sabit buton, kayan içeriği veya klavyeyi kapatmaz. Büyük yazıda kartlar büyür ve ekran kaydırılır.

**Seçim:** 180 ms renk/sınır geçişi. **Sayfa:** 220 ms yumuşak geçiş. **Alt panel:** 280 ms. **Ortam:** İstenirse yaklaşık 9 saniyelik çok hafif ışık döngüsü. Sürekli animasyon yalnız görünen sahnede çalışır; uygulama arka planda durur. Azaltılmış hareket açıkken ortam ve ölçek animasyonları kapatılır. Bu süreler tasarım önerisidir, uygulanmış davranış değildir.

Kartlarda gerçek arka plan bulanıklığı zorunlu değildir; opak katmanlar ve hafif gradyanlar aynı hiyerarşiyi daha öngörülebilir biçimde verir. Geliştirme sırasında orta sınıf cihazlarda kaydırma ve enerji tüketimi ölçülür; makete bakarak performans garantisi verilmez.

## İçeriğin tasarımla bütünleşmesi

- Düşük enerji seçimi hazırlık yükünü azaltır; arayüz rengi bir tıbbi sonuç veya otomatik teşhis anlatmaz.
- Besin fotoğrafı, malzeme adı ve öneri gerekçesi aynı bölgede bulunur. Dekorasyon ana besin seçimini geri plana itmez.
- Gerekçeler gerçek filtre ve eşleşme verisinden gelir. Stok oranı kişisel sağlık uygunluğu gibi sunulmaz.
- Alerjen dışlaması görünür kalır. Süt ürünü tüketmeme tercihi ile süt alerjisi aynı alan değildir.
- Pişirmeye başla, tamamlandı demek değildir. Uyku rutini başlatılmadan kontrol daireleri boş kalır.
- Gelişim grafiği örneğinde beş kayıt ve iki eksik gün vardır. Çizgiyle eksik günler doldurulmaz.

## Durumlar

**Yükleniyor:** Koyu yüzeyde sabit iskelet; azaltılmış hareket tercihinde parlayan tarama yok. **Seçimsiz:** Kullanıcıdan kısa ve atlanabilir giriş; hayali kişiselleştirme rozeti yok. **Sonuç yok:** Sebep ve uygun alternatif yolu; alerjen filtresi gevşetilmez. **Çevrimdışı:** Yerel katalog ve kayıtlar; üretim servisi için anlaşılır bağlantı durumu. **Hata:** Düz metin ve yeniden dene; yalnız kırmızıya dayanan anlatım yok. **Tamamlandı:** Küçük işaret ve geri al seçeneği; zorunlu kutlama animasyonu yok.

## Uygulamaya aktarım

theme-tokens.json renk, tipografi, ölçü ve hareket değerlerinin kaynağıdır. Bunlar Flutter ThemeData / ColorScheme / ThemeExtension bileşenlerine taşınabilir. Ortak ufuk sahnesi, bağlamsal özet, besin kartı, seçim kontrolü, alt menü ve açıklama satırları tekrar kullanılabilir bileşenler olarak kurulmalıdır.

HorizonHeader, FoodFeature, IngredientChoice, ReasonStack, RitualPlayer, SleepScene, InsightChart ve ProfileSection önerilen bileşen sorumluluklarıdır. Mevcut Riverpod verileri ve wellness dönüşüm planı kullanılır. Görseldeki tabak fotoğrafları uygulama asset paketi yerine geçmez; üretimde ayrı ve içerikle tutarlı dosyalar gerekir.

Metin renkleri için hesaplanan düz zemin kontrast oranları theme-tokens.json içinde kayıtlıdır. Bu hesap, bitmiş arayüzün erişilebilirlik denetimi değildir; gerçek gradyan, fotoğraf, büyük yazı ve etkileşim durumları ayrıca kontrol edilmelidir.

## Teslim

Bu çalışma yeni tema ve ekran tasarımıdır. Uygulama kaynak kodu değiştirilmedi. Yerleşik image_gen kullanıldı; üretim promptları bu klasörde saklanır. Önceki onaylanan tasarımlar korunur.

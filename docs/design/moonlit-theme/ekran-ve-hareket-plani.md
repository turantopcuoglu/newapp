# Ekran ve hareket planı

Bu dosya statik maketlerin etkileşim karşılığıdır. Buradaki hareketler henüz uygulanmamıştır.

## 1. Ana ekran, kullanıcının gününe yanıt verir

Güncel günlük durum başlık altındaki ufuk şeridinde görünür. Güncelle eylemi günlük kayıt alt akışını açar. Kaydet sonrası ufukta tek, kısa bir ışık geçişi olur; besin önerisinin gerekçesi ve küçük adımlar aynı veri değişimine göre yenilenir. Öneri değişmediyse sahte bir yenileme hissi yaratılmaz.

Yemek görselinin sıcak rengi, gece mavisi yüzey içinde odak oluşturur. Başlık ve besin isimleri görselin sessiz tarafında kalır. Besinlerimi keşfet tüm profili tekrar sormadan besin seçim ekranını açar. Ana içerik görseli, ekranın kaydırılması sırasında metnin önüne geçmez.

## 2. Besin seçimi ve alternatifler

Değiştir, mevcut besini ve üç uygun alternatifi gösteren alt panel açar. Paneldeki alternatifler etiket/alerjen denetiminden geçmiş olmalıdır. Seçim sonrası yalnız ilgili satır güncellenir; tüm ekran yanıp sönmez. Sonuçtaki tariflerin ortak aday havuzu korunur.

Mutfağında var, envanter bilgisidir. Alışverişe ekle ayrı bir eylemdir; bir besinin seçili olup olmadığını temsil etmez. Butona basılınca kısa işaret ve Geri al sunulur. Eklenen malzeme yanlışlıkla tüketilmiş kabul edilmez.

Tarife geçerken aynı yemek görselinin yumuşak konum geçişi kullanılabilir. Görsel geçiş metin ve ekran okuyucu odağını geciktirmez. Üretim işlevi bulunmayan sürümde düğme Tarif bul olarak kalır.

## 3. Rutinler

Nefes ekranındaki form bir hareket kılavuzudur; ölçülen nefes veya biyometrik sinyal değildir. Kullanıcı doğal temposunda ilerler. Azaltılmış hareket açıkken halka sabit kalır, yazı ve sayaç işlevini sürdürür. Duraklat her zaman görünür; Bitir tek dokunuşla erişilebilir.

Uyku ekranında ay ve ufuk görseli bütün arka planı taşır. Akşam rutini içeriği, kullanıcının yatış saatinden türetilir; temanın koyu olması bütün günün gece olduğu anlamına gelmez. Ana sayfanın sabah durumunda ufuk biraz aydınlatılabilir; gece görünümündeki ayı sabah içeriğine zorunlu işaret olarak taşımak gerekmez. Referans maket, ortak renk dünyasını gösterir.

Kontrol listesi başlangıçta boştur. Her tamamlamada daire işarete dönüşür; Tümünü tamamla gibi yanlışlıkla seri kayıt yaratacak eylem kullanılmaz. Uyku rutini tamamlanması, uyku süresi/kalitesi ölçümü değildir.

## 4. Kayıtlar ve kişisel kontrol

Gelişim görünümü renkli başarı puanı yerine olay ve özbildirim gösterir. Grafik noktasına dokununca gün, verilen yanıt ve veri kaynağı açılır. Eksik güne dokununca Kayıt yok denir; var olmayan sonuç hesaplanmaz. Tarih seçimi ve kaynak açıklamaları büyük yazıda da erişilebilir olmalıdır.

Profil satırları dokunma alanı olan tam satırlardır. Alerji düzenlemesi sonrasında açık tarif ve besin alternatifleri yeniden denetlenir. Kayıtlarımı sil bir yönetim akışını açar; görseldeki satıra dokunmak anında tüm veriyi silmez. Önce kapsam gösterilir, sonra kullanıcı doğrular.

## Kod yapısına tasarım aktarımı

Mevcut AppTheme.light yapısına yalnız birkaç renk değişikliği eklemek yeterli değildir. Bu tema için ayrı karanlık ColorScheme ve ortak bileşen yüzeyleri gerekir. Eski accentOrange ana eylemi mint role taşınır; accentTeal veya successGreen tek başına yeni tüm durumları temsil etmez. Öğün kategorilerinin farklı renkleri, temel arayüz kimliğini parçalamayan küçük yardımcı etiketlere dönüşür.

RecipeVisual'ın mevcut gradyan/emoji fallback'i korunabilir; yeni karanlık yüzey içinde boyut ve görünürlük kuralları uygulanır. Maketteki özgün yemek fotoğrafları ayrıca hazırlanır. Ana menüde sekme başına ayrı baskın renk yerine tek seçili durum rengi kullanılır.

Her ekran için normal, seçili, basılı, devre dışı, odak, yükleme, boş ve hata durumları ortak tokenlara bağlanır. Kullanıcının tercihlerine dayalı eleme kuralları, animasyon katmanından bağımsız çalışır.

## Geliştirme kabul kontrolü

- 390 x 844 referans ve daha dar ekranlarda başlık/ana eylem taşmaz.
- Büyük yazıda iki satırlı başlıklar ve menü etiketleri kesilmez.
- Dokunma hedefleri en az 48; durum yalnız renk farkıyla aktarılmaz.
- Metin açık, yüzey koyu; yemek fotoğrafı altında rastgele metin kalmaz.
- Hareket azaltma ve ekran okuyucu odağı desteklenir.
- Gündüz ve akşam içerikleri doğru bağlamı korur.
- Bir sekmedeki besin/alerji değişikliği diğer sekmelerin gerekçelerini günceller.
- Görsel olarak tüm ekranlar aynı yüzey, ikon, tipografi ve buton ailesinden gelir.

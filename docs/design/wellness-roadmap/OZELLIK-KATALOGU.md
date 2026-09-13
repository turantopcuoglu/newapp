# Wellness özellik kataloğu

7 Eylül 2026 · Önerilen ürün kapsamı. Listelenen özelliklerin tümü mevcut uygulamada var anlamına gelmez.

Toplam: 18 alanda 115 özellik. Dağılım: F0'da 2, F1'de 36, F2'de 45, F3'te 27, F4'te 5 özellik. Bu sayılar kullanıcı işlevleridir; veri altyapısı, test ve işletim işleri ayrıca ana planda tanımlanmıştır. [JSON iş listesi](./features.json) aynı kimlikleri kullanır.

F0: temel; F1: ilk sürüm; F2: genişleme; F3: gelişmiş deneyim; F4: ayrı uzmanlık ve doğrulama gerektiren kapsam. Aşamaların çıkış ölçütleri [ana plandadır](./PLAN.md).

Veri anahtarı: **K** kullanıcı kaydı/tercihi, **C** izinli cihaz/sağlık merkezi, **İ** uzman incelemesinden geçmiş içerik, **V** doğrulanmış dış veri/servis. “K/C” otomasyonun isteğe bağlı, manuel alternatifin mümkün olduğunu belirtir. Cihazın her veri tipini sağladığı varsayılmaz.

## 1. Günlük durum ve kişiselleştirme

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| KIS-01 | Ruh hali, enerji ve öznel stres kaydı | F1 | K; tarihli geçmiş, atlama hakkı |
| KIS-02 | Uyku hissi, açlık ve tokluk kaydı | F1 | K; cihaz ölçümünden ayrı |
| KIS-03 | Hedef, alışkanlık, zaman ve bütçe profili | F1 | K; az sorulu, aşamalı kurulum |
| KIS-04 | Sabah, gün içi ve akşam için günlük plan | F1 | K/C; tek plan, en fazla üç ana öneri |
| KIS-05 | Öneri gerekçesi ve alternatif seçimi | F1 | K/C; kullanılan veri ve güncellik görünür |
| KIS-06 | Seyahat, vardiya ve yoğun gün bağlamı | F2 | K; saat dilimi ve kullanılabilir süre |
| KIS-07 | Öneri geri bildirimi ve tercih öğrenme | F2 | K; atlamak başarısızlık sayılmaz |

## 2. Besin seçimi ve beslenme takibi

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| BES-01 | Bugün tüketilebilecek besin önerileri | F1 | K/İ; zaman, tercih ve çeşitlilik odaklı |
| BES-02 | Alerji, intolerans ve tercih için ayrı filtreler | F0 | K/V; zorunlu eleme ve belirsiz içerik yönetimi |
| BES-03 | Öğün ve porsiyon tüketim kaydı | F1 | K; planlanan öğünden ayrı |
| BES-04 | İsteğe bağlı enerji ve makro takibi | F2 | K/V; miktar ve veri kaynağı görünür |
| BES-05 | Lif, besin grupları ve haftalık çeşitlilik | F2 | K/V; eksik günlükte eksiksiz alım iddiası yok |
| BES-06 | Mikrobesin alım tahmini | F3 | K/V/İ; beslenme kaydından tahmin, eksiklik tanısı değil |
| BES-07 | Barkod ve ürün etiketi okuma | F2 | V/K; ülke kapsamı, etiket doğrulama, veri lisansı |
| BES-08 | Fotoğraftan öğün taslağı oluşturma | F3 | K/V; porsiyon ve içerik kullanıcı onayından geçer |

## 3. Tarif, mutfak ve alışveriş

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| TAR-01 | Profile ve günlük bağlama uygun tarif bulma | F1 | K/İ; mevcut tarif tabanı geliştirilebilir |
| TAR-02 | Besin ve malzeme alternatifi önerme | F1 | K/V; her alternatif yeniden alerjen kontrolü |
| TAR-03 | Haftalık öğün planlama ve hazırlık planı | F1 | K/İ; tüketim sayılmaz |
| TAR-04 | Mutfak envanteri ve son kullanım hatırlatması | F2 | K; kayıtlı tarihe dayanır |
| TAR-05 | Birleşik alışveriş listesi ve bütçe | F1 | K/V; fiyat yoksa kesin toplam gösterilmez |
| TAR-06 | Aile için ortak yemek, kişi başına ayrı kısıtlar | F3 | K; her yetişkinin verisi ve izni ayrı |
| TAR-07 | Doğrulanmış malzemelerle kişiye özel tarif üretme | F3 | V/İ; yapılandırılmış çıktı, miktar ve güvenlik denetimi |

## 4. Su ve içecekler

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| ICE-01 | Su ve içecek miktarı günlüğü | F1 | K/C; dışarıdan gelen tekrarlar ayıklanır |
| ICE-02 | Kullanıcının ayarladığı su hedefi ve hatırlatma | F1 | K; sıvı kısıtında otomatik artırma yok |
| ICE-03 | Kafein miktarı ve tüketim saati | F2 | K/V; ürün miktarları tahmin olarak etiketlenir |
| ICE-04 | Kafein ile uyku günlüğünü birlikte inceleme | F2 | K/C; kişisel kayıt ilişkisi, nedensellik değil |
| ICE-05 | İsteğe bağlı alkol kaydı ve azaltma hedefi | F2 | K/İ; gizli varsayılan, yargılayıcı dil yok |

## 5. Uyku ve günlük ritim

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| UYK-01 | Manuel veya cihazdan uyku günlüğü | F1 | K/C; oturum başlangıcı, bitişi ve kaynak |
| UYK-02 | Süre ve yatış/kalkış düzeni eğilimleri | F1 | K/C; veri olmayan gece açıkça işaretlenir |
| UYK-03 | Uyku evreleri, bölünme ve kestirme görünümü | F2 | C/K; evreler cihaz tahmini, tanı değil |
| UYK-04 | Kişisel akşam hazırlık rutini | F1 | K/İ; tamamlamak uyumuş olmak değildir |
| UYK-05 | Uyku sesleri, hikâyeleri ve zamanlayıcı | F2 | İ; lisans, çevrimdışı oynatma, otomatik durdurma |
| UYK-06 | Sabah ışık ve günlük ritim hatırlatmaları | F2 | K/İ; kullanıcının programına göre |
| UYK-07 | Vardiya ve seyahat için esnek uyku planı | F3 | K/İ; standart yatış saati zorlanmaz |

## 6. Hareket ve egzersiz

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| HAR-01 | Adım, aktif süre ve antrenman geçmişi | F1 | C/K; manuel aktivite adım ölçümü gibi sunulmaz |
| HAR-02 | Oturma molası ve kısa yürüyüş rutini | F1 | K/İ; kullanıcı saat ve sıklık seçer |
| HAR-03 | Esneme ve mobilite kütüphanesi | F2 | İ; süre ve hareket düzeyi filtreleri |
| HAR-04 | Başlangıç kuvvet, kardiyo, yoga ve pilates planları | F2 | İ/K; kapasite ve tercih seçimi |
| HAR-05 | Ekipmana, zamana ve erişilebilirliğe göre uyarlama | F2 | K/İ; oturarak yapılabilen seçenekler |
| HAR-06 | Antrenman sonrası algılanan efor ve toparlanma kaydı | F2 | K/C; öznel ve ölçülen veriler ayrı |
| HAR-07 | Saatten antrenman başlatma ve canlı oturum | F3 | C; watchOS/Wear OS uygulaması ve cihaz yeteneği |

## 7. Zihinsel iyi oluş ve stres

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| ZIH-01 | Rehberli rahat nefes oturumları | F1 | İ; duraklat/bitir, zorunlu nefes tutma yok |
| ZIH-02 | Kısa meditasyon ve farkındalık | F1 | İ; metin/ses ve erişilebilirlik |
| ZIH-03 | Beden taraması ve gevşeme oturumları | F2 | İ; isteğe bağlı, durdurulabilir |
| ZIH-04 | Günlük yazma, duygu etiketleme, şükran günlüğü | F2 | K; özel içerik, dış paylaşım varsayılan kapalı |
| ZIH-05 | Duyusal odaklanma ve zor anlar için sakinleşme araçları | F2 | İ; terapi veya acil yardım olarak sunulmaz |
| ZIH-06 | Stres bağlamı ile izinli cihaz göstergelerini inceleme | F3 | K/C; cihaz stresi psikolojik tanı değildir |
| ZIH-07 | Profesyonel destek kaynaklarına erişim | F2 | V/İ; ülkeye göre doğrulanmış, güncel yönlendirme |

## 8. Alışkanlıklar ve odak

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| ALI-01 | Kişisel alışkanlık oluşturma ve takip | F1 | K; kaçırılan gün için ceza yok |
| ALI-02 | Esnek haftalık hedef ve hatırlatma | F1 | K; sessiz saatler ve erteleme |
| ALI-03 | Alışkanlıkları mevcut rutinlere bağlama | F2 | K/İ; ör. öğle sonrası kısa mola |
| ALI-04 | Odak zamanlayıcısı ve dinlenme araları | F2 | K; çevrimdışı çalışabilir |
| ALI-05 | Dijital mola ve ekran kullanımını gözden geçirme | F3 | K/V; OS erişimi ayrıca araştırılır, manuel seçenek vardır |
| ALI-06 | Sigarayı azaltma/bırakma hedefi ve kaynaklar | F3 | K/İ; tedavi dozu veya başarı garantisi yok |

## 9. Vücut ölçümleri ve toparlanma

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| VUC-01 | İsteğe bağlı kilo ve vücut ölçüsü günlüğü | F2 | K/C; kilo odaklı olmayan kullanım mümkün |
| VUC-02 | Akıllı tartıdan vücut bileşimi eğilimleri | F2 | C; üretici tahmini ve kaynak belirtilir |
| VUC-03 | Dinlenik nabız ve kişisel geçmiş | F2 | C; ölçüm bağlamı korunur |
| VUC-04 | HRV eğilimi ve veri kapsamı | F2 | C; SDNN/RMSSD ve kaynak ayrı |
| VUC-05 | Üreticinin toparlanma/enerji skorunu gösterme | F2 | C; marka adıyla, ortak sağlık puanına çevrilmez |
| VUC-06 | Ağrı, kas yorgunluğu ve dinlenme kaydı | F2 | K; semptom günlüğü, tanı değil |

## 10. Sindirim ve bedensel rahatlık

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| SIN-01 | Şişkinlik, rahatsızlık ve sindirim günlüğü | F2 | K; isteğe bağlı hassas kayıt |
| SIN-02 | Bağırsak düzeni kaydı | F2 | K/İ; dil ve sınıflama uzman incelemesi |
| SIN-03 | Öğün ve belirti zaman çizelgesi | F2 | K; zaman ilişkisini görünür kılar |
| SIN-04 | Olası kişisel örüntüleri inceleme | F3 | K; otomatik alerji veya intolerans tanısı yok |
| SIN-05 | Uzmanla paylaşılabilir sindirim özeti | F3 | K; kullanıcı tarih ve alan seçer |

## 11. Döngü ve yaşam dönemleri

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| DON-01 | İsteğe bağlı adet döngüsü takvimi | F2 | K/C; ayrı izin, varsayılan kapalı |
| DON-02 | Döngüyle birlikte belirti, enerji ve uyku kaydı | F2 | K/C; günlük durum kişiden sorulur |
| DON-03 | Döngü dönemi tahmin aralığı | F3 | K; belirsizlik görünür, gebelikten korunma aracı değil |
| DON-04 | Perimenopoz/menopoz günlüğü ve eğitim | F3 | K/İ; herkes için aynı program önerilmez |
| DON-05 | Gebelik ve doğum sonrası iyi oluş programı | F4 | K/İ; ayrı uygunluk ve uzman içerik süreci |
| DON-06 | Cinsel iyi oluş, beden farkındalığı ve eğitim | F3 | K/İ; yetişkin, mahremiyet ve içerik kontrolleri |

## 12. Sosyal ve duygusal iyi oluş

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| SOS-01 | Sosyal bağ kurma niyeti ve küçük hatırlatmalar | F2 | K; rehbere erişim zorunlu değil |
| SOS-02 | Bir arkadaşla gönüllü rutin hedefi | F3 | K; karşılıklı katılım, sağlık verisi paylaşılmaz |
| SOS-03 | Küçük grup etkinlikleri ve meydan okumalar | F3 | K/İ; kilo/kalori rekabeti varsayılan değil |
| SOS-04 | Moderasyonlu topluluk | F3 | K/İ; raporla, engelle ve insan moderasyonu |
| SOS-05 | Değerler, amaç ve haftalık kişisel değerlendirme | F2 | K/İ; hassas metinler özel kalır |

## 13. Çevresel iyi oluş

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| CEV-01 | Hava durumu ve dışarıda aktivite bağlamı | F3 | V/K; şehir seçimi, konum isteğe bağlı |
| CEV-02 | Hava kalitesi, polen ve UV bilgisi | F3 | V; bölgesel kapsam ve güncellik görünür |
| CEV-03 | Gün ışığı ve doğada geçirilen süre günlüğü | F2 | K/C; desteklenmeyen ölçüm manuel kalır |
| CEV-04 | Gürültü ve uyku ortamını gözden geçirme | F3 | K/C; mikrofon/cihaz yetkisi ayrı, sürekli kayıt yok |
| CEV-05 | İş ortamı, ergonomi ve dinlenme düzeni | F2 | K/İ; kısa kontrol listeleri |

## 14. Sağlık kayıtları ve uzman desteği

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| SAG-01 | İlaç ve takviye günlüğü/hatırlatması | F2 | K; doz kullanıcı/reçete girdisi, otomatik doz önerilmez |
| SAG-02 | Tansiyon, glikoz ve ek ölçümlerin günlüğü | F3 | K/C; kaynak, birim ve ölçüm zamanı |
| SAG-03 | Laboratuvar belgelerini saklama ve yapılandırılmış aktarım | F4 | K/V; belge doğrulama, klinik yorum ayrı |
| SAG-04 | Uzmanla randevu ve izinli rapor paylaşımı | F4 | K/V; süreli erişim, yetki yönetimi |
| SAG-05 | CGM ve ECG gibi gelişmiş kayıt bağlantıları | F4 | C/V; cihaz/ülke/API ve kullanım amacı incelemesi |
| SAG-06 | Uzman tarafından hazırlanan kişisel planı takip | F4 | K/İ; uzman kimliği, sürüm ve kapsam görünür |

## 15. Cihazlar ve sağlık bağlantıları

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| CIH-01 | Apple HealthKit bağlantısı | F1 | C; veri tipi bazında okuma izni |
| CIH-02 | Android Health Connect bağlantısı | F1 | C; özellik ve sürüm kontrolü |
| CIH-03 | Oura, WHOOP ve diğer marka hesap bağlantıları | F2 | C/V; ayrı bağlayıcılar, OAuth ve erişim koşulları |
| CIH-04 | Kaynak, son eşitleme ve izin yönetimi ekranı | F1 | C/K; bağlantı yok/eksik/eski veri durumları |
| CIH-05 | Çoklu cihazda tekrar ayıklama ve tercih edilen kaynak | F1 | C/K; aynı adım veya uyku iki kez sayılmaz |
| CIH-06 | Kullanıcının seçtiği kendi kayıtlarını sağlık merkezine yazma | F2 | K/C; okuma izninden ayrı ve geri döngü engelli |
| CIH-07 | Saatte hızlı kayıt, nefes ve günlük plan | F3 | C/K; telefon uygulamasına ek yardımcı uygulamalar |

## 16. Gelişim, içgörü ve koç

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| GEL-01 | Günlük/haftalık özet ve eksik kayıt görünümü | F1 | K/C; sayıların yanında veri kapsamı |
| GEL-02 | Kullanıcının kendi geçmişine göre eğilimler | F2 | K/C; yeterli geçmiş ve aynı ölçüm yöntemi |
| GEL-03 | Uyku, hareket, öğün ve ruh halini birlikte inceleme | F3 | K/C; ilişki ile neden-sonuç ayrılır |
| GEL-04 | Tek alışkanlığa odaklanan kişisel denemeler | F3 | K/İ; deneysel, bilimsel kanıt diye sunulmaz |
| GEL-05 | Bağlamı açıklayan sohbetli iyi oluş rehberi | F3 | K/C/İ; izinli özet, kaynak ve kapsam kontrolü |
| GEL-06 | CSV/PDF kişisel raporu ve taşınabilir veri dışa aktarımı | F2 | K/C; seçilen kayıtlar, kaynak ve birimler |
| GEL-07 | Gerekçeli günlük tempo önerisi | F3 | K/C/İ; klinik hazır oluş puanı veya başarı baskısı yok |

## 17. Programlar ve içerik

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| PRG-01 | 7/14/28 günlük uyku, hareket ve beslenme programları | F2 | İ/K; süreler ürün formatı, sonuç garantisi değil |
| PRG-02 | Süre/amaç/zorluk filtresi ve favoriler | F1 | İ/K; küçük başlangıç kütüphanesi |
| PRG-03 | Çevrimdışı içerik ve ses indirme | F2 | İ; lisans ve indirme yönetimi |
| PRG-04 | Uzman içerik yönetimi, sürüm ve inceleme tarihi | F1 | İ; yayınlama ve geri çekme akışı |
| PRG-05 | Eğitim içerikleri ve küçük bilgi adımları | F2 | İ; korkutucu veya aşırı kesin dil yok |
| PRG-06 | İsteğe bağlı öğün penceresi/oruç takibi | F3 | K/İ; uygunluk incelemesi; kısıtlayıcı beslenme varsayılan değil |

## 18. Kullanıcı kontrolü ve erişilebilirlik

| Kimlik | Özellik | Aşama | Veri ve ürün koşulu |
|---|---|---|---|
| KON-01 | Modül seçimi ve ana ekran kişiselleştirme | F1 | K; ilgisiz hassas modüller gizli |
| KON-02 | Veri tipi ve amaç bazında izin merkezi | F0 | K; cihaz, bulut ve AI için ayrı kontroller |
| KON-03 | Veriyi düzeltme, silme ve hesabı kapatma | F1 | K; kapsam, ilerleme ve tamamlanma görünür |
| KON-04 | Şifreli saklama ve isteğe bağlı uygulama kilidi | F1 | K; anahtarlar güvenli cihaz depolamasında |
| KON-05 | Büyük yazı, ekran okuyucu ve hareket azaltma | F1 | K; tasarım bileşenlerinde baştan destek |
| KON-06 | Sessiz saatler, bildirim sınırı ve kilit ekranı gizliliği | F1 | K; sağlık içeriği bildirimde varsayılan gizli |
| KON-07 | Türkçe/İngilizce, birim ve saat dilimi tercihleri | F1 | K; tarih ve ölçümlerde tutarlılık |
| KON-08 | Cihazsız ve bulutsuz temel kullanım | F1 | K; otomatik ölçüm yokken manuel deneyim |

## Kapsamın ürün sınırları

- Bu katalog bir hastalık teşhis, tedavi, ilaç dozu veya acil izleme sistemi planı değildir. Bu amaçlar ayrıca seçilirse F4 kapsamı yeniden tanımlanır.
- Mikrobiyom/DNA testi, “biyolojik yaş”, detoks skoru ve kamera ile doğrulanmamış biyometrik ölçümler temel wellness özelliği sayılarak eklenmez. İleride talep olursa ayrı kanıt ve veri erişimi incelemesi gerekir.
- Menstrüasyon, kilo, kalori, oruç, alkol, cinsel iyi oluş ve sağlık belgeleri tüm kullanıcılara zorunlu gösterilmez.
- Akıllı cihazdan vitamin, mineral veya su eksikliği çıkarıldığı varsayılmaz. Bazı cihaz göstergeleri günlük bağlam sağlar; öneri motorunun zorunlu beslenme kısıtlarını geçersiz kılamaz.
- Fotoğrafla besin tanıma, tarif üretimi, topluluk ve canlı saat oturumları ayrı geliştirme/işletim maliyeti olan özelliklerdir; yalnızca bir arayüz kartı eklenerek tamamlanmış sayılmaz.

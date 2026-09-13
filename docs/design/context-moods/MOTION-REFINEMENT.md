# Doku, renk ve hareket uygulaması — 8 Eylül 2026

Bu kayıt önceki hareket çalışmasını anlatır. Kullanıcının yeni görsel karşılaştırmasından sonra doku ve ışık sistemi yeniden düzenlendi; güncel malzeme ayrıntıları [referans eşleştirme analizindedir](../reference-material/ANALYSIS.md).

## Onboarding hatası

Onboarding adımlarındaki `PageRouteBuilder.transitionsBuilder` kapanmış bir `State.context` yakalıyordu. Son adım `pushAndRemoveUntil` ile önceki ekranları kaldırdıktan sonra tema veya erişilebilirlik değişimi, yaşamaya devam eden geçişi yeniden çiziyor ve silinmiş ekrana erişiyordu. Kaydın saklanması, yeniden açınca temanın neden göründüğünü açıklıyor.

Geçişler, uygulamanın ortak `PageTransitionsTheme` yapısını kullanan `MaterialPageRoute` ile değiştirildi. Geçiş artık kendisine ait bağlamı kullanıyor. Yalnızca kaydetme metoduna `mounted` eklemek, sonradan tekrar çalışan geçiş çizimini çözmeyecekti.

`test/onboarding_theme_lifecycle_test.dart` gerçek onboarding ekranlarını ilerletir; önceki rotalar kaldırıldıktan sonra iki tema değiştirir ve sistemin hareket azaltma bilgisini yeniler. Aynı akış düzeltmeden önce hata verdi, düzeltmeden sonra geçti.

## Görsel inceleme ve kararlar

Onaylı `02-gunluk-temalar.png` ve `02-yorgun-tum-ekranlar.png` görsellerinde kartın üst kenarı aydınlık, alt kısmı daha derin; yüzeyde ince lifler ve renkli yansımalar bulunuyor. Önceki sürümde düz dolgu ve tek kenar çizgisi bu malzeme hissini taşımıyordu.

Yeni `AtmosphereSurface`: eğimli renk dolgusu, geniş ışık düşümü, ince kıvrımlı lifler veya yatay su çizgileri, sabit tanecikler, kenar yansıması ve dokununca ilerleyen ışık. Tanecikler kareler arasında rastgele değişmez. Doku ve dokunma ışığı ayrı çizim katmanlarında tutulur.

Son doku kontrolünde liflerin ışığı ve hemen altındaki gölge belirginleştirildi; çizgi sıklığı kontrolün yüksekliğine uyarlandı. Böylece küçük düğmelerde sık çizgiler birikmez. Büyük özellik kartları, günlük durum seçimi, ana eylemler, alt menü, wellness kartları ve standart dolu düğmeler bu yüzey dilini paylaşır. Tarif fotoğrafının üzerine doku bindirilmez.

Son renk geri bildirimine göre dokuz paletin kart ve eylem renkleri daha doygun hale getirildi. Koyu kartların üzerindeki krem/beyaz karışımı azaltıldı; yansıma artık kartın kendi renk ailesinden üretiliyor. Adaçayı açık kalır; diğer temalar kendi mürdüm, kakao, indigo, gül, bakır, lavanta, petrol ve yeşim ailesinde kalır. Yazı renkleri ve fotoğrafların doğal renkleri korunur.

Palet değerleri ve taban renklerin kontrast hesapları `vivid-theme-tokens.json` dosyasındadır. Ana yazı/kart, ikincil yazı/kart ve eylem yazısı/dolgu eşleşmelerinin en düşük oranı 4,84:1. Bu hesap, fotoğrafların ve tüm geçiş karelerinin piksel bazında erişilebilirlik doğrulaması değildir.

## İncelenen hareket örnekleri

- **Headspace:** Resmî hareket kılavuzu ve tarayıcıdaki nefes/karakter örnekleri incelendi. Hareket hiyerarşisi, bilinçli hız değişimi, küçük gecikmeler ve çevresel katmanlar temel çıkarımlardı. Karakter veya marka varlıkları kopyalanmadı. [Headspace Motion](https://live.standards.site/headspace/motion)
- **Calm:** Tarayıcıdaki nefes halkası ve resmî egzersiz açıklamaları incelendi. Görsel fazın anlaşılır olması, çevresel sahne ve kullanıcı tarafından seçilebilen ritim, nefes ekranına yön verdi. Uygulamadaki rehber, nefes tutmayı zorunlu kılmaz. [Calm Breathe](https://www.calm.com/breathe), [egzersiz kontrolleri](https://support.calm.com/hc/en-us/articles/360000069973-Breathing-Exercises)
- **Google Material 3 Expressive:** Renk, şekil, boyut ve hareketin belirgin eylemler oluşturmak için birlikte kullanılmasına ilişkin resmî araştırma incelendi. Büyük etiketli kartlar korunurken hareket eklendi. Araştırmadaki kullanım sonuçları bu uygulama için ölçülmüş sonuçlar değildir. [Google Design](https://design.google/library/expressive-material-design-google-research)

## Uygulanan hareket dili

| Alan | Hareket | Süre / davranış |
| --- | --- | --- |
| Büyük kart | Basınca hafif gömülme, bırakınca toparlanma, simge tepkisi, ilerleyen kenar ışığı | 85 ms basınç; yaklaşık 670–866 ms tamamlayıcı hareket; eylem 90 ms içinde çalışır |
| Ana düğmeler | Doygun malzeme, ışık, ok hareketi; yerel FilledButton kontrollerinde yüzey yansıması | Tek dokunuşa bağlı; boşta sürekli çalışmaz |
| Simgeler | Su dolumu/kabarcık, akan nefes izleri, ay/yıldız parçacıkları, kalp halkaları, dönen odak yayları | Simgenin anlamına bağlı, kısa ve sonlu |
| Sekmeler | Kayarak yer değiştiren seçim yüzeyi; eski ekran çıkarken yeni ekran gelir | 520 ms; sayfa ve kaydırma durumları korunur |
| Sayfalar | Opaklık, ölçek ve düşey konum birlikte; arka sayfada hafif derinlik | Ortak rota geçişi; kapanmış ekrana bağlanmaz |
| Tema | Renklerin akışı ve manzaranın yumuşak karışımı | Tema 700 ms, manzara 950 ms |
| Kart girişi | Küçük yaylı yerleşme ve ayrı opaklık eğrisi | Sıraya ve atmosfere bağlı, sonlu |
| Nefes | Üç katmanda 36 ışık yaprağı, gölgeli merkez, ölçülü dış kenar, faz işareti, çevresel ışık | Seçilebilir 6 / 8 / 10 sn görsel döngü |
| Meditasyon | Üç eğimli yörünge, ön/arka aydınlatma, kısa parçacık izleri, yüzen ışıklı çekirdek | 16 sn |
| Yürüyüş | Dolgulu gövde, eklemli kol/bacak, adım kaldırma, zemin hareketi, el izleri | 2,4 sn |
| Esneme | Gövde salınımı, yumuşak kol yükselişi, omuz yayları, ışıklı eklemli figür | 12 sn |
| Oturum kontrolü | Oynat/duraklat simgesinin dönüşümü | 380 ms; devam eden süs animasyonu duraklamayı engellemez |

Figürler soyut hareket eşlikçileridir; kişiye özel duruş doğrulaması veya sensörden alınan hareket ölçümü olarak sunulmaz.

## Çalışma sınırları ve doğrulama

Rutin çizimleri ekran yenilemesine bağlı `CustomPainter` ile çizilir. Metin yalnızca nefes fazı değiştiğinde yenilenir; süre sayacı saniyede bir güncellenir. Arka planda, kapalı sekmede ve hareket azaltma tercihinde dekoratif hareket durur. Arka plandan dönüş kendi kendine seans başlatmaz. Duraklatma, tamamlamadan çıkış ve kayıt davranışları korunur.

`test/mood_experience_test.dart` iptal edilen veya silinen butonun eylem çalıştırmamasını, ritim değişirken oturumun korunmasını ve hareketin arka planda durmasını denetler. Yeni renkler, doku ve dokuz modun bütün sekmelere yayılması çalışan Flutter ekranlarıyla kontrol edilir.

Dokunma sonrasında eylemi kısa süre bekleten zamanlayıcılar da bileşen kapanırken iptal edilir. Böylece hızlı duraklatma ve hemen sayfadan çıkış, geride zamanlayıcı veya eski bağlama erişen bir eylem bırakmaz.

152 otomatik test geçti, Flutter analizi temiz. Son doku yoğunluğu ayarından sonra 12 görsel/davranış testi tekrar geçti. Normal uygulama giriş noktası (`lib/main.dart`) ile Android debug APK başarıyla üretildi.

`integration_test/mood_motion_test.dart` ve `test_driver/mood_motion_driver.dart` Android üzerinde onboarding, tema, beş sekme ve dört oturum için ayrı denetim içerir. Test verileri bellekte tutulur. Bu cihaz testi tamamlanamadı: Windows üzerindeki Android emülatör işlemi erişim ihlaliyle kapandı ve ADB bağlantısı çevrimdışı oldu. Dolayısıyla fiziksel cihaz akıcılığı veya başarılı bir native uçtan uca sonuç raporlanmıyor.

`output/motion-refinement/ui-motion.mp4` gerçek Flutter ekranlarında dokunma, sekme, tema ve oturum akışını; `routine-motion.mp4` dört rutin çizimini gösterir. Bunlar deterministik 30 fps Flutter karelerinden üretilmiş önizlemelerdir, cihaz ekran kaydı veya performans ölçümü değildir. Güncel dokuz tema ekranı `output/mood-experience/` klasöründedir.

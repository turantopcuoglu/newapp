# 115 özellik: mevcut kod ile eşleştirme

8 Eylül 2026. Statik kod incelemesi; bu belge yeni cihaz sertifikasyonu veya yeni test koşusu değildir. Orijinal features.json bir plan dosyasıdır; planned değerleri teslim durumunu göstermiyordu. Uygulama kodu bu inceleme sırasında değiştirilmedi.

**Çekirdek var:** temel manuel akış uygulanmış. **Kısmi:** katalog maddesinin bazı alt koşulları var. **Bağlantı altyapısı:** kod var, fiziksel cihaz/iOS doğrulaması eksik. **Yok:** ilgili ürün işlevi uygulanmamış. Hiçbiri mağaza yayınına hazır sertifikası anlamına gelmez.

Çekirdek var: 8 | Kısmi: 34 | Yok: 68 | Bağlantı altyapısı: 5

Bir özellik birkaç alt iş içerdiği için bu sayılardan ürünün yüzde tamamlanma oranı çıkarılmamalıdır.

## Günlük durum ve kişiselleştirme

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| KIS-01 | Ruh hali, enerji ve öznel stres kaydı | Çekirdek var | Tarihli ruh hali, enerji, stres; kayıt isteğe bağlı. [wellness.dart](../../../lib/models/wellness.dart), [check_in_screen.dart](../../../lib/screens/wellness/check_in_screen.dart) |
| KIS-02 | Uyku hissi, açlık ve tokluk kaydı | Kısmi | Uyku hissi var; açlık/tokluk yeni wellness kaydında yok. [wellness.dart](../../../lib/models/wellness.dart) |
| KIS-03 | Hedef, alışkanlık, zaman ve bütçe profili | Kısmi | Hedefler, alışkanlıklar ve hazırlık zamanı var; bütçe profili yok. [wellness.dart](../../../lib/models/wellness.dart), [user_profile.dart](../../../lib/models/user_profile.dart) |
| KIS-04 | Sabah, gün içi ve akşam için günlük plan | Kısmi | Günlük yemek ve sabit iki rutin sunuluyor; birleşik sabah/gün/akşam planı yok. [today_screen.dart](../../../lib/screens/wellness/today_screen.dart) |
| KIS-05 | Öneri gerekçesi ve alternatif seçimi | Kısmi | Gerekçe metni ve alternatif var; tüm önerilerin bağlam/provenans açıklaması yok. [nourish_screen.dart](../../../lib/screens/wellness/nourish_screen.dart), [wellness_provider.dart](../../../lib/providers/wellness_provider.dart) |
| KIS-06 | Seyahat, vardiya ve yoğun gün bağlamı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| KIS-07 | Öneri geri bildirimi ve tercih öğrenme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Besin seçimi ve beslenme takibi

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| BES-01 | Bugün tüketilebilecek besin önerileri | Kısmi | Alerji, tercih, süre, öğün ve mutfak temeli var. Referans kasesinin sıralamada sabit önceliği kişiselleştirmeyi zayıflatıyor. [wellness_provider.dart](../../../lib/providers/wellness_provider.dart), [recipe_provider.dart](../../../lib/providers/recipe_provider.dart) |
| BES-02 | Alerji, intolerans ve tercih için ayrı filtreler | Çekirdek var | Ayrı alerji, laktoz intoleransı ve diyet filtresi; belirsiz malzeme eleme. Katalog doğrulaması ayrıca sürmeli. [recommendation_service.dart](../../../lib/services/recommendation_service.dart), [preference_matcher.dart](../../../lib/services/preference_matcher.dart), [allergens.dart](../../../lib/data/allergens.dart) |
| BES-03 | Öğün ve porsiyon tüketim kaydı | Çekirdek var | Porsiyonlu tüketim kaydı; plan ve tüketim ayrı, açık pişirme eylemi gerekiyor. [cooked_provider.dart](../../../lib/providers/cooked_provider.dart), [moonlit_recipe_screen.dart](../../../lib/screens/wellness/moonlit_recipe_screen.dart) |
| BES-04 | İsteğe bağlı enerji ve makro takibi | Kısmi | Eski beslenme ekranında kayıtlı öğünlerden enerji/makro hesapları var; wellness ana akışına entegre tercihli modül değil. [nutrition_stats_screen.dart](../../../lib/screens/nutrition/nutrition_stats_screen.dart), [nutrition_calculator.dart](../../../lib/services/nutrition_calculator.dart) |
| BES-05 | Lif, besin grupları ve haftalık çeşitlilik | Kısmi | Lif hesabı var; haftalık besin grubu/çeşitlilik deneyimi yok. [cooked_provider.dart](../../../lib/providers/cooked_provider.dart), [nutrition_calculator.dart](../../../lib/services/nutrition_calculator.dart) |
| BES-06 | Mikrobesin alım tahmini | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| BES-07 | Barkod ve ürün etiketi okuma | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| BES-08 | Fotoğraftan öğün taslağı oluşturma | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Tarif, mutfak ve alışveriş

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| TAR-01 | Profile ve günlük bağlama uygun tarif bulma | Kısmi | Alerji, tercih, süre, öğün ve mutfak temeli var. Referans kasesinin sıralamada sabit önceliği kişiselleştirmeyi zayıflatıyor. [wellness_provider.dart](../../../lib/providers/wellness_provider.dart), [recipe_provider.dart](../../../lib/providers/recipe_provider.dart) |
| TAR-02 | Besin ve malzeme alternatifi önerme | Kısmi | Malzemeyi dışlayan güvenli başka tarif seçiliyor; aynı tarifte miktarlı malzeme ikamesi değil. [nourish_screen.dart](../../../lib/screens/wellness/nourish_screen.dart) |
| TAR-03 | Haftalık öğün planlama ve hazırlık planı | Kısmi | Öğün planlayıcı var; kapsamlı ön hazırlık planı yok. [planner_screen.dart](../../../lib/screens/planner/planner_screen.dart), [meal_plan_provider.dart](../../../lib/providers/meal_plan_provider.dart) |
| TAR-04 | Mutfak envanteri ve son kullanım hatırlatması | Kısmi | Mutfak envanteri var; son kullanım tarihi ve hatırlatması yok. [inventory_provider.dart](../../../lib/providers/inventory_provider.dart), [shopping_screen.dart](../../../lib/screens/shopping/shopping_screen.dart) |
| TAR-05 | Birleşik alışveriş listesi ve bütçe | Kısmi | Birleşik alışveriş listesi var; fiyat/bütçe hesabı yok. [shopping_provider.dart](../../../lib/providers/shopping_provider.dart), [shopping_screen.dart](../../../lib/screens/shopping/shopping_screen.dart) |
| TAR-06 | Aile için ortak yemek, kişi başına ayrı kısıtlar | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| TAR-07 | Doğrulanmış malzemelerle kişiye özel tarif üretme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Su ve içecekler

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| ICE-01 | Su ve içecek miktarı günlüğü | Çekirdek var | Manuel su ve içecek miktarı/tarih kaydı; otomatik cihazdan içecek aktarımı yok. [beverage_provider.dart](../../../lib/providers/beverage_provider.dart), [beverages_screen.dart](../../../lib/screens/beverages/beverages_screen.dart) |
| ICE-02 | Kullanıcının ayarladığı su hedefi ve hatırlatma | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ICE-03 | Kafein miktarı ve tüketim saati | Kısmi | Kahve/çay türü, miktarı ve tüketim zamanı var; mg cinsinden kafein hesabı yok. [beverage_entry.dart](../../../lib/models/beverage_entry.dart), [beverage_provider.dart](../../../lib/providers/beverage_provider.dart) |
| ICE-04 | Kafein ile uyku günlüğünü birlikte inceleme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ICE-05 | İsteğe bağlı alkol kaydı ve azaltma hedefi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Uyku ve günlük ritim

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| UYK-01 | Manuel veya cihazdan uyku günlüğü | Kısmi | Manuel oturum var; cihaz okuma kodu mevcut fakat fiziksel cihaz doğrulaması tamamlanmadı. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart), [health_connection_service.dart](../../../lib/services/health_connection_service.dart) |
| UYK-02 | Süre ve yatış/kalkış düzeni eğilimleri | Kısmi | Uyku süre özeti var; yatış/kalkış düzeni eğilimi tamamlanmış değil. [progress_screen.dart](../../../lib/screens/wellness/progress_screen.dart) |
| UYK-03 | Uyku evreleri, bölünme ve kestirme görünümü | Kısmi | Uyku evreleri okunup toplam süreye birleştiriliyor; evre, bölünme ve kestirme arayüzü yok. [health_connection_service.dart](../../../lib/services/health_connection_service.dart), [wellness.dart](../../../lib/models/wellness.dart) |
| UYK-04 | Kişisel akşam hazırlık rutini | Çekirdek var | Üç maddelik akşam kontrolü, yatış saati ve nefes oturumuna geçiş. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| UYK-05 | Uyku sesleri, hikâyeleri ve zamanlayıcı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| UYK-06 | Sabah ışık ve günlük ritim hatırlatmaları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| UYK-07 | Vardiya ve seyahat için esnek uyku planı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Hareket ve egzersiz

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| HAR-01 | Adım, aktif süre ve antrenman geçmişi | Bağlantı altyapısı | Adım ve antrenman süresi okuma var; fiziksel kaynak/doğrulama ve kapsamlı geçmiş eksik. [health_connection_service.dart](../../../lib/services/health_connection_service.dart), [health_connections_screen.dart](../../../lib/screens/wellness/health_connections_screen.dart) |
| HAR-02 | Oturma molası ve kısa yürüyüş rutini | Kısmi | Kısa yürüyüş ve tek esneme zamanlayıcısı/metni var; mola sıklığı, filtreli kütüphane ve uyarlama motoru yok. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| HAR-03 | Esneme ve mobilite kütüphanesi | Kısmi | Kısa yürüyüş ve tek esneme zamanlayıcısı/metni var; mola sıklığı, filtreli kütüphane ve uyarlama motoru yok. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| HAR-04 | Başlangıç kuvvet, kardiyo, yoga ve pilates planları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| HAR-05 | Ekipmana, zamana ve erişilebilirliğe göre uyarlama | Kısmi | Kısa yürüyüş ve tek esneme zamanlayıcısı/metni var; mola sıklığı, filtreli kütüphane ve uyarlama motoru yok. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| HAR-06 | Antrenman sonrası algılanan efor ve toparlanma kaydı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| HAR-07 | Saatten antrenman başlatma ve canlı oturum | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Zihinsel iyi oluş ve stres

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| ZIH-01 | Rehberli rahat nefes oturumları | Kısmi | Birer kısa metinli nefes/farkındalık oturumu var; uzman incelemeli sesli içerik kütüphanesi yok. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| ZIH-02 | Kısa meditasyon ve farkındalık | Kısmi | Birer kısa metinli nefes/farkındalık oturumu var; uzman incelemeli sesli içerik kütüphanesi yok. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| ZIH-03 | Beden taraması ve gevşeme oturumları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ZIH-04 | Günlük yazma, duygu etiketleme, şükran günlüğü | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ZIH-05 | Duyusal odaklanma ve zor anlar için sakinleşme araçları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ZIH-06 | Stres bağlamı ile izinli cihaz göstergelerini inceleme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ZIH-07 | Profesyonel destek kaynaklarına erişim | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Alışkanlıklar ve odak

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| ALI-01 | Kişisel alışkanlık oluşturma ve takip | Çekirdek var | Kişisel alışkanlık ekle, işaretle, sil; tarihli yerel kayıt. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart), [wellness_provider.dart](../../../lib/providers/wellness_provider.dart) |
| ALI-02 | Esnek haftalık hedef ve hatırlatma | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ALI-03 | Alışkanlıkları mevcut rutinlere bağlama | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ALI-04 | Odak zamanlayıcısı ve dinlenme araları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| ALI-05 | Dijital mola ve ekran kullanımını gözden geçirme | Kısmi | Akşam ekran molası işaretlemesi var; ekran süresi erişimi ve inceleme aracı yok. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| ALI-06 | Sigarayı azaltma/bırakma hedefi ve kaynaklar | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Vücut ölçümleri ve toparlanma

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| VUC-01 | İsteğe bağlı kilo ve vücut ölçüsü günlüğü | Kısmi | Profilde tek kilo/boy değeri var; tarihli vücut ölçüsü günlüğü yok. [user_profile.dart](../../../lib/models/user_profile.dart), [settings_screen.dart](../../../lib/screens/settings_screen.dart) |
| VUC-02 | Akıllı tartıdan vücut bileşimi eğilimleri | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| VUC-03 | Dinlenik nabız ve kişisel geçmiş | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| VUC-04 | HRV eğilimi ve veri kapsamı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| VUC-05 | Üreticinin toparlanma/enerji skorunu gösterme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| VUC-06 | Ağrı, kas yorgunluğu ve dinlenme kaydı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Sindirim ve bedensel rahatlık

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| SIN-01 | Şişkinlik, rahatsızlık ve sindirim günlüğü | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SIN-02 | Bağırsak düzeni kaydı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SIN-03 | Öğün ve belirti zaman çizelgesi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SIN-04 | Olası kişisel örüntüleri inceleme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SIN-05 | Uzmanla paylaşılabilir sindirim özeti | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Döngü ve yaşam dönemleri

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| DON-01 | İsteğe bağlı adet döngüsü takvimi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| DON-02 | Döngüyle birlikte belirti, enerji ve uyku kaydı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| DON-03 | Döngü dönemi tahmin aralığı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| DON-04 | Perimenopoz/menopoz günlüğü ve eğitim | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| DON-05 | Gebelik ve doğum sonrası iyi oluş programı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| DON-06 | Cinsel iyi oluş, beden farkındalığı ve eğitim | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Sosyal ve duygusal iyi oluş

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| SOS-01 | Sosyal bağ kurma niyeti ve küçük hatırlatmalar | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SOS-02 | Bir arkadaşla gönüllü rutin hedefi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SOS-03 | Küçük grup etkinlikleri ve meydan okumalar | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SOS-04 | Moderasyonlu topluluk | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SOS-05 | Değerler, amaç ve haftalık kişisel değerlendirme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Çevresel iyi oluş

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| CEV-01 | Hava durumu ve dışarıda aktivite bağlamı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| CEV-02 | Hava kalitesi, polen ve UV bilgisi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| CEV-03 | Gün ışığı ve doğada geçirilen süre günlüğü | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| CEV-04 | Gürültü ve uyku ortamını gözden geçirme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| CEV-05 | İş ortamı, ergonomi ve dinlenme düzeni | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Sağlık kayıtları ve uzman desteği

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| SAG-01 | İlaç ve takviye günlüğü/hatırlatması | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SAG-02 | Tansiyon, glikoz ve ek ölçümlerin günlüğü | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SAG-03 | Laboratuvar belgelerini saklama ve yapılandırılmış aktarım | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SAG-04 | Uzmanla randevu ve izinli rapor paylaşımı | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SAG-05 | CGM ve ECG gibi gelişmiş kayıt bağlantıları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| SAG-06 | Uzman tarafından hazırlanan kişisel planı takip | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Cihazlar ve sağlık bağlantıları

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| CIH-01 | Apple HealthKit bağlantısı | Bağlantı altyapısı | Seçili alanlarda salt okuma, kaynak/izin/yenileme ve tekrar ayıklama kodu var. iOS derlenmedi; gerçek saat/yüzükle uçtan uca doğrulanmadı. [health_connection_service.dart](../../../lib/services/health_connection_service.dart), [health_connections_screen.dart](../../../lib/screens/wellness/health_connections_screen.dart), [wellness.dart](../../../lib/models/wellness.dart) |
| CIH-02 | Android Health Connect bağlantısı | Bağlantı altyapısı | Seçili alanlarda salt okuma, kaynak/izin/yenileme ve tekrar ayıklama kodu var. iOS derlenmedi; gerçek saat/yüzükle uçtan uca doğrulanmadı. [health_connection_service.dart](../../../lib/services/health_connection_service.dart), [health_connections_screen.dart](../../../lib/screens/wellness/health_connections_screen.dart), [wellness.dart](../../../lib/models/wellness.dart) |
| CIH-03 | Oura, WHOOP ve diğer marka hesap bağlantıları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| CIH-04 | Kaynak, son eşitleme ve izin yönetimi ekranı | Bağlantı altyapısı | Seçili alanlarda salt okuma, kaynak/izin/yenileme ve tekrar ayıklama kodu var. iOS derlenmedi; gerçek saat/yüzükle uçtan uca doğrulanmadı. [health_connection_service.dart](../../../lib/services/health_connection_service.dart), [health_connections_screen.dart](../../../lib/screens/wellness/health_connections_screen.dart), [wellness.dart](../../../lib/models/wellness.dart) |
| CIH-05 | Çoklu cihazda tekrar ayıklama ve tercih edilen kaynak | Bağlantı altyapısı | Seçili alanlarda salt okuma, kaynak/izin/yenileme ve tekrar ayıklama kodu var. iOS derlenmedi; gerçek saat/yüzükle uçtan uca doğrulanmadı. [health_connection_service.dart](../../../lib/services/health_connection_service.dart), [health_connections_screen.dart](../../../lib/screens/wellness/health_connections_screen.dart), [wellness.dart](../../../lib/models/wellness.dart) |
| CIH-06 | Kullanıcının seçtiği kendi kayıtlarını sağlık merkezine yazma | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| CIH-07 | Saatte hızlı kayıt, nefes ve günlük plan | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Gelişim, içgörü ve koç

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| GEL-01 | Günlük/haftalık özet ve eksik kayıt görünümü | Çekirdek var | Hafta/ay enerji grafiği, eksik günler ve gerçek tüketim/rutin sayıları. [progress_screen.dart](../../../lib/screens/wellness/progress_screen.dart) |
| GEL-02 | Kullanıcının kendi geçmişine göre eğilimler | Kısmi | Geçmiş nokta grafiği var; yeterli veri eşiğiyle kişisel baz çizgisi/ileri eğilim motoru yok. [progress_screen.dart](../../../lib/screens/wellness/progress_screen.dart) |
| GEL-03 | Uyku, hareket, öğün ve ruh halini birlikte inceleme | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| GEL-04 | Tek alışkanlığa odaklanan kişisel denemeler | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| GEL-05 | Bağlamı açıklayan sohbetli iyi oluş rehberi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| GEL-06 | CSV/PDF kişisel raporu ve taşınabilir veri dışa aktarımı | Kısmi | Wellness JSON önizleme/kopyalama var; seçilebilir CSV/PDF raporu yok. [profile_screen.dart](../../../lib/screens/wellness/profile_screen.dart) |
| GEL-07 | Gerekçeli günlük tempo önerisi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Programlar ve içerik

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| PRG-01 | 7/14/28 günlük uyku, hareket ve beslenme programları | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| PRG-02 | Süre/amaç/zorluk filtresi ve favoriler | Kısmi | Tarif arama/favoriler var; wellness içeriklerinde amaç/süre/zorluk kataloğu yok. [recipe_book_screen.dart](../../../lib/screens/recipe_book/recipe_book_screen.dart), [favorites_provider.dart](../../../lib/providers/favorites_provider.dart), [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| PRG-03 | Çevrimdışı içerik ve ses indirme | Kısmi | Paketlenmiş kısa rutin metinleri çevrimdışı çalışır; ses içeriği, indirme/lisans yönetimi yok. [routines_screen.dart](../../../lib/screens/wellness/routines_screen.dart) |
| PRG-04 | Uzman içerik yönetimi, sürüm ve inceleme tarihi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |
| PRG-05 | Eğitim içerikleri ve küçük bilgi adımları | Yok | Eski HomeScreen için ipucu metinleri kaynakta duruyor; yeni wellness akışında eğitim modülü ve editoryal inceleme süreci yok. [health_tips_data.dart](../../../lib/data/health_tips_data.dart), [home_screen.dart](../../../lib/screens/home/home_screen.dart), [main_shell.dart](../../../lib/screens/main_shell.dart) |
| PRG-06 | İsteğe bağlı öğün penceresi/oruç takibi | Yok | Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.  |

## Kullanıcı kontrolü ve erişilebilirlik

| Kimlik | Özellik | Durum | Kanıt / eksik |
|---|---|---|---|
| KON-01 | Modül seçimi ve ana ekran kişiselleştirme | Kısmi | Hedef seçimi var; modül gizleme ve ana ekran kart düzenleme yok. [today_screen.dart](../../../lib/screens/wellness/today_screen.dart), [wellness.dart](../../../lib/models/wellness.dart) |
| KON-02 | Veri tipi ve amaç bazında izin merkezi | Kısmi | Sağlık alanı izinleri var; kapsamlı cihaz/bulut/AI amaç merkezi yok; bulut/AI servisi henüz eklenmedi. [health_connections_screen.dart](../../../lib/screens/wellness/health_connections_screen.dart) |
| KON-03 | Veriyi düzeltme, silme ve hesabı kapatma | Kısmi | Günlük kaydı düzenleme/silme ve wellness silme var; bulut hesabı ve hesap kapatma bulunmuyor. [profile_screen.dart](../../../lib/screens/wellness/profile_screen.dart), [progress_screen.dart](../../../lib/screens/wellness/progress_screen.dart) |
| KON-04 | Şifreli saklama ve isteğe bağlı uygulama kilidi | Kısmi | Şifreli depo ve güvenli anahtar var; isteğe bağlı biyometrik uygulama kilidi yok. [private_storage.dart](../../../lib/services/private_storage.dart), [wellness_store.dart](../../../lib/services/wellness_store.dart) |
| KON-05 | Büyük yazı, ekran okuyucu ve hareket azaltma | Kısmi | Büyük yazı testleri, semantik ve azaltılmış hareket desteği var; tam ekran okuyucu/cihaz denetimi yapılmadı. [wellness_ui_test.dart](../../../test/wellness_ui_test.dart), [wellness_ui.dart](../../../lib/screens/wellness/wellness_ui.dart) |
| KON-06 | Sessiz saatler, bildirim sınırı ve kilit ekranı gizliliği | Kısmi | Yerel günlük durum/akşam yemeği hatırlatması var; tam sessiz saat, sınır ve gizlilik merkezi yok. [notification_service.dart](../../../lib/services/notification_service.dart), [settings_screen.dart](../../../lib/screens/settings_screen.dart) |
| KON-07 | Türkçe/İngilizce, birim ve saat dilimi tercihleri | Kısmi | Türkçe/İngilizce ve yerel saat kullanımı var; kullanıcı seçilebilir bütün birim/saat dilimi tercihleri yok. [locale_provider.dart](../../../lib/providers/locale_provider.dart), [day_boundary.dart](../../../lib/core/day_boundary.dart) |
| KON-08 | Cihazsız ve bulutsuz temel kullanım | Çekirdek var | Cihaz ve bulut hesabı olmadan temel manuel kullanım. [main.dart](../../../lib/main.dart), [wellness_store.dart](../../../lib/services/wellness_store.dart) |


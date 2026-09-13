# Wellness ürün ve geliştirme planı

Tarih: 7 Eylül 2026. Durum: ilk çekirdek sürüm mevcut Flutter uygulamasına uygulandı. Katalogdaki bütün aşamalar tamamlanmış değildir; teslim edilen kapsam ve doğrulamalar [uygulama durumunda](./UYGULAMA-DURUMU.md) açıklanır.

Hedef kitle: günlük iyi oluşunu desteklemek isteyen yetişkinler. Çalışma varsayımları: iOS ve Android, Türkçe öncelikli deneyim, cihazı olmayan kullanıcı için de tam bir temel deneyim. Önceki gece mavisi ve mint tasarım sistemi korunur.

## 1. Ürünün merkezi

Ürün vaadi: **“Bugünkü durumunu, alışkanlıklarını ve izin verdiğin sağlık verilerini anlayarak ne yiyebileceğini ve gününü nasıl düzenleyebileceğini seçmene yardımcı olan kişisel iyi oluş rehberi.”**

Beslenme, uygulamayı ayrıştıran ana işlevdir. Uyku, hareket, stres ve günlük zaman kısıtı besin ve tarif seçiminin bağlamına katılır. Bu verilerden vitamin eksikliği, hastalık veya kesin bir besin ihtiyacı çıkarılmaz. Örneğin düşük enerji bildirimi, hazırlaması kolay bir öğünü öne çıkarabilir; tek bir HRV ölçümü “magnezyum almalısın” sonucuna dönüştürülemez.

Temel döngü:

1. Kullanıcının kısa günlük kaydı ve izin verdiği cihaz verileri alınır.
2. Verinin tarihi, kaynağı ve yeterliliği değerlendirilir.
3. Alerjiler ve diğer zorunlu kısıtlar uygulanır.
4. Bir beslenme önerisi, bir hareket/dinlenme seçeneği ve bir akşam adımı sunulur.
5. Kullanıcı öneriyi değiştirir, uygular veya atlar.
6. Sistem seçimleri ve kullanıcı geri bildirimini öğrenir; gözlenen ilişkiyi neden-sonuç diye sunmaz.

“Neredeyse tüm wellness özellikleri” geniş bir modül kataloğu olarak ele alınır. Kullanıcı bütün modülleri açmak zorunda değildir. Kurulumda en fazla üç odak seçer; diğerlerini daha sonra ekler.

## 2. Plan belgeleri

- [Özellik kataloğu](./OZELLIK-KATALOGU.md): 18 alanda 115 özellik; ayrı kimlik, aşama ve veri ihtiyacı.
- [Yapılandırılmış iş listesi](./features.json): katalogla aynı 115 kaydın geliştirme takibine aktarılabilir karşılığı.
- [Cihaz ve sağlık verisi planı](./CIHAZ-VE-VERI-PLANI.md): entegrasyon matrisi, veri modeli, işleme kuralları, izinler ve doğrulama.
- [Mevcut tasarım sistemi](../moonlit-theme/tasarim-sistemi.md): renkler, tipografi ve bileşenler.
- [Mevcut ekran ve hareket planı](../moonlit-theme/ekran-ve-hareket-plani.md): tasarımın etkileşim karşılığı.

## 3. Uygulama içi yerleşim

| Alan | Kullanıcının bulacağı içerik | Ana eylem |
|---|---|---|
| Bugün | Kısa durum özeti, bugünkü besinler, üç önerilen adım, veri güncelliği | Günümü düzenle |
| Beslen | Besin seçimi, tarifler, öğün planı, tüketim, su, mutfak ve alışveriş | Bana uygun öğün bul |
| Rutinler | Uyku, nefes, meditasyon, hareket, odak, alışkanlık ve programlar | Bir rutin başlat |
| Gelişim | Uyku/hareket/beslenme eğilimleri, özbildirimler, seçili ölçümler, açıklanabilir ilişkiler | Haftamı incele |
| Profil | Alerji ve tercihler, hedefler, modüller, cihazlar, izinler ve veri yönetimi | Bağlantılarımı yönet |

Yeni ana sekmelerle menü büyütülmez. Döngü, sindirim ve vücut takibi, kullanıcı açtığında Gelişim içinde modül olur; bunların günlük kayıt kısayolları Bugün ekranına eklenebilir.

Bugün ekranının önerilen sırası:

1. “Günaydın Ece” ve “Bugün nasıl hissediyorsun?”
2. “Uyku kaydı: 6 sa 10 dk · Kaynak: Apple Health · Son eşitleme: 08.12” gibi somut bir veri özeti.
3. Büyük beslenme kartı: “15 dakikada hazırlanabilen öğünler” ve seçilen besinler; “Neden bu öneri?” bağlantısı.
4. “Bugünün küçük adımları”: kısa hareket seçeneği, nefes molası, akşam rutini.
5. Günün kayıtları ve tek bir geri bildirim sorusu.

Bu örnekteki değerler arayüz senaryosudur; gerçek kullanıcı ölçümü değildir. Işıklı formlar sakin bir görsel dil sağlar; sensörden gelmeyen hiçbir animasyon canlı biyometri gibi gösterilmez. Veri yokken sahte grafik yerine kısa açıklama ve manuel kayıt sunulur.

## 4. Geliştirme sırası

Katalogdaki F0–F4 etiketleri aşağıdaki aşamalara karşılık gelir. Aşamalar takvim taahhüdü değildir; kapalı beta ve kabul ölçütleriyle ilerler. Geniş aşamalar küçük teslimatlara bölünür.

| Aşama | Kapsam ve somut çıktı | Bağımlılık | Tamamlanma ölçütü |
|---|---|---|---|
| F0 — Temel | Tarihli kayıt modeli, alerji ayrımı, veri sözlüğü, izin tasarımı, karanlık tema bileşenleri, HealthKit/Health Connect teknik denemesi | Mevcut veri ve ekran envanteri | Eski kullanıcı kayıtları kayıpsız taşınır; iki platformdan gerçek cihaz verisi alınabildiği gösterilir |
| F1 — İlk kullanılabilir sürüm | Günlük kayıt → besin/tarif → küçük rutinler döngüsü; su, uyku günlüğü, temel hareket, haftalık özet; HealthKit ve Health Connect okuma; veri silme | F0 | Cihazlı ve cihazsız kullanıcı aynı temel akışı tamamlar; kısmi izin, eksik kayıt ve çift kaynak senaryoları geçer |
| F2 — Kapsamı genişletme | Daha zengin uyku/zihin/hareket içerikleri; alışkanlıklar, sindirim ve isteğe bağlı döngü; Oura ve seçilen marka bağlantıları; izinli veri yazma | F1 geri bildirimi; OAuth sunucusu ve içerik yönetimi | İlk marka entegrasyonu bağlantı–eşitleme–iptal–silme yaşam döngüsünü tamamlar; kaynak çakışmaları doğru çözülür |
| F3 — Gelişmiş kişiselleştirme | Bireysel eğilimler, bağlamlı koç, denetimli tarif üretimi, watchOS/Wear OS yardımcı uygulamaları, sosyal ve çevresel modüller | Güvenilir geçmiş, uzman içerik, işletim ve moderasyon | Yeni öneriler gerekçelendirilir; etkisi kullanıcı deneyimi üzerinden değerlendirilir; gerçek zamanlı özellikler desteklenen cihazlarda doğrulanır |
| F4 — Uzmanlık gerektiren genişleme | Uzman portalı, laboratuvar/klinik kayıt aktarımı, CGM/ECG gibi gelişmiş kayıtlar, özel yaşam dönemlerine yönelik programlar | Ayrı ürün kapsamı, uzman ekip, yasal ve klinik değerlendirme, gerekli ortaklıklar | Kullanım amacı, veri erişimi ve doğrulama gereklilikleri karşılanmadan kullanıcıya açılmaz |

F0 sırasında Garmin ve Samsung gibi programlara başvuru hazırlığı yapılabilir. Onay süreleri temel sürümün kritik yoluna konmaz. Her markanın verisini tek seferde bağlamak yerine, ortak altyapı üzerinden bir bağlayıcı tamamlanır ve sonraki markalara uygulanır.

F1 için iki teslimat önerisi:

- **İç pilot:** yeni veri modeli, alerji kuralları, günlük beslenme önerisi, durum kaydı ve HealthKit/Health Connect üzerinden uyku–adım–aktivite okuma.
- **Kapalı beta:** ortak tema, su, temel rutinler, kayıt geçmişi, kaynak/izin ekranları ve haftalık özet. F1 katalog kapsamı tamamlanınca genel sürüm değerlendirilir.

## 5. Mevcut koddan dönüşüm

Depoda Flutter ve Riverpod tabanı, tarifler, kullanıcı tercihleri, mutfak/alışveriş, öğün planı, tüketim ve su kayıtları bulunuyor. Bunlar korunarak genişletilebilir. İncelenen bağımlılıklarda hazır HealthKit/Health Connect veya marka bağlayıcısı yok.

| Mevcut durum | Yapılacak iş | Gerekçe |
|---|---|---|
| Son check-in değerini tutan saklama | Tarih, saat ve geçmişi olan DailyCheckIn tablosu | Son değerden haftalık eğilim üretilemez |
| SharedPreferences ağırlıklı saklama | Sürümlü yerel veritabanı; hassas kayıtlar için şifreleme; güvenli anahtar saklama | Sağlık kaydı hacmi ve ilişkileri ayar saklamadan farklıdır |
| dairy gibi birleşik kısıtlar | Alerji, intolerans/hassasiyet, tıbbi kısıt ve tercih için ayrı modeller | Laktozsuz ürün süt alerjisine otomatik uygun sayılmaz |
| Öğün planı ve tüketim kayıtları | DailyWellnessPlan, MealPlan ve Consumption ayrı kalır | Planlamak tüketmiş olmak değildir |
| 06.00 günlük mod sınırı; bazı kayıtlarda takvim günü | Ortak zaman politikası, ayrı uyku oturumu modeli | Gece uykusu ve seyahat kayıtları parçalanmamalı |
| Mutfaktaki malzeme oranına bağlı uyumluluk yüzdesi | “Malzemelerin şu kadarı mutfağında” şeklinde doğru adlandırma | Malzeme bulunurluğu sağlık uygunluğu puanı değildir |
| Yerel tarif havuzu | Önce güvenilir tarif eşleştirme; sonra doğrulamalı üretim servisi | Henüz bulunmayan üretim yeteneği varmış gibi sunulmamalı |
| Sınırlı bildirimler | Sessiz saat, saat dilimi, tekrar engeli ve kullanıcı kontrolü | Her modül ayrı ayrı bildirim bombardımanı yaratmamalı |

Önerilen modüller: profile/consent, check-in, nutrition, recipes, routines, health-data, integrations, insights, notifications. Riverpod arayüz durumunu yönetir; veri alma, normalizasyon ve öneri kuralları ekranlardan bağımsız servislerde kalır. Flutter paket seçimi F0 denemesinde yapılır; güncel native veri tipleri eksikse Swift/Kotlin platform köprüsü kullanılır.

## 6. Kişiselleştirme kuralları

Öncelik sırası: **kullanıcının zorunlu kısıtları → tercih ve erişilebilirlik → zaman/bütçe/mutfak → günlük özbildirim → yeterli ve güncel cihaz bağlamı → çeşitlilik.**

- Alerji elemesi sıralama puanı değildir; tarif ve her malzeme alternatifi üzerinde uygulanır. Belirsiz içerik “uygun” diye onaylanmaz. Çapraz temas bilgisi eksikse bunun sınırı gösterilir.
- Beslenme verisi yoksa yeterli protein veya vitamin alındığı söylenmez. Kalori ve makro gösterimi kullanıcının seçtiği bir moddur; varsayılan amaç günlük iyi oluş ve çeşitliliktir.
- Spor saatinin harcama tahmini otomatik olarak aynı miktarda ek yemek veya kalori kısıtlama talimatına çevrilmez.
- Özbildirim ve cihaz sonucu ayrıdır: “kendimi iyi hissediyorum” yanıtı, düşük bir marka toparlanma puanı nedeniyle silinmez.
- Bir gecelik uyku veya HRV değişimi tanı üretmez. Veri yetersizliğinde kişisel eğilim iddiası ertelenir.
- Başlangıçta açıklanabilir kurallar çalışır. Dil modeli daha sonra doğrulanmış seçenekleri açıklayabilir; alerji denetiminin veya biyometrik hesapların sahibi olmaz.
- Üretilen tarifte yapılandırılmış malzeme listesi, alerjen ve miktar denetimi, gerçekçi hazırlık süresi ve doğrulanmış besin veri kaynağı zorunludur. Doğrulama başarısızsa mevcut güvenilir tarif önerilir.

## 7. Ekip ve işletim

İlk sürüm için gerekli sorumluluklar: ürün/tasarım, Flutter ve native sağlık entegrasyonu, veri/backend, gerçek cihaz QA, diyetisyen içerik incelemesi, güvenlik ve veri koruma incelemesi. Bir kişi birden çok rol üstlenebilir; sorumlulukların hiçbiri atlanmamalı.

Backend F2 marka bağlantıları için zorunlu hale gelir: OAuth sırları, token yenileme, webhook alımı, kuyruklar ve izinli hesap eşitlemesi. F1 telefon sağlık merkezleri üzerinden cihazda çalışan bir mod sunabilir. Buluta aktarım, telefon sağlık verisini okuma izninden ayrı bir kullanıcı kararıdır.

İçerik işletimi de ürün kapsamıdır: Türkçe metin ve ses hakları, uzman incelemesi, sürüm/son inceleme tarihi, erişilebilir transkript, içerik geri çekme ve hata düzeltme. Topluluk açılırsa raporlama ve moderasyon operasyonu aynı aşamada kurulmalıdır.

Maliyet kalemleri: ekip, test telefonu/saat/yüzükleri, API erişim ve ortaklık koşulları, besin/barkod veri lisansları, içerik ve ses üretimi, sunucu/depolama, güvenlik incelemesi, içerik uzmanları ve kullanıcı desteği. Bütçe bilinmeden kesin fiyat veya teslim haftası vermek doğru olmaz; F0 sonunda iş paketleri üzerinden tahmin çıkarılır.

## 8. Yayın ve başarı ölçütleri

İlk sürümün ana ölçüsü uygulamada geçirilen süre değil, kullanıcının önerilen bir beslenme veya rutin adımını faydalı bulup uygulayabilmesidir.

- İlk gün: kullanıcı hedefini seçer, isterse cihaz bağlar ve uygun bir öğün/rutin bulur.
- Devamlılık: 7 ve 28 günlük geri dönüş, planı değiştirme ve uygulanabilirlik geri bildirimi izlenir.
- Beslenme: alerjen test setinde uygunsuz tarif kaçışı yayın engelidir; belirsiz ürün uygunmuş gibi gösterilmez.
- Veri: çift kaynak toplamları, güncellik, eksik kayıt ve silme işlemleri kontrol edilir.
- Erişilebilirlik: büyük yazı, ekran okuyucu, hareket azaltma, renk dışı durum anlatımı ve dokunma hedefleri doğrulanır.
- Ürün etkisi: “uygulama uykuyu iyileştirdi” gibi bir iddia kullanım oranlarından çıkarılmaz. Klinik etki iddiası ayrı araştırma gerektirir.

Kabul senaryoları ve güncel üretici kaynakları [cihaz ve veri planında](./CIHAZ-VE-VERI-PLANI.md) yer alır. Bu plan, geniş ürün vizyonunu koruyarak önce günlük beslenme–iyi oluş döngüsünü ve güvenilir veri temelini kurmayı önerir.

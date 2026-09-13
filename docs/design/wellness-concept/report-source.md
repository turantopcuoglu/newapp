# NutriGuide Wellness
Günlük iyi oluşu, tabağa ve küçük eylemlere bağlayan ürün
Ürün stratejisi ve uygulama içi tasarım | 7 Eylül 2026

<!-- PAGE:1|Karar özeti -->
## Dönüşümün yönü
**NutriGuide, günlük iyi oluş isteyen yetişkinler için kişisel bir günlük rehbere dönüşmeli.** Kullanıcıya nasıl hissettiğini sormalı; beslenme, zihin, hareket ve uyku alanlarından o gün yapabileceği birkaç eylem seçmeli. Besin önerisi, bu günlük rehberin görünür ve tamamlanabilir bir parçası olmalı.

**Ürün vaadi:** Bugünkü haline, beslenme tercihlerine ve zamanına göre; ne yiyebileceğini ve kendin için ne yapabileceğini birlikte bul.

Bugünkü durum > Uygun besinler > Yapılabilir tarif > Küçük rutin > Kişisel gözlem

### Üç stratejik karar
- **Kapsam:** Beslenme, zihin, hareket, uyku ve alışkanlıklar aynı üründe bulunur. Ana ekran o güne uygun az sayıda eyleme öncelik verir.
- **Fark:** Beslenme eklemek tek başına yeni değil. Oura, Lifesum ve Samsung Health zaten beslenme-wellness bağlantıları sunuyor. Fırsat; günlük durumu, alerjen dışlamalarını, yerel malzemeleri ve pişirmeyi tek akışta kolaylaştırmak. Bu bir konumlandırma hipotezidir. [Oura Meals](https://support.ouraring.com/hc/en-us/articles/40264659421843-Meals), [Lifesum](https://lifesum.com/features/), [Samsung Health](https://www.samsung.com/us/apps/samsung-health/)
- **İlk sürüm:** Katalogdan kişisel tarif, görünür besin seçimi, kısa rutinler ve manuel kayıt. Giyilebilir cihaz, gelişmiş ses kütüphanesi ve yeni tarif üretimi sonraki katmanlardır.

### Araştırma ve teslim kapsamı
Hedef kitle kullanıcı tarafından günlük iyi oluş isteyen yetişkinler olarak seçildi. Türkiye/Türkçe başlangıç odağı bir ürün varsayımıdır; global örnekler incelendi. Sekiz ürünün resmi sayfaları, sağlık kurumları, iki klinik araştırma, platform belgeleri ve mevcut Flutter kodu değerlendirildi.

Sekiz ekran görseli hedef deneyimi gösterir. İsimler, seçimler, süreler ve haftalık kayıtlar örnektir. Bunlar çalışan uygulama ekranları veya ölçülmüş kullanıcı sonuçları değildir. Pazar büyüklüğü, ödeme isteği ve uygulamanın klinik etkisi bu çalışmada ölçülmedi. Rakiplerin bazı özellikleri ülke, dil, cihaz ve üyeliğe bağlıdır.

**Öneri:** Wellness dönüşümünü başlat; ilk ürünün başarısını günlük karar yükünü azaltması ve önerilerin uygulanabilmesi üzerinden doğrula.

<!-- PAGE:2|Rakiplerden öğrenilecekler -->
## Alan dolu; uygulanabilirlikte ayrışabiliriz
Aşağıdaki karşılaştırma doğrulanan özelliklerin özetidir. Bir özellikten söz edilmemesi o üründe bulunmadığı anlamına gelmez. Ürünlerin kendi sağlık yararı iddiaları bağımsız klinik kanıt sayılmadı.

| Ürün | Resmi kaynaklarda görülen deneyim | NutriGuide için ders |
|---|---|---|
| Headspace | Meditasyon, nefes, uyku; Apple Health verisine göre Today önerileri. | Kaydı hemen bir eyleme bağla. |
| Calm | Mod, uyku, şükran kaydı; günlük meditasyon ve hareket içeriği. | Günlük geri dönüş nedeni üret. |
| Fabulous | Zamanlanmış rutinler, kontrol listeleri, aşamalı alışkanlık programları. | Hedefleri küçük adımlarla ekle. |
| Finch | Küçük öz bakım hedefleri; sanal karakterle anında geri bildirim. | Başlamayı ve geri dönmeyi kolaylaştır. |
| Oura | Uyku/stres/toparlanma; öğün zamanı ve besin içeriğiyle Meals görünümü. | Beslenmeyi günün ritmine bağla. |
| Samsung Health | Uyku, aktivite, beslenme, mindfulness ve diğer sağlık ölçümleri. | Geniş kapsamı günlük rehberle düzenle. |
| Lifesum | Besin/su kaydı, tarif, alışveriş; beslenme-uyku içgörüleri. | Öneriyi alışveriş ve pişirmeye taşı. |
| ZOE | Kişisel besin puanları, fotoğraflı kayıt, beslenme koçu; isteğe bağlı test. | Neden önerildiğini açıkla. |

Kaynaklar: [Headspace](https://www.headspace.com/integrations/apple), [Calm](https://support.calm.com/hc/en-us/articles/9699990936731-How-to-Use-Check-Ins-Mood-Sleep-Gratitude-Tracker), [Fabulous](https://help.thefabulous.co/en/support/solutions/articles/101000427430-how-does-fabulous-work-), [Finch](https://help.finchcare.com/hc/en-us/articles/42149821015693-New-User-Guide), [Oura](https://support.ouraring.com/hc/en-us/articles/40264659421843-Meals), [Samsung](https://www.samsung.com/us/apps/samsung-health/), [Lifesum](https://lifesum.com/features/), [ZOE](https://zoe.com/learn/zoe-2-0-science-made-simple).

### Rakipleri kopyalamak yerine alınacak karar
NutriGuide'ın savunulabilir avantaj adayı; Türkçe günlük rehberlik, bilinen malzemeler, açıklanabilir dışlamalar ve doğrudan hazırlanabilir tariflerdir. Bunun talep yarattığı kullanıcı görüşmeleriyle doğrulanmalı. “İlk ve tek” gibi bir iddia desteklenmiyor.

Lifesum'un tarif filtrelemesi kişiselleştirilirken bazı öğün planları genel öneriler olarak tanımlanıyor. Filtrelenmiş katalog, kişiye göre seçilmiş plan ve yeni üretilmiş tarif farklı yeteneklerdir. NutriGuide bunları arayüzde ayrı adlandırmalı. [Lifesum plan sınırları](https://help.lifesum.com/en/article/list-of-all-available-meal-plans-how-to-get-started-1q8a3og/)

<!-- PAGE:3|Ürün modeli ve günlük yolculuk -->
## Tek günlük rehber, beş iyi oluş alanı
İlk hedef kullanıcı: daha iyi hissetmek isteyen; fakat ne pişireceğine, nereden başlayacağına ve rutinini nasıl sürdüreceğine karar vermekte zorlanan yetişkin. Kilo verme, spor performansı veya klinik durum yönetimi varsayılan hedef değildir.

| Alan | İlk sürümde karşılığı | Sonraki katman |
|---|---|---|
| Beslenme | Uygun besinler, katalog tarifi, mutfak, alışveriş, su kaydı. | Doğrulanan tarif uyarlama/üretimi. |
| Zihin | Ruh hali kaydı, kısa nefes molası, tek soruluk günlük. | Uzman üretimi meditasyon ve sesli içerik. |
| Hareket | Kısa yürüyüş/esneme seçeneği; tamamladım kaydı. | İzinli adım/aktivite bağlantısı. |
| Uyku | Özbildirim, seçilen yatış saati, akşam kontrol listesi. | Cihaz verisi ve kaynağı görünen uyku geçmişi. |
| Alışkanlık | Günlük küçük adımlar, esnek tekrar, isteğe bağlı hatırlatma. | Kullanıcının seçtiği çok haftalı programlar. |

### Örnek bir gün
**Sabah:** Ece enerji düzeyini düşük, uykusunu orta olarak işaretler; öğün için 15 dakika ayırır. Plan, kısa bir nefes molası ve hazır malzemelerle bir öğün sunar. Kayıt paylaşmak istemediği alanları atlayabilir.

**Öğlen:** Haşlanmış nohut, pişmiş bulgur ve domatesi görür. Süt ürünü tüketmeme tercihi ve yemiş alerjisi filtrelere yansır. Malzemeyi değiştirebilir; tarifin hazırlık koşullarını ve gerekçesini açar.

**Akşam:** Kendi seçtiği yatış saatine göre sakinleşme rutini açılır. Günlük kaydı isteğe bağlıdır. Tamamlanmayan eylemler başarısızlık olarak sunulmaz.

### Bilgi mimarisi
Alt menü: **Bugün / Beslen / Rutinler / Gelişim / Profil**. Beslen içinde Mutfağım, Keşfet, Tarif defteri ve Alışveriş korunur. Rutinler içinde Zihin, Hareket ve Uyku bulunur. Günlük plan, yemek planı ve tüketim kaydı farklı kavramlar olarak kalır.

Ana sayfada büyük bir besin-tarif alanı ve iki kısa rutin yeterlidir. Su gibi hızlı kayıtlar aşağıda veya hızlı ekleme alanında yer alır. Kişiselleştirme yeniden sayısız takip kartının arkasına düşmemeli.

<!-- PAGE:4|IMAGE|01-gunluk-rehber -->
## 01 / Günlük rehber ve kısa durum kaydı
Günlük durum, tek bir mod etiketinden ruh hali, enerji, uyku ve pratik zaman tercihine ayrılır. Ana ekran yanıtları görünür biçimde besinlere ve küçük eylemlere dönüştürür.
Görseldeki örnek: düşük enerji, orta uyku, 15 dakikalık öğün. Kullanıcı seçimleri atlayabilir; sağlık bağlantısı başlangıç şartı değildir.

<!-- PAGE:5|Besin önerisinin mantığı -->
## “Hangi besin?” sorusuna gerekçeli cevap
Besin seçimi ruh halinden eksiklik teşhisi çıkarmamalı. Günlük durum; hazırlık eforunu, zamanlamayı ve seçenek sayısını etkileyebilir. Genel beslenme çerçevesi çeşitlilik ve dengeyi gözetir. [WHO - Healthy diet](https://www.who.int/news-room/fact-sheets/detail/healthy-diet)

### Öneri motorunun sırası
1. **Kesin dışlamalar:** Alerjenler ve kullanıcının kaçın dediği içerikler; tarif, besin alternatifi ve üretim sonucu için aynı kurallardan geçer.
2. **Beslenme çerçevesi:** Tercihlerine uygun besin grupları ve çeşitlilik. “Demirin eksik” veya “bugün magnezyum almalısın” gibi sonuçlar moddan türetilmez.
3. **Günün koşulları:** Süre, hazırlık eforu, öğün saati, ekipman ve bildirilen durum.
4. **Uygulanabilirlik:** Mutfaktaki malzemeler, sevilen tatlar, tekrar sıklığı; daha sonra bütçe ve mevsim.
5. **Açıklama:** Öneriyi gerçekten belirleyen nedenler ve eksik malzemeler.

| Günlük durum | Ürünün yapabileceği | Yazılmaması gereken |
|---|---|---|
| Enerjim düşük | Hazır baklagil/tahıl ve sebzeyle az hazırlıklı öğün. | “Bu besin enerjini anında yükseltir.” |
| Gerginim | İsteğe bağlı kısa mola ve karar vermesi kolay öğün. | “Kortizolünü düşüren tarif.” |
| Uyku saatim yaklaşıyor | Öğün/hatırlatma zamanını dikkate al; kafeinsiz seçenek sun. | “Bu içecek derin uykunu artırır.” |
| Hassasiyet belirttim | Kullanıcının açık kaçınmalarını koru; alternatif sun. | Tek kayıttan yeni intolerans tanısı. |

Uyku tarafında düzenli saatler ve yatmaya yakın kafein/öğün zamanlaması, belirli besinin uyku garantisinden daha savunulabilir bir bağlantıdır. [NHLBI - Healthy Sleep Habits](https://www.nhlbi.nih.gov/health/sleep-deprivation/healthy-sleep-habits)

### Sağlık kanıtının sınırı
SMILES çalışması 67 yetişkinde 12 haftalık uzman destekli beslenme müdahalesini inceledi; bazı depresyon sonuçları iyileşti. MooDFOOD, farklı bir grupta 1.025 yetişkinin bir yıllık takibinde depresyonun önlenmesinde birincil fayda bulmadı. Popülasyon ve müdahaleler farklıdır; iki sonuç basit bir çelişki olarak okunmamalı. Hiçbiri aynı gün belirli bir besinin modunu düzelttiğini veya bu uygulamanın işe yaradığını kanıtlamaz. [SMILES](https://link.springer.com/article/10.1186/s12916-017-0791-y), [MooDFOOD](https://jamanetwork.com/journals/jama/fullarticle/2726983)

<!-- PAGE:6|IMAGE|02-besin-ve-tarif -->
## 02 / Besinlerden hazırlanabilir tarife
Besinler ayrı bir seçim ekranında görünür. Kullanıcı “neden seçildi?”, “evimde var mı?” ve “yerine ne seçebilirim?” sorularını aynı yerde cevaplar. Tarif önerisi bunun devamıdır.
15 dakika örneği hazır haşlanmış nohut ve pişmiş bulgur varsayar. Görseldeki tarif bir tasarım örneğidir; gerçek yayında içerik, miktarlar, süre ve alerjenler doğrulanır.

<!-- PAGE:7|Wellness deneyiminin derinliği -->
## Rutinler içerik rafı olmaktan çıkmalı
Kullanıcı her gün beş alanda hedef tamamlamak zorunda kalmamalı. Bir beslenme eylemi ve bir kısa iyi oluş eylemiyle başlamak yeterlidir; daha fazlasını isteyen Rutinler alanını açar.

### Zihin ve nefes
İlk sürümde kendi ritminde iki dakikalık nefes molası, duraklat/bitir kontrolü, gözleri açık kullanabilme ve metinli yönlendirme yeterli bir başlangıçtır. Süre bir deneyim tercihidir; klinik doz değildir. Mindfulness araştırmaları bazı yararlar gösterse de kalitesi ve yöntemleri değişir; bu bulgular kısa bir uygulama sayacına doğrudan aktarılamaz. [NCCIH](https://www.nccih.nih.gov/health/meditation-and-mindfulness-effectiveness-and-safety)

### Hareket
Beş-on dakikalık yürüyüş veya kullanıcıya uygun bir hareket arası, düşük eşikli başlangıç önerisidir. Tamamladım kaydı gerçek adım ölçümü olarak gösterilmez. Genel fiziksel aktivite önerileri, kişiye özel antrenman reçetesi değildir; kısa rutin tek başına tüm ihtiyacı karşıladığı iddiasını taşımaz. [WHO - Physical activity](https://www.who.int/news-room/fact-sheets/detail/physical-activity)

### Uyku
İlk sürüm uyku süresi/kalitesi özbildirimi ve akşam rutini sunar. Saat, kullanıcının seçtiği yatış düzenine bağlanır; vardiyalı yaşamda evrensel 23:00 varsayımı yapılmaz. “Işıkları azalt”, “Ekranlara ara ver”, “Gevşeme molası” eylemleri düzenlenebilir. Sonraki aşamada cihaz verisi gelirse kaynağı görünür olmalıdır. [NHLBI](https://www.nhlbi.nih.gov/health/sleep-deprivation/healthy-sleep-habits)

### Alışkanlık ve bildirim
Günlük seri kaybı, kırmızı başarısızlık kartı ve suçluluk dili kullanılmamalı. Kullanıcı eylemi küçültebilir, erteleyebilir veya planından çıkarabilir. Bildirimler isteğe bağlı, saatleri düzenlenebilir; kilit ekranında hassas durum ayrıntısı varsayılan olarak gösterilmez. Bu davranışlar ürün önerisidir.

### İçerik operasyonu
Başlangıç için küçük ve gözden geçirilmiş bir set öneriyorum: yaklaşık 6 kısa nefes/farkındalık yönlendirmesi, 6 hareket alternatifi ve 4 uyku rutini. Bunlar iş kapsamı önerisidir. Daha geniş ses kütüphanesi; uzman yazımı, kayıt, telif, çeviri ve erişilebilir transkript üretimi gerektirir. Ürün yalnızca yeni ekranlar eklemekten ibaret değildir.

<!-- PAGE:8|IMAGE|03-nefes-ve-uyku -->
## 03 / Nefes molası ve akşam rutini
Nefes aracı basit, durdurulabilir ve performans puansızdır. Uyku ekranı kişinin seçtiği saate göre uygulanabilir bir kontrol listesi sunar.
Ses olmadan kullanım ve azaltılmış hareket tercihi desteklenmeli. Tamamlanma kaydı, ölçülmüş fizyolojik iyileşme olarak yorumlanmamalı.

<!-- PAGE:9|Gözlem, kontrol ve güven -->
## Gelişim ekranı kişiyi yargılamamalı
Haftalık görünüm kendi bildirilen enerji, rutin tamamlamaları ve pişirilen öğünleri ayrı gösterir. Eksik kayıtlar sıfır sayılmaz; kaynağı ve kayıt yapılan gün sayısı belirtilir. “Wellness 82/100” gibi doğrulanmamış birleşik skor önerilmiyor.

**İlk sürüm:** Beş gün enerji kaydı, üç pişirilen öğün ve iki mola gibi betimleyici özet. **Daha sonra:** Yeterli kayıt varsa dikkatle ifade edilmiş beraber görülmeler. “Yürüyüş yaptığın günlerde kendini daha iyi işaretledin” gözlem olabilir; “yürüyüş enerjini %28 artırdı” nedensellik iddiasıdır. Tek gözlemden besin hassasiyeti öğrenilmez.

### Profilin dört ayrı bölümü
- **Alerjiler:** Kesin dışlama. Öneri ve malzeme değişiminde korunur.
- **Hassasiyet/intolerans:** Kişinin bildirdiği kaçınmalar; algoritma kendiliğinden gevşetmez.
- **Beslenme tercihleri:** Örneğin süt ürünü tüketmiyorum veya vejetaryenim.
- **Sevmediklerim:** Tat tercihleri ve alternatif sıralaması.

Laktoz intoleransı ve süt alerjisi farklıdır; “laktozsuz” bir süt ürünü süt proteini alerjisine uygun varsayılamaz. Mevcut kodun dairy etiketi bu ayrımı tek başına taşıyamıyor. [NIDDK](https://www.niddk.nih.gov/health-information/digestive-diseases/lactose-intolerance/definition-facts)

Tarif verisinde alerjen eşleşmemesi, paketli ürün etiketi veya çapraz temas hakkında garanti vermez. Detayda kısa etiket kontrolü hatırlatması bulunmalı. [FDA - Food Allergies](https://www.fda.gov/food/nutrition-food-labeling-and-critical-foods/food-allergies)

### Veri kontrolü ürünün parçası
Manuel kullanım her zaman mümkün olmalı. Sağlık bağlantısı bağlama anında ve yalnız gerekli veri türleri için izin istemeli. HealthKit okuma izninin verilmediğini her zaman ayırt ettirmez; veri yokluğu “sağlıklı”, “sıfır uyku” veya kesin “izin reddedildi” diye yorumlanmaz. [Apple HealthKit](https://developer.apple.com/documentation/HealthKit/authorizing-access-to-health-data?changes=_2)

Apple, sağlık/fitness verilerinin reklam amaçlı kullanımına kısıtlar getiriyor. Türkiye'de sağlık verileri özel nitelikli kişisel veri kapsamındadır. Veri akışı, işleme dayanağı, saklama, silme ve dışa aktarma tasarımı geliştirmeye dahil edilmeli; buluta gönderim ayrı ve anlaşılır olmalı. Bu rapor hukuki uygunluk görüşü değildir. [Apple kuralları](https://developer.apple.com/app-store/review/guidelines/#health-and-health-research), [KVKK](https://www.kvkk.gov.tr/Icerik/2051/Ozel-Nitelikli-Kisisel-Veriler)

<!-- PAGE:10|IMAGE|04-gelisim-ve-profil -->
## 04 / Kişisel gözlemler ve profil kontrolü
Haftalık ekran kayıtları açıkça özetler; eksik günleri görünür bırakır. Profil, alerji ile tercihi ayrı tutar ve veri izinlerine doğrudan erişim sağlar.
Grafikteki tüm kayıtlar örnektir. Ekranın yayın sürümünde özetler gerçek kayıtlardan türetilmeli; tekil gözlemler tıbbi sonuçlara dönüştürülmemeli.

<!-- PAGE:11|Mevcut koddan yeni ürüne -->
## Temel var; wellness veri modeli yeni
Kaynak kod incelemesi Flutter + Riverpod, yerel SharedPreferences depolama, TR/EN, katalog tarifleri ve cihaz üstü bildirimleri doğruluyor. Mevcut kaynak bu oturumda çalıştırılmadı; performans ve uygulama test sonucu iddiası yok.

| Mevcut parça | Korunacak değer | Gerekli değişiklik |
|---|---|---|
| Tarif ve öneri servisi | 144 tarif, malzeme, alerjen, diyet ve envanter eşleştirmesi. | Yapılandırılmış gerekçe; efor/süre; tutarlı alternatif kontrolü. |
| Günlük mod | Günlük durum ve durumla öneri bağı. | Ruh hali, enerji, uyku, stres birbirinden ayrılan tarihli kayıtlar. |
| Kullanıcı profili | Alerji, sağlık bildirimi, tercih ve sevilmeyenler. | Hassasiyet ayrımı; hedef, ekipman, zaman ve izin modeli. |
| Plan ve tüketim | Pişirilenler, plan ve su/içecek kayıtları. | Wellness günlüğüyle ortak zaman ve kaynak mantığı. |
| Bildirim servisi | Yerel iki hatırlatma türü. | Rutin zamanı, sessiz saat, tekrar ve kullanıcı kontrolü. |
| Ana ekran ve menü | Ekran kabuğu ve gezinme. | Yeni beş sekme; günlük rehber ve besin alanının önceliği. |

### Özellikle çözülmesi gerekenler
Check-in depolaması tek son değeri saklıyor; gerçek haftalık ruh hali geçmişi yok. dailyMode ile checkIn ayrı durum kanalları. Wellness için DailyCheckIn, RoutinePlan, RoutineCompletion, SleepEntry ve RecommendationReason gibi tarihli kayıtlar gerekir.

Mevcut DayBoundary 06:00'ı gün sınırı alırken içecek tarih anahtarı takvim gününü kullanıyor. Uyku ise geceyi aşan bir aralıktır. Geçişte olay zamanı, saat dilimi, kullanıcının gün tanımı ve uyku başlangıç/bitiş aralığı birlikte tasarlanmalı. Tek saatle tüm verileri kesmek yeterli değil.

### Uygulama mimarisi
**Profil + günlük kayıt + envanter > kural ve eleme katmanı > eylem/öğün adayları > DailyPlan > tamamlanma kayıtları > haftalık özet.**

Zaman serileri büyüdükçe sorgulanabilir yerel veritabanı ve göç planı gerekir; hassas veri koruması ayrıca uygulanır. Eski profil ve tarif defteri korunmalı.

HealthKit / Health Connect bağlantıları mevcut bağımlılıklarda yok. Entegrasyon; izin, veri kaynağı, tekilleştirme ve senkronizasyon işidir. Health Connect uyku, beslenme ve mindfulness türlerini destekliyor; kullanılabilirlik sürüm ve özelliğe göre kontrol edilmeli. [Android belgeleri](https://developer.android.com/health-and-fitness/health-connect/data-types)

<!-- PAGE:12|Geliştirme ve iş modeli -->
## Önce günlük döngüyü doğrula
### Aşama 1 - Wellness çekirdeği
Günlük kayıt, beş sekmeli düzen, görünür besin seçimi, katalog tarifi, manuel su/uyku kaydı, küçük rutin seti ve betimleyici haftalık özet. Alerji/tercih geçişi ve tarihli kayıt altyapısı bu aşamaya dahil. Ana CTA “tarif bul”; yeni içerik üretilmiş gibi konuşmaz.

### Aşama 2 - Bağlantı ve kişisel üretim
İzinli sağlık bağlantıları, daha zengin içerik ve sunucuda tarif uyarlama/üretimi. Üretilen malzemeler kanonik kimliklere bağlanır; miktar, adım ve alerjenler tekrar kontrol edilir; besin hesabı mevcut hesaplayıcıyla yapılır. Çıktı geçersizse gösterilmez; ağ yoksa katalog çalışır. Sunucu anahtarı mobil uygulamaya gömülmez.

### Aşama 3 - Sürdürülebilir kişiselleştirme
Kullanıcı geri bildirimine göre tekrar azaltma, daha iyi planlama ve isteğe bağlı programlar. Sosyal ağ, klinik tanı/tedavi, takviye önerisi ve sürekli sohbet eden genel AI koç ilk kapsamın dışında tutulmalı. İleride ancak ayrı ihtiyaç ve içerik değerlendirmesiyle ele alınmalı.

### Gelir modeli: test edilecek hipotez
Ücretsiz: günlük kayıt, temel besin/tarif önerileri, kısa rutinler, alerji filtreleri ve veri kontrolü. Premium adayı: çok haftalı planlama, gelişmiş uyarlama ve geniş uzman içerik kütüphanesi. Alerjen filtreleri veya veri silme ödeme duvarının arkasına konmamalı. Fiyat ve ödeme isteği araştırılmadığından rakam önermiyorum.

### Ölçülebilir ürün doğrulaması
- **İlk anlama testi:** 10 hedef kullanıcıyla beş saniyelik ana ekran testi ve görev çalışması. Önerilen karar eşiği: en az 8/10 kullanıcının günlük durum + besin + rutin bağını açıklayabilmesi.
- **Temel görev:** Kullanıcı “süt ürünü istemiyorum, 15 dakikam var” senaryosunda yardım almadan besin değiştirip tarife ulaşabilmeli. Hedef eşik 8/10; ölçülmüş sonuç değildir.
- **Pilot:** Küçük bir yetişkin grubunda 2-4 hafta. Öneri görüntüleme > kabul > gerçekten pişirme/tamamlama, atlama sebepleri ve geri dönüş takip edilir. İş hedefleri pilot taban değerinden sonra belirlenir.
- **Ana ölçüm:** Haftada en az bir beslenme eylemi ve başka bir iyi oluş eylemi tamamlayan kullanıcı oranı; yalnız uygulamayı açmak başarı sayılmaz.
- **Yayın kapısı:** Çatışan alerjenli örnekler, eksik veri, profil değişimi, geceyi aşan kayıt, çevrimdışı ve büyük yazı senaryoları geçmeli. Beklenen filtre dışı öneri sayısı sıfırdır.

En önemli test: Kullanıcı uygulamayı “her şeyi kaydetmem gereken yer” olarak mı, yoksa “bugün ne yapacağıma yardımcı olan rehber” olarak mı görüyor?

<!-- PAGE:13|Kaynak notları - ürünler -->
## Ürün kaynakları
Tüm kaynaklara 7 Eylül 2026'da erişildi. Tarih belirtilmeyen ürün sayfalarında görünür yayın tarihi bulunmadı. Doğrulanan yetenekler ülke, cihaz, sürüm ve plan bazında değişebilir. Bağlantılar tıklanabilir.

- **Headspace:** Headspace + Apple Health. Yayın tarihi görünmüyor. Kişisel Today önerileri ve uyku/aktivite bağlantısı. [Resmi kaynak](https://www.headspace.com/integrations/apple)
- **Calm:** How to Use Check-Ins. Güncelleme 27 Temmuz 2026. Mod, uyku, şükran ve düşünce kayıtları. [Resmi kılavuz](https://support.calm.com/hc/en-us/articles/9699990936731-How-to-Use-Check-Ins-Mood-Sleep-Gratitude-Tracker)
- **Calm:** What are the Calm Dailies? Güncelleme 5 Mayıs 2026. Günlük meditasyon ve hareket. Calm Sleep ayrı ürün olduğundan özellikleri ana Calm'a aktarılmadı. [Resmi kılavuz](https://support.calm.com/hc/en-us/articles/115005140414-What-are-the-Calm-Dailies-Daily-Meditations-Movement)
- **Fabulous:** How does Fabulous work? Tarih görünmüyor. Rutinler, Journeys ve kısa koçluk. [Resmi kılavuz](https://help.thefabulous.co/en/support/solutions/articles/101000427430-how-does-fabulous-work-)
- **Finch:** New User Guide. 22 Aralık 2025. Öz bakım hedefleri, karakter geri bildirimi, nefes ve düşünce araçları. [Resmi kılavuz](https://help.finchcare.com/hc/en-us/articles/42149821015693-New-User-Guide)
- **Oura:** Meals. Güncelleme 5 Ağustos 2026. Öğün zamanı, tahmini besin bileşimi ve alternatifler. İncelenen kaynak: Gen3+, aktif üyelik ve İngilizce. [Resmi kılavuz](https://support.ouraring.com/hc/en-us/articles/40264659421843-Meals)
- **Samsung:** Samsung Health. Tarih görünmüyor. Beş ana sağlık/wellness alanı. Türkiye'de tüm özelliklerin kullanılabilirliği bu çalışmada doğrulanmadı. [Resmi ürün sayfası](https://www.samsung.com/us/apps/samsung-health/)
- **Lifesum:** Features. Tarih görünmüyor. Tarif kişiselleştirme, su kaydı ve plan. [Resmi ürün sayfası](https://lifesum.com/features/)
- **Lifesum:** Nutrition & Sleep. Sayfada 05/11/2025; gün/ay sırası netleştirilmedi. [Uyku bağlantısı](https://help.lifesum.com/en/article/nutrition-sleep-1m14nq8/). Planların genel öneri olduğu sınırı ayrıca kontrol edildi. [Plan kılavuzu](https://help.lifesum.com/en/article/list-of-all-available-meal-plans-how-to-get-started-1q8a3og/)
- **ZOE:** Tim Newman, ZOE 2.0: Science made simple. 17 Mart 2026. Besin puanı, koç ve isteğe bağlı test. Algoritmanın klinik geçerliliği ayrıca incelenmedi. [Resmi ürün açıklaması](https://zoe.com/learn/zoe-2-0-science-made-simple)

Resmi sayfalar özellik varlığını destekler; kullanım kolaylığı veya etkinlik hakkında bağımsız sıralama yapmaya yetmez. Kullanıcı görüşmeleri ve mağaza yorumları üzerinden temsil gücü olan bir talep araştırması yapılmadı.

<!-- PAGE:14|Kaynak notları - kanıt ve yöntem -->
## Sağlık, platform ve yöntem kaynakları
- **WHO:** Healthy diet, 26 Ocak 2026. Genel denge ve çeşitlilik ilkeleri. [Kaynak](https://www.who.int/news-room/fact-sheets/detail/healthy-diet)
- **WHO:** Physical activity, 26 Haziran 2024. Genel hareket çerçevesi. [Kaynak](https://www.who.int/news-room/fact-sheets/detail/physical-activity)
- **NIH/NCCIH:** Meditation and Mindfulness: Effectiveness and Safety. Tarih görünmüyor. Bulguların ve güvenlik verisinin sınırları. [Kaynak](https://www.nccih.nih.gov/health/meditation-and-mindfulness-effectiveness-and-safety)
- **NIH/NHLBI:** Healthy Sleep Habits, 24 Mart 2022. Düzen ve zamanlama. [Kaynak](https://www.nhlbi.nih.gov/health/sleep-deprivation/healthy-sleep-habits)
- **Jacka ve ark.:** SMILES, BMC Medicine, 30 Ocak 2017. Küçük, uzman destekli klinik müdahale. [Araştırma](https://link.springer.com/article/10.1186/s12916-017-0791-y)
- **Bot ve ark.:** MooDFOOD, JAMA, 5 Mart 2019. Farklı önleme müdahalesinde negatif birincil sonuç. [Araştırma](https://jamanetwork.com/journals/jama/fullarticle/2726983)
- **NIH/NIDDK:** Definition & Facts for Lactose Intolerance. İnceleme Şubat 2018. Alerji ve intolerans ayrımı. [Kaynak](https://www.niddk.nih.gov/health-information/digestive-diseases/lactose-intolerance/definition-facts)
- **FDA:** Food Allergies. Görünür tarih yok. Kaçınma, etiket ve çapraz temas. ABD etiket mevzuatı Türkiye'ye genellenmedi. [Kaynak](https://www.fda.gov/food/nutrition-food-labeling-and-critical-foods/food-allergies)
- **Apple:** HealthKit authorization ve App Review Guidelines 5.1.3. Güncel erişim. İzin/veri kısıtları. [HealthKit](https://developer.apple.com/documentation/HealthKit/authorizing-access-to-health-data?changes=_2) | [İnceleme kuralları](https://developer.apple.com/app-store/review/guidelines/#health-and-health-research)
- **Google:** Health Connect data types. Güncel erişim. Veri türleri, izin ve özellik kontrolleri. [Belge](https://developer.android.com/health-and-fitness/health-connect/data-types)
- **KVKK:** Özel Nitelikli Kişisel Veriler. Güncel erişim. Sağlık verisi kategorisi. [Kurum açıklaması](https://www.kvkk.gov.tr/Icerik/2051/Ozel-Nitelikli-Kisisel-Veriler)

### Yerel inceleme
lib/services/recommendation_service.dart; storage_service.dart; notification_service.dart; lib/providers/check_in_provider.dart; daily_mode_provider.dart; beverage_provider.dart; lib/models/user_profile.dart; lib/core/day_boundary.dart; lib/screens/main_shell.dart; home/home_screen.dart; pubspec.yaml ve assets/recipes/*.json.

### Araştırmanın sınırı
Bu çalışma sistematik literatür derlemesi veya klinik doğrulama değildir. Resmi ürün taraması, olumlu/olumsuz kanıt karşılaştırması ve kod analiziyle ürün kararını destekler. Sonuçlar için ek genel arama yerine, talep/ödeme isteği ve gerçek kullanım pilotu gerekli görüldü. Görseller image_gen ile üretildi; yeni uygulama kodu yazılmadı.

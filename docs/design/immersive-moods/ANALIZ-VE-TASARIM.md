# NutriGuide — modun uygulamanın tamamına yayılması

8 Eylül 2026. Tasarım önerisi, uygulama koduna uygulanmadı. Bu belge önceki `visual-first/PLAN.md` içindeki yalnızca vurgu renkleriyle sınırlı mod yaklaşımının yerini alır. Büyük kartlar, kısa etiketler, bilgi pencereleri ve gezinme mimarisi korunur.

## 1. Önceki çizim neden yeterince farklı hissettirmedi?

Üç ekranın da baskın alanı lacivertti. Kart dolguları, yazılar, yemek kartı, alt menü zemini ve ışık yapısı neredeyse aynı kaldı. Kullanıcı değişikliği ancak ikon veya seçili düğmeye dikkat edince görebiliyordu. Duygu teması, arayüzün atmosferini değiştirmek yerine renk seçici gibi çalışıyordu.

Yeni tasarımın ölçütü: üç ekran küçük boyutta yan yana gösterildiğinde, etiketler okunmadan da üç farklı dünya görülmeli. Aynı zamanda kart yerleri ve temel eylemler tanıdık kalmalı. Bunun için marka kimliğini tek bir renge değil **ortak şekillere, ufuk geometrisine, göksel ışık motifine, tipografiye ve kart oranlarına** bağlıyorum.

Bu, renklerin ruh halini tedavi ettiği iddiası değildir. Seçilen durumun görsel ve davranışsal olarak karşılık bulmasını amaçlayan bir ürün tasarımı hipotezidir. Hangi görünümün hangi kullanıcıya iyi geldiği, kullanıcının tercihi ve prototip denemeleriyle değerlendirilir.

Üç yaratıcı yaklaşımı karşılaştırdım. Sadece vurgu rengi değiştirmek önceki çizimdeki görünürlük sorununu çözmüyor. Bütün ekranı hareketli bir manzaraya çevirmek ise büyük kartların tanınmasını ve okuma sadeliğini zayıflatıyor. Seçtiğim yaklaşım, uygulamanın yüzeylerini bir malzeme ve ışık ailesi etrafında birlikte dönüştürmek: arka plan atmosfer kuruyor, düz kartlar seçimi kolaylaştırıyor, kısa etkileşimler karakter katıyor.

Mürdüm/kadife, kullanıcının üstüne örtülen sıcak bir katman benzetmesi; petrol/su, bir şeyleri acele ettirmeyen yatay ritim; kayısı/şafak, hareket alanı açan gün ışığı benzetmesi. Bunlar yaratıcı sanat yönetimi kararlarıdır, bütün insanlarda aynı duyguyu oluşturacağına dair bilimsel iddia değildir. Her dünyada aynı aracı aynı yerde bulabilmek, benzetmenin önünde gelir.

## 2. Üç bütüncül dünya

| Kullanıcının seçimi | Yaratıcı yön | Bütün arayüzde etkisi | Küçük dokunuş |
|---|---|---|---|
| Yorgunum | **Kadife akşam** | Sıcak mürdüm zemin, mat gül kurusu kartlar, kırık beyaz yazı, şampanya ikon ve eylemler; yumuşak kumaş kıvrımını andıran ufuk | Karşılama: “Bugün azı da yeter.” Kısa efor seçenekleri, sakin tek geçiş, isteğe bağlı iki dakikalık mola |
| Sakinim | **Durgun su** | Petrol yeşili zemin, deniz camı yüzeyler, inci yazılar, açık yeşim ikonlar; yatay ve durgun bir su ufku | Karşılama: “Kendi ritminde devam.” Mevcut rutine dönme, dengeli boşluk ve ince su halkası geri bildirimi |
| Enerjik | **Kayısı şafağı** | Açık kayısı zemin, kum/şeftali kartlar, kakao yazılar, bakır eylemler; aynı ufuk ailesinde gün doğumu diski | Karşılama: “Bugüne alan aç.” Kullanıcının seçebileceği ek adım, kısa ve belirgin dokunma karşılığı |

İlk iki dünya koyu ama birbirinden belirgin biçimde farklıdır; üçüncü dünya bilinçli olarak aydınlıktır. Kayısı şafağı, gece temasının sadece turuncu düğmeli hali değildir. Aynı kart yapısı ve ikon sistemi sayesinde ayrı bir uygulamaya dönüşmeden farklı hissettirir.

## 3. Tüm renkler hangi alanları kapsar?

| Katman | Tasarım kararı |
|---|---|
| Açılış ve sayfa zemini | Tam mod paleti; önce lacivert gösterip sonradan renk değiştiren açılış parlaması yok |
| Başlık, app bar ve gezinme | Zemin, seçili/seçili olmayan ikon, yazı, gölge ve ayırıcılar birlikte değişir |
| Büyük kartlar ve listeler | Kart dolguları, kenarlar, gölgeler, boş/etkin/seçili durumlar moda aittir |
| Tipografi | Yorgun/sakin dünyada açık yazı; aydınlık dünyada koyu kakao. Boyut ve okunaklı ağırlık korunur |
| İkonlar | Şekil ve anlam sabit; çizgi/dolgu renkleri mod paletinden gelir. Tek tip lacivert ikon kutuları kalmaz |
| Formlar | Metin alanı, imleç, placeholder, çip, seçim kutusu, kaydırıcı, tarih/saat seçimi temaya dahil |
| Bilgi pencereleri | “i” penceresi, scrim, açılır detay, kapat ve ana düğme aynı dünyaya ait |
| İçerik ekranları | Tarif, pişirme adımları, mutfak, alışveriş, beslenme geçmişi, uyku, nefes, gelişim, profil ve bağlantı ekranları birlikte dönüşür |
| Grafikler | Zemin, eksen, çizgi, nokta, seçili gün, açıklama ve veri yok durumları palete uyar; seri anlamları etiket/şekille korunur |
| Geçici durumlar | Yükleme, hata, kayıt tamamlandı, geri al ve boş veri yüzeyleri de moda uyar |
| Dekoratif görseller | Ufuk, ışık diski, nefes küresi ve küçük boş durum illüstrasyonlarının her dünyaya ait sürümü vardır |
| Yemek fotoğrafı | Fotoğraf doğal renklerini korur; etrafındaki yüzey, kadraj gölgesi ve metin zemini değişir. Bütün ekrana renk filtresi uygulanmaz |

Uygulamanın yönettiği durum çubuğunda ikon parlaklığı seçilen zemine uyar. Sistem sağlık izin pencereleri, sistem klavyesi ve üretici logoları işletim sistemi/markanın kurallarına tabidir; bunları keyfî biçimde yeniden boyadığımız söylenmez. Uyarılar her dünyada anlaşılır ikon ve metin taşır; tehlike ile başarı aynı estetik renge indirgenmez.

## 4. “Yorgunum” seçilince ne olur?

1. Günün ilk açılışında kısa “Şu an nasılsın?” ekranı: üç büyük, kendi mini atmosferini gösteren seçim kartı. Yorgunum / Sakinim / Enerjik. “Şimdi değil” görünürdür. Açıklama tek satırdır: “Seçimin görünümü ve önerileri değiştirir.”
2. Kullanıcı Yorgunum'a bir kez dokunur. Ayrı bir tema ayar menüsüne veya ikinci “uygula” adımına ihtiyaç yoktur. Kayıt başarısızsa sessizce kaydedilmiş gibi davranılmaz; yeniden deneme ve kayıtsız devam ayrılır.
3. Bütün yüzeyler kısa bir çapraz geçişle Kadife akşam'a dönüşür. Kartlar zıplamaz, ekran sallanmaz, karartılıp metinler kaybedilmez. Tam ekran bekleten dekoratif animasyon yoktur.
4. Ana ekranda “Bugün azı da yeter.” yazısı belirir. Beslenme kartındaki öneri, varsa hazırlık süresi ve mutfaktaki malzemelerle az efor gerektiren seçeneklerden gelir. Alerji/intolerans filtreleri her zaman önce uygulanır.
5. Nefes kartı iki dakikalık kısa molayı açıkça sunar. Oturum kendiliğinden başlamaz. Su kartı kendiliğinden hedef artırmaz. Uygulama kullanıcının yorgunluğundan mineral eksikliği veya tedavi ihtiyacı çıkarmaz.
6. Kullanıcı Keşfet'e, tarife, alışverişe veya bilgi penceresine geçince aynı mürdüm dünya devam eder. Nefes küresi de mavi kalmak yerine şampanya ışıklı, yumuşak bir halka olur.
7. Görev bitiminde küçük onay işareti ve “Kaydedildi” görünür. Konfeti, rozet baskısı, suçlayıcı tamamlanmamış hedefler veya zorunlu seri sayacı eklenmez.

“Yorgunum” bir enerji ifadesidir; otomatik olarak düşük ruh hali, yüksek stres veya kötü uyku olarak kaydedilmez. Bu seçim için ayrı bir durum alanı tutulur; önceki uyku, stres ve duygu kayıtları korunur. İnsan hem yorgun hem mutlu olabilir.

## 5. Küçük ama karakterli dokunuşlar

| Dokunuş | Yorgunum | Sakinim | Enerjik |
|---|---|---|---|
| Ortak ufuk | Mat, yuvarlak kıvrımlar ve alçak sıcak ay | İnce yatay su yüzeyi ve inci yansıma | Açık kum kıvrımı ve yükselen gün ışığı |
| Nefes görseli | Sıcak şampanya halkası, düşük parlama | Yeşim-su halkası | Bal rengi halka, açık yüzeyde koyu okunaklı metin |
| Dokunma karşılığı | 220 ms yumuşak renk/dolgu değişimi | 180 ms küçük, yerel halka | 140 ms belirgin dolgu değişimi |
| Tema geçişi | En fazla 360 ms opaklık geçişi | En fazla 280 ms | En fazla 220 ms |
| Tamamlama | İnce onay ve kısa yazı | İnce halka kapanışı ve kısa yazı | Tek kısa ışık vurgusu ve kısa yazı |
| Öneri sunumu | “Kısa bir başlangıç” | “Rutinine dön” | “İstersen bir adım daha” |

Süreler tasarım önerisidir, test edilerek ayarlanır. Sürekli hareket eden duvar kâğıdı, sim parçacıkları, parallax veya otomatik ses eklemiyorum. Yaratıcılık burada daha çok eşyanın malzemesinde, ışığında ve verilen küçük karşılıkta. Hareket azaltma etkinse dekoratif hareket kapalı, tema geçişi anlıktır. Nefes zamanı metin olarak okunabilir; görsel animasyon zorunlu değildir.

Oturum sırasında mod değiştirmek zamanlayıcıyı sıfırlamaz; ses eklenirse bir gün, ses de durup yeniden başlamaz. Tema değişimi bir görünüm güncellemesidir, uygulamanın yeniden kurulması değildir.

## 6. Ortak kalması gereken kimlik

- Aynı büyük dikdörtgen kart oranları, köşeler, ikon geometrisi ve yazı ailesi.
- Aynı beş sekme: Bugün, Keşfet, Plan, Gelişim, Profil.
- Aynı kart konumları, eylem isimleri ve i düğmelerinin yeri. Mod değişimi kullanıcının kas hafızasını bozmamalı.
- Aynı ufuk eğrisinden türeyen üç sahne. Ay/gece kimliği, Enerjik görünümde aynı geometrinin gün ışığına açılmasıyla devam eder.
- Aynı veri doğruluğu: kaydı olmayan gün boş; bağlanmamış cihaz bağlı görünmez; tarifin alerjeni her temada görünür.
- Aynı bilgi sadeliği: kısa kart etiketi ve gerekli durum; ayrıntı bilgi penceresinde.

Görsel tema ile sunulan ürün işlevleri karıştırılmaz: yorgun kullanıcıdan hareket veya planlama araçları saklanmaz. Diğer seçeneklere erişim korunur. Bu yaklaşım, kişiselleştirirken kullanıcı kontrolünü koruma önerisiyle uyumludur. [NN/g — Personalization](https://www.nngroup.com/articles/personalization/).

## 7. Kullanıcının kontrolü ve günün akışı

İlk açık seçim mod ve görünümü birlikte uygular; önceki önerideki ayrı “mod uyumunu aç” adımı kaldırılır. Kullanıcı daha sonra Görünüm'den temayı sabitleyebilir. Sabitleme, yeni enerji kaydını engellemez; yalnız otomatik görünüm değişimini durdurur. “Modu değiştir” ana ekranda kolay erişilir. Aynı gün her açılışta tekrar soru sorulmaz.

Mevcut uygulama günü 06.00'da değişiyor (`DayBoundary`). Yeni durum kaydı da bu tanımı kullanmalı. Yeni gün geldiğinde önceki görsel tercih korunarak açılış parlaması önlenir, fakat dünün yorgunluğu bugünün güncel kaydı gibi gösterilmez. Soru atlanırsa yeni sağlık/durum kaydı üretilmez. Seyahat ve saat dilimi değişiminde gün anahtarı mevcut kayıtlarla tutarlı tutulur.

Kayısı şafağı bu çizimde açık görünür. Koyu görünümü sabitleyen kişi için aynı sıcak ailede koyu kehribar eşleniği gerekir; aydınlık ekran tercihi zorla uygulanmaz. Sistem erişilebilirlik tercihleri dekoratif ayarlardan önceliklidir. Bütün paletleri değiştirmek ekran parlaklığını işletim sistemi dışında otomatik yükseltmek anlamına gelmez.

## 8. Geliştirilebilir mimari

Mevcut `AppTheme` sabit renkler kullanıyor; `light` bile `dark` değerini döndürüyor. `HorizonScene` ve orijinal pano kırpımları da lacivert zeminleri içeriyor. Bu nedenle tek bir mint sabitini değiştirmek, kullanıcının istediği dönüşümü sağlayamaz.

Onaydan sonra önerilen çözüm:

1. Tema için uygulama kökünde tek durum kaynağı: görünüm modu, seçilen atmosfer, kullanıcı sabitlemesi ve hareket tercihi.
2. Her atmosfer için anlamsal renk rolleri: canvas, surface, elevated, primary/onPrimary, text/secondary, outline, modal, scrim, chart, error/warning/success. Tema tüm Navigator rotaları ve popup'lara taşınır.
3. Sabit `AppTheme.*` ve yerel `Color(...)` kullanımlarını bu rollere geçirmek. Önce yeni kartlar, sonra korunmuş bütün eski tarif/alışveriş/ayar ekranları. Karışık temalı ara teslim “tamamlandı” sayılmaz.
4. Dekoratif ufuk/ay/güneş ve nefes varlıklarını metinsiz, bağımsız katmanlar olarak üretmek. Mavi arka planı gömülü eski panoları mürdüm veya kayısı zemin üzerine olduğu gibi koymamak. Yemek fotoğrafını ayrı tutmak.
5. Ortak bileşen geometrisi, farklı renk/malzeme tokenları. Aynı ekranın üç ayrı kopyasını yazmamak.
6. Kullanıcı seçimini mevcut şifreli depoda sürümlü ek alanla tutmak; eski kayıtları doldurulmuş yeni duygu verisine çevirmemek.
7. Modun önerilere etkisini ayrı kurallarla uygulamak. Önce zorunlu beslenme filtreleri, sonra kullanıcının zaman/efor/tercih bağlamı. Sabit referans yemeği önceliği kaldırılır; sırf güzel fotoğrafı olduğu için tarif öne geçmez.

Bu metin uygulama değişikliği değildir. Çizimdeki tüm özellikler veya tema motoru bugün varmış gibi sunulmaz. Onaydan sonraki çalışma kapsamına dahildir.

## 9. Renk ve hareket doğrulaması

Normal metin için en az 4.5:1, büyük metin için 3:1 kontrast hedefi; renkler düz yüzeyde ölçülür. Fotoğraf üstündeki metin için ayrıca uygun düz zemin/scrim kullanılır. Dokulu yüzey üzerindeki her durum gerçek uygulamada kontrol edilir. [W3C — Contrast](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html).

Dekoratif etkileşim animasyonları kapatılabilir. Bu tasarım, WCAG'nin etkileşimle başlayan hareketi kapatma yaklaşımını benimser; çizimler kendi başına erişilebilirlik sertifikası değildir. [W3C — Animation from Interactions](https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html).

Tema tokenları ve seçili renk çiftlerinin hesapları `theme-tokens.json` dosyasındadır. Bu doğrulama, önerilen renklerin sayısal kontrolüdür; henüz uygulama testleri veya kullanıcı araştırması yapılmadı.

## 10. Tasarım kabul denemesi

1. Üç dünya küçük önizlemede, etiket okunmadan ayırt edilebiliyor mu?
2. Yorgunum seçildikten sonra Bugün → Keşfet → Tarif → i penceresi → Uyku → Profil boyunca eski lacivert yüzey kalıyor mu?
3. Katılımcı aynı aracı üç dünyada aynı yerde bulabiliyor mu?
4. Yorgun kullanıcı için küçük dokunuşlar destekleyici mi, yoksa çocuklaştırıcı veya yargılayıcı mı? Karşılama metni ve dokular bu geri bildirimle ayarlanır.
5. Aydınlık Enerjik görünüm, aynı markanın parçası olarak algılanıyor mu? Algılanmıyorsa kart/ikon/ufuk tutarlılığı güçlendirilir.
6. Büyük yazı, ekran okuyucu, hareket azaltma, renk görme farklılıkları, odak halkası ve hata durumları her temada doğrulanıyor mu?
7. Tema değişirken açık form, zamanlayıcı, liste konumu ve kaydedilmemiş girişler korunuyor mu?

Onaydan sonra önce yalnızca bir dikey akış, Yorgunum → Bugün → Beslenme → Bilgi → Nefes, gerçek Flutter ekranlarıyla çizime eşlenmeli. Ardından aynı tema sistemi tüm ekranlara ve diğer iki atmosfere genişletilmeli. Böylece önceki çizim/uygulama farkı erken görünür olur.

## Çizim seti

- `01-uc-dunya.png`: üç modun tüm ekran renklerini değiştirmesi.
- `02-yorgun-tum-ekranlar.png`: aynı Yorgunum temasının Keşfet, Beslenme ve Uyku içinde sürmesi.
- `03-secim-ve-mola.png`: tek seçimle giriş ve bu dünyanın nefes molasındaki devamı.

Yerleşik imagegen ile oluşturulan tasarım çizimleridir; uygulamadan alınmış görüntüler değildir. Üretim promptları ayrıca saklanır. Onay öncesi uygulama kodu değiştirilmez.

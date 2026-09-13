# Referans eşleştirmesi: doku, ışık ve derinlik

8 Eylül 2026 · Uygulamaya işlendi

İlk görüntüdeki kartlar, düzenli çizgili ve büyük ölçüde tek renkli yüzeyler olarak görünüyordu. İkinci görüntüdeki etki ise geniş bir ışık kaynağının, koyu malzemenin, düzensiz mikro dokunun ve birkaç farklı kenar/gölge katmanının birlikte çalışmasından doğuyor. Önceki çizgi yoğunluğunu artırmak bu malzeme hissini üretmiyordu.

İlk görüntü Keşfet kartlarının kırpılmış bir bölümü; ikinci görüntü Bugün ekranının üç ayrı regl teması. Bu nedenle yalnızca iki görüntünün genel mor tonunu karşılaştırmak yanıltıcı olur. Malzeme karşılaştırması PMS, regl krampları ve regl yorgunluğu için ayrı yapıldı. Son kontrol ekranlarında aynı nohutlu bulgur kasesi kullanılarak içerik değişkeni sabitlendi.

[Kullanıcının mevcut ekranı](user-current.png) · [Hedef çizim](user-target.png) · [Çalışan uygulama karşılaştırması](../../../output/reference-material/reference-match.png)

## Bulunan farklar ve uygulanan düzeltmeler

| Alan | Önceki görünüm | Referanstaki özellik | Uygulama değişikliği |
| --- | --- | --- | --- |
| Doku | Eşit aralıklı kıvrımlı çizgiler ve tek tek noktalar; her kartta aynı desen | Düzensiz, çok ince saten dokusu ve yumuşak bulutlanma | Nötr malzeme haritası ImageGen ile üretildi. Çizgi ve nokta döngüleri kaldırıldı. Harita yüzeye soft-light ile karışıyor. |
| Ana ışık | Bütün yüzeyi benzer ölçüde aydınlatan dolgu | Üst-soldan yayılan geniş, yumuşak ışık; ortada daha koyu ton | Üst-sol merkezli eliptik ışık ve dört duraklı dolgu ayrı hesaplanıyor. |
| Renkli yansıma | Açık/krem karışımın kartı soldurması veya bütün kartın aşırı doygunlaşması | Kartın kendi renk ailesinde aydınlanması | Koyu kartın yansıması kendi HSL tonundan üretiliyor. Ana eylemlerin daha açık vurgusu ayrı tutuluyor. |
| Dış kenar | Kalınlığı ve rengi fazla belirgin mor çerçeve | İnce, üst-sol tarafta daha görünür, diğer köşelerde hafifleyen kenar | 0,75 mantıksal piksel çizgi ve yönlü renk geçişi kullanılıyor. |
| Kenar derinliği | Tek çerçeveyle sınırlı hacim | Kenarın içinde yumuşak kararma, alt kenarda toplanan ışık | İç gölge ve alt yansıma birbirinden ayrı, hafif bulanık çizim katmanları. |
| Dış gölge | Arka plan renginde bir gölge; yüzeyden ayrışması zayıf | Yakın temas gölgesi ve daha geniş, yumuşak düşen gölge | İki ayrı gölge: 3 piksel bulanıklıklı yakın gölge ve 13 piksel bulanıklıklı geniş gölge. Yoğunluk açık/koyu temaya uyarlanıyor. |
| Köşeler | Özellik kartlarında 22 piksel yarıçap; fazla yuvarlak görünüm | Daha belirgin dikdörtgenler ve daha küçük köşeler | Özellik kartları 16 piksel köşeye geçirildi. Ana kapsül düğmelerin biçimi ayrı korundu. |
| Ölçü ve boşluk | İçerikte 22 piksel yan boşluk, küçük simgeler ve farklı kart oranları | Daha geniş kartlar; simge, etiket ve bilgi düğmesi arasında belirgin düzen | Yan boşluk 14 piksel, ana özellik kartı yüksekliği 136 piksel, ortak simge alanı 66 piksel. Büyük yazı desteği kartları büyütmeye devam ediyor. |
| Tipografi | Kart etiketleri fazla ağır | Daha hafif ve rahat okunan etiketler | Özellik etiketleri 19 piksel / 400 ağırlık; simgeyle arası 6 piksel. |
| Bilgi düğmesi | Kalın yerel “i” halkası | İnce halka ve küçük serif etkili “i” | İnce simge Flutter ile yeniden çizildi. Dokunma alanı en az 48 × 48 olarak korunuyor. |
| Büyük simgeler | Düz renk, bazı temalarda fazla sarı vurgular | Açık şeftali/lila tonları ve hafif ışık değişimi | Simge mürekkebine yönlü renk geçişi eklendi; ölçüler düzenlendi. Anlama göre çalışan animasyonlar korunuyor. |
| Tarif eylemi | Düz renk kapsül ve tek ok | Aydınlık kapsül içinde ayrı, yuvarlak ok alanı | Saten bitiş, açık ok dairesi, ince kenar ve geri dönen ok hareketi birlikte uygulanıyor. |
| Sayfa zemini | Kartların arkasında büyük ölçüde düz alan | Sayfanın alt bölgelerine kadar süren ortam rengi | Beş ana sayfa ve alt menünün arkasına ortak, yumuşak renkli aydınlatma eklendi. Kısa sayfalarda içerik üstten hizalanıyor. |
| Regl sahneleri | PMS ve kramp sahnelerinde tam güneş; yorgunlukta su yerine kumul | Üç hilal; regl yorgunluğunda göl ve yatay yansıma | Referansa göre üç satırlı yeni sahne atlası üretildi. Alt kısımdaki suyu koruyacak şekilde perdeleme ayarlandı. |
| Yemek fotoğrafı | Daha tepeden açı, düz tabak hissi ve fazla koyu perde | Kavisli kase, daha alçak açı, sıcak ışık ve belirgin temas gölgesi | Referanstaki nohutlu bulgur kasesinin yeni geniş fotoğrafı üretildi. Fotoğraf üzerindeki renk perdesi azaltıldı. |
| Tarif bilgisi | Kompakt kartta bilinen süre görünmüyordu | Başlığın altında küçük saat simgesi ve süre | Süresi bilinen tariflerde gerçek süre gösteriliyor. Bilinmeyen süreye “15 dk” yazılmıyor. |

## Renklerin kontrolü

Referansın küçük nefes kartlarında metin ve simgelerin dışından altı konum seçildi: üst-sol, üst, sol-orta, merkez, sağ-orta ve alt. Her konumda 5 × 5 piksellik bölgenin RGB ortalaması alındı. Uygulama tarafında kart sınırı elle tahmin edilmedi; Flutter yerleşiminden okunup aynı göreli konumlar kullanıldı.

| Tema | Referans merkez | Çalışan ekran merkezi |
| --- | --- | --- |
| PMS | `#532D3A` | `#532D39` |
| Regl krampları | `#5B3022` | `#5B2F22` |
| Regl yorgunluğu | `#39304C` | `#382F4C` |

[Referans örnekleri](reference-samples.json) ve [çalışan ekran örnekleri](rendered-samples.json) tüm kontrol noktalarını içerir. Bu ölçüm, seçilen yüzey tonlarını denetler; tüm ekranın piksel düzeyinde özdeşliğini veya cihaz ekranının renk kalibrasyonunu ölçmez. Telefon kasası ve işletim sistemi çubuğu, Flutter arayüz çıktısının kapsamı dışındadır.

PMS, kramp, regl yorgunluğu ve düşük enerji paletleri referans doğrultusunda ayarlandı. Ortak malzeme sistemi dokuz temanın tamamında kullanılıyor; diğer temaların renk kimlikleri korunuyor. Güncel değerler ve taban yazı/dolgu kontrastları [palettes.json](palettes.json) dosyasında.

## Görsel varlıklar ve uygulama yapısı

Yerleşik `image_gen` aracı kullanıldı. Üretilen PNG dosyaları değiştirilmeden projeye kopyalandı:

- [Saten malzeme haritası](../../../assets/materials/satin-neutral.png): bütün ortak yüzeylerde kullanılan nötr mikro doku.
- [Regl sahneleri atlası](../../../assets/moods/period-reference-v2.png): PMS, kramp ve yorgunluk için üç ayrı satır.
- [Nohutlu bulgur kasesi](../../../assets/food/moonlit-bowl-hero-v2.png): bu tarife ait fotoğraf.

[Üretim promptları](imagegen-prompts.json) ve [dosya boyutları / SHA-256 kayıtları](assets.json) saklandı. Diğer tariflerin kendi görselleri ve kişiselleştirilmiş sıralama sistemi çalışmaya devam ediyor. Karşılaştırma ekranlarında tek tarif kullanılması yalnızca görsel denetim verisidir.

Metin, simge, odak alanı, dokunma ve bilgi pencereleri Flutter bileşenleridir. `SatinTexture`, görseli Flutter görüntü önbelleği üzerinden paylaşır; kapanan bileşenin dinleyicisini ve görüntü tutamacını bırakır. Doku sabittir; dokunma ışığı ayrı katmanda çalışır. Sistem hareket azaltma tercihi, duraklatma ve onboarding yaşam döngüsü düzeltmeleri korunur.

## Doğrulama ve teslim

- 152 otomatik test geçti; Flutter analizi temiz.
- Dokuz tema, seçim/kayıt, tüm sekmeler, büyük yazı, bilgi pencereleri, su kaydı, oturumlar ve onboarding tema değişimi yeniden kontrol edildi.
- Üç aynı içerikli uygulama ekranı ayrı Flutter çalıştırmasıyla üretildi; yerleşim hatası yok.
- Android debug APK normal `lib/main.dart` giriş noktasıyla başarıyla derlendi.
- Bu çalışmada fiziksel cihaz performans ölçümü yapılmadı. Önceki native emülatör denemesi emülatörün kapanması nedeniyle tamamlanamamıştı.

[Güncel karşılaştırma](../../../output/reference-material/reference-match.png) · [PMS](../../../output/reference-material/matched-pms.png) · [Kramp](../../../output/reference-material/matched-periodCramps.png) · [Regl yorgunluğu](../../../output/reference-material/matched-periodFatigue.png)

Diğer gerçek uygulama ekranları `output/mood-experience/` altında yenilendi. Yeniden üretim dosyası: `tool/render_material_reference_test.dart`; örnek telefon alanı 390 × 844, üst güvenli alanı 24 piksel. Donanım ekran kaydı değil, çalışan Flutter arayüzünün çıktısıdır.

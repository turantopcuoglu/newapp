# NutriGuide · Dokuz atmosfer

Onaylanan durum seçimi ve büyük kartlı tasarım mevcut Flutter uygulamasına uygulandı. Önceki tasarım belgelerindeki “tasarım / onay bekliyor” durumu bu uygulama çalışmasıyla tamamlandı.

En güncel doku ve ışık uygulaması: [Referans eşleştirme analizi](../reference-material/ANALYSIS.md). Önceki düzenli çizgi dokusunun yerini saten malzeme haritası aldı; referanstaki regl sahneleri, kase fotoğrafı, kenarlar ve kart ölçüleri yeniden eşleştirildi.

## Uygulanan yapı

- Bugün, Keşfet, Plan, Gelişim ve Profil; büyük simgeli kartlar ve ayrı bilgi düğmeleri.
- Kodda bulunan dokuz durum, Günlük / Regl dönemi seçimiyle korunur. Seçim; uygulama arka planını, kartları, yazıları, menüyü, formları, pencereleri ve grafiklerin temasını değiştirir.
- Günlük durum ve görünüm şifreli wellness kaydında saklanır. Durum değiştirmek mevcut enerji, stres, uyku ve hazırlık süresi yanıtlarını değiştirmez. Profil → Atmosfer ile görünüm sabitlenebilir.
- Yeni güne girişte isteğe bağlı durum seçimi; atlama ve sonradan değiştirme.
- Beslenme önerileri önce alerji ve beslenme filtrelerinden geçer; günlük durum, süre ve mevcut malzemeler sıralamaya katılır. Eski sabit bulgur kasesi önceliği kaldırıldı.
- Tarif kitabı, yemek planı, alışveriş, içecek kayıtları, sağlık bağlantıları, beslenme tercihleri ve geçmiş kayıtlar erişilebilir kalır.

## Hareket

- Kart ve sekme girişleri, sayfa geçişleri ve tema dönüşümü.
- Simgesine göre hareket eden kontroller: dalga, damla, ay, kalp, pil, odak halkası, güneş, yürüme ve ayarlar.
- Nefes: genişleyip daralan ışık halkası. Meditasyon: yavaş yörüngeler. Yürüyüş ve esneme: ritmik soyut figürler.
- Animasyonlar Flutter'ın ekran yenilemesine bağlı çalışır; kapalı sekmelerin hareketi durur. Sistem hareket azaltma tercihi desteklenir.
- Oturumlar kullanıcı başlatınca çalışır, uygulama arka plana geçince duraklar ve kendiliğinden devam etmez. Tamamlanmamış oturumlar tamamlandı olarak kaydedilmez.

## Görseller

- 144 katalog tarifi için ayrı hücrelere eşlenen fotoğraf görselleri; önceki onaylı bulgur kasesi görseliyle toplam 145 hazır tarif.
- 233 besin için fotoğraf görseli; besin seçiminde ve tarif malzemelerinde kullanılır.
- Dokuz atmosferin manzaraları onaylanan çizimler referans alınarak üretildi.
- Kaynak PNG dosyaları değiştirilmeden saklanır ve Flutter içinde kaynak dikdörtgeniyle çizilir. Bir yemeğin fotoğrafı başka bir tarifin yerine sabitlenmez.
- Yeni / kullanıcı tarifinde kendi görseli varsa önceliklidir. Görseli olmayan yeni tarifte, tarifte gerçekten bulunan bir malzeme “Tarifindeki besin” açıklamasıyla gösterilir.
- Üretilen tarif fotoğrafları temsilidir; besin ve alerjen bilgisi fotoğraftan çıkarılmaz. Açıklama ilgili bilgi düğmesinde yer alır.
- Üretim kayıtları: `food-photo-provenance.json`, `ingredient-photo-provenance.json`, `scene-production-prompt.txt`.

## Kontroller

152 otomatik test: mevcut kayıt / tarif işlemleri, dokuz durumun seçimden itibaren kaydı ve tüm sekmelere yayılması, alerji filtresi, fotoğraf eşleştirmeleri, büyük yazı, hareket azaltma, bağımsız bilgi pencereleri, su kaydını geri alma, onboarding tema değişiminin yaşam döngüsü ve oturum/dokunma davranışları.

Flutter ekran çıktıları: `output/mood-experience/` ve `output/wellness-build/`. Bunlar çalışan Flutter widget'larından alınmıştır. Ekranlardaki örnek kayıtlar test verisidir.

Android debug APK derlemesi başarılı: `build/app/outputs/apk/debug/app-debug.apk`. Kod analizi temiz. Cihazda son uçtan uca kontrol, emülatör bağlantısı kesildiği için tamamlanamadı; akıcılık için gerçek cihaz performans ölçümü yapılmış sayılmaz.

Güncel hareket önizlemeleri `output/motion-refinement/ui-motion.mp4` ve `routine-motion.mp4`: gerçek Flutter ekran ve bileşenlerinden üretilir; telefon ekran kaydı değildir. Dokunma, sekmeler, tema geçişi, dört rutin ve duraklatma gösterilir. Üretim: `tool/render_ui_motion_test.dart` ve `tool/render_motion_preview_test.dart`, ardından kareleri 30 fps MP4'e kodlama.

8 Eylül doku, canlı renk, onboarding düzeltmesi ve kapsamlı hareket çalışması: [MOTION-REFINEMENT.md](MOTION-REFINEMENT.md).

iOS derlemesi ve fiziksel saat / yüzük eşleştirmesi bu görsel uygulama çalışmasında doğrulanmadı. Önceki sağlık bağlantısı kapsamı korunur; bu çalışma planlanan bütün wellness işlevlerinin ayrıca tamamlandığı anlamına gelmez.

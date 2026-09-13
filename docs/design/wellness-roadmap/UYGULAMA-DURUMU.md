# Wellness dönüşümü — ilk çalışan sürüm

7 Eylül 2026. Mevcut Flutter uygulaması dönüştürüldü. Bu teslim, 115 özellikli yol haritasının tamamı veya mağazaya hazır yayın değildir; sonraki modüllerin üzerine kurulacağı çalışan ürün çekirdeğidir.

## Kullanılabilir kapsam

| Alan | Uygulanan davranış |
|---|---|
| Tasarım | Gece mavisi, mint ve ay ışığı paleti; yerel fontlar; beş ana sekme; küçük ekran ve büyük yazı desteği |
| Bugün | İsteğe bağlı günlük ruh hali, enerji, uyku hissi, stres ve hazırlık zamanı; beslenme kartı; hedefler; su kaydı |
| Beslen | Mevcut tarif arşivi, alerji ve intolerans filtresi, malzemeye göre arama, mutfak uyumu, öğün saati ve düşük enerjide kısa hazırlığa öncelik |
| Rutinler | Nefes, farkındalık, yürüyüş ve esneme zamanlayıcıları; duraklatma; tamamlanma kaydı; kişisel alışkanlıklar |
| Uyku | Akşam kontrol listesi; tarih/saat ile manuel uyku kaydı; gece yarısını geçen uykular |
| Gelişim | Yedi günlük özbildirim geçmişi, uyku özeti, rutin sayıları, günlük kaydı inceleme/silme, mevcut beslenme istatistiklerine erişim |
| Profil | Hedefler, mevcut profil ve tercihler, ayrı laktoz intoleransı seçimi, bağlantılar, veri kullanımı ve wellness kayıtlarını silme |
| Sağlık bağlantısı | Android Health Connect ve iOS HealthKit için seçili alanlarda salt okuma; adım, uyku ve antrenman süreleri; elle yenileme; kaynak seçimi; bağlantıyı kaldırma |

Mevcut tarif defteri, kullanıcının tarifleri, mutfak, alışveriş, öğün planı ve içecek/tüketim akışları korunur. Eski günlük mod kapısı kaldırıldı; günlük durum paylaşmak uygulamaya girmek için zorunlu değil.

## Önerilerin kapsamı

- Alerji kontrolü tarif etiketleri ve bilinen malzemelerin alerjenlerini birlikte değerlendirir. Kısıtı olan kullanıcıda malzemesi doğrulanamayan tarif elenir; açık tarif de profil değişikliğinde tekrar kontrol edilir.
- Laktoz intoleransı süt alerjisinden ayrı saklanır. Arşiv laktoz miktarını belirtmediği için süt içeren tarifler intoleransta da muhafazakâr biçimde elenir.
- Eski `dairy` tercihi korunur; önceki sürümde süt/laktoz birleşik etiketini seçen kullanıcı kendi tercihini Profil ekranında gözden geçirmelidir.
- Arşivde hazırlık süreleri eksikti. 17 tarifin adımlarından yaklaşık toplam süre çıkarıldı; bekleme/soğutma süreleri dahildir. Ekranda açıkça tahmin olarak etiketlenir. Diğer tariflerin süresi bilinmiyor; zaman sınırı seçildiğinde bunlar gösterilmez. İçerik ekibinin bütün arşivi doğrulaması sonraki iştir.
- Bu sürüm katalog tariflerini seçer. Yeni üretken yapay zekâ tarif servisi, klinik öneri, eksiklik çıkarımı veya giyilebilir ölçümünden besin dozu hesaplama eklenmedi.
- Sağlık ölçümleri özetlerde kullanılır. HRV/uyku/aktiviteye dayalı daha ileri kişiselleştirme, veri yeterliliği ve değerlendirme kurallarıyla sonraki aşamaya aittir.

## Veri ve cihaz temeli

- Wellness kayıtları sürümlü AES-GCM şifreli yerel veri olarak saklanır; anahtar platformun güvenli deposundadır. Anahtar veya veri bozulursa sessiz sıfırlama yapılmaz.
- Mevcut profil, günlük mod, içecek, tüketim ve öğün planı kayıtları ilk açılışta şifreli depoya taşınır. Eski düz metin ancak şifreli yazma başarılı olunca temizlenir.
- Android yedekleme kapatıldı. Bulut hesabı, sunucuya sağlık yükleme, reklam SDK'sı veya marka OAuth bağlantısı eklenmedi.
- Kaynağı olmayan ölçüm sıfır sayılmaz. Uyku/antrenman için tek kaynak seçilir ve çakışan aralıklar birleştirilir. Adımlar sağlık merkezinin toplamından alınır. Uyku aşamalarını birleştirmede 90 dakikalık ara eşiği bir sezgisel kuraldır; cihaz verisiyle daha geniş doğrulama gerekir.
- Son haftanın kayıtları elle yeniden okunur; arka planda sürekli izleme yoktur. Saat/yüzük üreticisinin uygulaması veriyi Apple Health veya Health Connect'e aktarmış olmalıdır. Her marka/modelin her ölçümü aktaracağı varsayılmaz.
- Android bağlantıyı kaldırırken sistem iznini iptal etmeyi dener; iOS sistem izinleri Apple Health üzerinden yönetilir. Yerel bağlantı verilerini temizlemek sağlık merkezindeki asıl kayıtları silmez.
- Bu sürüm küçük günlük kayıtlar için şifreli sürümlü anlık görüntü kullanır. Wellness kayıtları için JSON önizleme ve panoya kopyalama eklendi. Tam yol haritasındaki SQL olay deposu, uzun geçmiş, artımlı eşitleme, kapsamlı dosya dışa aktarma ve bulut senkronizasyonu henüz uygulanmadı.

## Doğrulama

- `flutter test --no-pub`: **139 test geçti** (119 mevcut test + 20 yeni veri/arayüz testi).
- Yeni testler: şifreli yazma/okuma ve bozulma, eski kayıt taşıma, eşzamanlı güncelleme, kayıt hatası, gece yarısı ve kaynak çakışması, boş veri, 15 dakikalık filtre, isteğe bağlı durum kaydı, yarım kalan rutin ve büyük yazıda beş sekme.
- Android `assembleDebug`: başarılı. Android API 37 emülatörüne mevcut uygulamanın üzerine kurulum ve açılış doğrulandı. Geçici 15 dakikalık durum kaydı kaydedildi; süreç kapatılıp açılınca korunması ve önerinin değişmesi doğrulandı. Deneme kaydı sonrasında uygulamadan silindi.
- Statik analizde hata yok; eski ekranlarda 2 kullanılmayan kod uyarısı ve 20 stil/deprecation bildirimi bulunuyor.
- Gerçek Flutter ekran görüntüleri `output/wellness-build/01-today.png` ile `05-profile.png` arasındadır. Çizim maketi değildir; test ortamında uygulama widget'larından alınmıştır.
- iOS bu Windows ortamında derlenmedi. HealthKit yetkisi ve açıklamaları eklendi; Apple imzalama/provisioning ve gerçek cihaz denemesi gerekir.
- Gerçek saat/yüzük verisiyle uçtan uca doğrulama tamamlanmadı. Health Connect/HealthKit bağlantısı için fiziksel cihaz, kısmi izin, iptal, zaman dilimi ve farklı üretici kaynakları yayın öncesi doğrulanmalıdır.

## Sonraki geliştirme sırası

1. Fiziksel cihaz bağlantı testleri, iOS derlemesi ve eski profil tercihlerini gözden geçirme akışı.
2. Tarif arşivinin süre, alerjen ve besin verilerini editoryal doğrulama; besin/öğün önerilerinin açıklamalarını derinleştirme.
3. Kalıcı olay deposu, artımlı eşitleme, veri dışa aktarma ve seçilebilir saklama süreleri.
4. HRV, dinlenik nabız ve diğer izinli alanlar; ölçüm yeterliliğine göre kişisel eğilimler.
5. Programlar, içerik kütüphanesi, bildirim tercihleri ve yol haritasındaki ileri modüller.

## Geliştirici notu

Onaylı çizimlerin uygulamaya doğrudan aktarılması ikinci görsel teslimde tamamlandı. Sekiz ekran, orijinal görsel kaynakları, görselle eşleşen filtrelenebilir nohutlu bulgur tarifi, ay görünümü ve yatış saati seçimi için [uygulama eşleşmesi](../moonlit-theme/UYGULAMA-ESLESMESI.md) belgesine bakın.

Flutter 3.44.6 / Dart 3.12.2 ile doğrulandı. Android minimum API 26; iOS minimum 15. Bu Windows makinesinde Gradle'ın Unix domain socket geçici yol hatası, komut bazında `JAVA_TOOL_OPTIONS=-Djdk.net.unixdomain.tmpdir=C:\Trisenix\MobileApps\newapp\tmp` ve Microsoft JDK 21 kullanılarak aşıldı. Kullanıcının global Java/Flutter ayarları değiştirilmedi.

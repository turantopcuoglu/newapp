# NutriGuide uygulama logosu

Hilal günlük ritmi ve dinlenmeyi, içindeki yaprak beslenmeyi ve iyi oluşu anlatır. Şeftali/fildişi ışığı, lavanta gölgeleri ve erik moru saten zemin uygulamanın mevcut görsel dilinden alınmıştır. Menüde okunurluk için yazı ve küçük süsler kullanılmaz.

## Dosyalar

- `assets/branding/nutriguide-icon.png`: ImageGen ile üretilen asıl logo, 1254 × 1254 piksel; kaynak dosyanın birebir kopyası. Köşe maskesi içermez.
- `output/branding/launcher-preview.png`: gerçek Android kaynaklarından hazırlanmış yuvarlak, köşeli, tek renk ve küçük boyut önizlemesi. Cihaz ekran görüntüsü değildir.
- `flutter_launcher_icons.yaml`: Android ve iOS boyutlarını yeniden üretme ayarları.
- `android/app/src/main/res/drawable/ic_launcher_monochrome.xml`: logonun Android temalı simgeler için hazırlanan yerel vektör silüeti.
- `imagegen-prompts.json`: kullanılan yerleşik ImageGen modu, üretim istemleri ve kaynak kayıtları.
- `output/branding/validation.json`: boyut, opaklık ve paket kontrol sonuçları.

## Mobil uygulama bağlantısı

Android manifestindeki `android:icon` ve `android:roundIcon` aynı `@mipmap/ic_launcher` kaynağına bağlanır. Beş yoğunluk için normal PNG simgeleri, Android 8+ için adaptive XML ve Android 13+ için ayrı monochrome katmanı bulunur. Renkli simge, gölgesi ve dokusuyla birlikte üretilmiş saten görseli kullanır; yüzde 14 inset, kare görselin kenarlarını normal launcher maskesinin dışında tutar. Zemin `#2C2034` rengindedir. Bu sürümde amblem ve saten zemin tek renkli görsel katmanında birlikte hareket eder; birbirinden bağımsız parallax katmanları değildir.

ImageGen'in iki şeffaf çıktı denemesi gerçek alfa yerine dama deseni içeren RGB görseller döndürdü. Bu denemeler uygulamaya eklenmedi. Renkli simge için opak son çizim, tek renkli simge için arka plansız yerel vektör kullanıldı.

iOS AppIcon kataloğundaki iPhone, iPad ve 1024 piksel mağaza simgeleri güncellenmiştir. PNG'ler opaktır; köşeyi işletim sistemi şekillendirir. iOS derlemesi Windows üzerinde yapılmadı.

Uygulama adı `NutriGuide`, paket kimliği `com.example.ai_recipe_app` olarak kalır. Yeni simge native kaynak olduğundan hot reload yeterli değildir; uygulama yeniden derlenip kurulmalıdır. Bağlı telefon bulunmadığı için fiziksel cihaza yükleme yapılmadı.

## Yeniden üretme

```powershell
dart run flutter_launcher_icons
flutter test tool/render_launcher_preview_test.dart --no-pub
flutter build apk --debug --no-pub --target lib/main.dart
```

Android 13 kaynak dosyası elle tanımlanmış vektör katmanını korur. Logonun biçimi değişirse vektör de güncellenmelidir; inset değişirse YAML ve `mipmap-anydpi-v33/ic_launcher.xml` birlikte güncellenmelidir.

## Doğrulama

Simge önizlemesi görsel olarak incelendi; küçük boyutta hilal ve yaprak ayrımı korunuyor. Flutter analyzer hata vermedi ve Android debug APK derlemesi tamamlandı. Simge kaynakları ve uygulama adı APK içinde kontrol edildi. Bu değişiklik işlevsel ekran kodunu değiştirmediği için tüm uygulama testleri tekrar çalıştırılmadı.

Uygulama: [Android adaptive icon belgesi](https://developer.android.com/develop/ui/compose/system/icon_design_adaptive) ve [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons) yapılandırması esas alınmıştır.

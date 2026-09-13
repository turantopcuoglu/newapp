# NutriGuide - Gece mavisi

Uykuya hazırlık sahnesinden geliştirilen yeni tema ve sekiz temel ekran. Gece mavisi zemin, ay ışığı vurgusu, mint eylemler, sıcak yemek görselleri ve ortak ufuk geometrisi.

## Tasarım serisi

1. [Bugün ve günlük durum](screens/01-gunluk-rehber-v2.png)
2. [Besin seçimi ve tarif](screens/02-besin-ve-tarif.png)
3. [Nefes molası ve uyku](screens/03-nefes-ve-uyku.png)
4. [Gelişim ve profil](screens/04-gelisim-ve-profil.png)

## Geliştirme referansları

- [Tasarım sistemi](tasarim-sistemi.md): Renk, tipografi, yüzey, bileşen ve erişilebilirlik yaklaşımı.
- [Ekran ve hareket planı](ekran-ve-hareket-plani.md): Akışlar, animasyon davranışları, durumlar ve kabul ölçütleri.
- [Tema tokenları](theme-tokens.json): Flutter'a aktarılabilecek ölçü ve renk değerleri; düz yüzey kontrast hesapları.
- [Görsel üretim promptları](image-prompts.json): Yerleşik image_gen ile kullanılan girdiler.

Görseller örnek içerikle hazırlanmış tasarım referanslarıdır. 7 Eylül 2026'da sekiz temel ekran bu referanslarla yeniden uygulandı; orijinal panolar `assets/moonlit/` içine değiştirilmeden alındı. Ay, ufuk, yemek fotoğrafları ve nefes küresi doğrudan bu görsellerden kullanılır. [Uygulama eşleşmesi ve doğrulama](UYGULAMA-ESLESMESI.md) teslimin ayrıntılarını ve gerçek ekran görüntülerini listeler. Hareket planındaki tüm ileri animasyonlar bu teslimin kapsamında değildir. Eski tasarımlar korunmuştur. 01-gunluk-rehber-v1 ilk tipografi çalışmasıdır; v2 serinin nihai ana ekranıdır.

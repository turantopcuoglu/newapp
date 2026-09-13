# Referansa göre güncellenen uygulama

[Üç temanın karşılaştırması](reference-match.png)

[PMS](matched-pms.png) · [Regl krampları](matched-periodCramps.png) · [Regl yorgunluğu](matched-periodFatigue.png)

[Ayrıntılı fark analizi ve uygulama notları](../../docs/design/reference-material/ANALYSIS.md)

Ekranlar çalışan Flutter uygulamasından, aynı örnek tarifle üretildi. Telefon alanı 390 × 844 ve üst güvenli alanı 24 piksel. Fotoğraf sıralaması için kullanılan örnek veri gerçek kullanıcı kaydı değildir. Kartların ölçüm sınırları `bounds-*.json` dosyalarındadır.

`before-*.png` dosyaları önceki sürümün ekranlarıdır. Yeni kartlarda düzenli çizgiler kaldırıldı; referansa göre saten mikro doku, yönlü ışık, ince kenar, iç yansıma ve dış gölge uygulandı. Yeni sahne ve yemek varlıkları uygulamanın içindedir.

152 test geçti, kod analizi temiz; normal uygulama giriş noktasıyla Android APK derlendi. Cihaz performansı ölçülmedi.

# Wellness konsepti - geliştirme notları

Bu klasör 7 Eylül 2026 tarihli araştırma ve tasarım teslimidir; uygulama değişikliği içermez.

## Nihai görseller

- screens/01-gunluk-rehber.png: Bugün + günlük durum kaydı.
- screens/02-besin-ve-tarif.png: Besin seçimi + tarif.
- screens/03-nefes-ve-uyku-v2.png: Nefes molası + uyku rutini. v2 nihai sürümdür.
- screens/04-gelisim-ve-profil.png: Haftalık görünüm + profil.

Görseller yerleşik image_gen ile üretildi. Ana promptlar image-prompts.json içindedir. Son revizyonda yalnız nefes alt akışındaki menü kaldırıldı ve başlamamış uyku kontrol listesinin daireleri boşaltıldı; diğer öğeler korundu.

Referans: 390 x 844 mantıksal piksel, 20 yan boşluk, 16 kart içi boşluk, 20 kart yarıçapı, 52 buton yüksekliği, en az 48 x 48 dokunma alanı. Metin 28/16/12-14 ölçeği. Ana renkler #1B2838, #FF6B35, #FAF7F2. Tüm ekranlarda aynı ikon seti kullanılmalı; AI taslağındaki küçük ikon varyasyonları geliştirme şartı değildir.

Ana gezinme: Bugün, Beslen, Rutinler, Gelişim, Profil. Tarif ve nefes gibi odaklı alt akışlarda geri tuşu. Metin büyütmede içerik kaydırılır; ekran yüksekliğine sıkıştırılmaz. Nefes animasyonunda azaltılmış hareket ve ses olmadan kullanım desteklenir.

Durum kaydı dört isteğe bağlı alanla başlar: ruh hali, enerji, uyku, öğün süresi. İlk görselde seçili olanlar Dengeli / Düşük / Orta / 15 dk. Hazır nohut ve pişmiş bulgur 15 dakikalık örnek tarifin önkoşuludur. Domates kartındaki Ekle, alışverişe ekleme olarak açıklanmalı; seçimden çıkarma ile karıştırılmamalı.

Haftalık örnek kayıtlar: Pzt düşük, Sal orta, Çar eksik, Per orta, Cum yüksek, Cmt eksik, Paz orta. 5/7 gün; beş nokta, çizgiyle doldurulmuş eksik gün yok. Örnek sayılar ürün performansı veya gerçek kullanıcı verisi değildir.

Filtre değişiminde açık tarif yeniden kontrol edilir. Hatalı veya eksik malzeme verisinde uygunluk iddiası üretilmez. Tüm adaylar elenirse kullanıcıya sebep ve uygun alternatif yolu gösterilir; alerjen filtresi gevşetilmez. Profil belirtmeyen kişiye filtre açıkmış gibi rozet yazılmaz.

Manuel kayıt ile cihaz ölçümü kaynağı ayrı tutulur. İzin yok/veri yok, sıfır ölçüm değildir. Pişirmeye başla yalnız adımları açar; Pişirdim tüketimi kaydeder. Rutin başlatmak tamamlanma kaydı oluşturmaz. Üretim devreye girene kadar tarif bul/seçildi dili kullanılır.

Ana teslim: output/pdf/NutriGuide-Wellness-Stratejisi.pdf. Canonical report-source.md'den build_report.py ile oluşturulur. Araştırma kayıtları claim-source-ledger.json ve research-ledger.json içindedir.

# Kodla eşleşen 9 durum ve genişletilmiş tema tasarımı

8 Eylül 2026. Tasarım revizyonu; uygulama kodu değiştirilmedi. Beğenilen `immersive-moods` görsel dili korunur, üç örnek görünümün yerine mevcut durum kataloğunun tamamı tasarımda temsil edilir.

## 1. Kodda bulunan gerçek liste

`CheckInType` içinde **9 değer** var. Türkçe adlar `lib/l10n/translations/tr.dart` dosyasından doğrulandı.

| Kimlik — korunacak | Mevcut Türkçe etiket | Görünür grup | Tam uygulama teması |
|---|---|---|---|
| `lowEnergy` | Düşük Enerji | Günlük | Kadife akşam: sıcak mürdüm, mat gül kurusu, şampanya |
| `bloated` | Şişkinlik | Günlük | Adaçayı: açık adaçayı zemini, okaliptüs kartlar, koyu orman yazıları |
| `cravingSweets` | Tatlı İsteği | Günlük | Kakao: koyu kakao zemini, karamel ve krem |
| `cantFocus` | Odaklanamıyorum | Günlük | Mürekkep: mat lacivert/indigo, buzlu lavanta, az doku |
| `postWorkout` | Egzersiz Sonrası | Günlük | Mineral: koyu petrol, mineral yüzeyler, buzlu mint |
| `noSpecificIssue` | Belirli Bir Sorun Yok | Günlük | Durgun su: beğenilen petrol/yeşim ve inci görünümü |
| `pms` | PMS / Adet Öncesi | Regl dönemi | Gül akşamı: mat gül kurusu, şampanya gül, yumuşak kıvrımlar |
| `periodCramps` | Regl Krampları | Regl dönemi | Sıcak kil: terrakota, kil yüzeyler, açık kayısı ve amber ışık |
| `periodFatigue` | Regl Yorgunluğu | Regl dönemi | Gece leylak: dumanlı leylak, saten yüzeyler, inci ışık |

Önceki çizimlerdeki **Yorgunum**, `lowEnergy` durumunun görsel anlatımıydı. **Sakinim** ve **Enerjik**, eski `CheckInType` listesinde yok. Bunlar önceki tasarımda yeni örnek görünüm/enerji ifadeleriydi; mevcut dokuz durumun yerine geçirilmemeli.

Beğenilen sakin görünüm, Belirli Bir Sorun Yok için varsayılan atmosfer olabilir; bu eşleştirme kişinin sakin olduğunu kaydetmez. Kayısı şafağı görünümü Görünüm seçeneklerinde korunur. Kullanıcı onu seçebilir; eski enum'a sahte onuncu bir tıbbi/bedensel durum eklenmez. Yüksek enerji kaydı da kendi alanında durur.

## 2. Seçenekler kaybolmadı, geri planda kaldı

- Eski `ModeSelectionScreen` altı günlük seçeneği ve üç regl seçeneğini ayrı listeliyordu. Regl grubu `profile.isFemale` koşuluyla gösteriliyordu.
- Güncel `WellnessCheckInScreen`, dokuz değerin tamamını **Başka bir durum ekle** açılır alanında gösteriyor. Bu ekranda söz konusu cinsiyet filtresi yok. Dolayısıyla kullanıcı eski seçenekleri hatırlıyor ama artık ana akışta kolay göremiyor.
- Güncel ruh hali, enerji, uyku hissi, stres ve hazırlık zamanı alanları bunlardan ayrı. Ruh hali: Zorlanıyorum / Dengeli / İyi; enerji: Düşük / Orta / Yüksek; uyku: Zayıf / Orta / İyi; stres: Az / Orta / Yoğun. Bunları tek bir 9 seçenekli ölçeğe sıkıştırmıyoruz.
- `HealthCondition` içindeki PCOS, insülin direnci ve diğer kayıtlar profil bağlamıdır; günlük mod listesine karıştırılmamalı.

Kaynaklar: [enum](../../../lib/core/enums.dart), [Türkçe etiketler](../../../lib/l10n/translations/tr.dart), [eski seçim ekranı](../../../lib/screens/mode_selection_screen.dart), [güncel günlük durum ekranı](../../../lib/screens/wellness/check_in_screen.dart).

## 3. Yeni seçim ekranı

Başlık **Bugün nasılsın?**; açıklama yalnızca **Bugün öne çıkan durumu seç.** İki belirgin sekme: **Günlük** ve **Regl dönemi**.

Günlük sekmesinde altı büyük kart 2 × 3 düzeninde görünür. Regl dönemi sekmesinde üç geniş dikdörtgen kart vardır. Her kart büyük bir simge, mevcut durum adı ve ayrı bir i düğmesi içerir. Kart kendi atmosferini küçük bir önizleme olarak gösterir; ana sayfa henüz seçilmemiş durumda nötr marka görünümünü kullanır. Tek dokunuş ana durumu seçer, temayı tüm uygulamaya uygular ve Bugün ekranını açar.

“Şimdilik atla” ayrı ve görünür kalır. Atlamak `noSpecificIssue` kaydı oluşturmaz. “Belirli Bir Sorun Yok” ise kullanıcının açık seçimidir; bu iki sonuç birbirinden ayrılır.

Regl alanı kişinin isteğiyle açılır ve isterse gizlenebilir; erişim cinsiyet alanından otomatik türetilmez. Üç regl durumu tek bir “regl modu” içine birleştirilmez. Hassas seçimler bildirim/uygulama dışı önizlemelerde açık etiketle otomatik yayımlanmaz.

## 4. Aynı anda birden fazla durum

İlk seçim tek ve hızlıdır. Ana ekrandaki **Başka durum ekle** ile birden fazla bağlam eklenebilir. Bu, mevcut kodda tamamlanmış bir özellik değil; önerilen geliştirme işidir.

Örnek: ana durum **Regl Krampları**, ek durum **Düşük Enerji**. Tam görünüm Sıcak kil olur; ek düşük enerji bilgisi kısa hazırlık/az adım gibi içerik tercihlerini etkileyebilir. Ek durumu seçmek ana durumu silmez. Daha sonra kullanıcı istediğini ana durum yapabilir.

Kurallar:

1. Temayı kullanıcının seçtiği **ana durum** belirler. Sistem en ağır semptomu tahmin edip kendi sırasını dayatmaz.
2. Ek durumlar üst üste renk karıştırmaz; dokuz paletten rastgele ara renkler türetilmez.
3. **Görünümü sabitle** yalnız görünümü sabitler, durum kaydını engellemez. Birinin regl krampları varken kakao görünümünü tercih etmesi mümkündür.
4. Belirli Bir Sorun Yok diğer özel durumlarla aynı anda seçilemez. Belirli bir durum seçildiğinde bu seçenek kalkar. Tersi yönde mevcut özel seçimler görünür biçimde temizlenir; geçmiş kayıtlar silinmez.
5. Düşük enerji ile regl yorgunluğu ayrı etiketler olarak korunur; öneri puanında aynı yorgunluk katkısı iki kez sayılmaz. PMS ile regl durumları da üst üste keyfî besin puanı üretmez.
6. Bugünün durumu kaldırıldığında eski `dailyModeProvider` veya `checkInProvider` değeri arka planda kalmamalı. Tema, günlük kayıt ve öneri kaynağı aynı durumu göstermeli.

## 5. Her durumda yaratıcı küçük dokunuş

| Durum | Görsel / etkileşim fikri | Öneri akışına ürün etkisi |
|---|---|---|
| Düşük Enerji | Kadife ufuk, yumuşak şampanya nefes halkası, kısa karşılama | Kullanıcının süre ve mutfak bilgisine göre az hazırlık isteyen tarifler; oturumlar isteğe bağlı |
| Şişkinlik | Açık adaçayı, geniş yuvarlak kıvrımlar, boşluklu görünüm | Kişisel tercih ve bilinen hassasiyetleri gözden geçirme; yalnız bu seçimden alerji veya yasak besin çıkarılmaz |
| Tatlı İsteği | Mat kakao, sade kurabiye simgesi, karamel düğmeler | Kullanıcının isteğine uygun tarif seçenekleri; yargılayıcı dil, kırmızı ikaz veya otomatik kalori kısıtı yok |
| Odaklanamıyorum | Mat indigo, sabit ufuk çizgisi, dekoratif hareket kapalı | Tek belirgin başlangıç ve kısa farkındalık seçeneği; yeni odak zamanlayıcısı hazırmış gibi sunulmaz |
| Egzersiz Sonrası | Mineral yüzey, temiz su halkası, buzlu mint | Kayıtlı antrenmanı ve kullanıcının açlık/tercih bağlamını inceleme; otomatik yeniden egzersiz başlatma veya eksiklik çıkarımı yok |
| Belirli Bir Sorun Yok | Durgun su, dengeli yeşim | Özel durum bonusu olmadan tercihler, zaman, mutfak ve çeşitlilik |
| PMS / Adet Öncesi | Gül kurusu ufuk, yumuşak takvim/kalp simgesi | Açıkça seçilen gün bağlamı; otomatik döngü tahmini veya yaklaşan regl bildirimi değildir |
| Regl Krampları | Sıcak kil, yuvarlak ışık kıvrımları, sakin geri bildirim | İsteğe bağlı mola ve kullanıcıya uygun beslenme seçenekleri; yemekle ağrı giderme vaadi yok |
| Regl Yorgunluğu | Dumanlı leylak, inci ay, düşük dekoratif hareket | Efor/süreye duyarlı seçimler; “demirin eksik” veya otomatik takviye önerisi çıkarılmaz |

Renkler estetik tercih önerileridir, semptomları tedavi ettikleri ileri sürülmez. Bu revizyon yeni sağlık tedavisi veya yeni wellness modülü eklemez.

## 6. Görünümün bütünlüğü

Önceki beğenilen tasarımın kuralı sürer: zemin, kart dolgusu, yazı, ikon, form, alt menü, modal, grafik ve dekoratif varlık birlikte değişir. Sadece seçili ikonun rengi değişmez. Dokuz renk eşleştirmesi `context-themes.json` dosyasında tutulur.

Kart yerleri, ikonların anlamı, kısa etiketler ve gezinme düzeni ortaktır. Bu sayede dokuz durum dokuz ayrı öğrenme gerektirmez. Büyük yazıda kartlar genişler/tek sütuna geçer; uzun “Belirli Bir Sorun Yok” etiketi kesilmez. Hareket azaltma etkinse dekoratif hareket kapalıdır.

Çizimlerdeki yemek fotoğrafı Beslenme alanına giriş için örnek görseldir; her durumda aynı yemeğin önerileceği anlamına gelmez. Gerçek öneride içerik ve fotoğraf seçilen tarifle eşleşir; alerjen bilgisi görünürdür. Fotoğrafın doğal rengi tüm ekrana uygulanan filtreyle bozulmaz.

## 7. Kodda ayrıca bulunan bağlantı sorunu

`RecommendationService.getRecommendations` eski check-in etiketlerini puanlamada kullanıyor. Regl krampları/yorgunluğu için PMS etiketini de eşleşmeye katıyor. Ancak yeni ana ekranın `wellnessRecipesProvider` kaynağı `safeScoredRecipesProvider`; o da `getAllSafeRecipes` ile ağırlıkla mutfak uyumunu puanlıyor. Wellness sıralaması `focus` durumunu doğrudan kullanmıyor; ayrıca görseldeki kaseye sabit öncelik veriyor.

Dolayısıyla “durum seçildi ve kaydedildi” demek, yeni ana ekrandaki önerinin o duruma göre kişiselleştiği anlamına gelmiyor. Onaydan sonraki geliştirmede bu kopukluk giderilmeli. Ana durum, ek bağlamlar, süre ve efor tek bir açıklanabilir öneri girdisine dönüşmeli. Sabit fotoğraf tarifinin önceliği kaldırılmalı; zorunlu alerji/intolerans/diyet elemesi korunmalı.

Eski `health_tips_data.dart` dosyasında regl ve diğer durumlarla ilgili genelleyici beslenme açıklamaları da var. Yeni i pencerelerine bu metinler içerik incelemesi yapılmadan taşınmamalı. Bir tarifte durum etiketi olması, o tarifin semptomu tedavi ettiğinin kanıtı sayılmaz.

Kaynaklar: [eski öneri servisi](../../../lib/services/recommendation_service.dart), [tarif provider'ları](../../../lib/providers/recipe_provider.dart), [wellness sıralaması](../../../lib/providers/wellness_provider.dart), [günlük mod eşitlemesi](../../../lib/providers/daily_mode_provider.dart).

## 8. Onay sonrasında uygulanacak işler

1. Dokuz enum kimliğini koruyan yeni seçim arayüzü; kısa etiket ve ayrı bilgi düğmesi.
2. Dokuz durumun uygulama genelinde tema eşleştirmesi; önceki Kayısı şafağı dahil kullanıcı görünüm seçenekleri.
3. Günlük durum için ana/ek bağlam modeli; mevcut tek `focus` değerinin kayıpsız ana duruma taşınması. Yeni alanlar için sürümlü kayıt; eski metin değerleri yeniden adlandırılmaz.
4. Ruh hali, enerji, uyku hissi ve stresi ayrı tutma; regl veya egzersiz seçimini bu alanlara otomatik kopyalamama.
5. Tek kaynak üzerinden öneri motoru, günlük kayıt ve görünüm eşitlemesi; boşaltma/atlama/gün değişimi davranışları. Mevcut uygulama gün sınırı 06.00 ile tutarlılık.
6. Gerekçeleri gerçek girdilerden üretme; özel durum seçimi, tarif elemesi ve kullanıcı alternatiflerinin tutarlılığını doğrulama.
7. Dokuz durum × temel ekranlar; iki dil; büyük yazı; tema sabitleme; eski kayıt taşıma; birden fazla durum; veri yok ve kaydetme hatası senaryolarını kontrol etme.

Bu teslim yalnızca kod incelemesi, tasarım eşleştirmesi ve çizim üretimidir. Uygulama derlenmedi, testler tekrar çalıştırılmadı, ürün kodu değiştirilmedi.

## Çizimler

- `01-durum-secimi.png`: altı günlük ve üç regl seçeneği.
- `02-gunluk-temalar.png`: Düşük Enerji, Şişkinlik, Tatlı İsteği.
- `03-odak-hareket-denge.png`: Odaklanamıyorum, Egzersiz Sonrası, Belirli Bir Sorun Yok.
- `04-regl-temalari.png`: PMS / Adet Öncesi, Regl Krampları, Regl Yorgunluğu.

Yerleşik imagegen ile üretilmiş tasarım önerileri; gerçek uygulama ekran görüntüsü değildir. Promptlar ve doğrulama notları bu klasörde bulunur.

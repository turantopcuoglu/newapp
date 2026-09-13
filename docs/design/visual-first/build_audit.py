"""Reproducible documentation audit; does not modify application code."""
import json
from collections import Counter
from pathlib import Path

root = Path(__file__).resolve().parents[3]
out = Path(__file__).resolve().parent
catalog = json.loads((root / 'docs/design/wellness-roadmap/features.json').read_text(encoding='utf-8'))
evidence = {}
def record(ids, status, note, files):
    for key in ids.split():
        evidence[key] = (status, note, files.split())

record('KIS-01', 'Çekirdek var', 'Tarihli ruh hali, enerji, stres; kayıt isteğe bağlı.', 'lib/models/wellness.dart lib/screens/wellness/check_in_screen.dart')
record('KIS-02', 'Kısmi', 'Uyku hissi var; açlık/tokluk yeni wellness kaydında yok.', 'lib/models/wellness.dart')
record('KIS-03', 'Kısmi', 'Hedefler, alışkanlıklar ve hazırlık zamanı var; bütçe profili yok.', 'lib/models/wellness.dart lib/models/user_profile.dart')
record('KIS-04', 'Kısmi', 'Günlük yemek ve sabit iki rutin sunuluyor; birleşik sabah/gün/akşam planı yok.', 'lib/screens/wellness/today_screen.dart')
record('KIS-05', 'Kısmi', 'Gerekçe metni ve alternatif var; tüm önerilerin bağlam/provenans açıklaması yok.', 'lib/screens/wellness/nourish_screen.dart lib/providers/wellness_provider.dart')
record('BES-01 TAR-01', 'Kısmi', 'Alerji, tercih, süre, öğün ve mutfak temeli var. Referans kasesinin sıralamada sabit önceliği kişiselleştirmeyi zayıflatıyor.', 'lib/providers/wellness_provider.dart lib/providers/recipe_provider.dart')
record('BES-02', 'Çekirdek var', 'Ayrı alerji, laktoz intoleransı ve diyet filtresi; belirsiz malzeme eleme. Katalog doğrulaması ayrıca sürmeli.', 'lib/services/recommendation_service.dart lib/services/preference_matcher.dart lib/data/allergens.dart')
record('BES-03', 'Çekirdek var', 'Porsiyonlu tüketim kaydı; plan ve tüketim ayrı, açık pişirme eylemi gerekiyor.', 'lib/providers/cooked_provider.dart lib/screens/wellness/moonlit_recipe_screen.dart')
record('BES-04', 'Kısmi', 'Eski beslenme ekranında kayıtlı öğünlerden enerji/makro hesapları var; wellness ana akışına entegre tercihli modül değil.', 'lib/screens/nutrition/nutrition_stats_screen.dart lib/services/nutrition_calculator.dart')
record('BES-05', 'Kısmi', 'Lif hesabı var; haftalık besin grubu/çeşitlilik deneyimi yok.', 'lib/providers/cooked_provider.dart lib/services/nutrition_calculator.dart')
record('TAR-02', 'Kısmi', 'Malzemeyi dışlayan güvenli başka tarif seçiliyor; aynı tarifte miktarlı malzeme ikamesi değil.', 'lib/screens/wellness/nourish_screen.dart')
record('TAR-03', 'Kısmi', 'Öğün planlayıcı var; kapsamlı ön hazırlık planı yok.', 'lib/screens/planner/planner_screen.dart lib/providers/meal_plan_provider.dart')
record('TAR-04', 'Kısmi', 'Mutfak envanteri var; son kullanım tarihi ve hatırlatması yok.', 'lib/providers/inventory_provider.dart lib/screens/shopping/shopping_screen.dart')
record('TAR-05', 'Kısmi', 'Birleşik alışveriş listesi var; fiyat/bütçe hesabı yok.', 'lib/providers/shopping_provider.dart lib/screens/shopping/shopping_screen.dart')
record('ICE-01', 'Çekirdek var', 'Manuel su ve içecek miktarı/tarih kaydı; otomatik cihazdan içecek aktarımı yok.', 'lib/providers/beverage_provider.dart lib/screens/beverages/beverages_screen.dart')
record('ICE-03', 'Kısmi', 'Kahve/çay türü, miktarı ve tüketim zamanı var; mg cinsinden kafein hesabı yok.', 'lib/models/beverage_entry.dart lib/providers/beverage_provider.dart')
record('UYK-01', 'Kısmi', 'Manuel oturum var; cihaz okuma kodu mevcut fakat fiziksel cihaz doğrulaması tamamlanmadı.', 'lib/screens/wellness/routines_screen.dart lib/services/health_connection_service.dart')
record('UYK-02', 'Kısmi', 'Uyku süre özeti var; yatış/kalkış düzeni eğilimi tamamlanmış değil.', 'lib/screens/wellness/progress_screen.dart')
record('UYK-03', 'Kısmi', 'Uyku evreleri okunup toplam süreye birleştiriliyor; evre, bölünme ve kestirme arayüzü yok.', 'lib/services/health_connection_service.dart lib/models/wellness.dart')
record('UYK-04', 'Çekirdek var', 'Üç maddelik akşam kontrolü, yatış saati ve nefes oturumuna geçiş.', 'lib/screens/wellness/routines_screen.dart')
record('HAR-01', 'Bağlantı altyapısı', 'Adım ve antrenman süresi okuma var; fiziksel kaynak/doğrulama ve kapsamlı geçmiş eksik.', 'lib/services/health_connection_service.dart lib/screens/wellness/health_connections_screen.dart')
record('HAR-02 HAR-03 HAR-05', 'Kısmi', 'Kısa yürüyüş ve tek esneme zamanlayıcısı/metni var; mola sıklığı, filtreli kütüphane ve uyarlama motoru yok.', 'lib/screens/wellness/routines_screen.dart')
record('ZIH-01 ZIH-02', 'Kısmi', 'Birer kısa metinli nefes/farkındalık oturumu var; uzman incelemeli sesli içerik kütüphanesi yok.', 'lib/screens/wellness/routines_screen.dart')
record('ALI-01', 'Çekirdek var', 'Kişisel alışkanlık ekle, işaretle, sil; tarihli yerel kayıt.', 'lib/screens/wellness/routines_screen.dart lib/providers/wellness_provider.dart')
record('ALI-05', 'Kısmi', 'Akşam ekran molası işaretlemesi var; ekran süresi erişimi ve inceleme aracı yok.', 'lib/screens/wellness/routines_screen.dart')
record('VUC-01', 'Kısmi', 'Profilde tek kilo/boy değeri var; tarihli vücut ölçüsü günlüğü yok.', 'lib/models/user_profile.dart lib/screens/settings_screen.dart')
record('CIH-01 CIH-02 CIH-04 CIH-05', 'Bağlantı altyapısı', 'Seçili alanlarda salt okuma, kaynak/izin/yenileme ve tekrar ayıklama kodu var. iOS derlenmedi; gerçek saat/yüzükle uçtan uca doğrulanmadı.', 'lib/services/health_connection_service.dart lib/screens/wellness/health_connections_screen.dart lib/models/wellness.dart')
record('GEL-01', 'Çekirdek var', 'Hafta/ay enerji grafiği, eksik günler ve gerçek tüketim/rutin sayıları.', 'lib/screens/wellness/progress_screen.dart')
record('GEL-02', 'Kısmi', 'Geçmiş nokta grafiği var; yeterli veri eşiğiyle kişisel baz çizgisi/ileri eğilim motoru yok.', 'lib/screens/wellness/progress_screen.dart')
record('GEL-06', 'Kısmi', 'Wellness JSON önizleme/kopyalama var; seçilebilir CSV/PDF raporu yok.', 'lib/screens/wellness/profile_screen.dart')
record('PRG-02', 'Kısmi', 'Tarif arama/favoriler var; wellness içeriklerinde amaç/süre/zorluk kataloğu yok.', 'lib/screens/recipe_book/recipe_book_screen.dart lib/providers/favorites_provider.dart lib/screens/wellness/routines_screen.dart')
record('PRG-03', 'Kısmi', 'Paketlenmiş kısa rutin metinleri çevrimdışı çalışır; ses içeriği, indirme/lisans yönetimi yok.', 'lib/screens/wellness/routines_screen.dart')
record('PRG-05', 'Yok', 'Eski HomeScreen için ipucu metinleri kaynakta duruyor; yeni wellness akışında eğitim modülü ve editoryal inceleme süreci yok.', 'lib/data/health_tips_data.dart lib/screens/home/home_screen.dart lib/screens/main_shell.dart')
record('KON-01', 'Kısmi', 'Hedef seçimi var; modül gizleme ve ana ekran kart düzenleme yok.', 'lib/screens/wellness/today_screen.dart lib/models/wellness.dart')
record('KON-02', 'Kısmi', 'Sağlık alanı izinleri var; kapsamlı cihaz/bulut/AI amaç merkezi yok; bulut/AI servisi henüz eklenmedi.', 'lib/screens/wellness/health_connections_screen.dart')
record('KON-03', 'Kısmi', 'Günlük kaydı düzenleme/silme ve wellness silme var; bulut hesabı ve hesap kapatma bulunmuyor.', 'lib/screens/wellness/profile_screen.dart lib/screens/wellness/progress_screen.dart')
record('KON-04', 'Kısmi', 'Şifreli depo ve güvenli anahtar var; isteğe bağlı biyometrik uygulama kilidi yok.', 'lib/services/private_storage.dart lib/services/wellness_store.dart')
record('KON-05', 'Kısmi', 'Büyük yazı testleri, semantik ve azaltılmış hareket desteği var; tam ekran okuyucu/cihaz denetimi yapılmadı.', 'test/wellness_ui_test.dart lib/screens/wellness/wellness_ui.dart')
record('KON-06', 'Kısmi', 'Yerel günlük durum/akşam yemeği hatırlatması var; tam sessiz saat, sınır ve gizlilik merkezi yok.', 'lib/services/notification_service.dart lib/screens/settings_screen.dart')
record('KON-07', 'Kısmi', 'Türkçe/İngilizce ve yerel saat kullanımı var; kullanıcı seçilebilir bütün birim/saat dilimi tercihleri yok.', 'lib/providers/locale_provider.dart lib/core/day_boundary.dart')
record('KON-08', 'Çekirdek var', 'Cihaz ve bulut hesabı olmadan temel manuel kullanım.', 'lib/main.dart lib/services/wellness_store.dart')

rows = []
for f in catalog:
    status, note, files = evidence.get(f['id'], ('Yok', 'Bu katalog işlevine karşılık gelen ürün akışı/veri modeli mevcut kodda bulunmadı.', []))
    for name in files:
        assert (root / name).is_file(), name
    rows.append({**f, 'status': status, 'auditNote': note, 'evidenceFiles': files})
counts = Counter(r['status'] for r in rows)
assert len(rows) == 115
(out / 'feature-audit.json').write_text(json.dumps({'date':'2026-09-08', 'method':'Static code review; no new device validation', 'counts':dict(counts), 'features':rows}, ensure_ascii=False, indent=2), encoding='utf-8')
lines = ['# 115 özellik: mevcut kod ile eşleştirme', '', '8 Eylül 2026. Statik kod incelemesi; bu belge yeni cihaz sertifikasyonu veya yeni test koşusu değildir. Orijinal features.json bir plan dosyasıdır; planned değerleri teslim durumunu göstermiyordu. Uygulama kodu bu inceleme sırasında değiştirilmedi.', '', '**Çekirdek var:** temel manuel akış uygulanmış. **Kısmi:** katalog maddesinin bazı alt koşulları var. **Bağlantı altyapısı:** kod var, fiziksel cihaz/iOS doğrulaması eksik. **Yok:** ilgili ürün işlevi uygulanmamış. Hiçbiri mağaza yayınına hazır sertifikası anlamına gelmez.', '', ' | '.join(f'{k}: {v}' for k,v in counts.items()), '', 'Bir özellik birkaç alt iş içerdiği için bu sayılardan ürünün yüzde tamamlanma oranı çıkarılmamalıdır.', '']
for area in dict.fromkeys(f['area'] for f in rows):
    lines += ['## '+area, '', '| Kimlik | Özellik | Durum | Kanıt / eksik |','|---|---|---|---|']
    for r in rows:
        if r['area'] != area: continue
        links = ', '.join(f'[{Path(p).name}](../../../{p})' for p in r['evidenceFiles'])
        lines.append(f"| {r['id']} | {r['feature']} | {r['status']} | {r['auditNote']} {links} |")
    lines.append('')
(out / 'OZELLIK-DURUMU.md').write_text('\n'.join(lines)+'\n', encoding='utf-8')
print(json.dumps(dict(counts),ensure_ascii=False))

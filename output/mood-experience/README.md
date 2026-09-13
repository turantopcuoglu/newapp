# Uygulanan tasarım

Bu klasördeki ekranlar çalışan Flutter arayüzünden alınmıştır. Ekran kayıtları örnek test verisi kullanır.

Güncel referans eşleştirmesi: [üç tema yan yana](../reference-material/reference-match.png). Aşağıdaki eski hareket videoları son saten doku ve sahne güncellemesinden önceki sürümü gösterir.

## Dokuz atmosfer

| Durum | Uygulama ekranı |
| --- | --- |
| Düşük enerji | [Bugün](home-lowEnergy.png) |
| Şişkinlik | [Bugün](home-bloated.png) |
| Tatlı isteği | [Bugün](home-cravingSweets.png) |
| Odaklanma | [Bugün](home-cantFocus.png) |
| PMS | [Bugün](home-pms.png) |
| Regl ağrısı | [Bugün](home-periodCramps.png) |
| Regl yorgunluğu | [Bugün](home-periodFatigue.png) |
| Egzersiz sonrası | [Bugün](home-postWorkout.png) |
| Dengede | [Bugün](home-noSpecificIssue.png) |

## Sekmeler ve erişilebilirlik

[Keşfet](lowEnergy-0.png) · [Plan](lowEnergy-1.png) · [Gelişim](lowEnergy-2.png) · [Profil](lowEnergy-3.png)

[Açık temada Keşfet](bloated-0.png) · [Büyük yazıda regl durumları](picker-large-period.png)

## Hareket önizlemesi

[Arayüz geçişleri ve dokunma](../motion-refinement/ui-motion.mp4) · [15 saniyelik rutin animasyonları](../motion-refinement/routine-motion.mp4)

Video, uygulamanın gerçek `RoutineVisual` bileşenlerini aynı anda gösteren bir Flutter önizlemesidir; telefon ekran kaydı değildir. Nefes, meditasyon, yürüyüş ve esneme hareketlerini, tema geçişini ve duraklamayı gösterir. Yeniden üretim dosyası: `tool/render_motion_preview_test.dart`.

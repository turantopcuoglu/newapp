# Tasarım görseli üretim kaydı

Yöntem: yerleşik image_gen aracı. CLI veya ayrı API anahtarı kullanılmadı.

Çıktı: `tasarim-onerisi.png`. Üç ekranlı hedef deneyim; uygulama ekran görüntüsü değildir.

## Kullanılan son prompt

```text
Use case: ui-mockup
Asset type: high-fidelity mobile product design concept board for an existing Turkish Flutter recipe app, NutriGuide. This is a proposed future design for review, not a screenshot of implemented software.
Primary request: Make personalization the entire foundation: today's mood / bodily state -> ingredients chosen with dietary preferences and allergen exclusions -> a personalized recipe. Deliver a beautifully art-directed but entirely implementable three-screen mobile UI design. Flat front-facing screens with perfectly readable Turkish typography and a coherent visual hierarchy, no perspective device renders.
Composition: landscape board approximately 1800x1200 or similar, three equally sized 390x844 logical mobile screens side by side, generous cream margins. Slim rounded phone outlines. Each screen large enough to read. At top outside screens a small eyebrow "NUTRIGUIDE / TASARIM ÖNERİSİ" and headline "Bugün sana göre pişirelim." At bottom outside screens a discreet note "Hedef deneyim • Örnek içerik • Tarif üretimi ikinci aşama". Small column labels above phones "01 / BUGÜN", "02 / BESİNLER", "03 / TARİF".
Style: premium warm editorial food app, friendly contemporary mobile product, restrained warm ivory background #FAF7F2, deep navy #1B2838 typography, vibrant existing brand orange #FF6B35 for dominant actions, soft pale apricot for mood panel, sage green only for selected ingredients and factual profile status. Neutral clean sans-serif UI typography, large 28px headings, comfortable 16px body, 12px secondary text minimum at phone scale. Subtle 1px borders, 20px card radii, 52px buttons. Real appetizing editorial food photos only inside ingredient and dish cards. No purple gradients, no excessive shadows, no dashboard charts. Use elegant consistent outline icons, not random emojis. The personalization module must visually outweigh any food photography on first screen.
SCREEN 1 home:
Status bar 9:41. Small NutriGuide wordmark at upper left, round "E" profile at right. Greeting "Merhaba, Ece".
Large 2-line headline "Bugün sana göre\npişirelim."
Dominant pale apricot panel title "Bugün nasıl hissediyorsun?" followed by a tidy 2x2 grid of four selectable pill tiles labeled "Enerjim düşük", "Tatlı istiyorum", "Egzersiz sonrası", "İyiyim". Select "Egzersiz sonrası" with orange border and checkmark. Under tiles text link "Tüm durumlar →".
Below panel a compact bordered profile strip with small sliders icon, label "Beslenme profilin", two small chips "Süt ürünü yok" and "Yemiş filtresi", an edit chevron.
Full width orange primary CTA "Bana özel tarif hazırla →".
Below a section title "Bugünkü eşleşmen" and one compact horizontal card with small photo of quinoa black bean avocado bowl and text "Kinoa ve siyah\nfasulye kasesi" and secondary text "Seçtiğin modla eşleşiyor".
Bottom navigation 5 destinations "Bugün" active orange, "Mutfağım", "Keşfet", "Defterim", "Profil", consistently drawn outline icons.
SCREEN 2 ingredient selection:
Status bar, back arrow, centered small title "Sana özel tarif". Progress text "1 Mod  →  2 Besinler  →  3 Tarif" with middle stage emphasized orange.
Heading "Tabağının temeli,\nsana göre."
Subtitle "Egzersiz sonrası seçimine göre."
Compact profile chip row "Süt ürünü yok" and "Yemiş filtresi".
Three clean stacked ingredient rows. Each has small high-quality photo of ingredient in bowl, label and small secondary:
"Kinoa" / "Tariflerde eşleşiyor"
"Siyah fasulye" / "Mutfağında var"
"Avokado" / "Alışveriş gerekiyor"
Each selected with sage check in circle, with small "Değiştir" affordance where space allows. These are selected featured ingredients, not full ingredient list.
Below rows small label "Diğer malzemeler tarifte gösterilir."
A light grey inline note "Sevmediklerin seçimlere dahil edilmez."
Pinned footer summary "3 besin seçildi". Full width orange CTA "Bu besinlerle tarif oluştur →". No bottom app navigation on this focused subflow.
SCREEN 3 recipe result:
Status bar, back arrow, small title "Sana özel tarif", bookmark icon.
Small orange eyebrow "TARİF TASLAĞIN"
Heading "Kinoa ve siyah\nfasulye kasesi"
A beautiful rectangular overhead food photo, quinoa black beans avocado tomato corn on a white ceramic bowl, approx 160 logical px high. No nuts, cheese, meat or sauces containing dairy.
Below photo small secondary "Seçtiğin besinlerle hazırlandı".
Prominent cream bordered explanation card heading "Neden sana göre?" with 3 fact rows using small appropriate icons:
"Egzersiz sonrası seçiminle eşleşti"
"Süt ürünleri kullanılmadı"
"Sevmediğin besinler dışarıda"
Below a pale sage factual inventory strip "Mutfağındaki malzemeleri kullan".
Below a small compact accordion row "Malzemeler ve adımlar  ˅".
Pinned full width orange CTA "Bu tarifi pişir →" then secondary text link "Başka bir öneri".
Constraints: legible Turkish text with correct diacritics, usable real app proportions and generous whitespace, no overlapping text, all buttons fully inside viewport. No personal compatibility percentages, no calorie values, no fabricated medical benefit claims, no claims of absolute allergy safety. No AI chat window. This is a buildable user flow, not a decorative poster. Maintain identical design language across all three screens.
```

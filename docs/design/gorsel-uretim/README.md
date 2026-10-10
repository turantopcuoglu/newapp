# Görsel üretim rehberi (GPT ile)

> **Kimin için:** Turan (görselleri ChatGPT'de üretir) ve sonraki Claude
> oturumları (teslim edilen görselleri uygulamaya bağlar).
> Son güncelleme: 2026-10-03.

Uygulamanın dokusu üç görsel aileden oluşuyor ve yeni her görsel bunlardan
birine **birebir** uymalı. Aşağıdaki prompt'lar bu yüzden uzun: renk, ışık,
malzeme ve kadraj her seferinde aynı tarif ediliyor. Kısaltmayın.

---

## 1. Nasıl kullanılır (adım adım)

1. ChatGPT'de **yeni bir sohbet** aç. Önce aşağıdaki **"Seri başlangıç
   mesajı"**nı gönder (bir kez).
2. Her görsel için: o görselin **Referans** satırındaki dosyaları sohbete
   ekle, sonra **Prompt** bloğunu olduğu gibi yapıştır. Bir mesajda **tek
   görsel** iste. Izgara/kolaj isteme: GPT ızgaraları eşit bölemiyor, uygulama
   ise hücreleri piksel hesabıyla kesiyor.
3. Boyutu prompt'ta yazdığı gibi seç (kare 1024×1024, yatay 1536×1024).
4. Sonucu **Kabul listesi**yle kontrol et. Uymuyorsa "aynı görsel, ama …"
   diye düzelt veya yeniden üret.
5. Bir serinin ilk iyi görselini, aynı serinin sonraki görsellerine **ek
   referans** olarak ver. Tutarlılığı en çok bu artırır.
6. Görseli tablodaki **dosya adıyla** şu klasöre koy:
   `docs/design/gorsel-uretim/teslim/`
   (PNG kalabilir. Küçültme ve uygulamaya bağlama Claude'un işi.
   Bu klasördeki PNG'ler git'e girmez — yalnız yerel diskte durur; repoya
   `assets/images/` altındaki küçültülmüş kopyalar gider.)
7. Claude'a "teslim klasörüne görsel koydum" demen yeterli.

### Seri başlangıç mesajı (ChatGPT'ye bir kez gönder)

```
I am producing a consistent image series for a premium wellness and nutrition
mobile app called NutriGuide. I will attach reference images from the app;
every new image must look like it belongs to the same set: same lighting,
materials, colour temperature, camera angle and level of realism.
Rules for every image in this conversation:
- Absolutely no text, letters, numbers, logos, labels, watermarks, UI
  elements, frames or borders anywhere in the image.
- No people, faces, hands or body parts. No animals.
- No pills, capsules, supplements, syringes, medical devices or anything
  clinical.
- One single image per request, never a grid or collage.
- Keep the main subject inside the central area; the app crops the edges.
Reply only with the image.
```

### Kabul listesi (her görselde kontrol et)

- [ ] Hiç yazı, harf, logo, etiket yok (paket üstünde bile).
- [ ] İnsan, el, hayvan yok. Hap, takviye, tıbbi nesne yok.
- [ ] Referansla aynı aile: ışık yönü, zemin dokusu, kap malzemesi, renk.
- [ ] Ana nesne ortada; kenarlardan %15 kesilse bile anlam kaybolmuyor.
- [ ] Yemekte yalnızca prompt'ta yazan malzemeler var (uygulama kuralı:
      görsel tarifi yalan söylememeli).
- [ ] Çerçeve, kenar boşluğu, vinyet dışında koyu kenar yok.

---

## 2. Görsel aileleri (referans)

| Aile | Mevcut örnek (referans olarak ekle) | Nerede |
|---|---|---|
| **A · Yemek natürmortu** | `assets/food/recipes-0.png`, `assets/food/recipes-3.png` | Tarif fotoğrafları, kapaklar |
| **B · Malzeme** | `assets/food/ingredients-0.png`, `assets/food/ingredients-3.png` | Malzeme kartları, mutfak |
| **C · Ay ışığında kum tepeleri** | `assets/moods/landscapes.png`, `assets/moonlit/daily.png` | Ekran başlıkları, mod kartları |
| **D · Saten üstünde nesne** | `assets/materials/satin-neutral.png` + bir A örneği | Boş durumlar |

Atlaslar 4×4 (tarif) ve 6×6 (malzeme) ızgara; referans verirken GPT'ye
"tek bir hücrenin stilini taklit et" demek yeterli, ızgarayı taklit
etmesin.

### Uygulamanın renkleri (C ve D ailesi için)

Varsayılan tema "Düşük Enerji" (erik/şampanya). Diğer 8 mod kendi paletini
kullanır; başlık görselleri moda göre değişir.

| Mod | Zemin | Yüzey | Vurgu | Manzara karakteri |
|---|---|---|---|---|
| Düşük Enerji | #211625 | #39283F | #FBD7B5 | Erik moru tepeler, bal rengi hilal |
| Şişkinlik (açık tema) | #EDF3E4 | #D2E4BC | #226A44 | Açık adaçayı tepeler, durgun su, soluk disk |
| Tatlı İsteği | #29170F | #4C2B1C | #F0BA69 | Kakao tepeler, krem hilal |
| Odaklanamıyorum | #101A35 | #233565 | #AEC4FF | Mürekkep laciverdi, soğuk dolunay |
| PMS | #281921 | #532D3A | #FFD4C5 | Gül kurusu alacakaranlık, sıcak disk |
| Regl Krampları | #29170F | #5B3022 | #FFD7A0 | Pişmiş toprak/kil, kehribar disk |
| Regl Yorgunluğu | #211D30 | #39304C | #E5D0FF | Dumanlı leylak gece, inci hilal |
| Egzersiz Sonrası | #082F38 | #145564 | #89E0E1 | Mineral petrol, buz nanesi disk |
| İyiyim (eski adı: Belirli Bir Sorun Yok) | #093336 | #185348 | #9FE0BC | Sakin yeşim, durgun su, inci disk |

---

## 3. Öncelik ve durum tablosu

İşaretle: **Ü** = üretildi ve teslim klasöründe, **U** = uygulamaya bağlandı.

| # | Dosya adı | Boyut | Aile | Öncelik | Ü | U |
|---|---|---|---|---|---|---|
| K1 | `cuisine_turkish.png` | 1024² | A | P1 | [x] | [x] |
| K2 | `cuisine_italian.png` | 1024² | A | P1 | [x] | [x] |
| K3 | `cuisine_asian.png` | 1024² | A | P1 | [x] | [x] |
| K4 | `cuisine_middleEastern.png` | 1024² | A | P1 | [x] | [x] |
| K5 | `cuisine_mediterranean.png` | 1024² | A | P1 | [x] | [x] |
| K6 | `cuisine_american.png` | 1024² | A | P1 | [x] | [x] |
| K7 | `cuisine_mexican.png` | 1024² | A | P1 | [x] | [x] |
| K8 | `cuisine_international.png` | 1024² | A | P1 | [x] | [x] |
| S1 | `health_pcos.png` | 1024² | A | P1 | [x] | [x] |
| S2 | `health_insulinResistance.png` | 1024² | A | P1 | [x] | [x] |
| S3 | `health_ironDeficiency.png` | 1024² | A | P1 | [x] | [x] |
| S4 | `health_vitaminB12.png` | 1024² | A | P1 | [x] | [x] |
| S5 | `health_magnesiumDeficiency.png` | 1024² | A | P1 | [x] | [x] |
| S6 | `health_anemia.png` | 1024² | A | P1 | [x] | [x] |
| S7 | `health_glutenFree.png` | 1024² | A | P1 | [x] | [x] |
| S8 | `health_lactoseFree.png` | 1024² | A | P1 | [x] | [x] |
| S9 | `health_periodSupport.png` | 1024² | A | P1 | [x] | [x] |
| O1 | `onboarding_welcome.png` | 1536×1024 | C | P2 | [x] | [x] |
| O2 | `onboarding_health.png` | 1536×1024 | C | P2 | [x] | [x] |
| O3 | `onboarding_safety.png` | 1536×1024 | C | P2 | [x] | [x] |
| B1 | `empty_meals.png` | 1024² | D | P2 | [x] | [x] |
| B2 | `empty_progress.png` | 1024² | D | P2 | [x] | [x] |
| B3 | `empty_shopping.png` | 1024² | D | P2 | [x] | [x] |
| B4 | `empty_recipe_book.png` | 1024² | D | P2 | [x] | [x] |
| B5 | `empty_no_results.png` | 1024² | D | P2 | [x] | [x] |
| F1 | `evening_closeout.png` | 1536×1024 | C | P3 (faz 3) | [x] | [x] |
| F2 | `weekly_insight.png` | 1536×1024 | C | P3 (faz 3) | [x] | [x] |
| M1 | `mood_stress.png` | 1536×1024 | C | P4 (faz 4) | [x] | [x] |
| M2 | `mood_anxious.png` | 1536×1024 | C | P4 (faz 4) | [x] | [x] |
| M3 | `mood_poorSleep.png` | 1536×1024 | C | P4 (faz 4) | [x] | [x] |
| M4 | `mood_good.png` | 1536×1024 | C | P4 (faz 4) | [x] | — |

> **2026-10-07 üretim notu:** Yerleşik imagegen ile 27 eksik görsel üretildi;
> önceden bulunan K1, S1, O1 ve B1 korundu. Teslim klasöründe toplam 31 PNG var.
> Araç, 1024×1024 istenen kareleri 1254×1254; yatayları 1536×1024 verdi.
> Kare kaynaklar yüksek çözünürlükte korundu. Üretim kaydı: `uretim-kaydi.json`.
> Ü işaretleri dosyaların teslim edildiğini belirtir; uygulama entegrasyonu değildir.
>
> **2026-10-08 entegrasyon:** K, S, O, B satırları uygulamaya bağlandı
> (Codex başlattı, Claude denetleyip tamamladı). Kapaklar 1080 px, yataylar
> 1200 px JPEG; Mac'te `sips -s format jpeg -s formatOptions 65 -Z 1080`
> ile küçültüldü (toplam ~6 MB). F1–F2 faz 3 ile `assets/images/scenes/`'e
> alındı (`SceneBanner`). M1–M3 faz 4'te yeni modlarla bağlandı
> (`MoodLandscape`, `assets/images/scenes/mood_*.jpg`). M4 kullanılmadı:
> "İyiyim", mevcut "Belirli Bir Sorun Yok" kartıyla birleştirildi (adı
> değişti, yeşim paleti ve atlas manzarası korundu).

**Neden bu sıra:**
- **P1:** Keşfet ve sağlık alanları hâlâ eski tasarımda: parlak camgöbeği,
  kırmızı ve yeşil gradyanlar, emojiler. Uygulamadaki en büyük görsel
  kopukluk bu. Sağlık alanları da eşinin katkı vereceği bölüm.
- **P2:** İlk izlenim (kayıt akışı) ve boş ekranlar.
- **P3/P4:** Henüz yazılmamış özellikler içindir. M1–M4 ancak yeni mod
  seçenekleri için tarifler etiketlendiğinde gerekir; erken üretmenin
  zararı yok ama acelesi de yok.

**Görsel gerekmeyen, kodla düzeltilecek eksikler** (ROADMAP'te de var):
- Tarif Defterim kartları fotoğraf yerine ikon gösteriyor. Fotoğraflar
  zaten var; kartlar `RecipeVisual` kullanmalı.
- Mutfağım/alışveriş satırlarında malzeme fotoğrafı yok. `IngredientPhoto`
  hazır, bağlanmalı.

---

## 4. Prompt'lar

### Ortak kadraj notu (A ailesi kapakları)

Kapaklar uygulamada iki yerde kesilir: kare kart (iki sütunlu ızgara,
başlık sol altta) ve geniş başlık (yaklaşık 2:1). Bu yüzden ana tabak
**ortada, yatay orta bandın içinde** durur; **sol alt köşe** sade keten
kalır (başlık oraya yazılır).

---

#### K1 · `cuisine_turkish.png` — Türk Mutfağı
**Referans:** `assets/food/recipes-0.png`, `assets/food/recipes-5.png`
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "Turkish home cooking".
Subject: a matte cream stoneware bowl of smooth red lentil soup with a thin
swirl of paprika-infused butter and a few dried mint flakes on top, a lemon
wedge resting on the rim; behind it and slightly to the right, partly out of
frame, a small seasoned black cast-iron pan of menemen (soft scrambled eggs
with chopped tomatoes and green peppers). A torn piece of crusty village
bread on the linen.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field, the soup bowl perfectly sharp.
Surface: warm greige linen tablecloth with a visible fine weave.
Vessels: handmade matte stoneware in cream/oatmeal with fine dark speckles,
slightly irregular rims.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows falling to the lower right, no harsh highlights.
Colour: true-to-life, appetising, not oversaturated.
Composition: main bowl centred in the middle horizontal band; keep the
bottom-left quarter calm, plain linen for overlaid text.
Strictly no text, letters, logos, labels, hands, people, cutlery brands,
watermarks, frames or borders. Match the lighting and materials of the
attached reference images exactly.
```

#### K2 · `cuisine_italian.png` — İtalyan Mutfağı
**Referans:** `assets/food/recipes-0.png` + K1 (onaylandıysa)
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "Italian".
Subject: a shallow matte cream speckled stoneware bowl of spaghetti in a
fresh tomato and basil sauce, a few shavings of parmesan and two fresh basil
leaves on top; beside it a tiny stoneware dish of golden olive oil and a
small wedge of parmesan on the linen.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field, the pasta perfectly sharp.
Surface: warm greige linen tablecloth with a visible fine weave.
Vessels: handmade matte stoneware in cream/oatmeal with fine dark speckles.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Composition: main bowl centred in the middle horizontal band; bottom-left
quarter calm, plain linen.
Strictly no text, letters, logos, labels, hands, people, watermarks, frames
or borders. Match the attached references exactly.
```

#### K3 · `cuisine_asian.png` — Asya Mutfağı
**Referans:** `assets/food/recipes-0.png` + K1
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "Asian".
Subject: a deep matte cream speckled stoneware bowl of jasmine rice topped
with a colourful vegetable and tofu stir-fry (broccoli, red bell pepper,
snap peas, golden tofu cubes), sprinkled with sesame seeds and sliced spring
onion; a pair of plain unbranded wooden chopsticks resting across the rim;
a small dish of edamame beside it.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Composition: main bowl centred in the middle horizontal band; bottom-left
quarter calm, plain linen.
Strictly no text, letters, logos, labels, hands, people, watermarks, frames
or borders. Match the attached references exactly.
```

#### K4 · `cuisine_middleEastern.png` — Ortadoğu Mutfağı
**Referans:** `assets/food/recipes-0.png` + K1
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "Middle Eastern".
Subject: a wide matte cream speckled stoneware plate of silky hummus with a
pool of olive oil in the centre, a dusting of paprika, a few whole chickpeas
and chopped parsley; three warm pita wedges leaning on the plate edge; a
small scattering of pomegranate seeds on the linen.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Composition: plate centred in the middle horizontal band; bottom-left
quarter calm, plain linen.
Strictly no text, letters, logos, labels, hands, people, watermarks, frames
or borders. Match the attached references exactly.
```

#### K5 · `cuisine_mediterranean.png` — Akdeniz Mutfağı
**Referans:** `assets/food/recipes-0.png` + K1
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "Mediterranean".
Subject: a grilled sea bream fillet with crisp skin on a matte cream
speckled stoneware plate, with a lemon half and a sprig of fresh thyme;
beside it a small stoneware bowl of tomato, cucumber and red onion salad
with a few black olives and a cube of feta.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Composition: fish plate centred in the middle horizontal band; bottom-left
quarter calm, plain linen.
Strictly no text, letters, logos, labels, hands, people, watermarks, frames
or borders. Match the attached references exactly.
```

#### K6 · `cuisine_american.png` — Amerikan Mutfağı
**Referans:** `assets/food/recipes-0.png` (pankek hücresi) + K1
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "American breakfast and diner classics, done lighter".
Subject: a stack of three fluffy whole-grain pancakes on a matte cream
speckled stoneware plate, topped with fresh blueberries and a thin drizzle
of maple syrup running down the side; a small stoneware dish of thick plain
yoghurt beside it.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Composition: pancake stack centred in the middle horizontal band;
bottom-left quarter calm, plain linen.
Strictly no text, letters, logos, labels, hands, people, watermarks, frames
or borders. Match the attached references exactly.
```

#### K7 · `cuisine_mexican.png` — Meksika Mutfağı
**Referans:** `assets/food/recipes-0.png` + K1
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "Mexican".
Subject: three soft corn tortilla tacos lined up on a matte cream speckled
stoneware plate, filled with black beans, avocado slices, fresh pico de
gallo (diced tomato, onion, coriander); two lime wedges on the plate; a
small stoneware bowl of guacamole beside it.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Composition: taco plate centred in the middle horizontal band; bottom-left
quarter calm, plain linen.
Strictly no text, letters, logos, labels, hands, people, watermarks, frames
or borders. Match the attached references exactly.
```

#### K8 · `cuisine_international.png` — Dünya & Füzyon
**Referans:** `assets/food/recipes-0.png` + K1
```
Square 1024x1024 photorealistic editorial food photograph for a recipe app
category cover, "International and fusion bowls".
Subject: a wide matte cream speckled stoneware bowl arranged in neat
sections: fluffy quinoa, roasted sweet potato cubes, chickpeas, sliced
avocado, baby spinach and shredded red cabbage, finished with a thin
drizzle of tahini dressing and a few sesame seeds.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Composition: bowl centred in the middle horizontal band; bottom-left
quarter calm, plain linen.
Strictly no text, letters, logos, labels, hands, people, watermarks, frames
or borders. Match the attached references exactly.
```

---

### Sağlık alanı kapakları (S1–S9)

Ortak yaklaşım: **hazır yemek değil, malzemeler**. Birkaç küçük taş seramik
kâse ve doğrudan keten üstüne konmuş bütün malzemeler. Malzemeler
`lib/data/health_category_info.dart` içindeki listelerden seçildi; eşin
farklı malzeme isterse prompt'taki listeyi değiştirmek yeterli.
Tıbbi çağrışım yok: hap, kapsül, ölçü kabı, stetoskop, beden çizimi yok.
**Çiğ kırmızı et ve ciğer kapakta kullanılmaz** (iştah kapatır); demir için
bitkisel kaynaklar seçildi.

Hepsinde ortak kadraj: kompozisyon gevşek bir yay şeklinde, ortada; sol alt
çeyrek sade keten.

#### S1 · `health_pcos.png` — PCOS Dostu
**Referans:** `assets/food/ingredients-3.png`, `assets/food/recipes-0.png`
```
Square 1024x1024 photorealistic editorial still life of whole, uncooked
ingredients for a nutrition app health-area cover.
Ingredients, each in its own small matte cream speckled stoneware dish or
placed directly on the linen: rolled oats, white quinoa, buckwheat groats, a
halved ripe avocado, a small pile of walnuts, two brown eggs, a few broccoli
florets.
Arrangement: a loose, natural arc across the centre of the frame, dishes at
slightly different distances, generous breathing room, nothing touching the
edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, fresh, not oversaturated.
Keep the bottom-left quarter calm, plain linen for overlaid text.
Strictly no text, letters, labels, packaging, pills, capsules, supplements,
medical objects, hands, people, watermarks, frames or borders.
```

#### S2 · `health_insulinResistance.png` — İnsülin Direnci
**Referans:** S1 (onaylandıysa) + `assets/food/ingredients-3.png`
```
Square 1024x1024 photorealistic editorial still life of whole, uncooked
ingredients for a nutrition app health-area cover.
Ingredients in small matte cream speckled stoneware dishes or directly on
the linen: coarse bulgur, rolled oats, dried chickpeas, green lentils, a
small head of broccoli, a handful of walnuts, a tiny stoneware jug of olive
oil.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, fresh, not oversaturated.
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, pills, capsules, supplements,
medical objects, hands, people, watermarks, frames or borders. Match the
attached reference exactly.
```

#### S3 · `health_ironDeficiency.png` — Demir
**Referans:** S1 + `assets/food/ingredients-3.png`
```
Square 1024x1024 photorealistic editorial still life of whole, uncooked
ingredients for a nutrition app health-area cover about iron-rich foods.
Ingredients in small matte cream speckled stoneware dishes or directly on
the linen: red lentils, green lentils, a bunch of fresh spinach leaves,
pumpkin seeds, dried apricots, a few dates, and two lemon halves (vitamin C
partner).
No raw red meat or liver in this image.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, fresh, not oversaturated.
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, pills, capsules, supplements,
medical objects, hands, people, watermarks, frames or borders. Match the
attached reference exactly.
```

#### S4 · `health_vitaminB12.png` — B12
**Referans:** S1 + `assets/food/ingredients-0.png`
```
Square 1024x1024 photorealistic editorial still life of fresh ingredients
for a nutrition app health-area cover about vitamin B12 sources.
Ingredients in small matte cream speckled stoneware dishes or directly on
the linen: a fresh salmon fillet portion, three brown eggs, a bowl of thick
plain yoghurt, a block of white feta cheese, a small glass jug of milk.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, fresh, not oversaturated.
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, pills, capsules, supplements,
medical objects, hands, people, watermarks, frames or borders. Match the
attached reference exactly.
```

#### S5 · `health_magnesiumDeficiency.png` — Magnezyum
**Referans:** S1 + `assets/food/ingredients-3.png`
```
Square 1024x1024 photorealistic editorial still life of whole ingredients
for a nutrition app health-area cover about magnesium-rich foods.
Ingredients in small matte cream speckled stoneware dishes or directly on
the linen: pumpkin seeds, whole almonds, a few squares of dark chocolate,
fresh spinach leaves, a ripe banana, a small dish of tahini with a spoon
resting in it, black beans.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, fresh, not oversaturated.
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, pills, capsules, supplements,
medical objects, hands, people, watermarks, frames or borders. Match the
attached reference exactly.
```

#### S6 · `health_anemia.png` — Kansızlık
**Referans:** S3 (onaylandıysa) + S1
```
Square 1024x1024 photorealistic editorial still life of whole ingredients
for a nutrition app health-area cover about pairing iron sources with
vitamin C.
Ingredients in small matte cream speckled stoneware dishes or directly on
the linen: green lentils, chickpeas, fresh spinach, a split pomegranate with
visible seeds, a halved orange, a bunch of flat-leaf parsley, a few dried
apricots.
No raw red meat or liver in this image.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges. Slightly warmer, richer reds than S3 but
the same lighting and surface.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, pills, capsules, supplements,
medical objects, hands, people, watermarks, frames or borders. Match the
attached references exactly.
```

#### S7 · `health_glutenFree.png` — Glutensiz
**Referans:** S1 + `assets/food/ingredients-3.png`
```
Square 1024x1024 photorealistic editorial still life of whole, uncooked
ingredients for a nutrition app cover about naturally gluten-free staples.
Ingredients in small matte cream speckled stoneware dishes or directly on
the linen: white basmati rice, brown rice, buckwheat groats, white quinoa,
a fresh corn cob with the husk pulled back, two small potatoes, a dish of
coarse cornmeal.
No bread, pasta, wheat ears or flour bags.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, fresh, not oversaturated.
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, hands, people, watermarks,
frames or borders. Match the attached reference exactly.
```

#### S8 · `health_lactoseFree.png` — Laktozsuz
**Referans:** S1 + `assets/food/ingredients-3.png`
```
Square 1024x1024 photorealistic editorial still life of whole ingredients
for a nutrition app cover about dairy-free calcium sources.
Ingredients in small matte cream speckled stoneware dishes or directly on
the linen: a dish of tahini, white and black sesame seeds, whole almonds, a
small clear glass of almond milk, chickpeas, a few kale leaves, a small
head of broccoli.
No cow's milk, cheese, yoghurt or butter in this image.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, fresh, not oversaturated.
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, hands, people, watermarks,
frames or borders. Match the attached reference exactly.
```

#### S9 · `health_periodSupport.png` — Regl Dönemi
**Referans:** S5 + S3 (onaylandıysa)
```
Square 1024x1024 photorealistic editorial still life for a nutrition app
cover about gentle eating during the menstrual period.
Ingredients and items in small matte cream speckled stoneware dishes or
directly on the linen: a few squares of dark chocolate, pumpkin seeds, a
ripe banana, fresh spinach leaves, red lentils, a knob of fresh ginger, and
a stoneware cup of steaming ginger tea with a lemon slice.
Mood: cosy and warm, slightly lower-key lighting than the other covers, but
the same surface, vessels and light direction.
No pink props, no flowers, no hot-water bottles, no body imagery.
Arrangement: a loose, natural arc across the centre, generous breathing
room, nothing touching the edges.
Camera: about 35 degrees above the table, 50mm look, gentle shallow depth of
field.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4000K).
Keep the bottom-left quarter calm, plain linen.
Strictly no text, letters, labels, packaging, pills, capsules, supplements,
medical objects, hands, people, watermarks, frames or borders. Match the
attached references exactly.
```

---

### Kayıt akışı üst görselleri (O1–O3)

Uygulamada ekranın üst kısmında, yaklaşık 2:1 oranında kesilerek kullanılır.
Üstte ve solda başlık yazısı olacak: **sol yarının üst üçte ikisi sakin
gökyüzü** kalmalı, gök cismi sağ üst çeyrekte.
Palet: varsayılan tema "Düşük Enerji" (zemin #211625, yüzey #39283F, vurgu
#FBD7B5).

#### O1 · `onboarding_welcome.png` — Hoş geldin
**Referans:** `assets/moods/landscapes.png` (sol üst hücre), `assets/moonlit/daily.png`
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised, for
the welcome screen of a calm wellness app.
Scene: layered rolling sand dunes with a very fine satin ripple texture,
soft sculpted folds receding to a low horizon; a dusk-to-night sky in deep
plum (#211625 at the top fading to #39283F near the horizon) with a faint
scattering of tiny stars; a thin honey-gold crescent moon (#FBD7B5) low in
the upper-right quarter, casting a narrow warm rim light along the nearest
dune crests. A soft peach glow sits on the horizon just below the moon.
On the crest of the nearest dune, lower right, a single small matte cream
speckled stoneware bowl rests, catching the moonlight: the only object in
the scene, small and quiet.
Composition: the upper two thirds of the left half is calm empty sky for a
headline; dunes occupy the lower 45% of the image.
Atmosphere: quiet, premium, meditative, gentle contrast.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders. Match the colour, dune texture and lighting of the
attached references exactly.
```

#### O2 · `onboarding_health.png` — Sağlık durumu adımı
**Referans:** `assets/moods/landscapes.png` (sol üst ve sağ alt hücreler), O1
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised, same
world as the attached welcome image.
Scene: the same plum dune landscape with satin ripples, but the foreground
opens onto a perfectly still, shallow pool of water between two dunes,
reflecting a soft, round, pale-gold moon disc (#FBD7B5) that sits low in
the upper-right quarter. The reflection forms a gentle vertical band of
light on the water. Sky deep plum (#211625 to #39283F) with very few tiny
stars.
Feeling: balance and calm attention, nothing clinical.
Composition: upper two thirds of the left half is calm empty sky; dunes and
water occupy the lower 45%.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders. Match the attached references exactly.
```

#### O3 · `onboarding_safety.png` — Alerji adımı
**Referans:** O1 + O2
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised, same
world as the attached images.
Scene: the plum dune landscape with satin ripples; two large dunes in the
foreground curve towards each other and form a sheltered, softly lit hollow
in the lower centre, like a calm cove. A thin crescent moon (#FBD7B5) in the
upper-right quarter; its warm light gathers gently inside the hollow, which
glows faintly. Sky deep plum (#211625 to #39283F), faint stars.
Feeling: protected, safe, cared for. No shield shapes, icons or symbols.
Composition: upper two thirds of the left half is calm empty sky; dunes
occupy the lower 45%.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders. Match the attached references exactly.
```

---

### Boş durum görselleri (B1–B5)

Uygulamada koyu kartların içinde, ortada ~160 px boyunda gösterilir.
Kenarlar karta karışmalı: **kenarlara doğru neredeyse siyaha (#1A1420)
kararan vinyet**. Nesne küçük ve yalnız; sahne sakin.

#### B1 · `empty_meals.png` — "Bugün henüz öğün yok"
**Referans:** `assets/materials/satin-neutral.png`, `assets/food/recipes-0.png`
```
Square 1024x1024 photoreal minimal still life for an app empty state.
A single empty matte cream speckled stoneware bowl with a small wooden spoon
resting inside, sitting on softly folded deep plum satin fabric (#2A1D30 to
#3B2A41). Soft warm moonlight-like glow from the upper right (#FBD7B5
highlight on the bowl rim), gentle shadow to the lower left.
The edges of the frame fall off into a near-black vignette (#1A1420) so the
image melts into a dark app card.
The bowl sits slightly below centre and occupies about 40% of the frame
width. Shallow depth of field, calm, quiet, premium.
Strictly no food, text, letters, logos, people, hands, frames or borders.
```

#### B2 · `empty_progress.png` — "İlk kaydınla hikâyen başlasın"
**Referans:** B1 (onaylandıysa)
```
Square 1024x1024 photoreal minimal still life for an app empty state, same
set as the attached image.
A tiny fresh green seedling with two round leaves growing from soil in a
small matte cream speckled stoneware cup, on softly folded deep plum satin
(#2A1D30 to #3B2A41). Soft warm moonlight-like glow from the upper right
(#FBD7B5) catching the leaf edges.
Edges fall off into a near-black vignette (#1A1420).
The cup sits slightly below centre, about 35% of the frame width. Shallow
depth of field, calm, hopeful, quiet.
Strictly no text, letters, logos, people, hands, frames or borders.
```

#### B3 · `empty_shopping.png` — "Alışveriş listen boş"
**Referans:** B1
```
Square 1024x1024 photoreal minimal still life for an app empty state, same
set as the attached image.
A small empty hand-woven natural rattan basket with a single fresh lemon
resting beside it, on softly folded deep plum satin (#2A1D30 to #3B2A41).
Soft warm moonlight-like glow from the upper right (#FBD7B5).
Edges fall off into a near-black vignette (#1A1420).
Basket slightly below centre, about 45% of the frame width. Shallow depth of
field, calm, quiet.
Strictly no text, letters, logos, labels, people, hands, frames or borders.
```

#### B4 · `empty_recipe_book.png` — "Henüz kayıtlı tarifin yok"
**Referans:** B1
```
Square 1024x1024 photoreal minimal still life for an app empty state, same
set as the attached image.
A closed, linen-bound notebook in warm oatmeal colour with a blank cover (no
title, no letters), a small sprig of fresh thyme laid diagonally across it,
on softly folded deep plum satin (#2A1D30 to #3B2A41). Soft warm
moonlight-like glow from the upper right (#FBD7B5).
Edges fall off into a near-black vignette (#1A1420).
Notebook slightly below centre, about 45% of the frame width, angled about
15 degrees. Shallow depth of field, calm, quiet.
Strictly no text, letters, logos, people, hands, frames or borders.
```

#### B5 · `empty_no_results.png` — "Eşleşen tarif bulunamadı"
**Referans:** B1
```
Square 1024x1024 photoreal minimal still life for an app empty state, same
set as the attached image.
An empty matte cream speckled stoneware plate with a neatly folded oatmeal
linen napkin and a plain unbranded fork beside it, on softly folded deep
plum satin (#2A1D30 to #3B2A41). Soft warm moonlight-like glow from the
upper right (#FBD7B5).
Edges fall off into a near-black vignette (#1A1420).
Plate slightly below centre, about 45% of the frame width. Shallow depth of
field, calm, gently inviting rather than sad.
Strictly no food, text, letters, logos, people, hands, frames or borders.
```

---

### Faz 3 görselleri (F1–F2)

#### F1 · `evening_closeout.png` — Akşam kapanışı ("Bugün nasıl geçti?")
**Referans:** `assets/moods/landscapes.png`, O1
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised, same
world as the attached references.
Scene: late evening over satin-rippled dunes. The sky moves from deep
indigo-plum at the top (#1B1530) to a last thin band of warm amber light on
the horizon (#F3B98A), as if the day is gently closing. A thin crescent moon
(#FBD7B5) has just risen in the upper right. The nearest dune crests hold a
soft warm rim light; the valleys are deep and calm.
Composition: upper two thirds of the left half calm empty sky for a
headline; dunes in the lower 45%.
Feeling: completion, rest, a quiet exhale.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders.
```

#### F2 · `weekly_insight.png` — Haftalık gözlem kartı
**Referans:** F1 (onaylandıysa), `assets/moods/landscapes.png`
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised, same
world as the attached image.
Scene: the satin-rippled dune landscape seen from slightly higher, so seven
soft dune crests recede in a gentle rhythm towards the horizon, each crest
catching a little more moonlight than the one before it, like a quiet
sequence of days. Deep plum night sky (#211625 to #39283F), faint stars, a
soft pale-gold moon disc (#FBD7B5) in the upper right.
No charts, lines, numbers or symbols; the rhythm comes only from the dunes.
Composition: upper two thirds of the left half calm empty sky; dunes in the
lower half.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders.
```

---

### Faz 4 · Yeni mod manzaraları (M1–M4)

Mevcut 9 manzaranın (atlas `assets/moods/landscapes.png`) kardeşleri. Her
biri tek görsel olarak üretilir. Palet önerisi aşağıda; kodda yeni
`MoodPalette` aynı değerlerle tanımlanacak. **Önce bu modlar için tarif
etiketlemesi gerekir** (ROADMAP faz 4).

| Mod | Zemin | Yüzey | Vurgu |
|---|---|---|---|
| Stresliyim | #16202B | #26394A | #B9D3E6 |
| Kaygılıyım | #172A2C | #2A4446 | #C6E3DA |
| Uykusuzum | #120F24 | #241E3E | #C9C2F2 |
| İyiyim | #2A1D14 | #4A3222 | #FFD9A8 |

#### M1 · `mood_stress.png` — Stresliyim
**Referans:** `assets/moods/landscapes.png`
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised,
matching exactly the style, dune shapes, satin ripple texture and lighting
of the attached reference grid (copy the style of a single cell, not the
grid).
Palette: slate blue night, sky #16202B fading to #26394A at the horizon,
light accents #B9D3E6.
Scene: layered rolling dunes; above them, a few long, soft clouds that are
slowly parting, opening a clear calm gap where a pale cool full moon disc
(#B9D3E6) sits low on the right. The feeling is tension easing, not storm.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
lightning, frames or borders.
```

#### M2 · `mood_anxious.png` — Kaygılıyım
**Referans:** `assets/moods/landscapes.png`, M1
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised,
matching exactly the style of a single cell of the attached reference grid.
Palette: misty sea-green dusk, sky #172A2C fading to #2A4446, accents
#C6E3DA.
Scene: layered rolling dunes partly veiled by a thin, low, soft mist lying
in the valleys; the dune crests rise clearly above the mist; a soft pale
mint moon disc (#C6E3DA) low on the right, with a gentle reflection of
light in the mist. Feeling: grounding, steady footing.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders.
```

#### M3 · `mood_poorSleep.png` — Uykusuzum
**Referans:** `assets/moods/landscapes.png`, M1
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised,
matching exactly the style of a single cell of the attached reference grid.
Palette: deep indigo-violet late night, sky #120F24 fading to #241E3E,
accents #C9C2F2.
Scene: layered rolling dunes under a deep, quiet sky with slightly more
tiny stars than the other scenes; a very thin, low waning crescent
(#C9C2F2) near the horizon on the right, its light faint and soft. Feeling:
hush, softness, permission to rest.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders.
```

#### M4 · `mood_good.png` — İyiyim
**Referans:** `assets/moods/landscapes.png`, M1
```
Landscape 1536x1024 serene digital matte painting, photoreal-stylised,
matching exactly the style of a single cell of the attached reference grid.
Palette: warm early morning, sky #2A1D14 at the top warming to #4A3222 and a
soft apricot glow at the horizon, accents #FFD9A8.
Scene: layered rolling dunes with long gentle shadows; a soft, warm sun disc
(#FFD9A8) just above the horizon on the right, casting golden rim light on
the dune crests. Calm and bright, not exuberant; no lens flare.
Strictly no text, letters, logos, UI, people, animals, plants, buildings,
frames or borders.
```

---

## 5. Şablonlar (yeni içerik eklendikçe)

### Yeni tarif fotoğrafı
Görev 27'de yeni tarifler eklendikçe her biri için bir tane. **Dosya:**
`recipe_<tarif-id>.png` (ör. `recipe_d043.png`), 1024×1024.
**Referans:** `assets/food/recipes-0.png` + aynı öğün türünden bir atlas
(`recipes-0/1` kahvaltı, `-2..-5` öğle/akşam, `-6..-8` ara öğün).
Claude, tarifin JSON'undaki malzemelerden `{...}` alanlarını doldurup prompt'u
hazır verir; görünür malzeme listesi tarifteki listeyle **birebir** olmalı.
```
Square 1024x1024 photorealistic editorial food photograph of a single dish
for a recipe app, matching exactly one cell of the attached reference grid
(copy the style of one cell, not the grid).
Dish: {DISH_NAME_EN}. Visible components: {VISIBLE_INGREDIENTS}. Served in
{VESSEL: e.g. a matte cream speckled stoneware bowl / plate / clear glass /
seasoned cast-iron pan}. Garnish only: {GARNISH_FROM_RECIPE or "none"}.
Show only ingredients from that list; nothing else on or around the dish.
Camera: about 35 degrees above the table, three-quarter overhead, 50mm look,
gentle shallow depth of field, the dish perfectly sharp and centred, filling
about 70% of the frame width.
Surface: warm greige linen tablecloth with a visible fine weave.
Light: soft natural window light from the upper left, warm (about 4500K),
soft shadows to the lower right.
Colour: true-to-life, appetising, not oversaturated.
Strictly no text, letters, logos, labels, hands, people, extra props,
watermarks, frames or borders.
```

### Yeni malzeme fotoğrafı
Kataloğa yeni malzeme eklenirse (ör. `molasses`). **Dosya:**
`ingredient_<malzeme-id>.png`, 1024×1024.
**Referans:** `assets/food/ingredients-0.png`, `assets/food/ingredients-3.png`
```
Square 1024x1024 photorealistic top-down (90 degrees) photo of a single raw
ingredient portion, matching exactly one cell of the attached reference
grid (copy the style of one cell, not the grid).
Ingredient: {INGREDIENT_EN}, a realistic household portion, natural and
fresh, filling about 65% of a small round shallow matte stoneware dish in a
pale oat colour with a thin rim.
Surface: warm cream textured plaster (#E9DFCF).
Light: soft, even, diffuse daylight with a subtle soft shadow under the
dish.
Dish centred with generous margin.
Strictly no text, letters, labels, packaging, hands, people, extra props,
watermarks, frames or borders.
```

---

## 6. Claude için: teslim edilen görseli uygulamaya bağlama

Bu bölüm sonraki oturumlar için. Kullanıcı "teslim klasörüne görsel koydum"
dediğinde:

1. `docs/design/gorsel-uretim/teslim/` içindeki yeni dosyaları listele;
   tablodaki adlarla eşleştir. Adı uymayanı kullanıcıya sor.
2. Her görseli **Read ile aç ve kabul listesine göre denetle**. Yazı/harf,
   el, tıbbi nesne, tarifte olmayan malzeme, yanlış palet varsa reddet ve
   prompt'ta neyin düzeltileceğini yaz.
3. Küçült ve JPEG'e çevir (PNG'ler 1-3 MB; uygulamaya böyle girmez):
   ```
   powershell -ExecutionPolicy Bypass -File tool/resize_images.ps1 -Source docs/design/gorsel-uretim/teslim -Target assets/images/explore -Filter "cuisine_*.png"
   ```
   Hedef klasörler: `assets/images/explore/` (cuisine_, health_),
   `assets/images/onboarding/`, `assets/images/empty/`,
   `assets/images/scenes/` (evening_, weekly_, mood_),
   `assets/images/recipes/` (recipe_), `assets/images/ingredients/`.
   Yeni klasörü `pubspec.yaml` → `flutter: assets:` altına ekle.
4. Kodu bağla:
   - **cuisine_ / health_**: `lib/data/explore_data.dart` →
     `CuisineCategory` ve `SpecialCategory`'ye `coverImage` alanı; kartlar
     (`explore_screen.dart`) ve kategori başlığı
     (`special_detail_screen.dart`, `cuisine_detail_screen.dart`) gradyan +
     emoji yerine görsel + okunurluk için alttan koyulaşan gradyan
     (`WellnessFoodCard`'daki yöntem). Emoji kalksın.
   - **recipe_**: tarif JSON'unda `imagePath`; `RecipeVisual` zaten önce
     buna bakıyor. **ingredient_**: `FoodPhotoCatalog`'a değil, tek dosya
     desteği eklenerek `IngredientPhoto`'ya.
   - **onboarding_**: `onboarding_screen.dart`, `onboarding_health_screen.dart`,
     `onboarding_allergies_screen.dart` başlıkları.
   - **empty_**: ilgili boş durum metinlerinin üstüne, ~160 px.
5. Görsel kontrol: `flutter test test/wellness_ui_test.dart
   --dart-define=CAPTURE_WELLNESS=true` → `output/wellness-build/`. Gerekirse
   aynı yöntemle geçici bir yakalama testi yaz, sonra sil.
6. Bu dosyadaki tabloda **U** kutusunu işaretle, teslim edilen PNG'yi
   `teslim/` içinde bırak (kaynak arşivi), commit et.

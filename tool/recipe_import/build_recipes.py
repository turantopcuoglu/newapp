#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Düzeltme raporunu assets/recipes/*.json üzerine uygular."""
import json
import re
import os
import sys
import unicodedata
from collections import Counter, defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ing_map import MAP, NEW_INGREDIENTS  # noqa: E402
from parse_report import parse  # noqa: E402
from step_rewrites import rewrite as rewrite_steps  # noqa: E402

SP = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(SP))
MEALS = {'B': 'breakfast', 'L': 'lunch', 'D': 'dinner', 'S': 'snack'}

# ── katalog ───────────────────────────────────────────────────────────────
src = open(f'{ROOT}/lib/data/mock_ingredients.dart', encoding='utf-8').read()
CAT = {cid: {'en': en, 'tr': tr} for cid, en, tr in re.findall(
    r"id:\s*'([^']+)',\s*(?://[^\n]*\n\s*)*name:\s*\{'en':\s*'([^']*)',"
    r"\s*'tr':\s*'([^']*)'\}", src)}
ING_ALLERGENS = {}
for cid, tags in re.findall(r"id:\s*'([^']+)',(?:.|\n)*?allergenTags:\s*\[([^\]]*)\]",
                            src):
    ING_ALLERGENS[cid] = re.findall(r"'([a-z_]+)'", tags)
for nid, (tr, en, cat, alg, *_rest) in NEW_INGREDIENTS.items():
    CAT[nid] = {'tr': tr, 'en': en}
    ING_ALLERGENS[nid] = alg


def norm(s):
    s = s.lower().replace('ı', 'i')
    s = ''.join(c for c in unicodedata.normalize('NFD', s)
                if unicodedata.category(c) != 'Mn')
    return re.sub(r'[^a-z0-9 ]', ' ', s).strip()


BY_TR = {norm(v['tr']): k for k, v in CAT.items()}
BY_EN = {norm(v['en']): k for k, v in CAT.items()}
QUAL = (r'^(cig |taze |kuru |tam yagli |yagsiz |az yagli |dogranmis |'
        r'rendelenmis |ince |dilimlenmis |pismis |sicak |ilik |toz |turk |'
        r'raw |fresh |dried |cooked |chopped |grated |sliced |whole |ground |'
        r'lean |warm |hot |lukewarm |plain |low fat |full fat )')


def strip_q(n):
    prev = None
    while prev != n:
        prev = n
        n = re.sub(QUAL, '', n)
    return n.strip()


def resolve(tr_name, en_name):
    if tr_name in MAP:
        return MAP[tr_name]
    cid = (BY_TR.get(strip_q(norm(tr_name))) or BY_EN.get(strip_q(norm(en_name)))
           or BY_TR.get(norm(tr_name)) or BY_EN.get(norm(en_name)))
    return [cid] if cid else []


# ── miktar ayrıştırma ─────────────────────────────────────────────────────
FRAC = {'1/2': 0.5, '1/3': 0.33, '1/4': 0.25, '3/4': 0.75, '2/3': 0.67}


def number(tok):
    tok = tok.strip().replace("'şer", '').replace("'er", '')
    if tok in FRAC:
        return FRAC[tok]
    tok = tok.replace(',', '.')
    try:
        return float(tok)
    except ValueError:
        return None


def parse_qty(text, n_items):
    """Rapordaki miktar metnini {amount, unit}'e çevirir."""
    t = text.strip()
    # "yenebilir" diyen parantez kabuk/çekirdek düşülmüş ağırlığı verir;
    # besin tablosu da yenebilir kısma göre olduğu için o kazanır.
    m = re.search(r'\(([^)]*yenebilir[^)]*?([\d.,]+)\s*(g|ml)\b[^)]*|'
                  r'[^)]*?([\d.,]+)\s*(g|ml)\b[^)]*yenebilir[^)]*)\)', t)
    if m:
        val = m.group(2) or m.group(4)
        unit = m.group(3) or m.group(5)
        if val:
            return {'amount': float(val.replace(',', '.')), 'unit': unit}
    # Baştaki gram/ml değeri esastır. Parantez içi çoğu zaman PİŞMİŞ ağırlığı
    # verir ("50 g (pişince yaklaşık 150 g)") — besin tablosu kuru bazda
    # olduğu için oradaki değeri almak kaloriyi üçe katlar.
    m = re.match(r'^(?:yaklaşık\s+|about\s+)?([\d.,/]+)\s*(g|ml|L)\b', t)
    if m:
        val = number(m.group(1))
        if val is not None:
            return {'amount': val, 'unit': m.group(2)}
    # Baş kısımda ölçü yoksa ("1 yemek kaşığı (13,5 g)") parantezdeki gram
    # değeri kullanılır; bu satırlarda parantez pişmiş ağırlık değil, çeviri.
    m = re.search(r'\(([^)]*?([\d.,]+)\s*(g|ml)\b[^)]*)\)', t)
    if m and not re.search(r'pişince|pişmiş|cooked', m.group(1), re.I):
        return {'amount': float(m.group(2).replace(',', '.')),
                'unit': m.group(3)}
    units = [
        (r'yemek kaşığı', 'tablespoon'), (r'çay kaşığı', 'teaspoon'),
        (r'su bardağı|bardak', 'cup'), (r'diş', 'clove'), (r'tutam', 'pinch'),
        (r'dilim', 'slice'), (r'demet', 'bunch'), (r'dal', 'piece'),
        (r'adet|orta boy|küçük boy|büyük boy', 'piece'),
    ]
    for pattern, unit in units:
        if re.search(pattern, t):
            m = re.match(r"^([\d.,/]+)", t)
            amount = number(m.group(1)) if m else 1.0
            if amount is None:
                amount = 1.0
            # "birer tutam" = her biri için 1
            if re.match(r'^birer\b', t):
                amount = 1.0
            return {'amount': amount, 'unit': unit}
    # "gerekirse az", "damak tadına göre" gibi ölçüsüzler
    return {'amount': 1.0, 'unit': 'pinch'}


# ── pişmiş → kuru çevrimi ────────────────────────────────────────────────
# Besin tablosunda pirinç/mercimek KURU bazda; rapor birkaç satırda pişmiş
# ağırlık veriyor. O satırlarda kuru karşılığı yazılır, yoksa kalori 3 katına
# çıkar.
COOKED_TO_DRY = {
    'Pişmiş pirinç': ('white_rice', 2.75),
    'Soğuk pişmiş pirinç': ('white_rice', 2.75),
    'Pişmiş, süzülmüş yeşil mercimek': ('green_lentil', 2.4),
}


# ── mutfak eşlemesi ───────────────────────────────────────────────────────
CUISINE_RULES = [
    ('türk', 'turkish'), ('anglo-amerikan', 'american'),
    ('amerikan', 'american'), ('italyan', 'italian'), ('i̇talyan', 'italian'),
    ('akdeniz', 'mediterranean'), ('yunan', 'mediterranean'),
    ('ortadoğu', 'middleEastern'), ('orta doğu', 'middleEastern'),
    ('levant', 'middleEastern'), ('kuzey afrika', 'middleEastern'),
    ('meksika', 'mexican'), ('tex-mex', 'mexican'),
    ('asya', 'asian'), ('japon', 'asian'), ('kore', 'asian'),
    ('çin', 'asian'), ('vietnam', 'asian'), ('tayland', 'asian'),
    ('hint', 'asian'),
    ('latin amerika', 'mexican'),
    ('kuzey amerika', 'american'), ('louisiana', 'american'),
    ('hawaii', 'american'),
    ('fas', 'middleEastern'),
]


def cuisines_for(label):
    """Mutfak etiketi → Keşfet kategorileri.

    Kaynak belgeler tariflerin çoğunu "… Esintili Füzyon" diye etiketliyor.
    Mutfağı belli olan tarif YALNIZCA o mutfakta görünür; "Dünya & Füzyon"
    yalnızca uygulamada karşılığı olmayan etiketler için kalır (Fransız,
    Britanya, İskandinav, "Dünya ve Füzyon" gibi). Aksi hâlde bütün füzyonlar
    Dünya & Füzyon'a da düşüyor ve kategori diğerlerini eziyordu.
    """
    low = label.lower()
    out = []
    for key, cid in CUISINE_RULES:
        if key in low and cid not in out:
            out.append(cid)
    return out or ['international']


# ── alerjen eşlemesi ──────────────────────────────────────────────────────
ALLERGEN_WORDS = [
    (r'süt|milk|dairy|peynir|cheese|yoğurt|yogurt|tereyağ|butter|krema|cream',
     'dairy'),
    (r'yumurta|egg', 'eggs'),
    (r'gluten|buğday|wheat|arpa|barley', 'gluten'),
    (r'yer fıstığı|peanut', 'peanuts'),
    (r'ceviz|badem|fındık|antep fıstığı|kaju|çam fıstığı|walnut|almond|'
     r'hazelnut|pistachio|cashew|pine nut|tree nut|nuts', 'nuts'),
    (r'susam|sesame|tahin|tahini', 'sesame'),
    (r'soya|soy\b|miso|tofu|edamame', 'soy'),
    (r'karides|shrimp|midye|mussel|kalamar|squid|ahtapot|octopus|shellfish|'
     r'kabuklu deniz', 'shellfish'),
    (r'balık|fish|somon|salmon|ton|tuna|hamsi|anchovy|sardalya|sardine|'
     r'morina|cod|levrek|sea bass|çipura', 'fish'),
    (r'hardal|mustard', 'mustard'),
]


def allergens_from_text(text):
    low = text.lower()
    out = set()
    for pattern, tag in ALLERGEN_WORDS:
        if re.search(pattern, low):
            out.add(tag)
    return out


# ── yoğurt kuralı (kullanıcı düzeltmesi: TR'de "Türk" yok) ────────────────
TR_YOGURT = [
    ('Türk Yoğurtlu', 'Yoğurtlu'), ('Türk yoğurtlu', 'yoğurtlu'),
    ('Türk Yoğurdu', 'Yoğurt'), ('Türk yoğurdunun', 'yoğurdun'),
    ('Türk yoğurdunu', 'yoğurdu'), ('Türk yoğurdunda', 'yoğurtta'),
    ('Türk yoğurduyla', 'yoğurtla'), ('Türk yoğurdu', 'yoğurt'),
]


def tr_upper_first(text):
    if not text:
        return text
    first = text[0]
    upper = {'i': 'İ', 'ı': 'I'}.get(first, first.upper())
    return upper + text[1:]


def fix_tr(text):
    for a, b in TR_YOGURT:
        text = text.replace(a, b)
    # "Türk yoğurdu, ..." cümle başındaysa değişimden sonra küçük harfle
    # başlıyor; Türkçe büyük harfle düzelt.
    return tr_upper_first(text)


def fix_en(text):
    # Yalnız başına kalan "yogurt" -> "Turkish yogurt"
    text = re.sub(r'(?<!Turkish )(?<!turkish )\b([Yy])ogurt\b',
                  lambda m: ('T' if m.group(1) == 'Y' else 'T') +
                  ('urkish Yogurt' if m.group(1) == 'Y' else 'urkish yogurt'),
                  text)
    return text


SENTENCE = re.compile(r'(?<=[.!?])\s+(?=[A-ZÇĞİÖŞÜ0-9])')


def split_steps(steps):
    """Rapordaki çok cümleli adımları cümle cümle ayırır.

    Metin birebir korunur; yalnızca adım sınırı değişir. Rapor her tarifi
    4 adımda topluyor, uygulama (ve data_report) en az 6 adım bekliyor ve
    tek ekranda okunan kısa adımlar zaten daha kullanışlı.
    """
    out = []
    for step in steps:
        for piece in SENTENCE.split(step.strip()):
            piece = piece.strip()
            if piece:
                out.append(piece)
    return out


# Raporun kendi başlığı bozuk gelen tek tarif: kelimeler yer değiştirmiş
# ("Menemen Pepper) (Turkish Scrambled Eggs with Tomato and").
TITLE_FIX = {
    'B006': ('Menemen',
             'Menemen (Turkish Scrambled Eggs with Tomato and Pepper)'),
}


# ── birleştirilen tarifler ───────────────────────────────────────────────
# S020 ve S036 raporda aynı yemek: 200°C'de kızartılan nohut, tek fark
# sumak. Kullanıcı kararıyla tek tarifte birleştirildi; S036 içe
# aktarılmıyor, S020 ikisinin de baharatını taşıyor.
DROPPED = {'S036'}

MERGED = {
    'S020': {
        'name_tr': 'Sumaklı Baharatlı Çıtır Fırın Nohut',
        'name_en': 'Spiced Crispy Roasted Chickpeas with Sumac',
        'desc_tr': 'Kimyon, toz biber ve sarımsak tozuyla fırında kızartılıp '
                   'sıcakken sumakla tamamlanan çıtır nohut atıştırmalığı.',
        'desc_en': 'Chickpeas roasted with cumin, paprika and garlic powder, '
                   'finished with sumac straight out of the oven.',
        'cuisine_tr': 'Türk ve Ortadoğu Esintili Atıştırmalık',
        'ings_tr': [
            'Pişmiş, süzülmüş nohut - 150 g',
            'Zeytinyağı - 10 g',
            'Kimyon - 1/2 çay kaşığı',
            'Tatlı toz biber - 1/2 çay kaşığı',
            'Sarımsak tozu - 1/4 çay kaşığı',
            'Sumak - 1 çay kaşığı',
            'Tuz - 1 küçük tutam',
        ],
        'ings_en': [
            'Cooked, drained chickpeas - 150 g',
            'Olive oil - 10 g',
            'Cumin - 1/2 tsp',
            'Sweet paprika - 1/2 tsp',
            'Garlic powder - 1/4 tsp',
            'Sumac - 1 tsp',
            'Salt - 1 small pinch',
        ],
        'steps_tr': [
            "Fırını 200°C'ye ısıtın. Nohudu süzüp yıkayın ve temiz bezle çok "
            "iyi kurulayın.",
            'Nohudu zeytinyağı, kimyon, toz biber ve sarımsak tozuyla '
            'karıştırın; sumağı ve tuzu şimdilik eklemeyin.',
            'Tek sıra hâlinde tepsiye yayın; iki kez sallayarak 35-45 dakika, '
            'dışı kuru ve kızarmış olana kadar fırınlayın.',
            'Fırından çıkar çıkmaz sumak ve tuzu ekleyin. Tepside tamamen '
            'soğutup aynı gün tüketin.',
        ],
        'steps_en': [
            'Heat the oven to 200°C. Drain and rinse the chickpeas, then dry '
            'them very well with a clean cloth.',
            'Toss the chickpeas with the olive oil, cumin, paprika and garlic '
            'powder; hold back the sumac and salt for now.',
            'Spread them in a single layer on a tray and roast for 35-45 '
            'minutes, shaking twice, until dry and golden outside.',
            'Add the sumac and salt the moment they leave the oven. Cool '
            'completely on the tray and eat the same day.',
        ],
        'allergens_tr': 'Yok.',
        'allergens_en': 'None.',
    },
}


# ── ana akış ──────────────────────────────────────────────────────────────
def main():
    report = {r['code']: r for r in parse()}
    # Raporun 20 tarifte başlık satırı kırpık ("... Yaban Mersinli Gece");
    # bölüm başındaki özet tablosunda adlar tam. Türkçe ad oradan alınır.
    table_names = json.load(open(f'{SP}/table_names.json', encoding='utf-8'))
    stats = defaultdict(list)
    cuisine_counter = Counter()

    for meal_letter, meal in MEALS.items():
        path = f'{ROOT}/assets/recipes/{meal}.json'
        data = json.load(open(path, encoding='utf-8'))
        for recipe in data:
            code = recipe['id'].upper()
            if code in DROPPED:
                stats['birleştirildi'].append(code)
                continue
            rep = report.get(code)
            if not rep:
                stats['raporda_yok'].append(code)
                continue
            if code in MERGED:
                rep = {**rep, **MERGED[code]}

            name_tr = table_names.get(code, rep['name_tr'])
            name_en = rep['name_en']
            if len(name_tr) < len(rep['name_tr']):
                name_tr = rep['name_tr']
            if code in TITLE_FIX:
                name_tr, name_en = TITLE_FIX[code]
            recipe['name'] = {'en': fix_en(name_en), 'tr': fix_tr(name_tr)}
            recipe['description'] = {'en': fix_en(rep['desc_en']),
                                     'tr': fix_tr(rep['desc_tr'])}
            steps_tr = [fix_tr(s) for s in split_steps(rep['steps_tr'])]
            steps_en = [fix_en(s) for s in split_steps(rep['steps_en'])]
            # İç sıcaklık ölçütlerini gündelik dile çevir, pişirme adımı
            # eksik olan tarifleri yeniden yaz.
            steps_tr, steps_en = rewrite_steps(
                code, steps_tr, steps_en,
                f"{name_tr} {rep['desc_tr']} {' '.join(steps_tr)}",
                f"{name_en} {rep['desc_en']} {' '.join(steps_en)}")
            recipe['steps'] = {'en': steps_en, 'tr': steps_tr}

            # malzemeler + miktarlar
            ids, quantities = [], {}
            for tr_line, en_line in zip(rep['ings_tr'], rep['ings_en']):
                tr_name, _, qty_text = tr_line.partition(' - ')
                en_name = en_line.partition(' - ')[0]
                targets = resolve(tr_name.strip(), en_name.strip())
                if not targets:
                    stats['eşleşmeyen'].append((code, tr_name))
                    continue
                qty = parse_qty(qty_text, len(targets))
                if tr_name.strip() in COOKED_TO_DRY:
                    _cid, factor = COOKED_TO_DRY[tr_name.strip()]
                    if qty['unit'] in ('g', 'ml'):
                        qty['amount'] = round(qty['amount'] / factor)
                        stats['pişmiş_kuru'].append((code, tr_name.strip()))
                for cid in targets:
                    if cid in quantities:  # aynı malzeme iki satırda
                        if quantities[cid]['unit'] == qty['unit']:
                            quantities[cid]['amount'] += qty['amount']
                        continue
                    ids.append(cid)
                    quantities[cid] = dict(qty)
            recipe['ingredientIds'] = ids
            recipe['quantities'] = quantities

            # mutfak
            recipe['cuisineIds'] = cuisines_for(rep['cuisine_tr'])
            cuisine_counter.update(recipe['cuisineIds'])

            # alerjenler: malzemeden türetilen ∪ raporun beyanı
            derived = set()
            for cid in ids:
                derived.update(ING_ALLERGENS.get(cid, []))
            declared = allergens_from_text(
                rep['allergens_tr'] + ' ' + rep['allergens_en'])
            tags = sorted(derived | declared)
            if set(tags) != set(recipe.get('allergenTags', [])):
                stats['alerjen_değişti'].append(
                    (code, sorted(recipe.get('allergenTags', [])), tags))
            recipe['allergenTags'] = tags

            # porsiyon
            m = re.search(r'(\d+)\s*porsiyon', rep['servings_tr'])
            recipe['servings'] = int(m.group(1)) if m else 1

            # rapordaki besin değeri (karşılaştırma için sakla)
            recipe['macros'] = {k: int(round(v))
                                for k, v in rep['macros'].items()}
            stats['güncellendi'].append(code)

        data = [r for r in data if r['id'].upper() not in DROPPED]
        json.dump(data, open(path, 'w', encoding='utf-8'),
                  ensure_ascii=False, indent=2)
        open(path, 'a', encoding='utf-8').write('')

    for path in [f'{ROOT}/assets/recipes/{m}.json' for m in MEALS.values()]:
        text = open(path, encoding='utf-8').read()
        if not text.endswith('\n'):
            open(path, 'a', encoding='utf-8').write('\n')

    print("güncellenen tarif:", len(stats['güncellendi']))
    print("birleştirilip çıkarılan:", stats['birleştirildi'] or "yok")
    # Paketten gelen tarifler bu raporda yok; onları build_pack yönetiyor.
    print("bu raporda olmayan (başka kaynaktan gelen):",
          len(stats['raporda_yok']))
    print("eşleşmeyen malzeme:", stats['eşleşmeyen'] or "yok")
    print("mutfak dağılımı:", dict(cuisine_counter))
    print("alerjen etiketi değişen tarif:", len(stats['alerjen_değişti']))
    json.dump(stats['alerjen_değişti'],
              open(f'{SP}/allergen_changes.json', 'w', encoding='utf-8'),
              ensure_ascii=False, indent=1)


if __name__ == '__main__':
    main()

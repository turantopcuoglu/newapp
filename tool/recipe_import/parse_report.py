#!/usr/bin/env python3
"""Düzeltme raporunu (markdown) yapısal kayıtlara çevirir."""
import json
import re
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
SRC = ROOT / "docs/tarif-duzeltme-raporu.md"


def parse():
    text = open(SRC, encoding='utf-8').read()
    # Tarif blokları
    parts = re.split(r'^### ([A-Z]\d{3}) — (.*?)$', text, flags=re.M)
    recipes = []
    for i in range(1, len(parts), 3):
        code, title, body = parts[i], parts[i + 1], parts[i + 2]
        rec = {'code': code}
        if '/' in title:
            tr_name, en_name = title.split('/', 1)
        else:
            tr_name, en_name = title, title
        rec['name_tr'] = tr_name.strip()
        rec['name_en'] = en_name.strip()

        tr_sec = section(body, 'Türkçe Düzeltilmiş Tarif')
        en_sec = section(body, 'Corrected English Recipe')
        notes = section(body, 'Düzeltme Notları')

        rec.update(parse_side(tr_sec, 'tr'))
        rec.update(parse_side(en_sec, 'en'))

        m = re.search(r'^Yeni: *(\d+) *kcal *\| *P *([\d.,]+) *g *\| *KH *'
                      r'([\d.,]+) *g *\| *Y *([\d.,]+) *g *\| *Lif *([\d.,]+)',
                      notes, re.M)
        if m:
            rec['macros'] = {
                'calories': int(m.group(1)),
                'proteinG': num(m.group(2)),
                'carbsG': num(m.group(3)),
                'fatG': num(m.group(4)),
                'fiberG': num(m.group(5)),
            }
        m = re.search(r'^Eski: *(\d+) *kcal', notes, re.M)
        rec['old_calories'] = int(m.group(1)) if m else None
        rec['notes'] = [l.strip('• ').strip() for l in notes.splitlines()
                        if l.startswith('•')]
        recipes.append(rec)
    return recipes


def num(s):
    return float(s.replace(',', '.'))


def section(body, heading):
    m = re.search(r'^#### ' + re.escape(heading) + r'\s*$(.*?)(?=^#### |\Z)',
                  body, re.M | re.S)
    return m.group(1) if m else ''


def parse_side(sec, lang):
    out = {}
    lines = [l.rstrip() for l in sec.strip().splitlines()]
    lines = [l for l in lines if l.strip()]
    if not lines:
        return out
    # 1. satır: *Mutfak • porsiyon*
    head = lines[0].strip('*').strip()
    out[f'cuisine_{lang}'] = head.split('•')[0].strip()
    out[f'servings_{lang}'] = head.split('•')[1].strip() if '•' in head else ''
    # 2. satır (madde başlığına kadar): açıklama
    desc, idx = [], 1
    while idx < len(lines) and not lines[idx].startswith('**'):
        desc.append(lines[idx].strip())
        idx += 1
    # Raporda birkaç tarifte italik künye satırı ortadan bölünmüş:
    # "*... • 1 porsiyon / 1*" + "serving Açıklama..." — kalıntıyı temizle.
    text = ' '.join(desc).strip()
    text = re.sub(r'^\*?(?:\d+\s*)?(?:porsiyon\s*/\s*)?(?:\d+\s*)?'
                  r'(?:serving|porsiyon)\*?\s+', '', text)
    out[f'desc_{lang}'] = text

    ings, steps, allergens = [], [], ''
    mode = None
    for line in lines[idx:]:
        s = line.strip()
        if s.startswith('**') and ('Malzemeler' in s or s == '**Ingredients**'):
            mode = 'ing'
            continue
        if s.startswith('**') and ('Hazırlanışı' in s or s == '**Method**'):
            mode = 'step'
            continue
        if s.startswith('Alerjenler / Allergens:'):
            allergens = s.split(':', 1)[1].strip()
            mode = None
            continue
        if mode == 'ing' and s.startswith('•'):
            ings.append(s.lstrip('• ').strip())
        elif mode == 'step' and re.match(r'^\d+\.', s):
            steps.append(re.sub(r'^\d+\.\s*', '', s))
        elif mode == 'step' and steps:
            steps[-1] += ' ' + s
    out[f'ings_{lang}'] = ings
    out[f'steps_{lang}'] = steps
    out[f'allergens_{lang}'] = allergens
    return out


if __name__ == '__main__':
    recipes = parse()
    json.dump(recipes, open(sys.argv[1], 'w', encoding='utf-8'),
              ensure_ascii=False, indent=1)
    print(f"{len(recipes)} tarif ayrıştırıldı")
    bad = [r['code'] for r in recipes
           if not r.get('ings_tr') or not r.get('ings_en')
           or not r.get('steps_tr') or not r.get('steps_en')
           or not r.get('macros') or not r.get('desc_tr')
           or not r.get('desc_en')]
    print("eksik alanı olanlar:", bad or "yok")
    from collections import Counter
    print("TR mutfak:", Counter(r['cuisine_tr'] for r in recipes))
    print("EN mutfak:", Counter(r['cuisine_en'] for r in recipes))
    print("adım sayısı:", Counter(len(r['steps_tr']) for r in recipes))
    print("TR/EN adım sayısı farklı:",
          [r['code'] for r in recipes
           if len(r['steps_tr']) != len(r['steps_en'])] or "yok")
    print("TR/EN malzeme sayısı farklı:",
          [r['code'] for r in recipes
           if len(r['ings_tr']) != len(r['ings_en'])] or "yok")

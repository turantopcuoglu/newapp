#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""220 yeni tarif koleksiyonunu (`docs/yeni-tarifler.md`) ayrıştırır.

Düzeltme raporundan farklı bir şema kullanıyor: malzemeler TR|EN tablosunda,
adımlar tek numarada **TR:** + **EN:** olarak, besin değerleri kendi
tablosunda. Çıktı kayıtları `build_recipes.py`'nin beklediği alan adlarıyla
aynı, böylece yazma tarafı ortak kalıyor.
"""
from __future__ import annotations

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
SRC = ROOT / 'docs/yeni-tarifler.md'


def field(body: str, label: str) -> str:
    m = re.search(r'^\*\*' + re.escape(label) + r':?\*\*[ \t]*(.*?)\s*$',
                  body, re.M)
    return m.group(1).strip() if m else ''


def table_rows(body: str, heading: str) -> list[tuple[str, str]]:
    m = re.search(r'^### ' + re.escape(heading) + r'\s*$(.*?)(?=^###|\Z)',
                  body, re.M | re.S)
    if not m:
        return []
    rows = []
    for line in m.group(1).splitlines():
        line = line.strip()
        if not line.startswith('|') or set(line) <= set('|-: '):
            continue
        cells = [c.strip() for c in line.strip('|').split('|')]
        if len(cells) < 2 or cells[0] in ('Türkçe', 'Turkish'):
            continue
        rows.append((cells[0], cells[1]))
    return rows


def parse_steps(body: str) -> tuple[list[str], list[str]]:
    m = re.search(r'^### Hazırlanışı / Method\s*$(.*?)(?=^###|\Z)',
                  body, re.M | re.S)
    if not m:
        return [], []
    tr, en = [], []
    for line in m.group(1).splitlines():
        line = line.strip()
        t = re.match(r'^(?:\d+\.\s*)?\*\*TR:?\*\*\s*(.*)$', line)
        e = re.match(r'^(?:\d+\.\s*)?\*\*EN:?\*\*\s*(.*)$', line)
        if t:
            tr.append(t.group(1).strip())
        elif e:
            en.append(e.group(1).strip())
    return tr, en


def parse_macros(body: str) -> dict | None:
    m = re.search(r'^### Besin değerleri / Nutrition\s*$(.*?)(?=^###|\Z|^\*\*)',
                  body, re.M | re.S)
    if not m:
        return None
    for line in m.group(1).splitlines():
        nums = re.findall(r'(\d+(?:[.,]\d+)?)\s*(?:kcal|g)\b', line)
        if len(nums) >= 5:
            vals = [float(n.replace(',', '.')) for n in nums[:5]]
            return {
                'calories': int(round(vals[0])),
                'proteinG': vals[1],
                'carbsG': vals[2],
                'fatG': vals[3],
                'fiberG': vals[4],
            }
    return None


def parse() -> list[dict]:
    text = SRC.read_text(encoding='utf-8')
    parts = re.split(r'^## ([BLDS]\d{3}) [-–] (.*?)$', text, flags=re.M)
    out = []
    for i in range(1, len(parts), 3):
        code, title, body = parts[i], parts[i + 1].strip(), parts[i + 2]
        cuisine = field(body, 'Mutfak / Cuisine')
        rec = {
            'code': code,
            'name_tr': title,
            'name_en': field(body, 'English title'),
            'cuisine_tr': cuisine.split('/')[0].strip(),
            'cuisine_en': (cuisine.split('/')[1].strip()
                           if '/' in cuisine else cuisine),
            'content_tag': field(body, 'İçerik etiketi / Content tag'),
            'desc_tr': field(body, 'Açıklama'),
            'desc_en': field(body, 'Description'),
            'allergens_tr': field(body, 'Alerjenler'),
            'allergens_en': field(body, 'Allergens'),
            'servings_tr': '1 porsiyon',
            'macros': parse_macros(body),
        }
        rows = table_rows(body, 'Malzemeler / Ingredients')
        rec['ings_tr'] = [tr for tr, _ in rows]
        rec['ings_en'] = [en for _, en in rows]
        rec['steps_tr'], rec['steps_en'] = parse_steps(body)
        out.append(rec)
    return out


if __name__ == '__main__':
    recipes = parse()
    if len(sys.argv) > 1:
        json.dump(recipes, open(sys.argv[1], 'w', encoding='utf-8'),
                  ensure_ascii=False, indent=1)
    print(f'{len(recipes)} tarif ayrıştırıldı')
    bad = [r['code'] for r in recipes
           if not (r['name_tr'] and r['name_en'] and r['desc_tr']
                   and r['desc_en'] and r['ings_tr'] and r['ings_en']
                   and r['steps_tr'] and r['steps_en'] and r['macros'])]
    print('eksik alanı olan:', bad or 'yok')
    print('TR/EN malzeme sayısı farklı:',
          [r['code'] for r in recipes
           if len(r['ings_tr']) != len(r['ings_en'])] or 'yok')
    print('TR/EN adım sayısı farklı:',
          [r['code'] for r in recipes
           if len(r['steps_tr']) != len(r['steps_en'])] or 'yok')
    from collections import Counter
    print('adım sayısı:', dict(Counter(len(r['steps_tr'])
                                       for r in recipes)))
    print('malzeme sayısı:', dict(sorted(Counter(
        len(r['ings_tr']) for r in recipes).items())))

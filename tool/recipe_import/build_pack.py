#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""220 yeni tarifi (`docs/yeni-tarifler.md`) assets/recipes/*.json'a ekler.

Mevcut tariflere dokunmaz; yalnızca dosyada bulunmayan kodları ekler, sonra
listeyi id'ye göre sıralar. Yazma kuralları (yoğurt adlandırması, adımların
cümleden bölünmesi, miktar önceliği, alerjen birleştirme) `build_recipes.py`
ile ortak.
"""
from __future__ import annotations

import json
import os
import re
import sys
from collections import Counter, defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import build_recipes as B  # noqa: E402
from ing_map_pack import (COOKED_TO_DRY_FACTORS, MAP as PACK_MAP,  # noqa: E402
                          NEW_INGREDIENTS as PACK_NEW)
from parse_pack import parse  # noqa: E402

ROOT = B.ROOT
MEALS = {'B': 'breakfast', 'L': 'lunch', 'D': 'dinner', 'S': 'snack'}

COOKED_PREFIX = re.compile(r'^(pişmiş|haşlanmış)\b', re.I)

# Pakette kütüphanedeki bir tarifin aynısı olan kayıtlar. Malzeme listeleri
# birebir/neredeyse aynı ve yöntem de örtüşüyor; ikisini de tutmak kullanıcıya
# aynı yemeği iki kez göstermek olurdu.
DROPPED = {
    'S039': 's037 ile aynı: hurma-tahin-kakao topları, malzemeler birebir',
    'D094': 'd065 ile aynı: balık taco, tek fark morina yerine çipura',
}

# Paketin kendi içinde aynı İngilizce adı taşıyan iki farklı tarif var;
# Türkçe adları zaten ayrı ("Kapama" / "Kasesi").
TITLE_FIX = {
    'D095': ('Tavuklu Mantarlı Milföy Kasesi',
             'Chicken and Mushroom Puff Pastry Bowl'),
}


def resolve(tr_name: str, en_name: str) -> list[str]:
    if tr_name in PACK_MAP:
        return PACK_MAP[tr_name]
    return B.resolve(tr_name, en_name)


def ingredient_allergens(cid: str) -> list[str]:
    if cid in PACK_NEW:
        return PACK_NEW[cid][3]
    return B.ING_ALLERGENS.get(cid, [])


def build_recipe(rep: dict) -> dict:
    code = rep['code']
    if code in TITLE_FIX:
        rep = {**rep, 'name_tr': TITLE_FIX[code][0],
               'name_en': TITLE_FIX[code][1]}
    ids: list[str] = []
    quantities: dict[str, dict] = {}

    for tr_line, en_line in zip(rep['ings_tr'], rep['ings_en']):
        tr_name, _, qty_text = tr_line.partition(' - ')
        en_name = en_line.partition(' - ')[0]
        tr_name = tr_name.strip()
        targets = resolve(tr_name, en_name.strip())
        if not targets:
            raise SystemExit(f'{code}: eşleşmeyen malzeme "{tr_name}"')
        qty = B.parse_qty(qty_text, len(targets))
        for cid in targets:
            amount = qty['amount']
            # Besin tablosu kuru bazda tutulan malzemeler için "pişmiş"
            # verilen ağırlığı kuru karşılığına indir.
            if (COOKED_PREFIX.match(tr_name)
                    and cid in COOKED_TO_DRY_FACTORS
                    and qty['unit'] in ('g', 'ml')):
                amount = round(amount / COOKED_TO_DRY_FACTORS[cid])
            if cid in quantities:
                if quantities[cid]['unit'] == qty['unit']:
                    quantities[cid]['amount'] += amount
                continue
            ids.append(cid)
            quantities[cid] = {'amount': float(amount), 'unit': qty['unit']}

    derived = set()
    for cid in ids:
        derived.update(ingredient_allergens(cid))
    declared = B.allergens_from_text(
        f"{rep['allergens_tr']} {rep['allergens_en']}")

    macros = rep['macros'] or {}
    return {
        'id': code.lower(),
        'name': {'en': B.fix_en(rep['name_en']),
                 'tr': B.fix_tr(rep['name_tr'])},
        'description': {'en': B.fix_en(rep['desc_en']),
                        'tr': B.fix_tr(rep['desc_tr'])},
        'mealType': MEALS[code[0]],
        'cuisineIds': B.cuisines_for(rep['cuisine_tr']),
        'dietTags': [],
        'servings': 1,
        'prepTimeMin': None,
        'ingredientIds': ids,
        'allergenTags': sorted(derived | declared),
        'checkInTags': [],
        'proteinLevel': 'medium',
        'fiberLevel': 'medium',
        'carbType': 'mixed',
        'macros': {k: int(round(v)) for k, v in macros.items()},
        'steps': {'en': [B.fix_en(s) for s in B.split_steps(rep['steps_en'])],
                  'tr': [B.fix_tr(s) for s in B.split_steps(rep['steps_tr'])]},
        'imagePath': None,
        'isUserCreated': False,
        'quantities': quantities,
    }


def main() -> None:
    pack = [r for r in parse() if r['code'] not in DROPPED]
    by_meal: dict[str, list[dict]] = defaultdict(list)
    for rep in pack:
        by_meal[MEALS[rep['code'][0]]].append(build_recipe(rep))
    print('kopya olduğu için alınmayan:', ', '.join(sorted(DROPPED)))

    added = Counter()
    cuisines = Counter()
    for meal, new_recipes in by_meal.items():
        path = f'{ROOT}/assets/recipes/{meal}.json'
        data = json.load(open(path, encoding='utf-8'))
        existing = {r['id'] for r in data}
        for recipe in new_recipes:
            if recipe['id'] in existing:
                continue
            data.append(recipe)
            added[meal] += 1
            cuisines.update(recipe['cuisineIds'])
        data.sort(key=lambda r: r['id'])
        json.dump(data, open(path, 'w', encoding='utf-8'),
                  ensure_ascii=False, indent=2)
        open(path, 'a', encoding='utf-8').write('\n')
        print(f'{meal}: +{added[meal]} → {len(data)} tarif')

    print('toplam eklenen:', sum(added.values()))
    print('yeni tariflerin mutfak dağılımı:', dict(cuisines.most_common()))


if __name__ == '__main__':
    main()

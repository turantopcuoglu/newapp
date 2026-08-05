#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Yeni makro/malzemelere göre besin seviyelerini ve check-in etiketlerini
gözden geçirir.

Seviyeler (proteinLevel/fiberLevel/carbType) tamamen yeniden türetilir —
eskiden elle yazılmışlardı ve düzeltilmiş miktarlardan sonra artık yanlışlar.
Check-in etiketleri ise korunur; yalnızca veri açıkça çelişiyorsa eklenir
veya çıkarılır.
"""
import collections
import json
import os

ROOT = os.path.join(
    os.path.dirname(os.path.dirname(
        os.path.dirname(os.path.abspath(__file__)))),
    'assets/recipes')
MEALS = ['breakfast', 'lunch', 'dinner', 'snack']

SWEET = {'sugar', 'brown_sugar', 'powdered_sugar', 'honey', 'maple_syrup',
         'molasses', 'condensed_milk', 'chocolate_bar', 'dark_chocolate',
         'ice_cream', 'cookies', 'whipped_cream', 'granola_bar', 'granola',
         'dried_fruit', 'raisins', 'dried_apricot', 'dates'}

IRON = {'liver', 'ground_beef', 'beef_steak', 'veal', 'lamb', 'red_lentil',
        'green_lentil', 'chickpea', 'white_bean', 'black_bean', 'kidney_bean',
        'fava_bean', 'spinach', 'swiss_chard', 'kale', 'pumpkin_seeds',
        'molasses', 'dried_apricot', 'raisins', 'tahini', 'dates', 'quinoa',
        'buckwheat'}

VITAMIN_C = {'lemon', 'lime', 'orange', 'tomato', 'tomato_paste',
             'bell_pepper', 'hot_pepper', 'parsley', 'broccoli', 'strawberry',
             'pomegranate', 'kiwi', 'cabbage', 'red_cabbage', 'cauliflower',
             'arugula', 'watercress'}

# Tek başına da kayda değer demir veren malzemeler.
STRONG_IRON = {'liver', 'ground_beef', 'beef_steak', 'veal', 'lamb',
               'red_lentil', 'green_lentil', 'spinach', 'swiss_chard',
               'molasses'}

MAGNESIUM = {'pumpkin_seeds', 'tahini', 'dark_chocolate', 'cocoa_powder',
             'spinach', 'swiss_chard', 'almond', 'walnut', 'hazelnut',
             'cashew', 'chia_seeds', 'flax_seeds', 'buckwheat', 'quinoa',
             'oats', 'banana', 'dates', 'sunflower_seeds', 'pistachio',
             'peanut', 'peanut_butter', 'almond_butter'}


def protein_level(g):
    return 'high' if g >= 25 else ('medium' if g >= 12 else 'low')


def fiber_level(g):
    return 'high' if g >= 8 else ('medium' if g >= 4 else 'low')


def carb_type(recipe):
    """Lif yoğunluğu + eklenmiş şeker. İnsülin direnci / PCOS filtresi bunu
    okuyor; ölçüt "bu karbonhidrat kan şekerini nasıl etkiler" olmalı."""
    carbs = recipe['macros']['carbsG']
    fiber = recipe['macros']['fiberG']
    if carbs <= 0:
        return 'complex'
    density = fiber / carbs
    sweet = bool(SWEET & set(recipe['ingredientIds']))
    if density >= 0.14 and not sweet:
        return 'complex'
    if density <= 0.06 or (sweet and density < 0.09):
        return 'simple'
    return 'mixed'


def main():
    before = collections.Counter()
    after = collections.Counter()
    level_changes = collections.Counter()
    tag_changes = []

    for meal in MEALS:
        path = f'{ROOT}/{meal}.json'
        data = json.load(open(path, encoding='utf-8'))
        for r in data:
            before.update(r['checkInTags'])
            ings = set(r['ingredientIds'])
            macros = r['macros']

            for field, value in [('proteinLevel',
                                  protein_level(macros['proteinG'])),
                                 ('fiberLevel', fiber_level(macros['fiberG'])),
                                 ('carbType', carb_type(r))]:
                if r[field] != value:
                    level_changes[field] += 1
                r[field] = value

            tags = set(r['checkInTags'])
            original = set(tags)

            # Toparlanma: protein yüksekse ekle, düşükse yanlış etikettir.
            if macros['proteinG'] >= 25:
                tags.add('postWorkout')
            elif macros['proteinG'] < 15:
                tags.discard('postWorkout')

            # Regl yorgunluğu: ya birden çok demir kaynağı, ya da güçlü bir
            # demir kaynağı + emilimi artıran C vitamini.
            if (len(IRON & ings) >= 2
                    or (STRONG_IRON & ings and VITAMIN_C & ings)):
                tags.add('periodFatigue')
            # Kramp ve PMS: magnezyum yoğun tarifler.
            if len(MAGNESIUM & ings) >= 2:
                tags.add('periodCramps')
                tags.add('pms')

            # Tatlı isteği: gerçekten tatlı bir şey içermeyen tarif bu
            # etiketi taşımamalı.
            if not (SWEET & ings) and not ({'banana', 'apple', 'pear',
                                            'strawberry', 'blueberry',
                                            'raspberry', 'mango', 'fig',
                                            'grape', 'peach'} & ings):
                tags.discard('cravingSweets')

            if not tags:
                tags.add('noSpecificIssue')
            if tags != original:
                tag_changes.append((r['id'], sorted(original), sorted(tags)))
            r['checkInTags'] = sorted(tags)
            after.update(r['checkInTags'])

        json.dump(data, open(path, 'w', encoding='utf-8'),
                  ensure_ascii=False, indent=2)
        open(path, 'a', encoding='utf-8').write('\n')

    print("seviye alanı değişen tarif sayısı:", dict(level_changes))
    print("check-in etiketi değişen tarif:", len(tag_changes))
    print("\nönce :", dict(before.most_common()))
    print("sonra:", dict(after.most_common()))


if __name__ == '__main__':
    main()

# -*- coding: utf-8 -*-
"""Hazırlanış adımlarını günlük dile çeker.

İki iş yapar:

1. **Sıcaklık ifadelerini sadeleştirir.** Kaynak belgeler pişme kontrolünü
   "merkez sıcaklığı 74°C'ye ulaşana kadar" diye yazıyor. Evde termometre
   kullanmayan biri için bu ölçüt işe yaramıyor; yerine gözle görülebilir
   işaret konur ("kestiğinizde içi tamamen beyaz olana kadar"). Fırın
   sıcaklıkları (180-220°C) olduğu gibi kalır — onlar düğmeden ayarlanıyor.

2. **Eksik pişirme adımı olan tarifleri yeniden yazar.** Bazı tarifler
   "önceden 74°C'ye ulaşmış tavuğu doğrayın" diye başlıyor; tavuğun nasıl
   pişirileceği hiçbir yerde yazmıyor. Bu tarifler pişirmeden başlayıp
   soğutma süresini de veren adımlarla değiştirilir (`STEP_OVERRIDES`).
"""
from __future__ import annotations

import re

# ── 1. Sıcaklık → gözle görülür pişme işareti ────────────────────────────

# Adım metninde hangi protein geçiyorsa ona uygun işaret seçilir.
CUES = {
    'shrimp': ('karidesler pembeleşip kıvrılana kadar',
               'until the shrimp turn pink and curl'),
    'fish': ('çatalla bastırınca kolayca pul pul ayrılana kadar',
             'until it flakes easily when pressed with a fork'),
    'mince': ('içinde pembelik kalmayana kadar',
              'until no pink remains'),
    'poultry': ('en kalın yerinden kestiğinizde içi tamamen beyaz olana kadar',
                'until the thickest part is white all the way through'),
    'steak': ('istediğiniz pişme derecesine gelene kadar',
              'until it is done to your liking'),
    'liver': ('içinde pembelik kalmayana kadar',
              'until no pink remains'),
    'egg': ('ortası oynamayana kadar',
            'until the centre is set'),
    'default': ('iyice pişene kadar', 'until cooked through'),
}

_CONTEXT = [
    (r'karides|shrimp', 'shrimp'),
    (r'kıyma|köfte|mince|minced|ground (beef|turkey|lamb)|meatball', 'mince'),
    (r'somon|levrek|çipura|morina|uskumru|alabalık|sardalya|balığ|balık|'
     r'salmon|cod|sea bass|sea bream|trout|mackerel|fish', 'fish'),
    (r'tavuğ|tavuk|hindi|chicken|turkey', 'poultry'),
    (r'ciğer|liver', 'liver'),
    (r'biftek|bonfile|kuşbaşı|dana|kuzu|domuz|steak|beef|lamb|pork', 'steak'),
    (r'yumurta|muffin|omlet|egg|frittata', 'egg'),
]


def _cue(step: str, recipe_text: str, lang: str) -> str:
    """Adımın (yoksa tarifin) içeriğine göre pişme işaretini seçer."""
    idx = 1 if lang == 'en' else 0
    # 71 °C ölçütü kıyma/köfte içindir; bütün et parçası için 63 °C yazılır.
    ground = re.search(r'\b71\s*°C', step) is not None
    # Adım zaten "en kalın yeri" diyorsa işaret kısa tutulur, yoksa cümlede
    # aynı ifade iki kez geçiyor.
    short = re.search(r'en kalın yer|thickest part', step, re.I) is not None
    for haystack in (step, recipe_text):
        low = haystack.lower()
        for pattern, key in _CONTEXT:
            if re.search(pattern, low):
                if ground and key == 'steak':
                    key = 'mince'
                cue = CUES[key][idx]
                if short and key == 'poultry':
                    cue = ('içi tamamen beyaz olana kadar' if idx == 0
                           else 'is white all the way through')
                return cue
    return CUES['default'][idx]


# Yalnızca "iç sıcaklık" anlatan kalıplar. Fırın/su sıcaklıkları dokunulmaz:
# bunların hepsi 60-80 °C aralığındaki iç sıcaklık ifadeleri.
# Sayı sınırı şart: "180°C" içindeki "80°C" yakalanırsa fırın sıcaklığı
# bozulur ("Fırını 1 ... 'ye ısıtın").
_T = r'(?<!\d)(?:6[0-9]|7[0-9]|8[0-5])\s*°C'

# Önce cümle yapısını bozmadan çevrilebilen özel kalıplar. Buradaki
# değişiklikler sabit metinlidir; kalanlar aşağıda gözle görülür işaretle
# değiştirilir.
TR_SPECIAL = [
    (rf"etin merkezinin en az {_T}(?:'ye|'ya)?\s*ulaşmasını ve dokusunun "
     rf"yumuşamasını sağlayın",
     'eti çatalla kolayca ayrılacak kadar yumuşatın'),
    (rf"iç dolgusu {_T}(?:'ye|'ya)? ulaşmalı(?:dır)?",
     'içi tamamen pişmiş olmalı'),
    # "içleri opaklaşana ve 63°C'ye ulaşana kadar" → "içleri opaklaşana kadar"
    (rf"(\w+[ae]n[ae])\s+ve\s+(?:merkez\w*\s*)?(?:sıcaklığı\s*)?"
     rf"(?:en az\s*)?{_T}(?:'ye|'ya)?\s*ulaşana kadar", r'\1 kadar'),
    # "Merkezi 71°C'ye ulaşana ve tamamen katılaşana kadar" → ikinci işaret
    (rf"merkez\w*\s*(?:sıcaklığı\s*)?(?:en az\s*)?{_T}(?:'ye|'ya)?"
     rf"\s*ulaşana ve\s+", ''),
    (rf"merkez\w*\s*(?:sıcaklığı\s*)?(?:en az\s*)?{_T}(?:'ye|'ya)?"
     rf"\s*ulaşıp\s+", ''),
    (rf"\w+(?:ın|in|un|ün|nın|nin|nun|nün)\s+merkez\w*\s*"
     rf"(?:sıcaklığı\s*)?(?:en az\s*)?{_T}(?:'ye|'ya)?"
     rf"\s*ulaş(?:tığında|ınca)", 'iyice pişince'),
    (rf"(?:merkez\w*\s*)?(?:sıcaklığı\s*)?(?:en az\s*)?{_T}(?:'ye|'ya)?"
     rf"\s*ulaştığında", 'iyice pişince'),
    (rf"(?:merkez\w*\s*)?(?:sıcaklığı\s*)?(?:en az\s*)?{_T}(?:'ye|'ya)?"
     rf"\s*ulaşınca", 'iyice pişince'),
    (rf"{_T}(?:'ye|'ya)?\s*ulaşmış", 'iyice pişmiş'),
    # "Balık 63°C'ye ulaşana ve eti opaklaşıp ... kadar" → ikinci işaret kalır
    (rf"(?:,\s*)?\s*(?:ve\s+)?(?:en az\s*)?{_T}(?:'ye|'ya)?\s*ulaşana ve\s+",
     ' '),
    # "… 74°C'ye ulaştığını kontrol edin" → "… piştiğini kontrol edin"
    (rf"\s*(?:merkez\w*\s*)?{_T}(?:'ye|'ya)?\s*ulaştığını kontrol edin",
     ' iyice piştiğini kontrol edin'),
    (rf"\s*(?:merkez\w*\s*)?(?:sıcaklığı\s*)?(?:en az\s*)?{_T}"
     rf"(?:'ye|'ya)?\s*ulaştığından emin ol",
     ' iyice piştiğinden emin ol'),
    (rf"(?:,\s*)?\s*(?:ve\s+)?(?:en az\s*)?{_T}(?:'ye|'ya)?\s*ulaştırıp",
     '{cue} pişirip'),
    (rf"(?:,\s*)?\s*(?:ve\s+)?(?:en az\s*)?{_T}(?:'ye|'ya)?\s*ulaştır\w*",
     '{cue} pişirin'),
]

EN_SPECIAL = [
    (rf"ensuring the (\w+) reaches at least {_T} and is tender",
     r'until the \1 is tender enough to pull apart with a fork'),
    (rf"the filling in a test dumpling should reach {_T}",
     'the filling should be cooked through'),
    (rf"when the cent(?:re|er) reaches (?:at least\s*)?{_T}",
     'when it is cooked through'),
    (rf"until (\w+) and {_T}", r'until \1'),
    (rf"previously reached {_T}", 'is already cooked'),
    (rf"until the (\w+) reaches (?:at least\s*)?{_T} and", r'until the \1'),
    (rf"confirm the (\w+) reaches (?:at least\s*)?{_T}",
     r'check that the \1 is cooked through'),
    (rf"once (?:the )?[\w ]{{0,20}}?cent(?:re|er) reaches (?:at least\s*)?{_T}",
     'once it is cooked through'),
]

# Geriye kalan sıcaklık ölçütleri gözle görülür işaretle değiştirilir.
_TR_PRE = (r"(?:,\s*)?\s*(?:ve\s+)?(?:merkez\w*\s*)?(?:sıcaklığı\s*)?"
           r"(?:en az\s*)?(?:yaklaşık\s*)?")

TR_CLAUSES = [
    rf"{_TR_PRE}{_T}(?:'ye|'ya)?\s*ulaşana kadar",
    rf"{_TR_PRE}{_T}(?:'ye|'ya)?\s*ulaşıp",
    rf"{_TR_PRE}{_T}(?:'ye|'ya)?\s*ulaşmalı(?:dır)?",
    rf"{_TR_PRE}{_T}",
]

EN_CLAUSES = [
    rf"(?:,\s*)?\s*(?:and\s+)?until (?:its |the )?cent(?:re|er)\s*"
    rf"reaches (?:at least\s*)?{_T}",
    rf"(?:,\s*)?\s*(?:and\s+)?until (?:it|they|the [\w ]{{0,24}}?)\s*"
    rf"reach(?:es)? (?:at least\s*)?{_T}",
    rf"(?:,\s*)?\s*(?:and\s+)?cook to {_T}",
    rf"\s*(?:the |it |they )?[\w ]{{0,24}}?reach(?:es)? (?:at least\s*)?{_T}",
    rf"\s*to (?:at least\s*)?{_T}",
    rf"(?:,\s*)?\s*(?:and\s+)?(?:at least\s*)?{_T}",
]


def _tidy(text: str) -> str:
    text = re.sub(r'\s{2,}', ' ', text)
    text = re.sub(r'\s+([.,;])', r'\1', text)
    text = re.sub(r',\s*,', ',', text)
    text = text.strip()
    if text and text[0].islower():
        text = {'i': 'İ', 'ı': 'I'}.get(text[0], text[0].upper()) + text[1:]
    return text


def plain_language(steps: list[str], recipe_text: str, lang: str) -> list[str]:
    """Adımlardaki iç-sıcaklık ölçütünü gündelik ifadeye çevirir.

    Fırın sıcaklıkları (180-220 °C) dokunulmadan kalır; yalnızca etin
    içindeki sıcaklığı anlatan 60-85 °C aralığı değişir.
    """
    special = EN_SPECIAL if lang == 'en' else TR_SPECIAL
    clauses = EN_CLAUSES if lang == 'en' else TR_CLAUSES
    out = []
    for step in steps:
        if not re.search(_T, step):
            out.append(step)
            continue
        text = step
        cue_text = _cue(step, recipe_text, lang)
        for pattern, repl in special:
            text = re.sub(pattern, repl.replace('{cue}', ' ' + cue_text),
                          text, flags=re.I)
        if re.search(_T, text):
            cue = ' ' + _cue(step, recipe_text, lang)
            if lang == 'en':
                text = re.sub(rf"cook to {_T}", 'cook' + cue, text, flags=re.I)
            for pattern in clauses:
                if not re.search(_T, text):
                    break
                text, n = re.subn(pattern, cue, text, count=1, flags=re.I)
                cue = '' if n else cue
        out.append(_tidy(text))
    return out


# ── 2. Pişirme adımı eksik olan tarifler ─────────────────────────────────
# Bu tariflerin malzemesinde "pişmiş tavuk/somon/hindi" yazıyordu ama etin
# nasıl pişirileceği hiçbir adımda anlatılmıyordu. Adımlar pişirmeden
# başlayacak ve soğutma süresini de verecek şekilde yeniden yazıldı.
# Yöntemler ev tarifi kaynaklarındaki standart uygulamayı izler: eti üzerini
# geçecek suda kısık ateşte hafif fokurdayarak pişirmek, dinlendirmek, sonra
# buzdolabında soğutmak.

STEP_OVERRIDES: dict[str, dict[str, list[str]]] = {
    # Hindili Waldorf Salatası
    'l070': {
        'tr': [
            'Hindi göğsünü geniş bir tencereye koyup üzerini geçecek kadar '
            'soğuk su ekleyin.',
            'Suyu orta ateşte ısıtın; kaynamaya yakın, yüzeyi hafif '
            'titreşirken ateşi kısın ve kapağı kapatarak 12-15 dakika '
            'pişirin.',
            'En kalın yerinden kestiğinizde içi tamamen beyaz olmalı; '
            'pembe kalırsa 2-3 dakika daha pişirin.',
            'Hindiyi sudan alıp tabakta 10 dakika dinlendirin, ardından '
            'buzdolabında en az 30 dakika soğutun.',
            'Soğuyan hindiyi kuşbaşı doğrayın; elma ve kerevizi küp, '
            'üzümleri ikiye kesin, cevizi iri kıyın.',
            'Yoğurt ile limon suyunu çırpın; hindi, elma, üzüm, kereviz ve '
            'cevizi ekleyip karıştırın.',
            'Marul yapraklarını yıkayıp kurulayın ve salatayı üzerine alarak '
            'soğuk servis edin.',
        ],
        'en': [
            'Put the turkey breast in a wide pan and cover it with cold '
            'water.',
            'Heat over medium heat; as soon as the surface begins to '
            'tremble, lower the heat, cover and cook for 12-15 minutes.',
            'The thickest part should be white all the way through when cut; '
            'give it 2-3 minutes more if any pink remains.',
            'Lift the turkey out, rest it on a plate for 10 minutes, then '
            'chill it in the fridge for at least 30 minutes.',
            'Dice the cooled turkey; cube the apple and celery, halve the '
            'grapes and roughly chop the walnuts.',
            'Whisk the Turkish yogurt with the lemon juice, then fold in the '
            'turkey, apple, grapes, celery and walnuts.',
            'Wash and dry the lettuce leaves and serve the salad chilled on '
            'top of them.',
        ],
    },
    # Somonlu Poke Esintili Kase
    'l053': {
        'tr': [
            'Somonu yapışmaz tavada orta ateşte her yüzü 3-4 dakika, çatalla '
            'bastırınca kolayca pul pul ayrılana kadar pişirin.',
            'Balığı tabağa alıp buzdolabında 15 dakika soğutun, sonra iri '
            'parçalara ayırın.',
            'Edamameyi kaynar suda 3-4 dakika haşlayıp süzün ve soğuk suyla '
            'durulayın.',
            'Pirinci pirinç sirkesiyle karıştırın; salatalık ve havucu ince '
            'şerit, avokadoyu dilim doğrayın.',
            'Pirinci kasenin tabanına yayıp somon, edamame ve sebzeleri ayrı '
            'bölümler hâlinde dizin.',
            'Üzerine soya sosu gezdirip susam serperek servis edin.',
        ],
        'en': [
            'Cook the salmon in a non-stick pan over medium heat for 3-4 '
            'minutes a side, until it flakes easily when pressed with a '
            'fork.',
            'Move it to a plate, chill for 15 minutes in the fridge, then '
            'break it into large pieces.',
            'Boil the edamame for 3-4 minutes, drain and rinse under cold '
            'water.',
            'Mix the rice with the rice vinegar; cut the cucumber and carrot '
            'into thin strips and slice the avocado.',
            'Spread the rice over the base of a bowl and arrange the salmon, '
            'edamame and vegetables in separate sections.',
            'Drizzle with the soy sauce, scatter over the sesame seeds and '
            'serve.',
        ],
    },
    # Somonlu Krem Peynirli Bagel Sandviç
    'l068': {
        'tr': [
            'Somonu yapışmaz tavada orta ateşte her yüzü 3-4 dakika, çatalla '
            'bastırınca kolayca pul pul ayrılana kadar pişirin.',
            'Balığı 15 dakika buzdolabında soğutup iri parçalara ayırın.',
            "Bagel'ı ikiye kesip iç yüzlerine krem peynir sürün.",
            'Salatalığı ince dilimleyin, kırmızı soğanı ince doğrayın, '
            'dereotunu kıyın.',
            'Somon, salatalık ve soğanı alt yarıya dizip limon suyu sıkın.',
            'Dereotunu serpip bagelin üst yarısını kapatın ve hemen servis '
            'edin.',
        ],
        'en': [
            'Cook the salmon in a non-stick pan over medium heat for 3-4 '
            'minutes a side, until it flakes easily when pressed with a '
            'fork.',
            'Chill it for 15 minutes in the fridge, then break it into large '
            'pieces.',
            'Split the bagel and spread cream cheese over both cut sides.',
            'Slice the cucumber thinly, finely chop the red onion and chop '
            'the dill.',
            'Layer the salmon, cucumber and onion on the bottom half and '
            'squeeze over the lemon juice.',
            'Scatter with dill, close the bagel and serve immediately.',
        ],
    },
    # Tavuklu Humuslu Mini Dürüm
    's051': {
        'tr': [
            'Tavuk göğsünü küçük bir tencereye koyup üzerini geçecek kadar '
            'soğuk su ekleyin.',
            'Suyu kaynamaya yakın ısıtıp ateşi kısın; kapağı kapatarak 10-12 '
            'dakika, kestiğinizde içi tamamen beyaz olana kadar pişirin.',
            'Tavuğu sudan alıp 5 dakika dinlendirin, buzdolabında 20 dakika '
            'soğutun ve ince şerit doğrayın.',
            'Tortillaya humusu sürüp limon suyu gezdirin.',
            'Havuç ve salatalığı ince şerit doğrayın, marulu kıyın.',
            'Tavuk ve sebzeleri tortillanın ortasına yerleştirin.',
            'Yanları içe katlayıp sıkıca sarın; ikiye kesip hemen servis '
            'edin.',
        ],
        'en': [
            'Put the chicken breast in a small pan and cover it with cold '
            'water.',
            'Bring it close to a boil, lower the heat, cover and cook for '
            '10-12 minutes, until the thickest part is white all the way '
            'through.',
            'Lift it out, rest for 5 minutes, chill for 20 minutes in the '
            'fridge and cut into thin strips.',
            'Spread the hummus over the tortilla and add the lemon juice.',
            'Cut the carrot and cucumber into thin strips and shred the '
            'lettuce.',
            'Place the chicken and vegetables down the centre of the '
            'tortilla.',
            'Fold in the sides, roll it tightly, cut in half and serve '
            'immediately.',
        ],
    },
    # Tavuklu Sezar Marul Lokmaları
    's064': {
        'tr': [
            'Tavuk göğsünü küçük bir tencereye koyup üzerini geçecek kadar '
            'soğuk su ekleyin.',
            'Kaynamaya yakın ısıtıp ateşi kısın; kapağı kapatarak 10-12 '
            'dakika, kestiğinizde içi tamamen beyaz olana kadar pişirin.',
            'Tavuğu 5 dakika dinlendirip buzdolabında 20 dakika soğutun, '
            'sonra küçük küpler hâlinde doğrayın.',
            'Yoğurt, çatalla ezilmiş ançüez ve limon suyunu çırpıp sosu '
            'hazırlayın.',
            'Tavuğu sosla karıştırın.',
            'Marul yapraklarını yıkayıp kurulayın ve tavuğu yapraklara '
            'paylaştırın.',
            'Üzerine rendelenmiş Parmesan ve kruton serpip hemen servis '
            'edin.',
        ],
        'en': [
            'Put the chicken breast in a small pan and cover it with cold '
            'water.',
            'Bring it close to a boil, lower the heat, cover and cook for '
            '10-12 minutes, until the thickest part is white all the way '
            'through.',
            'Rest it for 5 minutes, chill for 20 minutes in the fridge, then '
            'cut into small cubes.',
            'Whisk the Turkish yogurt, the anchovy mashed with a fork and '
            'the lemon juice into a dressing.',
            'Toss the chicken through the dressing.',
            'Wash and dry the lettuce leaves and divide the chicken among '
            'them.',
            'Scatter over the grated Parmesan and croutons and serve '
            'immediately.',
        ],
    },
    # Somonlu Krem Peynirli Çavdar Kanepeler
    's074': {
        'tr': [
            'Somonu yapışmaz tavada orta ateşte her yüzü 3-4 dakika, çatalla '
            'bastırınca kolayca pul pul ayrılana kadar pişirin.',
            'Balığı buzdolabında 15 dakika soğutup küçük parçalara ayırın.',
            'Çavdar krakerlerin üzerine krem peynir sürün.',
            'Salatalığı ince dilimleyin.',
            'Her krakere somon ve salatalık paylaştırın.',
            'Dereotuyla tamamlayıp hemen servis edin.',
        ],
        'en': [
            'Cook the salmon in a non-stick pan over medium heat for 3-4 '
            'minutes a side, until it flakes easily when pressed with a '
            'fork.',
            'Chill it for 15 minutes in the fridge and break it into small '
            'pieces.',
            'Spread cream cheese over the rye crackers.',
            'Slice the cucumber thinly.',
            'Divide the salmon and cucumber among the crackers.',
            'Finish with dill and serve immediately.',
        ],
    },
    # Tavuklu Pestolu Mini Şişler
    's076': {
        'tr': [
            'Tavuk göğsünü küçük bir tencereye koyup üzerini geçecek kadar '
            'soğuk su ekleyin.',
            'Kaynamaya yakın ısıtıp ateşi kısın; kapağı kapatarak 10-12 '
            'dakika, kestiğinizde içi tamamen beyaz olana kadar pişirin.',
            'Tavuğu 5 dakika dinlendirip buzdolabında 20 dakika soğutun ve '
            'lokmalık kesin.',
            'Mozzarellayı ve domatesi tavukla aynı boyda doğrayın.',
            'Tavuk, mozzarella ve domatesi sırayla altı kısa şişe dizin.',
            'Pestoyu bir tatlı kaşığı suyla inceltip şişlerin üzerine '
            'gezdirin.',
            'Fesleğen yapraklarıyla süsleyip soğuk servis edin.',
        ],
        'en': [
            'Put the chicken breast in a small pan and cover it with cold '
            'water.',
            'Bring it close to a boil, lower the heat, cover and cook for '
            '10-12 minutes, until the thickest part is white all the way '
            'through.',
            'Rest it for 5 minutes, chill for 20 minutes in the fridge and '
            'cut into bite-sized pieces.',
            'Cut the mozzarella and tomato to the same size as the chicken.',
            'Thread the chicken, mozzarella and tomato onto six short '
            'skewers.',
            'Loosen the pesto with a teaspoon of water and drizzle it over '
            'the skewers.',
            'Garnish with basil leaves and serve chilled.',
        ],
    },
    # Tavuklu Avokadolu Krakerler
    's086': {
        'tr': [
            'Tavuk göğsünü küçük bir tencereye koyup üzerini geçecek kadar '
            'soğuk su ekleyin.',
            'Kaynamaya yakın ısıtıp ateşi kısın; kapağı kapatarak 10-12 '
            'dakika, kestiğinizde içi tamamen beyaz olana kadar pişirin.',
            'Tavuğu 5 dakika dinlendirip buzdolabında 20 dakika soğutun, '
            'sonra küçük doğrayın.',
            'Avokadoyu limon suyuyla ezip krakerlere yayın.',
            'Domatesi küçük küpler hâlinde doğrayın.',
            'Tavuk ve domatesi krakerlere paylaştırıp hemen servis edin.',
        ],
        'en': [
            'Put the chicken breast in a small pan and cover it with cold '
            'water.',
            'Bring it close to a boil, lower the heat, cover and cook for '
            '10-12 minutes, until the thickest part is white all the way '
            'through.',
            'Rest it for 5 minutes, chill for 20 minutes in the fridge, then '
            'dice it small.',
            'Mash the avocado with the lemon juice and spread it over the '
            'crackers.',
            'Cut the tomato into small cubes.',
            'Divide the chicken and tomato among the crackers and serve '
            'immediately.',
        ],
    },
}


def rewrite(code: str, steps_tr: list[str], steps_en: list[str],
            recipe_text_tr: str, recipe_text_en: str):
    """Bir tarifin adımlarını gündelik dile çeker."""
    override = STEP_OVERRIDES.get(code.lower())
    if override:
        return list(override['tr']), list(override['en'])
    return (plain_language(steps_tr, recipe_text_tr, 'tr'),
            plain_language(steps_en, recipe_text_en, 'en'))

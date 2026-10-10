import '../core/turkish_string_helper.dart';
import '../data/mock_ingredients.dart';
import '../models/recipe.dart';

/// Guesses which of a recipe's ingredients each step uses, from the step
/// wording in both languages.
///
/// Bundled recipes do not rely on this at runtime: `tool/step_ingredients.dart`
/// runs it once, a person reviews the result, and it is stored in the JSON as
/// `stepIngredients`. The app only falls back to it for recipes without that
/// field (the user's own recipes).
List<List<String>> matchStepIngredients(Recipe recipe) => [
  for (final mentions in _stepMentions(recipe))
    _ordered(recipe.ingredientIds, {
      for (final ids in mentions) ...ids.where(recipe.ingredientIds.contains),
    }),
];

/// Catalog ingredients a step names that the recipe does not list, one per
/// mention, keyed by step index. A mention shared with a listed ingredient
/// ("peynir" when the recipe has feta) is not reported.
Map<int, Set<String>> unlistedStepMentions(Recipe recipe) {
  final out = <int, Set<String>>{};
  final mentions = _stepMentions(recipe);
  for (var i = 0; i < mentions.length; i++) {
    for (final ids in mentions[i]) {
      if (ids.any(recipe.ingredientIds.contains)) continue;
      (out[i] ??= {}).add(ids.first);
    }
  }
  return out;
}

/// Per step, every mention in either language as the set of catalog ids
/// that phrase can mean.
List<List<Set<String>>> _stepMentions(Recipe recipe) {
  final tr = recipe.steps['tr'] ?? const <String>[];
  final en = recipe.steps['en'] ?? const <String>[];
  final count = tr.length > en.length ? tr.length : en.length;
  final patterns = _patternsFor(recipe.ingredientIds);
  return [
    for (var i = 0; i < count; i++)
      [
        if (i < tr.length) ..._matchStep(tr[i], patterns['tr']!, turkish: true),
        if (i < en.length)
          ..._matchStep(en[i], patterns['en']!, turkish: false),
      ],
  ];
}

/// Keeps the recipe's own ingredient order so chips read like the list.
List<String> _ordered(List<String> ingredientIds, Set<String> found) => [
  for (final id in ingredientIds)
    if (found.contains(id)) id,
];

/// Extra ways a step refers to an ingredient besides its catalog name.
/// Only words a recipe step actually uses; checked by the tool's report.
const Map<String, Map<String, List<String>>> _aliases = {
  'chicken_breast': {
    'tr': ['tavuk'],
    'en': ['chicken'],
  },
  'chicken_thigh': {
    'tr': ['tavuk'],
    'en': ['chicken', 'thighs'],
  },
  'ground_beef': {
    'tr': ['kıyma', 'dana kıyma'],
    'en': ['beef', 'minced beef'],
  },
  'ground_turkey': {
    'tr': ['kıyma', 'hindi'],
    'en': ['turkey', 'minced turkey'],
  },
  'beef_steak': {
    'tr': ['bonfile', 'dana'],
    'en': ['steak', 'beef'],
  },
  'lamb': {
    'tr': ['kuzu'],
    'en': ['lamb'],
  },
  'tuna': {
    'tr': ['ton'],
    'en': ['tuna'],
  },
  'cod': {
    'tr': ['morina', 'balık'],
    'en': ['fish'],
  },
  'sea_bass': {
    'tr': ['balık'],
    'en': ['fish'],
  },
  'sardine': {
    'tr': ['balık'],
    'en': ['sardines', 'fish'],
  },
  'salmon': {
    'tr': ['balık'],
    'en': ['fish'],
  },
  'eggs': {
    'tr': ['yumurta'],
    'en': ['egg'],
  },
  'cheddar_cheese': {
    'tr': ['kaşar', 'peynir'],
    'en': ['cheddar', 'cheese'],
  },
  'feta_cheese': {
    'tr': ['peynir', 'beyaz peynir'],
    'en': ['feta', 'cheese'],
  },
  'cottage_cheese': {
    'tr': ['lor', 'peynir'],
    'en': ['cottage cheese'],
  },
  'cream_cheese': {
    'tr': ['krem peynir', 'peynir'],
    'en': ['cream cheese'],
  },
  'greek_yogurt': {
    'tr': ['yoğurt'],
    'en': ['yogurt', 'yoghurt'],
  },
  'yogurt': {
    'en': ['yoghurt'],
  },
  'cream': {
    'tr': ['krema'],
    'en': ['cream'],
  },
  'white_rice': {
    'tr': ['pirinç'],
    'en': ['rice'],
  },
  'flour': {
    'tr': ['un'],
    'en': ['flour'],
  },
  'bread': {
    'tr': ['ekmek'],
    'en': ['bread'],
  },
  'pita_bread': {
    'tr': ['pide', 'ekmek'],
    'en': ['pita', 'bread'],
  },
  'tortilla_wrap': {
    'tr': ['tortilla', 'lavaş'],
    'en': ['tortilla'],
  },
  'noodle': {
    'tr': ['erişte', 'noodle', 'pirinç noodle'],
    'en': ['noodles', 'rice noodles'],
  },
  'phyllo_dough': {
    'tr': ['yufka'],
    'en': ['phyllo', 'filo'],
  },
  'oats': {
    'tr': ['yulaf'],
    'en': ['oat', 'oats'],
  },
  'cornmeal': {
    'tr': ['mısır unu'],
    'en': ['cornmeal', 'polenta'],
  },
  'bell_pepper': {
    'tr': ['biber', 'kapya', 'dolmalık biber', 'yeşil biber', 'kırmızı biber'],
    'en': ['peppers', 'bell pepper', 'red pepper', 'green pepper'],
  },
  'hot_pepper': {
    'tr': ['acı biber', 'sivri'],
    'en': ['chilli', 'chili'],
  },
  'black_pepper': {
    'tr': ['karabiber'],
    'en': ['pepper', 'black pepper'],
  },
  'paprika': {
    'tr': ['toz biber', 'kırmızı toz biber', 'kırmızı biber'],
    'en': ['paprika'],
  },
  'red_pepper_flakes': {
    'tr': ['pul biber'],
    'en': ['chilli flakes', 'chili flakes', 'pepper flakes'],
  },
  'spring_onion': {
    'tr': ['yeşil soğan', 'taze soğan'],
    'en': ['spring onion', 'scallion', 'green onion'],
  },
  'red_onion': {
    'tr': ['kırmızı soğan', 'soğan'],
    'en': ['red onion', 'onion'],
  },
  'tomato_paste': {
    'tr': ['salça', 'domates salçası'],
    'en': ['tomato paste'],
  },
  'zucchini': {
    'tr': ['kabak'],
    'en': ['zucchini', 'courgette'],
  },
  'eggplant': {
    'tr': ['patlıcan'],
    'en': ['eggplant', 'aubergine'],
  },
  'green_beans': {
    'tr': ['fasulye'],
    'en': ['beans'],
  },
  'peas': {
    'tr': ['bezelye'],
    'en': ['peas'],
  },
  'lettuce': {
    'tr': ['marul'],
    'en': ['lettuce'],
  },
  'kale': {
    'tr': ['kara lahana', 'lahana'],
    'en': ['kale'],
  },
  'swiss_chard': {
    'tr': ['pazı'],
    'en': ['chard'],
  },
  'ginger': {
    'tr': ['zencefil'],
    'en': ['ginger'],
  },
  'lime': {
    'tr': ['misket limonu', 'lime'],
    'en': ['lime'],
  },
  'lemon': {
    'tr': ['limon'],
    'en': ['lemon'],
  },
  'blueberry': {
    'tr': ['yaban mersini'],
    'en': ['blueberries', 'berries'],
  },
  'raspberry': {
    'tr': ['ahududu'],
    'en': ['raspberries', 'berries'],
  },
  'strawberry': {
    'tr': ['çilek'],
    'en': ['strawberries', 'berries'],
  },
  'dates': {
    'tr': ['hurma'],
    'en': ['dates', 'date'],
  },
  'coconut': {
    'tr': ['hindistancevizi', 'hindistan cevizi'],
    'en': ['coconut'],
  },
  'mint': {
    'tr': ['nane'],
    'en': ['mint'],
  },
  'thyme': {
    'tr': ['kekik'],
    'en': ['thyme'],
  },
  'oregano': {
    'tr': ['kekik'],
    'en': ['oregano'],
  },
  'coriander': {
    'tr': ['kişniş'],
    'en': ['coriander', 'cilantro'],
  },
  'curry_powder': {
    'tr': ['köri'],
    'en': ['curry'],
  },
  'olive_oil': {
    'tr': ['zeytinyağ', 'yağ'],
    'en': ['olive oil', 'oil'],
  },
  'sunflower_oil': {
    'tr': ['ayçiçek yağı', 'yağ'],
    'en': ['oil'],
  },
  'coconut_oil': {
    'tr': ['hindistancevizi yağı', 'hindistan cevizi yağı', 'yağ'],
    'en': ['oil'],
  },
  'sesame_oil': {
    'tr': ['susam yağı', 'yağ'],
    'en': ['sesame oil', 'oil'],
  },
  'butter': {
    'tr': ['tereyağ'],
    'en': ['butter'],
  },
  'pistachio': {
    'tr': ['antep fıstığı', 'fıstık', 'kuruyemiş'],
    'en': ['pistachios', 'nuts'],
  },
  'peanut': {
    'tr': ['yer fıstığı', 'fıstık', 'kuruyemiş'],
    'en': ['peanuts', 'nuts'],
  },
  'pine_nut': {
    'tr': ['çam fıstığı'],
    'en': ['pine nuts'],
  },
  'walnut': {
    'tr': ['ceviz', 'kuruyemiş'],
    'en': ['walnuts', 'nuts'],
  },
  'almond': {
    'tr': ['badem', 'kuruyemiş'],
    'en': ['almonds', 'nuts'],
  },
  'hazelnut': {
    'tr': ['fındık', 'kuruyemiş'],
    'en': ['hazelnuts', 'nuts'],
  },
  'cashew': {
    'tr': ['kaju', 'kuruyemiş'],
    'en': ['cashews', 'nuts'],
  },
  'mixed_nuts': {
    'tr': ['kuruyemiş'],
    'en': ['nuts'],
  },
  'sesame_seeds': {
    'tr': ['susam'],
    'en': ['sesame'],
  },
  'pumpkin_seeds': {
    'tr': ['kabak çekirdeği'],
    'en': ['pumpkin seeds'],
  },
  'flax_seeds': {
    'tr': ['keten'],
    'en': ['flax', 'flaxseed', 'linseed'],
  },
  'chia_seeds': {
    'tr': ['chia'],
    'en': ['chia'],
  },
  'red_lentil': {
    'tr': ['mercimek'],
    'en': ['lentils'],
  },
  'green_lentil': {
    'tr': ['mercimek'],
    'en': ['lentils'],
  },
  'chickpea': {
    'tr': ['nohut'],
    'en': ['chickpeas'],
  },
  'white_bean': {
    'tr': ['fasulye'],
    'en': ['beans'],
  },
  'black_bean': {
    'tr': ['fasulye'],
    'en': ['beans'],
  },
  'kidney_bean': {
    'tr': ['barbunya', 'fasulye'],
    'en': ['beans'],
  },
  'fava_bean': {
    'tr': ['bakla'],
    'en': ['beans', 'broad beans'],
  },
  'edamame': {
    'tr': ['edamame'],
    'en': ['edamame', 'beans'],
  },
  'sugar': {
    'tr': ['şeker'],
    'en': ['sugar'],
  },
  'soy_sauce': {
    'tr': ['soya sosu', 'soya'],
    'en': ['soy'],
  },
  'honey': {
    'tr': ['bal'],
    'en': ['honey'],
  },
  'molasses': {
    'tr': ['pekmez'],
    'en': ['molasses'],
  },
  'pomegranate_molasses': {
    'tr': ['nar ekşisi'],
    'en': ['pomegranate molasses'],
  },
  'peanut_butter': {
    'tr': ['fıstık ezmesi'],
    'en': ['peanut butter'],
  },
  'coconut_milk': {
    'tr': ['hindistancevizi sütü', 'hindistan cevizi sütü'],
    'en': ['coconut milk'],
  },
  'white_vinegar': {
    'tr': ['sirke'],
    'en': ['vinegar'],
  },
  'maple_syrup': {
    'tr': ['akçaağaç', 'şurup'],
    'en': ['maple', 'syrup'],
  },
  'olives': {
    'tr': ['zeytin'],
    'en': ['olives'],
  },
  'dark_chocolate': {
    'tr': ['çikolata'],
    'en': ['chocolate'],
  },
  'chocolate_bar': {
    'tr': ['çikolata'],
    'en': ['chocolate'],
  },
  'dried_fruit': {
    'tr': ['kuru meyve'],
    'en': ['dried fruit'],
  },
  'yeast': {
    'tr': ['maya'],
    'en': ['yeast'],
  },
  'breadcrumbs': {
    'tr': ['galeta'],
    'en': ['breadcrumbs'],
  },
  'cocoa_powder': {
    'tr': ['kakao'],
    'en': ['cocoa'],
  },
  'vanilla': {
    'tr': ['vanilya'],
    'en': ['vanilla'],
  },
  'semolina': {
    'tr': ['irmik'],
    'en': ['semolina'],
  },
  'buckwheat': {
    'tr': ['karabuğday'],
    'en': ['buckwheat'],
  },
  'barley': {
    'tr': ['arpa'],
    'en': ['barley'],
  },
  'liver': {
    'tr': ['ciğer'],
    'en': ['liver'],
  },
  'tofu': {
    'tr': ['tofu'],
    'en': ['tofu'],
  },
  'potato_chips': {
    'tr': ['cips'],
    'en': ['chips'],
  },
  'tortilla_chips': {
    'tr': ['cips', 'nacho'],
    'en': ['chips', 'nachos'],
  },
  'crackers': {
    'tr': ['kraker'],
    'en': ['crackers'],
  },
  'rice_cake': {
    'tr': ['pirinç patlağı'],
    'en': ['rice cakes', 'rice cake'],
  },
  'granola_bar': {
    'tr': ['granola'],
    'en': ['granola'],
  },
};

/// Words that mean "season it": salt and pepper are what the recipe means.
const _seasonWords = {
  'tr': ['baharatla'],
  'en': ['season', 'seasoned', 'seasoning'],
};
const _seasonIds = {'salt', 'black_pepper'};

typedef _Pattern = ({String id, List<String> words});

/// Every catalog ingredient's phrases, so a mention of an ingredient the
/// recipe does not list ("toz biber" in a recipe with only bell pepper)
/// still claims its words instead of falling to a shorter look-alike.
final Map<String, List<_Pattern>> _catalogPatterns = () {
  final out = <String, List<_Pattern>>{'tr': [], 'en': []};
  for (final ingredient in mockIngredients) {
    final id = ingredient.id;
    for (final lang in const ['tr', 'en']) {
      final phrases = <String>{
        if (ingredient.name[lang] case final name?) name,
        ...?_aliases[id]?[lang],
        if (_seasonIds.contains(id)) ...?_seasonWords[lang],
      };
      for (final phrase in phrases) {
        final words = _words(phrase, turkish: lang == 'tr');
        if (words.isEmpty) continue;
        out[lang]!.add((id: id, words: words));
        // Turkish compounds mark the head ("çam fıstığı"); in a step the
        // head takes other endings ("çam fıstıklarını"), so match its stem.
        if (lang == 'tr' && words.length > 1) {
          final head = _compoundStem(words.last);
          if (head != null) {
            out[lang]!.add((
              id: id,
              words: [...words.take(words.length - 1), head],
            ));
          }
        }
        // Catalog names are often plural ("Eggs", "Oats"); steps say "egg".
        if (lang == 'en' && words.last.length > 3 && words.last.endsWith('s')) {
          out[lang]!.add((
            id: id,
            words: [
              ...words.take(words.length - 1),
              words.last.substring(0, words.last.length - 1),
            ],
          ));
        }
      }
    }
  }
  for (final list in out.values) {
    list.sort((a, b) {
      final byWords = b.words.length.compareTo(a.words.length);
      if (byWords != 0) return byWords;
      return b.words.join().length.compareTo(a.words.join().length);
    });
  }
  return out;
}();

/// In English "pepper" alone means black pepper only when the recipe has no
/// fresh pepper it could mean instead.
Map<String, List<_Pattern>> _patternsFor(List<String> ingredientIds) {
  final freshPepper =
      ingredientIds.contains('bell_pepper') ||
      ingredientIds.contains('hot_pepper');
  return {
    'tr': _catalogPatterns['tr']!,
    'en': [
      for (final p in _catalogPatterns['en']!)
        if (!(freshPepper &&
            p.id == 'black_pepper' &&
            p.words.join() == 'pepper'))
          p,
    ],
  };
}

/// "fıstığı" → "fıstık", "salçası" → "salça", "unu" → "un". Null when
/// the word carries no compound ending.
String? _compoundStem(String word) {
  String? stem;
  for (final ending in const ['sı', 'si', 'su', 'sü', 'ı', 'i', 'u', 'ü']) {
    if (word.length > ending.length + 1 && word.endsWith(ending)) {
      stem = word.substring(0, word.length - ending.length);
      break;
    }
  }
  if (stem == null) return null;
  const hardened = {'ğ': 'k', 'b': 'p', 'd': 't', 'c': 'ç'};
  final last = stem[stem.length - 1];
  if (hardened[last] case final hard?) {
    stem = stem.substring(0, stem.length - 1) + hard;
  }
  return stem.length >= 2 ? stem : null;
}

/// Words that start like an ingredient but describe texture or size.
const _lookAlikes = {'kremamsı', 'kremamsıyken', 'kremsi'};

final _letters = RegExp(r'\p{L}+', unicode: true);

List<String> _words(String text, {required bool turkish}) {
  final lower = turkish
      ? TurkishStringHelper.toLowerCaseTr(text)
      : text.toLowerCase();
  return [for (final m in _letters.allMatches(lower)) m.group(0)!];
}

/// Longer phrases win: "kırmızı soğan" claims its words before "soğan"
/// can, so a recipe with both onions does not tick both on one mention.
/// Returns one id set per mention; equally long phrases on the same words
/// ("fasulye" for two beans) share it.
List<Set<String>> _matchStep(
  String step,
  List<_Pattern> patterns, {
  required bool turkish,
}) => [
  // A phrase never spans punctuation: "sarımsak, toz biber" is garlic and
  // paprika, not garlic powder.
  for (final clause in step.split(_clauseBreak))
    ..._matchClause(clause, patterns, turkish: turkish),
];

final _clauseBreak = RegExp(r'[,.;:!?()—–/]');

List<Set<String>> _matchClause(
  String clause,
  List<_Pattern> patterns, {
  required bool turkish,
}) {
  final words = _words(clause, turkish: turkish);
  final owner = List<Set<String>?>.filled(words.length, null);
  final ownerLen = List<int>.filled(words.length, 0);
  final mentions = <Set<String>>[];
  for (final p in patterns) {
    for (var start = 0; start + p.words.length <= words.length; start++) {
      if (!_phraseAt(words, start, p.words, turkish: turkish)) continue;
      final end = start + p.words.length;
      final taken = owner[start];
      if (taken != null &&
          ownerLen[start] == p.words.length &&
          owner[end - 1] == taken) {
        taken.add(p.id);
        continue;
      }
      var free = true;
      for (var k = start; k < end; k++) {
        if (owner[k] != null) free = false;
      }
      if (!free) continue;
      final ids = {p.id};
      mentions.add(ids);
      for (var k = start; k < end; k++) {
        owner[k] = ids;
        ownerLen[k] = p.words.length;
      }
    }
  }
  return mentions;
}

bool _phraseAt(
  List<String> words,
  int start,
  List<String> phrase, {
  required bool turkish,
}) {
  for (var j = 0; j < phrase.length; j++) {
    final word = words[start + j];
    final last = j == phrase.length - 1;
    // Turkish compounds inflect the head too ("domates salçasını"), so
    // every word may carry a suffix; English only pluralizes the last.
    final ok = turkish
        ? _trForm(word, phrase[j])
        : (last ? _enForm(word, phrase[j]) : word == phrase[j]);
    if (!ok) return false;
  }
  return true;
}

const _trSuffixes = {
  '',
  'u',
  'ü',
  'ı',
  'i',
  'yu',
  'yü',
  'yı',
  'yi',
  'nu',
  'nü',
  'nı',
  'ni',
  'a',
  'e',
  'ya',
  'ye',
  'na',
  'ne',
  'la',
  'le',
  'yla',
  'yle',
  'da',
  'de',
  'ta',
  'te',
  'dan',
  'den',
  'tan',
  'ten',
  'lu',
  'lü',
  'lı',
  'li',
  'un',
  'ün',
  'ın',
  'in',
  'nun',
  'nın',
  'nin',
  'lar',
  'ler',
  'ları',
  'leri',
  'larla',
  'lerle',
  'ların',
  'lerin',
  'sı',
  'si',
  'su',
  'sü',
  'sını',
  'sini',
  'sunu',
  'sünü',
};

const _softened = {'k': 'ğ', 'ç': 'c', 'p': 'b', 't': 'd'};

bool _trForm(String word, String base) {
  if (word == base) return true;
  if (_lookAlikes.contains(word)) return false;
  final stems = [
    base,
    // Only longer stems soften: "et" → "ed" would match "edin" (serve).
    if (base.length >= 4)
      if (_softened[base[base.length - 1]] case final soft?)
        base.substring(0, base.length - 1) + soft,
  ];
  for (final stem in stems) {
    if (!word.startsWith(stem)) continue;
    final rest = word.substring(stem.length);
    // Short stems ("un", "bal", "et") collide with unrelated words
    // ("uzun", "balık", "ete" vs "eti"): accept only a known case ending.
    if (base.length <= 4) {
      if (_trSuffixes.contains(rest)) return true;
    } else {
      return true;
    }
  }
  return false;
}

bool _enForm(String word, String base) {
  if (word == base || word == '${base}s' || word == '${base}es') return true;
  if (base.endsWith('y') &&
      word == '${base.substring(0, base.length - 1)}ies') {
    return true;
  }
  return false;
}

/// What the screens show per step: the reviewed data when it lines up with
/// the steps, otherwise a guess (the user's own recipes have no data).
List<List<String>> stepIngredientsFor(Recipe recipe) {
  final stored = recipe.stepIngredients;
  final stepCount =
      (recipe.steps['tr'] ?? recipe.steps['en'] ?? const <String>[]).length;
  if (stored.isNotEmpty && stored.length == stepCount) return stored;
  return matchStepIngredients(recipe);
}

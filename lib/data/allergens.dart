/// The allergen vocabulary, in one place.
///
/// Recipe `allergenTags`, ingredient `allergenTags` and the allergen chips in
/// the profile all have to speak the same words: the hard filter compares tags
/// literally, so a recipe tagged with something the profile cannot select —
/// "tree_nuts" instead of "nuts" — passes straight through the nut filter.
/// Twelve recipes shipped that way. The data report now fails on any tag that
/// is not in here.
const Map<String, Map<String, String>> allergenLabels = {
  'gluten': {'en': 'Gluten', 'tr': 'Gluten'},
  'dairy': {'en': 'Dairy / Lactose', 'tr': 'Süt Ürünleri / Laktoz'},
  'eggs': {'en': 'Eggs', 'tr': 'Yumurta'},
  'nuts': {'en': 'Tree Nuts', 'tr': 'Kabuklu Yemişler'},
  'peanuts': {'en': 'Peanuts', 'tr': 'Yer Fıstığı'},
  'fish': {'en': 'Fish', 'tr': 'Balık'},
  'shellfish': {'en': 'Shellfish', 'tr': 'Kabuklu Deniz Ürünleri'},
  'soy': {'en': 'Soy', 'tr': 'Soya'},
  'sesame': {'en': 'Sesame', 'tr': 'Susam'},
  'mustard': {'en': 'Mustard', 'tr': 'Hardal'},
};

Set<String> get knownAllergenTags => allergenLabels.keys.toSet();

String localizedAllergen(String tag, String locale) =>
    allergenLabels[tag]?[locale] ?? allergenLabels[tag]?['en'] ?? tag;

import '../core/enums.dart';
import '../l10n/app_localizations.dart';
import '../models/recipe.dart';

/// Kitchen measures read as words ("1 yemek kaşığı", "2 cloves"); metric
/// ones keep their symbol ("150 g").
const _metric = {QuantityUnit.g, QuantityUnit.ml, QuantityUnit.L};

const _fractions = {25: '¼', 33: '⅓', 50: '½', 67: '⅔', 75: '¾'};

/// A per-serving amount with a localized unit, e.g. "150 g", "½ adet",
/// "1 yemek kaşığı", "2 cloves". Null when the recipe declares no amount.
String? formatQuantity(IngredientQuantity? quantity, AppLocalizations l10n) {
  if (quantity == null || quantity.amount <= 0) return null;
  final amount = quantity.amount;
  final unit = quantity.unit;
  if (_metric.contains(unit)) {
    return '${_number(amount)} ${l10n.localizedUnit(unit.name)}';
  }
  var word = l10n.localizedUnitFull(unit.name);
  // Turkish keeps the noun singular after a number; English does not.
  if (l10n.locale.languageCode == 'en' && amount > 1) {
    word = word.endsWith('ch') ? '${word}es' : '${word}s';
  }
  return '${_kitchenNumber(amount)} $word';
}

String _number(double amount) => amount == amount.roundToDouble()
    ? amount.toInt().toString()
    : amount.toStringAsFixed(1);

/// Spoons and pieces read as fractions: 0.5 → "½", 1.5 → "1½".
String _kitchenNumber(double amount) {
  final whole = amount.floor();
  final fraction = _fractions[((amount - whole) * 100).round()];
  if (fraction == null) return _number(amount);
  return whole == 0 ? fraction : '$whole$fraction';
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/quantity_format.dart';

void main() {
  final tr = AppLocalizations(const Locale('tr'));
  final en = AppLocalizations(const Locale('en'));
  String? f(double amount, QuantityUnit unit, AppLocalizations l10n) =>
      formatQuantity(IngredientQuantity(amount: amount, unit: unit), l10n);

  test('Turkish UI never shows the raw English unit name', () {
    // The cooking screen printed "1 tablespoon", "2 clove" in Turkish.
    expect(f(1, QuantityUnit.tablespoon, tr), '1 yemek kaşığı');
    expect(f(2, QuantityUnit.clove, tr), '2 diş');
    expect(f(1, QuantityUnit.pinch, tr), '1 tutam');
    expect(f(150, QuantityUnit.g, tr), '150 g');
    expect(f(200, QuantityUnit.ml, tr), '200 ml');
  });

  test('kitchen measures read as fractions, metric keeps decimals', () {
    expect(f(.5, QuantityUnit.piece, tr), '½ adet');
    expect(f(1.5, QuantityUnit.tablespoon, tr), '1½ yemek kaşığı');
    expect(f(.25, QuantityUnit.teaspoon, tr), '¼ çay kaşığı');
    expect(f(7.5, QuantityUnit.g, tr), '7.5 g');
  });

  test('English pluralises after a number above one', () {
    expect(f(2, QuantityUnit.clove, en), '2 cloves');
    expect(f(2, QuantityUnit.pinch, en), '2 pinches');
    expect(f(1, QuantityUnit.tablespoon, en), '1 tablespoon');
    expect(f(.5, QuantityUnit.piece, en), '½ piece');
  });

  test('no amount, no text', () {
    expect(formatQuantity(null, tr), isNull);
    expect(f(0, QuantityUnit.g, tr), isNull);
  });
}

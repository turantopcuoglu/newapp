import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/step_ingredient_matcher.dart';
import 'package:nutri_guide/services/step_timer.dart';

Recipe _recipe(
  List<String> ids, {
  List<String> tr = const [],
  List<String> en = const [],
}) => Recipe(
  id: 'x',
  name: const {'tr': 'x', 'en': 'x'},
  description: const {},
  ingredientIds: ids,
  steps: {'tr': tr, 'en': en},
);

void main() {
  group('step durations', () {
    test('reads single values, ranges and units in both languages', () {
      expect(parseStepDurations('12-15 dakika pişirin.'), [
        const StepDuration(12, StepTimeUnit.minute, to: 15),
      ]);
      expect(parseStepDurations('Roast for 12–15 minutes.'), [
        const StepDuration(12, StepTimeUnit.minute, to: 15),
      ]);
      expect(parseStepDurations('Yüksek devirde 45 saniye çekin.'), [
        const StepDuration(45, StepTimeUnit.second),
      ]);
      expect(parseStepDurations('Refrigerate for at least 1 hour.'), [
        const StepDuration(1, StepTimeUnit.hour),
      ]);
      expect(parseStepDurations('Cook for 3 more minutes.'), [
        const StepDuration(3, StepTimeUnit.minute),
      ]);
      expect(parseStepDurations('give them a 10 minute head start'), [
        const StepDuration(10, StepTimeUnit.minute),
      ]);
    });

    test('ignores temperatures, sizes and overnight soaks', () {
      expect(parseStepDurations("Fırını 200°C'ye ısıtın."), isEmpty);
      expect(parseStepDurations('1 cm kalınlığında, 250 ml su'), isEmpty);
      expect(parseStepDurations('Soak for 24 hours.'), isEmpty);
    });

    test('a range times the short end', () {
      const d = StepDuration(12, StepTimeUnit.minute, to: 15);
      expect(d.duration, const Duration(minutes: 12));
      expect(d.isRange, isTrue);
    });
  });

  group('step ingredients guess', () {
    test('Turkish case endings and consonant softening match', () {
      final r = _recipe(
        ['carrot', 'chicken_breast', 'pine_nut'],
        tr: [
          'Havucu doğrayın.',
          'Tavuğu ekleyin.',
          'Çam fıstıklarını kavurun.',
        ],
      );
      expect(matchStepIngredients(r), [
        ['carrot'],
        ['chicken_breast'],
        ['pine_nut'],
      ]);
    });

    test('a longer phrase claims its words before a shorter one', () {
      final r = _recipe(
        ['onion', 'red_onion'],
        tr: ['Kırmızı soğanı doğrayın.', 'Soğanı kavurun.'],
      );
      // "kırmızı soğan" is the red onion only; "soğan" alone could be either.
      expect(matchStepIngredients(r)[0], ['red_onion']);
      expect(matchStepIngredients(r)[1], containsAll(['onion']));
    });

    test('a phrase never spans punctuation', () {
      final r = _recipe(
        ['garlic', 'paprika', 'garlic_powder'],
        tr: ['Ezilmiş sarımsak, toz biber ve tuzu karıştırın.'],
      );
      expect(matchStepIngredients(r).single, ['garlic', 'paprika']);
    });

    test('look-alike words are not ingredients', () {
      final r = _recipe(
        ['cream', 'beef_steak', 'eggs'],
        tr: [
          'Kremamsıyken ateşten alın.',
          'Sıcak servis edin.',
          'Yumurtaları çırpın.',
        ],
      );
      // "kremamsı" is a texture; "edin" is "serve", not a softened "et".
      expect(matchStepIngredients(r), [
        <String>[],
        <String>[],
        ['eggs'],
      ]);
    });

    test('a mention of an ingredient the list lacks is reported', () {
      final r = _recipe(
        ['apple'],
        tr: ['Elmayı dilimleyin.', 'Limon suyuyla fırçalayın.'],
        en: ['Slice the apple.', 'Brush with lemon juice.'],
      );
      expect(unlistedStepMentions(r), {
        1: {'lemon'},
      });
    });

    test('stored data wins over the guess when it lines up', () {
      const stored = Recipe(
        id: 'x',
        name: {'tr': 'x'},
        description: {},
        ingredientIds: ['salmon', 'broccoli'],
        steps: {
          'tr': ['Somondan önce brokoliyi fırına verin.'],
        },
        stepIngredients: [
          ['broccoli'],
        ],
      );
      expect(stepIngredientsFor(stored), [
        ['broccoli'],
      ]);
    });
  });
}

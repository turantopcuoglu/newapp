import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/services/nutrition_calculator.dart';

void main() {
  final calculator = NutritionCalculator();

  Recipe recipe({
    List<String> ingredientIds = const [],
    Map<String, IngredientQuantity> quantities = const {},
    MacroEstimation macros = const MacroEstimation(),
    int servings = 1,
  }) =>
      Recipe(
        id: 'r1',
        name: const {'en': 'test'},
        description: const {'en': ''},
        ingredientIds: ingredientIds,
        quantities: quantities,
        macros: macros,
        servings: servings,
      );

  test('computes calories from explicit gram quantities', () {
    // chicken_breast: 165 kcal / 100 g
    final r = recipe(
      ingredientIds: ['chicken_breast'],
      quantities: {
        'chicken_breast':
            const IngredientQuantity(amount: 200, unit: QuantityUnit.g),
      },
    );

    final result = calculator.compute(r);
    expect(result.fromQuantities, isTrue);
    expect(result.macros.calories, 330);
  });

  test('piece unit resolves through defaultServingG', () {
    // eggs: 155 kcal / 100 g, defaultServingG 60 -> 2 eggs = 120 g = 186 kcal
    final r = recipe(
      ingredientIds: ['eggs'],
      quantities: {
        'eggs': const IngredientQuantity(amount: 2, unit: QuantityUnit.piece),
      },
    );

    expect(calculator.compute(r).macros.calories, 186);
  });

  test('falls back to default servings when no quantities exist', () {
    final r = recipe(ingredientIds: ['chicken_breast']);

    final result = calculator.compute(r);
    expect(result.fromQuantities, isFalse);
    // 150 g default serving of chicken breast
    expect(result.macros.calories, 248);
  });

  test('unknown ingredients are reported, not silently dropped', () {
    final r = recipe(ingredientIds: ['chicken_breast', 'no_such_thing']);

    final result = calculator.compute(r);
    expect(result.missingNutritionData, ['no_such_thing']);
    expect(result.macros.calories, greaterThan(0));
  });

  test('per-serving nutrition divides by servings', () {
    final r = recipe(
      ingredientIds: ['chicken_breast'],
      quantities: {
        'chicken_breast':
            const IngredientQuantity(amount: 400, unit: QuantityUnit.g),
      },
      servings: 2,
    );

    expect(calculator.computePerServing(r).macros.calories, 330);
  });

  test('effectiveMacros prefers computed values when quantities exist', () {
    final withQuantities = recipe(
      ingredientIds: ['chicken_breast'],
      quantities: {
        'chicken_breast':
            const IngredientQuantity(amount: 100, unit: QuantityUnit.g),
      },
      macros: const MacroEstimation(calories: 999),
    );
    final manualOnly = recipe(
      ingredientIds: ['chicken_breast'],
      macros: const MacroEstimation(calories: 999),
    );

    expect(calculator.effectiveMacros(withQuantities).calories, 165);
    expect(calculator.effectiveMacros(manualOnly).calories, 999);
  });

  test('calorieDeviation flags manual values far from computed estimate', () {
    final r = recipe(
      ingredientIds: ['chicken_breast'],
      quantities: {
        'chicken_breast':
            const IngredientQuantity(amount: 100, unit: QuantityUnit.g),
      },
      // manual claims 330, computed 165 -> 50% deviation
      macros: const MacroEstimation(calories: 330),
    );

    expect(calculator.calorieDeviation(r), closeTo(0.5, 0.01));
  });
}

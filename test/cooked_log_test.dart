import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/day_boundary.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/models/cooked_entry.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/cooked_provider.dart';

CookedEntry _entry({
  String recipeId = 'r1',
  required DateTime at,
  double servings = 1,
  int calories = 500,
  int protein = 30,
}) =>
    CookedEntry(
      id: '$recipeId-${at.microsecondsSinceEpoch}',
      recipeId: recipeId,
      dateTime: at,
      mealType: MealType.dinner,
      servings: servings,
      macrosPerServing:
          MacroEstimation(calories: calories, proteinG: protein),
    );

void main() {
  group('day boundary', () {
    test('the app-day runs 06:00 to 05:59 the next morning', () {
      final morning = DateTime(2026, 8, 2, 9);
      final lateNight = DateTime(2026, 8, 3, 1, 30);
      final nextMorning = DateTime(2026, 8, 3, 7);

      // A 01:30 meal still belongs to the day the user checked in for.
      expect(DayBoundary.keyFor(lateNight), DayBoundary.keyFor(morning));
      expect(DayBoundary.keyFor(nextMorning), isNot(DayBoundary.keyFor(morning)));
      expect(DayBoundary.keyFor(morning), '2026-08-02');
      expect(DayBoundary.keyFor(lateNight), '2026-08-02');
      expect(DayBoundary.keyFor(nextMorning), '2026-08-03');
    });

    test('entry dayKey uses the same boundary', () {
      final entry = _entry(at: DateTime(2026, 8, 3, 2));
      expect(entry.dayKey, '2026-08-02');
    });
  });

  group('cooked entry macros', () {
    test('servings scale the snapshotted macros', () {
      final single = _entry(at: DateTime(2026, 8, 2, 20), calories: 500);
      final double_ = _entry(
        at: DateTime(2026, 8, 2, 20),
        servings: 2,
        calories: 500,
      );
      final half = _entry(
        at: DateTime(2026, 8, 2, 20),
        servings: 0.5,
        calories: 500,
      );

      expect(single.calories, 500);
      expect(double_.calories, 1000);
      expect(half.calories, 250);
      expect(double_.proteinG, 60);
    });

    test('round-trips through JSON', () {
      final entry = _entry(at: DateTime(2026, 8, 2, 20), servings: 1.5);
      final restored = CookedEntry.decode(entry.encode());

      expect(restored.recipeId, entry.recipeId);
      expect(restored.dateTime, entry.dateTime);
      expect(restored.servings, entry.servings);
      expect(restored.calories, entry.calories);
      expect(restored.mealType, entry.mealType);
    });
  });

  group('consumed totals', () {
    test('logging the same recipe twice doubles the total', () {
      final once = ConsumedTotals.from([
        _entry(at: DateTime(2026, 8, 2, 13), calories: 420),
      ]);
      final twice = ConsumedTotals.from([
        _entry(at: DateTime(2026, 8, 2, 13), calories: 420),
        _entry(at: DateTime(2026, 8, 2, 19), calories: 420),
      ]);

      expect(once.calories, 420);
      expect(once.mealCount, 1);
      expect(twice.calories, 840);
      expect(twice.mealCount, 2);
    });

    test('empty log totals zero', () {
      final totals = ConsumedTotals.from([]);
      expect(totals.calories, 0);
      expect(totals.mealCount, 0);
    });

    test('sums every macro, not just calories', () {
      final totals = ConsumedTotals.from([
        _entry(at: DateTime(2026, 8, 2, 13), calories: 400, protein: 20),
        _entry(at: DateTime(2026, 8, 2, 19), calories: 600, protein: 35),
      ]);

      expect(totals.calories, 1000);
      expect(totals.proteinG, 55);
    });
  });

  group('planned meals never count as consumed', () {
    test('ConsumedTotals only sums cooked entries', () {
      // The bug this guards: nutrition screens used to read mealPlanProvider,
      // so adding a recipe to the planner inflated consumed calories.
      final cooked = [
        CookedEntry(
          id: 'c1',
          recipeId: 'r1',
          dateTime: DateTime(2026, 8, 2, 12),
          mealType: MealType.lunch,
          macrosPerServing: const MacroEstimation(calories: 500, proteinG: 30),
        ),
      ];

      final totals = ConsumedTotals.from(cooked);
      expect(totals.calories, 500);
      expect(totals.proteinG, 30);
      expect(totals.mealCount, 1);

      // An empty cooked log means zero intake regardless of any plan.
      expect(ConsumedTotals.from(const <CookedEntry>[]).calories, 0);
      expect(ConsumedTotals.from(const <CookedEntry>[]).mealCount, 0);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/day_boundary.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/models/cooked_entry.dart';
import 'package:nutri_guide/models/meal_plan.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/cooked_provider.dart';
import 'package:nutri_guide/services/day_meal_list.dart';

void main() {
  final today = DateTime.now();
  final todayKey = DayBoundary.keyForDate(today);

  MealPlanEntry plan(String recipeId, MealType type, {String? time}) =>
      MealPlanEntry(
        id: 'plan_$recipeId',
        recipeId: recipeId,
        date: DateTime(today.year, today.month, today.day),
        mealType: type,
        hour: time == null ? null : int.parse(time.split(':')[0]),
        minute: time == null ? null : int.parse(time.split(':')[1]),
      );

  CookedEntry cooked(String recipeId, MealType type, {DateTime? at}) =>
      CookedEntry(
        id: 'cooked_$recipeId',
        recipeId: recipeId,
        dateTime: at ?? DayBoundary.middayOf(today),
        mealType: type,
        macrosPerServing: const MacroEstimation(calories: 300),
      );

  group('day meal list', () {
    test('a cooked entry ticks off the meal that was planned', () {
      final items = buildDayMealList(
        date: today,
        plans: [plan('r1', MealType.lunch)],
        cooked: [cooked('r1', MealType.lunch)],
      );

      expect(items, hasLength(1));
      expect(items.single.isCooked, isTrue);
      expect(items.single.planId, 'plan_r1');
      expect(items.single.isUnplanned, isFalse);
    });

    test('cooking something unplanned still shows up on the list', () {
      // The whole point: "I cooked this" from a recipe page has to reach the
      // meal list, otherwise the list and the nutrition summary disagree.
      final items = buildDayMealList(
        date: today,
        plans: const [],
        cooked: [cooked('r9', MealType.dinner)],
      );

      expect(items, hasLength(1));
      expect(items.single.recipeId, 'r9');
      expect(items.single.isCooked, isTrue);
      expect(items.single.isUnplanned, isTrue);
    });

    test('a planned meal that was not cooked stays unticked', () {
      final items = buildDayMealList(
        date: today,
        plans: [plan('r1', MealType.breakfast)],
        cooked: const [],
      );

      expect(items.single.isCooked, isFalse);
    });

    test('one cooked entry does not tick off two plans of the same recipe',
        () {
      final items = buildDayMealList(
        date: today,
        plans: [
          plan('r1', MealType.lunch),
          MealPlanEntry(
            id: 'plan_r1_again',
            recipeId: 'r1',
            date: DateTime(today.year, today.month, today.day),
            mealType: MealType.dinner,
          ),
        ],
        cooked: [cooked('r1', MealType.lunch)],
      );

      expect(items.where((i) => i.isCooked), hasLength(1));
      expect(items.where((i) => !i.isCooked), hasLength(1));
    });

    test('meals from other days are left out', () {
      final yesterday = today.subtract(const Duration(days: 1));
      final items = buildDayMealList(
        date: today,
        plans: const [],
        cooked: [cooked('r1', MealType.lunch, at: DayBoundary.middayOf(yesterday))],
      );

      expect(items, isEmpty);
    });

    test('the list is ordered by meal type then time', () {
      final items = buildDayMealList(
        date: today,
        plans: [
          plan('dinner', MealType.dinner, time: '19:00'),
          plan('breakfast', MealType.breakfast, time: '08:00'),
          plan('lunch', MealType.lunch, time: '12:30'),
        ],
        cooked: const [],
      );

      expect(items.map((i) => i.recipeId).toList(),
          ['breakfast', 'lunch', 'dinner']);
    });
  });

  group('app-day keys', () {
    test('keyForDate does not shift a midnight date back a day', () {
      // keyFor treats anything before 06:00 as the previous day, which is
      // right for a timestamp and wrong for a calendar date. The charts built
      // their buckets from dates and lost a day because of it.
      final date = DateTime(2026, 8, 4);
      expect(DayBoundary.keyFor(date), '2026-08-03');
      expect(DayBoundary.keyForDate(date), '2026-08-04');
    });

    test('a meal logged at midday lands on its own date', () {
      final date = DateTime(2026, 8, 4);
      expect(DayBoundary.keyFor(DayBoundary.middayOf(date)), '2026-08-04');
    });

    test('a late-night meal still counts towards the day that started it', () {
      expect(DayBoundary.keyFor(DateTime(2026, 8, 5, 1, 30)), '2026-08-04');
    });
  });

  group('consumed totals', () {
    test('only entries of the day count', () {
      final entries = [
        cooked('r1', MealType.lunch),
        CookedEntry(
          id: 'old',
          recipeId: 'r2',
          dateTime: DayBoundary.middayOf(today.subtract(const Duration(days: 3))),
          mealType: MealType.dinner,
          macrosPerServing: const MacroEstimation(calories: 900),
        ),
      ];

      final totals =
          ConsumedTotals.from(entries.where((e) => e.dayKey == todayKey));
      expect(totals.calories, 300);
      expect(totals.mealCount, 1);
    });
  });
}

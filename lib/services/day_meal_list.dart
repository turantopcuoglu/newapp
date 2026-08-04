import '../core/day_boundary.dart';
import '../core/enums.dart';
import '../models/cooked_entry.dart';
import '../models/meal_plan.dart';

/// One line of a day's meal list: what was planned, what was cooked, or both.
class DayMealItem {
  final String recipeId;
  final MealType mealType;

  /// "12:30" from the plan, empty when there is no planned time.
  final String timeLabel;

  /// Id of the plan entry, null when the meal was only ever cooked.
  final String? planId;

  /// Id of the cooked entry, null when the meal is still just a plan.
  final String? cookedEntryId;

  const DayMealItem({
    required this.recipeId,
    required this.mealType,
    this.timeLabel = '',
    this.planId,
    this.cookedEntryId,
  });

  bool get isCooked => cookedEntryId != null;

  /// Cooked without ever being planned — logged straight from a recipe page.
  bool get isUnplanned => planId == null;
}

/// Merges the plan and the cooked log into the single list the user sees.
///
/// The two used to live apart: marking a recipe cooked from its page left no
/// trace on the day's meal list, and ticking a planned meal off was not
/// possible at all, so the nutrition summary and the list disagreed. Here a
/// cooked entry attaches to the matching planned meal when there is one, and
/// otherwise shows up on its own.
List<DayMealItem> buildDayMealList({
  required DateTime date,
  required List<MealPlanEntry> plans,
  required List<CookedEntry> cooked,
}) {
  final dayKey = DayBoundary.keyForDate(date);

  final dayPlans = plans.where((p) => p.dateKey == dayKey).toList();
  // Oldest first so repeated cooks of the same recipe pair up predictably.
  final dayCooked = cooked.where((c) => c.dayKey == dayKey).toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  final unmatched = List.of(dayCooked);
  final items = <DayMealItem>[];

  for (final plan in dayPlans) {
    final match =
        unmatched.where((c) => c.recipeId == plan.recipeId).firstOrNull;
    if (match != null) unmatched.remove(match);
    items.add(DayMealItem(
      recipeId: plan.recipeId,
      mealType: plan.mealType,
      timeLabel: plan.timeLabel,
      planId: plan.id,
      cookedEntryId: match?.id,
    ));
  }

  for (final entry in unmatched) {
    items.add(DayMealItem(
      recipeId: entry.recipeId,
      mealType: entry.mealType,
      cookedEntryId: entry.id,
    ));
  }

  items.sort((a, b) {
    final byMeal = a.mealType.index.compareTo(b.mealType.index);
    if (byMeal != 0) return byMeal;
    return a.timeLabel.compareTo(b.timeLabel);
  });

  return items;
}

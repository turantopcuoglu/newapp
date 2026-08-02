import 'dart:convert';

import '../core/day_boundary.dart';
import '../core/enums.dart';
import 'recipe.dart';

/// A recipe the user marked as actually cooked/eaten.
///
/// Distinct from [MealPlanEntry], which is only an intention. Consumed
/// calories are computed from these entries.
///
/// The macros are snapshotted at logging time: recipe content can change
/// (bundled updates, edited quantities) and history must not shift under the
/// user afterwards.
class CookedEntry {
  final String id;
  final String recipeId;
  final DateTime dateTime;
  final MealType mealType;

  /// How many servings were eaten (1 = one serving of the recipe).
  final double servings;

  /// Per-serving macros at the moment of logging.
  final MacroEstimation macrosPerServing;

  const CookedEntry({
    required this.id,
    required this.recipeId,
    required this.dateTime,
    required this.mealType,
    this.servings = 1,
    this.macrosPerServing = const MacroEstimation(),
  });

  /// App-day this entry counts towards (06:00 reset, see [DayBoundary]).
  String get dayKey => DayBoundary.keyFor(dateTime);

  int get calories => (macrosPerServing.calories * servings).round();
  int get proteinG => (macrosPerServing.proteinG * servings).round();
  int get carbsG => (macrosPerServing.carbsG * servings).round();
  int get fatG => (macrosPerServing.fatG * servings).round();
  int get fiberG => (macrosPerServing.fiberG * servings).round();

  Map<String, dynamic> toJson() => {
        'id': id,
        'recipeId': recipeId,
        'dateTime': dateTime.toIso8601String(),
        'mealType': mealType.name,
        'servings': servings,
        'macrosPerServing': macrosPerServing.toJson(),
      };

  factory CookedEntry.fromJson(Map<String, dynamic> json) => CookedEntry(
        id: json['id'] as String,
        recipeId: json['recipeId'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        mealType: MealType.values.firstWhere(
          (e) => e.name == json['mealType'],
          orElse: () => MealType.lunch,
        ),
        servings: (json['servings'] as num?)?.toDouble() ?? 1,
        macrosPerServing: json['macrosPerServing'] != null
            ? MacroEstimation.fromJson(
                json['macrosPerServing'] as Map<String, dynamic>)
            : const MacroEstimation(),
      );

  String encode() => jsonEncode(toJson());
  factory CookedEntry.decode(String s) =>
      CookedEntry.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

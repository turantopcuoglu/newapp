import 'dart:convert';
import '../core/enums.dart';

class MealPlanEntry {
  final String id;
  final String recipeId;
  final DateTime date;
  final MealType mealType;

  const MealPlanEntry({
    required this.id,
    required this.recipeId,
    required this.date,
    required this.mealType,
  });

  /// Date key for grouping: "2026-02-25"
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  MealPlanEntry copyWith({
    String? recipeId,
    DateTime? date,
    MealType? mealType,
  }) =>
      MealPlanEntry(
        id: id,
        recipeId: recipeId ?? this.recipeId,
        date: date ?? this.date,
        mealType: mealType ?? this.mealType,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'recipeId': recipeId,
        'date': date.toIso8601String(),
        'mealType': mealType.name,
      };

  factory MealPlanEntry.fromJson(Map<String, dynamic> json) => MealPlanEntry(
        id: json['id'] as String,
        recipeId: json['recipeId'] as String,
        date: DateTime.parse(json['date'] as String),
        mealType:
            MealType.values.firstWhere((e) => e.name == json['mealType']),
      );

  String encode() => jsonEncode(toJson());
  factory MealPlanEntry.decode(String s) =>
      MealPlanEntry.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

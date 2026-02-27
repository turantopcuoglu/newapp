import 'dart:convert';
import '../core/enums.dart';

class MealPlanEntry {
  final String id;
  final String recipeId;
  final DateTime date;
  final MealType mealType;
  final int? hour;
  final int? minute;

  const MealPlanEntry({
    required this.id,
    required this.recipeId,
    required this.date,
    required this.mealType,
    this.hour,
    this.minute,
  });

  String get timeLabel {
    if (hour == null || minute == null) return '';
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Date key for grouping: "2026-02-25"
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  MealPlanEntry copyWith({
    String? recipeId,
    DateTime? date,
    MealType? mealType,
    int? hour,
    int? minute,
  }) =>
      MealPlanEntry(
        id: id,
        recipeId: recipeId ?? this.recipeId,
        date: date ?? this.date,
        mealType: mealType ?? this.mealType,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'recipeId': recipeId,
        'date': date.toIso8601String(),
        'mealType': mealType.name,
        'hour': hour,
        'minute': minute,
      };

  factory MealPlanEntry.fromJson(Map<String, dynamic> json) => MealPlanEntry(
        id: json['id'] as String,
        recipeId: json['recipeId'] as String,
        date: DateTime.parse(json['date'] as String),
        mealType:
            MealType.values.firstWhere((e) => e.name == json['mealType']),
        hour: json['hour'] as int?,
        minute: json['minute'] as int?,
      );

  String encode() => jsonEncode(toJson());
  factory MealPlanEntry.decode(String s) =>
      MealPlanEntry.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

import 'dart:convert';
import '../core/enums.dart';

class MacroEstimation {
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int fiberG;

  const MacroEstimation({
    this.calories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.fiberG = 0,
  });

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatG': fatG,
        'fiberG': fiberG,
      };

  factory MacroEstimation.fromJson(Map<String, dynamic> json) =>
      MacroEstimation(
        calories: json['calories'] as int? ?? 0,
        proteinG: json['proteinG'] as int? ?? 0,
        carbsG: json['carbsG'] as int? ?? 0,
        fatG: json['fatG'] as int? ?? 0,
        fiberG: json['fiberG'] as int? ?? 0,
      );
}

class Recipe {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final MealType mealType;
  final List<String> ingredientIds;
  final List<String> allergenTags;
  final List<CheckInType> checkInTags;
  final NutrientLevel proteinLevel;
  final NutrientLevel fiberLevel;
  final CarbType carbType;
  final MacroEstimation macros;
  final Map<String, List<String>> steps;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    this.mealType = MealType.lunch,
    this.ingredientIds = const [],
    this.allergenTags = const [],
    this.checkInTags = const [],
    this.proteinLevel = NutrientLevel.medium,
    this.fiberLevel = NutrientLevel.medium,
    this.carbType = CarbType.mixed,
    this.macros = const MacroEstimation(),
    this.steps = const {},
  });

  String localizedName(String locale) =>
      name[locale] ?? name['en'] ?? name.values.firstOrNull ?? '';

  String localizedDescription(String locale) =>
      description[locale] ??
      description['en'] ??
      description.values.firstOrNull ??
      '';

  List<String> localizedSteps(String locale) =>
      steps[locale] ?? steps['en'] ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'mealType': mealType.name,
        'ingredientIds': ingredientIds,
        'allergenTags': allergenTags,
        'checkInTags': checkInTags.map((e) => e.name).toList(),
        'proteinLevel': proteinLevel.name,
        'fiberLevel': fiberLevel.name,
        'carbType': carbType.name,
        'macros': macros.toJson(),
        'steps': steps,
      };

  static Map<String, String> _parseLocalizedString(dynamic value) {
    if (value is Map) return Map<String, String>.from(value);
    if (value is String) return {'en': value, 'tr': value};
    return {};
  }

  static Map<String, List<String>> _parseLocalizedSteps(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k as String, List<String>.from(v)));
    }
    if (value is List) return {'en': List<String>.from(value)};
    return {};
  }

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String? ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _parseLocalizedString(json['name']),
        description: _parseLocalizedString(json['description']),
        mealType: MealType.values.firstWhere(
            (e) => e.name == json['mealType'],
            orElse: () => MealType.lunch),
        ingredientIds: List<String>.from(
            json['ingredientIds'] ?? json['ingredients'] ?? []),
        allergenTags: List<String>.from(json['allergenTags'] ?? []),
        checkInTags: (json['checkInTags'] as List?)
                ?.map((e) =>
                    CheckInType.values.firstWhere((v) => v.name == e))
                .toList() ??
            [],
        proteinLevel: NutrientLevel.values.firstWhere(
            (e) => e.name == json['proteinLevel'],
            orElse: () => NutrientLevel.medium),
        fiberLevel: NutrientLevel.values.firstWhere(
            (e) => e.name == json['fiberLevel'],
            orElse: () => NutrientLevel.medium),
        carbType: CarbType.values.firstWhere(
            (e) => e.name == json['carbType'],
            orElse: () => CarbType.mixed),
        macros: json['macros'] != null
            ? MacroEstimation.fromJson(json['macros'])
            : const MacroEstimation(),
        steps: _parseLocalizedSteps(json['steps']),
      );

  String encode() => jsonEncode(toJson());
  factory Recipe.decode(String s) =>
      Recipe.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

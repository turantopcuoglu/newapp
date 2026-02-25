import 'dart:convert';
import '../core/enums.dart';

class MacroEstimation {
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int fiberG;

  const MacroEstimation({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
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
  final String? imagePath;
  final bool isUserCreated;

  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.mealType,
    required this.ingredientIds,
    this.allergenTags = const [],
    this.checkInTags = const [],
    this.proteinLevel = NutrientLevel.medium,
    this.fiberLevel = NutrientLevel.medium,
    this.carbType = CarbType.mixed,
    this.macros = const MacroEstimation(
        calories: 0, proteinG: 0, carbsG: 0, fatG: 0, fiberG: 0),
    this.steps = const {},
    this.imagePath,
    this.isUserCreated = false,
  });

  String localizedName(String locale) =>
      name[locale] ?? name['en'] ?? id;

  String localizedDescription(String locale) =>
      description[locale] ?? description['en'] ?? '';

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
        'imagePath': imagePath,
        'isUserCreated': isUserCreated,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        name: Map<String, String>.from(json['name'] as Map),
        description: Map<String, String>.from(json['description'] as Map),
        mealType:
            MealType.values.firstWhere((e) => e.name == json['mealType']),
        ingredientIds: List<String>.from(json['ingredientIds'] ?? []),
        allergenTags: List<String>.from(json['allergenTags'] ?? []),
        checkInTags: (json['checkInTags'] as List<dynamic>?)
                ?.map(
                    (e) => CheckInType.values.firstWhere((c) => c.name == e))
                .toList() ??
            [],
        proteinLevel: json['proteinLevel'] != null
            ? NutrientLevel.values
                .firstWhere((e) => e.name == json['proteinLevel'])
            : NutrientLevel.medium,
        fiberLevel: json['fiberLevel'] != null
            ? NutrientLevel.values
                .firstWhere((e) => e.name == json['fiberLevel'])
            : NutrientLevel.medium,
        carbType: json['carbType'] != null
            ? CarbType.values.firstWhere((e) => e.name == json['carbType'])
            : CarbType.mixed,
        macros: json['macros'] != null
            ? MacroEstimation.fromJson(json['macros'] as Map<String, dynamic>)
            : const MacroEstimation(
                calories: 0, proteinG: 0, carbsG: 0, fatG: 0, fiberG: 0),
        steps: (json['steps'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, List<String>.from(v as List))) ??
            {},
        imagePath: json['imagePath'] as String?,
        isUserCreated: json['isUserCreated'] as bool? ?? false,
      );

  String encode() => jsonEncode(toJson());
  factory Recipe.decode(String s) =>
      Recipe.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

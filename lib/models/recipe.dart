import 'dart:convert';

class Recipe {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> availableIngredients;
  final List<String> missingIngredients;
  final int prepTimeMinutes;
  final int servings;

  const Recipe({
    required this.name,
    required this.description,
    this.ingredients = const [],
    this.steps = const [],
    this.availableIngredients = const [],
    this.missingIngredients = const [],
    this.prepTimeMinutes = 0,
    this.servings = 0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'ingredients': ingredients,
        'steps': steps,
        'availableIngredients': availableIngredients,
        'missingIngredients': missingIngredients,
        'prepTimeMinutes': prepTimeMinutes,
        'servings': servings,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        ingredients: List<String>.from(json['ingredients'] ?? []),
        steps: List<String>.from(json['steps'] ?? []),
        availableIngredients:
            List<String>.from(json['availableIngredients'] ?? []),
        missingIngredients:
            List<String>.from(json['missingIngredients'] ?? []),
        prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
        servings: json['servings'] as int? ?? 0,
      );

  String encode() => jsonEncode(toJson());
  factory Recipe.decode(String s) =>
      Recipe.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

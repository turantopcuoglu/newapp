class Recipe {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> availableIngredients;
  final List<String> missingIngredients;
  final int prepTimeMinutes;
  final int servings;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    this.availableIngredients = const [],
    this.missingIngredients = const [],
    this.prepTimeMinutes = 0,
    this.servings = 4,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        name: json['name'] as String? ?? 'Tarif',
        description: json['description'] as String? ?? '',
        ingredients: List<String>.from(json['ingredients'] ?? []),
        steps: List<String>.from(json['steps'] ?? []),
        availableIngredients:
            List<String>.from(json['availableIngredients'] ?? []),
        missingIngredients:
            List<String>.from(json['missingIngredients'] ?? []),
        prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
        servings: json['servings'] as int? ?? 4,
      );
}

class ShoppingItem {
  final String name;
  final String? forRecipe;
  bool isChecked;

  ShoppingItem({
    required this.name,
    this.forRecipe,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'forRecipe': forRecipe,
        'isChecked': isChecked,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        name: json['name'] as String,
        forRecipe: json['forRecipe'] as String?,
        isChecked: json['isChecked'] as bool? ?? false,
      );
}

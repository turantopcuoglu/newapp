import 'dart:convert';
import '../core/enums.dart';

class Ingredient {
  final String id;
  final Map<String, String> name;
  final IngredientCategory category;
  final List<String> allergenTags;

  const Ingredient({
    required this.id,
    required this.name,
    this.category = IngredientCategory.other,
    this.allergenTags = const [],
  });

  String localizedName(String locale) =>
      name[locale] ?? name['en'] ?? name.values.firstOrNull ?? id;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'allergenTags': allergenTags,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    final nameValue = json['name'];
    final Map<String, String> parsedName;
    if (nameValue is Map) {
      parsedName = Map<String, String>.from(nameValue);
    } else if (nameValue is String) {
      parsedName = {'en': nameValue, 'tr': nameValue};
    } else {
      parsedName = {};
    }

    return Ingredient(
      id: json['id'] as String,
      name: parsedName,
      category: IngredientCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => IngredientCategory.other),
      allergenTags: List<String>.from(json['allergenTags'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  String encode() => jsonEncode(toJson());
  factory Ingredient.decode(String s) =>
      Ingredient.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

class InventoryItem {
  final String ingredientId;

  const InventoryItem({required this.ingredientId});

  Map<String, dynamic> toJson() => {'ingredientId': ingredientId};

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      InventoryItem(ingredientId: json['ingredientId'] as String);

  String encode() => jsonEncode(toJson());
  factory InventoryItem.decode(String s) =>
      InventoryItem.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

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
    required this.category,
    this.allergenTags = const [],
  });

  String localizedName(String locale) =>
      name[locale] ?? name['en'] ?? id;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'allergenTags': allergenTags,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'] as String,
        name: Map<String, String>.from(json['name'] as Map),
        category: IngredientCategory.values
            .firstWhere((e) => e.name == json['category']),
        allergenTags: List<String>.from(json['allergenTags'] ?? []),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// A user's kitchen inventory item: references an ingredient ID + timestamp.
class InventoryItem {
  final String ingredientId;
  final DateTime addedAt;

  InventoryItem({
    required this.ingredientId,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'ingredientId': ingredientId,
        'addedAt': addedAt.toIso8601String(),
      };

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        ingredientId: json['ingredientId'] as String,
        addedAt: DateTime.parse(json['addedAt'] as String),
      );

  String encode() => jsonEncode(toJson());
  factory InventoryItem.decode(String s) =>
      InventoryItem.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

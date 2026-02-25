import 'dart:convert';

class ShoppingItem {
  final String id;
  final String name;
  final String? forRecipeId;
  final bool isPurchased;
  final DateTime addedAt;

  ShoppingItem({
    required this.id,
    required this.name,
    this.forRecipeId,
    this.isPurchased = false,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  ShoppingItem copyWith({
    String? name,
    String? forRecipeId,
    bool? isPurchased,
  }) =>
      ShoppingItem(
        id: id,
        name: name ?? this.name,
        forRecipeId: forRecipeId ?? this.forRecipeId,
        isPurchased: isPurchased ?? this.isPurchased,
        addedAt: addedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'forRecipeId': forRecipeId,
        'isPurchased': isPurchased,
        'addedAt': addedAt.toIso8601String(),
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        id: json['id'] as String,
        name: json['name'] as String,
        forRecipeId: json['forRecipeId'] as String?,
        isPurchased: json['isPurchased'] as bool? ?? false,
        addedAt: json['addedAt'] != null
            ? DateTime.parse(json['addedAt'] as String)
            : null,
      );

  String encode() => jsonEncode(toJson());
  factory ShoppingItem.decode(String s) =>
      ShoppingItem.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

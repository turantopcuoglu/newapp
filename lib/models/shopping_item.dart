import 'dart:convert';

class ShoppingItem {
  final String id;
  final String name;
  final String? forRecipeId;
  final bool isPurchased;

  const ShoppingItem({
    required this.id,
    required this.name,
    this.forRecipeId,
    this.isPurchased = false,
  });

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
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'forRecipeId': forRecipeId,
        'isPurchased': isPurchased,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        id: json['id'] as String? ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: json['name'] as String,
        forRecipeId: json['forRecipeId'] as String?,
        isPurchased: json['isPurchased'] as bool? ?? false,
      );

  String encode() => jsonEncode(toJson());
  factory ShoppingItem.decode(String s) =>
      ShoppingItem.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

import 'dart:convert';

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

  String encode() => jsonEncode(toJson());
  factory ShoppingItem.decode(String s) =>
      ShoppingItem.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

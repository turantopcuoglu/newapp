import 'dart:convert';

class Ingredient {
  final String id;
  final String name;

  const Ingredient({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'] as String,
        name: json['name'] as String,
      );

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

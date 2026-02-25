import 'dart:convert';
import '../core/enums.dart';

class UserProfile {
  final int? age;
  final double? weight;
  final double? height;
  final Gender? gender;
  final ActivityLevel activityLevel;
  final List<String> allergies;
  final List<String> dislikedIngredients;

  const UserProfile({
    this.age,
    this.weight,
    this.height,
    this.gender,
    this.activityLevel = ActivityLevel.moderate,
    this.allergies = const [],
    this.dislikedIngredients = const [],
  });

  bool get isFemale => gender == Gender.female;

  UserProfile copyWith({
    int? age,
    double? weight,
    double? height,
    Gender? gender,
    ActivityLevel? activityLevel,
    List<String>? allergies,
    List<String>? dislikedIngredients,
  }) =>
      UserProfile(
        age: age ?? this.age,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        gender: gender ?? this.gender,
        activityLevel: activityLevel ?? this.activityLevel,
        allergies: allergies ?? this.allergies,
        dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      );

  Map<String, dynamic> toJson() => {
        'age': age,
        'weight': weight,
        'height': height,
        'gender': gender?.name,
        'activityLevel': activityLevel.name,
        'allergies': allergies,
        'dislikedIngredients': dislikedIngredients,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        age: json['age'] as int?,
        weight: (json['weight'] as num?)?.toDouble(),
        height: (json['height'] as num?)?.toDouble(),
        gender: json['gender'] != null
            ? Gender.values.firstWhere((e) => e.name == json['gender'])
            : null,
        activityLevel: json['activityLevel'] != null
            ? ActivityLevel.values
                .firstWhere((e) => e.name == json['activityLevel'])
            : ActivityLevel.moderate,
        allergies: List<String>.from(json['allergies'] ?? []),
        dislikedIngredients:
            List<String>.from(json['dislikedIngredients'] ?? []),
      );

  String encode() => jsonEncode(toJson());

  factory UserProfile.decode(String source) =>
      UserProfile.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

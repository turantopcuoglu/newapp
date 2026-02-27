import 'dart:convert';
import '../core/enums.dart';

class BeverageEntry {
  final String id;
  final BeverageType type;
  final int milliliters;
  final DateTime dateTime;
  final int calories;

  const BeverageEntry({
    required this.id,
    required this.type,
    required this.milliliters,
    required this.dateTime,
    this.calories = 0,
  });

  String get dateKey =>
      '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  String get timeLabel =>
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'milliliters': milliliters,
        'dateTime': dateTime.toIso8601String(),
        'calories': calories,
      };

  factory BeverageEntry.fromJson(Map<String, dynamic> json) => BeverageEntry(
        id: json['id'] as String,
        type: BeverageType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => BeverageType.other,
        ),
        milliliters: json['milliliters'] as int? ?? 0,
        dateTime: DateTime.parse(json['dateTime'] as String),
        calories: json['calories'] as int? ?? 0,
      );

  String encode() => jsonEncode(toJson());
  factory BeverageEntry.decode(String s) =>
      BeverageEntry.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

class BeverageInfo {
  final BeverageType type;
  final Map<String, String> name;
  final int defaultMl;
  final int caloriesPer100ml;
  final String icon;

  const BeverageInfo({
    required this.type,
    required this.name,
    required this.defaultMl,
    this.caloriesPer100ml = 0,
    this.icon = '',
  });
}

const List<BeverageInfo> beverageOptions = [
  BeverageInfo(
    type: BeverageType.water,
    name: {'en': 'Water', 'tr': 'Su'},
    defaultMl: 250,
    caloriesPer100ml: 0,
  ),
  BeverageInfo(
    type: BeverageType.tea,
    name: {'en': 'Tea', 'tr': 'Çay'},
    defaultMl: 200,
    caloriesPer100ml: 1,
  ),
  BeverageInfo(
    type: BeverageType.coffee,
    name: {'en': 'Coffee', 'tr': 'Kahve'},
    defaultMl: 150,
    caloriesPer100ml: 2,
  ),
  BeverageInfo(
    type: BeverageType.juice,
    name: {'en': 'Fruit Juice', 'tr': 'Meyve Suyu'},
    defaultMl: 200,
    caloriesPer100ml: 45,
  ),
  BeverageInfo(
    type: BeverageType.soda,
    name: {'en': 'Soda / Fizzy Drink', 'tr': 'Gazlı İçecek'},
    defaultMl: 330,
    caloriesPer100ml: 42,
  ),
  BeverageInfo(
    type: BeverageType.milk,
    name: {'en': 'Milk', 'tr': 'Süt'},
    defaultMl: 200,
    caloriesPer100ml: 42,
  ),
  BeverageInfo(
    type: BeverageType.smoothie,
    name: {'en': 'Smoothie', 'tr': 'Smoothie'},
    defaultMl: 300,
    caloriesPer100ml: 55,
  ),
  BeverageInfo(
    type: BeverageType.other,
    name: {'en': 'Other', 'tr': 'Diğer'},
    defaultMl: 200,
    caloriesPer100ml: 20,
  ),
];

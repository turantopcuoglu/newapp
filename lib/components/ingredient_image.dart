import 'package:flutter/material.dart';
import '../data/food_photo_catalog.dart';
import 'atlas_image.dart';

class IngredientImage extends StatelessWidget {
  final String id;
  const IngredientImage({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final entry = FoodPhotoCatalog.ingredients[id];
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: entry == null
          ? const ColoredBox(
              color: Color(0xFFECE2D7),
              child: Center(
                child: Icon(Icons.restaurant_rounded, color: Color(0xFF544638)),
              ),
            )
          : AtlasImage(
              asset: 'assets/food/ingredients-${entry.$1}.png',
              columns: 6,
              rows: 6,
              index: entry.$2,
            ),
    );
  }
}

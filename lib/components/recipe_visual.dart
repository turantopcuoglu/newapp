import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../data/food_photo_catalog.dart';
import 'atlas_image.dart';
import 'ingredient_image.dart';
import '../screens/wellness/moonlit_assets.dart';
import '../models/recipe.dart';

/// Recipe photography, with ingredient imagery for recipes without a photo.
///
class RecipeVisual extends StatelessWidget {
  final Recipe recipe;
  final double height;
  final BorderRadius borderRadius;

  const RecipeVisual({
    super.key,
    required this.recipe,
    this.height = 96,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    final path = recipe.imagePath;
    final photo = path != null && path.isNotEmpty
        ? Image.asset(
            path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _photo(),
          )
        : _photo();
    return Semantics(
      image: true,
      label: recipe.localizedName(Localizations.localeOf(context).languageCode),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(height: height, width: double.infinity, child: photo),
      ),
    );
  }

  Widget _photo() {
    if (recipe.id == 'moonlit_bulgur_bowl') {
      return const OriginalFoodPhoto(detail: true);
    }
    final entry = FoodPhotoCatalog.recipes[recipe.id];
    if (entry != null) {
      return AtlasImage(
        asset: 'assets/food/recipes-${entry.$1}.png',
        columns: 4,
        rows: 4,
        index: entry.$2,
      );
    }
    // A user-created/new recipe has no invented finished-dish photograph.
    final id = recipe.ingredientIds
        .where(FoodPhotoCatalog.ingredients.containsKey)
        .firstOrNull;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (id != null)
          IngredientImage(id: id)
        else
          const ColoredBox(color: Color(0xFFECE2D7)),
        Align(
          alignment: Alignment.bottomCenter,
          child: Builder(
            builder: (context) => Container(
              width: double.infinity,
              color: Colors.black54,
              padding: const EdgeInsets.all(6),
              child: Text(
                Localizations.localeOf(context).languageCode == 'tr'
                    ? 'Tarifindeki besin'
                    : 'An ingredient in your recipe',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Dish emoji: name keywords first (most specific), then a signature
  /// ingredient, then the meal type.
  String get emoji {
    final name = (recipe.name['en'] ?? '').toLowerCase();
    for (final entry in _nameKeywordEmoji.entries) {
      if (name.contains(entry.key)) return entry.value;
    }
    for (final id in recipe.ingredientIds) {
      final match = _ingredientEmoji[id];
      if (match != null) return match;
    }
    return _mealTypeEmoji[recipe.mealType]!;
  }

  static const Map<String, String> _nameKeywordEmoji = {
    'soup': '🍲',
    'stew': '🍲',
    'salad': '🥗',
    'pasta': '🍝',
    'spaghetti': '🍝',
    'penne': '🍝',
    'pizza': '🍕',
    'burger': '🍔',
    'taco': '🌮',
    'burrito': '🌯',
    'fajita': '🌯',
    'wrap': '🌯',
    'sandwich': '🥪',
    'toast': '🍞',
    'simit': '🥯',
    'bagel': '🥯',
    'pancake': '🥞',
    'omelette': '🍳',
    'scramble': '🍳',
    'menemen': '🍳',
    'shakshuka': '🍳',
    'egg': '🥚',
    'smoothie': '🥤',
    'pudding': '🍮',
    'parfait': '🍨',
    'ice cream': '🍨',
    'yogurt': '🥣',
    'oatmeal': '🥣',
    'oats': '🥣',
    'porridge': '🥣',
    'rice': '🍚',
    'pilaf': '🍚',
    'risotto': '🍚',
    'sushi': '🍣',
    'noodle': '🍜',
    'stir-fry': '🥘',
    'curry': '🍛',
    'kebab': '🍢',
    'skewer': '🍢',
    'köfte': '🍡',
    'meatball': '🍡',
    'shawarma': '🥙',
    'börek': '🥧',
    'pide': '🫓',
    'flatbread': '🫓',
    'hummus': '🥣',
    'dip': '🥣',
    'chips': '🍟',
    'popcorn': '🍿',
    'energy ball': '🍫',
    'bliss ball': '🍫',
    'chocolate': '🍫',
    'bar': '🍫',
    'fruit': '🍓',
    'trail mix': '🥜',
  };

  static const Map<String, String> _ingredientEmoji = {
    'salmon': '🐟',
    'sea_bass': '🐟',
    'sea_bream': '🐟',
    'cod': '🐟',
    'tuna': '🐟',
    'sardine': '🐟',
    'shrimp': '🦐',
    'squid': '🦑',
    'mussel': '🦪',
    'chicken_breast': '🍗',
    'chicken_thigh': '🍗',
    'chicken_wing': '🍗',
    'turkey_breast': '🍗',
    'ground_beef': '🥩',
    'beef_steak': '🥩',
    'lamb': '🥩',
    'veal': '🥩',
    'pork_chop': '🥓',
    'eggs': '🥚',
    'tofu': '🧊',
    'red_lentil': '🫘',
    'green_lentil': '🫘',
    'chickpea': '🫘',
    'black_bean': '🫘',
    'kidney_bean': '🫘',
    'white_bean': '🫘',
    'edamame': '🫛',
    'eggplant': '🍆',
    'tomato': '🍅',
    'potato': '🥔',
    'sweet_potato': '🍠',
    'avocado': '🥑',
    'banana': '🍌',
    'apple': '🍎',
    'strawberry': '🍓',
    'blueberry': '🫐',
    'mango': '🥭',
    'orange': '🍊',
    'spinach': '🥬',
    'kale': '🥬',
    'broccoli': '🥦',
    'mushroom': '🍄',
    'walnut': '🥜',
    'almond': '🥜',
    'peanut': '🥜',
    'cashew': '🥜',
    'cheddar_cheese': '🧀',
    'feta_cheese': '🧀',
    'parmesan': '🧀',
    'mozzarella': '🧀',
    'bread': '🍞',
    'honey': '🍯',
  };

  static const Map<MealType, String> _mealTypeEmoji = {
    MealType.breakfast: '🍳',
    MealType.lunch: '🍽️',
    MealType.dinner: '🍲',
    MealType.snack: '🍎',
  };
}

import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../data/explore_data.dart';
import '../models/recipe.dart';

/// Illustration stand-in for recipe photography.
///
/// Recipes ship without images, and bundling ~120 photos would balloon the
/// app. Instead every recipe gets a deterministic cuisine-coloured gradient
/// with a dish emoji picked from its name/ingredients, so cards and detail
/// headers always render something recognisable. A real [Recipe.imagePath]
/// takes precedence whenever one exists.
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
    final image = recipe.imagePath;
    if (image != null && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          image,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          // A missing/renamed asset must not break the screen.
          errorBuilder: (_, __, ___) => _illustration(),
        ),
      );
    }
    return _illustration();
  }

  Widget _illustration() {
    final colors = _gradientColors();
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          // Oversized watermark emoji bleeding off the corner
          Positioned(
            right: -height * 0.12,
            bottom: -height * 0.18,
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: height * 0.72,
                color: Colors.white.withAlpha(38),
              ),
            ),
          ),
          Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: height * 0.38),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _gradientColors() {
    for (final id in recipe.cuisineIds) {
      final gradient = cuisineGradients[id];
      if (gradient != null) {
        return [Color(gradient[0]), Color(gradient[1])];
      }
    }
    final fallback = cuisineGradients['international']!;
    return [Color(fallback[0]), Color(fallback[1])];
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

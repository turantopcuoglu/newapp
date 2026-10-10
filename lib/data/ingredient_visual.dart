import '../models/ingredient.dart';
import 'mock_ingredients.dart';

/// Lookup of a catalogue ingredient by id. The emoji and gradient tiles that
/// used to live here are gone: every ingredient has a photo now
/// (`IngredientImage`).

final Map<String, Ingredient> _byId = {
  for (final ingredient in mockIngredients) ingredient.id: ingredient,
};

Ingredient? ingredientById(String id) => _byId[id];

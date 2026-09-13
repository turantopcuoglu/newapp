import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/models/user_profile.dart';
import 'package:nutri_guide/services/diet_classifier.dart';
import 'package:nutri_guide/services/recommendation_service.dart';

Recipe _recipe(
  String id, {
  MealType mealType = MealType.lunch,
  List<String> ingredientIds = const ['tomato'],
  List<String> allergenTags = const [],
  List<CheckInType> checkInTags = const [],
}) =>
    Recipe(
      id: id,
      name: {'en': id, 'tr': id},
      description: {'en': '', 'tr': ''},
      mealType: mealType,
      ingredientIds: ingredientIds,
      allergenTags: allergenTags,
      checkInTags: checkInTags,
    );

void main() {
  final service = RecommendationService();

  group('allergen safety', () {
    test('recipes with a profile allergen are never recommended', () {
      final recipes = [
        _recipe('safe'),
        _recipe('gluteny', allergenTags: ['gluten']),
        _recipe('dairy_gluten', allergenTags: ['dairy', 'gluten']),
      ];
      const profile = UserProfile(allergies: ['Gluten']);

      final result = service.getRecommendations(
        allRecipes: recipes,
        profile: profile,
        checkIn: CheckInType.noSpecificIssue,
        inventoryIds: {},
      );

      final ids = result.values
          .expand((list) => list)
          .map((s) => s.recipe.id)
          .toList();
      expect(ids, ['safe']);
    });

    test('disliked ingredients are excluded in browsing lists too', () {
      final recipes = [
        _recipe('with_onion', ingredientIds: ['onion', 'tomato']),
        _recipe('no_onion', ingredientIds: ['tomato']),
      ];
      const profile = UserProfile(dislikedIngredients: ['onion']);

      final result = service.getAllSafeRecipes(
        allRecipes: recipes,
        profile: profile,
        inventoryIds: {},
      );

      expect(result.map((s) => s.recipe.id), ['no_onion']);
    });
  });

  group('diet preferences', () {
    final dietService =
        RecommendationService(dietClassifier: DietClassifier(mockIngredients));

    test('vegetarian preference excludes meat recipes everywhere', () {
      final recipes = [
        _recipe('meaty', ingredientIds: ['chicken_breast', 'tomato']),
        _recipe('veggie', ingredientIds: ['tomato', 'onion']),
      ];
      const profile =
          UserProfile(dietPreferences: [DietClassifier.vegetarian]);

      final browsing = dietService.getAllSafeRecipes(
        allRecipes: recipes,
        profile: profile,
        inventoryIds: {},
      );
      expect(browsing.map((s) => s.recipe.id), ['veggie']);

      final recommended = dietService.getRecommendations(
        allRecipes: recipes,
        profile: profile,
        checkIn: CheckInType.noSpecificIssue,
        inventoryIds: {},
      );
      final ids = recommended.values
          .expand((list) => list)
          .map((s) => s.recipe.id);
      expect(ids, ['veggie']);
    });

    test('no preferences means no diet filtering', () {
      final recipes = [
        _recipe('meaty', ingredientIds: ['chicken_breast', 'tomato']),
      ];

      final result = dietService.getAllSafeRecipes(
        allRecipes: recipes,
        profile: const UserProfile(),
        inventoryIds: {},
      );
      expect(result, hasLength(1));
    });
  });

  group('health conditions', () {
    // Same nutrient profile on both, differing only in an ingredient the
    // magnesium filter looks for — so the health term is the only thing that
    // can separate them.
    Recipe withMagnesium(String id) => Recipe(
          id: id,
          name: {'en': id},
          description: {'en': ''},
          ingredientIds: const ['spinach', 'tomato'],
          carbType: CarbType.complex,
          fiberLevel: NutrientLevel.high,
          proteinLevel: NutrientLevel.high,
        );

    Recipe withoutMagnesium(String id) => Recipe(
          id: id,
          name: {'en': id},
          description: {'en': ''},
          ingredientIds: const ['lettuce', 'tomato'],
          carbType: CarbType.complex,
          fiberLevel: NutrientLevel.high,
          proteinLevel: NutrientLevel.high,
        );

    test('a declared condition lifts matching recipes up the ranking', () {
      final recipes = [withoutMagnesium('plain'), withMagnesium('rich')];
      const profile = UserProfile(
          healthConditions: [HealthCondition.magnesiumDeficiency]);

      final lunch = service.getRecommendations(
        allRecipes: recipes,
        profile: profile,
        checkIn: CheckInType.noSpecificIssue,
        inventoryIds: {},
      )[MealType.lunch]!;

      expect(lunch.first.recipe.id, 'rich');
      // Soft, not a filter: the other recipe is still offered.
      expect(lunch, hasLength(2));
    });

    test('no declared condition contributes nothing to the score', () {
      final recipes = [withoutMagnesium('plain'), withMagnesium('rich')];

      final scores = service
          .getRecommendations(
            allRecipes: recipes,
            profile: const UserProfile(),
            checkIn: CheckInType.noSpecificIssue,
            inventoryIds: {},
          )[MealType.lunch]!
          .map((s) => s.compatibilityScore)
          .toSet();

      // Identical on every other term, so equal scores prove the health term
      // dropped out rather than quietly reordering the list.
      expect(scores, hasLength(1));
    });

    test('partially matching recipes rank between full and no match', () {
      final recipes = [
        withoutMagnesium('none'),
        withMagnesium('one_of_two'),
      ];
      // Two conditions declared, the recipe satisfies only the magnesium one.
      const profile = UserProfile(healthConditions: [
        HealthCondition.magnesiumDeficiency,
        HealthCondition.vitaminB12Deficiency,
      ]);

      final lunch = service.getRecommendations(
        allRecipes: recipes,
        profile: profile,
        checkIn: CheckInType.noSpecificIssue,
        inventoryIds: {},
      )[MealType.lunch]!;

      final partial =
          lunch.firstWhere((s) => s.recipe.id == 'one_of_two');
      final none = lunch.firstWhere((s) => s.recipe.id == 'none');
      expect(partial.compatibilityScore,
          greaterThan(none.compatibilityScore));
    });
  });

  group('check-in soft scoring', () {
    test('non-matching recipes still appear, ranked below matching ones', () {
      final recipes = [
        _recipe('plain'),
        _recipe('energy', checkInTags: [CheckInType.lowEnergy]),
      ];

      final result = service.getRecommendations(
        allRecipes: recipes,
        profile: const UserProfile(),
        checkIn: CheckInType.lowEnergy,
        inventoryIds: {},
      );

      final lunch = result[MealType.lunch]!;
      expect(lunch.length, 2, reason: 'soft filter must not drop recipes');
      expect(lunch.first.recipe.id, 'energy');
    });

    test('period check-ins also match PMS-tagged recipes', () {
      final recipes = [
        _recipe('pms', checkInTags: [CheckInType.pms]),
        _recipe('plain'),
      ];

      final result = service.getRecommendations(
        allRecipes: recipes,
        profile: const UserProfile(),
        checkIn: CheckInType.periodCramps,
        inventoryIds: {},
      );

      expect(result[MealType.lunch]!.first.recipe.id, 'pms');
    });
  });

  group('pantry matching', () {
    test('compatibility percent reflects available vs missing ingredients',
        () {
      final recipes = [
        _recipe('half', ingredientIds: ['tomato', 'onion', 'rice', 'beef']),
      ];

      final result = service.getAllSafeRecipes(
        allRecipes: recipes,
        profile: const UserProfile(),
        inventoryIds: {'tomato', 'onion'},
      );

      final scored = result.single;
      expect(scored.availableIngredients, ['tomato', 'onion']);
      expect(scored.missingIngredients, ['rice', 'beef']);
      expect(scored.compatibilityPercent, 50);
    });

    test('recipes with more pantry overlap rank higher', () {
      final recipes = [
        _recipe('full_match', ingredientIds: ['tomato', 'onion']),
        _recipe('no_match', ingredientIds: ['beef', 'rice']),
      ];

      final result = service.getAllSafeRecipes(
        allRecipes: recipes,
        profile: const UserProfile(),
        inventoryIds: {'tomato', 'onion'},
      );

      expect(result.first.recipe.id, 'full_match');
      expect(result.first.compatibilityPercent, 100);
      expect(result.last.compatibilityPercent, 0);
    });
  });
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/components/save_recipe_button.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/favorites_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/screens/recipe_book/recipe_book_screen.dart';
import 'package:nutri_guide/screens/recipe_detail/recipe_detail_screen.dart';
import 'package:nutri_guide/services/recommendation_service.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  // A user-created recipe with a long name: this is the card that overflowed,
  // because it carries the delete button on top of the badges and the
  // "add to planner" button.
  const ownRecipe = Recipe(
    id: 'user_test_1',
    name: {'tr': 'ton balıklı makarna testi', 'en': 'tuna pasta test'},
    description: {'tr': 'fdjghkjdhgkdjfhgkds', 'en': 'fdjghkjdhgkdjfhgkds'},
    mealType: MealType.dinner,
    ingredientIds: ['pasta', 'tuna'],
    macros: MacroEstimation(calories: 590, proteinG: 30, carbsG: 70, fatG: 18),
    isUserCreated: true,
  );

  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService(await SharedPreferences.getInstance());
  });

  Widget host(Widget child) => ProviderScope(
        overrides: [
          bundledRecipesProvider.overrideWithValue(recipes),
          storageProvider.overrideWithValue(storage),
        ],
        child: MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: child,
        ),
      );

  Widget detailHost(Recipe recipe) => host(
        RecipeDetailScreen(
          scoredRecipe: ScoredRecipe(
            recipe: recipe,
            compatibilityScore: 0,
            availableIngredients: const [],
            missingIngredients: recipe.ingredientIds,
          ),
        ),
      );

  testWidgets('own-recipe card fits a narrow phone without overflowing',
      (tester) async {
    // The bug: badges and the action buttons shared one Row, so the Turkish
    // labels pushed the card 97 px past the screen edge.
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await storage.addMyRecipe(ownRecipe);
    await tester.pumpWidget(host(const RecipeBookScreen()));
    await tester.pumpAndSettle();

    // Search narrows the list down to the own recipe, whose card carries the
    // delete button as well.
    await tester.enterText(find.byType(TextField).first, 'makarna testi');
    await tester.pumpAndSettle();

    expect(find.text('ton balıklı makarna testi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every recipe book card offers a save button', (tester) async {
    await tester.pumpWidget(host(const RecipeBookScreen()));
    await tester.pumpAndSettle();

    // One preview card, one save button.
    expect(
      find.byType(SaveRecipeButton),
      findsAtLeast(1),
    );
  });

  testWidgets('saving from a preview card lands in saved recipes',
      (tester) async {
    await storage.addMyRecipe(ownRecipe);
    await tester.pumpWidget(host(const RecipeBookScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'makarna testi');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SaveRecipeButton).first);
    await tester.pumpAndSettle();

    expect(storage.getFavoriteRecipeIds(), contains(ownRecipe.id));

    // And tapping again takes it back out.
    await tester.tap(find.byType(SaveRecipeButton).first);
    await tester.pumpAndSettle();

    expect(storage.getFavoriteRecipeIds(), isNot(contains(ownRecipe.id)));
  });

  testWidgets('the detail screen can save the recipe too', (tester) async {
    final recipe = recipes.first;
    await tester.pumpWidget(detailHost(recipe));
    await tester.pumpAndSettle();

    expect(find.byType(SaveRecipeWideButton), findsOneWidget);
    expect(find.text('Tarifi Kaydet'), findsOneWidget);

    await tester.ensureVisible(find.byType(SaveRecipeWideButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SaveRecipeWideButton));
    await tester.pumpAndSettle();

    expect(storage.getFavoriteRecipeIds(), contains(recipe.id));
    // The label flips, so the button also reads as "already saved".
    expect(find.text('Kayıtlardan Çıkar'), findsOneWidget);
  });

  testWidgets('the saved state is shared between the card and the detail view',
      (tester) async {
    final recipe = recipes.first;
    final container = ProviderContainer(
      overrides: [
        bundledRecipesProvider.overrideWithValue(recipes),
        storageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);

    container.read(favoritesProvider.notifier).toggleFavorite(recipe.id);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: RecipeDetailScreen(
            scoredRecipe: ScoredRecipe(
              recipe: recipe,
              compatibilityScore: 0,
              availableIngredients: const [],
              missingIngredients: recipe.ingredientIds,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Saved elsewhere → the detail screen opens in the "saved" state.
    expect(find.text('Kayıtlardan Çıkar'), findsOneWidget);
  });
}

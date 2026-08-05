import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/screens/recipe_detail/recipe_detail_screen.dart';
import 'package:nutri_guide/services/recommendation_service.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService(await SharedPreferences.getInstance());
  });

  Widget host(Recipe recipe, Locale locale) => ProviderScope(
        overrides: [
          bundledRecipesProvider.overrideWithValue(recipes),
          storageProvider.overrideWithValue(storage),
        ],
        child: MaterialApp(
          locale: locale,
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
      );

  testWidgets('ingredient amounts are shown, not just names', (tester) async {
    // b001: 40 g oats, 200 ml milk, 1 teaspoon cinnamon
    final recipe = recipes.firstWhere((r) => r.id == 'b001');
    await tester.pumpWidget(host(recipe, const Locale('tr')));
    await tester.pumpAndSettle();

    expect(find.text('40 g'), findsOneWidget);
    expect(find.text('200 ml'), findsOneWidget);
    // Turkish short unit for teaspoon
    expect(find.text('1 çk'), findsOneWidget);
  });

  testWidgets('units follow the app locale', (tester) async {
    final recipe = recipes.firstWhere((r) => r.id == 'b001');
    await tester.pumpWidget(host(recipe, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('1 tsp'), findsOneWidget);
    expect(find.text('40 g'), findsOneWidget);
  });

  testWidgets('every bundled recipe renders an amount for each ingredient',
      (tester) async {
    // Guards the regression this test was written for: the data carried
    // quantities all along, the detail screen just never displayed them.
    for (final recipe in recipes) {
      await tester.pumpWidget(host(recipe, const Locale('tr')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: recipe.id);

      for (final id in recipe.ingredientIds) {
        final quantity = recipe.quantities[id];
        expect(quantity, isNotNull,
            reason: '${recipe.id}: "$id" has no quantity');
        expect(quantity!.amount, greaterThan(0),
            reason: '${recipe.id}: "$id" amount must be positive');
      }
    }
  });
}

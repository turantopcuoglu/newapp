import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/health_category_info.dart';
import 'package:nutri_guide/data/ingredient_visual.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/screens/explore/health_recipe_list_screen.dart';
import 'package:nutri_guide/screens/explore/special_detail_screen.dart';
import 'package:nutri_guide/services/special_category_matcher.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  final magnesium =
      specialCategories.firstWhere((c) => c.id == 'magnesiumDeficiency');

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

  testWidgets('the category page leads with the condition explanation',
      (tester) async {
    await tester.pumpWidget(host(SpecialDetailScreen(category: magnesium)));
    await tester.pumpAndSettle();

    // Header stays on top, unchanged.
    expect(find.text(magnesium.localizedName('tr')), findsOneWidget);

    final info = healthCategoryInfo[magnesium.id]!;
    expect(find.text(info.localizedSummary('tr')), findsOneWidget);
    expect(find.text(info.sections.first.localizedTitle('tr')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ingredient tiles sit under the explanation', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(host(SpecialDetailScreen(category: magnesium)));
    await tester.pumpAndSettle();

    final tiles = healthCategoryIngredients(magnesium, recipes);
    expect(tiles, isNotEmpty);

    // The first tile's ingredient is named on screen, below the summary.
    final firstName = ingredientById(tiles.first)!.localizedName('tr');
    final summary = healthCategoryInfo[magnesium.id]!.localizedSummary('tr');
    final tileY = tester.getTopLeft(find.text(firstName)).dy;
    final summaryY = tester.getTopLeft(find.text(summary)).dy;
    expect(tileY, greaterThan(summaryY));
  });

  testWidgets('tapping a tile opens only that ingredient\'s recipes',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(host(SpecialDetailScreen(category: magnesium)));
    await tester.pumpAndSettle();

    final ingredientId = healthCategoryIngredients(magnesium, recipes).first;
    final name = ingredientById(ingredientId)!.localizedName('tr');

    await tester.tap(find.text(name));
    await tester.pumpAndSettle();

    expect(find.byType(HealthRecipeListScreen), findsOneWidget);

    // Every recipe on the page carries the ingredient and the condition.
    final expected = recipes
        .where((r) => matchesCategoryIngredient(r, magnesium, ingredientId))
        .toList();
    expect(expected, isNotEmpty);
    expect(find.text(expected.first.localizedName('tr')), findsOneWidget);

    final unrelated = recipes.firstWhere(
      (r) => !matchesCategoryIngredient(r, magnesium, ingredientId),
    );
    expect(find.text(unrelated.localizedName('tr')), findsNothing);
  });

  testWidgets('every category renders without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final category in specialCategories) {
      await tester.pumpWidget(host(SpecialDetailScreen(category: category)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: category.id);
    }
  });
}

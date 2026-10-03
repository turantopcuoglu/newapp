import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/components/preference_warning.dart';
import 'package:nutri_guide/core/day_boundary.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/cooked_provider.dart';
import 'package:nutri_guide/providers/inventory_provider.dart';
import 'package:nutri_guide/providers/meal_plan_provider.dart';
import 'package:nutri_guide/providers/profile_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/shopping_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/screens/explore/special_detail_screen.dart';
import 'package:nutri_guide/screens/shopping/shopping_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  late StorageService storage;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = StorageService(await SharedPreferences.getInstance());
    container = ProviderContainer(overrides: [
      bundledRecipesProvider.overrideWithValue(recipes),
      storageProvider.overrideWithValue(storage),
    ]);
    addTearDown(container.dispose);
  });

  Widget host(Widget child) => UncontrolledProviderScope(
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
          home: child,
        ),
      );

  // The home meal list these used to drive is gone with the old HomeScreen;
  // the Today tab gets its own list in the next phase. Until then the data
  // contract is pinned here, independent of any screen.
  group('cooked log and consumed totals', () {
    // The app-day, not the calendar day: before 06:00 "today" is still
    // yesterday's date, and these tests must not depend on when they run.
    DateTime appToday() => DateTime.parse(DayBoundary.today());

    test('a planned meal is not consumption', () {
      final recipe = recipes.first;
      container.read(mealPlanProvider.notifier).addEntry(
            recipeId: recipe.id,
            date: appToday(),
            mealType: recipe.mealType,
          );
      expect(container.read(consumedTodayProvider).mealCount, 0);
    });

    test('ticking a meal off feeds the consumed totals, and untick undoes it',
        () {
      final recipe = recipes.first;
      final cooked = container.read(cookedProvider.notifier);

      cooked.toggleForDay(recipe, appToday());
      final consumed = container.read(consumedTodayProvider);
      expect(consumed.mealCount, 1);
      expect(consumed.calories, greaterThan(0));

      cooked.toggleForDay(recipe, appToday());
      expect(container.read(consumedTodayProvider).mealCount, 0);
    });

    test('toggling on a past day lands on that day, not today', () {
      final recipe = recipes.first;
      final yesterday = appToday().subtract(const Duration(days: 1));

      container.read(cookedProvider.notifier).toggleForDay(recipe, yesterday);

      final entries = container.read(cookedProvider);
      expect(entries, hasLength(1));
      expect(entries.single.dayKey, DayBoundary.keyForDate(yesterday));
      expect(container.read(consumedTodayProvider).mealCount, 0);
    });
  });

  group('preference-aware browsing', () {
    testWidgets('a disliked ingredient keeps its tile, with a warning',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final category =
          specialCategories.firstWhere((c) => c.id == 'magnesiumDeficiency');

      container.read(profileProvider.notifier).addDislikedIngredient('spinach');

      await tester.pumpWidget(host(SpecialDetailScreen(category: category)));
      await tester.pumpAndSettle();

      // Still on the page rather than filtered away — demoted to the end of
      // the grid, so it takes a scroll to reach.
      await tester.dragUntilVisible(
        find.text('Ispanak'),
        find.byType(CustomScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ispanak'), findsOneWidget);

      await tester.tap(find.text('Ispanak'));
      await tester.pumpAndSettle();

      // The list explains itself and offers the way out.
      expect(find.byType(PreferenceWarningCard), findsOneWidget);
      expect(
        find.text(AppLocalizations(const Locale('tr')).preferenceChangeCta),
        findsOneWidget,
      );
    });
  });

  group('shopping list', () {
    testWidgets('purchased items move to the kitchen in one tap',
        (tester) async {
      final shopping = container.read(shoppingProvider.notifier);
      shopping.addItem('Ispanak');
      shopping.addItem('Avokado');
      for (final item in container.read(shoppingProvider)) {
        shopping.togglePurchased(item.id);
      }

      await tester.pumpWidget(host(const ShoppingScreen()));
      await tester.pumpAndSettle();

      // Switch to the shopping list tab.
      await tester.tap(find.text(
          AppLocalizations(const Locale('tr')).shoppingTitle));
      await tester.pumpAndSettle();

      final label = AppLocalizations(const Locale('tr'))
          .shoppingMovePurchasedToKitchen(2);
      expect(find.text(label), findsOneWidget);

      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(container.read(shoppingProvider), isEmpty);
      expect(container.read(inventoryIdsProvider),
          containsAll(<String>['spinach', 'avocado']));
    });

    test('moving twice does not duplicate an ingredient', () {
      final inventory = container.read(inventoryProvider.notifier);
      expect(inventory.addAll(['spinach', 'avocado']), 2);
      expect(inventory.addAll(['spinach', 'walnut']), 1);
      expect(container.read(inventoryIdsProvider),
          {'spinach', 'avocado', 'walnut'});
    });

    test('removeItems takes exactly the listed items off', () {
      final shopping = container.read(shoppingProvider.notifier);
      shopping.addItem('a');
      shopping.addItem('b');
      final items = container.read(shoppingProvider);
      shopping.removeItems([items.first.id]);

      final left = container.read(shoppingProvider);
      expect(left, hasLength(1));
      expect(left.single.name, 'b');
    });
  });
}

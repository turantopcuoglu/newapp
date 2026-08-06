import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/components/cooked_tick.dart';
import 'package:nutri_guide/components/preference_warning.dart';
import 'package:nutri_guide/core/day_boundary.dart';
import 'package:nutri_guide/core/enums.dart';
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
import 'package:nutri_guide/screens/home/home_screen.dart';
import 'package:nutri_guide/screens/home/meal_recommendations_screen.dart';
import 'package:nutri_guide/screens/shopping/shopping_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  /// Testler saatten bağımsız olsun diye tarihler uygulama gününden
  /// üretilir: 06:00 öncesinde takvim günü ile uygulama günü ayrışıyor.
  DateTime appDay([int daysAgo = 0]) {
    final parts = DayBoundary.today().split('-').map(int.parse).toList();
    return DateTime(parts[0], parts[1], parts[2], 12)
        .subtract(Duration(days: daysAgo));
  }

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

  group('meal list and nutrition summary', () {
    testWidgets('a recipe marked cooked appears on the home meal list',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final recipe = recipes.first;
      // Same call the recipe page's "I cooked this" button makes.
      container.read(cookedProvider.notifier).markCooked(recipe);

      await tester.pumpWidget(host(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text(recipe.localizedName('tr')), findsWidgets);
      expect(find.byType(CookedTick), findsWidgets);
    });

    testWidgets('ticking a meal off feeds the consumed totals',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final recipe = recipes.first;
      final today = appDay();
      container.read(mealPlanProvider.notifier).addEntry(
            recipeId: recipe.id,
            date: today,
            mealType: recipe.mealType,
          );

      await tester.pumpWidget(host(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(container.read(consumedTodayProvider).mealCount, 0);

      await tester.tap(find.byType(CookedTick).first);
      await tester.pumpAndSettle();

      final consumed = container.read(consumedTodayProvider);
      expect(consumed.mealCount, 1);
      expect(consumed.calories, greaterThan(0));

      // And the same tick takes it back out.
      await tester.tap(find.byType(CookedTick).first);
      await tester.pumpAndSettle();
      expect(container.read(consumedTodayProvider).mealCount, 0);
    });

    test('toggling on a past day lands on that day, not today', () {
      final recipe = recipes.first;
      final yesterday = appDay(1);

      container.read(cookedProvider.notifier).toggleForDay(recipe, yesterday);

      final entries = container.read(cookedProvider);
      expect(entries, hasLength(1));
      expect(entries.single.dayKey, DayBoundary.keyForDate(yesterday));
      expect(container.read(consumedTodayProvider).mealCount, 0);
    });
  });

  group('daily recommendations search', () {
    testWidgets('searching an ingredient narrows the list', (tester) async {
      final scored = container
          .read(safeScoredRecipesProvider)
          .where((sr) => sr.recipe.mealType == MealType.breakfast)
          .toList();

      await tester.pumpWidget(host(MealRecommendationsScreen(
        mealType: MealType.breakfast,
        recipes: scored,
      )));
      await tester.pumpAndSettle();

      final withEggs = scored
          .where((sr) => sr.recipe.ingredientIds.contains('eggs'))
          .toList();
      expect(withEggs, isNotEmpty);

      // "yumurta" is the ingredient name, not part of every recipe title.
      await tester.enterText(find.byType(TextField).first, 'yumurta');
      await tester.pumpAndSettle();

      expect(find.text(withEggs.first.recipe.localizedName('tr')),
          findsOneWidget);

      final withoutEggs = scored.firstWhere(
        (sr) => !sr.recipe.ingredientIds.contains('eggs') &&
            !sr.recipe
                .localizedName('tr')
                .toLowerCase()
                .contains('yumurta'),
      );
      expect(find.text(withoutEggs.recipe.localizedName('tr')), findsNothing);
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

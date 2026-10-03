import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/components/cooked_tick.dart';
import 'package:nutri_guide/core/day_boundary.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/focus_guidance.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/cooked_provider.dart';
import 'package:nutri_guide/providers/meal_plan_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/main_shell.dart';
import 'package:nutri_guide/screens/wellness/routines_screen.dart';
import 'package:nutri_guide/services/recipe_search.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];
  late ProviderContainer container;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(
      overrides: [
        storageProvider.overrideWithValue(
          StorageService(await SharedPreferences.getInstance()),
        ),
        bundledRecipesProvider.overrideWithValue(recipes),
        wellnessStoreProvider.overrideWithValue(MemoryWellnessStore()),
      ],
    );
    addTearDown(container.dispose);
  });
  Widget host(Widget child) => UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.dark,
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
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  group('focus guidance', () {
    test('every check-in choice has a reason and real steps', () {
      final known = {...routineLibrary.map((r) => r.id), 'water'};
      for (final focus in CheckInType.values) {
        final g = focusGuidance[focus];
        expect(g, isNotNull, reason: focus.name);
        expect(g!.reasonTr, isNotEmpty);
        expect(g.reasonEn, isNotEmpty);
        expect(g.steps, isNotEmpty);
        expect(known.containsAll(g.steps), isTrue, reason: focus.name);
      }
    });

    // Until the physician review, the copy may say what was prioritised,
    // never what the user lacks or what food will do for them.
    test('health copy stays on the wellness side of the line', () {
      const forbidden = [
        'eksiklik',
        'tedavi',
        'iyileştir',
        'teşhis',
        'hastalık',
        'garanti',
        'deficien',
        'treat',
        'cure',
        'diagnos',
        'heal',
        'guarantee',
      ];
      final texts = [
        for (final g in focusGuidance.values) ...[g.reasonTr, g.reasonEn],
        genericReasonTr,
        genericReasonEn,
      ];
      for (final text in texts) {
        for (final word in forbidden) {
          expect(text.toLowerCase(), isNot(contains(word)), reason: text);
        }
      }
    });

    test('the reason only claims a priority the ranking applied', () {
      final tagged = recipes.firstWhere(
        (r) => r.checkInTags.contains(CheckInType.lowEnergy),
      );
      final untagged = recipes.firstWhere(
        (r) => !recipeMatchesFocus(r, CheckInType.lowEnergy),
      );
      final low = focusGuidance[CheckInType.lowEnergy]!.reasonTr;
      expect(
        recommendationReason(tagged, CheckInType.lowEnergy, 'tr'),
        startsWith(low),
      );
      expect(
        recommendationReason(untagged, CheckInType.lowEnergy, 'tr'),
        genericReasonTr,
      );
      expect(recommendationReason(tagged, null, 'tr'), genericReasonTr);
    });

    // A cramp recipe once came with "warm, light" in its reason and was a
    // cold sandwich. Whatever the sentence names must be in the recipe.
    test('every ingredient the reason names is in that recipe', () {
      for (final focus in CheckInType.values) {
        final g = focusGuidance[focus]!;
        if (g.nutrientSource == null) continue;
        for (final recipe in recipes.where(
          (r) => recipeMatchesFocus(r, focus),
        )) {
          final reason = recommendationReason(recipe, focus, 'tr');
          final listed = healthConditionIngredients[g.nutrientSource]!;
          final named = mockIngredients.where(
            (i) =>
                listed.contains(i.id) &&
                reason.contains(': ') &&
                reason
                    .split(': ')
                    .last
                    .split(RegExp(r' ve |\.'))
                    .contains(i.localizedName('tr')),
          );
          for (final ingredient in named) {
            expect(
              recipe.ingredientIds,
              contains(ingredient.id),
              reason: '${recipe.id}: $reason',
            );
          }
        }
      }
    });
  });

  test('searching an ingredient finds the recipes that contain it', () {
    final withEggs = recipes.firstWhere(
      (r) =>
          r.ingredientIds.contains('eggs') &&
          !r.localizedName('tr').toLowerCase().contains('yumurta'),
    );
    final withoutEggs = recipes.firstWhere(
      (r) =>
          !r.ingredientIds.contains('eggs') &&
          !recipeMatchesQuery(r, 'yumurta', 'tr'),
    );
    expect(recipeMatchesQuery(withEggs, 'yumurta', 'tr'), isTrue);
    expect(recipeMatchesQuery(withEggs, 'YUMURTA', 'tr'), isTrue);
    expect(recipeMatchesQuery(withoutEggs, 'yumurta', 'tr'), isFalse);
    expect(recipeMatchesQuery(withoutEggs, '  ', 'tr'), isTrue);
  });

  testWidgets('Today asks for a check-in first, then explains its pick', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(host(const MainShell(promptOnOpen: false)));
    await tester.pumpAndSettle();
    expect(find.text('Başlayalım'), findsOneWidget);
    expect(find.text(genericReasonTr, findRichText: true), findsNothing);

    await container
        .read(wellnessProvider.notifier)
        .selectFocus(
          CheckInType.lowEnergy,
          container.read(wellnessNowProvider),
        );
    await tester.pumpAndSettle();
    expect(find.text('Başlayalım'), findsNothing);
    expect(
      find.textContaining(focusGuidance[CheckInType.lowEnergy]!.reasonTr),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ticking a meal on Today feeds the consumed totals', (
    tester,
  ) async {
    phone(tester);
    final recipe = recipes.first;
    container
        .read(mealPlanProvider.notifier)
        .addEntry(
          recipeId: recipe.id,
          date: DateTime.parse(DayBoundary.today()),
          mealType: recipe.mealType,
        );
    await tester.pumpWidget(host(const MainShell(promptOnOpen: false)));
    await tester.pumpAndSettle();
    expect(container.read(consumedTodayProvider).mealCount, 0);

    final tick = find.byType(CookedTick);
    await tester.scrollUntilVisible(
      tick,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(tick);
    await tester.pumpAndSettle();
    expect(container.read(consumedTodayProvider).mealCount, 1);
    expect(find.textContaining('Bugün 1 öğün'), findsOneWidget);

    await tester.tap(tick);
    await tester.pumpAndSettle();
    expect(container.read(consumedTodayProvider).mealCount, 0);
    await tester.pumpWidget(const SizedBox());
  });
}

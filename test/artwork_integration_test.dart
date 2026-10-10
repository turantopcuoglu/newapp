import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/components/atlas_image.dart';
import 'package:nutri_guide/components/empty_state_artwork.dart';
import 'package:nutri_guide/components/ingredient_image.dart';
import 'package:nutri_guide/components/recipe_visual.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/explore/explore_screen.dart';
import 'package:nutri_guide/screens/explore/cuisine_detail_screen.dart';
import 'package:nutri_guide/screens/explore/health_recipe_list_screen.dart';
import 'package:nutri_guide/screens/explore/special_detail_screen.dart';
import 'package:nutri_guide/screens/explore/saved_recipes_screen.dart';
import 'package:nutri_guide/screens/onboarding_screen.dart';
import 'package:nutri_guide/screens/onboarding_health_screen.dart';
import 'package:nutri_guide/screens/onboarding_allergies_screen.dart';
import 'package:nutri_guide/screens/recipe_book/recipe_book_screen.dart';
import 'package:nutri_guide/screens/shopping/shopping_screen.dart';
import 'package:nutri_guide/screens/wellness/mood_picker_screen.dart';
import 'package:nutri_guide/screens/wellness/progress_screen.dart';
import 'package:nutri_guide/screens/wellness/today_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final family in ['WellnessSans', 'Roboto']) {
      final font = FontLoader(family);
      for (final weight in ['light', 'regular', 'medium', 'bold']) {
        font.addFont(rootBundle.load('assets/fonts/roboto-$weight.ttf'));
      }
      await font.load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  final recipes = [
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];

  for (final mode in [CheckInType.lowEnergy, CheckInType.bloated]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets(
        'artwork screens stay usable in ${mode.name} at text scale $scale',
        (tester) async {
          tester.view.physicalSize = Size(scale == 1 ? 390 : 320, 844);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          SharedPreferences.setMockInitialValues({});
          final container = ProviderContainer(
            overrides: [
              storageProvider.overrideWithValue(
                StorageService(await SharedPreferences.getInstance()),
              ),
              bundledRecipesProvider.overrideWithValue(recipes),
              wellnessStoreProvider.overrideWithValue(MemoryWellnessStore()),
              // Evening, so Today shows the closing card.
              wellnessNowProvider.overrideWithValue(
                DateTime(2026, 10, 8, 20, 30),
              ),
            ],
          );
          addTearDown(container.dispose);
          final boundary = GlobalKey();
          Future<void> show(Widget screen) async {
            await tester.pumpWidget(const SizedBox());
            await tester.pumpWidget(
              UncontrolledProviderScope(
                container: container,
                child: MaterialApp(
                  theme: AppTheme.forPalette(MoodPalette.all[mode]!),
                  locale: const Locale('tr'),
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(scale),
                      disableAnimations: true,
                    ),
                    child: child!,
                  ),
                  home: RepaintBoundary(
                    key: boundary,
                    child: Scaffold(body: screen),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final error = tester.takeException();
            expect(
              error,
              isNull,
              reason:
                  '${screen.runtimeType}: ${error is FlutterError ? error.toString(minLevel: DiagnosticLevel.fine) : error}',
            );
          }

          Future<void> capture(String name) async {
            if (!const bool.fromEnvironment('CAPTURE_WELLNESS') || scale != 1) {
              return;
            }
            await tester.runAsync(() async {
              for (final image in tester.widgetList<Image>(
                find.byType(Image),
              )) {
                await precacheImage(image.image, boundary.currentContext!);
              }
              // Ingredient photos are atlas cells, not Image widgets.
              for (final atlas in tester.widgetList<AtlasImage>(
                find.byType(AtlasImage),
              )) {
                await precacheImage(
                  AssetImage(atlas.asset),
                  boundary.currentContext!,
                );
              }
            });
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final object =
                boundary.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            await tester.runAsync(() async {
              final image = await object.toImage(pixelRatio: 2);
              final bytes = await image.toByteData(
                format: ui.ImageByteFormat.png,
              );
              final dir = Directory('output/artwork-integration')
                ..createSync(recursive: true);
              File(
                '${dir.path}/${mode.name}-$name.png',
              ).writeAsBytesSync(bytes!.buffer.asUint8List());
              image.dispose();
            });
          }

          await show(const ExploreScreen());
          await capture('cuisines');
          await tester.tap(find.text('Sana Özel'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.drag(
            find.byType(NestedScrollView),
            const Offset(0, -520),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await capture('health-areas');
          await show(CuisineDetailScreen(cuisine: worldCuisines.first));
          await capture('cuisine-detail');
          await show(SpecialDetailScreen(category: specialCategories[4]));
          await capture('health-detail');
          // How far the grid is depends on the text scale; scroll to it.
          for (
            var i = 0;
            i < 12 && find.byType(IngredientImage).evaluate().isEmpty;
            i++
          ) {
            await tester.drag(
              find.byType(CustomScrollView),
              const Offset(0, -300),
            );
            await tester.pumpAndSettle();
          }
          expect(find.byType(IngredientImage), findsWidgets);
          expect(tester.takeException(), isNull);
          await capture('health-ingredients');
          await show(
            HealthRecipeListScreen(
              category: specialCategories[4],
              ingredientId: 'spinach',
            ),
          );
          expect(find.byType(IngredientImage), findsOneWidget);
          await capture('ingredient-list');
          await show(const OnboardingScreen());
          await capture('welcome');
          await show(const OnboardingHealthScreen());
          await capture('health-step');
          await show(const OnboardingAllergiesScreen());
          await capture('safety-step');
          await show(const ProgressScreen());
          expect(find.byType(EmptyStateArtwork), findsOneWidget);
          await capture('progress');
          await show(const SavedRecipesScreen());
          expect(find.byType(EmptyStateArtwork), findsOneWidget);
          await capture('saved-empty');
          await show(const ShoppingScreen());
          // Kitchen rows carry the ingredient photo.
          expect(find.byType(IngredientImage), findsWidgets);
          await capture('kitchen');
          await tester.tap(find.text('Alışveriş Listesi'));
          await tester.pumpAndSettle();
          expect(find.byType(EmptyStateArtwork), findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('shopping-empty');
          await show(const RecipeBookScreen());
          // Recipe cards carry the dish photo, not a meal-type icon.
          expect(find.byType(RecipeVisual), findsWidgets);
          await capture('recipe-book');
          await tester.enterText(
            find.byType(TextField).first,
            'zzzznotarecipe',
          );
          await tester.pumpAndSettle();
          expect(find.byType(EmptyStateArtwork), findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('no-results');
          await show(const MoodPickerScreen());
          for (final mode in [
            CheckInType.stressed,
            CheckInType.anxious,
            CheckInType.poorSleep,
            CheckInType.noSpecificIssue,
          ]) {
            expect(find.text(MoodPalette.all[mode]!.tr), findsOneWidget);
          }
          await capture('mood-picker');
          await show(TodayScreen(navigate: (_) {}));
          expect(find.byKey(eveningCloseoutKey), findsOneWidget);
          await capture('evening-closeout');
          final notifier = container.read(wellnessProvider.notifier);
          for (var day = 4; day <= 8; day++) {
            await notifier.saveEvening(
              DateTime(2026, 10, day, 21),
              energy: day % 3 + 1,
              mood: 2,
            );
          }
          await show(const ProgressScreen());
          for (
            var i = 0;
            i < 12 && find.textContaining('akşamın').evaluate().isEmpty;
            i++
          ) {
            await tester.drag(
              find.byType(Scrollable).first,
              const Offset(0, -300),
            );
            await tester.pumpAndSettle();
          }
          expect(find.textContaining('akşamın'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await capture('weekly-insight');
          await tester.pumpWidget(const SizedBox());
        },
      );
    }
  }
}

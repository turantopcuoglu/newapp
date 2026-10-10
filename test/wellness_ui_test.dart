import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/models/wellness.dart';
import 'package:nutri_guide/services/recipe_timing.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/providers/profile_provider.dart';
import 'package:nutri_guide/providers/inventory_provider.dart';
import 'package:nutri_guide/providers/cooked_provider.dart';
import 'package:nutri_guide/screens/wellness/cooking_screen.dart';
import 'package:nutri_guide/screens/wellness/moonlit_recipe_screen.dart';
import 'package:nutri_guide/screens/main_shell.dart';
import 'package:nutri_guide/screens/wellness/check_in_screen.dart';
import 'package:nutri_guide/screens/wellness/health_connections_screen.dart';
import 'package:nutri_guide/screens/wellness/routines_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('WellnessSans');
    for (final weight in ['light', 'regular', 'medium', 'bold']) {
      final bytes = File('assets/fonts/roboto-$weight.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];
  late ProviderContainer container;
  late MemoryWellnessStore store;
  final boundary = GlobalKey();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = MemoryWellnessStore();
    container = ProviderContainer(
      overrides: [
        storageProvider.overrideWithValue(
          StorageService(await SharedPreferences.getInstance()),
        ),
        bundledRecipesProvider.overrideWithValue(recipes),
        wellnessStoreProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);
  });
  Widget host(Widget child, {String locale = 'tr', double scale = 1}) =>
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.dark,
          locale: Locale(locale),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: RepaintBoundary(key: boundary, child: child),
        ),
      );
  Future<void> capture(WidgetTester tester, String name) async {
    if (!const bool.fromEnvironment('CAPTURE_WELLNESS')) return;
    await tester.runAsync(() async {
      for (final board in ['daily', 'food', 'ritual', 'journey']) {
        await precacheImage(
          AssetImage('assets/moonlit/$board.png'),
          boundary.currentContext!,
        );
      }
    });
    await tester.pumpAndSettle();
    final object =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await object.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('output/wellness-build');
      await dir.create(recursive: true);
      await File(
        '${dir.path}/$name.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets(
    'five sections work at phone width and preserve core food tools',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(host(const MainShell(promptOnOpen: false)));
      await tester.pumpAndSettle();
      expect(find.text('Bugün senin için'), findsOneWidget);
      await capture(tester, '01-today');
      for (final tab in ['Beslen', 'İyi oluş', 'Gelişim', 'Profil']) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: tab);
        await capture(
          tester,
          tab == 'Beslen'
              ? '02-nourish'
              : tab == 'İyi oluş'
              ? '03-routines'
              : tab == 'Gelişim'
              ? '04-progress'
              : '05-profile',
        );
      }
      await tester.pumpWidget(const SizedBox());
    },
  );
  test(
    '15-minute check-in finds timed recipes without admitting unknown times',
    () async {
      await container
          .read(wellnessProvider.notifier)
          .checkIn(
            DailyCheckIn(
              recordedAt: container.read(wellnessNowProvider),
              prepMinutes: 15,
            ),
          );
      final matching = container.read(wellnessRecipesProvider);
      expect(matching, isNotEmpty);
      expect(
        matching.every((s) => RecipeTiming.minutes(s.recipe)! <= 15),
        isTrue,
      );
      expect(
        RecipeTiming.minutes(
          const Recipe(id: 'unknown', name: {}, description: {}),
        ),
        isNull,
      );
      expect(
        RecipeTiming.minutes(
          const Recipe(id: 's003', name: {}, description: {}),
        ),
        260,
        reason: 'Chilling time must not become a quick preparation promise',
      );
      expect(
        RecipeTiming.minutes(
          const Recipe(
            id: 'b001',
            name: {},
            description: {},
            isUserCreated: true,
          ),
        ),
        isNull,
      );
    },
  );
  testWidgets(
    'optional check-in starts empty and saves only explicit answers',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(host(const WellnessCheckInScreen()));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate((w) => w is ChoiceChip && w.selected),
        findsNothing,
      );
      await tester.tap(find.text('Düşük').first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Günümü hazırla'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Günümü hazırla'));
      await tester.pumpAndSettle();
      expect(store.initial.checkIns.single.energy, 1);
      expect(store.initial.checkIns.single.mood, isNull);
      expect(store.initial.checkIns.single.sleepQuality, isNull);
    },
  );
  testWidgets(
    'approved layouts render with explicit sample records on all eight screens',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      container.read(profileProvider.notifier).updateName('Ece');
      container.read(profileProvider.notifier).updateAllergies(['nuts']);
      container
          .read(profileProvider.notifier)
          .toggleDietPreference('dairyFree');
      container.read(inventoryProvider.notifier).addAll(['chickpea', 'bulgur']);
      final now = container.read(wellnessNowProvider);
      await container
          .read(wellnessProvider.notifier)
          .checkIn(
            DailyCheckIn(
              recordedAt: now,
              mood: 2,
              energy: 1,
              sleepQuality: 2,
              prepMinutes: 15,
            ),
          );
      await container
          .read(wellnessProvider.notifier)
          .update((s) => s.copyWith(bedtimeMinutes: 1380));
      await tester.pumpWidget(host(const MainShell(promptOnOpen: false)));
      await tester.pumpAndSettle();
      await capture(tester, 'reference-01-today');
      for (final tab in ['Beslen', 'İyi oluş', 'Gelişim', 'Profil']) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: tab);
        await capture(
          tester,
          'reference-${['Beslen', 'İyi oluş', 'Gelişim', 'Profil'].indexOf(tab) + 2}',
        );
      }
      final chosen = container
          .read(wellnessRecipesProvider)
          .firstWhere((r) => r.recipe.id == 'moonlit_bulgur_bowl');
      final screens = <String, Widget>{
        '06-check-in': const WellnessCheckInScreen(),
        '07-breathing': RoutineSessionScreen(routine: routineLibrary.first),
        '08-recipe': MoonlitRecipeScreen(scored: chosen),
      };
      for (final entry in screens.entries) {
        await tester.pumpWidget(host(entry.value));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: entry.key);
        await capture(tester, entry.key);
      }
      container.read(profileProvider.notifier).updateAllergies([
        'nuts',
        'gluten',
      ]);
      await tester.pumpAndSettle();
      expect(find.textContaining('uygun değil'), findsOneWidget);
      expect(
        container
            .read(wellnessRecipesProvider)
            .any((s) => s.recipe.id == 'moonlit_bulgur_bowl'),
        isFalse,
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('cooking only logs consumption after explicit completion', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final recipe = container.read(wellnessRecipesProvider).first.recipe;
    await tester.pumpWidget(host(CookingScreen(recipe: recipe)));
    await tester.pumpAndSettle();
    expect(container.read(cookedProvider), isEmpty);
    // The step buttons sit in a fixed bar, always on screen.
    await tester.tap(find.text('Adımlara geç'));
    await tester.pumpAndSettle();
    for (var i = 0; i < recipe.localizedSteps('tr').length - 1; i++) {
      await tester.tap(find.text('Sonraki adım'));
      await tester.pumpAndSettle();
    }
    expect(container.read(cookedProvider), isEmpty);
    await tester.tap(find.text('Pişirdim, kaydet'));
    await tester.pumpAndSettle();
    expect(container.read(cookedProvider), hasLength(1));
  });
  testWidgets('cooking mode: prep list, step amounts, timers that keep '
      'running across steps', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // d001: salmon roasts "12-15 dakika" in step 7; step 4 is a 10 minute
    // head start for the vegetables.
    final recipe = recipes.firstWhere((r) => r.id == 'd001');
    var now = DateTime(2026, 10, 11, 18);
    await tester.pumpWidget(
      host(CookingScreen(recipe: recipe, now: () => now)),
    );
    await tester.pumpAndSettle();

    // Prep list: every ingredient with its amount, before any step.
    expect(find.text('HAZIRLIK'), findsOneWidget);
    expect(find.text('Somon'), findsOneWidget);
    expect(find.text('150 g'), findsOneWidget);
    expect(find.text('½ adet'), findsOneWidget);
    await capture(tester, '20-cooking-prep');
    await tester.tap(find.text('Somon'));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 / 8 hazır'), findsOneWidget);

    Future<void> next(String label) async {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    await next('Adımlara geç');
    await next('Sonraki adım'); // step 2: broccoli and carrot are cut
    expect(find.text('Bu adımda'), findsOneWidget);
    // Broccoli comes back in step 4, so its amount reads as the total.
    expect(
      find.text('Brokoli · 100 g (toplam)', findRichText: true),
      findsOneWidget,
    );

    await next('Sonraki adım');
    await next('Sonraki adım'); // step 4: the 10 minute head start
    expect(find.text('10 dk'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Başlat'));
    await tester.tap(find.byTooltip('Başlat'));
    await tester.pump();
    expect(find.text('10:00'), findsOneWidget);

    // Moving on does not stop the oven: the running timer follows along.
    await next('Sonraki adım');
    expect(find.textContaining('4. adım ·'), findsOneWidget);

    // The phone locks for ten minutes; the wall clock decides, not ticks.
    now = now.add(const Duration(minutes: 10));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('4. adım · süre doldu'), findsOneWidget);
    expect(find.text('4. adımın süresi doldu'), findsOneWidget);

    await next('Sonraki adım');
    await next('Sonraki adım'); // step 7: a range counts the short end
    expect(find.text('12–15 dk'), findsOneWidget);
    expect(find.text('Kısa süreyi sayar'), findsOneWidget);
    expect(
      find.text('Somon · 150 g (toplam)', findRichText: true),
      findsOneWidget,
    );
    await capture(tester, '21-cooking-step-timer');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('cooking mode fits a narrow phone at large text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final recipe = recipes.firstWhere((r) => r.id == 'd001');
    await tester.pumpWidget(host(CookingScreen(recipe: recipe), scale: 1.6));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    for (var i = 0; i < 7; i++) {
      final label = i == 0 ? 'Adımlara geç' : 'Sonraki adım';
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'page ${i + 1}');
    }
  });
  testWidgets('partial routine is never recorded as complete', (tester) async {
    await tester.pumpWidget(
      host(RoutineSessionScreen(routine: routineLibrary.first)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Başlat'), 250);
    await tester.tap(find.text('Başlat'));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Duraklat'));
    await tester.pump();
    expect(store.initial.routines, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('missing energy stays missing, including large English text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      host(const MainShell(promptOnOpen: false), locale: 'en', scale: 1.6),
    );
    await tester.pumpAndSettle();
    for (final tab in ['Nourish', 'Wellbeing', 'Progress', 'Profile']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: tab);
    }
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'unsupported platform offers manual usage and no fake connection',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      await tester.pumpWidget(host(const HealthConnectionsScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('manuel kayıtlarla'), findsOneWidget);
      expect(store.initial.health, isNull);
      await tester.pumpWidget(const SizedBox());
      debugDefaultTargetPlatformOverride = null;
    },
  );
  testWidgets('focused design screens remain usable with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final chosen = container.read(wellnessRecipesProvider).first;
    for (final screen in <Widget>[
      const WellnessCheckInScreen(),
      RoutineSessionScreen(routine: routineLibrary.first),
      MoonlitRecipeScreen(scored: chosen),
    ]) {
      await tester.pumpWidget(host(screen, locale: 'en', scale: 1.6));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${screen.runtimeType}');
    }
    await tester.pumpWidget(const SizedBox());
  });
}

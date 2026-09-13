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
      expect(find.text('Durumu değiştir'), findsOneWidget);
      await capture(tester, '01-today');
      for (final tab in ['Keşfet', 'Plan', 'Gelişim', 'Profil']) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: tab);
        await capture(
          tester,
          tab == 'Keşfet'
              ? '02-nourish'
              : tab == 'Plan'
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
        find.text('Bugünkü planımı hazırla'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Bugünkü planımı hazırla'));
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
      for (final tab in ['Keşfet', 'Plan', 'Gelişim', 'Profil']) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: tab);
        await capture(
          tester,
          'reference-${['Keşfet', 'Plan', 'Gelişim', 'Profil'].indexOf(tab) + 2}',
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
    await tester.pumpWidget(host(MoonlitCookingScreen(recipe: recipe)));
    await tester.pumpAndSettle();
    expect(container.read(cookedProvider), isEmpty);
    for (var i = 0; i < recipe.localizedSteps('tr').length - 1; i++) {
      await tester.scrollUntilVisible(find.text('Sonraki adım'), 150);
      await tester.tap(find.text('Sonraki adım'));
      await tester.pumpAndSettle();
    }
    expect(container.read(cookedProvider), isEmpty);
    await tester.scrollUntilVisible(find.text('Pişirdim, kaydet'), 150);
    await tester.tap(find.text('Pişirdim, kaydet'));
    await tester.pumpAndSettle();
    expect(container.read(cookedProvider), hasLength(1));
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
    for (final tab in ['Explore', 'Plan', 'Progress', 'Profile']) {
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

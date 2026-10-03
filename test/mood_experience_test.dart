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
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/core/wellness_motion.dart';
import 'package:nutri_guide/core/satin_texture.dart';
import 'package:nutri_guide/data/food_photo_catalog.dart';
import 'package:nutri_guide/data/mock_ingredients.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/models/wellness.dart';
import 'package:nutri_guide/providers/beverage_provider.dart';
import 'package:nutri_guide/providers/profile_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/main_shell.dart';
import 'package:nutri_guide/screens/wellness/mood_picker_screen.dart';
import 'package:nutri_guide/screens/wellness/routine_visual.dart';
import 'package:nutri_guide/screens/wellness/routines_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime(2026, 9, 8, 12);
  final recipes = <Recipe>[
    for (final path in RecipeRepository.bundleFiles)
      ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
  ];
  late ProviderContainer container;
  late MemoryWellnessStore store;
  final boundary = GlobalKey();
  setUpAll(() async {
    final loader = FontLoader('WellnessSans');
    for (final weight in ['light', 'regular', 'medium', 'bold']) {
      loader.addFont(
        Future.value(
          ByteData.sublistView(
            File('assets/fonts/roboto-$weight.ttf').readAsBytesSync(),
          ),
        ),
      );
    }
    await loader.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = MemoryWellnessStore();
    container = ProviderContainer(
      overrides: [
        storageProvider.overrideWithValue(
          StorageService(await SharedPreferences.getInstance()),
        ),
        wellnessStoreProvider.overrideWithValue(store),
        bundledRecipesProvider.overrideWithValue(recipes),
        wellnessNowProvider.overrideWithValue(now),
      ],
    );
    addTearDown(container.dispose);
  });
  Widget host(Widget child, {double scale = 1, bool reduce = false}) =>
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) => MaterialApp(
            theme: AppTheme.forPalette(ref.watch(moodPaletteProvider)),
            themeAnimationDuration: reduce
                ? Duration.zero
                : const Duration(milliseconds: 700),
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
                disableAnimations: reduce,
              ),
              child: child!,
            ),
            home: RepaintBoundary(key: boundary, child: child),
          ),
        ),
      );
  void phone(WidgetTester tester, {double width = 390}) {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> capture(
    WidgetTester tester,
    String name, {
    bool settle = true,
  }) async {
    if (!const bool.fromEnvironment('CAPTURE_WELLNESS')) return;
    final images =
        tester
            .widgetList<AtlasImage>(find.byType(AtlasImage))
            .map((i) => i.asset)
            .toSet()
          ..add(SatinTexture.asset);
    await tester.runAsync(() async {
      for (final path in images) {
        await precacheImage(AssetImage(path), boundary.currentContext!);
      }
    });
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
    final object =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await object.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await Directory('output/mood-experience').create(recursive: true);
      await File(
        'output/mood-experience/$name.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  }

  test(
    'all catalog dishes and ingredients have present, unique photo cells',
    () {
      expect(FoodPhotoCatalog.recipes.length, recipes.length);
      expect(FoodPhotoCatalog.recipes.values.toSet().length, recipes.length);
      for (final r in recipes) {
        final cell = FoodPhotoCatalog.recipes[r.id]!;
        expect(
          File('assets/food/recipes-${cell.$1}.png').lengthSync(),
          greaterThan(10000),
        );
      }
      for (final i in mockIngredients) {
        expect(
          FoodPhotoCatalog.ingredients.containsKey(i.id),
          isTrue,
          reason: i.id,
        );
        final cell = FoodPhotoCatalog.ingredients[i.id]!;
        expect(
          File('assets/food/ingredients-${cell.$1}.png').existsSync(),
          isTrue,
        );
      }
    },
  );
  test(
    'context change keeps explicit metrics and persists appearance without changing health records',
    () async {
      await container
          .read(wellnessProvider.notifier)
          .checkIn(
            DailyCheckIn(
              recordedAt: now,
              mood: 3,
              energy: 1,
              sleepQuality: 2,
              stress: 3,
              prepMinutes: 15,
            ),
          );
      await container
          .read(wellnessProvider.notifier)
          .selectFocus(CheckInType.periodCramps, now);
      final restored = WellnessData.fromJson(store.initial.toJson());
      final check = restored.checkInFor(now)!;
      expect(check.focus, CheckInType.periodCramps);
      expect(
        [
          check.mood,
          check.energy,
          check.sleepQuality,
          check.stress,
          check.prepMinutes,
        ],
        [3, 1, 2, 3, 15],
      );
      expect(restored.themeMode, 'periodCramps');
      expect(restored.routines, isEmpty);
      expect(restored.health, isNull);
      await container
          .read(wellnessProvider.notifier)
          .update((s) => s.copyWith(appearanceLocked: true));
      await container
          .read(wellnessProvider.notifier)
          .selectFocus(CheckInType.bloated, now);
      expect(container.read(todayCheckInProvider)!.focus, CheckInType.bloated);
      expect(
        container.read(moodPaletteProvider).mode,
        CheckInType.periodCramps,
      );
    },
  );
  test(
    'context ranks matching food while allergies remain a hard constraint',
    () async {
      container.read(profileProvider.notifier).updateAllergies(['fish']);
      for (final mode in [
        CheckInType.cantFocus,
        CheckInType.periodCramps,
        CheckInType.postWorkout,
      ]) {
        await container.read(wellnessProvider.notifier).selectFocus(mode, now);
        final safe = container.read(wellnessRecipesProvider);
        expect(safe, isNotEmpty);
        expect(
          safe.any((r) => r.recipe.allergenTags.contains('fish')),
          isFalse,
        );
        final tags = safe.first.recipe.checkInTags;
        expect(
          tags.contains(mode) ||
              (mode == CheckInType.periodCramps &&
                  tags.contains(CheckInType.pms)),
          isTrue,
        );
      }
    },
  );
  testWidgets(
    'all nine choices apply through the picker, persist, and color every tab',
    (tester) async {
      phone(tester);
      await tester.pumpWidget(host(const MainShell(promptOnOpen: false)));
      await tester.pumpAndSettle();
      for (final mode in CheckInType.values) {
        await tester.tap(find.text('Durumu değiştir'));
        await tester.pumpAndSettle();
        if ([
          CheckInType.pms,
          CheckInType.periodCramps,
          CheckInType.periodFatigue,
        ].contains(mode)) {
          await tester.tap(find.text('Regl dönemi'));
          await tester.pumpAndSettle();
        }
        await tester.ensureVisible(find.text(MoodPalette.all[mode]!.tr));
        await tester.tap(find.text(MoodPalette.all[mode]!.tr));
        await tester.pumpAndSettle();
        expect(container.read(todayCheckInProvider)!.focus, mode);
        expect(
          WellnessData.fromJson(store.initial.toJson()).themeMode,
          mode.name,
        );
        expect(
          Theme.of(
            tester.element(find.byType(MainShell)),
          ).scaffoldBackgroundColor,
          MoodPalette.all[mode]!.background,
        );
        await capture(tester, 'home-${mode.name}');
        for (final tab in ['Keşfet', 'Plan', 'Gelişim', 'Profil']) {
          await tester.tap(find.text(tab).last);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '${mode.name} $tab');
          expect(
            Theme.of(
              tester.element(find.byType(MainShell)),
            ).colorScheme.surface,
            MoodPalette.all[mode]!.surface,
          );
          if (mode == CheckInType.lowEnergy || mode == CheckInType.bloated) {
            await capture(
              tester,
              '${mode.name}-${['Keşfet', 'Plan', 'Gelişim', 'Profil'].indexOf(tab)}',
            );
          }
        }
        await tester.tap(find.text('Bugün').last);
        await tester.pumpAndSettle();
      }
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('information opens independently and water can be undone', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(host(const MainShell(promptOnOpen: false)));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Nefes hakkında bilgi'));
    await tester.pumpAndSettle();
    expect(find.byType(RoutineSessionScreen), findsNothing);
    expect(container.read(wellnessProvider).routines, isEmpty);
    await tester.tap(find.text('Anladım'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Su'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+250 ml'));
    await tester.pumpAndSettle();
    expect(container.read(beverageProvider.notifier).totalWaterToday(), 250);
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(container.read(beverageProvider.notifier).totalWaterToday(), 0);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'period picker remains readable with large text and system reduced motion',
    (tester) async {
      phone(tester, width: 360);
      await tester.pumpWidget(
        host(const MoodPickerScreen(), scale: 1.6, reduce: true),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Regl dönemi'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture(tester, 'picker-large-period');
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets(
    'reduced motion activates immediately, without an animation ticker',
    (tester) async {
      var count = 0;
      await tester.pumpWidget(
        host(
          Scaffold(
            body: MotionTap(
              onTap: () => count++,
              builder: (_, t) => Text('tap $t'),
            ),
          ),
          reduce: true,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('tap 0'));
      expect(count, 1);
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    },
  );
  testWidgets(
    'sessions pause on background without auto-resume or completion',
    (tester) async {
      phone(tester);
      await tester.pumpWidget(
        host(RoutineSessionScreen(routine: routineLibrary[0])),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Başlat'));
      await tester.tap(find.text('Başlat'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(
        tester.widget<RoutineVisual>(find.byType(RoutineVisual)).running,
        isTrue,
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(
        tester.widget<RoutineVisual>(find.byType(RoutineVisual)).running,
        isFalse,
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(
        tester.widget<RoutineVisual>(find.byType(RoutineVisual)).running,
        isFalse,
      );
      expect(store.initial.routines, isEmpty);
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('four session illustrations animate and stop when paused', (
    tester,
  ) async {
    phone(tester);
    for (final kind in ['breathe', 'mindful', 'walk', 'stretch']) {
      await tester.pumpWidget(
        host(
          Scaffold(
            body: Center(
              child: RoutineVisual(
                key: ValueKey(kind),
                kind: kind,
                running: true,
                elapsedMilliseconds: 0,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await capture(tester, 'motion-$kind-1', settle: false);
      await tester.pump(const Duration(milliseconds: 1400));
      await capture(tester, 'motion-$kind-2', settle: false);
      expect(tester.binding.hasScheduledFrame, isTrue);
      await tester.pumpWidget(
        host(
          Scaffold(
            body: Center(
              child: RoutineVisual(
                key: ValueKey(kind),
                kind: kind,
                running: false,
                elapsedMilliseconds: 2000,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'cancelled presses never act; a tap acts at once and a double tap once', (
    tester,
  ) async {
    phone(tester);
    var count = 0;
    await tester.pumpWidget(
      host(
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 140,
              height: 70,
              child: MotionTap(
                onTap: () => count++,
                builder: (_, _) => const Center(child: Text('Activate')),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Activate')),
    );
    await tester.pump(const Duration(milliseconds: 120));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(count, 0);
    // No waiting for the flourish: the action runs on the tap itself.
    await tester.tap(find.text('Activate'));
    expect(count, 1);
    // A second tap right after is the same intent (e.g. pushing a page twice).
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(find.text('Activate'));
    expect(count, 1);
    // Disposing mid-flourish neither repeats the action nor throws.
    await tester.pump(const Duration(milliseconds: 35));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(count, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'changing breathing pace preserves the running session and pause',
    (tester) async {
      phone(tester);
      await tester.pumpWidget(
        host(RoutineSessionScreen(routine: routineLibrary.first)),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Başlat'));
      await tester.tap(find.text('Başlat'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.ensureVisible(find.text('10 sn'));
      await tester.tap(find.text('10 sn'));
      await tester.pump(const Duration(milliseconds: 300));
      final scene = tester.widget<RoutineVisual>(find.byType(RoutineVisual));
      expect(scene.running, isTrue);
      expect(scene.cycleMilliseconds, 10000);
      expect(store.initial.routines, isEmpty);
      await tester.ensureVisible(find.text('Duraklat'));
      await tester.tap(find.text('Duraklat'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<RoutineVisual>(find.byType(RoutineVisual)).running,
        isFalse,
      );
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'standalone artwork stops when backgrounded and stays paused on resume',
    (tester) async {
      phone(tester);
      await tester.pumpWidget(
        host(
          const Scaffold(
            body: RoutineVisual(
              kind: 'mindful',
              running: true,
              elapsedMilliseconds: 0,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.binding.hasScheduledFrame, isTrue);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pumpWidget(const SizedBox());
    },
  );
}

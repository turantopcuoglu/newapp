// Actual Flutter screens with a controlled recipe fixture for visual comparison.
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/core/satin_texture.dart';
import 'package:nutri_guide/data/moonlit_recipe.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/main_shell.dart';
import 'package:nutri_guide/screens/wellness/mood_widgets.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('render reference material in three real application themes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(() async {
      final font = FontLoader('WellnessSans');
      for (final weight in ['light', 'regular', 'medium', 'bold']) {
        font.addFont(rootBundle.load('assets/fonts/roboto-$weight.ttf'));
      }
      await font.load();
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    });
    // Standalone renderer intentionally uses the test storage API.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    final now = DateTime(2026, 9, 8, 12);
    final container = ProviderContainer(
      overrides: [
        storageProvider.overrideWithValue(
          StorageService(await SharedPreferences.getInstance()),
        ),
        wellnessStoreProvider.overrideWithValue(MemoryWellnessStore()),
        bundledRecipesProvider.overrideWithValue([moonlitBowl]),
        wellnessNowProvider.overrideWithValue(now),
      ],
    );
    addTearDown(container.dispose);
    final boundary = GlobalKey();
    final folder = Directory('output/reference-material')
      ..createSync(recursive: true);
    Future<void> export(String name) async {
      final render =
          boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await render.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(
          '${folder.path}/$name.png',
        ).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }

    const modes = [
      CheckInType.pms,
      CheckInType.periodCramps,
      CheckInType.periodFatigue,
    ];
    for (final mode in modes) {
      await container.read(wellnessProvider.notifier).selectFocus(mode, now);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            key: ValueKey(mode),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.forPalette(MoodPalette.all[mode]!),
            locale: const Locale('tr'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: RepaintBoundary(
              key: boundary,
              child: const MainShell(promptOnOpen: false),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        for (final path in [
          SatinTexture.asset,
          'assets/moods/landscapes.png',
          'assets/moods/period-reference-v2.png',
          'assets/food/moonlit-bowl-hero-v2.png',
        ]) {
          await precacheImage(AssetImage(path), boundary.currentContext!);
        }
      });
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await export('matched-${mode.name}');
      final tile = tester.getRect(find.byType(FeatureTile).first);
      File('${folder.path}/bounds-${mode.name}.json').writeAsStringSync(
        '{"x":${tile.left * 2},"y":${tile.top * 2},"width":${tile.width * 2},"height":${tile.height * 2}}',
      );
      await tester.runAsync(() async {
        await precacheImage(
          FileImage(File('${folder.path}/matched-${mode.name}.png')),
          boundary.currentContext!,
        );
      });
    }
    await tester.pumpWidget(const SizedBox());
    tester.view.padding = const FakeViewPadding();
    tester.view.physicalSize = const Size(1280, 1024);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'WellnessSans'),
        home: RepaintBoundary(
          key: boundary,
          child: Material(
            color: const Color(0xFFF6F0E7),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Referansa göre güncellenen uygulama',
                    style: TextStyle(
                      fontFamily: 'WellnessSans',
                      fontSize: 26,
                      color: Color(0xFF32243C),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final mode in modes)
                        SizedBox(
                          width: 390,
                          child: Column(
                            children: [
                              Text(
                                MoodPalette.all[mode]!.tr,
                                style: const TextStyle(
                                  fontFamily: 'WellnessSans',
                                  fontSize: 20,
                                  color: Color(0xFF32243C),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.file(
                                  File(
                                    '${folder.path}/matched-${mode.name}.png',
                                  ),
                                  width: 390,
                                  height: 844,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Çalışan Flutter ekranları · Aynı örnek tarif · Doku, ışık ve derinlik karşılaştırması',
                    style: TextStyle(
                      fontFamily: 'WellnessSans',
                      fontSize: 13,
                      color: Color(0xFF6C616D),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(() async {
      for (final mode in modes) {
        await precacheImage(
          FileImage(File('${folder.path}/matched-${mode.name}.png')),
          boundary.currentContext!,
        );
      }
    });
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await export('reference-match');
    await tester.pumpWidget(const SizedBox());
  });
}

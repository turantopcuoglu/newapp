// Exports real UI interactions at a deterministic 30 fps. Not a device recording.
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
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/main_shell.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('WellnessSans');
    for (final weight in ['light', 'regular', 'medium', 'bold']) {
      font.addFont(rootBundle.load('assets/fonts/roboto-$weight.ttf'));
    }
    await font.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  testWidgets(
    'render palette, touch and navigation choreography',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      // This standalone frame renderer runs through flutter_test.
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(
            StorageService(await SharedPreferences.getInstance()),
          ),
          wellnessStoreProvider.overrideWithValue(MemoryWellnessStore()),
          bundledRecipesProvider.overrideWithValue([
            for (final file in RecipeRepository.bundleFiles)
              ...RecipeRepository.decodeRecipeList(
                File(file).readAsStringSync(),
              ),
          ]),
        ],
      );
      addTearDown(container.dispose);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.forPalette(ref.watch(moodPaletteProvider)),
              themeAnimationDuration: const Duration(milliseconds: 700),
              locale: const Locale('tr'),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (_, child) =>
                  RepaintBoundary(key: boundary, child: child!),
              home: const MainShell(promptOnOpen: false),
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        for (final asset
            in tester
                .widgetList<AtlasImage>(
                  find.byType(AtlasImage, skipOffstage: false),
                )
                .map((a) => a.asset)
                .toSet()) {
          await precacheImage(AssetImage(asset), boundary.currentContext!);
        }
      });
      final directory = Directory('tmp/motion-refinement/ui-frames')
        ..createSync(recursive: true);
      var frame = 0;
      Future<void> frames(int count) async {
        for (var i = 0; i < count; i++) {
          await tester.pump(const Duration(microseconds: 33333));
          expect(tester.takeException(), isNull);
          final render =
              boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await render.toImage(pixelRatio: 2);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            await File(
              '${directory.path}/${frame.toString().padLeft(4, '0')}.png',
            ).writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
          frame++;
        }
      }

      Future<void> touch(Finder finder, int after) async {
        await tester.ensureVisible(finder);
        final gesture = await tester.startGesture(tester.getCenter(finder));
        await frames(4);
        await gesture.up();
        await frames(after);
      }

      await frames(45);
      await touch(find.text('Keşfet').last, 38);
      await touch(find.text('Plan').last, 38);
      await touch(find.text('Bugün').last, 38);
      await touch(find.text('Durumu değiştir'), 45);
      await touch(find.text('Şişkinlik'), 75);
      await touch(find.text('Nefes'), 50);
      await touch(find.text('Başlat'), 100);
      await touch(find.text('Duraklat'), 35);
      await tester.pumpWidget(const SizedBox());
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

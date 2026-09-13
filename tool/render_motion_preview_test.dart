// Run explicitly with flutter test tool/render_motion_preview_test.dart.
// Exports the production animation widgets; this is not a device recording.
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/screens/wellness/routine_visual.dart';

void main() {
  testWidgets('export production routine motion preview', (tester) async {
    tester.view.physicalSize = const Size(800, 940);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(() async {
      final font = FontLoader('WellnessSans');
      for (final weight in ['regular', 'medium', 'bold']) {
        font.addFont(rootBundle.load('assets/fonts/roboto-$weight.ttf'));
      }
      await font.load();
    });
    final mode = ValueNotifier(CheckInType.lowEnergy);
    final running = ValueNotifier(true);
    addTearDown(mode.dispose);
    addTearDown(running.dispose);
    final boundary = GlobalKey();
    await tester.pumpWidget(
      ValueListenableBuilder(
        valueListenable: mode,
        builder: (_, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.forPalette(MoodPalette.all[value]!),
          themeAnimationDuration: const Duration(milliseconds: 700),
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
            child: Builder(
              builder: (context) {
                final p = context.palette;
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NutriGuide',
                          style: TextStyle(
                            fontSize: 16,
                            color: p.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hareketin ritmi',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1,
                            children: [
                              for (final entry in const {
                                'breathe': 'Nefes',
                                'mindful': 'Meditasyon',
                                'walk': 'Yürüyüş',
                                'stretch': 'Esneme',
                              }.entries)
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: p.surface,
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 14),
                                      Text(
                                        entry.value,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: running,
                                        builder: (_, active, _) =>
                                            RoutineVisual(
                                              key: ValueKey(entry.key),
                                              kind: entry.key,
                                              running: active,
                                              elapsedMilliseconds: 0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: running,
                          builder: (_, active, _) => Text(
                            active
                                ? 'Uygulamanın çalışan animasyon bileşenleri'
                                : 'Duraklatıldı · Hareket kullanıcı kontrolünde',
                            style: TextStyle(
                              fontSize: 14,
                              color: p.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    final directory = Directory('tmp/mood-implementation/motion-frames');
    directory.createSync(recursive: true);
    for (var frame = 0; frame < 450; frame++) {
      if (frame == 240) mode.value = CheckInType.bloated;
      if (frame == 390) running.value = false;
      await tester.pump(const Duration(microseconds: 33333));
      expect(tester.takeException(), isNull);
      final render =
          boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await render.toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(
          '${directory.path}/${frame.toString().padLeft(4, '0')}.png',
        ).writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
    await tester.pumpWidget(const SizedBox());
  });
}

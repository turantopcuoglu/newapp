// Asset preview, not an emulator screenshot. Uses the native launcher artwork.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('export NutriGuide launcher artwork preview', (tester) async {
    await tester.runAsync(() async {
      final font = FontLoader('WellnessSans')
        ..addFont(rootBundle.load('assets/fonts/roboto-regular.ttf'));
      await font.load();
      Future<ui.Image> read(String path) async {
        final codec = await ui.instantiateImageCodec(
          await File(path).readAsBytes(),
        );
        final frame = await codec.getNextFrame();
        codec.dispose();
        return frame.image;
      }

      final master = await read('assets/branding/nutriguide-icon.png');
      final foreground = await read(
        'android/app/src/main/res/drawable-xxxhdpi/ic_launcher_foreground.png',
      );
      final xml = File(
        'android/app/src/main/res/drawable/ic_launcher_monochrome.xml',
      ).readAsStringSync();
      final data = RegExp(
        r'android:pathData="([^"]+)"',
      ).firstMatch(xml)!.group(1)!;
      final tokens = RegExp(
        r'[MCZ]|-?\d+(?:\.\d+)?',
      ).allMatches(data).map((match) => match.group(0)!).toList();
      final silhouette = ui.Path();
      var cursor = 0;
      double number() => double.parse(tokens[cursor++]);
      while (cursor < tokens.length) {
        switch (tokens[cursor++]) {
          case 'M':
            silhouette.moveTo(number(), number());
          case 'C':
            silhouette.cubicTo(
              number(),
              number(),
              number(),
              number(),
              number(),
              number(),
            );
          case 'Z':
            silhouette.close();
          default:
            throw StateError('Unsupported native path command');
        }
      }
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      canvas.drawColor(const ui.Color(0xFFF6F0E9), ui.BlendMode.src);

      void text(
        String value,
        double x,
        double y,
        double size, {
        ui.Color color = const ui.Color(0xFF38283E),
        double width = 500,
      }) {
        final builder =
            ui.ParagraphBuilder(
                ui.ParagraphStyle(fontFamily: 'WellnessSans', fontSize: size),
              )
              ..pushStyle(ui.TextStyle(color: color))
              ..addText(value);
        final paragraph = builder.build()
          ..layout(ui.ParagraphConstraints(width: width));
        canvas.drawParagraph(paragraph, ui.Offset(x, y));
      }

      final paint = ui.Paint()..filterQuality = ui.FilterQuality.high;
      void drawImage(ui.Image image, ui.Rect dst) => canvas.drawImageRect(
        image,
        ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        dst,
        paint,
      );

      // Adaptive layers are 108 dp; the usual launcher viewport is 72 dp.
      // The foreground inset matches flutter_launcher_icons.yaml (14%).
      void adaptive(
        double x,
        double y,
        double side, {
        bool circle = true,
        bool themed = false,
      }) {
        final rect = ui.Rect.fromLTWH(x, y, side, side);
        canvas.save();
        if (circle) {
          canvas.clipPath(ui.Path()..addOval(rect));
        } else {
          canvas.clipRRect(
            ui.RRect.fromRectAndRadius(rect, ui.Radius.circular(side * .24)),
          );
        }
        canvas.drawPaint(
          ui.Paint()
            ..color = themed
                ? const ui.Color(0xFFE5D0FF)
                : const ui.Color(0xFF2C2034),
        );
        final layer = side * 108 / 72;
        final inset = layer * .14;
        final destination = ui.Rect.fromLTWH(
          x + (side - layer) / 2 + inset,
          y + (side - layer) / 2 + inset,
          layer - inset * 2,
          layer - inset * 2,
        );
        if (themed) {
          canvas.translate(destination.left, destination.top);
          canvas.scale(destination.width / 1254);
          canvas.drawPath(
            silhouette,
            ui.Paint()..color = const ui.Color(0xFF362345),
          );
        } else {
          drawImage(foreground, destination);
        }
        canvas.restore();
      }

      text('NutriGuide', 48, 34, 36);
      text('Ay ışığı · Beslenme · Denge', 48, 85, 18);
      canvas.save();
      canvas.clipRRect(
        ui.RRect.fromRectAndRadius(
          const ui.Rect.fromLTWH(48, 142, 408, 408),
          const ui.Radius.circular(88),
        ),
      );
      drawImage(master, const ui.Rect.fromLTWH(48, 142, 408, 408));
      canvas.restore();

      text('Telefon menüsü için', 518, 145, 25);
      adaptive(523, 210, 108);
      adaptive(678, 210, 108, circle: false);
      adaptive(833, 210, 108, themed: true);
      for (final x in [531.0, 686.0, 841.0]) {
        text('NutriGuide', x, 331, 16, width: 115);
      }
      text('Yuvarlak', 538, 360, 14);
      text('Köşeli', 707, 360, 14);
      text('Temalı', 859, 360, 14);
      text('Küçük boyutta görünüm', 518, 422, 18);
      adaptive(523, 468, 48);
      adaptive(602, 460, 64, circle: false);
      text('48 px', 525, 533, 13);
      text('64 px', 613, 533, 13);
      text(
        'Simge önizlemesi · Cihaz ekran görüntüsü değildir.',
        48,
        592,
        14,
        color: const ui.Color(0xFF7D6F80),
        width: 900,
      );

      final picture = recorder.endRecording();
      final preview = await picture.toImage(1000, 640);
      final bytes = await preview.toByteData(format: ui.ImageByteFormat.png);
      Directory('output/branding').createSync(recursive: true);
      File(
        'output/branding/launcher-preview.png',
      ).writeAsBytesSync(bytes!.buffer.asUint8List());
      preview.dispose();
      picture.dispose();
      master.dispose();
      foreground.dispose();
    });
  });
}

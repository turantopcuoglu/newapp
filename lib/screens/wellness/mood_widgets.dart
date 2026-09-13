import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import '../../core/atmosphere_surface.dart';
import 'wellness_ui.dart';

class MoodGlyph extends StatelessWidget {
  final String kind;
  final double size, progress;
  final Color? color;
  const MoodGlyph(
    this.kind, {
    super.key,
    this.size = 54,
    this.progress = 0,
    this.color,
  });
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _GlyphPainter(kind, color ?? context.palette.mint, progress),
      ),
    ),
  );
}

class _GlyphPainter extends CustomPainter {
  final String kind;
  final Color color;
  final double progress;
  _GlyphPainter(this.kind, this.color, this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 40, size.height / 40);
    final pulse = math.sin(progress * math.pi);
    final ink = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(color, Colors.white, .22)!,
        color,
        Color.lerp(color, Colors.black, .035)!,
      ],
      stops: const [0, .58, 1],
    ).createShader(const Rect.fromLTWH(0, 0, 40, 40));
    final p = Paint()
      ..color = color
      ..shader = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    void line(double x, double y, double a, double b) =>
        canvas.drawLine(Offset(x, y), Offset(a, b), p);
    void circle(double x, double y, double r, {bool fill = false}) =>
        canvas.drawCircle(
          Offset(x, y),
          r,
          Paint()
            ..color = color
            ..shader = ink
            ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
            ..strokeWidth = 2.7,
        );
    switch (kind) {
      case 'wind':
      case 'waves':
      case 'belly':
        if (kind == 'belly') {
          canvas.drawPath(
            Path()
              ..moveTo(10, 4)
              ..cubicTo(16, 16, 3, 23, 8, 35),
            p,
          );
          canvas.drawPath(
            Path()
              ..moveTo(30, 4)
              ..cubicTo(24, 16, 37, 23, 32, 35),
            p,
          );
        }
        for (var i = 0; i < 3; i++) {
          final y = 12 + i * 8.0;
          canvas.drawPath(
            Path()
              ..moveTo(5, y)
              ..cubicTo(
                17,
                y - 8 - pulse * 3,
                23,
                y + 8 + pulse * 3,
                35,
                y - 1,
              ),
            p,
          );
        }
        break;
      case 'moon':
      case 'moonBattery':
        canvas.save();
        canvas.translate(20, 20);
        canvas.rotate(-pulse * .2);
        canvas.translate(-20, -20);
        canvas.drawPath(
          Path()
            ..moveTo(26, 3)
            ..cubicTo(11, 6, 11, 29, 32, 29)
            ..cubicTo(20, 44, 0, 27, 8, 12)
            ..cubicTo(11, 6, 19, 2, 26, 3),
          Paint()..shader = ink,
        );
        canvas.restore();
        if (kind == 'moonBattery') {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              const Rect.fromLTWH(20, 24, 17, 11),
              const Radius.circular(2),
            ),
            p,
          );
          line(24, 27, 24, 32);
        }
        break;
      case 'water':
        canvas.drawPath(
          Path()
            ..moveTo(20, 3)
            ..cubicTo(16, 12, 6, 19, 7, 27)
            ..cubicTo(8, 42, 32, 42, 33, 27)
            ..cubicTo(34, 19, 24, 12, 20, 3),
          p,
        );
        if (progress > 0 && progress < 1) {
          p.color = color.withValues(alpha: (1 - progress) * .8);
          canvas.drawOval(
            Rect.fromCenter(
              center: const Offset(20, 28),
              width: 10 + 26 * progress,
              height: 3 + 9 * progress,
            ),
            p,
          );
        }
        break;
      case 'battery':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(3, 10, 31, 21),
            const Radius.circular(3),
          ),
          p,
        );
        line(38, 17, 38, 24);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(7, 14, 4 + pulse * 17, 13),
            const Radius.circular(1),
          ),
          Paint()..shader = ink,
        );
        break;
      case 'cookie':
        canvas.drawPath(
          Path()
            ..moveTo(30, 7)
            ..cubicTo(30, 17, 35, 16, 36, 18)
            ..cubicTo(39, 36, 18, 43, 7, 29)
            ..cubicTo(-3, 10, 16, -1, 25, 4)
            ..quadraticBezierTo(22, 12, 30, 7),
          p,
        );
        for (final o in [
          const Offset(14, 13),
          const Offset(11, 24),
          const Offset(21, 20),
          const Offset(24, 31),
        ]) {
          circle(o.dx, o.dy, 1.5 + pulse * .7, fill: true);
        }
        break;
      case 'focus':
        for (var i = 0; i < 3; i++) {
          circle(20, 20, 6 + i * 6 + pulse * (2 - i));
        }
        break;
      case 'calendar':
      case 'calendarHeart':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(5, 9, 30, 27),
            const Radius.circular(4),
          ),
          p,
        );
        line(5, 17, 35, 17);
        line(12, 4, 12, 12);
        line(28, 4, 28, 12);
        if (kind == 'calendarHeart') {
          canvas.drawPath(
            Path()
              ..moveTo(25, 34)
              ..cubicTo(4, 22, 21, 17, 25, 24)
              ..cubicTo(31, 15, 43, 24, 25, 34),
            Paint()..shader = ink,
          );
        } else {
          line(13, 24, 18, 24);
          line(23, 24, 28, 24);
        }
        break;
      case 'walk':
      case 'stretch':
        circle(22, 6, 3.5, fill: true);
        p.strokeWidth = 3.8;
        final swing = pulse * 5;
        line(20, 14, 17, 25);
        line(20, 14, 12 - swing, 18);
        line(12 - swing, 18, 9 - swing, 26);
        line(20, 14, 26 + swing, 22);
        line(26 + swing, 22, 33, 25);
        line(17, 25, 27 - swing, 34);
        line(27 - swing, 34, 30 - swing, 38);
        line(17, 25, 12 + swing, 32);
        line(12 + swing, 32, 6 + swing, 38);
        break;
      case 'dumbbell':
        canvas.save();
        canvas.translate(0, -pulse * 4);
        p.strokeWidth = 3.8;
        line(4, 16, 4, 26);
        line(10, 10, 10, 32);
        line(16, 15, 16, 27);
        line(16, 21, 24, 21);
        line(24, 15, 24, 27);
        line(30, 10, 30, 32);
        line(36, 16, 36, 26);
        canvas.restore();
        break;
      case 'sun':
        circle(20, 20, 7);
        canvas.save();
        canvas.translate(20, 20);
        canvas.rotate(pulse * .4);
        for (var i = 0; i < 8; i++) {
          canvas.rotate(math.pi / 4);
          line(0, 12, 0, 16);
        }
        canvas.restore();
        break;
      case 'bars':
        for (var i = 0; i < 4; i++) {
          final h = 9 + i * 6 + pulse * (4 - i);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(5 + i * 8.0, 36 - h, 4, h),
              const Radius.circular(1),
            ),
            p,
          );
        }
        break;
      case 'person':
        circle(20, 10, 6);
        canvas.drawPath(
          Path()
            ..moveTo(7, 36)
            ..lineTo(7, 30)
            ..cubicTo(7, 17, 33, 17, 33, 30)
            ..lineTo(33, 36)
            ..close(),
          p,
        );
        break;
      case 'bowl':
        canvas.drawPath(
          Path()
            ..moveTo(4, 18)
            ..lineTo(36, 18)
            ..cubicTo(34, 36, 6, 36, 4, 18),
          p,
        );
        line(13, 36, 27, 36);
        line(24, 13, 32, 3);
        line(12, 12, 10, 6);
        break;
      case 'heart':
        canvas.save();
        canvas.translate(20, 20);
        canvas.scale(1 + pulse * .16);
        canvas.translate(-20, -20);
        canvas.drawPath(
          Path()
            ..moveTo(20, 35)
            ..cubicTo(-11, 16, 12, -3, 20, 13)
            ..cubicTo(30, -3, 51, 16, 20, 35),
          p,
        );
        canvas.restore();
        break;
      case 'meditation':
        circle(20, 8, 4);
        canvas.drawPath(
          Path()
            ..moveTo(10, 28)
            ..lineTo(16, 18)
            ..quadraticBezierTo(20, 13, 24, 18)
            ..lineTo(30, 28),
          p,
        );
        canvas.drawOval(const Rect.fromLTWH(6, 27, 28, 9), p);
        line(16, 24, 11, 30);
        line(24, 24, 29, 30);
        break;
      case 'settings':
        for (var i = 0; i < 3; i++) {
          final y = 10 + i * 10.0;
          line(5, y, 35, y);
          canvas.drawCircle(
            Offset(i == 1 ? 27 : 13, y),
            3.5,
            Paint()..shader = ink,
          );
        }
        break;
      default:
        canvas.drawPath(
          Path()
            ..moveTo(8, 34)
            ..cubicTo(3, 11, 23, 8, 35, 5)
            ..cubicTo(38, 30, 15, 36, 8, 34)
            ..moveTo(8, 34)
            ..lineTo(28, 14),
          p,
        );
        break;
    }
    if (progress > 0 && progress < 1) _response(canvas);
  }

  void _response(Canvas canvas) {
    final t = progress;
    final envelope = math.sin(t * math.pi);
    final pen = Paint()
      ..color = color.withValues(alpha: envelope * .65)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = .9;
    if (kind == 'water') {
      final droplet = Path()
        ..moveTo(20, 3)
        ..cubicTo(16, 12, 6, 19, 7, 27)
        ..cubicTo(8, 42, 32, 42, 33, 27)
        ..cubicTo(34, 19, 24, 12, 20, 3);
      canvas.save();
      canvas.clipPath(droplet);
      final y = 36 - envelope * 15;
      final liquid = Path()
        ..moveTo(3, y)
        ..cubicTo(12, y - 4, 23, y + 4, 38, y - 2)
        ..lineTo(38, 42)
        ..lineTo(3, 42)
        ..close();
      canvas.drawPath(
        liquid,
        Paint()..color = color.withValues(alpha: .24 * envelope),
      );
      for (var i = 0; i < 3; i++) {
        canvas.drawCircle(
          Offset(13 + i * 7, 34 - ((t + i * .22) % 1) * 18),
          1.3,
          pen,
        );
      }
      canvas.restore();
    } else if (['wind', 'waves', 'belly', 'bowl'].contains(kind)) {
      for (var i = 0; i < 3; i++) {
        final start = ((t * 1.5 + i * .2) % 1) * 40;
        final y = kind == 'bowl' ? 10 - i * 3.0 : 10 + i * 10.0;
        canvas.drawPath(
          Path()
            ..moveTo(start - 9, y)
            ..quadraticBezierTo(start - 4, y - 4, start + 2, y - 1),
          pen,
        );
      }
    } else if ([
      'moon',
      'moonBattery',
      'sun',
      'meditation',
      'leaf',
    ].contains(kind)) {
      for (var i = 0; i < 4; i++) {
        final theta = i * math.pi / 2 + t * 1.5;
        final point =
            const Offset(20, 20) +
            Offset(math.cos(theta), math.sin(theta)) * 18;
        final reach = (i.isEven ? 2.0 : 1.2) * envelope;
        canvas.drawLine(
          point - Offset(reach, 0),
          point + Offset(reach, 0),
          pen,
        );
        canvas.drawLine(
          point - Offset(0, reach),
          point + Offset(0, reach),
          pen,
        );
      }
    } else if (kind == 'heart' || kind == 'calendarHeart') {
      for (var i = 0; i < 2; i++) {
        final wave = (t + i * .24) % 1;
        canvas.drawOval(
          Rect.fromCenter(
            center: const Offset(20, 21),
            width: 24 + wave * 15,
            height: 21 + wave * 15,
          ),
          pen..color = color.withValues(alpha: envelope * (1 - wave) * .4),
        );
      }
    } else if (kind == 'focus' || kind == 'settings') {
      for (var i = 0; i < 4; i++) {
        canvas.drawArc(
          Rect.fromCircle(center: const Offset(20, 20), radius: 17),
          i * math.pi / 2 + t * 2,
          .35 * envelope,
          false,
          pen,
        );
      }
    } else {
      for (var i = 0; i < 3; i++) {
        final x = 9 + i * 11.0;
        canvas.drawLine(Offset(x, 38), Offset(x + envelope * 4, 38), pen);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter old) =>
      old.kind != kind || old.color != color || old.progress != progress;
}

Future<void> showFeatureInfo(
  BuildContext context,
  String title,
  String description,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (sheet) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(sheet).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Text(description, style: Theme.of(sheet).textTheme.bodyLarge),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.pop(sheet),
            child: Text(sheet.w('Anladım', 'Got it')),
          ),
        ),
      ],
    ),
  ),
);

class InfoDot extends StatelessWidget {
  final String title, description;
  const InfoDot({super.key, required this.title, required this.description});
  @override
  Widget build(BuildContext context) => WellnessIconButton(
    tooltip: context.w('$title hakkında bilgi', 'About $title'),
    onPressed: () => showFeatureInfo(context, title, description),
    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    icon: SizedBox.square(
      dimension: 26,
      child: CustomPaint(
        painter: _InfoGlyphPainter(context.palette.textPrimary),
      ),
    ),
  );
}

class _InfoGlyphPainter extends CustomPainter {
  final Color color;
  const _InfoGlyphPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 26, size.height / 26);
    final pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.15;
    canvas.drawCircle(const Offset(13, 13), 11, pen);
    pen.strokeWidth = 1.4;
    pen.strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 11.4), const Offset(13.5, 11.4), pen);
    canvas.drawLine(const Offset(13.5, 11.4), const Offset(13.5, 17.4), pen);
    canvas.drawLine(const Offset(11.5, 17.4), const Offset(15.2, 17.4), pen);
    canvas.drawCircle(const Offset(13.2, 8), .8, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _InfoGlyphPainter old) => old.color != color;
}

class FeatureTile extends StatelessWidget {
  final String title, kind;
  final String? detail, info;
  final VoidCallback? onTap;
  final bool selected;
  const FeatureTile({
    super.key,
    required this.title,
    required this.kind,
    this.detail,
    this.info,
    this.onTap,
    this.selected = false,
  });
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Stack(
      children: [
        Positioned.fill(
          child: MotionTap(
            onTap: onTap,
            radius: BorderRadius.circular(16),
            builder: (context, t) => AtmosphereSurface(
              activity: t,
              selected: selected,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 66,
                      child: Center(
                        child: MoodGlyph(
                          kind,
                          size: kind == 'wind' || kind == 'waves' ? 66 : 60,
                          progress: t,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: p.textPrimary,
                        height: 1.13,
                      ),
                    ),
                    if (detail != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        detail!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: p.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        if (info != null)
          Positioned(
            right: 0,
            top: 0,
            child: InfoDot(title: title, description: info!),
          ),
        if (selected)
          Positioned(
            left: 10,
            top: 10,
            child: Icon(Icons.check_circle_rounded, size: 18, color: p.mint),
          ),
      ],
    );
  }
}

class FeatureGrid extends StatelessWidget {
  final List<Widget> children;
  final double height;
  const FeatureGrid({super.key, required this.children, this.height = 142});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final scale = MediaQuery.textScalerOf(context).scale(1);
      final columns = c.maxWidth < 290 ? 1 : 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          children.length,
          (i) => SizedBox(
            width: (c.maxWidth - 10 * (columns - 1)) / columns,
            height: height + (scale - 1) * 76,
            child: LiftIn(order: i, child: children[i]),
          ),
        ),
      );
    },
  );
}

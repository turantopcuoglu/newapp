import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Thin, round-ended strokes follow the icon family in the approved boards.
class MoonlitIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  const MoonlitIcon(this.name, {super.key, this.size = 26, this.color});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LinePainter(name, color ?? context.palette.textPrimary),
      ),
    ),
  );
}

class _LinePainter extends CustomPainter {
  final String name;
  final Color color;
  const _LinePainter(this.name, this.color);
  @override
  void paint(Canvas c, Size s) {
    c.save();
    c.scale(s.width / 28, s.height / 28);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    void line(double x, double y, double x2, double y2) =>
        c.drawLine(Offset(x, y), Offset(x2, y2), p);
    void path(Path v) => c.drawPath(v, p);
    switch (name) {
      case 'leaf':
        path(
          Path()
            ..moveTo(5, 23)
            ..cubicTo(-3, 5, 15, 7, 24, 2)
            ..cubicTo(26, 22, 14, 28, 7, 20),
        );
        path(
          Path()
            ..moveTo(3, 26)
            ..quadraticBezierTo(13, 17, 20, 9),
        );
      case 'bowl':
        path(
          Path()
            ..moveTo(2, 12)
            ..lineTo(26, 12)
            ..quadraticBezierTo(24, 25, 14, 25)
            ..quadraticBezierTo(4, 25, 2, 12),
        );
        line(7, 26, 21, 26);
        path(
          Path()
            ..moveTo(7, 11)
            ..cubicTo(1, 2, 12, 0, 11, 9),
        );
        path(
          Path()
            ..moveTo(15, 11)
            ..cubicTo(10, 1, 22, -1, 20, 8),
        );
        path(
          Path()
            ..moveTo(21, 11)
            ..quadraticBezierTo(23, 4, 27, 8),
        );
      case 'calendar':
        c.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(3, 5, 22, 21),
            const Radius.circular(2),
          ),
          p,
        );
        line(3, 11, 25, 11);
        line(9, 2, 9, 8);
        line(20, 2, 20, 8);
      case 'bars':
        for (final v in [
          (4.0, 16.0, 5.0, 10.0),
          (12.0, 5.0, 5.0, 21.0),
          (20.0, 12.0, 5.0, 14.0),
        ]) {
          c.drawRect(Rect.fromLTWH(v.$1, v.$2, v.$3, v.$4), p);
        }
        line(2, 27, 27, 27);
      case 'person':
        c.drawCircle(const Offset(14, 7), 5, p);
        path(
          Path()
            ..moveTo(3, 26)
            ..lineTo(3, 22)
            ..cubicTo(3, 12, 25, 12, 25, 22)
            ..lineTo(25, 26)
            ..close(),
        );
      case 'wind':
        path(
          Path()
            ..moveTo(2, 10)
            ..lineTo(19, 10)
            ..cubicTo(29, 10, 27, -1, 20, 4),
        );
        path(
          Path()
            ..moveTo(2, 15)
            ..lineTo(23, 15)
            ..cubicTo(30, 15, 26, 25, 21, 22),
        );
        path(
          Path()
            ..moveTo(2, 20)
            ..lineTo(12, 20)
            ..cubicTo(18, 20, 16, 28, 11, 25),
        );
      case 'sun':
        c.drawCircle(const Offset(14, 14), 5, p);
        for (final v in [
          (14.0, 1.0, 14.0, 5.0),
          (14.0, 23.0, 14.0, 27.0),
          (1.0, 14.0, 5.0, 14.0),
          (23.0, 14.0, 27.0, 14.0),
          (5.0, 5.0, 8.0, 8.0),
          (20.0, 20.0, 23.0, 23.0),
          (5.0, 23.0, 8.0, 20.0),
          (20.0, 8.0, 23.0, 5.0),
        ]) {
          line(v.$1, v.$2, v.$3, v.$4);
        }
      case 'phone':
        c.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(6, 2, 17, 25),
            const Radius.circular(2),
          ),
          p,
        );
        line(13, 5, 17, 5);
        c.drawCircle(const Offset(14.5, 23), .7, p);
        path(
          Path()
            ..moveTo(10, 14)
            ..quadraticBezierTo(17, 9, 20, 15)
            ..quadraticBezierTo(17, 21, 11, 18)
            ..close(),
        );
      case 'waves':
        for (var y = 5.0; y < 26; y += 8) {
          path(
            Path()
              ..moveTo(1, y)
              ..quadraticBezierTo(7, y - 7, 14, y)
              ..quadraticBezierTo(21, y + 7, 27, y),
          );
        }
      case 'cup':
        path(
          Path()
            ..moveTo(4, 12)
            ..lineTo(22, 12)
            ..lineTo(21, 21)
            ..quadraticBezierTo(13, 27, 5, 21)
            ..close(),
        );
        path(
          Path()
            ..moveTo(22, 14)
            ..cubicTo(30, 12, 28, 22, 22, 21),
        );
        line(2, 27, 25, 27);
        for (var x = 7.0; x < 22; x += 6) {
          path(
            Path()
              ..moveTo(x, 9)
              ..cubicTo(x - 4, 6, x + 3, 5, x, 1),
          );
        }
      case 'heart':
        path(
          Path()
            ..moveTo(14, 25)
            ..cubicTo(-10, 10, 8, -5, 14, 6)
            ..cubicTo(20, -5, 38, 10, 14, 25),
        );
      default:
        c.drawCircle(const Offset(14, 14), 12, p);
        line(14, 6, 14, 15);
        line(14, 15, 20, 18);
    }
    c.restore();
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.name != name || old.color != color;
}

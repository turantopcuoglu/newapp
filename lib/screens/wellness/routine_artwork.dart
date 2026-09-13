import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/mood_palette.dart';

/// Display-synchronised native geometry. The parent layout does not repaint.
class RoutineArtwork extends CustomPainter {
  final String kind;
  final Animation<double> motion;
  final MoodPalette palette;
  final bool completed;
  RoutineArtwork(this.kind, this.motion, this.palette, {this.completed = false})
    : super(repaint: motion);
  static const tau = math.pi * 2;
  Color ink(double alpha) => palette.mint.withValues(alpha: alpha.clamp(0, 1));
  void glow(Canvas c, Offset p, double r, double opacity) => c.drawCircle(
    p,
    r,
    Paint()
      ..shader = RadialGradient(
        colors: [ink(opacity), ink(opacity * .3), ink(0)],
        stops: const [0, .4, 1],
      ).createShader(Rect.fromCircle(center: p, radius: r)),
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final c = Offset(size.width / 2, size.height * .48);
    final r = math.min(size.width * .39, size.height * .43);
    final a = motion.value * tau;
    glow(canvas, c + Offset(math.sin(a) * 12, -12), r * 1.45, .13);
    // Offset horizon veils and stable particles provide depth, not visual noise.
    for (var i = 0; i < 4; i++) {
      final y = size.height * (.72 + i * .048), wave = math.sin(a + i * .7) * 6;
      final path = Path()
        ..moveTo(-15, y)
        ..cubicTo(
          size.width * .24,
          y - 18 + wave,
          size.width * .63,
          y + 28 - wave,
          size.width + 15,
          y - 10,
        )
        ..lineTo(size.width + 15, size.height)
        ..lineTo(-15, size.height)
        ..close();
      canvas.drawPath(
        path,
        Paint()
          ..shader =
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ink(.025 + i * .008), ink(0)],
              ).createShader(
                Rect.fromLTWH(0, y - 25, size.width, size.height - y + 25),
              ),
      );
    }
    for (var i = 0; i < 22; i++) {
      final theta = i * 2.39996, d = r * (.73 + (i % 7) * .071);
      final point =
          c +
          Offset(
            math.cos(theta) * d + math.sin(a + i) * 3,
            math.sin(theta) * d + math.cos(a + i) * 2,
          );
      final alpha = .12 + (math.sin(a + i * 1.7) + 1) * .08;
      canvas.drawCircle(point, .65 + i % 3 * .2, Paint()..color = ink(alpha));
      if (i % 6 == 0) glow(canvas, point, 5, alpha);
    }
    if (kind == 'breathe') {
      breath(canvas, c, r, a);
    } else if (kind == 'mindful') {
      meditation(canvas, c + const Offset(0, -7), r, a);
    } else {
      figure(canvas, c, r, a, kind == 'walk');
    }
    if (completed) {
      for (var i = 0; i < 12; i++) {
        final p =
            c +
            Offset(math.cos(i * tau / 12), math.sin(i * tau / 12)) * r * .92;
        glow(canvas, p, 6, .3);
        canvas.drawCircle(p, 1.5, Paint()..color = ink(.65));
      }
    }
    canvas.restore();
  }

  void breath(Canvas canvas, Offset c, double r, double a) {
    final expansion = (1 - math.cos(a)) / 2;
    final core = r * (.47 + expansion * .11),
        orbit = r * (.7 + expansion * .21);
    // Three translucent layers of twelve silk petals open behind a lit pearl.
    for (var layer = 0; layer < 3; layer++) {
      for (var i = 0; i < 12; i++) {
        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.rotate(i * tau / 12 + layer * .095 + math.sin(a) * .065);
        final inner = core * (.73 + layer * .06), outer = orbit + layer * 5;
        final petal = Path()
          ..moveTo(-inner * .28, -inner)
          ..cubicTo(
            -outer * .51,
            -outer * .7,
            -outer * .41,
            -outer * 1.19,
            0,
            -outer,
          )
          ..cubicTo(
            outer * .28,
            -outer * .94,
            outer * .32,
            -inner * .88,
            inner * .22,
            -inner,
          )
          ..close();
        final rect = Rect.fromLTRB(
          -outer * .52,
          -outer * 1.2,
          outer * .5,
          -inner * .7,
        );
        canvas.drawPath(
          petal,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ink(.015), ink(.11 + layer * .026), ink(.012)],
            ).createShader(rect),
        );
        canvas.drawPath(
          petal,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = .55
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ink(.37 - layer * .06), ink(.035)],
            ).createShader(rect),
        );
        canvas.restore();
      }
    }
    glow(canvas, c, core * 1.7, .2);
    final disc = Rect.fromCircle(center: c, radius: core);
    canvas.drawCircle(
      c,
      core,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.35, -.48),
          radius: 1.25,
          colors: [
            Color.lerp(palette.surface, palette.mint, .35)!,
            Color.lerp(palette.background, palette.surface, .7)!,
            palette.background,
          ],
          stops: const [0, .48, 1],
        ).createShader(disc),
    );
    canvas.drawCircle(
      c,
      core,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..shader = SweepGradient(
          transform: const GradientRotation(-math.pi / 2),
          colors: [ink(.85), ink(.04), ink(.15), ink(.9)],
          stops: const [0, .3, .62, 1],
        ).createShader(disc),
    );
    for (var i = 0; i < 48; i++) {
      final theta = -math.pi / 2 + i * tau / 48;
      final d = Offset(math.cos(theta), math.sin(theta));
      canvas.drawLine(
        c + d * (orbit + 11),
        c + d * (orbit + (i % 6 == 0 ? 15 : 13)),
        Paint()
          ..color = ink(i / 48 <= motion.value ? .46 : .1)
          ..strokeWidth = .8,
      );
    }
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: orbit + 11),
      -math.pi / 2,
      a,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..color = ink(.52),
    );
    final point = c + Offset(math.sin(a), -math.cos(a)) * (orbit + 11);
    glow(canvas, point, 12, .6);
    canvas.drawCircle(point, 2.5, Paint()..color = palette.mint);
  }

  void meditation(Canvas canvas, Offset c, double r, double a) {
    // Inclined ribbons: far portions fall into shadow, near portions catch light.
    for (var ribbon = 0; ribbon < 3; ribbon++) {
      final turn = ribbon * math.pi / 3 + math.sin(a) * .09;
      Offset point(double t) {
        final x = math.cos(t) * r * (.75 + ribbon * .07);
        final y = math.sin(t) * r * (.25 + .04 * math.sin(a + ribbon));
        return c +
            Offset(
              x * math.cos(turn) - y * math.sin(turn),
              x * math.sin(turn) + y * math.cos(turn),
            );
      }

      final points = List.generate(97, (i) => point(i / 96 * tau));
      final path = Path()..addPolygon(points, false);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..shader = LinearGradient(
            colors: [ink(.01), ink(.08), ink(.01)],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
      for (var i = 0; i < 96; i++) {
        canvas.drawLine(
          points[i],
          points[i + 1],
          Paint()
            ..strokeWidth = 1
            ..color = ink(
              .15 + .38 * ((math.sin(i / 96 * tau + a + ribbon) + 1) / 2),
            ),
        );
      }
      for (var trail = 0; trail < 10; trail++) {
        final p = point(a + ribbon * tau / 3 - trail * .032);
        canvas.drawCircle(
          p,
          trail == 0 ? 2.6 : 1.1,
          Paint()..color = ink((1 - trail / 10) * .76),
        );
        if (trail == 0) glow(canvas, p, 8, .32);
      }
    }
    final center = c + Offset(0, math.sin(a) * 4);
    glow(canvas, center, r * .68, .3);
    final stone = Rect.fromCenter(
      center: center,
      width: r * .7,
      height: r * .84,
    );
    canvas.drawOval(
      stone,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.4, -.6),
          radius: 1.3,
          colors: [
            Color.lerp(palette.mint, Colors.white, .45)!,
            palette.mint,
            Color.lerp(palette.background, palette.mint, .18)!,
          ],
          stops: const [0, .28, 1],
        ).createShader(stone),
    );
    canvas.drawArc(
      stone.deflate(4),
      math.pi * 1.12,
      math.pi * .5,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8
        ..color = Colors.white.withValues(alpha: .43),
    );
    final ground = Rect.fromCenter(
      center: c + Offset(0, r * .9),
      width: r * (1.05 + .05 * math.sin(a)),
      height: 13,
    );
    canvas.drawOval(
      ground,
      Paint()
        ..shader = RadialGradient(
          colors: [ink(.22), ink(0)],
        ).createShader(ground),
    );
  }

  void figure(Canvas canvas, Offset c, double r, double a, bool walking) {
    canvas.save();
    canvas.translate(c.dx, c.dy + 1);
    canvas.scale(r / 125);
    final bob = walking ? math.cos(a * 2) * 2.2 : math.sin(a) * 1.5;
    final sway = walking ? math.sin(a) * 2 : math.sin(a) * 5;
    final shoulder = Offset(sway, -42 + bob),
        hip = Offset(-sway * .35, 14 + bob);
    for (var i = 0; i < 5; i++) {
      final t = (i / 5 + motion.value) % 1;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(walking ? 105 - t * 210 : (i - 2) * 28.0, 104),
          width: walking ? 19 : 5,
          height: walking ? 4 : 2,
        ),
        Paint()..color = ink(math.sin(t * math.pi) * .15),
      );
    }
    canvas.drawOval(
      const Rect.fromLTWH(-89, 97, 178, 16),
      Paint()
        ..shader = RadialGradient(
          colors: [ink(.22), ink(0)],
        ).createShader(const Rect.fromLTWH(-89, 97, 178, 16)),
    );
    Offset hand(bool front, double phase) {
      if (walking) {
        final swing = math.sin(phase + (front ? 0 : math.pi));
        return shoulder +
            Offset(37 * swing + (front ? 8 : -8), 40 - 13 * swing);
      }
      final raise = (1 - math.cos(phase)) / 2;
      return shoulder +
          Offset((front ? 1 : -1) * (60 - 12 * raise), 25 - 89 * raise);
    }

    void arm(bool front) {
      final start = shoulder + Offset(front ? 10 : -10, 5),
          end = hand(front, a);
      final mid = walking
          ? Offset((start.dx + end.dx) / 2 + (front ? 9 : -8), start.dy + 28)
          : Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2 + 5);
      limb(canvas, start, mid, end, 9, front ? 1 : .44);
      for (var i = 1; i < 7; i++) {
        canvas.drawCircle(
          hand(front, a - i * .055),
          1.25 - i * .1,
          Paint()..color = ink((7 - i) * .026),
        );
      }
    }

    void leg(bool front) {
      final swing = math.sin(a + (front ? 0 : math.pi));
      final start = hip + Offset(front ? 7 : -7, 0);
      final knee = walking
          ? Offset(start.dx + 22 * swing, 54 + bob - math.max(0, -swing) * 7)
          : Offset(start.dx + (front ? 12 : -12), 58);
      final ankle = walking
          ? Offset(start.dx + 39 * swing, 99 - math.max(0, -swing) * 17)
          : Offset(front ? 30 : -30, 99);
      limb(canvas, start, knee, ankle, 12, front ? 1 : .42);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(ankle.dx - 6, ankle.dy - 4, 18, 7),
          const Radius.circular(4),
        ),
        Paint()..color = ink(front ? .9 : .39),
      );
    }

    leg(false);
    arm(false);
    final torso = Path()
      ..moveTo(shoulder.dx - 12, shoulder.dy)
      ..quadraticBezierTo(
        shoulder.dx,
        shoulder.dy - 7,
        shoulder.dx + 12,
        shoulder.dy,
      )
      ..cubicTo(
        shoulder.dx + 17,
        shoulder.dy + 18,
        hip.dx + 10,
        hip.dy - 15,
        hip.dx + 11,
        hip.dy + 3,
      )
      ..quadraticBezierTo(hip.dx, hip.dy + 9, hip.dx - 11, hip.dy + 3)
      ..cubicTo(
        hip.dx - 8,
        hip.dy - 15,
        shoulder.dx - 17,
        shoulder.dy + 17,
        shoulder.dx - 12,
        shoulder.dy,
      )
      ..close();
    canvas.drawPath(
      torso,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Color.lerp(palette.mint, Colors.white, .25)!,
            palette.mint,
            Color.lerp(palette.surface, palette.mint, .36)!,
          ],
        ).createShader(torso.getBounds()),
    );
    leg(true);
    arm(true);
    final head = shoulder + const Offset(0, -21);
    canvas.drawCircle(
      head,
      12.8,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.4, -.5),
          colors: [
            Color.lerp(palette.mint, Colors.white, .35)!,
            palette.mint,
            Color.lerp(palette.surface, palette.mint, .55)!,
          ],
        ).createShader(Rect.fromCircle(center: head, radius: 13)),
    );
    if (!walking) {
      for (var side in [-1, 1]) {
        canvas.drawArc(
          Rect.fromCircle(center: shoulder + Offset(side * 17, 8), radius: 35),
          a + side * math.pi / 2,
          .8,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = ink(.24),
        );
      }
    }
    canvas.restore();
  }

  void limb(
    Canvas canvas,
    Offset start,
    Offset joint,
    Offset end,
    double width,
    double opacity,
  ) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(joint.dx, joint.dy)
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = width
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ink(opacity), ink(opacity * .55)],
        ).createShader(path.getBounds().inflate(1)),
    );
    canvas.drawPath(
      path.shift(const Offset(-1.7, -1)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .85
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white.withValues(alpha: .19 * opacity),
    );
    canvas.drawCircle(joint, 2, Paint()..color = ink(opacity * .25));
  }

  @override
  bool shouldRepaint(covariant RoutineArtwork old) =>
      old.kind != kind ||
      old.motion != motion ||
      old.palette != palette ||
      old.completed != completed;
}

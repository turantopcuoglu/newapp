import 'dart:math' as math;
import 'dart:ui' as ui;
import 'satin_texture.dart';
import 'package:flutter/material.dart';
import 'mood_palette.dart';
import 'wellness_motion.dart' show reducedMotion;

/// Adds an optical finish while preserving a native button's resolved colors,
/// semantics, focus, disabled state and hit testing.
class AtmosphereButtonFinish extends StatelessWidget {
  final Widget child;
  final bool pressed, disabled;
  const AtmosphereButtonFinish({
    super.key,
    required this.child,
    required this.pressed,
    required this.disabled,
  });
  @override
  Widget build(BuildContext context) => SatinTexture(
    builder: (context, texture) => TweenAnimationBuilder<double>(
      tween: Tween(end: pressed ? 1 : 0),
      duration: reducedMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 220),
      builder: (context, t, child) => CustomPaint(
        painter: _ButtonFinishPainter(t, disabled, texture),
        child: child,
      ),
      child: child,
    ),
  );
}

class _ButtonFinishPainter extends CustomPainter {
  final double pressure;
  final bool disabled;
  final ui.Image? texture;
  const _ButtonFinishPainter(this.pressure, this.disabled, this.texture);
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final shape = RRect.fromRectAndRadius(
      rect.deflate(.4),
      const Radius.circular(18),
    );
    canvas.save();
    canvas.clipRRect(shape);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(
              alpha: disabled ? .025 : .16 + pressure * .06,
            ),
            Colors.white.withValues(alpha: 0),
            Colors.black.withValues(alpha: disabled ? .01 : .045),
          ],
          stops: const [0, .56, 1],
        ).createShader(rect),
    );
    paintSatin(canvas, rect, texture, disabled ? .08 : .24);
    canvas.drawRRect(
      shape,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .65
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .4),
            Colors.white.withValues(alpha: .04),
          ],
        ).createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ButtonFinishPainter old) =>
      old.pressure != pressure ||
      old.disabled != disabled ||
      old.texture != texture;
}

/// Native light and bevel layers over a neutral satin map. Text, icons and
/// photographs stay separate. Static material and touch light repaint apart.
class AtmosphereSurface extends StatelessWidget {
  final Widget child;
  final double radius, activity;
  final bool primary, selected;
  final Color? color;
  const AtmosphereSurface({
    super.key,
    required this.child,
    this.radius = 16,
    this.activity = 0,
    this.primary = false,
    this.selected = false,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final base = color ?? (primary ? p.mint : p.surface);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: p.brightness == Brightness.light ? .08 : .20,
            ),
            blurRadius: 13,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 3,
            offset: const Offset(0, .8),
          ),
          if (selected)
            BoxShadow(
              color: p.mint.withValues(alpha: .14),
              blurRadius: 18,
              spreadRadius: 1,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: SatinTexture(
                  builder: (_, texture) => CustomPaint(
                    painter: _MaterialPainter(
                      p,
                      base,
                      radius,
                      primary,
                      texture,
                    ),
                  ),
                ),
              ),
            ),
            child,
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _TouchLightPainter(p, radius, activity, primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialPainter extends CustomPainter {
  final MoodPalette palette;
  final Color base;
  final double radius;
  final bool primary;
  final ui.Image? texture;
  const _MaterialPainter(
    this.palette,
    this.base,
    this.radius,
    this.primary,
    this.texture,
  );
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size, p = palette;
    final reflection = primary || p.brightness == Brightness.light
        ? const Color(0xFFFFF6ED)
        : HSLColor.fromColor(base)
              .withLightness(
                (HSLColor.fromColor(base).lightness + .22).clamp(0, 1),
              )
              .toColor();
    final rim = primary || p.brightness == Brightness.light
        ? reflection
        : p.mint;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(base, reflection, primary ? .18 : .22)!,
            base,
            primary
                ? Color.lerp(base, p.background, .045)!
                : Color.lerp(base, reflection, .055)!,
            Color.lerp(base, reflection, primary ? .035 : .06)!,
          ],
          stops: const [0, .38, .72, 1],
        ).createShader(rect),
    );
    // A broad, elliptical light source; the middle stays optically deep.
    canvas.drawRect(
      rect,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                reflection.withValues(alpha: primary ? .10 : .04),
                reflection.withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCenter(
                center: Offset(size.width * .05, size.height * .04),
                width: size.width * 1.9,
                height: size.height * 2,
              ),
            ),
    );
    // ImageGen material only: no repeated contour lines or isolated dots.
    paintSatin(canvas, rect, texture, primary ? .24 : .28);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.inflate(1.2), Radius.circular(radius + 1)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
        ..color = Colors.black.withValues(alpha: primary ? .08 : .10),
    );
    // Reflected light gathers inside the lower bevel, separate from the rim.
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(2), Radius.circular(radius - 1)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5)
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            reflection.withValues(alpha: 0),
            reflection.withValues(alpha: .11),
          ],
          stops: const [.65, 1],
        ).createShader(rect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(.45), Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .75
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            rim.withValues(alpha: primary ? .65 : .55),
            rim.withValues(alpha: .17),
            rim.withValues(alpha: .29),
          ],
          stops: const [0, .57, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _MaterialPainter old) =>
      old.palette != palette ||
      old.base != base ||
      old.radius != radius ||
      old.primary != primary ||
      old.texture != texture;
}

/// Continuous ambient color behind the five main pages and their navigation.
class AtmosphereBackdrop extends StatelessWidget {
  final Widget child;
  const AtmosphereBackdrop({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            p.background,
            Color.lerp(p.background, p.surface, .20)!,
            p.background,
          ],
          stops: const [0, .72, 1],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-1, .6),
            radius: 1.3,
            colors: [
              p.surface.withValues(alpha: .14),
              p.surface.withValues(alpha: 0),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

class _TouchLightPainter extends CustomPainter {
  final MoodPalette palette;
  final double radius, activity;
  final bool primary;
  const _TouchLightPainter(
    this.palette,
    this.radius,
    this.activity,
    this.primary,
  );
  @override
  void paint(Canvas canvas, Size size) {
    if (activity <= 0 || activity >= 1 || size.isEmpty) return;
    final envelope = math.sin(math.pi * activity);
    final color = primary ? Colors.white : palette.mint;
    final center = Offset(
      size.width * (-.3 + activity * 1.65),
      size.height * (.85 - activity * .75),
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                color.withValues(alpha: envelope * .13),
                color.withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCircle(center: center, radius: size.longestSide * .7),
            ),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        (Offset.zero & size).deflate(.8),
        Radius.circular(radius),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = .9
        ..shader = SweepGradient(
          transform: GradientRotation(activity * math.pi * 2),
          colors: [
            color.withValues(alpha: 0),
            color.withValues(alpha: .55 * envelope),
            color.withValues(alpha: 0),
          ],
          stops: const [0, .3, .65],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant _TouchLightPainter old) =>
      old.palette != palette ||
      old.activity != activity ||
      old.radius != radius ||
      old.primary != primary;
}

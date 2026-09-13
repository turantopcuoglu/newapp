import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mood_palette.dart';
import 'enums.dart';

bool reducedMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ||
    MediaQuery.accessibleNavigationOf(context);

/// An under-damped response for space; opacity always uses a bounded curve.
class WellnessSpring extends Curve {
  const WellnessSpring();
  @override
  double transformInternal(double t) =>
      1 - math.exp(-7.8 * t) * math.cos(9.5 * t);
}

double atmosphereTempo(BuildContext context) => switch (context.palette.mode) {
  CheckInType.postWorkout => .88,
  CheckInType.lowEnergy || CheckInType.periodFatigue || CheckInType.pms => 1.14,
  _ => 1.0,
};

class MotionSize extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  const MotionSize({
    super.key,
    required this.child,
    required this.duration,
    this.curve = Curves.easeInOutCubic,
  });
  @override
  Widget build(BuildContext context) => reducedMotion(context)
      ? child
      : AnimatedSize(duration: duration, curve: curve, child: child);
}

/// Keeps the departing tab on screen until its exit finishes, while preserving
/// each tab's scroll and form state. Hidden pages have neither focus nor tickers.
class WellnessTabScene extends StatefulWidget {
  final Widget child;
  final bool visible;
  final int direction;
  const WellnessTabScene({
    super.key,
    required this.child,
    required this.visible,
    this.direction = 1,
  });
  @override
  State<WellnessTabScene> createState() => _WellnessTabSceneState();
}

class _WellnessTabSceneState extends State<WellnessTabScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController motion = AnimationController(
    vsync: this,
    value: widget.visible ? 1 : 0,
    duration: const Duration(milliseconds: 520),
  );
  bool still = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    still = reducedMotion(context);
    if (still) {
      motion.stop();
      motion.value = widget.visible ? 1 : 0;
    }
  }

  @override
  void didUpdateWidget(covariant WellnessTabScene old) {
    super.didUpdateWidget(old);
    if (old.visible == widget.visible) return;
    if (still) {
      motion.value = widget.visible ? 1 : 0;
    } else if (widget.visible) {
      motion.forward();
    } else {
      motion.reverse();
    }
  }

  @override
  void dispose() {
    motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: motion,
    child: TickerMode(enabled: widget.visible, child: widget.child),
    builder: (context, child) {
      // Complementary fades prevent two full-bright scenes accumulating.
      final v = widget.visible
          ? Curves.easeOutCubic.transform(motion.value)
          : Curves.easeInCubic.transform(motion.value);
      return Offstage(
        offstage: !widget.visible && motion.value == 0,
        child: IgnorePointer(
          ignoring: !widget.visible,
          child: ExcludeFocus(
            excluding: !widget.visible,
            child: ExcludeSemantics(
              excluding: !widget.visible,
              child: Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(
                    (1 - v) * 28 * widget.direction * (widget.visible ? 1 : -1),
                    0,
                  ),
                  child: Transform.scale(scale: .986 + v * .014, child: child),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Keeps the native IconButton's focus and accessibility behavior, while
/// giving its own symbol a short, context-appropriate response.
class WellnessIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize, splashRadius;
  final Color? color,
      disabledColor,
      hoverColor,
      focusColor,
      highlightColor,
      splashColor;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  final AlignmentGeometry alignment;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool? enableFeedback, isSelected;
  final Widget? selectedIcon;
  final MouseCursor? mouseCursor;
  const WellnessIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize,
    this.color,
    this.disabledColor,
    this.padding = const EdgeInsets.all(8),
    this.constraints,
    this.style,
    this.alignment = Alignment.center,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.splashRadius,
    this.hoverColor,
    this.focusColor,
    this.highlightColor,
    this.splashColor,
    this.mouseCursor,
    this.isSelected,
    this.selectedIcon,
  });
  @override
  State<WellnessIconButton> createState() => _WellnessIconButtonState();
}

class _WellnessIconButtonState extends State<WellnessIconButton>
    with SingleTickerProviderStateMixin {
  Timer? activationTimer;
  late final AnimationController pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reducedMotion(context)) {
      pulse.stop();
      pulse.value = 0;
    }
  }

  void handlePress() {
    if (widget.onPressed == null || activationTimer?.isActive == true) return;
    if (reducedMotion(context)) {
      widget.onPressed!();
      return;
    }
    pulse.forward(from: 0);
    activationTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) widget.onPressed?.call();
    });
  }

  @override
  void dispose() {
    activationTimer?.cancel();
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: pulse,
    builder: (context, _) {
      final v = reducedMotion(context) ? 0.0 : math.sin(pulse.value * math.pi);
      final data = widget.icon is Icon ? (widget.icon as Icon).icon : null;
      final turn =
          data == Icons.settings ||
          data == Icons.settings_outlined ||
          data == Icons.refresh ||
          data == Icons.sync ||
          data == Icons.close ||
          data == Icons.settings_rounded;
      final spin = data == Icons.refresh || data == Icons.sync;
      final heart =
          data == Icons.favorite ||
          data == Icons.favorite_border ||
          data == Icons.favorite_rounded;
      final arrow =
          data == Icons.arrow_forward ||
          data == Icons.chevron_right ||
          data == Icons.arrow_back;
      return IconButton(
        onPressed: widget.onPressed == null ? null : handlePress,
        tooltip: widget.tooltip,
        iconSize: widget.iconSize,
        color: widget.color,
        disabledColor: widget.disabledColor,
        padding: widget.padding,
        constraints: widget.constraints,
        style: widget.style,
        alignment: widget.alignment,
        visualDensity: widget.visualDensity,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enableFeedback: widget.enableFeedback,
        splashRadius: widget.splashRadius,
        hoverColor: widget.hoverColor,
        focusColor: widget.focusColor,
        highlightColor: widget.highlightColor,
        splashColor: widget.splashColor,
        mouseCursor: widget.mouseCursor,
        isSelected: widget.isSelected,
        selectedIcon: widget.selectedIcon,
        icon: Transform.translate(
          offset: Offset(arrow ? v * 4 : 0, 0),
          child: Transform.rotate(
            angle: turn
                ? (reducedMotion(context) ? 0 : pulse.value) *
                      (spin
                          ? math.pi * 2
                          : data == Icons.close
                          ? math.pi / 2
                          : math.pi / 3)
                : 0,
            child: Transform.scale(
              scale: 1 + v * (heart ? .21 : .1),
              child: widget.icon,
            ),
          ),
        ),
      );
    },
  );
}

class WellnessPageTransitions extends PageTransitionsBuilder {
  const WellnessPageTransitions();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (reducedMotion(context)) return child;
    return AnimatedBuilder(
      animation: Listenable.merge([animation, secondaryAnimation]),
      child: child,
      builder: (context, child) {
        final enter = Curves.easeOutCubic.transform(animation.value);
        final leave = Curves.easeInOutCubic.transform(secondaryAnimation.value);
        return Transform.translate(
          offset: Offset(0, (1 - enter) * 30 - leave * 9),
          child: Transform.scale(
            scale: (0.96 + enter * .04) * (1 - leave * .025),
            child: Opacity(
              opacity: (enter * (1 - leave * .16)).clamp(0, 1),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Finite entry motion. No idle ticker, and no motion when accessibility asks.
class LiftIn extends StatelessWidget {
  final Widget child;
  final int order;
  const LiftIn({super.key, required this.child, this.order = 0});
  @override
  Widget build(BuildContext context) => reducedMotion(context)
      ? child
      : TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(
            milliseconds:
                ((630 + order.clamp(0, 8) * 45) * atmosphereTempo(context))
                    .round(),
          ),
          builder: (_, t, child) {
            final v = const WellnessSpring().transform(t);
            return Opacity(
              opacity: Curves.easeOut.transform((t * 2).clamp(0, 1)),
              child: Transform.translate(
                offset: Offset(0, (1 - v) * 23),
                child: Transform.scale(scale: .97 + .03 * v, child: child),
              ),
            );
          },
          child: child,
        );
}

/// InkWell retains keyboard activation, focus, semantics and ripple support.
/// One activation per gesture; the short flourish precedes navigation.
class MotionTap extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget Function(BuildContext, double) builder;
  final BorderRadius radius;
  const MotionTap({
    super.key,
    this.onTap,
    required this.builder,
    this.radius = const BorderRadius.all(Radius.circular(22)),
  });
  @override
  State<MotionTap> createState() => _MotionTapState();
}

class _MotionTapState extends State<MotionTap> with TickerProviderStateMixin {
  Timer? activationTimer;
  late final AnimationController pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 760),
  );
  late final AnimationController pressure = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 85),
    reverseDuration: const Duration(milliseconds: 320),
  );
  bool busy = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pulse.duration = Duration(
      milliseconds: (760 * atmosphereTempo(context)).round(),
    );
    if (reducedMotion(context)) {
      pulse.stop();
      pressure.stop();
      pulse.value = 0;
      pressure.value = 0;
    }
  }

  void handleTap() {
    if (busy || widget.onTap == null) return;
    if (reducedMotion(context)) {
      widget.onTap!();
      return;
    }
    busy = true;
    HapticFeedback.selectionClick();
    pulse.forward(from: 0);
    pressure.reverse();
    activationTimer = Timer(const Duration(milliseconds: 90), () {
      if (!mounted) return;
      try {
        widget.onTap?.call();
      } finally {
        // The flourish may continue, but must never block an immediate pause.
        if (mounted) busy = false;
      }
    });
  }

  @override
  void dispose() {
    activationTimer?.cancel();
    pulse.dispose();
    pressure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([pulse, pressure]),
    builder: (context, _) => Transform.scale(
      scale: reducedMotion(context)
          ? 1
          : 1 -
                pressure.value * .028 +
                math.sin(pulse.value * math.pi * 2) * .006 * (1 - pulse.value),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: widget.radius,
          onTap: widget.onTap == null ? null : handleTap,
          onTapDown: widget.onTap == null
              ? null
              : (_) {
                  if (!reducedMotion(context)) pressure.forward();
                },
          onTapCancel: () => pressure.reverse(),
          child: widget.builder(
            context,
            reducedMotion(context) ? 0 : pulse.value,
          ),
        ),
      ),
    ),
  );
}

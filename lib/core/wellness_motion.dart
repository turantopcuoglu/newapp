import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mood_palette.dart';
import 'enums.dart';

bool reducedMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ||
    MediaQuery.accessibleNavigationOf(context);

double atmosphereTempo(BuildContext context) => switch (context.palette.mode) {
  CheckInType.postWorkout => .88,
  CheckInType.lowEnergy ||
  CheckInType.periodFatigue ||
  CheckInType.pms ||
  CheckInType.poorSleep ||
  CheckInType.stressed => 1.14,
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

/// Tab switch duration. Kept short: a tab change is navigation, not a scene.
const Duration wellnessTabDuration = Duration(milliseconds: 260);

/// Keeps the departing tab on screen until its exit finishes, while preserving
/// each tab's scroll and form state. Hidden pages have neither focus nor tickers.
///
/// Fade-through: the departing tab is gone within the first 40% of the switch
/// and the arriving one starts at 35%. Tabs sit on a shared transparent
/// backdrop, so letting both fade at once showed two pages stacked.
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
    duration: wellnessTabDuration,
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
      final v = widget.visible
          ? const Interval(
              .35,
              1,
              curve: Curves.easeOutCubic,
            ).transform(motion.value)
          : const Interval(.6, 1, curve: Curves.easeIn).transform(motion.value);
      return Offstage(
        offstage: !widget.visible && motion.value == 0,
        child: HeroMode(
          enabled: widget.visible,
          child: IgnorePointer(
            ignoring: !widget.visible,
            child: ExcludeFocus(
              excluding: !widget.visible,
              child: ExcludeSemantics(
                excluding: !widget.visible,
                child: Opacity(
                  opacity: v,
                  // Same widget shape in both states, or the tab would remount
                  // and lose its scroll position.
                  child: Transform.translate(
                    offset: Offset(
                      widget.visible ? (1 - v) * 12 * widget.direction : 0,
                      0,
                    ),
                    child: child,
                  ),
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
  final guard = _RepeatGuard();
  late final AnimationController pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
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
    if (widget.onPressed == null || !guard.tryActivate()) return;
    if (!reducedMotion(context)) pulse.forward(from: 0);
    widget.onPressed!();
  }

  @override
  void dispose() {
    guard.dispose();
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
      // The arriving page is opaque by mid-flight, so the page beneath shows
      // through only briefly. No scaling: scaled text shimmers while moving.
      builder: (context, child) {
        final enter = Curves.easeOutCubic.transform(animation.value);
        final fade = const Interval(
          0,
          .55,
          curve: Curves.easeOut,
        ).transform(animation.value);
        final leave = Curves.easeInOutCubic.transform(secondaryAnimation.value);
        return Transform.translate(
          offset: Offset(0, (1 - enter) * 18 - leave * 6),
          child: Opacity(opacity: fade, child: child),
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
                ((320 + order.clamp(0, 6) * 40) * atmosphereTempo(context))
                    .round(),
          ),
          curve: Curves.easeOutCubic,
          builder: (_, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, (1 - t) * 12),
              child: child,
            ),
          ),
          child: child,
        );
}

/// Taps closer together than this are treated as one, so a quick double tap
/// can't push the same page twice. The action itself always fires at once:
/// delaying it to let a flourish play made every control feel late.
///
/// A timer rather than wall-clock time, so widget tests' fake clock applies.
class _RepeatGuard {
  Timer? _window;
  bool tryActivate() {
    if (_window?.isActive ?? false) return false;
    _window = Timer(const Duration(milliseconds: 300), () {});
    return true;
  }

  void dispose() => _window?.cancel();
}

/// InkWell retains keyboard activation, focus, semantics and ripple support.
/// One activation per gesture; the flourish plays alongside the action.
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
  final guard = _RepeatGuard();
  late final AnimationController pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final AnimationController pressure = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 85),
    reverseDuration: const Duration(milliseconds: 320),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pulse.duration = Duration(
      milliseconds: (420 * atmosphereTempo(context)).round(),
    );
    if (reducedMotion(context)) {
      pulse.stop();
      pressure.stop();
      pulse.value = 0;
      pressure.value = 0;
    }
  }

  void handleTap() {
    if (widget.onTap == null || !guard.tryActivate()) return;
    if (!reducedMotion(context)) {
      HapticFeedback.selectionClick();
      pulse.forward(from: 0);
      pressure.reverse();
    }
    widget.onTap!();
  }

  @override
  void dispose() {
    guard.dispose();
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

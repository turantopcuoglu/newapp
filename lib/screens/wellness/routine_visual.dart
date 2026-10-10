import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/wellness_motion.dart';
import 'routine_artwork.dart';
import 'wellness_ui.dart';

class RoutineVisual extends StatefulWidget {
  final String kind;
  final bool running, completed;
  final int elapsedMilliseconds;
  final int? cycleMilliseconds;
  const RoutineVisual({
    super.key,
    required this.kind,
    required this.running,
    this.completed = false,
    required this.elapsedMilliseconds,
    this.cycleMilliseconds,
  }) : assert(cycleMilliseconds == null || cycleMilliseconds > 0);
  @override
  State<RoutineVisual> createState() => _RoutineVisualState();
}

class _RoutineVisualState extends State<RoutineVisual>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController motion = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: cycle),
    value: (widget.elapsedMilliseconds % cycle) / cycle,
  )..addListener(updatePhase);
  final inhaling = ValueNotifier(true);
  bool suspended = false;
  int get cycle =>
      widget.cycleMilliseconds ??
      switch (widget.kind) {
        'breathe' => 8000,
        'walk' => 2400,
        'stretch' => 12000,
        _ => 16000,
      };
  void updatePhase() {
    final next = motion.value < .5;
    if (inhaling.value != next) inhaling.value = next;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void sync() {
    final active =
        widget.running &&
        !widget.completed &&
        !suspended &&
        !reducedMotion(context) &&
        TickerMode.valuesOf(context).enabled;
    if (active) {
      if (!motion.isAnimating) motion.repeat();
    } else {
      motion.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sync();
  }

  @override
  void didUpdateWidget(covariant RoutineVisual old) {
    super.didUpdateWidget(old);
    if (!old.running && widget.running) suspended = false;
    if (old.kind != widget.kind ||
        old.cycleMilliseconds != widget.cycleMilliseconds) {
      motion.stop();
      motion.duration = Duration(milliseconds: cycle);
    }
    sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The session keeps running while the app is away, so the motion
    // resumes with it instead of waiting for a pause/resume tap.
    suspended = state != AppLifecycleState.resumed;
    if (mounted) sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    motion.dispose();
    inhaling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette, still = reducedMotion(context);
    return RepaintBoundary(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: ExcludeSemantics(
                child: CustomPaint(
                  painter: RoutineArtwork(
                    widget.kind,
                    motion,
                    p,
                    completed: widget.completed,
                  ),
                ),
              ),
            ),
            if (widget.kind == 'breathe')
              // Only phase boundaries update typography, not every animation frame.
              ValueListenableBuilder(
                valueListenable: inhaling,
                builder: (context, inhale, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: still
                          ? Duration.zero
                          : const Duration(milliseconds: 420),
                      child: Text(
                        widget.completed
                            ? context.w('Tamamlandı', 'Complete')
                            : !widget.running
                            ? context.w('Bir nefes.', 'A breath.')
                            : still
                            ? context.w(
                                'Rahatça nefes al',
                                'Breathe comfortably',
                              )
                            : inhale
                            ? context.w('Nefes al', 'Breathe in')
                            : context.w('Nefes ver', 'Breathe out'),
                        key: ValueKey(
                          '${widget.running}-${widget.completed}-$inhale-$still',
                        ),
                        style: TextStyle(
                          fontSize: still ? 15 : 20,
                          color: p.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.w('Kendi ritminde', 'At your own pace'),
                      style: TextStyle(fontSize: 11, color: p.textSecondary),
                    ),
                  ],
                ),
              ),
            if (widget.kind == 'mindful')
              Positioned(
                bottom: 6,
                child: Text(
                  context.w('Buradasın. Bu andasın.', 'Here. In this moment.'),
                  style: TextStyle(color: p.textSecondary, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

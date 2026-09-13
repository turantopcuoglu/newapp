import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/wellness_provider.dart';
import 'wellness/today_screen.dart';
import 'wellness/discover_screen.dart';
import 'wellness/mood_widgets.dart';
import 'wellness/mood_picker_screen.dart';
import '../core/wellness_motion.dart';
import '../core/atmosphere_surface.dart';
import '../core/day_boundary.dart';
import 'wellness/progress_screen.dart';
import 'wellness/profile_screen.dart';
import 'wellness/wellness_ui.dart';

class MainShell extends ConsumerStatefulWidget {
  final bool promptOnOpen;
  const MainShell({super.key, this.promptOnOpen = true});
  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  int index = 0;
  int direction = 1;
  void selectTab(int next) {
    if (index == next) return;
    setState(() {
      direction = next > index ? 1 : -1;
      index = next;
    });
  }

  Timer? clock;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.promptOnOpen) return;
      final now = ref.read(wellnessNowProvider);
      final data = ref.read(wellnessProvider);
      if (data.contextPromptDay != DayBoundary.keyFor(now) &&
          data.checkInFor(now) == null) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const MoodPickerScreen()),
        );
      }
    });
    clock = Timer.periodic(
      const Duration(minutes: 1),
      (_) => ref.invalidate(wellnessNowProvider),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(wellnessNowProvider);
  }

  @override
  void dispose() {
    clock?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final labels = [
      context.w('Bugün', 'Today'),
      context.w('Keşfet', 'Explore'),
      context.w('Plan', 'Plan'),
      context.w('Gelişim', 'Progress'),
      context.w('Profil', 'Profile'),
    ];
    final pages = [
      TodayScreen(navigate: selectTab),
      const DiscoverScreen(),
      const DailyPlanScreen(),
      const ProgressScreen(),
      const WellnessProfileScreen(),
    ];
    final duration = reducedMotion(context)
        ? Duration.zero
        : const Duration(milliseconds: 520);
    return AtmosphereBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: List.generate(
            pages.length,
            (i) => Positioned.fill(
              child: WellnessTabScene(
                visible: index == i,
                direction: direction,
                child: pages[i],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                height:
                    82 + (MediaQuery.textScalerOf(context).scale(11) - 11) * 7,
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 6),
                child: AtmosphereSurface(
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedAlign(
                            duration: duration,
                            curve: const WellnessSpring(),
                            alignment: Alignment(-1 + index * .5, 0),
                            child: const FractionallySizedBox(
                              widthFactor: .2,
                              heightFactor: 1,
                              child: AtmosphereSurface(
                                primary: true,
                                radius: 25,
                                child: SizedBox.expand(),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Expanded(
                              child: Semantics(
                                selected: index == i,
                                button: true,
                                child: MotionTap(
                                  onTap: () => selectTab(i),
                                  radius: BorderRadius.circular(25),
                                  builder: (context, t) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                      vertical: 9,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MoodGlyph(
                                          [
                                            'sun',
                                            'leaf',
                                            'calendar',
                                            'bars',
                                            'person',
                                          ][i],
                                          size: 26,
                                          progress: t,
                                          color: index == i
                                              ? p.onAction
                                              : p.textPrimary,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          labels[i],
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: index == i
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: index == i
                                                ? p.onAction
                                                : p.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

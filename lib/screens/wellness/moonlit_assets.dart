import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/enums.dart';
import '../../core/wellness_motion.dart';
import '../../components/atlas_image.dart';
import '../../components/ingredient_image.dart';

/// Original approved boards, copied byte-for-byte. Crops are drawn at runtime;
/// photos and luminous scenery are never approximated with placeholder artwork.
class ReferenceCrop extends StatelessWidget {
  final String board;
  final Rect crop;
  final BoxFit fit;
  const ReferenceCrop({
    super.key,
    required this.board,
    required this.crop,
    this.fit = BoxFit.cover,
  });
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final sx = constraints.maxWidth / crop.width;
        final sy = constraints.maxHeight / crop.height;
        final scale = fit == BoxFit.contain
            ? math.min(sx, sy)
            : math.max(sx, sy);
        return ClipRect(
          child: Stack(
            children: [
              Positioned(
                left:
                    (constraints.maxWidth - crop.width * scale) / 2 -
                    crop.left * scale,
                top:
                    (constraints.maxHeight - crop.height * scale) / 2 -
                    crop.top * scale,
                width: 1536 * scale,
                height: 1024 * scale,
                child: Image.asset(
                  'assets/moonlit/$board.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class HorizonScene extends StatelessWidget {
  final bool moon;
  const HorizonScene({super.key, this.moon = true});
  @override
  Widget build(BuildContext context) {
    final periodIndex = switch (context.palette.mode) {
      CheckInType.pms => 0,
      CheckInType.periodCramps => 1,
      CheckInType.periodFatigue => 2,
      _ => null,
    };
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: reducedMotion(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (current, previous) => Stack(
                fit: StackFit.expand,
                children: [...previous, if (current != null) current],
              ),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation.drive(Tween(begin: 1.035, end: 1.0)),
                  child: child,
                ),
              ),
              child: AtlasImage(
                key: ValueKey(context.palette.mode),
                asset: periodIndex == null
                    ? 'assets/moods/landscapes.png'
                    : 'assets/moods/period-reference-v2.png',
                columns: periodIndex == null ? 3 : 1,
                rows: 3,
                index: periodIndex ?? context.palette.mode.index,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.palette.background.withValues(
                      alpha: periodIndex == null ? .28 : .10,
                    ),
                    context.palette.background.withValues(alpha: .02),
                    context.palette.background,
                  ],
                  stops: periodIndex == null
                      ? const [0, .68, 1]
                      : const [0, .90, 1],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoonlitHeader extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final bool moon;
  const MoonlitHeader({
    super.key,
    required this.child,
    this.minHeight = 190,
    this.moon = true,
  });
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: HorizonScene(moon: moon)),
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          child: child,
        ),
      ),
    ],
  );
}

class OriginalFoodPhoto extends StatelessWidget {
  final bool detail;
  const OriginalFoodPhoto({super.key, this.detail = false});
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/food/moonlit-bowl-hero-v2.png',
    fit: BoxFit.cover,
    filterQuality: FilterQuality.high,
  );
}

class IngredientPhoto extends StatelessWidget {
  final String id;
  const IngredientPhoto({super.key, required this.id});
  @override
  Widget build(BuildContext context) => IngredientImage(id: id);
}

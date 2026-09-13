import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/beverage_entry.dart';
import '../../providers/beverage_provider.dart';

// ─── Beverage type visual configuration ─────────────────────────────────────

const Map<BeverageType, IconData> _beverageIcons = {
  BeverageType.water: Icons.water_drop_rounded,
  BeverageType.tea: Icons.emoji_food_beverage_rounded,
  BeverageType.coffee: Icons.coffee_rounded,
  BeverageType.juice: Icons.local_drink_rounded,
  BeverageType.soda: Icons.bubble_chart_rounded,
  BeverageType.milk: Icons.water_rounded,
  BeverageType.smoothie: Icons.blender_rounded,
  BeverageType.other: Icons.local_cafe_rounded,
};

Map<BeverageType, Color> _beverageColors(BuildContext context) => {
  BeverageType.water: const Color(0xFF4FC3F7),
  BeverageType.tea: const Color(0xFFA1887F),
  BeverageType.coffee: const Color(0xFF795548),
  BeverageType.juice: const Color(0xFFFFB74D),
  BeverageType.soda: const Color(0xFFE57373),
  BeverageType.milk: Colors.white,
  BeverageType.smoothie: const Color(0xFFBA68C8),
  BeverageType.other: context.palette.textLight,
};

const List<int> _presetAmounts = [100, 150, 200, 250, 330, 500];

const int _dailyWaterTargetMl = 2000;

// ─── BeveragesScreen ────────────────────────────────────────────────────────

class BeveragesScreen extends ConsumerStatefulWidget {
  const BeveragesScreen({super.key});

  @override
  ConsumerState<BeveragesScreen> createState() => _BeveragesScreenState();
}

class _BeveragesScreenState extends ConsumerState<BeveragesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressAnimController;
  late Animation<double> _progressAnim;
  double _lastProgress = 0;

  @override
  void initState() {
    super.initState();
    _progressAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progressAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: _progressAnimController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _progressAnimController.dispose();
    super.dispose();
  }

  void _animateProgress(double target) {
    if (target == _lastProgress) return;
    _progressAnim = Tween<double>(begin: _lastProgress, end: target).animate(
      CurvedAnimation(
        parent: _progressAnimController,
        curve: Curves.easeOutCubic,
      ),
    );
    _lastProgress = target;
    _progressAnimController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final notifier = ref.read(beverageProvider.notifier);
    // Watched for rebuilds; the entries themselves are read via the notifier.
    ref.watch(beverageProvider);

    final today = DateTime.now();
    final todayEntries = notifier.entriesForDate(today)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final waterToday = notifier.totalWaterToday();
    final caloriesToday = notifier.totalCaloriesToday();
    final waterProgress = (waterToday / _dailyWaterTargetMl).clamp(0.0, 1.0);

    // Schedule animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateProgress(waterProgress);
    });

    return Scaffold(
      backgroundColor: context.palette.background,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // Header with water progress
          SliverToBoxAdapter(
            child: _BeverageHeader(
              waterMl: waterToday,
              targetMl: _dailyWaterTargetMl,
              caloriesToday: caloriesToday,
              progressAnimation: _progressAnim,
              animationController: _progressAnimController,
              l10n: l10n,
            ),
          ),

          // Beverage type grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            sliver: SliverToBoxAdapter(
              child: _BeverageTypeGrid(
                locale: locale,
                l10n: l10n,
                onBeverageSelected: (info) =>
                    _showAmountDialog(context, info, locale, l10n),
              ),
            ),
          ),

          // Section label for today's log
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.palette.accentTeal.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: context.palette.accentTeal,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.beverageTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.palette.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.palette.softLavender.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${todayEntries.length}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.palette.softLavender,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Today's entries list
          if (todayEntries.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        size: 56,
                        color: context.palette.textLight.withAlpha(80),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noData,
                        style: TextStyle(
                          fontSize: 15,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final entry = todayEntries[index];
                  final info = beverageOptions.firstWhere(
                    (b) => b.type == entry.type,
                    orElse: () => beverageOptions.last,
                  );
                  return _BeverageEntryTile(
                    entry: entry,
                    info: info,
                    locale: locale,
                    l10n: l10n,
                    onDismissed: () => notifier.removeEntry(entry.id),
                  );
                }, childCount: todayEntries.length),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Amount selection dialog ──────────────────────────────────────────────

  Future<void> _showAmountDialog(
    BuildContext context,
    BeverageInfo info,
    String locale,
    AppLocalizations l10n,
  ) async {
    final beverageColor =
        _beverageColors(context)[info.type] ?? context.palette.textLight;
    final iconData = _beverageIcons[info.type] ?? Icons.local_cafe_rounded;
    final beverageName = info.name[locale] ?? info.name['en'] ?? '';
    final customController = TextEditingController();
    int? selectedMl;

    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.palette.dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Beverage icon and name
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: beverageColor.withAlpha(
                          info.type == BeverageType.milk ? 20 : 30,
                        ),
                        shape: BoxShape.circle,
                        border: info.type == BeverageType.milk
                            ? Border.all(
                                color: context.palette.accentTeal.withAlpha(60),
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(
                        iconData,
                        size: 36,
                        color: info.type == BeverageType.milk
                            ? context.palette.accentTeal
                            : beverageColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      beverageName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    if (info.caloriesPer100ml > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${info.caloriesPer100ml} kcal / 100ml',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Preset amount buttons
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: _presetAmounts.map((ml) {
                        final isSelected = selectedMl == ml;
                        return GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              selectedMl = ml;
                              customController.clear();
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? beverageColor.withAlpha(
                                      info.type == BeverageType.milk ? 30 : 180,
                                    )
                                  : context.palette.background,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(
                                      color: info.type == BeverageType.milk
                                          ? context.palette.accentTeal
                                          : beverageColor,
                                      width: 2,
                                    )
                                  : Border.all(
                                      color: context.palette.dividerColor,
                                    ),
                            ),
                            child: Text(
                              '${ml}ml',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? (info.type == BeverageType.milk
                                          ? context.palette.accentTeal
                                          : _contrastTextColor(beverageColor))
                                    : context.palette.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Custom amount input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: customController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                            onChanged: (value) {
                              setSheetState(() {
                                final parsed = int.tryParse(value);
                                if (parsed != null && parsed > 0) {
                                  selectedMl = parsed;
                                } else {
                                  selectedMl = null;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'ml',
                              hintStyle: TextStyle(
                                color: context.palette.textLight,
                              ),
                              prefixIcon: Icon(
                                Icons.edit_rounded,
                                color: context.palette.textLight,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: context.palette.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: info.type == BeverageType.milk
                                      ? context.palette.accentTeal
                                      : beverageColor,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: selectedMl != null && selectedMl! > 0
                            ? () => Navigator.pop(ctx, selectedMl)
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: info.type == BeverageType.milk
                              ? context.palette.accentTeal
                              : beverageColor,
                          disabledBackgroundColor: context.palette.dividerColor
                              .withAlpha(120),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          selectedMl != null
                              ? '${l10n.add}  ${selectedMl}ml'
                              : l10n.add,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: selectedMl != null
                                ? _contrastTextColor(
                                    info.type == BeverageType.milk
                                        ? context.palette.accentTeal
                                        : beverageColor,
                                  )
                                : context.palette.textLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && result > 0) {
      final calories = (info.caloriesPer100ml * result / 100).round();
      ref
          .read(beverageProvider.notifier)
          .addEntry(type: info.type, milliliters: result, calories: calories);
    }
  }

  Color _contrastTextColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.5 ? context.palette.textPrimary : Colors.white;
  }
}

// ─── Header Widget ──────────────────────────────────────────────────────────

class _BeverageHeader extends StatelessWidget {
  final int waterMl;
  final int targetMl;
  final int caloriesToday;
  final Animation<double> progressAnimation;
  final AnimationController animationController;
  final AppLocalizations l10n;

  const _BeverageHeader({
    required this.waterMl,
    required this.targetMl,
    required this.caloriesToday,
    required this.progressAnimation,
    required this.animationController,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.beverageTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: context.palette.warningAmber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$caloriesToday kcal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Circular progress indicator
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Row(
                children: [
                  // Progress circle
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: _WaterProgressPainter(
                        progress: progressAnimation.value,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.water_drop_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(progressAnimation.value * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Water stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.beverageWater,
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$waterMl',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: ' / ${targetMl}ml',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(150),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Mini progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            height: 8,
                            child: LinearProgressIndicator(
                              value: progressAnimation.value,
                              backgroundColor: Colors.white.withAlpha(40),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (waterMl >= targetMl)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.palette.successGreen.withAlpha(50),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: context.palette.successGreen,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Goal reached!',
                                  style: TextStyle(
                                    color: context.palette.successGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            '${targetMl - waterMl}ml remaining',
                            style: TextStyle(
                              color: Colors.white.withAlpha(140),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Circular progress painter ──────────────────────────────────────────────

class _WaterProgressPainter extends CustomPainter {
  final double progress;

  _WaterProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 8.0;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withAlpha(35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          Color(0xFFE1F5FE),
          Colors.white,
          Color(0xFFB3E5FC),
          Colors.white,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Dot at the end of progress
    if (progress > 0.02) {
      final dotAngle = -math.pi / 2 + sweepAngle;
      final dotX = center.dx + radius * math.cos(dotAngle);
      final dotY = center.dy + radius * math.sin(dotAngle);
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaterProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ─── Beverage Type Grid ─────────────────────────────────────────────────────

class _BeverageTypeGrid extends StatelessWidget {
  final String locale;
  final AppLocalizations l10n;
  final void Function(BeverageInfo info) onBeverageSelected;

  const _BeverageTypeGrid({
    required this.locale,
    required this.l10n,
    required this.onBeverageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: beverageOptions.length,
      itemBuilder: (context, index) {
        final info = beverageOptions[index];
        return _BeverageTypeButton(
          info: info,
          locale: locale,
          l10n: l10n,
          onTap: () => onBeverageSelected(info),
        );
      },
    );
  }
}

class _BeverageTypeButton extends StatelessWidget {
  final BeverageInfo info;
  final String locale;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _BeverageTypeButton({
    required this.info,
    required this.locale,
    required this.l10n,
    required this.onTap,
  });

  String _localizedBeverageName() {
    switch (info.type) {
      case BeverageType.water:
        return l10n.beverageWater;
      case BeverageType.tea:
        return l10n.beverageTea;
      case BeverageType.coffee:
        return l10n.beverageCoffee;
      case BeverageType.juice:
        return l10n.beverageJuice;
      case BeverageType.soda:
        return l10n.beverageSoda;
      case BeverageType.milk:
        return l10n.beverageMilk;
      case BeverageType.smoothie:
        return l10n.beverageSmoothie;
      case BeverageType.other:
        return l10n.beverageOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color =
        _beverageColors(context)[info.type] ?? context.palette.textLight;
    final icon = _beverageIcons[info.type] ?? Icons.local_cafe_rounded;
    final isMilk = info.type == BeverageType.milk;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(18),
          border: isMilk
              ? Border.all(
                  color: context.palette.accentTeal.withAlpha(50),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMilk
                    ? context.palette.accentTeal.withAlpha(20)
                    : color.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isMilk ? context.palette.accentTeal : color,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                _localizedBeverageName(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: context.palette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Beverage Entry Tile ────────────────────────────────────────────────────

class _BeverageEntryTile extends StatelessWidget {
  final BeverageEntry entry;
  final BeverageInfo info;
  final String locale;
  final AppLocalizations l10n;
  final VoidCallback onDismissed;

  const _BeverageEntryTile({
    required this.entry,
    required this.info,
    required this.locale,
    required this.l10n,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        _beverageColors(context)[entry.type] ?? context.palette.textLight;
    final icon = _beverageIcons[entry.type] ?? Icons.local_cafe_rounded;
    final isMilk = entry.type == BeverageType.milk;
    final displayColor = isMilk ? context.palette.accentTeal : color;
    final name = info.name[locale] ?? info.name['en'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key(entry.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismissed(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFE57373).withAlpha(30),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFE57373),
            size: 24,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: displayColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                  border: isMilk
                      ? Border.all(
                          color: context.palette.accentTeal.withAlpha(40),
                        )
                      : null,
                ),
                child: Icon(icon, color: displayColor, size: 22),
              ),
              const SizedBox(width: 14),

              // Name and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: context.palette.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          entry.timeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.palette.textSecondary,
                          ),
                        ),
                        if (entry.calories > 0) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 13,
                            color: context.palette.warningAmber.withAlpha(180),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${entry.calories} kcal',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.palette.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // ML amount
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: displayColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${entry.milliliters}ml',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: displayColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

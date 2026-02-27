import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/beverage_entry.dart';
import '../../providers/beverage_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/recipe_provider.dart';

// ---------------------------------------------------------------------------
// Data model for aggregated nutrition stats
// ---------------------------------------------------------------------------

class _NutritionData {
  final int totalCalories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int fiberG;
  final int mealsLogged;
  final int beverageCalories;
  final int waterMl;

  const _NutritionData({
    this.totalCalories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.fiberG = 0,
    this.mealsLogged = 0,
    this.beverageCalories = 0,
    this.waterMl = 0,
  });

  int get foodCalories => totalCalories - beverageCalories;

  double get proteinPercent {
    if (totalCalories == 0) return 0;
    return (proteinG * 4 / totalCalories) * 100;
  }

  double get carbsPercent {
    if (totalCalories == 0) return 0;
    return (carbsG * 4 / totalCalories) * 100;
  }

  double get fatPercent {
    if (totalCalories == 0) return 0;
    return (fatG * 9 / totalCalories) * 100;
  }
}

// ---------------------------------------------------------------------------
// Period enum
// ---------------------------------------------------------------------------

enum _Period { daily, weekly, monthly }

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------

class NutritionStatsScreen extends ConsumerStatefulWidget {
  const NutritionStatsScreen({super.key});

  @override
  ConsumerState<NutritionStatsScreen> createState() =>
      _NutritionStatsScreenState();
}

class _NutritionStatsScreenState extends ConsumerState<NutritionStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _Period get _currentPeriod => _Period.values[_tabController.index];

  // ── Date navigation ─────────────────────────────────────────────────────

  void _goBack() {
    setState(() {
      switch (_currentPeriod) {
        case _Period.daily:
          _selectedDate =
              _selectedDate.subtract(const Duration(days: 1));
          break;
        case _Period.weekly:
          _selectedDate =
              _selectedDate.subtract(const Duration(days: 7));
          break;
        case _Period.monthly:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month - 1,
            _selectedDate.day,
          );
          break;
      }
    });
  }

  void _goForward() {
    setState(() {
      switch (_currentPeriod) {
        case _Period.daily:
          _selectedDate = _selectedDate.add(const Duration(days: 1));
          break;
        case _Period.weekly:
          _selectedDate = _selectedDate.add(const Duration(days: 7));
          break;
        case _Period.monthly:
          _selectedDate = DateTime(
            _selectedDate.year,
            _selectedDate.month + 1,
            _selectedDate.day,
          );
          break;
      }
    });
  }

  // ── Period label ────────────────────────────────────────────────────────

  String _periodLabel() {
    switch (_currentPeriod) {
      case _Period.daily:
        return DateFormat('EEEE, MMM d').format(_selectedDate);
      case _Period.weekly:
        final monday = _mondayOfWeek(_selectedDate);
        final sunday = monday.add(const Duration(days: 6));
        return '${DateFormat('MMM d').format(monday)} - ${DateFormat('MMM d').format(sunday)}';
      case _Period.monthly:
        return DateFormat('MMMM yyyy').format(_selectedDate);
    }
  }

  // ── Date helpers ────────────────────────────────────────────────────────

  DateTime _mondayOfWeek(DateTime d) {
    final monday = d.subtract(Duration(days: d.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ── Data aggregation ────────────────────────────────────────────────────

  _NutritionData _computeData() {
    final mealPlans = ref.read(mealPlanProvider);
    final recipeMap = ref.read(recipeMapProvider);
    final beverages = ref.read(beverageProvider);

    // Determine date range
    late DateTime startDate;
    late DateTime endDate;

    switch (_currentPeriod) {
      case _Period.daily:
        startDate = DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day);
        endDate = startDate.add(const Duration(days: 1));
        break;
      case _Period.weekly:
        startDate = _mondayOfWeek(_selectedDate);
        endDate = startDate.add(const Duration(days: 7));
        break;
      case _Period.monthly:
        startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
        endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
        break;
    }

    // Filter meal plan entries by date range
    final filteredMeals = mealPlans.where((e) {
      if (_currentPeriod == _Period.daily) {
        return e.dateKey == _dateKey(startDate);
      }
      return !e.date.isBefore(startDate) && e.date.isBefore(endDate);
    }).toList();

    // Sum macros from recipes
    int totalCals = 0;
    int protein = 0;
    int carbs = 0;
    int fat = 0;
    int fiber = 0;

    for (final entry in filteredMeals) {
      final recipe = recipeMap[entry.recipeId];
      if (recipe != null) {
        totalCals += recipe.macros.calories;
        protein += recipe.macros.proteinG;
        carbs += recipe.macros.carbsG;
        fat += recipe.macros.fatG;
        fiber += recipe.macros.fiberG;
      }
    }

    // Filter beverages by date range
    final filteredBeverages = beverages.where((b) {
      if (_currentPeriod == _Period.daily) {
        return b.dateKey == _dateKey(startDate);
      }
      return !b.dateTime.isBefore(startDate) && b.dateTime.isBefore(endDate);
    }).toList();

    int bevCals = 0;
    int waterMl = 0;
    for (final b in filteredBeverages) {
      bevCals += b.calories;
      if (b.type == BeverageType.water) {
        waterMl += b.milliliters;
      }
    }

    totalCals += bevCals;

    return _NutritionData(
      totalCalories: totalCals,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      fiberG: fiber,
      mealsLogged: filteredMeals.length,
      beverageCalories: bevCals,
      waterMl: waterMl,
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Watch providers so the widget rebuilds when data changes
    ref.watch(mealPlanProvider);
    ref.watch(recipeMapProvider);
    ref.watch(beverageProvider);

    final data = _computeData();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(l10n.summaryTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.accentOrange,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.accentOrange,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(text: l10n.summaryDaily),
            Tab(text: l10n.summaryWeekly),
            Tab(text: l10n.summaryMonthly),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date navigation bar
          _DateNavigationBar(
            label: _periodLabel(),
            onBack: _goBack,
            onForward: _goForward,
          ),

          // Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _NutritionContent(
                key: ValueKey('${_currentPeriod.name}-${_periodLabel()}'),
                data: data,
                l10n: l10n,
                theme: theme,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Date Navigation Bar
// ---------------------------------------------------------------------------

class _DateNavigationBar extends StatelessWidget {
  final String label;
  final VoidCallback onBack;
  final VoidCallback onForward;

  const _DateNavigationBar({
    required this.label,
    required this.onBack,
    required this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, size: 28),
            onPressed: onBack,
            color: AppTheme.textPrimary,
            splashRadius: 22,
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, size: 28),
            onPressed: onForward,
            color: AppTheme.textPrimary,
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nutrition Content (scrollable body)
// ---------------------------------------------------------------------------

class _NutritionContent extends StatelessWidget {
  final _NutritionData data;
  final AppLocalizations l10n;
  final ThemeData theme;

  const _NutritionContent({
    super.key,
    required this.data,
    required this.l10n,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (data.mealsLogged == 0 && data.beverageCalories == 0) {
      return _EmptyState(l10n: l10n);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        // Calories header card
        _CaloriesHeaderCard(data: data, l10n: l10n),
        const SizedBox(height: 16),

        // Donut chart + macro breakdown
        _MacroChartCard(data: data, l10n: l10n),
        const SizedBox(height: 16),

        // Detailed macro rows
        _MacroDetailCard(data: data, l10n: l10n),
        const SizedBox(height: 16),

        // Meals & beverages summary
        _MealsAndBeveragesCard(data: data, l10n: l10n),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.accentOrange.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              size: 48,
              color: AppTheme.accentOrange,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.noData,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.plannerEmpty,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calories Header Card
// ---------------------------------------------------------------------------

class _CaloriesHeaderCard extends StatelessWidget {
  final _NutritionData data;
  final AppLocalizations l10n;

  const _CaloriesHeaderCard({required this.data, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentOrange.withAlpha(50),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: data.totalCalories),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Text(
                '$value',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -2,
                  height: 1.1,
                ),
              );
            },
          ),
          Text(
            l10n.recipeCalories,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white.withAlpha(210),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withAlpha(40),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _HeaderStat(
                icon: Icons.restaurant_rounded,
                value: '${data.foodCalories}',
                label: l10n.summaryMealsLogged,
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withAlpha(40),
              ),
              _HeaderStat(
                icon: Icons.local_cafe_rounded,
                value: '${data.beverageCalories}',
                label: 'kcal',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withAlpha(180), size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withAlpha(160),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Macro Chart Card (Donut + legend)
// ---------------------------------------------------------------------------

class _MacroChartCard extends StatelessWidget {
  final _NutritionData data;
  final AppLocalizations l10n;

  const _MacroChartCard({required this.data, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recipeNutrition,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Donut chart
              SizedBox(
                width: 140,
                height: 140,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, _) {
                    return CustomPaint(
                      size: const Size(140, 140),
                      painter: _DonutChartPainter(
                        proteinPercent: data.proteinPercent,
                        carbsPercent: data.carbsPercent,
                        fatPercent: data.fatPercent,
                        progress: progress,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${data.totalCalories}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Text(
                              'kcal',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendItem(
                      color: AppTheme.accentTeal,
                      label: l10n.recipeProtein,
                      grams: data.proteinG,
                      percent: data.proteinPercent,
                    ),
                    const SizedBox(height: 14),
                    _LegendItem(
                      color: AppTheme.warningAmber,
                      label: l10n.recipeCarbs,
                      grams: data.carbsG,
                      percent: data.carbsPercent,
                    ),
                    const SizedBox(height: 14),
                    _LegendItem(
                      color: const Color(0xFFE84393),
                      label: l10n.recipeFat,
                      grams: data.fatG,
                      percent: data.fatPercent,
                    ),
                    const SizedBox(height: 14),
                    _LegendItem(
                      color: AppTheme.successGreen,
                      label: l10n.recipeFiber,
                      grams: data.fiberG,
                      percent: -1, // no percentage for fiber
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int grams;
  final double percent;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.grams,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final showPercent = percent >= 0;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                showPercent
                    ? '${grams}g (${percent.toStringAsFixed(1)}%)'
                    : '${grams}g',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Donut Chart Painter
// ---------------------------------------------------------------------------

class _DonutChartPainter extends CustomPainter {
  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;
  final double progress;

  _DonutChartPainter({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 18.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    // Background track
    final bgPaint = Paint()
      ..color = AppTheme.dividerColor.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    final total = proteinPercent + carbsPercent + fatPercent;
    if (total <= 0) return;

    // Normalize percentages so they sum to 100
    final pNorm = proteinPercent / total;
    final cNorm = carbsPercent / total;
    final fNorm = fatPercent / total;

    const gapAngle = 0.04; // radians gap between segments
    final totalGap = gapAngle * 3;
    final availableAngle = (2 * math.pi - totalGap) * progress;

    final proteinAngle = pNorm * availableAngle;
    final carbsAngle = cNorm * availableAngle;
    final fatAngle = fNorm * availableAngle;

    var startAngle = -math.pi / 2;

    // Draw protein arc
    _drawArc(canvas, rect, startAngle, proteinAngle, AppTheme.accentTeal,
        strokeWidth);
    startAngle += proteinAngle + gapAngle;

    // Draw carbs arc
    _drawArc(canvas, rect, startAngle, carbsAngle, AppTheme.warningAmber,
        strokeWidth);
    startAngle += carbsAngle + gapAngle;

    // Draw fat arc
    _drawArc(canvas, rect, startAngle, fatAngle, const Color(0xFFE84393),
        strokeWidth);
  }

  void _drawArc(Canvas canvas, Rect rect, double startAngle,
      double sweepAngle, Color color, double strokeWidth) {
    if (sweepAngle <= 0) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.proteinPercent != proteinPercent ||
      oldDelegate.carbsPercent != carbsPercent ||
      oldDelegate.fatPercent != fatPercent;
}

// ---------------------------------------------------------------------------
// Macro Detail Card (horizontal bars)
// ---------------------------------------------------------------------------

class _MacroDetailCard extends StatelessWidget {
  final _NutritionData data;
  final AppLocalizations l10n;

  const _MacroDetailCard({required this.data, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final maxGrams = [data.proteinG, data.carbsG, data.fatG, data.fiberG]
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Macronutrients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 20),
          _MacroBarRow(
            label: l10n.recipeProtein,
            grams: data.proteinG,
            percent: data.proteinPercent,
            color: AppTheme.accentTeal,
            icon: Icons.fitness_center_rounded,
            maxGrams: maxGrams,
          ),
          const SizedBox(height: 16),
          _MacroBarRow(
            label: l10n.recipeCarbs,
            grams: data.carbsG,
            percent: data.carbsPercent,
            color: AppTheme.warningAmber,
            icon: Icons.grain_rounded,
            maxGrams: maxGrams,
          ),
          const SizedBox(height: 16),
          _MacroBarRow(
            label: l10n.recipeFat,
            grams: data.fatG,
            percent: data.fatPercent,
            color: const Color(0xFFE84393),
            icon: Icons.water_drop_rounded,
            maxGrams: maxGrams,
          ),
          const SizedBox(height: 16),
          _MacroBarRow(
            label: l10n.recipeFiber,
            grams: data.fiberG,
            percent: -1,
            color: AppTheme.successGreen,
            icon: Icons.eco_rounded,
            maxGrams: maxGrams,
          ),
        ],
      ),
    );
  }
}

class _MacroBarRow extends StatelessWidget {
  final String label;
  final int grams;
  final double percent;
  final Color color;
  final IconData icon;
  final double maxGrams;

  const _MacroBarRow({
    required this.label,
    required this.grams,
    required this.percent,
    required this.color,
    required this.icon,
    required this.maxGrams,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = maxGrams > 0 ? (grams / maxGrams) : 0.0;
    final showPercent = percent >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              showPercent
                  ? '${grams}g  (${percent.toStringAsFixed(1)}%)'
                  : '${grams}g',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: fraction),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return Container(
              height: 8,
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Meals & Beverages Summary Card
// ---------------------------------------------------------------------------

class _MealsAndBeveragesCard extends StatelessWidget {
  final _NutritionData data;
  final AppLocalizations l10n;

  const _MealsAndBeveragesCard({required this.data, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final waterLiters = (data.waterMl / 1000).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Meals logged
          Expanded(
            child: _SummaryTile(
              icon: Icons.restaurant_menu_rounded,
              iconColor: AppTheme.accentOrange,
              value: '${data.mealsLogged}',
              label: l10n.summaryMealsLogged,
            ),
          ),
          Container(
            width: 1,
            height: 56,
            color: AppTheme.dividerColor,
          ),
          // Beverage calories
          Expanded(
            child: _SummaryTile(
              icon: Icons.local_cafe_rounded,
              iconColor: AppTheme.warmCoral,
              value: '${data.beverageCalories}',
              label: l10n.recipeCalories,
            ),
          ),
          Container(
            width: 1,
            height: 56,
            color: AppTheme.dividerColor,
          ),
          // Water intake
          Expanded(
            child: _SummaryTile(
              icon: Icons.water_drop_rounded,
              iconColor: AppTheme.accentTeal,
              value: '${waterLiters}L',
              label: 'Water',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _SummaryTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, progress, child) {
            return Opacity(
              opacity: progress,
              child: Transform.translate(
                offset: Offset(0, 6 * (1 - progress)),
                child: child,
              ),
            );
          },
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: iconColor,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

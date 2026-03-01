import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/recipe_provider.dart';

enum _Period { weekly, monthly, yearly }

class NutritionDetailScreen extends ConsumerStatefulWidget {
  const NutritionDetailScreen({super.key});

  @override
  ConsumerState<NutritionDetailScreen> createState() =>
      _NutritionDetailScreenState();
}

class _NutritionDetailScreenState
    extends ConsumerState<NutritionDetailScreen> {
  _Period _period = _Period.weekly;

  /// Returns a list of (label, calories, protein, carbs, fat) for each bar.
  List<_BarData> _computeData() {
    final mealPlans = ref.read(mealPlanProvider);
    final recipeMap = ref.read(recipeMapProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_period) {
      case _Period.weekly:
        // Last 7 days
        return List.generate(7, (i) {
          final date = today.subtract(Duration(days: 6 - i));
          return _sumForDate(date, mealPlans, recipeMap);
        });
      case _Period.monthly:
        // Last 4 weeks
        return List.generate(4, (i) {
          final weekEnd = today.subtract(Duration(days: (3 - i) * 7));
          final weekStart = weekEnd.subtract(const Duration(days: 6));
          return _sumForRange(weekStart, weekEnd, mealPlans, recipeMap,
              label: '${_weekLabel(i)}');
        });
      case _Period.yearly:
        // Last 12 months
        return List.generate(12, (i) {
          final month = DateTime(now.year, now.month - 11 + i, 1);
          final monthEnd = DateTime(month.year, month.month + 1, 0);
          return _sumForRange(month, monthEnd, mealPlans, recipeMap,
              label: _monthLabel(month.month));
        });
    }
  }

  String _weekLabel(int weekIndex) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    return locale == 'tr' ? '${weekIndex + 1}. Hf' : 'W${weekIndex + 1}';
  }

  String _monthLabel(int month) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final months = locale == 'tr'
        ? ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  _BarData _sumForDate(
    DateTime date,
    List mealPlans,
    Map recipeMap,
  ) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    int cal = 0, pro = 0, carb = 0, fat = 0;
    for (final entry in mealPlans) {
      if (entry.dateKey == dateKey) {
        final recipe = recipeMap[entry.recipeId];
        if (recipe != null) {
          cal += recipe.macros.calories as int;
          pro += recipe.macros.proteinG as int;
          carb += recipe.macros.carbsG as int;
          fat += recipe.macros.fatG as int;
        }
      }
    }
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final dayNames = locale == 'tr'
        ? ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz']
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return _BarData(
      label: dayNames[date.weekday - 1],
      calories: cal,
      protein: pro,
      carbs: carb,
      fat: fat,
    );
  }

  _BarData _sumForRange(
    DateTime start,
    DateTime end,
    List mealPlans,
    Map recipeMap, {
    required String label,
  }) {
    int cal = 0, pro = 0, carb = 0, fat = 0;
    for (var d = start;
        !d.isAfter(end);
        d = d.add(const Duration(days: 1))) {
      final dateKey =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      for (final entry in mealPlans) {
        if (entry.dateKey == dateKey) {
          final recipe = recipeMap[entry.recipeId];
          if (recipe != null) {
            cal += recipe.macros.calories as int;
            pro += recipe.macros.proteinG as int;
            carb += recipe.macros.carbsG as int;
            fat += recipe.macros.fatG as int;
          }
        }
      }
    }
    return _BarData(
      label: label,
      calories: cal,
      protein: pro,
      carbs: carb,
      fat: fat,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = _computeData();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(l10n.summaryTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Period selector
            _PeriodSelector(
              period: _period,
              l10n: l10n,
              onChanged: (p) => setState(() => _period = p),
            ),
            const SizedBox(height: 24),

            // Calories chart
            _ChartCard(
              title: l10n.recipeCalories,
              color: AppTheme.accentOrange,
              data: data,
              valueExtractor: (d) => d.calories.toDouble(),
              l10n: l10n,
            ),
            const SizedBox(height: 16),

            // Protein chart
            _ChartCard(
              title: l10n.recipeProtein,
              color: AppTheme.accentTeal,
              data: data,
              valueExtractor: (d) => d.protein.toDouble(),
              l10n: l10n,
              unit: 'g',
            ),
            const SizedBox(height: 16),

            // Carbs chart
            _ChartCard(
              title: l10n.recipeCarbs,
              color: AppTheme.warningAmber,
              data: data,
              valueExtractor: (d) => d.carbs.toDouble(),
              l10n: l10n,
              unit: 'g',
            ),
            const SizedBox(height: 16),

            // Fat chart
            _ChartCard(
              title: l10n.homeFat,
              color: AppTheme.snackColor,
              data: data,
              valueExtractor: (d) => d.fat.toDouble(),
              l10n: l10n,
              unit: 'g',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _BarData {
  final String label;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const _BarData({
    required this.label,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class _PeriodSelector extends StatelessWidget {
  final _Period period;
  final AppLocalizations l10n;
  final ValueChanged<_Period> onChanged;

  const _PeriodSelector({
    required this.period,
    required this.l10n,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _tabButton(l10n.nutritionPeriodWeekly, _Period.weekly),
          _tabButton(l10n.nutritionPeriodMonthly, _Period.monthly),
          _tabButton(l10n.nutritionPeriodYearly, _Period.yearly),
        ],
      ),
    );
  }

  Widget _tabButton(String label, _Period value) {
    final isActive = period == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.accentOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Color color;
  final List<_BarData> data;
  final double Function(_BarData) valueExtractor;
  final AppLocalizations l10n;
  final String? unit;

  const _ChartCard({
    required this.title,
    required this.color,
    required this.data,
    required this.valueExtractor,
    required this.l10n,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final values = data.map(valueExtractor).toList();
    final maxVal = values.fold<double>(0, (a, b) => a > b ? a : b);
    final total = values.fold<double>(0, (a, b) => a + b);
    final avg = data.isNotEmpty ? total / data.length : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${l10n.nutritionStatsAvg}: ${avg.round()}${unit ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bar chart
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal > 0 ? maxVal * 1.2 : 100,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => color.withAlpha(220),
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()}${unit ?? ''}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max || value == meta.min) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          value.round().toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textLight,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            data[idx].label,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal > 0 ? maxVal / 4 : 25,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppTheme.dividerColor,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        color: color.withAlpha(200),
                        width: data.length <= 7 ? 20 : 14,
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxVal > 0 ? maxVal * 1.2 : 100,
                          color: color.withAlpha(12),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/health_tips_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/check_in_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/recommendation_service.dart';
import 'meal_recommendations_screen.dart';
import 'widgets/check_in_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final profile = ref.watch(profileProvider);
    final checkIn = ref.watch(checkInProvider);
    final inventoryCount = ref.watch(inventoryProvider).length;
    final theme = Theme.of(context);

    // Meal recommendations grouped by meal type
    final recommendations = ref.watch(recommendationsProvider);
    final safeRecipes = ref.watch(safeScoredRecipesProvider);

    // Build grouped recommendations: check-in based or fallback to safe recipes
    final Map<MealType, List<ScoredRecipe>> groupedRecommendations;
    if (recommendations != null) {
      groupedRecommendations = recommendations;
    } else {
      // Group safe recipes by meal type
      final grouped = <MealType, List<ScoredRecipe>>{};
      for (final mealType in MealType.values) {
        grouped[mealType] =
            safeRecipes.where((s) => s.recipe.mealType == mealType).toList();
      }
      groupedRecommendations = grouped;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: _DashboardHeader(
              greeting: _getGreeting(l10n),
              userName: profile.name,
              subtitle: l10n.homeHowAreYou,
              checkIn: checkIn,
              onCheckInTap: () => _showCheckIn(context),
              l10n: l10n,
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),

                // Kitchen Status Card
                _KitchenStatusCard(
                  inventoryCount: inventoryCount,
                  l10n: l10n,
                ),
                const SizedBox(height: 16),

                // Nutrition Day Navigator
                _NutritionDayCard(l10n: l10n),
                const SizedBox(height: 16),

                // Meal Recommendations by type
                Text(
                  l10n.homeMealOfDay,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...MealType.values.map((mealType) {
                  final recipes =
                      groupedRecommendations[mealType] ?? [];
                  final topRecipe =
                      recipes.isNotEmpty ? recipes.first : null;
                  return _MealTypeHeaderCard(
                    mealType: mealType,
                    topRecipe: topRecipe,
                    recipeCount: recipes.length,
                    locale: locale,
                    l10n: l10n,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealRecommendationsScreen(
                          mealType: mealType,
                          recipes: recipes,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Daily Health Tip
                _HealthTipCard(l10n: l10n, locale: locale),
                const SizedBox(height: 16),

                // Mood-based Food Tip
                if (checkIn != null) ...[
                  _MoodFoodTipCard(
                    checkInType: checkIn,
                    l10n: l10n,
                    locale: locale,
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.homeGreetingMorning;
    if (hour < 18) return l10n.homeGreetingAfternoon;
    return l10n.homeGreetingEvening;
  }

  void _showCheckIn(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CheckInSheet(),
    );
  }
}

// ─── Dashboard Header ───────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  final String greeting;
  final String? userName;
  final String subtitle;
  final CheckInType? checkIn;
  final VoidCallback onCheckInTap;
  final AppLocalizations l10n;

  const _DashboardHeader({
    required this.greeting,
    this.userName,
    required this.subtitle,
    required this.checkIn,
    required this.onCheckInTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final displayGreeting = userName != null && userName!.isNotEmpty
        ? '$greeting, $userName!'
        : greeting;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: AppTheme.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayGreeting,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withAlpha(180),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  checkIn != null
                      ? _checkInIcon(checkIn!)
                      : Icons.sunny_snowing,
                  color: checkIn != null
                      ? _checkInIconColor(checkIn!)
                      : Colors.white.withAlpha(200),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onCheckInTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: checkIn != null
                    ? AppTheme.successGreen.withAlpha(40)
                    : Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    checkIn != null ? Icons.check_rounded : Icons.add_rounded,
                    color: checkIn != null
                        ? AppTheme.successGreen
                        : Colors.white.withAlpha(200),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    checkIn != null
                        ? '${l10n.homeCheckIn}: ${_checkInLabel(l10n, checkIn!)}'
                        : l10n.homeStartCheckIn,
                    style: TextStyle(
                      color: checkIn != null
                          ? AppTheme.successGreen
                          : Colors.white.withAlpha(200),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit_rounded,
                    color: checkIn != null
                        ? AppTheme.successGreen.withAlpha(180)
                        : Colors.white.withAlpha(150),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _checkInIcon(CheckInType type) {
    switch (type) {
      case CheckInType.lowEnergy:
        return Icons.battery_1_bar_rounded;
      case CheckInType.bloated:
        return Icons.water_drop_outlined;
      case CheckInType.cravingSweets:
        return Icons.cookie_outlined;
      case CheckInType.cantFocus:
        return Icons.psychology_outlined;
      case CheckInType.pms:
        return Icons.favorite_border_rounded;
      case CheckInType.periodCramps:
        return Icons.healing_rounded;
      case CheckInType.periodFatigue:
        return Icons.nightlight_round;
      case CheckInType.postWorkout:
        return Icons.fitness_center_rounded;
      case CheckInType.feelingBalanced:
        return Icons.balance_rounded;
      case CheckInType.noSpecificIssue:
        return Icons.check_circle_outline_rounded;
    }
  }

  Color _checkInIconColor(CheckInType type) {
    switch (type) {
      case CheckInType.lowEnergy:
        return const Color(0xFFFF9800);
      case CheckInType.bloated:
        return const Color(0xFF42A5F5);
      case CheckInType.cravingSweets:
        return const Color(0xFFE91E63);
      case CheckInType.cantFocus:
        return const Color(0xFF7C4DFF);
      case CheckInType.pms:
      case CheckInType.periodCramps:
      case CheckInType.periodFatigue:
        return AppTheme.snackColor;
      case CheckInType.postWorkout:
        return const Color(0xFF26A69A);
      case CheckInType.feelingBalanced:
        return AppTheme.successGreen;
      case CheckInType.noSpecificIssue:
        return Colors.white.withAlpha(200);
    }
  }

  String _checkInLabel(AppLocalizations l10n, CheckInType type) {
    switch (type) {
      case CheckInType.lowEnergy:
        return l10n.checkInLowEnergy;
      case CheckInType.bloated:
        return l10n.checkInBloated;
      case CheckInType.cravingSweets:
        return l10n.checkInCravingSweets;
      case CheckInType.cantFocus:
        return l10n.checkInCantFocus;
      case CheckInType.pms:
        return l10n.checkInPms;
      case CheckInType.periodCramps:
        return l10n.checkInPeriodCramps;
      case CheckInType.periodFatigue:
        return l10n.checkInPeriodFatigue;
      case CheckInType.postWorkout:
        return l10n.checkInPostWorkout;
      case CheckInType.feelingBalanced:
        return l10n.checkInFeelingBalanced;
      case CheckInType.noSpecificIssue:
        return l10n.checkInNoSpecificIssue;
    }
  }
}

// ─── Kitchen Status Card ────────────────────────────────────────────────────

class _KitchenStatusCard extends StatelessWidget {
  final int inventoryCount;
  final AppLocalizations l10n;

  const _KitchenStatusCard({
    required this.inventoryCount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.kitchen_rounded,
              color: AppTheme.accentOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeKitchenInventory,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  inventoryCount > 0
                      ? '$inventoryCount ${l10n.homeItemsInKitchen}'
                      : l10n.homeKitchenEmpty,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: inventoryCount > 0
                  ? AppTheme.successGreen.withAlpha(20)
                  : AppTheme.warningAmber.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$inventoryCount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: inventoryCount > 0
                    ? AppTheme.successGreen
                    : AppTheme.warningAmber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nutrition Day Navigator Card ───────────────────────────────────────────

class _NutritionDayCard extends ConsumerStatefulWidget {
  final AppLocalizations l10n;

  const _NutritionDayCard({required this.l10n});

  @override
  ConsumerState<_NutritionDayCard> createState() => _NutritionDayCardState();
}

class _NutritionDayCardState extends ConsumerState<_NutritionDayCard> {
  int _dayOffset = 1; // 1 = yesterday (default)
  bool _slidingForward = true;

  DateTime get _selectedDate =>
      DateTime.now().subtract(Duration(days: _dayOffset));

  String _getDateLabel() {
    final l10n = widget.l10n;
    if (_dayOffset == 0) return l10n.plannerToday;
    if (_dayOffset == 1) return l10n.homeYesterday;
    final date = _selectedDate;
    final locale = l10n.locale.languageCode;
    final months = locale == 'tr'
        ? [
            'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
            'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
          ]
        : [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
          ];
    return '${date.day} ${months[date.month - 1]}';
  }

  void _goBack() {
    setState(() {
      _slidingForward = false;
      _dayOffset++;
    });
  }

  void _goForward() {
    if (_dayOffset > 0) {
      setState(() {
        _slidingForward = true;
        _dayOffset--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final theme = Theme.of(context);
    final mealPlans = ref.watch(mealPlanProvider);
    final recipeMap = ref.watch(recipeMapProvider);

    final date = _selectedDate;
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final meals = mealPlans.where((e) => e.dateKey == dateKey).toList();

    int totalCalories = 0;
    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFat = 0;
    for (final entry in meals) {
      final recipe = recipeMap[entry.recipeId];
      if (recipe != null) {
        totalCalories += recipe.macros.calories;
        totalProtein += recipe.macros.proteinG;
        totalCarbs += recipe.macros.carbsG;
        totalFat += recipe.macros.fatG;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.softLavender.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppTheme.softLavender,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.summaryTitle,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${meals.length} ${l10n.homeYesterdayMeals}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Date label
          Center(
            child: Text(
              _getDateLabel(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Content with side arrows
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left arrow (go to older days)
              GestureDetector(
                onTap: _goBack,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.softLavender.withAlpha(15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppTheme.softLavender,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Animated content
              Expanded(
                child: ClipRect(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final slideBegin = _slidingForward
                          ? const Offset(0.3, 0)
                          : const Offset(-0.3, 0);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: slideBegin,
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: _buildNutritionContent(
                      mealCount: meals.length,
                      totalCalories: totalCalories,
                      totalProtein: totalProtein,
                      totalCarbs: totalCarbs,
                      totalFat: totalFat,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Right arrow (go to newer days)
              GestureDetector(
                onTap: _dayOffset > 0 ? _goForward : null,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _dayOffset > 0
                        ? AppTheme.softLavender.withAlpha(15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: _dayOffset > 0
                        ? AppTheme.softLavender
                        : AppTheme.textLight.withAlpha(80),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionContent({
    required int mealCount,
    required int totalCalories,
    required int totalProtein,
    required int totalCarbs,
    required int totalFat,
  }) {
    final l10n = widget.l10n;

    if (mealCount == 0) {
      return Container(
        key: ValueKey('empty_$_dayOffset'),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            l10n.homeNoMealsForDay,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      key: ValueKey('data_$_dayOffset'),
      children: [
        // Calorie center
        Center(
          child: Column(
            children: [
              Text(
                '$totalCalories',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.accentOrange,
                  letterSpacing: -1,
                ),
              ),
              Text(
                l10n.recipeCalories,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Macro bars
        Row(
          children: [
            _MacroItem(
              label: l10n.recipeProtein,
              value: '${totalProtein}g',
              color: AppTheme.accentTeal,
              icon: Icons.fitness_center_rounded,
            ),
            const SizedBox(width: 12),
            _MacroItem(
              label: l10n.recipeCarbs,
              value: '${totalCarbs}g',
              color: AppTheme.warningAmber,
              icon: Icons.grain_rounded,
            ),
            const SizedBox(width: 12),
            _MacroItem(
              label: l10n.homeFat,
              value: '${totalFat}g',
              color: AppTheme.snackColor,
              icon: Icons.water_drop_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Meal Type Header Card ──────────────────────────────────────────────────

class _MealTypeHeaderCard extends StatelessWidget {
  final MealType mealType;
  final ScoredRecipe? topRecipe;
  final int recipeCount;
  final String locale;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _MealTypeHeaderCard({
    required this.mealType,
    required this.topRecipe,
    required this.recipeCount,
    required this.locale,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getMealColor();
    final gradient = _getMealGradient();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(50),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getMealIcon(),
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMealTitle(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (topRecipe != null)
                        Text(
                          topRecipe!.recipe.localizedName(locale),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 13,
                          ),
                        )
                      else
                        Text(
                          l10n.recipeNoResults,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 12,
                          ),
                        ),
                      if (topRecipe != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${topRecipe!.compatibilityPercent}% ${l10n.recipeCompatibility} · $recipeCount ${l10n.homeMealRecipeCount}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(160),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMealTitle() {
    switch (mealType) {
      case MealType.breakfast:
        return l10n.homeMealBreakfastTitle;
      case MealType.lunch:
        return l10n.homeMealLunchTitle;
      case MealType.dinner:
        return l10n.homeMealDinnerTitle;
      case MealType.snack:
        return l10n.homeMealSnackTitle;
    }
  }

  Color _getMealColor() {
    switch (mealType) {
      case MealType.breakfast:
        return AppTheme.breakfastColor;
      case MealType.lunch:
        return AppTheme.lunchColor;
      case MealType.dinner:
        return AppTheme.dinnerColor;
      case MealType.snack:
        return AppTheme.snackColor;
    }
  }

  LinearGradient _getMealGradient() {
    switch (mealType) {
      case MealType.breakfast:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB020), Color(0xFFF09819)],
        );
      case MealType.lunch:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
        );
      case MealType.dinner:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5B6FE6), Color(0xFF4A5BD4)],
        );
      case MealType.snack:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE84393), Color(0xFFD63384)],
        );
    }
  }

  IconData _getMealIcon() {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.free_breakfast_rounded;
      case MealType.lunch:
        return Icons.lunch_dining_rounded;
      case MealType.dinner:
        return Icons.dinner_dining_rounded;
      case MealType.snack:
        return Icons.cookie_rounded;
    }
  }
}

// ─── Quick Actions ──────────────────────────────────────────────────────────

class _QuickActionsRow extends StatelessWidget {
  final CheckInType? checkIn;
  final VoidCallback onCheckInTap;
  final AppLocalizations l10n;

  const _QuickActionsRow({
    required this.checkIn,
    required this.onCheckInTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeQuickActions,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.add_reaction_outlined,
                label: checkIn != null
                    ? l10n.homeChangeCheckIn
                    : l10n.homeStartCheckIn,
                color: AppTheme.softLavender,
                onTap: onCheckInTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.restaurant_menu_rounded,
                label: l10n.homeRecommendations,
                color: AppTheme.accentTeal,
                onTap: checkIn != null ? onCheckInTap : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Daily Health Tip Card ──────────────────────────────────────────────────

class _HealthTipCard extends StatefulWidget {
  final AppLocalizations l10n;
  final String locale;

  const _HealthTipCard({required this.l10n, required this.locale});

  @override
  State<_HealthTipCard> createState() => _HealthTipCardState();
}

class _HealthTipCardState extends State<_HealthTipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tip = getTipOfTheDay();
    final title = tip.title[widget.locale] ?? tip.title['en'] ?? '';
    final body = tip.body[widget.locale] ?? tip.body['en'] ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00B4D8), Color(0xFF0096C7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentTeal.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.l10n.healthTipTitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: Text(
              body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            secondChild: Text(
              body,
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _expanded ? widget.l10n.close : widget.l10n.healthTipReadMore,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mood Food Tip Card ────────────────────────────────────────────────────

class _MoodFoodTipCard extends StatefulWidget {
  final CheckInType checkInType;
  final AppLocalizations l10n;
  final String locale;

  const _MoodFoodTipCard({
    required this.checkInType,
    required this.l10n,
    required this.locale,
  });

  @override
  State<_MoodFoodTipCard> createState() => _MoodFoodTipCardState();
}

class _MoodFoodTipCardState extends State<_MoodFoodTipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final tip = getMoodFoodTip(widget.checkInType);
    if (tip == null) return const SizedBox.shrink();

    final title = tip.title[widget.locale] ?? tip.title['en'] ?? '';
    final body = tip.body[widget.locale] ?? tip.body['en'] ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C5CFC), Color(0xFF9B7EFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softLavender.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.l10n.healthTipMoodTitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: Text(
              body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            secondChild: Text(
              body,
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _expanded ? widget.l10n.close : widget.l10n.healthTipReadMore,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

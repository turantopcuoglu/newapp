import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/check_in_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/recommendation_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';
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
    final mealPlans = ref.watch(mealPlanProvider);
    final recipeMap = ref.watch(recipeMapProvider);
    final theme = Theme.of(context);

    // Yesterday's meals
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayKey =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    final yesterdayMeals =
        mealPlans.where((e) => e.dateKey == yesterdayKey).toList();

    int totalCalories = 0;
    int totalProtein = 0;
    int totalCarbs = 0;
    int totalFat = 0;
    for (final entry in yesterdayMeals) {
      final recipe = recipeMap[entry.recipeId];
      if (recipe != null) {
        totalCalories += recipe.macros.calories;
        totalProtein += recipe.macros.proteinG;
        totalCarbs += recipe.macros.carbsG;
        totalFat += recipe.macros.fatG;
      }
    }

    // Meal of the day recommendation
    final recommendations = ref.watch(recommendationsProvider);
    ScoredRecipe? mealOfTheDay;
    if (recommendations != null) {
      for (final mealType in MealType.values) {
        final list = recommendations[mealType];
        if (list != null && list.isNotEmpty) {
          mealOfTheDay = list.first;
          break;
        }
      }
    }

    // If no check-in based recommendation, get from safe recipes
    if (mealOfTheDay == null) {
      final safe = ref.watch(safeScoredRecipesProvider);
      if (safe.isNotEmpty) {
        mealOfTheDay = safe.first;
      }
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

                // Yesterday's Nutrition
                _YesterdayNutritionCard(
                  mealCount: yesterdayMeals.length,
                  totalCalories: totalCalories,
                  totalProtein: totalProtein,
                  totalCarbs: totalCarbs,
                  totalFat: totalFat,
                  l10n: l10n,
                ),
                const SizedBox(height: 16),

                // Meal of the Day
                if (mealOfTheDay != null) ...[
                  Text(
                    l10n.homeMealOfDay,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _MealOfDayCard(
                    scoredRecipe: mealOfTheDay,
                    locale: locale,
                    l10n: l10n,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecipeDetailScreen(scoredRecipe: mealOfTheDay!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Quick Actions
                _QuickActionsRow(
                  checkIn: checkIn,
                  onCheckInTap: () => _showCheckIn(context),
                  l10n: l10n,
                ),

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
              GestureDetector(
                onTap: onCheckInTap,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    checkIn != null
                        ? Icons.check_circle_rounded
                        : Icons.add_reaction_outlined,
                    color: checkIn != null
                        ? AppTheme.successGreen
                        : Colors.white.withAlpha(200),
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          if (checkIn != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_rounded,
                      color: AppTheme.successGreen, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${l10n.homeCheckIn}: ${_checkInLabel(l10n, checkIn!)}',
                    style: const TextStyle(
                      color: AppTheme.successGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
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

// ─── Yesterday's Nutrition Card ─────────────────────────────────────────────

class _YesterdayNutritionCard extends StatelessWidget {
  final int mealCount;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final AppLocalizations l10n;

  const _YesterdayNutritionCard({
    required this.mealCount,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                l10n.homeYesterdayNutrition,
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
                  '$mealCount ${l10n.homeYesterdayMeals}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (mealCount == 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.homeNoMealsYesterday,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            )
          else ...[
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
        ],
      ),
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

// ─── Meal of the Day Card ───────────────────────────────────────────────────

class _MealOfDayCard extends StatelessWidget {
  final ScoredRecipe scoredRecipe;
  final String locale;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _MealOfDayCard({
    required this.scoredRecipe,
    required this.locale,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final recipe = scoredRecipe.recipe;
    final macros = recipe.macros;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.accentGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentOrange.withAlpha(60),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _mealTypeLabel(recipe.mealType),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                recipe.localizedName(locale),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                recipe.localizedDescription(locale),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withAlpha(200),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _MealChip(
                    icon: Icons.local_fire_department_rounded,
                    label: '${macros.calories} kcal',
                  ),
                  const SizedBox(width: 8),
                  _MealChip(
                    icon: Icons.fitness_center_rounded,
                    label: '${macros.proteinG}g ${l10n.recipeProtein.toLowerCase()}',
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${scoredRecipe.compatibilityPercent}% ${l10n.recipeCompatibility}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mealTypeLabel(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return l10n.recipeBreakfast;
      case MealType.lunch:
        return l10n.recipeLunch;
      case MealType.dinner:
        return l10n.recipeDinner;
      case MealType.snack:
        return l10n.recipeSnack;
    }
  }
}

class _MealChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MealChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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

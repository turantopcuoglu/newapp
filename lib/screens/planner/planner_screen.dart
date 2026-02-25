import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../components/meal_type_badge.dart';
import '../../core/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../models/meal_plan.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/recommendation_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
    _weekStart = DateTime(_weekStart.year, _weekStart.month, _weekStart.day);
  }

  void _prevWeek() =>
      setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));

  void _nextWeek() =>
      setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _weekStart = now.subtract(Duration(days: now.weekday - 1));
      _weekStart = DateTime(_weekStart.year, _weekStart.month, _weekStart.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mealPlans = ref.watch(mealPlanProvider);
    final recipeMap = ref.watch(recipeMapProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d');
    final dayFormat = DateFormat('EEE');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.plannerTitle),
        actions: [
          TextButton(
            onPressed: _goToToday,
            child: Text(l10n.plannerToday),
          ),
        ],
      ),
      body: Column(
        children: [
          // Week navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _prevWeek),
                Text(
                  '${l10n.plannerWeekOf} ${dateFormat.format(_weekStart)}',
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextWeek),
              ],
            ),
          ),

          // Days
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = _weekStart.add(Duration(days: index));
                final isToday = _isSameDay(day, DateTime.now());
                final dayEntries = mealPlans
                    .where((e) => _isSameDay(e.date, day))
                    .toList()
                  ..sort((a, b) => a.mealType.index.compareTo(b.mealType.index));

                return Card(
                  color: isToday
                      ? theme.colorScheme.primary.withAlpha(10)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              dayFormat.format(day),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isToday
                                    ? theme.colorScheme.primary
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(dateFormat.format(day),
                                style: theme.textTheme.bodySmall),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(l10n.plannerToday,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ),
                            ],
                            const Spacer(),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline,
                                  color: theme.colorScheme.primary),
                              onPressed: () => _addMeal(context, day),
                              iconSize: 22,
                            ),
                          ],
                        ),
                        if (dayEntries.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(l10n.plannerEmpty,
                                style: theme.textTheme.bodySmall),
                          )
                        else
                          ...dayEntries.map((entry) =>
                              _buildEntry(context, entry, recipeMap)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(BuildContext context, MealPlanEntry entry,
      Map<String, dynamic> recipeMap) {
    final recipe = recipeMap[entry.recipeId];
    final locale = AppLocalizations.of(context).locale.languageCode;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          MealTypeBadge(mealType: entry.mealType),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              recipe?.localizedName(locale) ?? entry.recipeId,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () =>
                ref.read(mealPlanProvider.notifier).removeEntry(entry.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _addMeal(BuildContext context, DateTime date) async {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final allSafe = ref.read(safeScoredRecipesProvider);

    // Select meal type
    final mealType = await showDialog<MealType>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.plannerSelectMealType),
        children: MealType.values
            .map((type) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, type),
                  child: Text(type.name[0].toUpperCase() + type.name.substring(1)),
                ))
            .toList(),
      ),
    );
    if (mealType == null || !context.mounted) return;

    // Filter recipes by meal type
    final filtered =
        allSafe.where((sr) => sr.recipe.mealType == mealType).toList();

    if (!context.mounted) return;

    // Select recipe
    final selected = await showDialog<ScoredRecipe>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.plannerSelectRecipe),
        children: filtered
            .map((sr) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, sr),
                  child: Text(sr.recipe.localizedName(locale)),
                ))
            .toList(),
      ),
    );
    if (selected == null) return;

    ref.read(mealPlanProvider.notifier).addEntry(
          recipeId: selected.recipe.id,
          date: date,
          mealType: mealType,
        );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

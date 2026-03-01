import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/meal_type_badge.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/recipe.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/my_recipes_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../services/recommendation_service.dart';
import '../my_recipes/create_recipe_screen.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class RecipeBookScreen extends ConsumerStatefulWidget {
  const RecipeBookScreen({super.key});

  @override
  ConsumerState<RecipeBookScreen> createState() => _RecipeBookScreenState();
}

class _RecipeBookScreenState extends ConsumerState<RecipeBookScreen> {
  String _searchQuery = '';
  MealType? _selectedMealType;
  bool _showOnlyMyRecipes = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final allRecipes = ref.watch(allRecipesProvider);
    final myRecipes = ref.watch(myRecipesProvider);
    final inventoryIds = ref.watch(inventoryIdsProvider);
    final theme = Theme.of(context);

    // Filter recipes
    List<Recipe> filteredRecipes = _showOnlyMyRecipes ? myRecipes : allRecipes;

    if (_selectedMealType != null) {
      filteredRecipes = filteredRecipes
          .where((r) => r.mealType == _selectedMealType)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredRecipes = filteredRecipes.where((r) {
        final name = r.localizedName(locale).toLowerCase();
        final desc = r.localizedDescription(locale).toLowerCase();
        return name.contains(query) || desc.contains(query);
      }).toList();
    }

    // Score recipes by inventory
    final scoredRecipes = filteredRecipes.map((recipe) {
      final available = <String>[];
      final missing = <String>[];
      for (final id in recipe.ingredientIds) {
        if (inventoryIds.contains(id)) {
          available.add(id);
        } else {
          missing.add(id);
        }
      }
      final score = recipe.ingredientIds.isEmpty
          ? 0.0
          : available.length / recipe.ingredientIds.length;
      return ScoredRecipe(
        recipe: recipe,
        compatibilityScore: score,
        availableIngredients: available,
        missingIngredients: missing,
      );
    }).toList()
      ..sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recipeBookTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: l10n.recipeBookSearch,
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.textLight),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.recipeBookAll,
                  isSelected: _selectedMealType == null && !_showOnlyMyRecipes,
                  color: AppTheme.accentOrange,
                  onTap: () => setState(() {
                    _selectedMealType = null;
                    _showOnlyMyRecipes = false;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.recipeBreakfast,
                  isSelected: _selectedMealType == MealType.breakfast,
                  color: AppTheme.breakfastColor,
                  onTap: () => setState(() {
                    _selectedMealType = MealType.breakfast;
                    _showOnlyMyRecipes = false;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.recipeLunch,
                  isSelected: _selectedMealType == MealType.lunch,
                  color: AppTheme.lunchColor,
                  onTap: () => setState(() {
                    _selectedMealType = MealType.lunch;
                    _showOnlyMyRecipes = false;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.recipeDinner,
                  isSelected: _selectedMealType == MealType.dinner,
                  color: AppTheme.dinnerColor,
                  onTap: () => setState(() {
                    _selectedMealType = MealType.dinner;
                    _showOnlyMyRecipes = false;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.recipeBookSnacks,
                  isSelected: _selectedMealType == MealType.snack,
                  color: AppTheme.snackColor,
                  onTap: () => setState(() {
                    _selectedMealType = MealType.snack;
                    _showOnlyMyRecipes = false;
                  }),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: l10n.recipeBookMyRecipes,
                  icon: Icons.person_outline_rounded,
                  isSelected: _showOnlyMyRecipes,
                  color: AppTheme.softLavender,
                  onTap: () => setState(() {
                    _showOnlyMyRecipes = !_showOnlyMyRecipes;
                    if (_showOnlyMyRecipes) {
                      _selectedMealType = null;
                    }
                  }),
                ),
              ],
            ),
          ),

          // Recipe count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${scoredRecipes.length} ${l10n.recipeBookTotalRecipes}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Recipe list
          Expanded(
            child: scoredRecipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showOnlyMyRecipes
                              ? Icons.restaurant_menu
                              : Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _showOnlyMyRecipes
                              ? l10n.recipeBookMyRecipesEmpty
                              : l10n.recipeBookEmpty,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        if (_showOnlyMyRecipes) ...[
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CreateRecipeScreen()),
                            ),
                            icon: const Icon(Icons.add, size: 18),
                            label: Text(l10n.myRecipesCreate),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    itemCount: scoredRecipes.length,
                    itemBuilder: (context, index) {
                      final scored = scoredRecipes[index];
                      return _RecipeBookCard(
                        scoredRecipe: scored,
                        locale: locale,
                        l10n: l10n,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RecipeDetailScreen(scoredRecipe: scored),
                          ),
                        ),
                        onAddToPlanner: () =>
                            _addToPlanner(context, scored),
                        onDelete: scored.recipe.isUserCreated
                            ? () => _deleteRecipe(context, scored)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _deleteRecipe(BuildContext context, ScoredRecipe scored) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.recipeBookDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(myRecipesProvider.notifier).removeRecipe(scored.recipe.id);
    }
  }

  void _addToPlanner(BuildContext context, ScoredRecipe scored) async {
    final l10n = AppLocalizations.of(context);

    // Select date
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;

    // Select meal type
    final mealType = await showDialog<MealType>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.plannerSelectMealType),
        children: MealType.values
            .map((type) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, type),
                  child: Text(
                      type.name[0].toUpperCase() + type.name.substring(1)),
                ))
            .toList(),
      ),
    );
    if (mealType == null || !context.mounted) return;

    // Select time (optional)
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: _defaultTimeForMealType(mealType),
      helpText: l10n.plannerSelectTime,
      cancelText: l10n.plannerSkipTime,
      confirmText: l10n.confirm,
    );

    ref.read(mealPlanProvider.notifier).addEntry(
          recipeId: scored.recipe.id,
          date: date,
          mealType: mealType,
          hour: timeOfDay?.hour,
          minute: timeOfDay?.minute,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.recipeBookAddToPlanner)),
      );
    }
  }

  TimeOfDay _defaultTimeForMealType(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return const TimeOfDay(hour: 8, minute: 0);
      case MealType.lunch:
        return const TimeOfDay(hour: 12, minute: 30);
      case MealType.dinner:
        return const TimeOfDay(hour: 19, minute: 0);
      case MealType.snack:
        return const TimeOfDay(hour: 15, minute: 0);
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(30) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? color : AppTheme.textSecondary,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeBookCard extends StatelessWidget {
  final ScoredRecipe scoredRecipe;
  final String locale;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final VoidCallback onAddToPlanner;
  final VoidCallback? onDelete;

  const _RecipeBookCard({
    required this.scoredRecipe,
    required this.locale,
    required this.l10n,
    required this.onTap,
    required this.onAddToPlanner,
    this.onDelete,
  });

  Color _mealTypeColor(MealType type) {
    switch (type) {
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

  IconData _mealTypeIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = scoredRecipe.recipe;
    final theme = Theme.of(context);
    final mealColor = _mealTypeColor(recipe.mealType);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal type icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: mealColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _mealTypeIcon(recipe.mealType),
                      color: mealColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.localizedName(locale),
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recipe.localizedDescription(locale),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  MealTypeBadge(mealType: recipe.mealType),
                  const SizedBox(width: 8),
                  if (recipe.macros.calories > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${recipe.macros.calories} kcal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (recipe.isUserCreated) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.softLavender.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.recipeBookMyRecipes,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.softLavender,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (onDelete != null)
                    SizedBox(
                      height: 32,
                      child: IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        color: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        constraints: const BoxConstraints(),
                        tooltip: l10n.delete,
                      ),
                    ),
                  // Add to planner button
                  SizedBox(
                    height: 32,
                    child: TextButton.icon(
                      onPressed: onAddToPlanner,
                      icon: const Icon(Icons.calendar_today, size: 14),
                      label: Text(
                        l10n.recipeBookAddToPlanner,
                        style: const TextStyle(fontSize: 11),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: Size.zero,
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/recipe.dart';
import '../../providers/locale_provider.dart';
import '../../providers/my_recipes_provider.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  ConsumerState<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  MealType _mealType = MealType.lunch;
  NutrientLevel _proteinLevel = NutrientLevel.medium;
  NutrientLevel _fiberLevel = NutrientLevel.medium;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

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

  String _mealTypeLabel(MealType type, AppLocalizations l10n) {
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

  String _nutrientLevelLabel(NutrientLevel level, AppLocalizations l10n) {
    switch (level) {
      case NutrientLevel.low:
        return l10n.levelLow;
      case NutrientLevel.medium:
        return l10n.levelMedium;
      case NutrientLevel.high:
        return l10n.levelHigh;
    }
  }

  Color _nutrientLevelColor(NutrientLevel level) {
    switch (level) {
      case NutrientLevel.low:
        return const Color(0xFFE57373);
      case NutrientLevel.medium:
        return AppTheme.warningAmber;
      case NutrientLevel.high:
        return AppTheme.successGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myRecipesCreate)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe name
            _buildSectionLabel(l10n.myRecipesName, Icons.restaurant_menu, theme),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: l10n.myRecipesName,
              ),
              enableIMEPersonalizedLearning: true,
              autocorrect: false,
              enableSuggestions: true,
            ),
            const SizedBox(height: 20),

            // Description
            _buildSectionLabel(l10n.myRecipesDescription, Icons.description_outlined, theme),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                hintText: l10n.myRecipesDescription,
              ),
              maxLines: 2,
              enableIMEPersonalizedLearning: true,
              autocorrect: false,
              enableSuggestions: true,
            ),
            const SizedBox(height: 24),

            // Meal type
            _buildSectionLabel(l10n.myRecipesMealType, Icons.schedule, theme),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: MealType.values.map((type) {
                final isSelected = _mealType == type;
                final color = _mealTypeColor(type);
                return ChoiceChip(
                  label: Text(_mealTypeLabel(type, l10n)),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _mealType = type),
                  backgroundColor: color.withAlpha(30),
                  selectedColor: color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? color : color.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Ingredients
            _buildSectionLabel(l10n.myRecipesIngredients, Icons.kitchen, theme),
            const SizedBox(height: 8),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                hintText: l10n.myRecipesIngredients,
              ),
              maxLines: 5,
              minLines: 3,
              enableIMEPersonalizedLearning: true,
              autocorrect: false,
              enableSuggestions: true,
            ),
            const SizedBox(height: 24),

            // Steps
            _buildSectionLabel(l10n.myRecipesSteps, Icons.format_list_numbered, theme),
            const SizedBox(height: 8),
            TextField(
              controller: _stepsController,
              decoration: InputDecoration(
                hintText: l10n.myRecipesSteps,
              ),
              maxLines: 5,
              minLines: 3,
              enableIMEPersonalizedLearning: true,
              autocorrect: false,
              enableSuggestions: true,
            ),
            const SizedBox(height: 24),

            // Protein level
            _buildSectionLabel(l10n.recipeProtein, Icons.fitness_center, theme),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: NutrientLevel.values.map((level) {
                final isSelected = _proteinLevel == level;
                final color = _nutrientLevelColor(level);
                return ChoiceChip(
                  label: Text(_nutrientLevelLabel(level, l10n)),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _proteinLevel = level),
                  backgroundColor: color.withAlpha(30),
                  selectedColor: color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? color : color.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Fiber level
            _buildSectionLabel(l10n.recipeFiber, Icons.eco, theme),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: NutrientLevel.values.map((level) {
                final isSelected = _fiberLevel == level;
                final color = _nutrientLevelColor(level);
                return ChoiceChip(
                  label: Text(_nutrientLevelLabel(level, l10n)),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _fiberLevel = level),
                  backgroundColor: color.withAlpha(30),
                  selectedColor: color,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? color : color.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                );
              }).toList(),
            ),

            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded),
                label: Text(l10n.myRecipesSave),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final locale = ref.read(localeProvider).languageCode;
    final ingredients = _ingredientsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final steps = _stepsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final recipe = Recipe(
      id: 'user_${const Uuid().v4()}',
      name: {locale: name},
      description: {locale: _descController.text.trim()},
      mealType: _mealType,
      ingredientIds: ingredients,
      proteinLevel: _proteinLevel,
      fiberLevel: _fiberLevel,
      steps: {locale: steps},
      isUserCreated: true,
      checkInTags: [CheckInType.feelingBalanced, CheckInType.noSpecificIssue],
    );

    ref.read(myRecipesProvider.notifier).addRecipe(recipe);
    Navigator.pop(context);
  }
}

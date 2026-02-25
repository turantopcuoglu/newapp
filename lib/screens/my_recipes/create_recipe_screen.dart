import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/enums.dart';
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.myRecipesName),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: l10n.myRecipesDescription),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Meal type
            Text(l10n.myRecipesMealType, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: MealType.values.map((type) {
                return ChoiceChip(
                  label: Text(type.name[0].toUpperCase() + type.name.substring(1)),
                  selected: _mealType == type,
                  onSelected: (_) => setState(() => _mealType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: l10n.myRecipesIngredients,
              ),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _stepsController,
              decoration: InputDecoration(labelText: l10n.myRecipesSteps),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 16),

            // Protein level
            Text(l10n.recipeProtein, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: NutrientLevel.values.map((level) {
                return ChoiceChip(
                  label: Text(level.name),
                  selected: _proteinLevel == level,
                  onSelected: (_) =>
                      setState(() => _proteinLevel = level),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Fiber level
            Text(l10n.recipeFiber, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: NutrientLevel.values.map((level) {
                return ChoiceChip(
                  label: Text(level.name),
                  selected: _fiberLevel == level,
                  onSelected: (_) =>
                      setState(() => _fiberLevel = level),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.myRecipesSave),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
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

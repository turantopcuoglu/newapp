import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/ingredient_nutrition_data.dart';
import '../../data/mock_ingredients.dart';
import '../../l10n/app_localizations.dart';
import '../../models/recipe.dart';
import '../../providers/locale_provider.dart';
import '../../providers/my_recipes_provider.dart';
import '../../widgets/ingredient_selector.dart';
import '../../widgets/nutrition_live_card.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  ConsumerState<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _stepsController = TextEditingController();
  MealType _mealType = MealType.lunch;
  NutrientLevel _proteinLevel = NutrientLevel.medium;
  NutrientLevel _fiberLevel = NutrientLevel.medium;

  /// ingredient id → serving weight in grams
  final Map<String, double> _selectedIngredients = {};

  /// Controllers for gram inputs keyed by ingredient id.
  final Map<String, TextEditingController> _gramControllers = {};

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _stepsController.dispose();
    for (final c in _gramControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────

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

  // ── ingredient selection ─────────────────────────────────────────────

  Future<void> _openIngredientSelector() async {
    final locale = ref.read(localeProvider).languageCode;
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IngredientSelectorSheet(
        alreadySelected: _selectedIngredients.keys.toSet(),
        locale: locale,
      ),
    );
    if (result == null) return;

    setState(() {
      // Remove deselected
      _selectedIngredients.keys
          .where((id) => !result.contains(id))
          .toList()
          .forEach((id) {
        _selectedIngredients.remove(id);
        _gramControllers[id]?.dispose();
        _gramControllers.remove(id);
      });

      // Add newly selected
      for (final id in result) {
        if (!_selectedIngredients.containsKey(id)) {
          final defaultG =
              ingredientNutritionData[id]?.defaultServingG ?? 100;
          _selectedIngredients[id] = defaultG;
          _gramControllers[id] =
              TextEditingController(text: defaultG.round().toString());
        }
      }
    });
  }

  void _removeIngredient(String id) {
    setState(() {
      _selectedIngredients.remove(id);
      _gramControllers[id]?.dispose();
      _gramControllers.remove(id);
    });
  }

  void _updateGrams(String id, String text) {
    final value = double.tryParse(text);
    if (value != null && value > 0) {
      setState(() => _selectedIngredients[id] = value);
    }
  }

  // ── computed macros ──────────────────────────────────────────────────

  MacroEstimation get _computedMacros {
    double cal = 0, prot = 0, carbs = 0, fat = 0, fiber = 0;
    for (final entry in _selectedIngredients.entries) {
      final n = ingredientNutritionData[entry.key];
      if (n == null) continue;
      final f = entry.value / 100.0;
      cal += n.caloriesPer100g * f;
      prot += n.proteinPer100g * f;
      carbs += n.carbsPer100g * f;
      fat += n.fatPer100g * f;
      fiber += n.fiberPer100g * f;
    }
    return MacroEstimation(
      calories: cal.round(),
      proteinG: prot.round(),
      carbsG: carbs.round(),
      fatG: fat.round(),
      fiberG: fiber.round(),
    );
  }

  // ── build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myRecipesCreate)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Recipe name ──
            _buildSectionLabel(
                l10n.myRecipesName, Icons.restaurant_menu, theme),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: l10n.myRecipesName),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // ── Description ──
            _buildSectionLabel(
                l10n.myRecipesDescription, Icons.description_outlined, theme),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              decoration: InputDecoration(hintText: l10n.myRecipesDescription),
              maxLines: 2,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 24),

            // ── Meal type ──
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Ingredients ──
            _buildSectionLabel(
                l10n.myRecipesIngredients, Icons.kitchen, theme),
            const SizedBox(height: 12),

            // Add ingredient button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openIngredientSelector,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(l10n.ingredientAddBtn),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Selected ingredients list
            if (_selectedIngredients.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: Column(
                  children: [
                    Icon(Icons.restaurant,
                        size: 40, color: AppTheme.textLight.withAlpha(120)),
                    const SizedBox(height: 8),
                    Text(
                      l10n.ingredientNone,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              _buildSelectedIngredientsList(locale, l10n, theme),

            const SizedBox(height: 20),

            // ── Nutrition live card ──
            NutritionLiveCard(servings: _selectedIngredients),

            const SizedBox(height: 24),

            // ── Steps ──
            _buildSectionLabel(
                l10n.myRecipesSteps, Icons.format_list_numbered, theme),
            const SizedBox(height: 8),
            TextField(
              controller: _stepsController,
              decoration: InputDecoration(hintText: l10n.myRecipesSteps),
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(height: 24),

            // ── Protein level ──
            _buildSectionLabel(
                l10n.recipeProtein, Icons.fitness_center, theme),
            const SizedBox(height: 10),
            _buildNutrientLevelChips(
              value: _proteinLevel,
              onChanged: (v) => setState(() => _proteinLevel = v),
              l10n: l10n,
            ),
            const SizedBox(height: 24),

            // ── Fiber level ──
            _buildSectionLabel(l10n.recipeFiber, Icons.eco, theme),
            const SizedBox(height: 10),
            _buildNutrientLevelChips(
              value: _fiberLevel,
              onChanged: (v) => setState(() => _fiberLevel = v),
              l10n: l10n,
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

  // ── section label ──

  Widget _buildSectionLabel(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }

  // ── nutrient level chips ──

  Widget _buildNutrientLevelChips({
    required NutrientLevel value,
    required ValueChanged<NutrientLevel> onChanged,
    required AppLocalizations l10n,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: NutrientLevel.values.map((level) {
        final isSelected = value == level;
        final color = _nutrientLevelColor(level);
        return ChoiceChip(
          label: Text(_nutrientLevelLabel(level, l10n)),
          selected: isSelected,
          onSelected: (_) => onChanged(level),
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
    );
  }

  // ── selected ingredients list ──

  Widget _buildSelectedIngredientsList(
      String locale, AppLocalizations l10n, ThemeData theme) {
    final ids = _selectedIngredients.keys.toList();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.checklist_rounded,
                    size: 18, color: AppTheme.accentOrange),
                const SizedBox(width: 8),
                Text(
                  l10n.ingredientSelected,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${ids.length}',
                    style: const TextStyle(
                      color: AppTheme.accentOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Items
          ...ids.map((id) {
            final ingredient = mockIngredients.firstWhere(
              (i) => i.id == id,
              orElse: () => mockIngredients.first,
            );
            final name = ingredient.localizedName(locale);
            final grams = _selectedIngredients[id]!;
            final nutrition = ingredientNutritionData[id];
            final cals = nutrition != null
                ? (nutrition.caloriesPer100g * grams / 100).round()
                : 0;

            return Dismissible(
              key: ValueKey(id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => _removeIngredient(id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red.withAlpha(30),
                child: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 22),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.dividerColor.withAlpha(100),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Ingredient info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$cals kcal',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.accentOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Gram input
                    SizedBox(
                      width: 70,
                      height: 36,
                      child: TextField(
                        controller: _gramControllers[id],
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          filled: true,
                          fillColor: AppTheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppTheme.dividerColor, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppTheme.dividerColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppTheme.accentOrange, width: 1.5),
                          ),
                        ),
                        onChanged: (v) => _updateGrams(id, v),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'g',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Remove button
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeIngredient(id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── save ──

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final locale = ref.read(localeProvider).languageCode;
    final steps = _stepsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Collect allergen tags from selected ingredients
    final allergens = <String>{};
    for (final id in _selectedIngredients.keys) {
      final ingredient = mockIngredients.firstWhere(
        (i) => i.id == id,
        orElse: () => mockIngredients.first,
      );
      allergens.addAll(ingredient.allergenTags);
    }

    final macros = _computedMacros;

    final recipe = Recipe(
      id: 'user_${const Uuid().v4()}',
      name: {locale: name},
      description: {locale: _descController.text.trim()},
      mealType: _mealType,
      ingredientIds: _selectedIngredients.keys.toList(),
      allergenTags: allergens.toList(),
      proteinLevel: _proteinLevel,
      fiberLevel: _fiberLevel,
      macros: macros,
      steps: {locale: steps},
      isUserCreated: true,
      checkInTags: [CheckInType.feelingBalanced, CheckInType.noSpecificIssue],
    );

    ref.read(myRecipesProvider.notifier).addRecipe(recipe);
    Navigator.pop(context);
  }
}

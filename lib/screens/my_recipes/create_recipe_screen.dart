import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/ingredient_nutrition_data.dart';
import '../../data/mock_ingredients.dart';
import '../../l10n/app_localizations.dart';
import '../../data/explore_data.dart';
import '../../models/recipe.dart';
import '../../providers/locale_provider.dart';
import '../../providers/my_recipes_provider.dart';
import '../../widgets/ingredient_selector.dart';
import '../../widgets/nutrition_live_card.dart';
import '../../widgets/turkish_text_field.dart';

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
  String? _selectedCuisineId;

  /// ingredient id → amount+unit
  final Map<String, IngredientQuantity> _selectedIngredients = {};

  /// Controllers for amount inputs keyed by ingredient id.
  final Map<String, TextEditingController> _amountControllers = {};

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _stepsController.dispose();
    for (final c in _amountControllers.values) {
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
      _selectedIngredients.keys
          .where((id) => !result.contains(id))
          .toList()
          .forEach((id) {
        _selectedIngredients.remove(id);
        _amountControllers[id]?.dispose();
        _amountControllers.remove(id);
      });

      for (final id in result) {
        if (_selectedIngredients.containsKey(id)) continue;

        final ingredient = mockIngredients.firstWhere(
          (i) => i.id == id,
          orElse: () => mockIngredients.first,
        );
        final nutrition = _nutritionFor(id, ingredient.category);
        final unit = _suggestUnit(id, ingredient.category);
        final quantity = _defaultQuantityForUnit(
          unit,
          nutrition?.defaultServingG ?? 100,
        );

        _selectedIngredients[id] = quantity;
        _amountControllers[id] = TextEditingController(
          text: _formatAmountForInput(quantity.amount),
        );
      }
    });
  }

  IngredientNutrition _nutritionFor(
    String ingredientId,
    IngredientCategory category,
  ) {
    return resolveIngredientNutrition(
      ingredientId: ingredientId,
      category: category,
    );
  }

  QuantityUnit _suggestUnit(String ingredientId, IngredientCategory category) {
    const pieceIds = {
      'eggs',
      'banana',
      'apple',
      'orange',
      'pear',
      'peach',
      'plum',
      'tangerine',
      'lemon',
      'lime',
      'avocado',
      'onion',
      'red_onion',
      'garlic',
      'tomato',
      'potato',
      'sweet_potato',
      'bread',
      'tortilla',
      'rice_cake',
      'granola_bar',
    };
    const literIds = {'milk', 'water', 'juice', 'lemonade'};
    const mlIds = {
      'olive_oil',
      'vegetable_oil',
      'avocado_oil',
      'grape_seed_oil',
      'vinegar',
      'white_vinegar',
      'balsamic_vinegar',
      'soy_sauce',
      'hot_sauce',
      'ketchup',
      'mayonnaise',
      'mustard',
      'maple_syrup',
      'honey',
      'vanilla_extract',
      'rose_water',
    };

    if (pieceIds.contains(ingredientId)) return QuantityUnit.piece;
    if (literIds.contains(ingredientId)) return QuantityUnit.L;
    if (mlIds.contains(ingredientId)) return QuantityUnit.ml;

    if (category == IngredientCategory.oil ||
        category == IngredientCategory.condiment ||
        category == IngredientCategory.beverage) {
      return QuantityUnit.ml;
    }

    return QuantityUnit.g;
  }

  IngredientQuantity _defaultQuantityForUnit(QuantityUnit unit, double defaultG) {
    switch (unit) {
      case QuantityUnit.piece:
        return const IngredientQuantity(amount: 1, unit: QuantityUnit.piece);
      case QuantityUnit.L:
        return IngredientQuantity(
          amount: (defaultG / 1000).clamp(0.1, 1.5).toDouble(),
          unit: QuantityUnit.L,
        );
      case QuantityUnit.ml:
        return IngredientQuantity(
          amount: defaultG.clamp(5, 300).toDouble(),
          unit: QuantityUnit.ml,
        );
      default:
        return IngredientQuantity(amount: defaultG, unit: QuantityUnit.g);
    }
  }

  String _formatAmountForInput(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(1);
  }

  void _removeIngredient(String id) {
    setState(() {
      _selectedIngredients.remove(id);
      _amountControllers[id]?.dispose();
      _amountControllers.remove(id);
    });
  }

  void _updateAmount(String id, String text) {
    final value = double.tryParse(text.replaceAll(',', '.'));
    if (value == null || value <= 0) return;
    final prev = _selectedIngredients[id];
    if (prev == null) return;

    setState(() {
      _selectedIngredients[id] = IngredientQuantity(
        amount: value,
        unit: prev.unit,
      );
    });
  }

  double _quantityToGrams(IngredientQuantity quantity, double defaultServingG) {
    switch (quantity.unit) {
      case QuantityUnit.g:
        return quantity.amount;
      case QuantityUnit.ml:
        return quantity.amount;
      case QuantityUnit.L:
        return quantity.amount * 1000;
      case QuantityUnit.piece:
        return quantity.amount * defaultServingG;
      case QuantityUnit.tablespoon:
        return quantity.amount * 15;
      case QuantityUnit.teaspoon:
        return quantity.amount * 5;
      case QuantityUnit.cup:
        return quantity.amount * 240;
      case QuantityUnit.bunch:
        return quantity.amount * 50;
      case QuantityUnit.slice:
        return quantity.amount * 30;
      case QuantityUnit.pinch:
        return quantity.amount * 0.5;
      case QuantityUnit.clove:
        return quantity.amount * 5;
    }
  }

  Map<String, double> get _servingsInGrams {
    final map = <String, double>{};
    for (final entry in _selectedIngredients.entries) {
      final ingredient = mockIngredients.firstWhere(
        (i) => i.id == entry.key,
        orElse: () => mockIngredients.first,
      );
      final nutrition = _nutritionFor(entry.key, ingredient.category);
      final defaultServingG = nutrition?.defaultServingG ?? 100;
      map[entry.key] = _quantityToGrams(entry.value, defaultServingG);
    }
    return map;
  }

  // ── computed macros ──────────────────────────────────────────────────

  MacroEstimation get _computedMacros {
    double cal = 0, prot = 0, carbs = 0, fat = 0, fiber = 0;
    for (final entry in _selectedIngredients.entries) {
      final ingredient = mockIngredients.firstWhere(
        (i) => i.id == entry.key,
        orElse: () => mockIngredients.first,
      );
      final n = _nutritionFor(entry.key, ingredient.category);
      if (n == null) continue;
      final grams = _quantityToGrams(entry.value, n.defaultServingG);
      final f = grams / 100.0;
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
            TurkishTextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: l10n.myRecipesName),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // ── Description ──
            _buildSectionLabel(
                l10n.myRecipesDescription, Icons.description_outlined, theme),
            const SizedBox(height: 8),
            TurkishTextField(
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
            NutritionLiveCard(servings: _servingsInGrams),

            const SizedBox(height: 24),

            // ── Steps ──
            _buildSectionLabel(
                l10n.myRecipesSteps, Icons.format_list_numbered, theme),
            const SizedBox(height: 8),
            TurkishTextField(
              controller: _stepsController,
              decoration: InputDecoration(hintText: l10n.myRecipesSteps),
              maxLines: 5,
              minLines: 3,
            ),

            const SizedBox(height: 24),

            _buildSectionLabel('Mutfak', Icons.public_rounded, theme),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              value: _selectedCuisineId,
              decoration: const InputDecoration(
                hintText: 'Opsiyonel mutfak seçimi',
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Seçilmedi'),
                ),
                ...worldCuisines.map(
                  (c) => DropdownMenuItem<String?>(
                    value: c.id,
                    child: Text(c.localizedName(locale)),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _selectedCuisineId = value),
            ),

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
            final quantity = _selectedIngredients[id]!;
            final nutrition = _nutritionFor(id, ingredient.category);
            final grams = _quantityToGrams(
              quantity,
              nutrition?.defaultServingG ?? 100,
            );
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
                        controller: _amountControllers[id],
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9,.]"))
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
                        onChanged: (v) => _updateAmount(id, v),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)
                          .localizedUnit(quantity.unit.name),
                      style: const TextStyle(
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

    final quantities = Map<String, IngredientQuantity>.from(_selectedIngredients);

    final recipe = Recipe(
      id: 'user_${const Uuid().v4()}',
      name: {locale: name},
      description: {locale: _descController.text.trim()},
      mealType: _mealType,
      ingredientIds: quantities.keys.toList(),
      allergenTags: allergens.toList(),
      proteinLevel: _proteinLevel,
      fiberLevel: _fiberLevel,
      macros: macros,
      steps: {locale: steps},
      isUserCreated: true,
      checkInTags: [CheckInType.noSpecificIssue],
      quantities: quantities,
      cuisineId: _selectedCuisineId,
      isExploreRecipe: false,
    );

    ref.read(myRecipesProvider.notifier).addRecipe(recipe);
    Navigator.pop(context);
  }
}

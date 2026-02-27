import 'package:flutter/material.dart';
import '../core/enums.dart';
import '../core/theme.dart';
import '../data/ingredient_nutrition_data.dart';
import '../data/mock_ingredients.dart';
import '../l10n/app_localizations.dart';
import '../models/ingredient.dart';

/// Bottom-sheet that lets users search, filter by category, and pick
/// ingredients from the pre-populated database.
class IngredientSelectorSheet extends StatefulWidget {
  final Set<String> alreadySelected;
  final String locale;

  const IngredientSelectorSheet({
    super.key,
    required this.alreadySelected,
    required this.locale,
  });

  @override
  State<IngredientSelectorSheet> createState() =>
      _IngredientSelectorSheetState();
}

class _IngredientSelectorSheetState extends State<IngredientSelectorSheet> {
  final _searchController = TextEditingController();
  IngredientCategory? _selectedCategory;
  late Set<String> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.alreadySelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Ingredient> get _filteredIngredients {
    var list = mockIngredients;
    if (_selectedCategory != null) {
      list = list.where((i) => i.category == _selectedCategory).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((i) {
        final en = (i.name['en'] ?? '').toLowerCase();
        final tr = (i.name['tr'] ?? '').toLowerCase();
        return en.contains(q) || tr.contains(q) || i.id.contains(q);
      }).toList();
    }
    // Show selected items first
    list.sort((a, b) {
      final aSelected = _selected.contains(a.id) ? 0 : 1;
      final bSelected = _selected.contains(b.id) ? 0 : 1;
      return aSelected.compareTo(bSelected);
    });
    return list;
  }

  String _categoryLabel(IngredientCategory cat, AppLocalizations l10n) {
    switch (cat) {
      case IngredientCategory.protein:
        return l10n.recipeProtein;
      case IngredientCategory.dairy:
        return l10n.catDairy;
      case IngredientCategory.grain:
        return l10n.catGrain;
      case IngredientCategory.vegetable:
        return l10n.catVegetable;
      case IngredientCategory.fruit:
        return l10n.catFruit;
      case IngredientCategory.spice:
        return l10n.catSpice;
      case IngredientCategory.oil:
        return l10n.catOil;
      case IngredientCategory.nut:
        return l10n.catNut;
      case IngredientCategory.legume:
        return l10n.catLegume;
      case IngredientCategory.condiment:
        return l10n.catCondiment;
      case IngredientCategory.other:
        return l10n.catOther;
    }
  }

  IconData _categoryIcon(IngredientCategory cat) {
    switch (cat) {
      case IngredientCategory.protein:
        return Icons.set_meal;
      case IngredientCategory.dairy:
        return Icons.water_drop;
      case IngredientCategory.grain:
        return Icons.grain;
      case IngredientCategory.vegetable:
        return Icons.eco;
      case IngredientCategory.fruit:
        return Icons.apple;
      case IngredientCategory.spice:
        return Icons.local_fire_department;
      case IngredientCategory.oil:
        return Icons.opacity;
      case IngredientCategory.nut:
        return Icons.nature;
      case IngredientCategory.legume:
        return Icons.grass;
      case IngredientCategory.condiment:
        return Icons.kitchen;
      case IngredientCategory.other:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final filtered = _filteredIngredients;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.kitchen,
                        color: AppTheme.accentOrange, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.ingredientSelect,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    if (_selected.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentOrange,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${_selected.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Search
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.inventorySearch,
                    prefixIcon: const Icon(Icons.search, size: 22),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),

              const SizedBox(height: 8),

              // Category filter chips
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip(
                        null, l10n.catAll, Icons.restaurant, theme),
                    ...IngredientCategory.values.map(
                      (cat) => _buildCategoryChip(
                        cat,
                        _categoryLabel(cat, l10n),
                        _categoryIcon(cat),
                        theme,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1),

              // Ingredient list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_off,
                                size: 48, color: AppTheme.textLight),
                            const SizedBox(height: 8),
                            Text(l10n.noData,
                                style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final ingredient = filtered[index];
                          final isSelected =
                              _selected.contains(ingredient.id);
                          final nutrition =
                              ingredientNutritionData[ingredient.id];

                          return _IngredientTile(
                            ingredient: ingredient,
                            locale: widget.locale,
                            isSelected: isSelected,
                            nutrition: nutrition,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selected.remove(ingredient.id);
                                } else {
                                  _selected.add(ingredient.id);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),

              // Done button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(context, _selected),
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        _selected.isEmpty
                            ? l10n.done
                            : l10n.ingredientAddCount(_selected.length),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    IngredientCategory? cat,
    String label,
    IconData icon,
    ThemeData theme,
  ) {
    final isSelected = _selectedCategory == cat;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 15,
                color: isSelected ? Colors.white : AppTheme.accentOrange),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = cat),
        backgroundColor: AppTheme.accentOrange.withAlpha(20),
        selectedColor: AppTheme.accentOrange,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppTheme.accentOrange
                : AppTheme.accentOrange.withAlpha(60),
            width: 1,
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final String locale;
  final bool isSelected;
  final IngredientNutrition? nutrition;
  final VoidCallback onTap;

  const _IngredientTile({
    required this.ingredient,
    required this.locale,
    required this.isSelected,
    required this.nutrition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = ingredient.localizedName(locale);
    final cals = nutrition?.caloriesPer100g.round() ?? 0;
    final protein = nutrition?.proteinPer100g.round() ?? 0;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentOrange
              : AppTheme.accentOrange.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isSelected ? Icons.check_rounded : Icons.add_rounded,
          color: isSelected ? Colors.white : AppTheme.accentOrange,
          size: 22,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 15,
          color: isSelected ? AppTheme.accentOrange : AppTheme.textPrimary,
        ),
      ),
      subtitle: nutrition != null
          ? Text(
              '$cals kcal  ·  ${protein}g protein  /  100g',
              style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
            )
          : null,
      trailing: isSelected
          ? const Icon(Icons.check_circle,
              color: AppTheme.accentOrange, size: 22)
          : null,
    );
  }
}

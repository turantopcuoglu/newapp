import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums.dart';
import '../../core/theme.dart';
import '../../data/mock_ingredients.dart';
import '../../l10n/app_localizations.dart';
import '../../models/ingredient.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/shopping_provider.dart';

class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navMyKitchen),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.accentOrange,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.accentOrange,
          tabs: [
            Tab(
              icon: const Icon(Icons.kitchen_rounded, size: 20),
              text: l10n.inventoryTitle,
            ),
            Tab(
              icon: const Icon(Icons.shopping_bag_rounded, size: 20),
              text: l10n.shoppingTitle,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _KitchenInventoryTab(),
          _ShoppingListTab(),
        ],
      ),
    );
  }
}

// ─── Kitchen Inventory Tab ──────────────────────────────────────────────────

class _KitchenInventoryTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_KitchenInventoryTab> createState() =>
      _KitchenInventoryTabState();
}

class _KitchenInventoryTabState extends ConsumerState<_KitchenInventoryTab> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  IngredientCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Ingredient> _getFilteredIngredients(Set<String> inventoryIds) {
    var results = mockIngredients.toList();

    if (_selectedCategory != null) {
      results =
          results.where((i) => i.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((i) {
        return i.name.values
            .any((name) => name.toLowerCase().contains(query));
      }).toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final theme = Theme.of(context);
    final inventoryItems = ref.watch(inventoryProvider);
    final inventoryIds =
        inventoryItems.map((i) => i.ingredientId).toSet();

    final filteredIngredients = _getFilteredIngredients(inventoryIds);

    // Separate into: in inventory vs not in inventory
    final inInventory =
        filteredIngredients.where((i) => inventoryIds.contains(i.id)).toList();
    final notInInventory =
        filteredIngredients.where((i) => !inventoryIds.contains(i.id)).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.inventorySearch,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),

        // Category filter chips
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip(null, l10n.catAll, locale),
              _buildCategoryChip(
                  IngredientCategory.protein, l10n.recipeProtein, locale),
              _buildCategoryChip(
                  IngredientCategory.dairy, l10n.catDairy, locale),
              _buildCategoryChip(
                  IngredientCategory.grain, l10n.catGrain, locale),
              _buildCategoryChip(
                  IngredientCategory.vegetable, l10n.catVegetable, locale),
              _buildCategoryChip(
                  IngredientCategory.fruit, l10n.catFruit, locale),
              _buildCategoryChip(
                  IngredientCategory.spice, l10n.catSpice, locale),
              _buildCategoryChip(
                  IngredientCategory.oil, l10n.catOil, locale),
              _buildCategoryChip(
                  IngredientCategory.nut, l10n.catNut, locale),
              _buildCategoryChip(
                  IngredientCategory.legume, l10n.catLegume, locale),
              _buildCategoryChip(
                  IngredientCategory.condiment, l10n.catCondiment, locale),
              _buildCategoryChip(
                  IngredientCategory.snackFood, l10n.catSnackFood, locale),
              _buildCategoryChip(
                  IngredientCategory.other, l10n.catOther, locale),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Inventory count badge
        if (inventoryIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${inventoryIds.length} ${l10n.homeItemsInKitchen}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),

        // Ingredients list
        Expanded(
          child: filteredIngredients.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(l10n.recipeBookEmpty,
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Items in inventory first
                    if (inInventory.isNotEmpty) ...[
                      ...inInventory.map((ingredient) =>
                          _buildIngredientTile(
                              ingredient, true, locale, l10n)),
                      if (notInInventory.isNotEmpty)
                        const Divider(height: 24),
                    ],
                    // Items not in inventory
                    ...notInInventory.map((ingredient) =>
                        _buildIngredientTile(
                            ingredient, false, locale, l10n)),
                    const SizedBox(height: 16),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
      IngredientCategory? category, String label, String locale) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedCategory = isSelected ? null : category);
        },
        selectedColor: AppTheme.accentOrange.withAlpha(40),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.accentOrange : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildIngredientTile(Ingredient ingredient, bool isInInventory,
      String locale, AppLocalizations l10n) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isInInventory
              ? AppTheme.successGreen.withAlpha(20)
              : AppTheme.accentOrange.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isInInventory
              ? Icons.check_circle_rounded
              : Icons.add_circle_outline_rounded,
          color: isInInventory ? AppTheme.successGreen : AppTheme.accentOrange,
          size: 22,
        ),
      ),
      title: Text(
        ingredient.localizedName(locale),
        style: TextStyle(
          fontWeight: isInInventory ? FontWeight.w600 : FontWeight.w400,
          color:
              isInInventory ? AppTheme.textPrimary : AppTheme.textSecondary,
        ),
      ),
      subtitle: Text(
        _categoryLabel(ingredient.category, l10n),
        style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
      ),
      trailing: isInInventory
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded,
                  color: AppTheme.warmCoral, size: 22),
              tooltip: l10n.remove,
              onPressed: () {
                ref
                    .read(inventoryProvider.notifier)
                    .removeItem(ingredient.id);
              },
            )
          : IconButton(
              icon: const Icon(Icons.add_rounded,
                  color: AppTheme.accentOrange, size: 22),
              tooltip: l10n.inventoryAdd,
              onPressed: () {
                ref
                    .read(inventoryProvider.notifier)
                    .addItem(ingredient.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${ingredient.localizedName(l10n.locale.languageCode)} ${l10n.inventoryAdd.toLowerCase()}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
    );
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
      case IngredientCategory.snackFood:
        return l10n.catSnackFood;
      case IngredientCategory.beverage:
        return l10n.catBeverage;
      case IngredientCategory.other:
        return l10n.catOther;
    }
  }
}

// ─── Shopping List Tab ──────────────────────────────────────────────────────

class _ShoppingListTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ShoppingListTab> createState() => _ShoppingListTabState();
}

class _ShoppingListTabState extends ConsumerState<_ShoppingListTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(shoppingProvider);
    final theme = Theme.of(context);

    final pending = items.where((i) => !i.isPurchased).toList();
    final purchased = items.where((i) => i.isPurchased).toList();

    return Column(
      children: [
        // Add item input
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.shoppingItemHint,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addItem,
                    ),
                  ),
                  onSubmitted: (_) => _addItem(),
                ),
              ),
            ],
          ),
        ),

        // Clear purchased button
        if (purchased.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () =>
                    ref.read(shoppingProvider.notifier).clearPurchased(),
                icon: const Icon(Icons.clear_all, size: 18),
                label: Text(l10n.shoppingClearPurchased),
              ),
            ),
          ),

        // List
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(l10n.shoppingEmpty,
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ...pending.map((item) => _buildItem(item.id, item.name,
                        item.isPurchased, item.forRecipeId)),
                    if (purchased.isNotEmpty) ...[
                      const Divider(height: 32),
                      ...purchased.map((item) => _buildItem(item.id,
                          item.name, item.isPurchased, item.forRecipeId)),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildItem(
      String id, String name, bool isPurchased, String? forRecipe) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          ref.read(shoppingProvider.notifier).removeItem(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade100,
        child: Icon(Icons.delete, color: Colors.red.shade700),
      ),
      child: ListTile(
        leading: Checkbox(
          value: isPurchased,
          onChanged: (_) =>
              ref.read(shoppingProvider.notifier).togglePurchased(id),
          activeColor: theme.colorScheme.primary,
        ),
        title: Text(
          name,
          style: TextStyle(
            decoration: isPurchased ? TextDecoration.lineThrough : null,
            color: isPurchased ? Colors.grey : null,
          ),
        ),
        subtitle: forRecipe != null
            ? Text(forRecipe, style: theme.textTheme.bodySmall)
            : null,
        trailing: isPurchased
            ? IconButton(
                icon: const Icon(Icons.kitchen_outlined, size: 20),
                tooltip: l10n.shoppingMoveToKitchen,
                onPressed: () {
                  final ingredientId = _resolveIngredientId(name);
                  ref
                      .read(inventoryProvider.notifier)
                      .addItem(ingredientId);
                  ref
                      .read(shoppingProvider.notifier)
                      .removeItem(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '$name ${l10n.shoppingMoveToKitchen}')),
                  );
                },
              )
            : null,
      ),
    );
  }

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(shoppingProvider.notifier).addItem(text);
    _controller.clear();
  }

  String _resolveIngredientId(String nameOrId) {
    final directMatch = mockIngredients.where((i) => i.id == nameOrId);
    if (directMatch.isNotEmpty) return directMatch.first.id;

    final lower = nameOrId.toLowerCase();
    for (final ingredient in mockIngredients) {
      for (final localizedName in ingredient.name.values) {
        if (localizedName.toLowerCase() == lower) {
          return ingredient.id;
        }
      }
    }

    return nameOrId;
  }
}

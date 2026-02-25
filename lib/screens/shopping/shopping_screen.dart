import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/shopping_provider.dart';

class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shoppingTitle),
        actions: [
          if (purchased.isNotEmpty)
            TextButton.icon(
              onPressed: () =>
                  ref.read(shoppingProvider.notifier).clearPurchased(),
              icon: const Icon(Icons.clear_all, size: 18),
              label: Text(l10n.shoppingClearPurchased),
            ),
        ],
      ),
      body: Column(
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
      ),
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
                  ref.read(inventoryProvider.notifier).addItem(name);
                  ref.read(shoppingProvider.notifier).removeItem(id);
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
}

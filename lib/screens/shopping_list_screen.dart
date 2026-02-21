import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<AppProvider>().addToShoppingList(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);
    final checkedCount =
        provider.shoppingList.where((i) => i.isChecked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alisveris Listesi'),
        actions: [
          if (checkedCount > 0)
            TextButton.icon(
              onPressed: () => provider.clearCheckedItems(),
              icon: const Icon(Icons.done_all, size: 18),
              label: Text('Secilenleri Sil ($checkedCount)'),
            ),
          if (provider.shoppingList.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  _showClearDialog(context);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Text('Tumunu Temizle'),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Add item input
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Urun ekle...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Ekle'),
                ),
              ],
            ),
          ),

          // Shopping list
          Expanded(
            child: provider.shoppingList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Alisveris listeniz bos',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tarif aradiginizda eksik malzemeler\n'
                          'otomatik olarak buraya eklenebilir',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.shoppingList.length,
                    itemBuilder: (context, index) {
                      final item = provider.shoppingList[index];
                      return Dismissible(
                        key: ValueKey('${item.name}_$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: theme.colorScheme.error,
                          child: Icon(Icons.delete,
                              color: theme.colorScheme.onError),
                        ),
                        onDismissed: (_) =>
                            provider.removeShoppingItem(index),
                        child: Card(
                          child: CheckboxListTile(
                            value: item.isChecked,
                            onChanged: (_) =>
                                provider.toggleShoppingItem(index),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item.isChecked
                                    ? theme.colorScheme.onSurfaceVariant
                                    : null,
                              ),
                            ),
                            subtitle: item.forRecipe != null
                                ? Text(
                                    item.forRecipe!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          theme.colorScheme.onSurfaceVariant,
                                    ),
                                  )
                                : null,
                            secondary: Icon(
                              item.isChecked
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: item.isChecked
                                  ? Colors.green
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            controlAffinity:
                                ListTileControlAffinity.trailing,
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Bottom summary
          if (provider.shoppingList.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border(
                  top: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Toplam: ${provider.shoppingList.length} urun',
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (checkedCount > 0)
                    Text(
                      '$checkedCount / ${provider.shoppingList.length} alindi',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Listeyi Temizle'),
        content: const Text(
            'Tum alisveris listesi silinecek. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Iptal'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AppProvider>().clearShoppingList();
              Navigator.pop(ctx);
            },
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }
}

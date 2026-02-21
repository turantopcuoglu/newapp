import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<AppProvider>();

    // Support comma-separated input
    if (text.contains(',')) {
      final items = text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      provider.addMultipleIngredients(items);
    } else {
      provider.addIngredient(text);
    }

    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dolabim'),
        actions: [
          if (provider.pantry.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Tumunu temizle',
              onPressed: () => _showClearDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Malzeme Ekle',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Virgul ile ayirarak birden fazla ekleyebilirsiniz',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'ornek: domates, sogan, biber',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addIngredient(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _addIngredient,
                      icon: const Icon(Icons.add),
                      label: const Text('Ekle'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick add suggestions
          if (provider.pantry.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hizli Ekle:', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Tuz', 'Seker', 'Un', 'Yag', 'Sut',
                      'Yumurta', 'Pirinc', 'Makarna', 'Sogan',
                      'Sarimsak', 'Domates', 'Biber', 'Patates',
                      'Tereyagi', 'Peynir',
                    ].map((name) => ActionChip(
                          label: Text(name),
                          onPressed: () => provider.addIngredient(name),
                        ))
                    .toList(),
                  ),
                ],
              ),
            ),

          // Ingredients list
          Expanded(
            child: provider.pantry.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.kitchen,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Dolabiniz bos',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Yukaridaki alandan malzeme ekleyin',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.pantry.length,
                    itemBuilder: (context, index) {
                      final ingredient = provider.pantry[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.restaurant),
                          ),
                          title: Text(ingredient.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                provider.removeIngredient(ingredient.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Bottom info
          if (provider.pantry.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${provider.pantry.length} malzeme dolabinizda',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
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
        title: const Text('Dolabi Temizle'),
        content: const Text(
            'Tum malzemeler silinecek. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Iptal'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AppProvider>().clearPantry();
              Navigator.pop(ctx);
            },
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }
}

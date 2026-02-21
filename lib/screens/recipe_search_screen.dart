import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/recipe_card.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    context.read<AppProvider>().searchRecipe(query);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemek Ara'),
      ),
      body: Column(
        children: [
          // Search input
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
                  'Hangi yemegi yapmak istiyorsunuz?',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Yapay zeka tarifi bulacak ve eksik malzemeleri belirleyecek',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'ornek: Karniyarik, Mercimek Corbasi...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: provider.isLoading ? null : _search,
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            )
                          : const Text('Ara'),
                    ),
                  ],
                ),

                // Quick search suggestions
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Menemen',
                    'Karniyarik',
                    'Mercimek Corbasi',
                    'Mantarli Makarna',
                    'Omlet',
                    'Pilav',
                  ].map((dish) => ActionChip(
                        label: Text(dish, style: const TextStyle(fontSize: 12)),
                        onPressed: () {
                          _controller.text = dish;
                          _search();
                        },
                      ))
                  .toList(),
                ),
              ],
            ),
          ),

          // Pantry info
          if (provider.pantry.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
              child: Text(
                'Dolabinizda ${provider.pantry.length} malzeme var. '
                'Eksik malzemeler otomatik belirlenecek.',
                style: theme.textTheme.bodySmall,
              ),
            ),

          // Error
          if (provider.error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: theme.colorScheme.onErrorContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => provider.clearError(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Result
          Expanded(
            child: provider.searchedRecipe == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Aramak istediginiz yemegi yazin',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: RecipeCard(
                      recipe: provider.searchedRecipe!,
                      expanded: true,
                      onAddToShoppingList: () {
                        provider.addMissingToShoppingList(
                            provider.searchedRecipe!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Eksik malzemeler alisveris listesine eklendi'),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

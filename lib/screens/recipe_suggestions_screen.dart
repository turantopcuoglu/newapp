import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/recipe_card.dart';

class RecipeSuggestionsScreen extends StatelessWidget {
  const RecipeSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarif Oner'),
      ),
      body: Column(
        children: [
          // Pantry summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dolabinizdaki Malzemeler',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                if (provider.pantry.isEmpty)
                  Text(
                    'Dolabinizda malzeme yok. Once Dolabim\'dan malzeme ekleyin.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  )
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: provider.pantry
                        .map((i) => Chip(
                              label: Text(i.name,
                                  style: const TextStyle(fontSize: 12)),
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),

          // Get suggestions button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: provider.isLoading || provider.pantry.isEmpty
                    ? null
                    : () => provider.suggestRecipesFromPantry(),
                icon: provider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(provider.isLoading
                    ? 'Tarifler hazirlaniyor...'
                    : 'Yapay Zeka ile Tarif Oner'),
              ),
            ),
          ),

          // Error
          if (provider.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

          // Results
          Expanded(
            child: provider.suggestedRecipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Tarif onerileri burada gorunecek',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.suggestedRecipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(
                        recipe: provider.suggestedRecipes[index],
                        onAddToShoppingList: () {
                          provider.addMissingToShoppingList(
                              provider.suggestedRecipes[index]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Eksik malzemeler alisveris listesine eklendi'),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

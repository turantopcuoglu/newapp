import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'pantry_screen.dart';
import 'recipe_suggestions_screen.dart';
import 'recipe_search_screen.dart';
import 'shopping_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Yemek Tarifi'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // API Key Warning
            if (!provider.hasApiKey)
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber,
                          color: theme.colorScheme.onErrorContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Claude API anahtari ayarlanmadi. '
                          'Ayarlar\'dan API anahtarinizi girin.',
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (!provider.hasApiKey) const SizedBox(height: 16),

            // Pantry summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.kitchen, color: theme.colorScheme.primary,
                        size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dolabim',
                              style: theme.textTheme.titleMedium),
                          Text(
                            provider.pantry.isEmpty
                                ? 'Henuz malzeme eklenmedi'
                                : '${provider.pantry.length} malzeme mevcut',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (provider.pantry.isNotEmpty)
                      Chip(
                        label: Text('${provider.pantry.length}'),
                        backgroundColor: theme.colorScheme.primaryContainer,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Main menu cards
            _MenuCard(
              icon: Icons.kitchen,
              title: 'Dolabim',
              subtitle: 'Evdeki malzemeleri yonet',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantryScreen()),
              ),
            ),

            const SizedBox(height: 12),

            _MenuCard(
              icon: Icons.auto_awesome,
              title: 'Tarif Oner',
              subtitle: 'Eldeki malzemelerle ne yapabilirim?',
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RecipeSuggestionsScreen()),
              ),
            ),

            const SizedBox(height: 12),

            _MenuCard(
              icon: Icons.search,
              title: 'Yemek Ara',
              subtitle: 'Bir yemek tarifi ara, eksikleri bul',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RecipeSearchScreen()),
              ),
            ),

            const SizedBox(height: 12),

            _MenuCard(
              icon: Icons.shopping_cart,
              title: 'Alisveris Listesi',
              subtitle: provider.shoppingList.isEmpty
                  ? 'Liste bos'
                  : '${provider.shoppingList.length} urun',
              color: Colors.purple,
              badge: provider.shoppingList.isEmpty
                  ? null
                  : provider.shoppingList.length,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ShoppingListScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final int? badge;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (badge != null)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color,
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12),
                  ),
                ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

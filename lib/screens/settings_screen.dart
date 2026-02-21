import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    final apiKey = context.read<AppProvider>().apiKey;
    if (apiKey != null) {
      _apiKeyController.text = apiKey;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Key Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.key, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Claude API Anahtari',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Yapay zeka ozelliklerini kullanmak icin Anthropic API '
                      'anahtarinizi girin. Anahtarinizi console.anthropic.com '
                      'adresinden alabilirsiniz.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiKeyController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'sk-ant-...',
                        border: const OutlineInputBorder(),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () =>
                                  setState(() => _obscureText = !_obscureText),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              final key = _apiKeyController.text.trim();
                              if (key.isEmpty) return;
                              provider.setApiKey(key);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('API anahtari kaydedildi')),
                              );
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('Kaydet'),
                          ),
                        ),
                        if (provider.hasApiKey) ...[
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              provider.removeApiKey();
                              _apiKeyController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('API anahtari silindi')),
                              );
                            },
                            child: const Text('Sil'),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Status indicator
                    Row(
                      children: [
                        Icon(
                          provider.hasApiKey
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 16,
                          color: provider.hasApiKey
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          provider.hasApiKey
                              ? 'API anahtari ayarli'
                              : 'API anahtari ayarli degil',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: provider.hasApiKey
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Data management
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storage,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Veri Yonetimi',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.kitchen),
                      title: const Text('Dolabimdaki Malzemeler'),
                      subtitle: Text('${provider.pantry.length} malzeme'),
                      trailing: TextButton(
                        onPressed: provider.pantry.isEmpty
                            ? null
                            : () => _showClearDialog(
                                  context,
                                  'Dolabi Temizle',
                                  'Tum malzemeler silinecek.',
                                  () => provider.clearPantry(),
                                ),
                        child: const Text('Temizle'),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('Alisveris Listesi'),
                      subtitle:
                          Text('${provider.shoppingList.length} urun'),
                      trailing: TextButton(
                        onPressed: provider.shoppingList.isEmpty
                            ? null
                            : () => _showClearDialog(
                                  context,
                                  'Listeyi Temizle',
                                  'Tum alisveris listesi silinecek.',
                                  () => provider.clearShoppingList(),
                                ),
                        child: const Text('Temizle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Hakkinda',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'AI Yemek Tarifi v1.0\n\n'
                      'Bu uygulama Claude AI kullanarak evinizdeki '
                      'malzemelerle yapabilecginiz tarifleri onerir. '
                      'Ayrica belirli bir yemek tarifi arayabilir ve '
                      'eksik malzemelerinizi belirleyebilirsiniz.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Iptal'),
          ),
          FilledButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(ctx);
            },
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }
}

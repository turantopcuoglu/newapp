import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' hide Provider;
import '../core/theme.dart';
import '../data/mock_ingredients.dart';
import '../l10n/app_localizations.dart';
import '../models/ingredient.dart';
import '../providers/app_provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/shopping_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureText = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final apiKey = context.read<AppProvider>().apiKey;
    if (apiKey != null && _apiKeyController.text.isEmpty) {
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

    // Use Riverpod providers for live data
    final inventoryItems = ref.watch(inventoryProvider);
    final shoppingItems = ref.watch(shoppingProvider);

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
                      subtitle:
                          Text('${inventoryItems.length} malzeme'),
                      trailing: TextButton(
                        onPressed: inventoryItems.isEmpty
                            ? null
                            : () => _showClearDialog(
                                  context,
                                  'Dolabi Temizle',
                                  'Tum malzemeler silinecek.',
                                  () => ref
                                      .read(inventoryProvider.notifier)
                                      .clear(),
                                ),
                        child: const Text('Temizle'),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('Alisveris Listesi'),
                      subtitle:
                          Text('${shoppingItems.length} urun'),
                      trailing: TextButton(
                        onPressed: shoppingItems.isEmpty
                            ? null
                            : () => _showClearDialog(
                                  context,
                                  'Listeyi Temizle',
                                  'Tum alisveris listesi silinecek.',
                                  () => ref
                                      .read(shoppingProvider.notifier)
                                      .clearAll(),
                                ),
                        child: const Text('Temizle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Allergies & Avoided Foods
            _AllergyDislikedSection(ref: ref),

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

// ─── Allergy & Disliked Ingredients Section ─────────────────────────────────

/// All known allergen tags used in the ingredient database.
const Map<String, Map<String, String>> _allergenLabels = {
  'gluten': {'en': 'Gluten', 'tr': 'Gluten'},
  'dairy': {'en': 'Dairy / Lactose', 'tr': 'Süt Ürünleri / Laktoz'},
  'eggs': {'en': 'Eggs', 'tr': 'Yumurta'},
  'nuts': {'en': 'Tree Nuts', 'tr': 'Kabuklu Yemişler'},
  'peanuts': {'en': 'Peanuts', 'tr': 'Yer Fıstığı'},
  'fish': {'en': 'Fish', 'tr': 'Balık'},
  'shellfish': {'en': 'Shellfish', 'tr': 'Kabuklu Deniz Ürünleri'},
  'soy': {'en': 'Soy', 'tr': 'Soya'},
  'sesame': {'en': 'Sesame', 'tr': 'Susam'},
};

class _AllergyDislikedSection extends StatelessWidget {
  final WidgetRef ref;

  const _AllergyDislikedSection({required this.ref});

  static final Map<String, Ingredient> _ingredientMap = {
    for (final i in mockIngredients) i.id: i,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Row(
              children: [
                Icon(Icons.health_and_safety_rounded,
                    color: AppTheme.warmCoral),
                const SizedBox(width: 8),
                Text(l10n.profileAllergiesAndAvoided,
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.profileAllergiesHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Allergens sub-section
            Text(
              l10n.profileAllergies,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.warmCoral,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allergenLabels.entries.map((entry) {
                final isActive = profile.allergies.contains(entry.key);
                return FilterChip(
                  label: Text(
                    entry.value[locale] ?? entry.value['en']!,
                  ),
                  selected: isActive,
                  onSelected: (selected) {
                    final notifier = ref.read(profileProvider.notifier);
                    if (selected) {
                      notifier.addAllergy(entry.key);
                    } else {
                      notifier.removeAllergy(entry.key);
                    }
                  },
                  selectedColor: AppTheme.warmCoral.withAlpha(40),
                  checkmarkColor: AppTheme.warmCoral,
                  labelStyle: TextStyle(
                    color: isActive
                        ? AppTheme.warmCoral
                        : AppTheme.textSecondary,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isActive
                        ? AppTheme.warmCoral.withAlpha(100)
                        : AppTheme.dividerColor,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Disliked ingredients sub-section
            Row(
              children: [
                Text(
                  l10n.profileDisliked,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.softLavender,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showAddDislikedSheet(context, locale),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded,
                          size: 16, color: AppTheme.softLavender),
                      const SizedBox(width: 2),
                      Text(
                        l10n.add,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.softLavender,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (profile.dislikedIngredients.isEmpty)
              Text(
                l10n.profileNoDisliked,
                style: theme.textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.dislikedIngredients.map((id) {
                  final ingredient = _ingredientMap[id];
                  final label = ingredient?.localizedName(locale) ?? id;
                  return Chip(
                    label: Text(label),
                    deleteIcon: const Icon(Icons.close_rounded, size: 16),
                    onDeleted: () {
                      ref
                          .read(profileProvider.notifier)
                          .removeDislikedIngredient(id);
                    },
                    backgroundColor: AppTheme.softLavender.withAlpha(20),
                    deleteIconColor: AppTheme.softLavender,
                    labelStyle: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                    ),
                    side: BorderSide(
                      color: AppTheme.softLavender.withAlpha(60),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddDislikedSheet(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddDislikedIngredientSheet(
        ref: ref,
        locale: locale,
        l10n: l10n,
      ),
    );
  }
}

class _AddDislikedIngredientSheet extends StatefulWidget {
  final WidgetRef ref;
  final String locale;
  final AppLocalizations l10n;

  const _AddDislikedIngredientSheet({
    required this.ref,
    required this.locale,
    required this.l10n,
  });

  @override
  State<_AddDislikedIngredientSheet> createState() =>
      _AddDislikedIngredientSheetState();
}

class _AddDislikedIngredientSheetState
    extends State<_AddDislikedIngredientSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final profile = widget.ref.watch(profileProvider);
    final dislikedSet = profile.dislikedIngredients.toSet();

    final filtered = mockIngredients.where((i) {
      if (dislikedSet.contains(i.id)) return false;
      if (_search.isEmpty) return true;
      final name = i.localizedName(widget.locale).toLowerCase();
      return name.contains(_search.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: widget.l10n.inventorySearch,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final ingredient = filtered[index];
                return ListTile(
                  title: Text(ingredient.localizedName(widget.locale)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    color: AppTheme.softLavender,
                    onPressed: () {
                      widget.ref
                          .read(profileProvider.notifier)
                          .addDislikedIngredient(ingredient.id);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

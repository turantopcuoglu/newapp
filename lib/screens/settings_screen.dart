import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../core/turkish_string_helper.dart';
import '../data/mock_ingredients.dart';
import '../widgets/turkish_text_field.dart';
import '../l10n/app_localizations.dart';
import '../models/ingredient.dart';
import '../models/shopping_item.dart';
import '../providers/inventory_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/shopping_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        Text('Veri Yönetimi',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.kitchen),
                      title: const Text('Dolabımdaki Malzemeler'),
                      subtitle: Text('${inventoryItems.length} malzeme'),
                      onTap: () => _showInventoryItemsSheet(
                        context,
                        inventoryItems,
                      ),
                      trailing: TextButton(
                        onPressed: inventoryItems.isEmpty
                            ? null
                            : () => _showClearDialog(
                                  context,
                                  'Dolabı Temizle',
                                  'Tüm malzemeler silinecek.',
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
                      title: const Text('Alışveriş Listesi'),
                      subtitle: Text('${shoppingItems.length} ürün'),
                      onTap: () => _showShoppingItemsSheet(
                        context,
                        shoppingItems,
                      ),
                      trailing: TextButton(
                        onPressed: shoppingItems.isEmpty
                            ? null
                            : () => _showClearDialog(
                                  context,
                                  'Listeyi Temizle',
                                  'Tüm alışveriş listesi silinecek.',
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

            // Body metrics & BMI
            _BodyMetricsSection(ref: ref),

            const SizedBox(height: 16),

            // Allergies & Avoided Foods
            _AllergyDislikedSection(ref: ref),

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
            child: const Text('İptal'),
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

  void _showInventoryItemsSheet(
    BuildContext context,
    List<InventoryItem> inventoryItems,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final ingredientMap = {
      for (final ingredient in mockIngredients) ingredient.id: ingredient,
    };

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.7,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.kitchen),
                title: const Text('Dolabımdaki Malzemeler'),
                subtitle: Text('${inventoryItems.length} malzeme'),
              ),
              const Divider(height: 1),
              Expanded(
                child: inventoryItems.isEmpty
                    ? const Center(
                        child: Text('Dolabınızda malzeme bulunmuyor.'),
                      )
                    : ListView.separated(
                        itemCount: inventoryItems.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, index) {
                          final ingredientId =
                              inventoryItems[index].ingredientId;
                          final ingredient = ingredientMap[ingredientId];
                          final ingredientName =
                              ingredient?.localizedName(locale) ?? ingredientId;

                          return ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: Text(turkishTitleCase(ingredientName)),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShoppingItemsSheet(
    BuildContext context,
    List<ShoppingItem> shoppingItems,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.7,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Alışveriş Listesi'),
                subtitle: Text('${shoppingItems.length} ürün'),
              ),
              const Divider(height: 1),
              Expanded(
                child: shoppingItems.isEmpty
                    ? const Center(
                        child: Text('Alışveriş listenizde ürün bulunmuyor.'),
                      )
                    : ListView.separated(
                        itemCount: shoppingItems.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, index) {
                          final item = shoppingItems[index];
                          return ListTile(
                            leading: Icon(
                              item.isPurchased
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: item.isPurchased
                                  ? Colors.green
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            title: Text(
                              turkishTitleCase(item.name),
                              style: TextStyle(
                                decoration: item.isPurchased
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Body Metrics & BMI Section ──────────────────────────────────────────────

class _BodyMetricsSection extends StatefulWidget {
  final WidgetRef ref;

  const _BodyMetricsSection({required this.ref});

  @override
  State<_BodyMetricsSection> createState() => _BodyMetricsSectionState();
}

class _BodyMetricsSectionState extends State<_BodyMetricsSection> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    final profile = widget.ref.read(profileProvider);
    _heightController = TextEditingController(
      text: profile.height != null ? profile.height!.toStringAsFixed(0) : '',
    );
    _weightController = TextEditingController(
      text: profile.weight != null ? profile.weight!.toStringAsFixed(1) : '',
    );
    _ageController = TextEditingController(
      text: profile.age != null ? profile.age.toString() : '',
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String _bmiCategory(double bmi, AppLocalizations l10n) {
    if (bmi < 18.5) return l10n.profileBmiUnderweight;
    if (bmi < 25) return l10n.profileBmiNormal;
    if (bmi < 30) return l10n.profileBmiOverweight;
    return l10n.profileBmiObese;
  }

  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return AppTheme.accentTeal;
    if (bmi < 25) return AppTheme.successGreen;
    if (bmi < 30) return AppTheme.accentOrange;
    return AppTheme.warmCoral;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = widget.ref.watch(profileProvider);
    final notifier = widget.ref.read(profileProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Row(
              children: [
                Icon(Icons.straighten_rounded,
                    color: AppTheme.accentTeal),
                const SizedBox(width: 8),
                Text(l10n.profileBodyMetrics,
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.profileBodyMetricsHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Height, Weight, Age inputs in a row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    decoration: InputDecoration(
                      labelText: l10n.profileHeight,
                      labelStyle:
                          const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        notifier.updateHeight(parsed);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.profileWeight,
                      labelStyle:
                          const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        notifier.updateWeight(parsed);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 72,
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.profileAge,
                      labelStyle:
                          const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        notifier.updateAge(parsed);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Show BMI toggle
            Row(
              children: [
                Text(
                  l10n.profileShowBmi,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: profile.showBmi,
                  activeColor: AppTheme.accentTeal,
                  onChanged: (value) => notifier.updateShowBmi(value),
                ),
              ],
            ),

            // BMI display
            if (profile.showBmi) ...[
              const Divider(),
              const SizedBox(height: 8),
              if (profile.bmi != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _bmiColor(profile.bmi!).withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _bmiColor(profile.bmi!).withAlpha(60),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${l10n.profileBmi}: ',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            profile.bmi!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _bmiColor(profile.bmi!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${l10n.profileBmiCategory}: ',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            _bmiCategory(profile.bmi!, l10n),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _bmiColor(profile.bmi!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Text(
                  l10n.profileBmiNeedData,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ],
        ),
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
      final name = i.localizedName(widget.locale);
      return TurkishStringHelper.containsTr(name, _search);
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
            child: TurkishTextField(
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

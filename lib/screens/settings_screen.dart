import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../core/theme.dart';
import '../core/turkish_string_helper.dart';
import '../data/mock_ingredients.dart';
import '../widgets/turkish_text_field.dart';
import '../l10n/app_localizations.dart';
import '../models/ingredient.dart';
import '../providers/inventory_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/shopping_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileSettings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data management
            _DataManagementSection(ref: ref),

            const SizedBox(height: 16),

            // Personal info (Gender, Age, BMI)
            _PersonalInfoSection(ref: ref),

            const SizedBox(height: 16),

            // Body metrics (Height, Weight)
            _BodyMetricsSection(ref: ref),

            const SizedBox(height: 16),

            // Allergies & Avoided Foods
            _AllergyDislikedSection(ref: ref),

            const SizedBox(height: 16),

            // Language
            _LanguageSection(ref: ref),
          ],
        ),
      ),
    );
  }
}

// ─── Data Management Section ────────────────────────────────────────────────

class _DataManagementSection extends StatelessWidget {
  final WidgetRef ref;

  const _DataManagementSection({required this.ref});

  static final Map<String, Ingredient> _ingredientMap = {
    for (final i in mockIngredients) i.id: i,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;
    final theme = Theme.of(context);
    final inventoryItems = ref.watch(inventoryProvider);
    final shoppingItems = ref.watch(shoppingProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.profileDataManagement,
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.kitchen),
              title: Text(l10n.profilePantryItems),
              subtitle: Text(l10n.profileItemCount(inventoryItems.length)),
              trailing: TextButton(
                onPressed: inventoryItems.isEmpty
                    ? null
                    : () => _showClearDialog(
                          context,
                          l10n.profileClearPantryTitle,
                          l10n.profileClearPantryMsg,
                          () => ref.read(inventoryProvider.notifier).clear(),
                        ),
                child: Text(l10n.profileClear),
              ),
              onTap: () => _showPantryItemsSheet(context, locale, l10n),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(l10n.profileShoppingList),
              subtitle: Text(l10n.profileProductCount(shoppingItems.length)),
              trailing: TextButton(
                onPressed: shoppingItems.isEmpty
                    ? null
                    : () => _showClearDialog(
                          context,
                          l10n.profileClearShoppingTitle,
                          l10n.profileClearShoppingMsg,
                          () => ref.read(shoppingProvider.notifier).clearAll(),
                        ),
                child: Text(l10n.profileClear),
              ),
              onTap: () => _showShoppingItemsSheet(context, l10n),
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(ctx);
            },
            child: Text(l10n.profileClear),
          ),
        ],
      ),
    );
  }

  void _showPantryItemsSheet(
      BuildContext context, String locale, AppLocalizations l10n) {
    final inventoryItems = ref.read(inventoryProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
              child: Row(
                children: [
                  const Icon(Icons.kitchen, color: AppTheme.accentTeal),
                  const SizedBox(width: 8),
                  Text(
                    l10n.profilePantryItems,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.profileItemCount(inventoryItems.length),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: inventoryItems.isEmpty
                  ? Center(
                      child: Text(
                        l10n.profileEmptyPantry,
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: inventoryItems.length,
                      itemBuilder: (context, index) {
                        final item = inventoryItems[index];
                        final ingredient =
                            _ingredientMap[item.ingredientId];
                        final name =
                            ingredient?.localizedName(locale) ??
                                item.ingredientId;
                        return ListTile(
                          leading: const Icon(Icons.circle,
                              size: 8, color: AppTheme.accentTeal),
                          title: Text(name),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShoppingItemsSheet(BuildContext context, AppLocalizations l10n) {
    final shoppingItems = ref.read(shoppingProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart,
                      color: AppTheme.accentOrange),
                  const SizedBox(width: 8),
                  Text(
                    l10n.profileShoppingList,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    l10n.profileProductCount(shoppingItems.length),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: shoppingItems.isEmpty
                  ? Center(
                      child: Text(
                        l10n.profileEmptyShopping,
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: shoppingItems.length,
                      itemBuilder: (context, index) {
                        final item = shoppingItems[index];
                        return ListTile(
                          leading: Icon(
                            item.isPurchased
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 20,
                            color: item.isPurchased
                                ? AppTheme.successGreen
                                : AppTheme.accentOrange,
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isPurchased
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isPurchased
                                  ? AppTheme.textSecondary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Personal Info Section (Gender, Age, BMI) ───────────────────────────────

class _PersonalInfoSection extends StatefulWidget {
  final WidgetRef ref;

  const _PersonalInfoSection({required this.ref});

  @override
  State<_PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<_PersonalInfoSection> {
  String _genderLabel(Gender gender, AppLocalizations l10n) {
    switch (gender) {
      case Gender.male:
        return l10n.profileGenderMale;
      case Gender.female:
        return l10n.profileGenderFemale;
      case Gender.other:
        return l10n.profileGenderOther;
    }
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
            Row(
              children: [
                Icon(Icons.person_rounded, color: AppTheme.accentOrange),
                const SizedBox(width: 8),
                Text(l10n.profilePersonalInfo,
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.profilePersonalInfoHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.profileGender,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Gender.values.map((gender) {
                final isSelected = profile.gender == gender;
                return ChoiceChip(
                  label: Text(_genderLabel(gender, l10n)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      notifier.updateGender(gender);
                    }
                  },
                  selectedColor: AppTheme.accentOrange.withAlpha(40),
                  checkmarkColor: AppTheme.accentOrange,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppTheme.accentOrange
                        : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.accentOrange.withAlpha(100)
                        : AppTheme.dividerColor,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyMetricsSection extends StatefulWidget {
  final WidgetRef ref;

  const _BodyMetricsSection({required this.ref});

  @override
  State<_BodyMetricsSection> createState() => _BodyMetricsSectionState();
}

class _BodyMetricsSectionState extends State<_BodyMetricsSection> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;

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
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
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
            Row(
              children: [
                Icon(Icons.straighten_rounded, color: AppTheme.accentTeal),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    decoration: InputDecoration(
                      labelText: l10n.profileHeight,
                      labelStyle: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
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
                      labelStyle: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary),
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
              ],
            ),
            const SizedBox(height: 16),
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

            // Allergens sub-section with +ekle button
            Row(
              children: [
                Text(
                  l10n.profileAllergies,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warmCoral,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showAddAllergenSheet(context, locale),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded,
                          size: 16, color: AppTheme.warmCoral),
                      const SizedBox(width: 2),
                      Text(
                        l10n.add,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.warmCoral,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (profile.allergies.isEmpty)
              Text(
                l10n.profileNoAllergies,
                style: theme.textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.allergies.map((tag) {
                  final label =
                      _allergenLabels[tag]?[locale] ??
                      _allergenLabels[tag]?['en'] ??
                      tag;
                  return Chip(
                    label: Text(label),
                    deleteIcon:
                        const Icon(Icons.close_rounded, size: 16),
                    onDeleted: () {
                      ref
                          .read(profileProvider.notifier)
                          .removeAllergy(tag);
                    },
                    backgroundColor:
                        AppTheme.warmCoral.withAlpha(20),
                    deleteIconColor: AppTheme.warmCoral,
                    labelStyle: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                    ),
                    side: BorderSide(
                      color: AppTheme.warmCoral.withAlpha(60),
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

  void _showAddAllergenSheet(BuildContext context, String locale) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAllergenSheet(
        ref: ref,
        locale: locale,
        l10n: l10n,
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

// ─── Add Allergen Bottom Sheet ──────────────────────────────────────────────

class _AddAllergenSheet extends StatelessWidget {
  final WidgetRef ref;
  final String locale;
  final AppLocalizations l10n;

  const _AddAllergenSheet({
    required this.ref,
    required this.locale,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final currentAllergies = profile.allergies.toSet();

    final available = _allergenLabels.entries
        .where((e) => !currentAllergies.contains(e.key))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
            child: Row(
              children: [
                const Icon(Icons.health_and_safety_rounded,
                    color: AppTheme.warmCoral),
                const SizedBox(width: 8),
                Text(
                  l10n.profileSelectAllergen,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: available.isEmpty
                ? Center(
                    child: Text(
                      l10n.profileNoAllergies,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    itemCount: available.length,
                    itemBuilder: (context, index) {
                      final entry = available[index];
                      final label =
                          entry.value[locale] ?? entry.value['en']!;
                      return ListTile(
                        title: Text(label),
                        trailing: IconButton(
                          icon: const Icon(
                              Icons.add_circle_outline_rounded),
                          color: AppTheme.warmCoral,
                          onPressed: () {
                            ref
                                .read(profileProvider.notifier)
                                .addAllergy(entry.key);
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

// ─── Add Disliked Ingredient Bottom Sheet ───────────────────────────────────

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

// ─── Language Section ───────────────────────────────────────────────────────

class _LanguageSection extends StatelessWidget {
  final WidgetRef ref;

  const _LanguageSection({required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language_rounded, color: AppTheme.softLavender),
                const SizedBox(width: 8),
                Text(l10n.profileLanguage,
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.profileLanguageTurkish),
                  selected: currentLocale.languageCode == 'tr',
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(localeProvider.notifier).setLocale('tr');
                    }
                  },
                  selectedColor: AppTheme.softLavender.withAlpha(40),
                  checkmarkColor: AppTheme.softLavender,
                  labelStyle: TextStyle(
                    color: currentLocale.languageCode == 'tr'
                        ? AppTheme.softLavender
                        : AppTheme.textSecondary,
                    fontWeight: currentLocale.languageCode == 'tr'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: currentLocale.languageCode == 'tr'
                        ? AppTheme.softLavender.withAlpha(100)
                        : AppTheme.dividerColor,
                  ),
                ),
                ChoiceChip(
                  label: Text(l10n.profileLanguageEnglish),
                  selected: currentLocale.languageCode == 'en',
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(localeProvider.notifier).setLocale('en');
                    }
                  },
                  selectedColor: AppTheme.softLavender.withAlpha(40),
                  checkmarkColor: AppTheme.softLavender,
                  labelStyle: TextStyle(
                    color: currentLocale.languageCode == 'en'
                        ? AppTheme.softLavender
                        : AppTheme.textSecondary,
                    fontWeight: currentLocale.languageCode == 'en'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: currentLocale.languageCode == 'en'
                        ? AppTheme.softLavender.withAlpha(100)
                        : AppTheme.dividerColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
